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

    DATA mo_client TYPE REF TO z2ui5_if_client.
    DATA mt_combo TYPE ty_t_combo.

  PROTECTED SECTION.

    METHODS on_rendering.
    METHODS on_event.
    METHODS on_init.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_002 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
      on_rendering( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
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

    lo_grid->simple_form( title    = `Time Inputs`
                       editable = abap_true
        )->content( `form`
            )->label( `Date`
            )->date_picker( mo_client->_bind_edit( screen-date )
            )->label( `Date and Time`
            )->date_time_picker( mo_client->_bind_edit( screen-date_time )
            )->label( `Time Begin/End`
            )->time_picker( mo_client->_bind_edit( screen-time_start )
            )->time_picker( mo_client->_bind_edit( screen-time_end ) ).

    DATA(lo_form) = lo_grid->get_parent( )->get_parent( )->grid( `L12 M12 S12`
        )->content( `layout`
            )->simple_form( title    = `Input with select options`
                            editable = abap_true
                )->content( `form` ).

    DATA(lv_test) = lo_form->label( `Checkbox`
         )->checkbox(
             selected = mo_client->_bind_edit( screen-check_is_active )
             text     = `this is a checkbox`
             enabled  = abap_true ).

    mt_combo = VALUE ty_t_combo(
                  ( key = `BLUE`  text = `green` )
                  ( key = `GREEN` text = `blue` )
                  ( key = `BLACK` text = `red` )
                  ( key = `GRAY`  text = `gray` ) ).

    lv_test->label( `Combobox`
      )->combobox(
          selectedkey = mo_client->_bind_edit( screen-combo_key )
          items       = mo_client->_bind( mt_combo )
              )->item(
                  key  = `{KEY}`
                  text = `{TEXT}`
      )->get_parent( )->get_parent( ).

    lv_test->label( `Combobox2`
      )->combobox(
          selectedkey = mo_client->_bind_edit( screen-combo_key2 )
          items       = mo_client->_bind( mt_combo )
              )->item(
                  key  = `{KEY}`
                  text = `{TEXT}`
      )->get_parent( )->get_parent( ).

    lv_test->label( `Segmented Button`
      )->segmented_button( selected_key = mo_client->_bind_edit( screen-segment_key )
        )->items(
            )->segmented_button_item(
                key  = `BLUE`
                icon = `sap-icon://accept`
                text = `blue`
            )->segmented_button_item(
                key  = `GREEN`
                icon = `sap-icon://add-favorite`
                text = `green`
            )->segmented_button_item(
                key  = `BLACK`
                icon = `sap-icon://attachment`
                text = `black`
      )->get_parent( )->get_parent(
      )->label( `Switch disabled`
      )->switch(
        enabled       = abap_false
        customtexton  = `A`
        customtextoff = `B`
      )->label( `Switch accept/reject`
      )->switch(
        state         = mo_client->_bind_edit( screen-check_switch_01 )
        customtexton  = `on`
        customtextoff = `off`
        type          = `AcceptReject`
      )->label( `Switch normal`
      )->switch(
        state         = mo_client->_bind_edit( screen-check_switch_02 )
        customtexton  = `YES`
        customtextoff = `NO` ).

    lo_page->footer( )->overflow_toolbar(
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

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
