CLASS z2ui5_cl_demo_app_189 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA one   TYPE string.
    DATA two   TYPE string.
    DATA three TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS render.
    METHODS dispatch.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_189 IMPLEMENTATION.

  METHOD dispatch.

    CASE client->get( )-event.
      WHEN `one_enter`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( `IdTwo` ) ) ).
      WHEN `two_enter`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( `IdThree` ) ) ).
    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD render.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
          )->page(
              title          = `abap2UI5 - Focus II`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

    page->simple_form(
       )->content( `form`
       )->label( `One (Press Enter)` )->input( id     = `IdOne`
                                               value  = client->_bind_edit( one )
                                               submit = client->_event( `one_enter` )
       )->label( `Two` )->input( id     = `IdTwo`
                                 value  = client->_bind_edit( two )
                                 submit = client->_event( `two_enter` )
       )->label( `Three` )->input( id    = `IdThree`
                                   value = client->_bind_edit( three ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      render( ).
      client->action->gen(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = VALUE #( ( `IdOne` ) ) ).
    ENDIF.

    dispatch( ).

  ENDMETHOD.

ENDCLASS.
