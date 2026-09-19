" @keywords sap.ui.device responsive orientation resize media model
" @summary Reads the sap.ui.Device model - phone, tablet or desktop, orientation and resize - so a view can react to the device it is on.
" @docs https://abap2ui5.github.io/docs/cookbook/model/device_model https://abap2ui5.github.io/docs/cookbook/device_capabilities/info
CLASS z2ui5_cl_smp_app_445 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.

    "! Build the label/value rows that show the live device state. The
    "! `device>` model is a OneWay JSONModel over sap.ui.Device, so the
    "! bindings below update on their own when the window is resized or the
    "! device is rotated - no backend round-trip is involved.
    METHODS device_form
      IMPORTING
        parent        TYPE REF TO z2ui5_cl_ui5_view_builder
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_ui5_view_builder.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_445 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `OPEN_POPUP` ) IS NOT INITIAL.
      popup_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD device_form.

    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    form = parent->ele( n = `SimpleForm` ns = `form`
        )->a( n = `layout`   v = `ResponsiveGridLayout`
        )->a( n = `editable` b = abap_false ).

    " a readable label per system type instead of the raw booleans
    form->tag( `Label`
        )->a( n = `text` v = `System type`
        )->ele( `ObjectStatus`
            )->a( n = `state` v = `Information`
            )->a( n = `text`  v = `{= ${device>/system/phone} ? 'Phone' : (${device>/system/tablet} ? 'Tablet' : (${device>/system/desktop} ? 'Desktop' : 'Other')) }` ).

    form->tag( `Label`
        )->a( n = `text` v = `Orientation`
        )->ele( `ObjectStatus`
            )->a( n = `text` v = `{= ${device>/orientation/landscape} ? 'Landscape' : 'Portrait' }` ).

    " resize/width and resize/height are updated live by UI5
    form->tag( `Label`
        )->a( n = `text` v = `Window size`
        )->ele( `ObjectStatus`
            )->a( n = `text` v = `{device>/resize/width} x {device>/resize/height} px` ).

    form->tag( `Label`
        )->a( n = `text` v = `Touch support`
        )->ele( `ObjectStatus`
            )->a( n = `state` v = `{= ${device>/support/touch} ? 'Success' : 'None' }`
            )->a( n = `text`  v = `{= ${device>/support/touch} ? 'Yes' : 'No' }` ).

    form->tag( `Label`
        )->a( n = `text` v = `Browser`
        )->tag( `Text`
            )->a( n = `text` v = `{device>/browser/name} {device>/browser/version}` ).

    form->tag( `Label`
        )->a( n = `text` v = `Operating system`
        )->tag( `Text`
            )->a( n = `text` v = `{device>/os/name} {device>/os/version}` ).

    result = form.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tabs TYPE REF TO z2ui5_cl_ui5_view_builder.
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
            )->a( n = `title`          v = `abap2UI5 - Device - Device Model: Phone, Tablet, Desktop`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The 'device>' model is a one-way JSONModel over sap.ui.Device. ` &&
                   `Resize the window or rotate your device and the values update live - ` &&
                   `no backend round-trip. It is available in this view and in the dialog below.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " 1) the raw device state, bound field by field
    device_form( page->ele( `Panel`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `headerText` v = `Live device properties` ) ).

    " 2) an expression binding that reacts to the device type
    page->tag( `MessageStrip`
        )->a( n = `text`     v = `{= ${device>/system/phone} ? 'Compact layout - you are on a phone.' : 'Full layout - tablet or desktop.' }`
        )->a( n = `type`     v = `{= ${device>/system/phone} ? 'Warning' : 'Success' }`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " 3) a control whose content collapses on a phone: expanded = !phone
    
    tabs = page->ele( `Panel`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `headerText` v = `Responsive IconTabBar (expanded only when it is not a phone)`
        )->ele( `IconTabBar`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`
            )->a( n = `expanded` v = `{= !${device>/system/phone} }`
            )->ele( `items` ).

    tabs->ele( `IconTabFilter`
        )->a( n = `icon` v = `sap-icon://money-bills`
        )->a( n = `text` v = `Sales`
        )->a( n = `key`  v = `sales`
        )->tag( `Text`
            )->a( n = `text` v = `On a phone the tab content is collapsed to save space; on tablet/desktop it stays expanded.` ).

    tabs->ele( `IconTabFilter`
        )->a( n = `icon` v = `sap-icon://product`
        )->a( n = `text` v = `Stock`
        )->a( n = `key`  v = `stock`
        )->tag( `Text`
            )->a( n = `text` v = `Everything here is driven purely by the device> model - no event handler.` ).

    " 4) the same device state, but inside a popup (device> now reaches popups too)
    page->tag( `Button`
        )->a( n = `press` v = client->_event( `OPEN_POPUP` )
        )->a( n = `text`  v = `Open dialog (device model inside a popup)`
        )->a( n = `icon`  v = `sap-icon://sys-monitor`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    " the dialog width itself is driven by the device model
    
    dialog = popup->ele( `Dialog`
        )->a( n = `title`        v = `Device model inside a popup`
        )->a( n = `contentWidth` v = `{= ${device>/system/phone} ? '95%' : '420px' }` ).

    device_form( dialog->ele( `content` ) ).

    dialog->ele( `buttons`
        )->tag( `Button`
            )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )
            )->a( n = `text`  v = `Close`
            )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
