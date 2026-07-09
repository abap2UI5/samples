CLASS z2ui5_cl_demo_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA title TYPE string VALUE `my title`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_125 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->shell(
          )->page(
              title          = `abap2UI5 - Change Browser Title`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( )
              )->simple_form(
                  title    = `Form Title`
                  editable = abap_true
                  )->content( `form`
                  )->label( `title`
                  )->input( client->_bind_edit( title )
                  )->button(
                      text  = `Set Title`
                      press = client->_event( `SET_TITLE` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `SET_TITLE` ).

      client->action->gen(
          val   = z2ui5_if_client=>cs_event-set_title
          t_arg = VALUE #( ( title ) ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
