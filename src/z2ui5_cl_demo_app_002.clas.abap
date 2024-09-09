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

    DATA client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_002 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(lv_script) = `` && |\n| &&
                        `function setInputFIlter(){` && |\n| &&
                        ` var inp = sap.z2ui5.oView.byId('suggInput');` && |\n| &&
                        ` inp.setFilterFunction(function(sValue, oItem){` && |\n| &&
                        `   var aSplit = sValue.split(" ");` && |\n| &&
                        `   if (aSplit.length > 0) {` && |\n| &&
                        `     var sTermNew = aSplit.slice(-1)[0];` && |\n| &&
                        `     sTermNew.trim();` && |\n| &&
                        `     if (sTermNew) {` && |\n| &&
                        `       return oItem.getText().match(new RegExp(sTermNew, "i"));` && |\n| &&
                        `     }` && |\n| &&
                        `   }` && |\n| &&
                        ` });` && |\n| &&
                        `}`.


      client->view_display( z2ui5_cl_xml_view=>factory(
       )->_z2ui5( )->timer(  client->_event( `START` )
         )->_generic( ns = `html` name = `script` )->_cc_plain_xml( lv_script
         )->stringify( ) ).


      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BUTTON_MCUSTOM'.
*        send type = '' is mandatory in order to not break current implementation
        client->message_box_display( type = '' text = 'Custom MessageBox' icon = `SUCCESS`
                                     title = 'Custom MessageBox' actions = VALUE #( ( `First Button` ) ( `Second Button` ) ) emphasizedaction = `First Button`
                                     onclose = `callMessageToast()` details = `<h3>these are details</h3>`).
      WHEN 'BUTTON_MCONFIRM'.
        client->message_box_display( type = 'confirm' text = 'Confirm MessageBox' ).
      WHEN 'BUTTON_MALERT'.
        client->message_box_display( type = 'alert' text = 'Alert MessageBox' ).
      WHEN 'BUTTON_MERROR'.
        client->message_box_display( type = 'error' text = 'Error MessageBox' ).
      WHEN 'BUTTON_MINFO'.
        client->message_box_display( type = 'information' text = 'Information MessageBox' ).
      WHEN 'BUTTON_MWARNING'.
        client->message_box_display( type = 'warning' text = 'Warning MessageBox' ).
      WHEN 'BUTTON_MSUCCESS'.
        client->message_box_display( type = 'success' text = 'Success MessageBox' icon = `sap-icon://accept` ).
      WHEN 'BUTTON_SEND'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->message_toast_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( ).

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
        ( descr = 'Gray'   value = 'GRAY' )
        ( descr = 'Blue2'  value = 'BLUE2' )
        ( descr = 'Blue3'  value = 'BLUE3' ) ).

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( `function callMessageToast(sAction) { sap.m.MessageToast.show('Hello there !!'); }` ).
    DATA(page) = view->shell(
         )->page(
          showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title          = 'abap2UI5 - Selection-Screen Example'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    grid->simple_form( title = 'Input' editable = abap_true
        )->content( 'form'
            )->label( 'Input with suggestion items'
            )->input(
                    id              = `suggInput`
                    value           = client->_bind_edit( screen-colour )
                    placeholder     = 'Fill in your favorite color'
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
    )->segmented_button( selected_key = client->_bind_edit( screen-segment_key )
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
         )->text( text = `MessageBox Types`
         )->button(
             text  = 'Confirm'
             press = client->_event( 'BUTTON_MCONFIRM' )
         )->button(
             text  = 'Alert'
             press = client->_event( 'BUTTON_MALERT' )
         )->button(
             text  = 'Error'
             press = client->_event( 'BUTTON_MERROR' )
         )->button(
             text  = 'Information'
             press = client->_event( 'BUTTON_MINFO' )
         )->button(
             text  = 'Warning'
             press = client->_event( 'BUTTON_MWARNING' )
         )->button(
             text  = 'Success'
             press = client->_event( 'BUTTON_MSUCCESS' )
         )->button(
             text  = 'Custom'
             press = client->_event( 'BUTTON_MCUSTOM' )
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


    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( `setInputFIlter()` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
