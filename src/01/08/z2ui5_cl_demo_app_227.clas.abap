"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.Page
"! Each screen of a mobile application is typically represented by a 'Page' consisting of a header, a
"! scrollable content area and optionally a footer. The standard header offers a navigation button and
"! a title. Alternatively you can provide a customer header. Gernerally you should use Toolbars in the
"! Page. If you need a centered title you may use a Bar.
CLASS z2ui5_cl_demo_app_227 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_227 IMPLEMENTATION.

  METHOD view_display.

    DATA(page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Page, Toolbar and Bar`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.Page` ).

    DATA(page_02) = page_01->page( title         = `Title`
                                   class         = `sapUiContentPadding sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer`
                                   shownavbutton = `true`
                              )->header_content(
                                  )->button( icon    = `sap-icon://action`
                                             tooltip = `Share` )->get_parent(
                              )->sub_header(
                                  )->overflow_toolbar(
                                      )->search_field( )->get_parent( )->get_parent(
                              )->content(
                                  )->vbox(
                                      )->text( `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore ` &&
                                                      `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                                                      `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit ` &&
                                                      `amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam ` &&
                                                      `erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
                                                      `tempor invidunt ut labore et dolore magna aliquyam erat` )->get_parent( )->get_parent(
                              )->footer(
                                  )->overflow_toolbar(
                                      )->toolbar_spacer(
                                          )->button( text = `Accept`
                                                     type = `Accept`
                                          )->button( text = `Reject`
                                                     type = `Reject`
                                          )->button( text = `Edit`
                                                     type = `Edit`
                                          )->button( text = `Delete`
                                                     type = `Delete` ).

    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
