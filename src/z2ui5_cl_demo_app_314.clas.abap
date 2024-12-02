CLASS z2ui5_cl_demo_app_314 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_314 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = 'abap2UI5 - Table with odata source'
              navbuttonpress = client->_event( 'BACK' )
              shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

      DATA(tab) = page->table(
        items = `{odata>/BookingSupplement}`
        growing = abap_true
         ).
      tab->columns(
          )->column(  )->text( 'TravelID' )->get_parent(
          )->column( )->text( 'BookingID' )->get_parent(
          )->column( )->text( 'BookingSupplementID' )->get_parent(
          )->column( )->text( 'SupplementID' )->get_parent(
          )->column( )->text( 'SupplementText' )->get_parent(
          )->column( )->text( 'Price' )->get_parent(
          )->column( )->text( 'CurrencyCode' )->get_parent(
          ).

      tab->items( )->column_list_item( )->cells(
         )->text( '{odata>TravelID}'
         )->text( '{odata>BookingID}'
         )->text( '{odata>BookingSupplementID}'
         )->text( '{odata>SupplementID}'
         )->text( '{odata>SupplementText}'
         )->text( '{odata>Price}'
         )->text( '{odata>CurrencyCode}'
         ).

      client->view_display( view->stringify( ) ).
      client->follow_up_action(
        client->_event_client(
            val   = z2ui5_if_client=>cs_event-set_odata_model
            t_arg = value #(
                     ( `/sap/opu/odata/DMO/API_TRAVEL_U_V2/` )
                     ( `odata` ) ) ) ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
