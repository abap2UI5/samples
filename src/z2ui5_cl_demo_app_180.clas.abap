CLASS z2ui5_cl_demo_app_180 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_url TYPE string.

    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_180 IMPLEMENTATION.

  METHOD on_event.

    IF mo_client->check_on_event( `CALL_EF` ).
      mv_url = `https://www.google.com`.
      mo_client->view_model_update( ).
      mo_client->follow_up_action( val = mo_client->_event_client( val = mo_client->cs_event-open_new_tab t_arg = VALUE #( ( mv_url ) ) ) ).
    ENDIF.
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page(
        title          = `Client->FOLLOW_UP_ACTION use cases`
        class          = `sapUiContentPadding`
        navbuttonpress = mo_client->_event_nav_app_leave( )
        shownavbutton  = mo_client->check_app_prev_stack( ) ).
    lo_page = lo_page->vbox( ).
    lo_page->button( text  = `call frontend event from backend event`
                  press = mo_client->_event( `CALL_EF` ) ).
    lo_page->label( text = `MV_URL was set AFTER backend event and model update to:` ).
    lo_page->label( text = mo_client->_bind_edit( mv_url ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      view_display( ).
    ENDIF.

    on_event( ).
  ENDMETHOD.
ENDCLASS.
