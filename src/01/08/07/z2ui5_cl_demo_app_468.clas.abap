"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.ToolbarEnabled
"! The Enabled property can be used to enable or disable all the controls inside the
"! OverflowToolbar/Toolbar.
CLASS z2ui5_cl_demo_app_468 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA enabled TYPE abap_bool.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_468 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: OverflowToolbar - Enabled`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.OverflowToolbar/sample/sap.m.sample.ToolbarEnabled` ).

    page->invisible_text(
        ns   = `core`
        id   = `text1`
        text = `Label text` ).

    " the select handler of the original controller is replaced by a two-way binding of the enabled property
    page->checkbox(
        text     = `Enabled`
        selected = client->_bind_edit( enabled ) ).

    page->overflow_toolbar(
        id      = `toolbar`
        enabled = client->_bind_edit( enabled )
        )->button(
            text = `Accept`
            type = `Accept`
        )->toolbar_spacer(
        )->checkbox( text = `CheckBox`
        )->toolbar_spacer(
        )->input(
            arialabelledby = `text1`
            width          = `100px`
            value          = `Input`
        )->toolbar_spacer(
        )->radio_button( text = `RadioButton` )->get_parent(
        )->toolbar_spacer(
        )->button(
            text = `Reject`
            type = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      enabled = abap_true.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
