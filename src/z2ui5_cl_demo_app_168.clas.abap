CLASS z2ui5_cl_demo_app_168 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
    METHODS get_file
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_168 IMPLEMENTATION.


  METHOD ui5_callback.

    TRY.
        DATA(lo_prev) = client->get_app( client->get(  )-s_draft-id_prev_app ).
        IF CAST z2ui5_cl_popup_file_download( lo_prev )->result( ).
          client->message_box_display( `the input is downloaded` ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup File Download'
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


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.
        DATA(lo_app) = z2ui5_cl_popup_file_download=>factory( get_file( ) ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_display( ).
      ui5_callback( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

  METHOD get_file.

    result = `test`.

  ENDMETHOD.

ENDCLASS.
