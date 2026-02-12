CLASS z2ui5_cl_demo_app_189 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES
      z2ui5_if_app.

    DATA:
      one         TYPE string,
      two         TYPE string,
      three       TYPE string,
      focus_field TYPE string.

  PRIVATE SECTION.
    DATA mv_initialized TYPE abap_bool.
    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS render.
    METHODS dispatch.

ENDCLASS.

CLASS z2ui5_cl_demo_app_189 IMPLEMENTATION.

  METHOD dispatch.

    CASE mo_client->get( )-event.
      WHEN `ONE_ENTER`.
        focus_field = `IdTwo`.
      WHEN `TWO_ENTER`.
        focus_field = `IdThree`.
    ENDCASE.
    mo_client->view_model_update( ).
  ENDMETHOD.

  METHOD render.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
          )->page(
              title          = `abap2UI5 - Focus II`
              navbuttonpress = mo_client->_event_nav_app_leave( )
              shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->simple_form(
       )->content( ns = `form`
       )->label( `One (Press Enter)` )->input( id     = `IdOne`
                                               value  = mo_client->_bind_edit( one )
                                               submit = mo_client->_event( `ONE_ENTER` )
       )->label( `Two` )->input( id     = `IdTwo`
                                 value  = mo_client->_bind_edit( two )
                                 submit = mo_client->_event( `TWO_ENTER` )
       )->label( `Three` )->input( id    = `IdThree`
                                   value = mo_client->_bind_edit( three ) ).

    lo_page->_z2ui5( )->focus( focusid = mo_client->_bind( focus_field ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.
      focus_field = `IdOne`.
      render( ).
    ENDIF.

    dispatch( ).
  ENDMETHOD.
ENDCLASS.
