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
      ty_t_combo TYPE STANDARD TABLE OF ty_s_combo WITH EMPTY KEY.

    DATA mt_picture       TYPE STANDARD TABLE OF ty_s_picture WITH EMPTY KEY.
    DATA mt_picture_out   TYPE STANDARD TABLE OF ty_s_picture WITH EMPTY KEY.
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

    me->client = client.
    IF client->check_on_init( ).

      facing_modes = VALUE ty_t_combo( ( key = `` text = `` )
                                     ( key = `environment` text = `environment` )
                                     ( key = `user`        text = `user` )
                                     ( key = `left`        text = `left` )
                                     ( key = `right`       text = `right` ) ).

      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    DATA(cont) = view->ele( `Shell` ).
    DATA(page) = cont->ele( `Page`
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

    DATA(lo_list) = page->ele( `List`
        )->a( n = `headerText`      v = `List Output`
        )->a( n = `items`           v = client->_bind( mt_picture_out )
        )->a( n = `mode`            v = `SingleSelectMaster`
        )->a( n = `selectionChange` v = client->_event( `DISPLAY` ) ).

    DATA(lo_item) = lo_list->ele( `CustomListItem`
        )->a( n = `selected` v = `{SELECTED}` ).

    DATA(lo_hbox) = lo_item->ele( `HBox`
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

    CASE client->get_event( ).
      WHEN `CAPTURE`.

        INSERT VALUE #( data = mv_picture_base thumbnail = mv_picture_thumb time = sy-uzeit ) INTO TABLE mt_picture.
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
                      selected  = xsdbool( sy-tabix = selected_picture-id ) )
             INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
