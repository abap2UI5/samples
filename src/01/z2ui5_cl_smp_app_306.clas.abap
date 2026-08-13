CLASS z2ui5_cl_smp_app_306 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_picture,
        time      TYPE string,
        id        TYPE string,
        name      TYPE string,
        data      TYPE string,    " full resolution - backend only
        thumbnail TYPE string,    " small preview - used in model
        selected  TYPE abap_bool,
      END OF ty_s_picture.

    TYPES:
      BEGIN OF ty_s_combo,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_combo,
      tt_combo TYPE STANDARD TABLE OF ty_s_combo WITH EMPTY KEY.

    DATA mt_picture       TYPE STANDARD TABLE OF ty_s_picture WITH EMPTY KEY.
    DATA mt_picture_out   TYPE STANDARD TABLE OF ty_s_picture WITH EMPTY KEY.
    DATA mv_pic_display   TYPE string.
    DATA mv_picture_base  TYPE string.
    DATA mv_picture_thumb TYPE string.
    DATA facing_mode      TYPE string.
    DATA facing_modes     TYPE tt_combo.
    DATA device           TYPE string.
    DATA devices          TYPE tt_combo.

  PROTECTED SECTION.
    DATA selected_picture TYPE ty_s_picture.
    DATA client           TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS rebuild_output.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_306 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      facing_modes = VALUE tt_combo( ( key = `` text = `` )
                                     ( key = `environment` text = `environment` )
                                     ( key = `user` text = `user` )
                                     ( key = `left` text = `left` )
                                     ( key = `right` text = `right` ) ).

      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(cont) = view->shell( ).
    DATA(page) = cont->page( title          = `abap2UI5 - Device - Camera, Take Photos`
                             navbuttonpress = client->_event_nav_app_leave( )
                             shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Capture photos from the device camera custom control; pick the facing mode and camera, then select ` &&
                   `a captured picture from the list to display it in full resolution.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
       )->label( text     = `facingMode: `
                 labelfor = `ComboFacingMode`
       )->combobox( id          = `ComboFacingMode`
                    selectedkey = client->_bind( facing_mode )
                    items       = |\{path:'{ client->_bind( val  = facing_modes
                    path        = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|
       )->get( )->item( key  = `{KEY}`
                        text = `{TEXT}` ).

    page->vbox( `sapUiSmallMargin`
       )->label( text     = `device: `
                 labelfor = `ComboDevice`
       )->_z2ui5( )->camera_selector(
           id          = `ComboDevice`
           selectedkey = client->_bind( device )
           items       = |\{path:'{ client->_bind( val  = devices
           path        = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|
       )->get( )->item( key  = `{KEY}`
                        text = `{TEXT}` ).

    page->_z2ui5( )->camera_picture( value      = client->_bind( mv_picture_base )
                                     thumbnail  = client->_bind( mv_picture_thumb )
                                     onphoto    = client->_event( `CAPTURE` )
                                     facingmode = client->_bind( facing_mode )
                                     deviceid   = client->_bind( device ) ).

    DATA(lo_list) = page->list(
                                headertext      = `List Output`
                                items           = client->_bind( mt_picture_out )
                                mode            = `SingleSelectMaster`
                                selectionchange = client->_event( `DISPLAY` ) ).

    DATA(lo_item) = lo_list->_generic( name   = `CustomListItem`
                                       t_prop = VALUE #( ( n = `selected` v = `{SELECTED}` ) ) ).

    DATA(lo_hbox) = lo_item->hbox( alignitems = `Center` ).
    lo_hbox->image( src    = `{THUMBNAIL}`
                    height = `80px` ).
    lo_hbox->text( `{NAME}` ).

    IF mv_pic_display IS NOT INITIAL.
      page->image( src    = client->_bind( mv_pic_display )
                   height = `200px`
                   class  = `sapUiSmallMargin` ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `CAPTURE`.

        INSERT VALUE #( data      = mv_picture_base
                        thumbnail = mv_picture_thumb
                        time      = sy-uzeit ) INTO TABLE mt_picture.
        mv_picture_base  = VALUE #( ).
        mv_picture_thumb = VALUE #( ).
        rebuild_output( ).

      WHEN `DISPLAY`.

        selected_picture = mt_picture_out[ selected = abap_true ].
        mv_pic_display   = mt_picture[ selected_picture-id ]-data.
        rebuild_output( ).
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD rebuild_output.

    mt_picture_out = VALUE #( ).
    LOOP AT mt_picture INTO DATA(ls_pic).
      INSERT VALUE #( name      = |picture { sy-tabix }|
                      id        = sy-tabix
                      thumbnail = ls_pic-thumbnail
                      selected  = COND #( WHEN sy-tabix = selected_picture-id
                                          THEN abap_true ) )
             INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
