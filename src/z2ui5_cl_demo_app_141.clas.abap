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

    DATA:
      BEGIN OF ms_popup_input,
        value1          TYPE string,
        value2          TYPE string,
        check_is_active TYPE abap_bool,
        combo_key       TYPE string,
      END OF ms_popup_input.

    DATA mt_bapiret TYPE bapirettab.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS popup_input.
    METHODS handle_event.
    METHODS init.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_141 IMPLEMENTATION.

  METHOD handle_event.

    IF mo_client->check_on_event( `POPUP_TO_INPUT` ).
      ms_popup_input-value1 = `value1`.
      popup_input( ).
    ENDIF.
  ENDMETHOD.

  METHOD init.

    mt_bapiret = VALUE #(
      ( message = `An empty Report field causes an empty XML Message to be sent` type = `E` id = `MSG1` number = `001` )
      ( message = `Check was executed for wrong Scenario` type = `E` id = `MSG1` number = `002` )
      ( message = `Request was handled without errors` type = `S` id = `MSG1` number = `003` )
      ( message = `product activated` type = `S` id = `MSG4` number = `375` )
      ( message = `check the input values` type = `W` id = `MSG2` number = `375` )
      ( message = `product already in use` type = `I` id = `MSG2` number = `375` ) ).
  ENDMETHOD.

  METHOD popup_input.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_dialog) = lo_popup->dialog(
       contentheight = `500px`
       contentwidth  = `500px`
       title         = `Title` ).

    lo_dialog->content(
           )->simple_form(
               )->label( text = `Input1`
                         id   = `lbl1`
               )->input( mo_client->_bind_edit( ms_popup_input-value1 )
               )->label( `Input2`
               )->input( mo_client->_bind_edit( ms_popup_input-value2 )
               )->label( `Checkbox`
               )->checkbox(
                   selected = mo_client->_bind_edit( ms_popup_input-check_is_active )
                   text     = `this is a checkbox`
                   enabled  = abap_true
         )->get_parent( )->get_parent(
         )->footer( )->overflow_toolbar(
           )->toolbar_spacer(
           )->button(
               text  = `Cancel`
               press = mo_client->_event( `BUTTON_TEXTAREA_CANCEL` )
           )->button(
               text  = `Confirm`
               press = mo_client->_event_client( mo_client->cs_event-popup_close )
               type  = `Emphasized` ).

    lo_dialog->_generic( name   = `HTML`
                      ns     = `core`
                      t_prop = VALUE #( ( n = `content` v = `<script> sap.z2ui5.setBlackColor();  </script>` )
                                                                   ( n = `preferDOM`  v = `true` )
                                                                  ) )->get_parent( ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lv_css) = `` &&
                `.lbl-color { color: red !important; font-size: 30px !important; }`.

    DATA(lv_script) = `` &&
                   `sap.z2ui5.setBlackColor = function() {` && |\n| &&
                   `  var lbl = sap.ui.getCore().byId('popupId--lbl1');` && |\n| &&
                   `  lbl.setText('changed from js');` && |\n| &&
                   `  lbl.addStyleClass('lbl-color');` && |\n| &&
                   `};`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( lv_css )->get_parent( ).
    lo_view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( lv_script )->get_parent( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title          = `abap2UI5 - Popups`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_grid) = lo_page->grid( `L8 M12 S12` )->content( `layout` ).

    lo_grid->simple_form( `Inputs` )->content( `form`
        )->label( `01`
        )->button(
            text  = `Popup Get Input Values`
            press = mo_client->_event( `POPUP_TO_INPUT` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      view_display( ).
    ENDIF.

    handle_event( ).
  ENDMETHOD.
ENDCLASS.
