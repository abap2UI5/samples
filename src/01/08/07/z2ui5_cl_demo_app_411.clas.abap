"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTag/sample/sap.uxap.sample.ObjectPageHeaderActionButtons
"! This example demonstrates ObjectPage with ObjectPageHeaderActionButtons and a GenericTag in the
"! header.
CLASS z2ui5_cl_demo_app_411 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_411 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Page with ObjectPageHeaderActionButtons`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTag/sample/sap.uxap.sample.ObjectPageHeaderActionButtons` ).

    DATA(object_page) = page->object_page_layout( showtitleinheadercontent = abap_true
                                                  uppercaseanchorbar       = abap_false ).

    DATA(header_title) = object_page->header_title( )->object_page_dyn_header_title( ).

    header_title->_generic( name = `breadcrumbs`
                            ns   = `uxap`
        )->breadcrumbs(
            )->link( text = `Page 1`
            )->link( text = `Page 2`
            )->link( text = `Page 3`
            )->link( text = `Page 4`
            )->link( text = `Page 5` ).

    header_title->expanded_heading(
        )->title( text     = `Denise Smith`
                  wrapping = abap_true ).

    header_title->snapped_heading(
        )->title( text     = `Denise Smith`
                  wrapping = abap_true ).

    header_title->expanded_content( `uxap` )->text( `Senior Developer` ).
    header_title->snapped_content( `uxap` )->text( `Senior Developer` ).

    header_title->actions( `uxap`
        )->object_page_header_action_btn( text     = `Edit`
                                          type     = `Emphasized`
                                          hidetext = abap_false
        )->object_page_header_action_btn( type     = `Transparent`
                                          text     = `Delete`
                                          hidetext = abap_false
                                          hideicon = abap_true
        )->object_page_header_action_btn( type     = `Transparent`
                                          text     = `Copy`
                                          hidetext = abap_false
                                          hideicon = abap_true
        )->object_page_header_action_btn( type     = `Transparent`
                                          text     = `Add`
                                          hidetext = abap_false
                                          hideicon = abap_true
        )->object_page_header_action_btn( icon = `sap-icon://action`
                                          type = `Transparent`
                                          text = `Share` )->get(
            )->_generic_property( VALUE #( n = `tooltip`
                                           v = `action` ) ).

    header_title->_generic( name = `navigationActions`
                            ns   = `uxap`
        )->object_page_header_action_btn( icon = `sap-icon://slim-arrow-up`
                                          type = `Transparent` )->get(
            )->_generic_property( VALUE #( n = `tooltip`
                                           v = `slim-arrow-up` ) )->get_parent(
        )->object_page_header_action_btn( icon = `sap-icon://slim-arrow-down`
                                          type = `Transparent` )->get(
            )->_generic_property( VALUE #( n = `tooltip`
                                           v = `slim-arrow-down` ) ).

    header_title->content( `uxap`
        )->generic_tag( text   = `Material Shortage`
                        status = `Warning` ).

    object_page->header_content( `uxap`
        )->horizontal_layout( allowwrapping = abap_true
            )->vertical_layout( class = `sapUiMediumMarginEnd`
                )->object_attribute( title = `Location`
                                     text  = `Warehouse A`
                )->object_attribute( title = `Halway`
                                     text  = `23L`
                )->object_attribute( title = `Rack`
                                     text  = `34`
            )->get_parent(
            )->vertical_layout(
                )->object_attribute( title = `Availability`
                )->object_status( text  = `In Stock`
                                  state = `Success` ).

    DATA(sections) = object_page->sections( ).

    DATA(subsections1) = sections->object_page_section( titleuppercase = abap_false
                                                        id             = `section1`
                                                        title          = `Section 1`
                                                        )->sub_sections( ).

    block_display( subsections1->object_page_sub_section( id             = `section1_SS1`
                                                          title          = `Subsection 1.1`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

    block_display( subsections1->object_page_sub_section( id             = `section1_SS2`
                                                          title          = `Subsection 1.2`
                                                          titleuppercase = abap_false
                       )->blocks( ) ).

    sections->object_page_section( titleuppercase = abap_false
                                   id             = `section2`
                                   title          = `Section 2` ).

    block_display( sections->object_page_section( titleuppercase = abap_false
                                                  id             = `section3`
                                                  title          = `Section 3`
                       )->sub_sections(
                           )->object_page_sub_section( id             = `section3_SS1`
                                                       title          = ` `
                                                       titleuppercase = abap_false
                               )->blocks( ) ).

    block_display( sections->object_page_section( titleuppercase = abap_false
                                                  id             = `section4`
                                                  title          = `Section 4`
                       )->sub_sections(
                           )->object_page_sub_section( id             = `section4_SS1`
                                                       title          = `Subsection 4.1`
                                                       titleuppercase = abap_false
                               )->blocks( ) ).

    " control ids of the original sample omitted for the generated sections
    DATA(index) = 5.
    DO 11 TIMES.

      block_display( sections->object_page_section( titleuppercase = abap_false
                                                    title          = |Section { index }|
                         )->sub_sections(
                             )->object_page_sub_section( title          = ` `
                                                         titleuppercase = abap_false
                                 )->blocks( ) ).
      index = index + 1.

    ENDDO.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD block_display.

    blocks->simple_form( editable = abap_false
                         layout   = `ResponsiveGridLayout`
        )->label( `Content`
        )->text( `some content goes here...` ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
