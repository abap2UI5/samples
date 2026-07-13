"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardNoMargins
"! Use our standard 'No-Margins' classes to remove existing margins from your control. You can either
"! remove all margins at once or remove the margin on one or more sides.
CLASS z2ui5_cl_demo_app_497 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             price         TYPE string,
             currency_code TYPE string,
             weight        TYPE string,
             dimensions    TYPE string,
             description   TYPE string,
           END OF ty_s_product.
    DATA s_product1 TYPE ty_s_product.
    DATA s_product2 TYPE ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_497 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      s_product1 = VALUE #( name          = `Notebook Basic 15`
                            price         = `956`
                            currency_code = `EUR`
                            weight        = `4.2 KG`
                            dimensions    = `30 x 18 x 3 cm`
                            description   = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` ).
      s_product2 = VALUE #( name          = `Notebook Basic 17`
                            price         = `1249`
                            currency_code = `EUR`
                            weight        = `4.5 KG`
                            dimensions    = `29 x 17 x 3.1 cm`
                            description   = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` ).

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(number1) = |\{ parts: [ '{ client->_bind( val  = s_product1-price
                                                   path = abap_true ) }', '{ client->_bind( val  = s_product1-currency_code
                                                                                            path = abap_true ) }' ],| &&
                    | type: 'sap.ui.model.type.Currency', formatOptions: \{ showMeasure: false \} \}|.
    DATA(number2) = |\{ parts: [ '{ client->_bind( val  = s_product2-price
                                                   path = abap_true ) }', '{ client->_bind( val  = s_product2-currency_code
                                                                                            path = abap_true ) }' ],| &&
                    | type: 'sap.ui.model.type.Currency', formatOptions: \{ showMeasure: false \} \}|.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Remove Margins`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardNoMargins` ).

    page->text( `ObjectHeader with its top and end margins removed:` ).

    page->object_header(
        title      = client->_bind( s_product1-name )
        number     = number1
        numberunit = client->_bind( s_product1-currency_code )
        class      = `sapUiNoMarginTop sapUiNoMarginEnd`
        )->_generic( `statuses`
            )->object_status(
                text  = `Some Damaged`
                state = `Error` )->get_parent(
            )->object_status(
                text  = `In Stock`
                state = `Success` )->get_parent( )->get_parent(
        )->_generic( `attributes`
            )->object_attribute( text = client->_bind( s_product1-weight )
            )->object_attribute( text = client->_bind( s_product1-dimensions )
            )->object_attribute( text = client->_bind( s_product1-description )
            )->object_attribute(
                text   = `www.sap.com`
                active = abap_true ).

    page->text( `ObjectHeader with its bottom and begin margins removed:` ).

    page->object_header(
        title      = client->_bind( s_product2-name )
        number     = number2
        numberunit = client->_bind( s_product2-currency_code )
        class      = `sapUiNoMarginBottom sapUiNoMarginBegin`
        )->_generic( `statuses`
            )->object_status(
                text  = `Some Damaged`
                state = `Error` )->get_parent(
            )->object_status(
                text  = `In Stock`
                state = `Success` )->get_parent( )->get_parent(
        )->_generic( `attributes`
            )->object_attribute( text = client->_bind( s_product2-weight )
            )->object_attribute( text = client->_bind( s_product2-dimensions )
            )->object_attribute( text = client->_bind( s_product2-description )
            )->object_attribute(
                text   = `www.sap.com`
                active = abap_true ).

    page->text( `By default, ObjectHeader instances come with a 16px (1rem) margin all around. In our example, we added pre-defined css classes ` &&
                `'sapUiNoMarginTop' and 'sapUiNoMarginEnd' to remove the top and right margin from the first ObjectHeader and 'sapUiNoMarginBottom' ` &&
                `and 'sapUiNoMarginBegin' to remove the bottom and left margin from the second ObjectHeader(in left-to-right mode). To see what happens ` &&
                `in Right-To-Left mode open 'Settings' by pressing the cog wheel button next to 'Entities'.` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
