" @keywords quickview contact card links grouped fields
" @summary A QuickView contact card in a Popover: grouped fields, and links that call the phone or the mail app.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popover
CLASS z2ui5_cl_smp_app_109 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product TYPE string.
    DATA quantity TYPE string.
    DATA mv_placement TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_109 IMPLEMENTATION.

  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).
    view->ele( `QuickView`
        )->a( n = `placement` v = mv_placement
        )->ele( `QuickViewPage`
            )->a( n = `description` v = `Enjoy`
            )->a( n = `header`      v = `Employee Info`
            )->a( n = `pageId`      v = `employeePageId`
            )->a( n = `title`       v = `choper725`
            )->a( n = `titleUrl`    v = `https://github.com/abap2UI5/abap2UI5`
            )->ele( `QuickViewGroup`
                )->a( n = `heading` v = `Contact Details`
                )->ele( `QuickViewGroupElement`
                    )->a( n = `label` v = `Mobile`
                    )->a( n = `type`  v = `mobile`
                    )->a( n = `value` v = `123-456-789`
                )->end(
                )->ele( `QuickViewGroupElement`
                    )->a( n = `label` v = `Phone`
                    )->a( n = `type`  v = `phone`
                    )->a( n = `value` v = `789-456-123`
                )->end(
                )->ele( `QuickViewGroupElement`
                    )->a( n = `emailSubject` v = `Subject`
                    )->a( n = `label`        v = `Email`
                    )->a( n = `type`         v = `email`
                    )->a( n = `value`        v = `thisisemail@email.com`
                )->end(
            )->end(
            )->ele( `QuickViewGroup`
                )->a( n = `heading` v = `Company`
                )->ele( `QuickViewGroupElement`
                    )->a( n = `label` v = `Name`
                    )->a( n = `type`  v = `link`
                    )->a( n = `url`   v = `https://github.com/abap2UI5/abap2UI5`
                    )->a( n = `value` v = `Adventure Company`
                )->end(
                )->ele( `QuickViewGroupElement`
                    )->a( n = `label` v = `Address`
                    )->a( n = `value` v = `Here"`
                )->end( ).

    client->popover_display( xml = view->stringify( ) by_id = id ).

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
            )->a( n = `title`          v = `abap2UI5 - Popover - QuickView Contact Card`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Opens a QuickView popover, a compact contact card with grouped fields and links, ` &&
                   `anchored to a button; the segmented button sets its placement.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `QuickView Popover`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `QuickView Popover`
            )->tag( `Label`
                )->a( n = `text` v = `placement`
            )->ele( `SegmentedButton`
                )->a( n = `selectedKey` v = client->_bind( mv_placement )
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
                )->a( n = `width` v = `10rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `CLOSE_POPOVER`.
        client->popover_destroy( ).
      WHEN `POPOVER`.
        popover_display( `TEST` ).

      WHEN `BUTTON_CONFIRM`.
        client->message_toast_display( |confirm| ).
        client->popover_destroy( ).

      WHEN `BUTTON_CANCEL`.
        client->message_toast_display( |cancel| ).
        client->popover_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD on_init.

    mv_placement = `Left`.
    product      = `tomato`.
    quantity     = `500`.

  ENDMETHOD.

ENDCLASS.
