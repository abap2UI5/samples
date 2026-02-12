CLASS z2ui5_cl_demo_app_254 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_254 IMPLEMENTATION.

  METHOD display_view.

    DATA(lv_css) = `.nestedFlexboxes .item1 {`      &&
                `    padding: 1rem;`             &&
                `    background-color: #d1dbbd;` &&
                `}`                              &&
                `.nestedFlexboxes .item2 {`      &&
                `    padding: 1rem;`             &&
                `    background-color: #7D8A2E;` &&
                `}`                              &&
                `.nestedFlexboxes .item3 {`      &&
                `    padding: 1rem;`             &&
                `    background-color: #C9D787;` &&
                `}`                              &&
                `.nestedFlexboxes .item4 {`      &&
                `    padding: 1rem;`             &&
                `    background-color: #FFFFFF;` &&
                `}`                              &&
                `.nestedFlexboxes .item5 {`      &&
                `    padding: 1rem;`             &&
                `    background-color: #FFC0A9;` &&
                `}`                              &&
                `.nestedFlexboxes .item6 {`      &&
                `    padding: 1rem;`             &&
                `    background-color: #FF8598;` &&
                `}`                              &&
      `.nestedFlexboxes h2 {`          &&
                `    color: #32363a;`            &&
                `}`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( lv_css )->get_parent( ).

    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Nested`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `hint_icon`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `POPOVER` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested` ).

    DATA(lo_layout) = lo_page->hbox(
                          fitcontainer = `abap_true`
                          alignitems   = `Stretch`
                          class        = `sapUiSmallMargin nestedFlexboxes`
                          )->html( content = `<h2>1</h2>`
                              )->layout_data( ns = `core`
                                  )->flex_item_data( growfactor = `2`
                                                     styleclass = `item1` )->get_parent( )->get_parent(
                          )->html( content = `<h2>2</h2>`
                              )->layout_data( ns = `core`
                                  )->flex_item_data( growfactor = `3`
                                                     styleclass = `item2` )->get_parent( )->get_parent(
      )->vbox( fitcontainer = abap_false
                              )->layout_data(
                                  )->flex_item_data( growfactor = `7` )->get_parent(
      )->html( content = `<h2>3</h2>`
                                  )->layout_data( ns = `core`
                                      )->flex_item_data( growfactor = `5`
                                                         styleclass = `item3` )->get_parent( )->get_parent(
      )->hbox( fitcontainer = `abap_true`
               alignitems   = `Stretch`
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `3` )->get_parent(
      )->html( content = `<h2>4</h2>`
                                          )->layout_data( ns = `core`
                                              )->flex_item_data( growfactor = `1`
                                                                 styleclass = `item4` )->get_parent( )->get_parent(
                                      )->html( content = `<h2>5</h2>`
                                          )->layout_data( ns = `core`
                                              )->flex_item_data( growfactor = `1`
                                                                 styleclass = `item5` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
      )->html( content = `<h2>6</h2>`
                              )->layout_data( ns = `core`
                                  )->flex_item_data( growfactor = `5`
                                                     styleclass = `item6` )->get_parent( )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `POPOVER` ).
      display_popover( `hint_icon` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Flex Boxes can be nested. Remember also that HBox and VBox are 'convenience' controls based on the Flex Box control.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
