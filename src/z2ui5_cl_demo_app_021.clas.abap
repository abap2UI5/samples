CLASS Z2UI5_CL_DEMO_APP_021 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        selkz    TYPE abap_bool,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_textarea TYPE string.
    DATA mv_stretch_active TYPE abap_bool.

    DATA:
      BEGIN OF ms_popup_input,
        value1          TYPE string,
        value2          TYPE string,
        check_is_active TYPE abap_bool,
        combo_key       TYPE string,
      END OF ms_popup_input.

    DATA t_bapiret TYPE bapirettab.

    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO Z2UI5_if_client.

    METHODS ui5_view_display.
    METHODS ui5_popup_decide.
    METHODS ui5_popup_textarea_size.
    METHODS ui5_popup_textarea.
    METHODS ui5_popup_input.
    METHODS ui5_popup_table.
    METHODS ui5_handle_event.
    METHODS ui5_init.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_021 IMPLEMENTATION.


  METHOD ui5_handle_event.

    CASE client->get( )-event.

      WHEN 'POPUP_TO_DECIDE'.
        ui5_popup_decide( ).

      WHEN 'BUTTON_CONFIRM'.
        client->popup_destroy( ).
        client->message_toast_display( 'confirm pressed' ).

      WHEN 'BUTTON_CANCEL'.
        client->popup_destroy(  ).
        client->message_toast_display( 'cancel pressed' ).

      WHEN 'POPUP_TO_TEXTAREA'.
        mv_stretch_active = abap_false.
        ui5_popup_textarea( ).

      WHEN 'POPUP_TO_TEXTAREA_STRETCH'.
        mv_stretch_active = abap_true.
        ui5_popup_textarea( ).

      WHEN 'POPUP_TO_TEXTAREA_SIZE'.
        ui5_popup_textarea_size( ).

      WHEN 'BUTTON_TEXTAREA_CANCEL'.
        client->popup_destroy( ).
        client->message_toast_display( 'textarea deleted' ).
        CLEAR mv_textarea.

      WHEN 'BUTTON_TEXTAREA_CONFIRM'.
        client->popup_destroy( ).

      WHEN 'POPUP_TO_INPUT'.
        ms_popup_input-value1 = 'value1'.
        ui5_popup_input( ).

      WHEN 'POPUP_TABLE'.
        CLEAR t_tab.
        DO 10 TIMES.
          DATA(ls_row) = VALUE ty_row( title = 'entry_' && sy-index  value = 'red' info = 'completed'  descr = 'this is a description' ).
          INSERT ls_row INTO TABLE t_tab.
        ENDDO.
        ui5_popup_table( ).

      WHEN 'POPUP_TABLE_CONTINUE'.
        client->popup_destroy( ).
        DELETE t_tab WHERE selkz = abap_false.
        client->message_toast_display( `Entry selected: ` && VALUE #( t_tab[ 1 ]-title DEFAULT `no entry selected` )  ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_init.

    t_bapiret = VALUE #(
      ( message = 'An empty Report field causes an empty XML Message to be sent' type = 'E' id = 'MSG1' number = '001' )
      ( message = 'Check was executed for wrong Scenario' type = 'E' id = 'MSG1' number = '002' )
      ( message = 'Request was handled without errors' type = 'S' id = 'MSG1' number = '003' )
      ( message = 'product activated' type = 'S' id = 'MSG4' number = '375' )
      ( message = 'check the input values' type = 'W' id = 'MSG2' number = '375' )
      ( message = 'product already in use' type = 'I' id = 'MSG2' number = '375' )
       ).

  ENDMETHOD.


  METHOD ui5_popup_decide.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( client )->dialog(
                title = 'Title'
                icon = 'sap-icon://question-mark'
            )->content(
                )->vbox( 'sapUiMediumMargin'
                    )->text( 'This is a question, you have to make a decision now, cancel or confirm?'
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


  METHOD ui5_popup_input.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( client )->dialog(
       contentheight = '500px'
       contentwidth  = '500px'
       title = 'Title'
       )->content(
           )->simple_form(
               )->label( 'Input1'
               )->input( client->_bind_edit( ms_popup_input-value1 )
               )->label( 'Input2'
               )->input( client->_bind_edit( ms_popup_input-value2 )
               )->label( 'Checkbox'
               )->checkbox(
                   selected = client->_bind_edit( ms_popup_input-check_is_active )
                   text     = 'this is a checkbox'
                   enabled  = abap_true
       )->get_parent( )->get_parent(
       )->footer( )->overflow_toolbar(
           )->toolbar_spacer(
           )->button(
               text  = 'Cancel'
               press = client->_event( 'BUTTON_TEXTAREA_CANCEL' )
           )->button(
               text  = 'Confirm'
               press = client->_event( 'BUTTON_TEXTAREA_CONFIRM' )
               type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_popup_table.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( client )->dialog( 'abap2UI5 - Popup to select entry'
           )->table(
               mode = 'SingleSelectLeft'
               items = client->_bind_edit( t_tab )
               )->columns(
                   )->column( )->text( 'Title' )->get_parent(
                   )->column( )->text( 'Color' )->get_parent(
                   )->column( )->text( 'Info' )->get_parent(
                   )->column( )->text( 'Description' )->get_parent(
               )->get_parent(
               )->items( )->column_list_item( selected = '{SELKZ}'
                   )->cells(
                       )->text( '{TITLE}'
                       )->text( '{VALUE}'
                       )->text( '{INFO}'
                       )->text( '{DESCR}'
           )->get_parent( )->get_parent( )->get_parent( )->get_parent(
           )->footer( )->overflow_toolbar(
               )->toolbar_spacer(
               )->button(
                   text  = 'continue'
                   press = client->_event( 'POPUP_TABLE_CONTINUE' )
                   type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_popup_textarea.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( client )->dialog(
              stretch = mv_stretch_active
              title = 'Title'
              icon = 'sap-icon://edit'
          )->content(
              )->text_area(
                  height = '100%'
                  width  = '100%'
                  value  = client->_bind_edit( mv_textarea )
          )->get_parent(
          )->footer( )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'Cancel'
                  press = client->_event( 'BUTTON_TEXTAREA_CANCEL' )
              )->button(
                  text  = 'Confirm'
                  press = client->_event( 'BUTTON_TEXTAREA_CONFIRM' )
                  type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_popup_textarea_size.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( client )->dialog(
               contentheight = '100px'
               contentwidth  = '1200px'
               title         = 'Title'
               icon          = 'sap-icon://edit'
           )->content(
               )->text_area(
                   height = '95%'
                   width  = '99%'
                   value  = client->_bind_edit( mv_textarea )
          )->get_parent(
          )->footer( )->overflow_toolbar(
               )->toolbar_spacer(
               )->button(
                   text  = 'Cancel'
                   press = client->_event( 'BUTTON_TEXTAREA_CANCEL' )
               )->button(
                   text  = 'Confirm'
                   press = client->_event( 'BUTTON_TEXTAREA_CONFIRM' )
                   type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_view_display.

    DATA(view) = Z2UI5_cl_xml_view=>factory( client ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Popups'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1637163852264624139'
                )->link(
                    text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
           )->get_parent( ).

    DATA(grid) = page->grid( 'L8 M12 S12' )->content( 'layout' ).

    grid->simple_form( 'Decide' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup to decide'
            press = client->_event( 'POPUP_TO_DECIDE' ) ).

    grid->simple_form( 'TextArea' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup with textarea input'
            press = client->_event( 'POPUP_TO_TEXTAREA' )
        )->label( '02'
        )->button(
            text  = 'Popup with textarea input (size)'
            press = client->_event( 'POPUP_TO_TEXTAREA_SIZE' )
        )->label( '03'
        )->button(
            text  = 'Popup with textarea input (stretched)'
            press = client->_event( 'POPUP_TO_TEXTAREA_STRETCH' ) ).

    grid->simple_form( 'Inputs' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup Get Input Values'
            press = client->_event( 'POPUP_TO_INPUT' ) ).

    grid->simple_form( 'Tables' )->content( 'form'
        )->label( '02'
        )->button(
            text  = 'Popup to select'
            press = client->_event( 'POPUP_TABLE' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_init( ).
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_display( ).
    ENDIF.

    ui5_handle_event( ).

  ENDMETHOD.
ENDCLASS.
