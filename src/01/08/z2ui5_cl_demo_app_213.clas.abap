CLASS z2ui5_cl_demo_app_213 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_213 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Password`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).
    layout->label( text     = `Password`
                   labelfor = `passwordInput` ).
    layout->input( id          = `passwordInput`
                   type        = `Password`
                   placeholder = `Enter password` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
