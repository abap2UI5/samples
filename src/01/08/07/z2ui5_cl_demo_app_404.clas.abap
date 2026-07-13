"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested
"! Flex Boxes can be nested. Remember also that HBox and VBox are 'convenience' controls based on the
"! Flex Box control.
CLASS z2ui5_cl_demo_app_404 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_404 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " style.css of the original sample injected via html:style
    DATA(css) = `.nestedFlexboxes .item1 {`    &&
                `  padding: 1rem;`             &&
                `  background-color: #d1dbbd;` &&
                `}`                            &&
                `.nestedFlexboxes .item2 {`    &&
                `  padding: 1rem;`             &&
                `  background-color: #7D8A2E;` &&
                `}`                            &&
                `.nestedFlexboxes .item3 {`    &&
                `  padding: 1rem;`             &&
                `  background-color: #C9D787;` &&
                `}`                            &&
                `.nestedFlexboxes .item4 {`    &&
                `  padding: 1rem;`             &&
                `  background-color: #FFFFFF;` &&
                `}`                            &&
                `.nestedFlexboxes .item5 {`    &&
                `  padding: 1rem;`             &&
                `  background-color: #FFC0A9;` &&
                `}`                            &&
                `.nestedFlexboxes .item6 {`    &&
                `  padding: 1rem;`             &&
                `  background-color: #FF8598;` &&
                `}`                            &&
                `.nestedFlexboxes h2 {`        &&
                `  color: #32363a;`            &&
                `}`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Flex Box - Nested`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested` ).

    page->hbox( fitcontainer = abap_true
                alignitems   = `Stretch`
                class        = `sapUiSmallMargin nestedFlexboxes`
        )->html( `<h2>1</h2>`
            )->layout_data( `core`
                )->flex_item_data( growfactor = `2`
                                   styleclass = `item1` )->get_parent( )->get_parent(
        )->html( `<h2>2</h2>`
            )->layout_data( `core`
                )->flex_item_data( growfactor = `3`
                                   styleclass = `item2` )->get_parent( )->get_parent(
        )->vbox( fitcontainer = abap_true
            )->layout_data(
                )->flex_item_data( growfactor = `7` )->get_parent(
            )->html( `<h2>3</h2>`
                )->layout_data( `core`
                    )->flex_item_data( growfactor = `5`
                                       styleclass = `item3` )->get_parent( )->get_parent(
            )->hbox( fitcontainer = abap_true
                     alignitems   = `Stretch`
                )->layout_data(
                    )->flex_item_data( growfactor = `3` )->get_parent(
                )->html( `<h2>4</h2>`
                    )->layout_data( `core`
                        )->flex_item_data( growfactor = `1`
                                           styleclass = `item4` )->get_parent( )->get_parent(
                )->html( `<h2>5</h2>`
                    )->layout_data( `core`
                        )->flex_item_data( growfactor = `1`
                                           styleclass = `item5` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
        )->html( `<h2>6</h2>`
            )->layout_data( `core`
                )->flex_item_data( growfactor = `5`
                                   styleclass = `item6` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
