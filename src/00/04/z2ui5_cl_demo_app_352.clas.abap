CLASS z2ui5_cl_demo_app_352 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_352 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
      client->action->gen(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = VALUE #( ( `ZINPUT` ) ) ).
      client->action->gen(
          val   = z2ui5_if_client=>cs_event-keyboard_set_mode
          t_arg = VALUE #( ( `ZINPUT` ) ( `numeric` ) ) ).
    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
             )->page(
                 title          = `abap2UI5 - Softkeyboard on/off`
                 navbuttonpress = client->_event_nav_app_leave( )
                 shownavbutton  = client->check_app_prev_stack( ) ).

    page->simple_form(
              editable = abap_true
         )->content( `form`
             )->title( `Keyboard on/off`
             )->label( `Input (numeric keyboard)`
             )->input(
                 id               = `ZINPUT`
                 value            = client->_bind_edit( input )
                 showvaluehelp    = abap_true
                 valuehelprequest = client->_event( `CALL_KEYBOARD` )
                 valuehelpiconsrc = `sap-icon://keyboard-and-mouse` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `CALL_KEYBOARD` ).
      client->action->gen(
          val   = z2ui5_if_client=>cs_event-keyboard_set_mode
          t_arg = VALUE #( ( `ZINPUT` ) ( `none` ) ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
