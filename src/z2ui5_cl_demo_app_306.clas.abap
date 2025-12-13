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
      tt_combo TYPE STANDARD TABLE OF t_combo WITH DEFAULT KEY.


    DATA:
      mt_picture      TYPE STANDARD TABLE OF ty_picture WITH DEFAULT KEY,
      mt_picture_out  TYPE STANDARD TABLE OF ty_picture WITH DEFAULT KEY,
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

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    cont = view->shell( ).
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = cont->page( title = 'abap2UI5 - Device Camera Picture'
                   navbuttonpress  = client->_event( 'BACK' )
                   shownavbutton   = client->check_app_prev_stack( ) ).

    page->vbox( class = `sapUiSmallMargin`
       )->label( text     = `facingMode: `
                 labelfor = `ComboFacingMode`
       )->combobox( id          = `ComboFacingMode`
                    selectedkey = client->_bind_edit( facing_mode )
                    items       = `{path:'` && client->_bind_edit( val = facing_modes  path = abap_true ) && `', sorter: { path: 'TEXT' } }`
       )->get( )->item( key  = `{KEY}`
                        text = `{TEXT}` ).

    page->vbox( class = `sapUiSmallMargin`
       )->label( text     = `device: `
                 labelfor = `ComboDevice`
       )->_z2ui5( )->camera_selector(
                    id          = `ComboDevice`
                    selectedkey = client->_bind_edit( device )
                    items       = `{path:'` && client->_bind_edit( val = devices  path = abap_true ) && `', sorter: { path: 'TEXT' } }`
       )->get( )->item( key  = `{KEY}`
                        text = `{TEXT}` ).

    page->_z2ui5( )->camera_picture(
                      value      = client->_bind_edit( mv_picture_base )
                      onphoto    = client->_event( 'CAPTURE' )
                      height     = `10`
                      width      = `1000`
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
      DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
      CLEAR temp1.
      DATA temp2 LIKE LINE OF temp1.
      temp2-n = 'src'.
      temp2-v = mv_pic_display.
      INSERT temp2 INTO TABLE temp1.
      page->_generic( ns   = 'html'
                      name = 'center'
         )->_generic( ns     = 'html'
                      name   = 'img'
                      t_prop = temp1 ).

      page->button( text  = 'Edit'
                    icon  = 'sap-icon://edit'
                    press = client->_event( 'EDIT' ) ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF me->z2ui5_if_app~check_initialized = abap_false.
      DATA temp3 TYPE tt_combo.
      CLEAR temp3.
      DATA temp4 LIKE LINE OF temp3.
      temp4-key = ``.
      temp4-text = ``.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = `environment`.
      temp4-text = `environment`.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = `user`.
      temp4-text = `user`.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = `left`.
      temp4-text = `left`.
      INSERT temp4 INTO TABLE temp3.
      temp4-key = `right`.
      temp4-text = `right`.
      INSERT temp4 INTO TABLE temp3.
      facing_modes = temp3.

      view_display( ).
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_callback( ).
      view_display( ).
      RETURN.
    ENDIF.


    CASE client->get( )-event.

      WHEN 'CAPTURE'.
        DATA temp5 TYPE z2ui5_cl_demo_app_306=>ty_picture.
        CLEAR temp5.
        temp5-data = mv_picture_base.
        temp5-time = sy-uzeit.
        INSERT temp5 INTO TABLE mt_picture.
        CLEAR mv_picture_base.
        client->view_model_update( ).

      WHEN 'DISPLAY'.

        DATA temp6 LIKE LINE OF mt_picture_out.
        DATA temp7 LIKE sy-tabix.
        temp7 = sy-tabix.
        READ TABLE mt_picture_out WITH KEY selected = abap_true INTO temp6.
        sy-tabix = temp7.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        selected_picture = temp6.
        DATA temp8 LIKE LINE OF mt_picture.
        DATA temp9 LIKE sy-tabix.
        temp9 = sy-tabix.
        READ TABLE mt_picture INDEX selected_picture-id INTO temp8.
        sy-tabix = temp9.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        mv_pic_display = temp8-data.
        view_display( ).

      WHEN 'EDIT'.

        edit_image( ).

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    DATA temp10 LIKE mt_picture_out.
    CLEAR temp10.
    mt_picture_out = temp10.
    DATA ls_pic LIKE LINE OF mt_picture.
    LOOP AT mt_picture INTO ls_pic.
      DATA temp11 TYPE z2ui5_cl_demo_app_306=>ty_picture.
      CLEAR temp11.
      temp11-name = `picture ` && sy-tabix.
      temp11-id = sy-tabix.
      INSERT temp11 INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.

  METHOD edit_image.

    client->nav_app_call( z2ui5_cl_pop_image_editor=>factory( mv_pic_display ) ).

  ENDMETHOD.


  METHOD ui5_callback.

    TRY.
        DATA lo_prev TYPE REF TO z2ui5_if_app.
        lo_prev = client->get_app( client->get( )-s_draft-id_prev_app ).
        DATA temp12 TYPE REF TO z2ui5_cl_pop_image_editor.
        temp12 ?= lo_prev.
        DATA result TYPE z2ui5_cl_pop_image_editor=>t_result.
        result = temp12->result( ).

        IF result-check_confirmed = abap_true.
          mv_pic_display = result-image.
          FIELD-SYMBOLS <picture> TYPE z2ui5_cl_demo_app_306=>ty_picture.
          READ TABLE mt_picture INDEX selected_picture-id ASSIGNING <picture>.
          IF sy-subrc = 0.
            <picture>-data = mv_pic_display.
          ENDIF.
        ENDIF.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
