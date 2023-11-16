CLASS z2ui5_cl_demo_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.
    METHODS display_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.
    DATA mv_url TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_073 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      product  = 'tomato'.
      quantity = '500'.

      display_view( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_OPEN_NEW_TAB'.
        mv_url = `https://www.google.com/search?q=abap2ui5&oq=abap2ui5,123`.
        display_view( client ).

*        client->timer_set(
*            interval_ms    = `0`
*            event_finished = client->_event_client(
*                val   = client->cs_event-open_new_tab
*                t_arg = value #( ( mv_url ) )
*      ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( i_client ).

    IF mv_url IS NOT INITIAL.
      view->_cc( )->timer( )->control( i_client->_event_client(
                  val   = i_client->cs_event-open_new_tab
                  t_arg = VALUE #( ( mv_url ) ) ) ).
    mv_url = ``.
    ENDIF.

    i_client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - First Example'
                  navbuttonpress = i_client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton  = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( I_client )->app_get_url_source_code( )
                      target = '_blank'
              )->get_parent(
              )->simple_form( title = 'Form Title' editable = abap_true
                  )->content( 'form'
                      )->button(
                          text  = 'open new tab'
                          press = i_client->_event( val = 'BUTTON_OPEN_NEW_TAB' )
           )->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
