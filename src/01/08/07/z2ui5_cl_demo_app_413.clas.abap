"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.AnchorBarNoPopover
"! This example shows how to change the default behavior in order to be able to navigate to sections
"! instead of subsections, using the Anchor Bar
CLASS z2ui5_cl_demo_app_413 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_413 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Navigation to Section sample`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.AnchorBarNoPopover` ).

    DATA(object_page) = page->object_page_layout( showanchorbarpopover = abap_false
                                                  uppercaseanchorbar   = abap_false ).

    DATA(header_title) = object_page->header_title( )->object_page_dyn_header_title( ).

    header_title->heading( `uxap` )->title( `Navigation to sections` ).
    header_title->snapped_title_on_mobile( )->title( `Navigation to sections` ).

    header_title->actions( `uxap`
        )->button( text = `Edit`
                   type = `Emphasized`
        )->button( type = `Transparent`
                   text = `Delete`
        )->button( type = `Transparent`
                   text = `Copy`
        )->overflow_toolbar_button( icon    = `sap-icon://action`
                                    type    = `Transparent`
                                    text    = `Share`
                                    tooltip = `action` ).

    object_page->header_content( `uxap`
        )->title( text       = `This example shows how to change the default behavior in order to be able to navigate to sections instead of subsections, using the Anchor Bar`
                  titlestyle = `H6` ).

    DATA(sections) = object_page->sections( ).

    DATA(subsections1) = sections->object_page_section( titleuppercase = abap_false
                                                        title          = `Section 1`
                                                        )->sub_sections( ).

    block_display( subsections1->object_page_sub_section( title          = `Subsection 1.1`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

    block_display( subsections1->object_page_sub_section( title          = `Subsection 1.2`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

    DATA(subsections2) = sections->object_page_section( titleuppercase = abap_false
                                                        title          = `Section 2`
                                                        )->sub_sections( ).

    block_display( subsections2->object_page_sub_section( title          = `Subsection 2.1`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

    block_display( subsections2->object_page_sub_section( title          = `Subsection 2.2`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

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
