"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNav
"! Here is an example of how you can use navigation items as unordered list items in a Flex Box.
CLASS z2ui5_cl_demo_app_403 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_403 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " style.css of the original sample injected via html:style
    DATA(css) = `.navigationExamples .code {`                    &&
                `  margin: 0 5%;`                                &&
                `  font-family: Consolas, Courier, monospace;`   &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox1,`              &&
                `.navigationExamples .ne-flexbox2 {`             &&
                `  padding: 0;`                                  &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox1 li {`          &&
                `  margin: 0.4em;`                               &&
                `  padding: 0.4em 1.3em;`                        &&
                `  list-style-type: none;`                       &&
                `  text-align: center;`                          &&
                `  background-color: #193441;`                   &&
                `  cursor: pointer;`                             &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox1 li:hover {`    &&
                `  background-color: orange;`                    &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox2 li {`          &&
                `  margin: 0.5em;`                               &&
                `  width: 25%;`                                  &&
                `  min-width: 15%;`                              &&
                `  list-style-type: none;`                       &&
                `  text-align: center;`                          &&
                `  background-color: #193441;`                   &&
                `  padding: 0.4em;`                              &&
                `  transition: width 0.5s ease-out, background-color 0.5s ease-out, flex-basis 0.5s ease-out;` &&
                `  cursor: pointer;`                             &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox2 li:hover {`    &&
                `  flex-basis: 35% !important;`                  &&
                `  background-color: orange;`                    &&
                `}`                                              &&
                `.navigationExamples .ne-flexbox1 li a,`         &&
                `.navigationExamples .ne-flexbox2 li a {`        &&
                `  color: #fff;`                                 &&
                `  text-decoration: none;`                       &&
                `  font-size: 0.875rem;`                         &&
                `}`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Flex Box - Navigation Examples`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNav` ).

    page->vbox( `navigationExamples`
        )->panel( headertext = `Variable width`
            )->flex_box( class          = `ne-flexbox1`
                         rendertype     = `List`
                         justifycontent = `Center`
                         alignitems     = `Center`
                )->html( `<a >Item 1</a>` )->get_parent(
                )->html( `<a >Long item 2</a>` )->get_parent(
                )->html( `<a >Item 3</a>` )->get_parent( )->get_parent( )->get_parent(
        )->panel( headertext = `Same width, transition effect`
            )->flex_box( class          = `ne-flexbox2`
                         rendertype     = `List`
                         justifycontent = `SpaceBetween`
                         alignitems     = `Center`
                )->html( `<a >Item 1</a>`
                    )->layout_data( `core`
                        )->flex_item_data( growfactor = `1`
                                           basesize   = `25%` )->get_parent( )->get_parent(
                )->html( `<a >Long item 2</a>`
                    )->layout_data( `core`
                        )->flex_item_data( growfactor = `1`
                                           basesize   = `25%` )->get_parent( )->get_parent(
                )->html( `<a >Item 3</a>`
                    )->layout_data( `core`
                        )->flex_item_data( growfactor = `1`
                                           basesize   = `25%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
