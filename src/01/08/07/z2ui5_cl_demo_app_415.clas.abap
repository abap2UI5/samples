"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionWithActions
"! Example of a subsection displaying action buttons.
CLASS z2ui5_cl_demo_app_415 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS block_display
      IMPORTING
        blocks TYPE REF TO z2ui5_cl_xml_view.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_415 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Subsection with Action buttons sample`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSubSection/sample/sap.uxap.sample.ObjectPageSubSectionWithActions` ).

    DATA(object_page) = page->object_page_layout( uppercaseanchorbar = abap_false ).

    object_page->header_title( )->object_page_header( objecttitle = `Action buttons sample` ).

    DATA(sections) = object_page->sections( ).

    DATA(subsections1) = sections->object_page_section( titleuppercase = abap_false
                                                        title          = `examples`
                                                        )->sub_sections( ).

    DATA(subsection) = subsections1->object_page_sub_section( title          = `Subsection with action buttons`
                                                              titleuppercase = abap_false ).

    block_display( subsection->blocks( ) ).
    subsection->actions( `uxap`
        )->button( icon = `sap-icon://synchronize`
        )->button( icon = `sap-icon://expand` ).

    block_display( subsections1->object_page_sub_section( title          = `Subsection without action buttons`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

    subsection = sections->object_page_section( titleuppercase = abap_false
                                                title          = `examples 2`
                    )->sub_sections(
                        )->object_page_sub_section( title          = `Single subsection with action buttons`
                                                    titleuppercase = abap_false ).

    block_display( subsection->blocks( ) ).
    subsection->actions( `uxap`
        )->button( icon = `sap-icon://synchronize`
        )->button( icon = `sap-icon://expand` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD block_display.

    " html-based BlockBlue shared block of the original sample replaced by a plain text
    blocks->text( `Block content goes here...` ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
