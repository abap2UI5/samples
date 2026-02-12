CLASS z2ui5_cl_demo_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_url TYPE string.
    DATA mv_check_timer_active TYPE abap_bool.

    METHODS display_view.

    DATA mo_client TYPE REF TO z2ui5_if_client.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_073 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    mo_client->view_display( lo_view->shell(
          )->page(
                  title          = `abap2UI5 - First Example`
                  navbuttonpress = mo_client->_event( `BACK` )
                  shownavbutton  = mo_client->check_app_prev_stack( )
             )->_z2ui5( )->timer(
                  checkactive = mo_client->_bind( mv_check_timer_active )
                  finished    = mo_client->_event_client( val     = mo_client->cs_event-open_new_tab
                                                         t_arg = VALUE #( ( `$` && mo_client->_bind( mv_url ) ) ) )
              )->simple_form( title    = `Form Title`
                              editable = abap_true
                  )->content( `form`
                      )->button(
                          text  = `open new tab`
                          press = mo_client->_event( `BUTTON_OPEN_NEW_TAB` )
           )->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      mv_check_timer_active = abap_false.
      display_view( ).
    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_OPEN_NEW_TAB`.
        mv_check_timer_active = abap_true.
        mv_url = `https://www.google.com/search?q=abap2ui5&oq=abap2ui5,123`.
        mo_client->view_model_update( ).
      WHEN `BACK`.
        mo_client->nav_app_leave( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
