CLASS z2ui5_cl_app_demo_63 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF screen,
        check_is_active TYPE abap_bool,
        colour          TYPE string,
      END OF screen.

    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO z2ui5_if_client.

    DATA:
      BEGIN OF ms_popup_input,
        name TYPE string,
        user TYPE string,
      END OF ms_popup_input.

    DATA mt_data TYPE STANDARD TABLE OF z2ui5_t_demo_01.
    METHODS popup_display.

  PROTECTED SECTION.

    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_63 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_rendering( client ).
    ENDIF.

    SELECT FROM z2ui5_t_demo_01
        FIELDS *
        WHERE name = 'TEST02'
        INTO TABLE @mt_data.

    z2ui5_on_event( client ).

    COMMIT WORK.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_CONFIRM'.

        MODIFY z2ui5_t_demo_01 FROM @( VALUE #(
           uuid = client->get( )-id name = 'TEST02' game = ms_popup_input-name ) ).
        COMMIT WORK.

       client->popup_close( ).

      WHEN 'BUTTON_ADD'.
        popup_display( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_on_rendering.

    DATA(page) = z2ui5_cl_xml_view=>factory( client )->shell(
         )->page(
            title          = 'abap2UI5 - Sessions'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = page->hlp_get_source_code_url(  )
         )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA(tab) = grid->table(
            items = client->_bind_edit( mt_data )
            mode  = 'MultiSelect'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'Active Session:'
                )->toolbar_spacer(
                )->button(
                    icon  = 'sap-icon://delete'
                    text  = 'Delete'
                    press = client->_event( 'BUTTON_DELETE' )
                )->button(
                    icon  = 'sap-icon://add'
                    text  = 'New'
                    press = client->_event( 'BUTTON_ADD' )
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Name' )->get_parent(
          )->column(
            )->text( 'UUID' )->get_parent(
     ).

    tab->items( )->column_list_item( selected = '{SELKZ}'
      )->cells(
          )->text( text = '{GAME}'
          )->text( text = '{UUID}'
           ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD popup_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client )->dialog(
          contentheight = '500px'
          contentwidth  = '500px'
          title = 'Title'
          )->content(
              )->simple_form(
                  )->label( 'Name Session'
                  )->input( client->_bind_edit( ms_popup_input-name )
                  )->label( 'Name User'
                  )->input( client->_bind_edit( ms_popup_input-user )
                  )->label( 'Checkbox'
          )->get_parent( )->get_parent(
          )->footer( )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'Cancel'
                  press = client->_event( 'BUTTON_CANCEL' )
              )->button(
                  text  = 'Confirm'
                  press = client->_event( 'BUTTON_CONFIRM' )
                  type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
