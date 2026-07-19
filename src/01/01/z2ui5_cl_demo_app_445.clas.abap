CLASS z2ui5_cl_demo_app_445 DEFINITION PUBLIC.

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
        parent        TYPE REF TO z2ui5_cl_xml_view
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_xml_view.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_445 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `OPEN_POPUP` ).
      popup_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD device_form.

    DATA(form) = parent->simple_form( editable = abap_false
                                      layout   = `ResponsiveGridLayout` ).

    " a readable label per system type instead of the raw booleans
    form->label( `System type`
        )->object_status(
            text  = `{= ${device>/system/phone} ? 'Phone' : (${device>/system/tablet} ? 'Tablet' : (${device>/system/desktop} ? 'Desktop' : 'Other')) }`
            state = `Information` ).

    form->label( `Orientation`
        )->object_status(
            text = `{= ${device>/orientation/landscape} ? 'Landscape' : 'Portrait' }` ).

    " resize/width and resize/height are updated live by UI5
    form->label( `Window size`
        )->object_status(
            text = `{device>/resize/width} x {device>/resize/height} px` ).

    form->label( `Touch support`
        )->object_status(
            text  = `{= ${device>/support/touch} ? 'Yes' : 'No' }`
            state = `{= ${device>/support/touch} ? 'Success' : 'None' }` ).

    form->label( `Browser`
        )->text( `{device>/browser/name} {device>/browser/version}` ).

    form->label( `Operating system`
        )->text( `{device>/os/name} {device>/os/version}` ).

    result = form.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Device Model`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The 'device>' model is a one-way JSONModel over sap.ui.Device. ` &&
                   `Resize the window or rotate your device and the values update live - ` &&
                   `no backend round-trip. It is available in this view and in the dialog below.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " 1) the raw device state, bound field by field
    device_form( page->panel( headertext = `Live device properties`
                              class      = `sapUiSmallMargin` ) ).

    " 2) an expression binding that reacts to the device type
    page->message_strip(
        text     = `{= ${device>/system/phone} ? 'Compact layout - you are on a phone.' : 'Full layout - tablet or desktop.' }`
        type     = `{= ${device>/system/phone} ? 'Warning' : 'Success' }`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " 3) a control whose content collapses on a phone: expanded = !phone
    DATA(tabs) = page->panel( headertext = `Responsive IconTabBar (expanded only when it is not a phone)`
                              class      = `sapUiSmallMargin`
        )->icon_tab_bar(
            expanded = `{= !${device>/system/phone} }`
            class    = `sapUiResponsiveContentPadding`
        )->items( ).

    tabs->icon_tab_filter( text = `Sales` key = `sales` icon = `sap-icon://money-bills`
        )->text( `On a phone the tab content is collapsed to save space; on tablet/desktop it stays expanded.` ).

    tabs->icon_tab_filter( text = `Stock` key = `stock` icon = `sap-icon://product`
        )->text( `Everything here is driven purely by the device> model - no event handler.` ).

    " 4) the same device state, but inside a popup (device> now reaches popups too)
    page->button(
        text  = `Open dialog (device model inside a popup)`
        icon  = `sap-icon://sys-monitor`
        press = client->_event( `OPEN_POPUP` )
        class = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    " the dialog width itself is driven by the device model
    DATA(dialog) = popup->dialog(
        title        = `Device model inside a popup`
        contentwidth = `{= ${device>/system/phone} ? '95%' : '420px' }` ).

    device_form( dialog->content( ) ).

    dialog->footer(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text  = `Close`
                type  = `Emphasized`
                press = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
