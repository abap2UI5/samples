CLASS z2ui5_cl_demo_app_141 DEFINITION PUBLIC.

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
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS ui5_view_display.
    METHODS ui5_popup_input.
    METHODS ui5_handle_event.
    METHODS ui5_init.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_141 IMPLEMENTATION.


  METHOD ui5_handle_event.

    CASE client->get( )-event.

      WHEN 'POPUP_TO_INPUT'.
        ms_popup_input-value1 = 'value1'.
        ui5_popup_input( ).

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


  METHOD ui5_popup_input.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(dialog) = popup->dialog(
       contentheight = '500px'
       contentwidth  = '500px'
       title = 'Title' ).

       dialog->content(
           )->simple_form(
               )->label( text = 'Input1'  id = 'lbl1'
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
               press = client->_event( client->cs_event-popup_close )
               type  = 'Emphasized' ).

     dialog->_generic( name = `HTML` ns = `core` t_prop = VALUE #( ( n = `content` v = `<script> sap.z2ui5.setBlackColor();  </script>` )
                                                                   ( n = `preferDOM`  v = `true` )
                                                                  ) )->get_parent( ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_view_display.

    DATA(css) = `` &&
                `.lbl-color { color: red !important; font-size: 30px !important; }`.

    DATA(script) = `` &&
                   `sap.z2ui5.setBlackColor = function() {` && |\n| &&
                   `  var lbl = sap.ui.getCore().byId('popupId--lbl1');` && |\n| &&
                   `  lbl.setText('changed from js');` && |\n| &&
                   `  lbl.addStyleClass('lbl-color');` && |\n| &&
                   `};`.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( css )->get_parent( ).
    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( script )->get_parent( ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Popups'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1637163852264624139'
                )->link(
                    text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
           )->get_parent( ).

    DATA(grid) = page->grid( 'L8 M12 S12' )->content( 'layout' ).


    grid->simple_form( 'Inputs' )->content( 'form'
        )->label( '01'
        )->button(
            text  = 'Popup Get Input Values'
            press = client->_event( 'POPUP_TO_INPUT' ) ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_display( ).
    ENDIF.

    ui5_handle_event( ).

  ENDMETHOD.
ENDCLASS.
