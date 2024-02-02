CLASS z2ui5_cl_demo_app_002 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF screen,
        check_is_active TYPE abap_bool,
        colour          TYPE string,
        combo_key       TYPE string,
        combo_key2      TYPE string,
        segment_key     TYPE string,
        date            TYPE string,
        date_time       TYPE string,
        time_start      TYPE string,
        time_end        TYPE string,
        check_switch_01 TYPE abap_bool VALUE abap_false,
        check_switch_02 TYPE abap_bool VALUE abap_false,
      END OF screen.

    TYPES:
      BEGIN OF s_suggestion_items,
        value TYPE string,
        descr TYPE string,
      END OF s_suggestion_items.
    DATA mt_suggestion TYPE STANDARD TABLE OF s_suggestion_items WITH EMPTY KEY.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.

    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY.



    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_002 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      z2ui5_on_rendering( client ).
    ENDIF.

    z2ui5_on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_SEND'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->message_toast_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    screen = VALUE #(
        check_is_active = abap_true
        colour          = 'BLUE'
        combo_key       = 'GRAY'
        segment_key     = 'GREEN'
        date            = '07.12.22'
        date_time       = '23.12.2022, 19:27:20'
        time_start      = '05:24:00'
        time_end        = '17:23:57').

    mt_suggestion = VALUE #(
        ( descr = 'Green'  value = 'GREEN' )
        ( descr = 'Blue'   value = 'BLUE' )
        ( descr = 'Black'  value = 'BLACK' )
        ( descr = 'Grey'   value = 'GREY' )
        ( descr = 'Blue2'  value = 'BLUE2' )
        ( descr = 'Blue3'  value = 'BLUE3' ) ).

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    data(page) = view->shell(
         )->page(
          showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title          = 'abap2UI5 - Selection-Screen Example'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

      page->header_content(
               )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
               )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
           )->get_parent( ).
    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    grid->simple_form( title = 'Input' editable = abap_true
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( screen-colour )
                    placeholder     = 'fill in your favorite colour'
                    suggestionitems = client->_bind( mt_suggestion )
                    showsuggestion  = abap_true )->get(
                )->suggestion_items( )->get(
                    )->list_item(
                        text = '{VALUE}'
                        additionaltext = '{DESCR}' ).

    grid->simple_form( title = 'Time Inputs' editable = abap_true
        )->content( 'form'
            )->label( 'Date'
            )->date_picker( client->_bind_edit( screen-date )
            )->label( 'Date and Time'
            )->date_time_picker( client->_bind_edit( screen-date_time )
            )->label( 'Time Begin/End'
            )->time_picker( client->_bind_edit( screen-time_start )
            )->time_picker( client->_bind_edit( screen-time_end ) ).


    DATA(form) = grid->get_parent( )->get_parent( )->grid( 'L12 M12 S12'
        )->content( 'layout'
            )->simple_form( title = 'Input with select options' editable = abap_true
                )->content( 'form' ).

    DATA(lv_test) = form->label( 'Checkbox'
         )->checkbox(
             selected = client->_bind_edit( screen-check_is_active )
             text     = 'this is a checkbox'
             enabled  = abap_true ).

    lv_test->label( 'Combobox'
      )->combobox(
          selectedkey = client->_bind_edit( screen-combo_key )
          items       = client->_bind_local( VALUE ty_t_combo(
                  ( key = 'BLUE'  text = 'green' )
                  ( key = 'GREEN' text = 'blue' )
                  ( key = 'BLACK' text = 'red' )
                  ( key = 'GRAY'  text = 'gray' ) ) )
              )->item(
                  key = '{KEY}'
                  text = '{TEXT}'
      )->get_parent( )->get_parent( ).

    lv_test->label( 'Combobox2'
      )->combobox(
          selectedkey = client->_bind_edit( screen-combo_key2 )
          items       = client->_bind_local( VALUE ty_t_combo(
                  ( key = 'BLUE'  text = 'green' )
                  ( key = 'GREEN' text = 'blue' )
                  ( key = 'BLACK' text = 'red' )
                  ( key = 'GRAY'  text = 'gray' ) ) )
              )->item(
                  key = '{KEY}'
                  text = '{TEXT}'
      )->get_parent( )->get_parent( ).

    lv_test->label( 'Segmented Button'
    )->segmented_button( client->_bind_edit( screen-segment_key )
        )->items(
            )->segmented_button_item(
                key = 'BLUE'
                icon = 'sap-icon://accept'
                text = 'blue'
            )->segmented_button_item(
                key = 'GREEN'
                icon = 'sap-icon://add-favorite'
                text = 'green'
            )->segmented_button_item(
                key = 'BLACK'
                icon = 'sap-icon://attachment'
                text = 'black'
   )->get_parent( )->get_parent(

   )->label( 'Switch disabled'
   )->switch(
        enabled       = abap_false
        customtexton  = 'A'
        customtextoff = 'B'
   )->label( 'Switch accept/reject'
   )->switch(
        state         = client->_bind_edit( screen-check_switch_01 )
        customtexton  = 'on'
        customtextoff = 'off'
        type = 'AcceptReject'
   )->label( 'Switch normal'
   )->switch(
        state         = client->_bind_edit( screen-check_switch_02 )
        customtexton  = 'YES'
        customtextoff = 'NO' ).

    page->footer( )->overflow_toolbar(
         )->toolbar_spacer(
         )->button(
             text  = 'Clear'
             press = client->_event( 'BUTTON_CLEAR' )
             type  = 'Reject'
             icon  = 'sap-icon://delete'
         )->button(
             text  = 'Send to Server'
             press = client->_event( 'BUTTON_SEND' )
             type  = 'Success' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
