CLASS z2ui5_cl_demo_app_217 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_217 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Placing a Title in OverflowToolbar/Toolbar`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->overflow_toolbar( design = `Transparent`
                                           height = `3rem`
                          )->title( `Title Only` ).
    page->overflow_toolbar( design = `Transparent`
                            height = `3rem`
                          )->title( `Title and Actions`
                          )->toolbar_spacer(
                          )->button( icon = `sap-icon://group-2`
                          )->button( icon = `sap-icon://action-settings` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
