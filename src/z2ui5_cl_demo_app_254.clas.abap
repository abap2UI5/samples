class z2ui5_cl_demo_app_254 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_254 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(css) = `.nestedFlexboxes .item1 {`      &&
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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Nested`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'POPOVER' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNested' ).

    DATA(layout) = page->hbox(
                          fitcontainer = `abap_true`
                          alignItems = `Stretch`
                          class = `sapUiSmallMargin nestedFlexboxes`
                          )->html( content = `<h2>1</h2>`
                              )->layout_data( ns = `core`
                                  )->flex_item_data( growFactor = `2` styleClass = `item1` )->get_parent( )->get_parent(
                          )->html( content = `<h2>2</h2>`
                              )->layout_data( ns = `core`
                                  )->flex_item_data( growFactor = `3` styleClass = `item2` )->get_parent( )->get_parent(

                          )->vbox( fitcontainer = abap_false
                              )->layout_data(
                                  )->flex_item_data( growFactor = `7` )->get_parent(

                              )->html( content = `<h2>3</h2>`
                                  )->layout_data( ns = `core`
                                      )->flex_item_data( growFactor = `5` styleClass = `item3` )->get_parent( )->get_parent(

                              )->hbox( fitcontainer = `abap_true` alignitems = `Stretch`
                                  )->layout_data(
                                      )->flex_item_data( growFactor = `3` )->get_parent(

                                      )->html( content = `<h2>4</h2>`
                                          )->layout_data( ns = `core`
                                              )->flex_item_data( growFactor = `1` styleClass = `item4` )->get_parent( )->get_parent(
                                      )->html( content = `<h2>5</h2>`
                                          )->layout_data( ns = `core`
                                              )->flex_item_data( growFactor = `1` styleClass = `item5` )->get_parent( )->get_parent( )->get_parent( )->get_parent(

                          )->html( content = `<h2>6</h2>`
                              )->layout_data( ns = `core`
                                  )->flex_item_data( growFactor = `5` styleClass = `item6` )->get_parent( )->get_parent(
                         ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `Flex Boxes can be nested. Remember also that HBox and VBox are 'convenience' controls based on the Flex Box control.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
