"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexFixedSize
"! Shows a FixFlex control where fixContentSize is set to a specific value(200px) and
"! sap.m.scrollContainer is enabling vertical scrolling.
CLASS z2ui5_cl_demo_app_410 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_410 IMPLEMENTATION.

  METHOD view_display.

    DATA(fix_text) = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. `                                 &&
                     `Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley `      &&
                     `of type and scrambled it to make a type specimen book. `                                                                   &&
                     `It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ` &&
                     `It was popularised in the 1960s with the release of Letraset sheets containing.`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Fix Flex - Fix container size`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexFixedSize` ).

    " custom CSS of the original sample (background colors of the fix and flex areas) omitted - native CSS is not available in this package
    page->fix_flex( ns             = `layout`
                    class          = `fixFlexFixedSize`
                    fixcontentsize = `150px`
        )->fix_content( `layout`
            )->scroll_container( height   = `100%`
                                 vertical = abap_true
                )->text( fix_text
                )->text( fix_text
                )->text( fix_text
                )->text( fix_text
            )->get_parent( )->get_parent(
        )->flex_content( `layout`
            )->text( class = `column1`
                     text  = `This container is flexible and it will adapt its size to fill the remaining size in the FixFlex control` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
