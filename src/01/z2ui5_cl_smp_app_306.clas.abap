" @keywords camera photo picture webcam capture facing mode
" @summary Takes a photo with the device camera, front or back, and hands the picture to the backend.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/camera
CLASS z2ui5_cl_smp_app_306 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_picture,
        time      TYPE string,
        id        TYPE string,
        name      TYPE string,
        " data is the full resolution, backend only; thumbnail is the small
        " preview that goes into the model
        data      TYPE string,
        thumbnail TYPE string,
        selected  TYPE abap_bool,
      END OF ty_s_picture.

    TYPES:
      BEGIN OF ty_s_combo,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_combo,
      ty_t_combo TYPE STANDARD TABLE OF ty_s_combo WITH DEFAULT KEY.

    TYPES temp1_0574ce3fcb TYPE STANDARD TABLE OF ty_s_picture WITH DEFAULT KEY.
DATA mt_picture       TYPE temp1_0574ce3fcb.
    TYPES temp2_0574ce3fcb TYPE STANDARD TABLE OF ty_s_picture WITH DEFAULT KEY.
DATA mt_picture_out   TYPE temp2_0574ce3fcb.
    DATA mv_pic_display   TYPE string.
    DATA mv_picture_base  TYPE string.
    DATA mv_picture_thumb TYPE string.
    DATA facing_mode      TYPE string.
    DATA facing_modes     TYPE ty_t_combo.
    DATA device           TYPE string.
    DATA devices          TYPE ty_t_combo.

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
      DATA temp1 TYPE ty_t_combo.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-key = ``.
      temp2-text = ``.
      INSERT temp2 INTO TABLE temp1.
      temp2-key = `environment`.
      temp2-text = `environment`.
      INSERT temp2 INTO TABLE temp1.
      temp2-key = `user`.
      temp2-text = `user`.
      INSERT temp2 INTO TABLE temp1.
      temp2-key = `left`.
      temp2-text = `left`.
      INSERT temp2 INTO TABLE temp1.
      temp2-key = `right`.
      temp2-text = `right`.
      INSERT temp2 INTO TABLE temp1.
      facing_modes = temp1.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cont TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_list TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_item TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_hbox TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    cont = view->ele( `Shell` ).
    
    page = cont->ele( `Page`
        )->a( n = `title`          v = `abap2UI5 - Device - Camera, Take Photos`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Capture photos from the device camera custom control; pick the facing mode and camera, then select ` &&
                   `a captured picture from the list to display it in full resolution.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Label`
            )->a( n = `text`        v = `facingMode: `
            )->a( n = `labelFor`    v = `ComboFacingMode`
        )->ele( `ComboBox`
            )->a( n = `selectedKey` v = client->_bind( facing_mode )
            )->a( n = `items`       v = |\{path:'{ client->_bind( val  = facing_modes
                    path        = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|
            )->a( n = `id`   v = `ComboFacingMode`
            )->tag( n = `Item` ns = `core`
                )->a( n = `key`  v = `{KEY}`
                )->a( n = `text` v = `{TEXT}` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Label`
            )->a( n = `text`        v = `device: `
            )->a( n = `labelFor`    v = `ComboDevice`
        )->ele( n = `CameraSelector` ns = `z2ui5`
            )->a( n = `selectedKey` v = client->_bind( device )
            )->a( n = `items`       v = |\{path:'{ client->_bind( val  = devices
           path        = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|
            )->a( n = `id`   v = `ComboDevice`
            )->tag( n = `Item` ns = `core`
                )->a( n = `key`  v = `{KEY}`
                )->a( n = `text` v = `{TEXT}` ).

    page->tag( n = `CameraPicture` ns = `z2ui5`
        )->a( n = `value`      v = client->_bind( mv_picture_base )
        )->a( n = `thumbnail`  v = client->_bind( mv_picture_thumb )
        )->a( n = `OnPhoto`    v = client->_event( `CAPTURE` )
        )->a( n = `facingMode` v = client->_bind( facing_mode )
        )->a( n = `deviceId`   v = client->_bind( device ) ).

    
    lo_list = page->ele( `List`
        )->a( n = `headerText`      v = `List Output`
        )->a( n = `items`           v = client->_bind( mt_picture_out )
        )->a( n = `mode`            v = `SingleSelectMaster`
        )->a( n = `selectionChange` v = client->_event( `DISPLAY` ) ).

    
    lo_item = lo_list->ele( `CustomListItem`
        )->a( n = `selected` v = `{SELECTED}` ).

    
    lo_hbox = lo_item->ele( `HBox`
        )->a( n = `alignItems` v = `Center` ).
    lo_hbox->tag( `Image`
        )->a( n = `src`    v = `{THUMBNAIL}`
        )->a( n = `height` v = `80px` ).
    lo_hbox->tag( `Text`
        )->a( n = `text` v = `{NAME}` ).

    IF mv_pic_display IS NOT INITIAL.
      page->tag( `Image`
          )->a( n = `src`    v = client->_bind( mv_pic_display )
          )->a( n = `class`  v = `sapUiSmallMargin`
          )->a( n = `height` v = `200px` ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE z2ui5_cl_smp_app_306=>ty_s_picture.
        DATA temp4 TYPE string.
        DATA temp5 TYPE string.
        DATA temp6 LIKE LINE OF mt_picture_out.
        DATA temp7 LIKE sy-tabix.
        DATA temp8 LIKE LINE OF mt_picture.
        DATA temp9 LIKE sy-tabix.

    CASE client->get_event( ).
      WHEN `CAPTURE`.

        
        CLEAR temp3.
        temp3-data = mv_picture_base.
        temp3-thumbnail = mv_picture_thumb.
        temp3-time = sy-uzeit.
        INSERT temp3 INTO TABLE mt_picture.
        
        CLEAR temp4.
        mv_picture_base  = temp4.
        
        CLEAR temp5.
        mv_picture_thumb = temp5.
        rebuild_output( ).

      WHEN `DISPLAY`.

        
        
        temp7 = sy-tabix.
        READ TABLE mt_picture_out WITH KEY selected = abap_true INTO temp6.
        sy-tabix = temp7.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        selected_picture = temp6.
        
        
        temp9 = sy-tabix.
        READ TABLE mt_picture INDEX selected_picture-id INTO temp8.
        sy-tabix = temp9.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        mv_pic_display   = temp8-data.
        rebuild_output( ).
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD rebuild_output.

    DATA temp10 LIKE mt_picture_out.
    DATA ls_pic LIKE LINE OF mt_picture.
      DATA temp11 TYPE z2ui5_cl_smp_app_306=>ty_s_picture.
      DATA temp1 TYPE xsdboolean.
    CLEAR temp10.
    mt_picture_out = temp10.
    
    LOOP AT mt_picture INTO ls_pic.
      
      CLEAR temp11.
      temp11-name = |picture { sy-tabix }|.
      temp11-id = sy-tabix.
      temp11-thumbnail = ls_pic-thumbnail.
      
      temp1 = boolc( sy-tabix = selected_picture-id ).
      temp11-selected = temp1.
      INSERT temp11
             INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
