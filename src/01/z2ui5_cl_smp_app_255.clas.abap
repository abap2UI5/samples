" @keywords flexbox layout responsive navigation tile panel
" @summary Lays a page out with FlexBox and custom CSS classes - tiles, panels and a QuickView popover, all from the view chain.
" @docs https://abap2ui5.github.io/docs/cookbook/view/definition
CLASS z2ui5_cl_smp_app_255 DEFINITION PUBLIC.

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
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_255 IMPLEMENTATION.

  METHOD view_display.

    DATA css TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    css = `.navigationExamples .code \{`                    &&
                `    margin: 0 5%;`                              &&
                `    font-family: Consolas, Courier, monospace;` &&
                `\}`                                              &&
                `.navigationExamples .ne-flexbox1,`              &&
                `.navigationExamples .ne-flexbox2 \{`             &&
                `    padding: 0;`                                &&
                `\}`                                              &&
                `.navigationExamples .ne-flexbox1 li \{`          &&
                `    margin: 0.4em;`                             &&
                `    padding: 0.4em 1.3em;`                      &&
                `    list-style-type: none;`                     &&
                `    text-align: center;`                        &&
                `    background-color: #193441;`                 &&
                `    cursor: pointer;`                           &&
                `\}`                                              &&
      `.navigationExamples .ne-flexbox1 li:hover \{`    &&
                `    background-color: orange;`                  &&
                `\}`                                              &&
      `.navigationExamples .ne-flexbox2 li \{`          &&
                `    margin: 0.5em;`                             &&
                `    width: 25%;`                                &&
                `    min-width: 15%;`                            &&
                `    list-style-type: none;`                     &&
                `    text-align: center;`                        &&
                `    background-color: #193441;`                 &&
                `    padding: 0.4em;`                            &&
                `    transition: width 0.5s ease-out, background-color 0.5s ease-out, flex-basis 0.5s ease-out;` &&
                `    cursor: pointer;`                           &&
                `\}`                                              &&
      `.navigationExamples .ne-flexbox2 li:hover \{`    &&
                `    flex-basis: 35% !important;`                &&
                `    background-color: orange;`                  &&
                `\}`                                              &&
      `.navigationExamples .ne-flexbox1 li a,`         &&
                `.navigationExamples .ne-flexbox2 li a \{`        &&
                `    color: #fff;`                               &&
                `    text-decoration: none;`                     &&
                `    font-size: 0.875rem;`                       &&
                `\}`.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    " raw markup travels in the content attribute of a core:HTML leaf - the
    " builder re-escapes it on stringify, so the literal markup is written here
    view->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>` && css && `</style>` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - CSS - FlexBox Layouts with Custom Classes`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Navigation layouts built with sap.m.FlexBox and own CSS classes: variable width, equal width with ` &&
                   `a transition effect and a wrapping row. The hint button in the header explains each panel.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " ONE headerContent with both children: an aggregation opened twice is not
    " merged, the second tag REPLACES the first - written as two blocks the
    " hint Button silently disappeared and only the Link ever rendered
    page->ele( `headerContent`
        )->tag( `Button`
            )->a( n = `press`   v = client->_event( `POPOVER` )
            )->a( n = `icon`    v = `sap-icon://hint`
            )->a( n = `id`      v = `hint_icon`
            )->a( n = `tooltip` v = `Sample information`
        )->tag( `Link`
            )->a( n = `text`   v = `UI5 Demo Kit`
            )->a( n = `target` v = `_blank`
            )->a( n = `href`   v = `https://sdk.openui5.org/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxNav` ).

    page->ele( `VBox`
        )->a( n = `class` v = `navigationExamples`
        )->ele( `Panel`
            )->a( n = `headerText` v = `Variable width`
            )->ele( `FlexBox`
                )->a( n = `class`          v = `ne-flexbox1`
                )->a( n = `renderType`     v = `List`
                )->a( n = `alignItems`     v = `Center`
                )->a( n = `justifyContent` v = `Center`
                )->ele( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<a >Item 1</a>`
                )->end(
                )->ele( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<a >Long item 2</a>`
                )->end(
                )->ele( n = `HTML` ns = `core`
                    )->a( n = `content` v = `<a >Item 3</a>`
                )->end(
            )->end(
            )->ele( `Panel`
                )->a( n = `headerText` v = `Same width, transition effect`
                )->ele( `FlexBox`
                    )->a( n = `class`          v = `ne-flexbox2`
                    )->a( n = `renderType`     v = `List`
                    )->a( n = `alignItems`     v = `Center`
                    )->a( n = `justifyContent` v = `SpaceBetween`
                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Item 1</a>`
                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `25%`
                        )->end(
                    )->end(
                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Long item 2</a>`
                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `25%`
                        )->end(
                    )->end(
                    )->ele( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<a >Item 3</a>`
                        )->ele( n = `layoutData` ns = `core`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `25%`
                        )->end(
                    )->end( ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `POPOVER` ) IS NOT INITIAL.
      popover_display( `hint_icon` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).
    view->ele( `QuickView`
        )->a( n = `placement` v = `Bottom`
        )->a( n = `width`     v = `auto`
        )->ele( `QuickViewPage`
            )->a( n = `description` v = `Here is an example of how you can use navigation items as unordered list items in a Flex Box.`
            )->a( n = `header`      v = `Sample information`
            )->a( n = `pageId`      v = `sampleInformationId` ).

    client->popover_display( xml = view->stringify( ) by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( client ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
