CLASS z2ui5_cl_app_demo_26 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA mv_placement TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_display_view.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_26 IMPLEMENTATION.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    view->popover(
                  title     = 'Popover Title'
                  placement = mv_placement
              )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
                  )->button(
                      text  = 'Cancel'
                      press = client->_event( 'BUTTON_CANCEL' )
                  )->button(
                      text  = 'Confirm'
                      press = client->_event( 'BUTTON_CONFIRM' )
                      type  = 'Emphasized'
                )->get_parent( )->get_parent(
            )->text(  'make an input here:'
            )->input( value = 'abcd'
            ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD z2ui5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    view->shell(
      )->page(
              title          = 'abap2UI5 - Popover Examples'
              navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
              shownavbutton  = abap_true
          )->header_content(
              )->link( text = 'Demo' target = '_blank' href = `https://twitter.com/abap2UI5/status/1643899059839672321`
              )->link(
                  text = 'Source_Code' target = '_blank'
                  href = view->hlp_get_source_code_url( )
          )->get_parent(
          )->simple_form( 'Popover'
              )->content( 'form'
                  )->title( 'Input'
                  )->label( 'Link'
                  )->link(  text = 'Documentation UI5 Popover Control' href = 'https://openui5.hana.ondemand.com/entity/sap.m.Popover'
                  )->label( 'placement'
                  )->segmented_button( client->_bind_edit( mv_placement )
                        )->items(
                        )->segmented_button_item(
                                key = 'Left'
                                icon = 'sap-icon://add-favorite'
                                text = 'Left'
                        )->segmented_button_item(
                                key = 'Top'
                                icon = 'sap-icon://accept'
                                text = 'Top'
                        )->segmented_button_item(
                                key = 'Bottom'
                                icon = 'sap-icon://accept'
                                text = 'Bottom'
                        )->segmented_button_item(
                                key = 'Right'
                                icon = 'sap-icon://attachment'
                                text = 'Right'
                  )->get_parent( )->get_parent(
                  )->label( 'popover'
                  )->button(
                      text  = 'show'
                      press = client->_event( 'POPOVER' )
                      id = 'TEST'
                  )->button(
                      text  = 'cancel'
                      press = client->_event( 'POPOVER' )
                )->button(
                      text  = 'post'
                      press = client->_event( 'POPOVER' )
          ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      z2ui5_display_view( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'POPOVER'.
        z2ui5_display_popover( `TEST` ).

      WHEN 'BUTTON_CONFIRM'.
        client->message_toast_display( |confirm| ).
        client->popover_destroy( ).

      WHEN 'BUTTON_CANCEL'.
        client->message_toast_display( |cancel| ).
        client->popover_destroy( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    mv_placement = 'Left'.
    product  = 'tomato'.
    quantity = '500'.

  ENDMETHOD.
ENDCLASS.
