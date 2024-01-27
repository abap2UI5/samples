CLASS z2ui5_cl_demo_app_154 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    DATA mv_check_initialized TYPE abap_bool.
    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_154 IMPLEMENTATION.


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        DATA(lo_app) = z2ui5_cl_popup_messages=>factory( VALUE #(
            ( message = 'An empty Report field causes an empty XML Message to be sent' type = 'E' id = 'MSG1' number = '001' )
            ( message = 'Check was executed for wrong Scenario' type = 'E' id = 'MSG1' number = '002' )
            ( message = 'Request was handled without errors' type = 'S' id = 'MSG1' number = '003' )
            ( message = 'product activated' type = 'S' id = 'MSG4' number = '375' )
            ( message = 'check the input values' type = 'W' id = 'MSG2' number = '375' )
            ( message = 'product already in use' type = 'I' id = 'MSG2' number = '375' )
       ) ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup Messages'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                    )->get_parent(
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      IF mv_check_initialized = abap_false.
        mv_check_initialized = abap_true.
        ui5_display( ).
      ELSE.
        ui5_callback( ).
      ENDIF.
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

  METHOD ui5_callback.

    TRY.
        DATA(lo_prev) = client->get_app( client->get(  )-s_draft-id_prev_app ).
        DATA(lo_dummy) = CAST z2ui5_cl_popup_messages( lo_prev ).
        client->message_box_display( `callback after popup messages` ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
