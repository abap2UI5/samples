CLASS z2ui5_cl_demo_app_110 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA product TYPE string .
    DATA quantity TYPE string .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_display_view.


  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_110 IMPLEMENTATION.


  METHOD z2ui5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
      )->page(
              title          = 'abap2UI5 - Popover Examples'
              navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
              shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
          )->header_content(
              )->link( text = 'Demo' target = '_blank' href = `https://twitter.com/abap2UI5/status/1643899059839672321`
              )->link(
                  text = 'Source_Code' target = '_blank'
                  href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
          )->get_parent(
          )->simple_form( title = 'Mask Input' layout = 'ColumnLayout' editable = abap_true
*              )->content( 'form'
                  )->label( text = 'Mask Input'
                  )->mask_input( mask = '~~~~~~~~~~' placeholdersymbol = '_' placeholder = 'All characters allowed' )->get(
                    )->rules(
                      )->mask_input_rule( maskformatsymbol = '~' regex = '"[^_]'
                    )->get_parent( )->get_parent( )->get_parent(
                 )->label( text = `Promo code`
                 )->mask_input( mask = `**********` placeholdersymbol = `_` placeholder = `Latin characters (case insensitive) and numbers` )->get(
                  )->rules(
                    )->mask_input_rule(
                  )->get_parent( )->get_parent( )->get_parent(
                )->label( text = `Phone number`
                 )->mask_input( mask = `(999) 999 999999` placeholdersymbol = `_` placeholder = `Enter twelve-digit number` showclearicon = abap_true )->get(
                  )->rules(
                    )->mask_input_rule(
                  )->get_parent( )->get_parent( )->get_parent(  )->get_parent(

          )->simple_form( title = 'Possible usages (may require additional coding)' layout = 'ColumnLayout' editable = abap_true
                )->label( text = `Serial number`
                 )->mask_input( mask = `CCCC-CCCC-CCCC-CCCC-CCCC` placeholdersymbol = `_` placeholder = `Enter digits and capital letters` showclearicon = abap_true )->get(
                  )->rules(
                    )->mask_input_rule( maskformatsymbol = `C` regex = `[A-Z0-9]`
                  )->get_parent( )->get_parent( )->get_parent(
                )->label( text = `Product activation key"`
                 )->mask_input( mask = `SAP-CCCCC-CCCCC` placeholdersymbol = `_` placeholder = `Starts with 'SAP' followed by digits and capital letters` showclearicon = abap_true )->get(
                  )->rules(
                    )->mask_input_rule( maskformatsymbol = `C` regex = `[A-Z0-9]`
                  )->get_parent( )->get_parent( )->get_parent(
                )->label( text = `ISBN`
                 )->mask_input( mask = `999-99-999-9999-9` placeholdersymbol = `_` placeholder = `Enter thirteen-digit number` showclearicon = abap_true )->get(
*                  )->rules(
*                    )->mask_input_rule(
*                  )->get_parent( )->get_parent( )->get_parent( )->get_parent( )->get_parent(
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

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.


  ENDMETHOD.
ENDCLASS.
