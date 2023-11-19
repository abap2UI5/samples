class Z2UI5_CL_DEMO_APP_108 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data:
    BEGIN OF screen,
        input1 TYPE string,
        input2 TYPE string,
        input3 TYPE string,
      END OF screen .
  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS Z2UI5_on_rendering
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.
    METHODS Z2UI5_on_event
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.
    METHODS Z2UI5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_108 IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_on_init( ).
      Z2UI5_on_rendering( client ).
    ENDIF.

    Z2UI5_on_event( client ).

  ENDMETHOD.


  METHOD Z2UI5_ON_EVENT.

    CASE client->get( )-event.

      WHEN 'BUTTON_SEND'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->message_toast_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_ON_INIT.

  ENDMETHOD.


  METHOD Z2UI5_ON_RENDERING.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Side Panel Example'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
         )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA(side_panel) = page->side_panel( sidepanelposition = `Left`
      )->main_content(
        )->button( text = `Button 1`
        )->button( text = `Button 2`
        )->vbox(
          )->label( text = `Switch 1`
          )->switch(
          )->get_parent(
        )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut` &&
                        `labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris` &&
                        `nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse` &&
                        `cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui` &&
                        `officia deserunt mollit anim id est laborum`
                        )->get_parent(
          )->items( ns = `f`
            )->side_panel_item( icon = `sap-icon://physical-activity` text = `Run`
              )->vbox(
                )->text( text = `Static Content` class = `sapUiSmallMarginBottom`
                )->switch(
                )->button( text = `Press Me`
              )->get_parent(
             )->get_parent(
           )->side_panel_item( icon = `sap-icon://addresses` text = `Go Home`
            )->vbox(
              )->text( text = `Static Content` class = `sapUiSmallMarginBottom`
              )->button( text = `Press Me`
              )->button( text = `Hit Me`
            )->get_parent(
           )->get_parent(
          )->side_panel_item( icon = `sap-icon://flight` text = `Fly abroad` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
