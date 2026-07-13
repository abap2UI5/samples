"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalette
"! The standalone ColorPalette in a container (sap.ui.layout.SimpleForm).
CLASS z2ui5_cl_demo_app_422 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_422 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Color Palette in a form`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ColorPalette/sample/sap.m.sample.ColorPalette` ).

    page->simple_form(
        editable                = abap_true
        backgrounddesign        = `Transparent`
        singlecontainerfullsize = abap_true
        layout                  = `ResponsiveGridLayout`
        )->toolbar( ns = `form`
            )->toolbar(
                )->title( `Color Palette in a Form`
            )->get_parent(
        )->get_parent(
        )->content( `form`
            )->label( `Choose Color`
            )->color_palette( colorselect = client->_event( val   = `COLOR_SELECT`
                                                            t_arg = VALUE #( ( `${$parameters>/value}` ) ( `${$parameters>/defaultAction}` ) ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `COLOR_SELECT` ).
      client->message_toast_display( |Color Selected: value - { client->get_event_arg( 1 ) }, \n defaultAction - { client->get_event_arg( 2 ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
