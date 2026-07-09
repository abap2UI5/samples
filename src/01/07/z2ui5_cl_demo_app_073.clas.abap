CLASS z2ui5_cl_demo_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_073 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    client->view_display( view->shell(
          )->page(
                  title          = `abap2UI5 - Open New Tab`
                  navbuttonpress = client->_event_nav_app_leave( )
                  shownavbutton  = client->check_app_prev_stack( )
              )->simple_form( title    = `Form Title`
                              editable = abap_true
                  )->content( `form`
                      )->button(
                          text  = `open new tab`
                          press = client->_event( val = `BUTTON_OPEN_NEW_TAB` )
           )->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN `BUTTON_OPEN_NEW_TAB`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-open_new_tab
            t_arg = VALUE #( ( `https://www.google.com/search?q=abap2ui5&oq=abap2ui5,123` ) ) ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
