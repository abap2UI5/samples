CLASS z2ui5_cl_demo_app_306 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_picture,
        time     TYPE string,
        id       TYPE string,
        name     TYPE string,
        data     TYPE string,
        selected TYPE abap_bool,
      END OF ty_picture.

    TYPES:
      BEGIN OF t_combo,
        key  TYPE string,
        text TYPE string,
      END OF t_combo,
      tt_combo TYPE STANDARD TABLE OF t_combo WITH EMPTY KEY.


    DATA mt_picture TYPE STANDARD TABLE OF ty_picture WITH EMPTY KEY.
    DATA mt_picture_out TYPE STANDARD TABLE OF ty_picture WITH EMPTY KEY.
    DATA mv_pic_display TYPE string.
    DATA mv_check_init TYPE abap_bool.
    DATA mv_picture_base TYPE string.
    DATA facing_mode TYPE string.
    DATA facing_modes TYPE tt_combo.
    DATA device TYPE string.
    DATA devices TYPE tt_combo.

  PROTECTED SECTION.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_306 IMPLEMENTATION.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(cont) = view->shell( ).
    DATA(page) = cont->page( title = 'abap2UI5 - Device Camera Picture'
               navbuttonpress      = client->_event( 'BACK' )
               shownavbutton       = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->vbox( class = `sapUiSmallMargin`
       )->label( text = `facingMode: ` labelfor = `ComboFacingMode`
       )->combobox( id = `ComboFacingMode` selectedkey = client->_bind_edit( facing_mode )
                    items = `{path:'` && client->_bind_edit( val = facing_modes  path = abap_true ) && `', sorter: { path: 'TEXT' } }`
       )->get( )->item( key = `{KEY}` text = `{TEXT}` ).

    page->vbox( class = `sapUiSmallMargin`
       )->label( text = `device: ` labelfor = `ComboDevice`
       )->_z2ui5( )->camera_selector(
                    id = `ComboDevice`
                    selectedkey = client->_bind_edit( device )
                    items = `{path:'` && client->_bind_edit( val = devices  path = abap_true ) && `', sorter: { path: 'TEXT' } }`
       )->get( )->item( key = `{KEY}` text = `{TEXT}` ).

    page->_z2ui5( )->camera_picture(
                      value   = client->_bind_edit( mv_picture_base )
                      onphoto = client->_event( 'CAPTURE' )
                      facingmode = client->_bind_edit( facing_mode )
                      deviceid = client->_bind_edit( device ) ).

    page->list(
        headertext      = 'List Ouput'
        items           = client->_bind_edit( mt_picture_out )
        mode            = `SingleSelectMaster`
        selectionchange = client->_event( 'DISPLAY' )
        )->standard_list_item(
            title       = '{NAME}'
            description = '{NAME}'
            icon        = '{ICON}'
            info        = '{INFO}'
            selected    = `{SELECTED}` ).

    IF mv_pic_display IS NOT INITIAL.
      page->_generic( ns   = 'html'
                      name = 'center'
        )->_generic( ns     = 'html'
                     name   = 'img'
                     t_prop = VALUE #(
        (  n = 'src'  v = mv_pic_display )
        ) ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF mv_check_init = abap_false.

      mv_check_init = abap_true.

      facing_modes = VALUE tt_combo( ( key = `` text = `` )
                                     ( key = `environment` text = `environment` )
                                     ( key = `user` text = `user` )
                                     ( key = `left` text = `left` )
                                     ( key = `right` text = `right` ) ).

      view_display( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'CAPTURE'.
        INSERT VALUE #( data = mv_picture_base time = sy-uzeit ) INTO TABLE mt_picture.
        CLEAR mv_picture_base.
        client->view_model_update( ).

      WHEN 'START'.


      WHEN 'DISPLAY'.
        DATA(lt_sel) = mt_picture_out.
        DELETE lt_sel WHERE selected = abap_false.
        DATA(ls_sel) = lt_sel[ 1 ].
        mv_pic_display = mt_picture[ ls_sel-id ]-data.
        view_display( client ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    mt_picture_out = VALUE #( ).
    LOOP AT mt_picture INTO DATA(ls_pic).
      INSERT VALUE #( name = `picture ` && sy-tabix id = sy-tabix ) INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
