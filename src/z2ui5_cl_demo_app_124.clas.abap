CLASS z2ui5_cl_demo_app_124 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA mv_scan_input TYPE string.
    DATA mv_scan_type TYPE string.
    DATA check_initialized TYPE abap_bool .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_124 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.


    "on init
    IF check_initialized = abap_false.
      check_initialized = abap_true.

    ENDIF.


    "user command
    CASE client->get( )-event.

      WHEN 'ON_SCAN_SUCCESS'.
           client->message_box_display( `Scan finished!`).
        DATA(lt_arg) = client->get( )-t_event_arg.
        mv_scan_input = lt_arg[ 1 ].
        mv_scan_type  = lt_arg[ 2 ].
        client->view_model_update( ).
        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.

    ENDCASE.


    "render view
    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton  = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = view->hlp_get_source_code_url(  )
                      target = '_blank'
              )->get_parent(
              )->simple_form( title = 'Information' editable = abap_true
                  )->content( 'form'
                      )->label( 'mv_scan_input'
                      )->input( client->_bind_edit( mv_scan_input )
                      )->label( `mv_scan_type`
                      )->input( client->_bind_edit( mv_scan_type )
                      )->label( `scanner`
                      )->barcode_scanner_button(
*                        id              =
                        scansuccess     = client->_event( val = 'ON_SCAN_SUCCESS' t_arg = value #( ( `${$event>/text}` ) ( `${$event>/type}` ) ) )
*                        scanfail        =
*                        inputliveupdate =
                        dialogtitle     = `Barcode Scanner`

           )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
