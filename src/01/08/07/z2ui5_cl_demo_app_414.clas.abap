"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSection/sample/sap.uxap.sample.ObjectPageSection
"! This example explains the rules for the rendering of sections
CLASS z2ui5_cl_demo_app_414 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_414 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Page Layout Section sample`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageSection/sample/sap.uxap.sample.ObjectPageSection` ).

    DATA(object_page) = page->object_page_layout( uppercaseanchorbar = abap_false ).

    object_page->header_title( )->object_page_header( objecttitle = `Section sample` ).

    object_page->header_content( `uxap`
        )->object_attribute( text = `This example explains the rules for the rendering of sections` ).

    DATA(sections) = object_page->sections( ).

    " html-based shared blocks of the original sample replaced by plain texts
    DATA(subsections1) = sections->object_page_section( titleuppercase = abap_false
                                                        title          = `Section 1`
                                                        )->sub_sections( ).

    subsections1->object_page_sub_section( title          = `Subsection 1.1`
                                           titleuppercase = abap_false
        )->blocks(
            )->text( `The title of the first section is not shown in the page but it is shown in the AnchorBar. Subsection titles are displayed.` ).

    subsections1->object_page_sub_section( title          = `Subsection 1.2`
                                           titleuppercase = abap_false
        )->blocks(
            )->text( `If there are several Subsections in a section, the subsection names are displayed in a popup when clicking the section name in the AnchorBar.` ).

    sections->object_page_section( titleuppercase = abap_false
                                   title          = `Section 2` ).

    sections->object_page_section( titleuppercase = abap_false
                                   title          = `Section 3`
        )->sub_sections(
            )->object_page_sub_section( titleuppercase = abap_false
                )->blocks(
                    )->text( `Section 2 is empty and is not displayed between section 1 and section 3.` ).

    sections->object_page_section( titleuppercase = abap_false
                                   title          = `Section 4`
        )->sub_sections(
            )->object_page_sub_section( titleuppercase = abap_false
                )->blocks(
                    )->text( `Single Subsections are promoted to section.` ).

    sections->object_page_section( titleuppercase = abap_false
                                   title          = `Section 5`
        )->sub_sections(
            )->object_page_sub_section( titleuppercase = abap_false
                )->blocks(
                    )->text( `Single Subsections are promoted to section. When they do not have a name, the section name is used.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
