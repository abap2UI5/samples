"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectNumber/sample/sap.m.sample.ObjectNumber
"! The object number is a small building block representing an important, numerical attribute of an
"! object together with it's unit. Often it is used in the last column of a table.
CLASS z2ui5_cl_demo_app_467 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_467 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Number`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectNumber/sample/sap.m.sample.ObjectNumber` ).

    " prices of /ProductCollection/0..5 of the mock model sap/ui/demo/mock/products.json used by the original sample
    DATA(layout) = page->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%` ).

    layout->label(
        text   = `ObjectNumber`
        class  = `sapUiSmallMarginTop`
        design = `Bold` ).

    layout->horizontal_layout( class = `sapUiContentPadding`
        )->object_number(
            class  = `sapUiSmallMarginBottom`
            number = `856.49`
            unit   = `EUR`
        )->object_number(
            class  = `sapUiSmallMarginBottom`
            number = `81.70`
            unit   = `EUR`
            state  = `Error`
        )->object_number(
            class  = `sapUiSmallMarginBottom`
            number = `219.00`
            unit   = `EUR`
            state  = `Warning`
        )->object_number(
            class  = `sapUiSmallMarginBottom`
            number = `59.00`
            unit   = `EUR`
            state  = `Success`
        )->object_number(
            class  = `sapUiSmallMarginBottom`
            number = `6.50`
            unit   = `EUR`
            state  = `Information` ).

    " sections 'Inverted ObjectNumber', 'Interactive ObjectNumber' and 'Inverted Interactive ObjectNumber' omitted - properties inverted and active and event press available only since UI5 1.86

    DATA(layout2) = page->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%` ).

    layout2->label(
        text   = `ObjectNumber with style sapMObjectNumberLarge applied`
        class  = `sapUiSmallMarginTop`
        design = `Bold` ).

    layout2->object_number(
        class      = `sapMObjectNumberLarge`
        number     = `78.90`
        unit       = `EUR`
        emphasized = abap_false
        state      = `None` ).

    " section 'Interactive ObjectNumber with style sapMObjectNumberLarge applied' omitted - property active and event press available only since UI5 1.86

    layout2->label(
        text   = `ObjectNumber wrapped via sapMObjectNumberLongText`
        class  = `sapUiSmallMarginTop`
        design = `Bold` ).

    " properties active and press of the original ObjectNumber omitted - available only since UI5 1.86
    layout2->panel(
        backgrounddesign = `Transparent`
        width            = `100px`
        )->object_number(
            class      = `sapMObjectNumberLongText`
            number     = `12345678901234567890`
            unit       = `EUR`
            emphasized = abap_false
            state      = `None` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
