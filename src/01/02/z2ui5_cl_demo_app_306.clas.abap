CLASS z2ui5_cl_demo_app_306 DEFINITION PUBLIC.

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
      tt_combo TYPE STANDARD TABLE OF ty_s_combo WITH DEFAULT KEY.

    DATA mt_picture       TYPE STANDARD TABLE OF ty_s_picture WITH DEFAULT KEY.
    DATA mt_picture_out   TYPE STANDARD TABLE OF ty_s_picture WITH DEFAULT KEY.
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
    METHODS edit_image.
    METHODS on_navigation.
    METHODS rebuild_output.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_306 IMPLEMENTATION.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_list TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp2 LIKE LINE OF temp1.
    DATA lo_item TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_hbox TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    cont = view->shell( ).
    
    page = cont->page( title          = `abap2UI5 - Device Camera Picture`
                             navbuttonpress = client->_event_nav_app_leave( )
                             shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Capture photos from the device camera custom control; pick the facing mode and camera, then edit a ` &&
                   `captured picture in the popup image editor.`
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

    
    lo_list = page->list(
                                headertext      = `List Output`
                                items           = client->_bind( mt_picture_out )
                                mode            = `SingleSelectMaster`
                                selectionchange = client->_event( `DISPLAY` ) ).

    
    CLEAR temp1.
    
    temp2-n = `selected`.
    temp2-v = `{SELECTED}`.
    INSERT temp2 INTO TABLE temp1.
    
    lo_item = lo_list->_generic( name   = `CustomListItem`
                                       t_prop = temp1 ).

    
    lo_hbox = lo_item->hbox( alignitems = `Center` ).
    lo_hbox->image( src    = `{THUMBNAIL}`
                    height = `80px` ).
    lo_hbox->text( `{NAME}` ).

    IF mv_pic_display IS NOT INITIAL.
      page->button( text  = `Edit`
                    icon  = `sap-icon://edit`
                    press = client->_event( `EDIT` ) ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp3 TYPE tt_combo.
      DATA temp4 LIKE LINE OF temp3.
        DATA temp5 TYPE z2ui5_cl_demo_app_306=>ty_s_picture.
                        DATA temp6 TYPE string.
                        DATA temp7 TYPE string.
        DATA temp8 LIKE LINE OF mt_picture_out.
        DATA temp9 LIKE sy-tabix.
        DATA temp10 LIKE LINE OF mt_picture.
        DATA temp11 LIKE sy-tabix.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp3.
      
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

      on_navigation( ).
      rebuild_output( ).
      view_display( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN `CAPTURE`.
        
        CLEAR temp5.
        temp5-data = mv_picture_base.
        temp5-thumbnail = mv_picture_thumb.
        temp5-time = sy-uzeit.
        INSERT temp5 INTO TABLE mt_picture.
                        
                        CLEAR temp6.
                        mv_picture_base  = temp6.
                        
                        CLEAR temp7.
                        mv_picture_thumb = temp7.
        client->view_model_update( ).

      WHEN `DISPLAY`.

        
        
        temp9 = sy-tabix.
        READ TABLE mt_picture_out WITH KEY selected = abap_true INTO temp8.
        sy-tabix = temp9.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        selected_picture = temp8.
        
        
        temp11 = sy-tabix.
        READ TABLE mt_picture INDEX selected_picture-id INTO temp10.
        sy-tabix = temp11.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        mv_pic_display   = temp10-data.
        rebuild_output( ).
        view_display( ).
        RETURN.

      WHEN `EDIT`.

        edit_image( ).
    ENDCASE.

    rebuild_output( ).

  ENDMETHOD.


  METHOD edit_image.

    client->nav_app_call( z2ui5_cl_pop_image_editor=>factory( mv_pic_display ) ).

  ENDMETHOD.


  METHOD rebuild_output.

    DATA temp12 LIKE mt_picture_out.
    DATA ls_pic LIKE LINE OF mt_picture.
      DATA temp13 TYPE z2ui5_cl_demo_app_306=>ty_s_picture.
      DATA temp1 TYPE abap_bool.
    CLEAR temp12.
    mt_picture_out = temp12.
    
    LOOP AT mt_picture INTO ls_pic.
      
      CLEAR temp13.
      temp13-name = |picture { sy-tabix }|.
      temp13-id = sy-tabix.
      temp13-thumbnail = ls_pic-thumbnail.
      
      IF sy-tabix = selected_picture-id.
        temp1 = abap_true.
      ELSE.
        CLEAR temp1.
      ENDIF.
      temp13-selected = temp1.
      INSERT temp13
             INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.


  METHOD on_navigation.
        DATA lo_prev TYPE REF TO z2ui5_if_app.
        DATA temp14 TYPE REF TO z2ui5_cl_pop_image_editor.
        DATA result TYPE z2ui5_cl_pop_image_editor=>t_result.
          FIELD-SYMBOLS <picture> TYPE z2ui5_cl_demo_app_306=>ty_s_picture.

    TRY.
        
        lo_prev = client->get_app( client->get( )-s_draft-id_prev_app ).
        
        temp14 ?= lo_prev.
        
        result = temp14->result( ).

        IF result-check_confirmed = abap_true.
          mv_pic_display = result-image.
          
          READ TABLE mt_picture INDEX selected_picture-id ASSIGNING <picture>.

          IF sy-subrc = 0.

            <picture>-data      = mv_pic_display.
            <picture>-thumbnail = mv_pic_display.
          ENDIF.
        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
