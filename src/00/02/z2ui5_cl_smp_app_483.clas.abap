CLASS z2ui5_cl_smp_app_483 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF nav_params,
        product  TYPE string,
        quantity TYPE string,
      END OF nav_params.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_483 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      nav_params-product  = `102343333`.
      nav_params-quantity = `500`.

      IF client->get( )-check_launchpad_active = abap_false.
        client->message_box_display( `No Launchpad Active, Sample not working!` ).
      ENDIF.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
            )->page(
                    showheader     = xsdbool( abap_false = client->get( )-check_launchpad_active )
                    title          = `abap2UI5 - Launchpad - Cross-App Navigation (Sender)`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `SENDER side of launchpad cross-app navigation: the button navigates to ` &&
                     `the receiver tile via _event_client( cs_event-cross_app_nav_to_ext ), ` &&
                     `handing over the bound Product and Quantity values as navigation ` &&
                     `parameters - the receiver (z2ui5_cl_smp_app_484) reads them from its ` &&
                     `startup parameters. ` &&
                     `Only works inside a launchpad with both tiles configured.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form( title    = `Cross-App Navigation - Sender`
                         editable = abap_true
          )->content( `form`
              )->label( `Product (sent as navigation parameter)`
              )->input( client->_bind( nav_params-product )
              )->label( `Quantity (sent as navigation parameter)`
              )->input( client->_bind( nav_params-quantity )
              )->button( text    = `back to the previous app`
                         visible = client->get( )-check_launchpad_active
                         press   = client->_event_client( client->cs_event-cross_app_nav_to_prev_app )
              )->button(
                  text    = `navigate to the receiver app`
                  visible = client->get( )-check_launchpad_active
                  press   = client->_event_client(
                      val   = client->cs_event-cross_app_nav_to_ext
                      t_arg = VALUE #(
                          ( `{ semanticObject: "Z2UI5_CL_LP_SAMPLE_04",  action: "display" }` )
                          ( `$` && client->_bind( nav_params ) ) ) ) ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
