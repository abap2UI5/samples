CLASS z2ui5_cl_demo_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA title TYPE string VALUE `my title`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_125 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
      DATA temp1 TYPE string_table.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      view = z2ui5_cl_xml_view=>factory( ).
      
      page = view->shell(
          )->page(
              title          = `abap2UI5 - Change Browser Title`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `Enter a title and press the button to run the set_title front-end action, which updates ` &&
                     `the browser tab title (document.title) without reloading the page.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form(
          title    = `Form Title`
          editable = abap_true
          )->content( `form`
          )->label( `title`
          )->input( client->_bind( title )
          )->button(
              text  = `Set Title`
              press = client->_event( `SET_TITLE` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `SET_TITLE` ) IS NOT INITIAL.

      
      CLEAR temp1.
      INSERT title INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_title
          t_arg = temp1 ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
