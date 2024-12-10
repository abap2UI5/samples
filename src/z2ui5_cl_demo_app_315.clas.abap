CLASS z2ui5_cl_demo_app_315 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_315 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = 'abap2UI5 - Table with odata source'
              navbuttonpress = client->_event( 'BACK' )
              shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

     data(tab) = page->table(
        items = `{TRAVEL>/BookingSupplement}`
        growing = abap_true ).

    tab->header_toolbar( )->toolbar(
      )->title( 'table with OData model TRAVEL' ).

    tab->columns(
      )->column(  )->text( 'TravelID' )->get_parent(
      )->column( )->text( 'BookingID' )->get_parent(
      )->column( )->text( 'BookingSupplementID' )->get_parent(
      )->column( )->text( 'SupplementID' )->get_parent(
      )->column( )->text( 'SupplementText' )->get_parent(
      )->column( )->text( 'Price' )->get_parent(
      )->column( )->text( 'CurrencyCode' )->get_parent( ).

    tab->items( )->column_list_item( )->cells(
      )->text( '{TRAVEL>TravelID}'
      )->text( '{TRAVEL>BookingID}'
      )->text( '{TRAVEL>BookingSupplementID}'
      )->text( '{TRAVEL>SupplementID}'
      )->text( '{TRAVEL>SupplementText}'
      )->text( '{TRAVEL>Price}'
      )->text( '{TRAVEL>CurrencyCode}' ).

    tab = page->table(
      items = `{FLIGHT>/Airport}`
      growing = abap_true ).

    tab->header_toolbar( )->toolbar(
      )->title( 'table with odata model FLIGHT' ).

    tab->columns(
      )->column(  )->text( 'AirportID' )->get_parent(
      )->column( )->text( 'Name' )->get_parent(
      )->column( )->text( 'City' )->get_parent(
      )->column( )->text( 'CountryCode' )->get_parent( ).

    tab->items( )->column_list_item( )->cells(
      )->text( '{FLIGHT>AirportID}'
      )->text( '{FLIGHT>Name}'
      )->text( '{FLIGHT>City}'
      )->text( '{FLIGHT>CountryCode}' ).

    client->view_display( val = view->stringify( ) switchdefaultmodelpath = `` ).

    client->follow_up_action( client->_event_client(
      val = z2ui5_if_client=>cs_event-set_odata_model
      t_arg = value #(
        ( `/sap/opu/odata/DMO/API_TRAVEL_U_V2/` )
        ( `TRAVEL` ) ) ) ).

    client->follow_up_action( client->_event_client(
      val = z2ui5_if_client=>cs_event-set_odata_model
      t_arg = value #(
        ( `/sap/opu/odata/DMO/ui_flight_r_v2/` )
        ( `FLIGHT` )  ) ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
