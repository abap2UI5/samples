class z2ui5_cl_demo_app_227 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_227 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Page, Toolbar and Bar'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(page_02) = page_01->page( title = `Title`
                                   class = `sapUiContentPadding sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer`
                                   showNavButton = `true`
                              )->header_content(
                                  )->button( icon = `sap-icon://action` tooltip = `Share` )->get_parent(
                              )->sub_header(
                                  )->overflow_toolbar(
                                      )->search_field( )->get_parent( )->get_parent(
                              )->content(
                                  )->vbox(
                                      )->text( text = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore ` &&
                                                      `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                                                      `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit ` &&
                                                      `amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam ` &&
                                                      `erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ` &&
                                                      `tempor invidunt ut labore et dolore magna aliquyam erat` )->get_parent( )->get_parent(
                              )->footer(
                                  )->overflow_toolbar(
                                      )->toolbar_spacer(
                                          )->button( text = `Accept` type = `Accept`
                                          )->button( text = `Reject` type = `Reject`
                                          )->button( text = `Edit` type = `Edit`
                                          )->button( text = `Delete` type = `Delete`
                    ).

    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
