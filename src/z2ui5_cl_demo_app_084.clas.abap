CLASS z2ui5_cl_demo_app_084 DEFINITION PUBLIC.

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

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

    METHODS on_rendering.
    METHODS on_event.
    METHODS on_init.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_084 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

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

      mo_client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer( mo_client->_event( `START` )
         )->_generic( ns   = `html`
                      name = `script` )->_cc_plain_xml( lv_script
         )->stringify( ) ).

      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `START`.
        on_rendering( ).
      WHEN `BUTTON_MCUSTOM`.
*        send type = '' is mandatory in order to not break current implementation
        mo_client->message_box_display( type             = ``
                                     text             = `Custom MessageBox`
                                     icon             = `SUCCESS`
                                     title            = `Custom MessageBox`
                                     actions          = VALUE #( ( `First Button` ) ( `Second Button` ) )
                                     emphasizedaction = `First Button`
                                     onclose          = `callMessageToast()`
                                     details          = `<h3>these are details</h3>` ).
      WHEN `BUTTON_MCONFIRM`.
        mo_client->message_box_display( type = `confirm`
                                     text = `Confirm MessageBox` ).
      WHEN `BUTTON_MALERT`.
        mo_client->message_box_display( type = `alert`
                                     text = `Alert MessageBox` ).
      WHEN `BUTTON_MERROR`.
        mo_client->message_box_display( type = `error`
                                     text = `Error MessageBox` ).
      WHEN `BUTTON_MINFO`.
        mo_client->message_box_display( type = `information`
                                     text = `Information MessageBox` ).
      WHEN `BUTTON_MWARNING`.
        mo_client->message_box_display( type = `warning`
                                     text = `Warning MessageBox` ).
      WHEN `BUTTON_MSUCCESS`.
        mo_client->message_box_display( type = `success`
                                     text = `Success MessageBox`
                                     icon = `sap-icon://accept` ).
      WHEN `BUTTON_SEND`.
        mo_client->message_box_display( `success - values send to the server` ).
      WHEN `BUTTON_CLEAR`.
        CLEAR screen.
        mo_client->message_toast_display( `View initialized` ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    screen = VALUE #(
        check_is_active = abap_true
        colour          = `BLUE`
        combo_key       = `GRAY`
        segment_key     = `GREEN`
        date            = `07.12.22`
        date_time       = `23.12.2022, 19:27:20`
        time_start      = `05:24:00`
        time_end        = `17:23:57` ).

    mt_suggestion = VALUE #(
        ( descr = `Green`  value = `GREEN` )
        ( descr = `Blue`   value = `BLUE` )
        ( descr = `Black`  value = `BLACK` )
        ( descr = `Gray`   value = `GRAY` )
        ( descr = `Blue2`  value = `BLUE2` )
        ( descr = `Blue3`  value = `BLUE3` ) ).
  ENDMETHOD.

  METHOD on_rendering.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( `function callMessageToast(sAction) { sap.m.MessageToast.show('Hello there !!'); }` ).
    DATA(lo_page) = lo_view->shell(
         )->page(
          showheader       = xsdbool( abap_false = mo_client->get( )-check_launchpad_active )
            title          = `abap2UI5 - Selection-Screen Example`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_grid) = lo_page->grid( `L6 M12 S12`
        )->content( `layout` ).

    lo_grid->simple_form( title    = `Input`
                       editable = abap_true
        )->content( `form`
            )->label( `Input with suggestion items`
            )->input(
                    id              = `suggInput`
                    value           = mo_client->_bind_edit( screen-colour )
                    placeholder     = `Fill in your favorite color`
                    suggestionitems = mo_client->_bind( mt_suggestion )
                    showsuggestion  = abap_true )->get(
                )->suggestion_items( )->get(
                    )->list_item(
                        text           = `{VALUE}`
                        additionaltext = `{DESCR}` ).

    lo_page->footer( )->overflow_toolbar(
         )->text( text = `MessageBox Types`
         )->button(
             text  = `Confirm`
             press = mo_client->_event( `BUTTON_MCONFIRM` )
         )->button(
             text  = `Alert`
             press = mo_client->_event( `BUTTON_MALERT` )
         )->button(
             text  = `Error`
             press = mo_client->_event( `BUTTON_MERROR` )
         )->button(
             text  = `Information`
             press = mo_client->_event( `BUTTON_MINFO` )
         )->button(
             text  = `Warning`
             press = mo_client->_event( `BUTTON_MWARNING` )
         )->button(
             text  = `Success`
             press = mo_client->_event( `BUTTON_MSUCCESS` )
         )->button(
             text  = `Custom`
             press = mo_client->_event( `BUTTON_MCUSTOM` )
         )->toolbar_spacer(
         )->button(
             text  = `Clear`
             press = mo_client->_event( `BUTTON_CLEAR` )
             type  = `Reject`
             icon  = `sap-icon://delete`
         )->button(
             text  = `Send to Server`
             press = mo_client->_event( `BUTTON_SEND` )
             type  = `Success` ).

    lo_view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( `setInputFIlter()` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
