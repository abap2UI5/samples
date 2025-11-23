CLASS z2ui5_cl_demo_app_306 DEFINITION
  PUBLIC
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


    DATA:
      mt_picture      TYPE STANDARD TABLE OF ty_picture WITH EMPTY KEY,
      mt_picture_out  TYPE STANDARD TABLE OF ty_picture WITH EMPTY KEY,
      mv_pic_display  TYPE string,
      mv_check_init   TYPE abap_bool,
      mv_picture_base TYPE string,
      facing_mode     TYPE string,
      facing_modes    TYPE tt_combo,
      device          TYPE string,
      devices         TYPE tt_combo.

  PROTECTED SECTION.

    METHODS view_display.
    METHODS edit_image.
    METHODS ui5_callback.

    DATA selected_picture TYPE ty_picture.
    DATA client TYPE REF TO z2ui5_if_client.

ENDCLASS.



CLASS z2ui5_cl_demo_app_306 IMPLEMENTATION.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(cont) = view->shell( ).
    DATA(page) = cont->page( title = 'abap2UI5 - Device Camera Picture'
                   navbuttonpress = client->_event( 'BACK' )
                   shownavbutton  = client->check_app_prev_stack( ) ).

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
                      value      = client->_bind_edit( mv_picture_base )
                      onphoto    = client->_event( 'CAPTURE' )
                      facingmode = client->_bind_edit( facing_mode )
                      deviceid   = client->_bind_edit( device ) ).

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
                        ( n = 'src'  v = mv_pic_display )
         ) ).

      page->button( text = 'Edit' icon = 'sap-icon://edit' press = client->_event( 'EDIT' ) ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF me->z2ui5_if_app~check_initialized = abap_false.
      facing_modes = VALUE tt_combo( ( key = `` text = `` )
                                     ( key = `environment` text = `environment` )
                                     ( key = `user` text = `user` )
                                     ( key = `left` text = `left` )
                                     ( key = `right` text = `right` ) ).

      view_display( ).
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_callback( ).
      view_display( ).
      RETURN.
    ENDIF.


    CASE client->get( )-event.

      WHEN 'CAPTURE'.
        INSERT VALUE #( data = mv_picture_base time = sy-uzeit ) INTO TABLE mt_picture.
        CLEAR mv_picture_base.
        client->view_model_update( ).

      WHEN 'DISPLAY'.

        selected_picture = mt_picture_out[ selected = abap_true ].
        mv_pic_display = mt_picture[ selected_picture-id ]-data.
        view_display( ).

      WHEN 'EDIT'.

        edit_image( ).

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    mt_picture_out = VALUE #( ).
    LOOP AT mt_picture INTO DATA(ls_pic).
      INSERT VALUE #( name = `picture ` && sy-tabix id = sy-tabix ) INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.

  METHOD edit_image.

    client->nav_app_call( z2ui5_cl_pop_image_editor=>factory( mv_pic_display ) ).

  ENDMETHOD.


  METHOD ui5_callback.

    TRY.
        DATA(lo_prev) = client->get_app( client->get( )-s_draft-id_prev_app ).
        DATA(result) = CAST z2ui5_cl_pop_image_editor( lo_prev )->result( ).

        IF result-check_confirmed = abap_true.
          mv_pic_display = result-image.
          ASSIGN mt_picture[ selected_picture-id ] TO FIELD-SYMBOL(<picture>).
          IF sy-subrc = 0.
            <picture>-data = mv_pic_display.
          ENDIF.
        ENDIF.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
