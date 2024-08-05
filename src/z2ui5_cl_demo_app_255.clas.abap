class z2ui5_cl_demo_app_255 definition
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



CLASS z2ui5_cl_demo_app_255 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(css) = `.navigationExamples .code {`                    &&
                `    margin: 0 5%;`                              &&
                `    font-family: Consolas, Courier, monospace;` &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox1,`              &&
                `.navigationExamples .ne-flexbox2 {`             &&
                `    padding: 0;`                                &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox1 li {`          &&
                `    margin: 0.4em;`                             &&
                `    padding: 0.4em 1.3em;`                      &&
                `    list-style-type: none;`                     &&
                `    text-align: center;`                        &&
                `    background-color: #193441;`                 &&
                `    cursor: pointer;`                           &&
                `}`                                              &&

                `.navigationExamples .ne-flexbox1 li:hover {`    &&
                `    background-color: orange;`                  &&
                `}`                                              &&

                `.navigationExamples .ne-flexbox2 li {`          &&
                `    margin: 0.5em;`                             &&
                `    width: 25%;`                                &&
                `    min-width: 15%;`                            &&
                `    list-style-type: none;`                     &&
                `    text-align: center;`                        &&
                `    background-color: #193441;`                 &&
                `    padding: 0.4em;`                            &&
                `    transition: width 0.5s ease-out, background-color 0.5s ease-out, flex-basis 0.5s ease-out;` &&
                `    cursor: pointer;`                           &&
                `}`                                              &&

                `.navigationExamples .ne-flexbox2 li:hover {`    &&
                `    flex-basis: 35% !important;`                &&
                `    background-color: orange;`                  &&
                `}`                                              &&

                `.navigationExamples .ne-flexbox1 li a,`         &&
                `.navigationExamples .ne-flexbox2 li a {`        &&
                `    color: #fff;`                               &&
                `    text-decoration: none;`                     &&
                `    font-size: 0.875rem;`                       &&
                `}`.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
         )->page(
            title          = `abap2UI5 - Flex Box - Navigation Examples`
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
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNav' ).

    DATA(layout) = page->vbox( class = `navigationExamples`
                          )->panel(  headerText = `Variable width`
                              )->flex_box(
                                  class = `ne-flexbox1`
                                  renderType = `List`
                                  justifyContent = `Center`
                                  alignItems = `Center`
                                  )->html( content = `<a >Item 1</a>` )->get_parent(
                                  )->html( content = `<a >Long item 2</a>` )->get_parent(
                                  )->html( content = `<a >Item 3</a>` )->get_parent( )->get_parent(

                          )->panel(  headerText = `Same width, transition effect`
                              )->flex_box(
                                  class = `ne-flexbox2`
                                  renderType = `List`
                                  justifyContent = `SpaceBetween`
                                  alignItems = `Center`
                                  )->html( content = `<a >Item 1</a>` )->get(
                                      )->layout_data( ns = `core`
                                          )->flex_item_data( growFactor = `1` baseSize = `25%` )->get_parent( )->get_parent(
                                  )->html( content = `<a >Long item 2</a>` )->get(
                                      )->layout_data( ns = `core`
                                          )->flex_item_data( growFactor = `1` baseSize = `25%` )->get_parent( )->get_parent(
                                  )->html( content = `<a >Item 3</a>` )->get(
                                      )->layout_data( ns = `core`
                                          )->flex_item_data( growFactor = `1` baseSize = `25%` )->get_parent( )->get_parent(
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
                                  description = `Here is an example of how you can use navigation items as unordered list items in a Flex Box.` ).

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
