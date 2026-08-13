" @keywords reload refresh restart location_reload url
CLASS z2ui5_cl_smp_app_492 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA url TYPE string.
    DATA scratch TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_492 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(s_config) = client->get( )-s_config.
      url = s_config-pathname && s_config-search.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Browser - Reload the Page`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `The location_reload front-end action navigates the browser to a same-domain URL. The url field is ` &&
                     `prefilled with this page's own address, so the button reloads the app from scratch - type something ` &&
                     `into the scratch field first and watch it get lost. Cross-origin URLs are blocked by the framework.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form(
          title    = `Reload`
          editable = abap_true
          )->content( `form`
          )->label( `scratch input`
          )->input(
              value       = client->_bind( scratch )
              placeholder = `type something - it is lost after the reload`
          )->label( `url`
          )->input( client->_bind( url )
          )->button(
              text  = `Reload Page`
              press = client->_event( `RELOAD` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `RELOAD` ).

      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-location_reload
          t_arg = VALUE #( ( url ) ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
