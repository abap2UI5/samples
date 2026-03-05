CLASS z2ui5_cl_demo_app_213 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_213 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Input - Password'
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


  METHOD on_event.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
