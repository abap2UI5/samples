" @keywords placement anchor button confirm cancel popover_display
" @summary A Popover anchored to the control that opened it, with the placements to choose from and a confirm/cancel footer.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popover
CLASS z2ui5_cl_smp_app_026 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product   TYPE string.
    DATA quantity  TYPE string.
    DATA placement TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS popover_display
      IMPORTING
        id TYPE string.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_026 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      placement = `Left`.
      product   = `tomato`.
      quantity  = `500`.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `POPOVER` ) IS NOT INITIAL.
      popover_display( `TEST` ).

    ELSEIF client->check_on_event( `BUTTON_CONFIRM` ) IS NOT INITIAL.

      client->message_toast_display( `confirm` ).
      client->popover_destroy( ).

    ELSEIF client->check_on_event( `BUTTON_CANCEL` ) IS NOT INITIAL.

      client->message_toast_display( `cancel` ).
      client->popover_destroy( ).

    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).
    view->ele( `Popover`
        )->a( n = `title`     v = `Popover Title`
        )->a( n = `placement` v = placement
        )->ele( `footer`
            )->ele( `OverflowToolbar`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_CANCEL` )
                    )->a( n = `text`  v = `Cancel`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_CONFIRM` )
                    )->a( n = `text`  v = `Confirm`
                    )->a( n = `type`  v = `Emphasized`
            )->end(
        )->end(
        )->tag( `Text`
            )->a( n = `text` v = `make an input here:`
        )->tag( `Input`
            )->a( n = `value` v = `abcd` ).

    client->popover_display(
        xml   = view->stringify( )
        by_id = id ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popover - Basic Example with Placement`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Popover demo: choose a placement with the segmented button, then open a popover ` &&
                   `anchored to a control, with confirm and cancel actions.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Popover`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `Input`
            )->tag( `Label`
                )->a( n = `text` v = `Link`
            )->tag( `Link`
                )->a( n = `text` v = `Documentation UI5 Popover Control`
                )->a( n = `href` v = `https://sdk.openui5.org/entity/sap.m.Popover`
            )->tag( `Label`
                )->a( n = `text` v = `placement`
            )->ele( `SegmentedButton`
                )->a( n = `selectedKey` v = client->_bind( placement )
                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://add-favorite`
                        )->a( n = `key`  v = `Left`
                        )->a( n = `text` v = `Left`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://accept`
                        )->a( n = `key`  v = `Top`
                        )->a( n = `text` v = `Top`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://accept`
                        )->a( n = `key`  v = `Bottom`
                        )->a( n = `text` v = `Bottom`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://attachment`
                        )->a( n = `key`  v = `Right`
                        )->a( n = `text` v = `Right`
                )->end(
            )->end(
            )->tag( `Label`
                )->a( n = `text` v = `popover`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPOVER` )
                )->a( n = `text`  v = `show`
                )->a( n = `id`    v = `TEST`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPOVER` )
                )->a( n = `text`  v = `cancel`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPOVER` )
                )->a( n = `text`  v = `post` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
