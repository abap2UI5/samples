" @keywords binding _bind model attribute value input button serialize
CLASS z2ui5_cl_smp_app_494 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA name     TYPE string.
    DATA greeting TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_494 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      name = `World`.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Basics II - Data Binding: Input and Button`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `client->_bind( name ) connects the public attribute NAME with the input ` &&
                     `below - in both directions. Type a name and leave the field: the text ` &&
                     `next to it changes without any ABAP code, because both are bound to the ` &&
                     `same attribute. Press Greet and the backend reads NAME - already filled ` &&
                     `in, no event argument needed - and writes GREETING back into the view.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form(
          title    = `Data Binding`
          editable = abap_true
          )->content( `form`
          )->label( `your name`
          )->input( client->_bind( name )
          )->label( `bound to the same attribute`
          )->text( client->_bind( name )
          )->label( `written by the backend`
          )->text( client->_bind( greeting )
          )->button(
              text  = `Greet`
              press = client->_event( `GREET` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `GREET` ).
      greeting = |Hello { name }!|.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
