CLASS z2ui5_cl_demo_app_002 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_suggestion_item,
        value TYPE string,
        descr TYPE string,
      END OF ty_s_suggestion_item.
    TYPES:
      BEGIN OF ty_s_combobox_item,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_combobox_item.

    DATA:
      BEGIN OF s_screen,
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
      END OF s_screen.

    DATA t_suggestions TYPE STANDARD TABLE OF ty_s_suggestion_item WITH EMPTY KEY.
    DATA t_combo       TYPE STANDARD TABLE OF ty_s_combobox_item WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_002 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    s_screen = VALUE #(
        check_is_active = abap_true
        colour          = `BLUE`
        combo_key       = `GRAY`
        segment_key     = `GREEN`
        date            = `07.12.22`
        date_time       = `23.12.2022, 19:27:20`
        time_start      = `05:24:00`
        time_end        = `17:23:57` ).

    t_suggestions = VALUE #(
        ( descr = `Green`  value = `GREEN` )
        ( descr = `Blue`   value = `BLUE` )
        ( descr = `Black`  value = `BLACK` )
        ( descr = `Gray`   value = `GRAY` )
        ( descr = `Blue2`  value = `BLUE2` )
        ( descr = `Blue3`  value = `BLUE3` ) ).

    t_combo = VALUE #(
        ( key = `BLUE`  text = `green` )
        ( key = `GREEN` text = `blue` )
        ( key = `BLACK` text = `red` )
        ( key = `GRAY`  text = `gray` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BUTTON_SEND`.
        client->message_box_display( `success - values send to the server` ).
      WHEN `BUTTON_CLEAR`.
        s_screen = VALUE #( ).
        client->message_toast_display( `View initialized` ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Selection-Screen Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(grid) = page->grid( `L6 M12 S12`
        )->content( `layout` ).

    grid->simple_form(
        title    = `Input`
        editable = abap_true
        )->content( `form`
        )->label( `Input with suggestion items`
        )->input(
            id              = `suggInput`
            value           = client->_bind_edit( s_screen-colour )
            placeholder     = `Fill in your favorite color`
            suggestionitems = client->_bind( t_suggestions )
            showsuggestion  = abap_true
        )->get(
        )->suggestion_items( )->get(
            )->list_item(
                text           = `{VALUE}`
                additionaltext = `{DESCR}` ).

    grid->simple_form(
        title    = `Time Inputs`
        editable = abap_true
        )->content( `form`
        )->label( `Date`
        )->date_picker( client->_bind_edit( s_screen-date )
        )->label( `Date and Time`
        )->date_time_picker( client->_bind_edit( s_screen-date_time )
        )->label( `Time Begin/End`
        )->time_picker( client->_bind_edit( s_screen-time_start )
        )->time_picker( client->_bind_edit( s_screen-time_end ) ).

    DATA(content) = page->grid( `L12 M12 S12`
        )->content( `layout`
            )->simple_form(
                title    = `Input with select options`
                editable = abap_true
                )->content( `form` ).

    content->label( `Checkbox` )->checkbox(
        selected = client->_bind_edit( s_screen-check_is_active )
        text     = `this is a checkbox`
        enabled  = abap_true ).

    content->label( `Combobox` )->combobox(
        selectedkey = client->_bind_edit( s_screen-combo_key )
        items       = client->_bind( t_combo )
        )->item(
            key  = `{KEY}`
            text = `{TEXT}` ).

    content->label( `Combobox2` )->combobox(
        selectedkey = client->_bind_edit( s_screen-combo_key2 )
        items       = client->_bind( t_combo )
        )->item(
            key  = `{KEY}`
            text = `{TEXT}` ).

    content->label( `Segmented Button` )->segmented_button(
        client->_bind_edit( s_screen-segment_key )
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
                text = `black` ).

    content->label( `Switch disabled` )->switch(
        enabled       = abap_false
        customtexton  = `A`
        customtextoff = `B` ).

    content->label( `Switch accept/reject` )->switch(
        state         = client->_bind_edit( s_screen-check_switch_01 )
        customtexton  = `on`
        customtextoff = `off`
        type          = `AcceptReject` ).

    content->label( `Switch normal` )->switch(
        state         = client->_bind_edit( s_screen-check_switch_02 )
        customtexton  = `YES`
        customtextoff = `NO` ).

    page->footer( )->overflow_toolbar(
        )->toolbar_spacer(
        )->button(
            text  = `Clear`
            press = client->_event( `BUTTON_CLEAR` )
            type  = `Reject`
            icon  = `sap-icon://delete`
        )->button(
            text  = `Send to Server`
            press = client->_event( `BUTTON_SEND` )
            type  = `Success` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
