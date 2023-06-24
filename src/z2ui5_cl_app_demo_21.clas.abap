CLASS z2ui5_cl_app_demo_21 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

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
    DATA mv_popup_name TYPE string.
    DATA mv_main_xml TYPE string.
    DATA mv_popup_xml TYPE string.
    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS view_popup_decide
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS view_popup_textarea_size
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS view_popup_textarea
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS view_popup_input
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS view_popup_table
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_21 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Popups'
                navbuttonpress = client->__event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1637163852264624139'
                )->link(
                    text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url( )
           )->get_parent( ).

    DATA(grid) = page->grid( 'L8 M12 S12' )->content( 'layout' ).

    grid->simple_form( 'Decide' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup to decide'
            press = client->__event( 'POPUP_TO_DECIDE' ) ).

    grid->simple_form( 'TextArea' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup with textarea input'
            press = client->__event( 'POPUP_TO_TEXTAREA' )
        )->label( '02'
        )->button(
            text  = 'Popup with textarea input (size)'
            press = client->__event( 'POPUP_TO_TEXTAREA_SIZE' )
        )->label( '03'
        )->button(
            text  = 'Popup with textarea input (stretched)'
            press = client->__event( 'POPUP_TO_TEXTAREA_STRETCH' ) ).

    grid->simple_form( 'Inputs' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup Get Input Values'
            press = client->__event( 'POPUP_TO_INPUT' ) ).

    grid->simple_form( 'Tables' )->content( 'form'
        )->label( '02'
        )->button(
            text  = 'Popup to select'
            press = client->__event( 'POPUP_TABLE' ) ).

    client->set_view( view->stringify( ) ).

  ENDMETHOD.


  METHOD view_popup_decide.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    DATA(popup) = view->dialog(
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
                    press = client->__event( 'BUTTON_CANCEL' )
                )->button(
                    text  = 'Confirm'
                    press = client->__event( 'BUTTON_CONFIRM' )
                    type  = 'Emphasized' ).

    mv_popup_xml = popup->get_root( )->xml_get( ).

  ENDMETHOD.


  METHOD view_popup_input.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    DATA(popup) = view->dialog(
       contentheight = '500px'
       contentwidth  = '500px'
       title = 'Title'
       )->content(
           )->simple_form(
               )->label( 'Input1'
               )->input( client->__bind( ms_popup_input-value1 )
               )->label( 'Input2'
               )->input( client->__bind( ms_popup_input-value2 )
               )->label( 'Checkbox'
               )->checkbox(
                   selected = client->__bind( ms_popup_input-check_is_active )
                   text     = 'this is a checkbox'
                   enabled  = abap_true
       )->get_parent( )->get_parent(
       )->footer( )->overflow_toolbar(
           )->toolbar_spacer(
           )->button(
               text  = 'Cancel'
               press = client->__event( 'BUTTON_TEXTAREA_CANCEL' )
           )->button(
               text  = 'Confirm'
               press = client->__event( 'BUTTON_TEXTAREA_CONFIRM' )
               type  = 'Emphasized' ).

    mv_popup_xml = popup->get_root( )->xml_get( ).

  ENDMETHOD.


  METHOD view_popup_table.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    DATA(popup) = view->dialog( 'abap2UI5 - Popup to select entry'
           )->table(
               mode = 'SingleSelectLeft'
               items = client->__bind_edit( t_tab )
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
                   press = client->__event( 'POPUP_TABLE_CONTINUE' )
                   type  = 'Emphasized' ).

    mv_popup_xml = popup->get_root( )->xml_get( ).

  ENDMETHOD.


  METHOD view_popup_textarea.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    DATA(popup) = view->dialog(
              stretch = mv_stretch_active
              title = 'Title'
              icon = 'sap-icon://edit'
          )->content(
              )->text_area(
                  height = '100%'
                  width  = '100%'
                  value  = client->__bind_edit( mv_textarea )
          )->get_parent(
          )->footer( )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'Cancel'
                  press = client->__event( 'BUTTON_TEXTAREA_CANCEL' )
              )->button(
                  text  = 'Confirm'
                  press = client->__event( 'BUTTON_TEXTAREA_CONFIRM' )
                  type  = 'Emphasized' ).

    mv_popup_xml = popup->get_root( )->xml_get( ).

  ENDMETHOD.


  METHOD view_popup_textarea_size.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    DATA(popup) = view->dialog(
               contentheight = '100px'
               contentwidth  = '1200px'
               title         = 'Title'
               icon          = 'sap-icon://edit'
           )->content(
               )->text_area(
                   height = '95%'
                   width  = '99%'
                   value  = client->__bind_edit( mv_textarea )
          )->get_parent(
          )->footer( )->overflow_toolbar(
               )->toolbar_spacer(
               )->button(
                   text  = 'Cancel'
                   press = client->__event( 'BUTTON_TEXTAREA_CANCEL' )
               )->button(
                   text  = 'Confirm'
                   press = client->__event( 'BUTTON_TEXTAREA_CONFIRM' )
                   type  = 'Emphasized' ).

    mv_popup_xml = popup->get_root( )->xml_get( ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_bapiret = VALUE #(
        ( message = 'An empty Report field causes an empty XML Message to be sent' type = 'E' id = 'MSG1' number = '001' )
        ( message = 'Check was executed for wrong Scenario' type = 'E' id = 'MSG1' number = '002' )
        ( message = 'Request was handled without errors' type = 'S' id = 'MSG1' number = '003' )
        ( message = 'product activated' type = 'S' id = 'MSG4' number = '375' )
        ( message = 'check the input values' type = 'W' id = 'MSG2' number = '375' )
        ( message = 'product already in use' type = 'I' id = 'MSG2' number = '375' )
         ).

      display_view( client ).


    ENDIF.

    mv_popup_name = ''.


    CASE client->get( )-event.

      WHEN 'POPUP_TO_DECIDE'.
        mv_popup_name = 'POPUP_TO_DECIDE'.

      WHEN 'BUTTON_CONFIRM'.
        client->set_popup( `` ).
        client->popup_message_toast( 'confirm pressed' ).

      WHEN 'BUTTON_CANCEL'.
        client->set_popup( `` ).
        client->popup_message_toast( 'cancel pressed' ).

      WHEN 'POPUP_TO_TEXTAREA'.
        mv_popup_name = 'POPUP_TO_TEXTAREA'.
        mv_stretch_active = abap_false.

      WHEN 'POPUP_TO_TEXTAREA_STRETCH'.
        mv_popup_name = 'POPUP_TO_TEXTAREA'.
        mv_stretch_active = abap_true.

      WHEN 'POPUP_TO_TEXTAREA_SIZE'.
        mv_popup_name = 'POPUP_TO_TEXTAREA_SIZE'.

      WHEN 'BUTTON_TEXTAREA_CANCEL'.
        client->set_popup( `` ).
        client->popup_message_toast( 'textarea deleted' ).
        CLEAR mv_textarea.

      WHEN 'BUTTON_TEXTAREA_CONFIRM'.
        client->set_popup( `` ).

      WHEN 'POPUP_TO_INPUT'.
        ms_popup_input-value1 = 'value1'.
        mv_popup_name =  'POPUP_TO_INPUT'.

      WHEN 'POPUP_BAL'.
        mv_popup_name =  'POPUP_BAL'.

      WHEN 'POPUP_TABLE'.
        CLEAR t_tab.
        DO 10 TIMES.
          DATA(ls_row) = VALUE ty_row( title = 'entry_' && sy-index  value = 'red' info = 'completed'  descr = 'this is a description' ).
          INSERT ls_row INTO TABLE t_tab.
        ENDDO.
        mv_popup_name = 'POPUP_TABLE'.

      WHEN 'POPUP_TABLE_CONTINUE'.
        client->set_popup( `` ).
        DELETE t_tab WHERE selkz = abap_false.
        client->popup_message_toast( `Entry selected: ` && VALUE #( t_tab[ 1 ]-title DEFAULT `no entry selected` )  ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.



    CASE mv_popup_name.

      WHEN 'POPUP_TO_DECIDE'.
        view_popup_decide( client ).
        client->set_popup( mv_popup_xml ).
      WHEN 'POPUP_TO_TEXTAREA'.
        view_popup_textarea( client ).
        client->set_popup( mv_popup_xml ).
      WHEN 'POPUP_TO_TEXTAREA_SIZE'.
        view_popup_textarea_size( client ).
        client->set_popup( mv_popup_xml ).
      WHEN 'POPUP_TO_INPUT'.
        view_popup_input( client ).
        client->set_popup( mv_popup_xml ).
      WHEN 'POPUP_TABLE'.
        view_popup_table( client ).
        client->set_popup( mv_popup_xml ).
    ENDCASE.


    CLEAR: mv_main_xml, mv_popup_xml.
  ENDMETHOD.
ENDCLASS.
