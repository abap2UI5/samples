CLASS z2ui5_cl_demo_app_124 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA mv_scan_input TYPE string.
    DATA mv_scan_type TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_124 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

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

    client->view_display( z2ui5_cl_ui5=>_factory( )->_ns_m( )->shell(
          )->page(
                 showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
                  title          = 'abap2UI5'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->headercontent(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code(  )
                      target = '_blank'
              )->_go_up( )->_ns_ui(
              )->simpleform( title = 'Information' editable = abap_true
                  )->content( )->_ns_m(
                      )->label( 'mv_scan_input'
                      )->input( client->_bind_edit( mv_scan_input )
                      )->label( `mv_scan_type`
                      )->input( client->_bind_edit( mv_scan_type )
                      )->label( `scanner` )->_ns_ndc(
                      )->barcodescannerbutton(
                        scansuccess     = client->_event( val = 'ON_SCAN_SUCCESS' t_arg = VALUE #( ( `${$parameters>/text}` ) ( `${$parameters>/format}` ) ) )
                        dialogtitle     = `Barcode Scanner`
           )->_stringify( ) ).

  ENDMETHOD.
ENDCLASS.
