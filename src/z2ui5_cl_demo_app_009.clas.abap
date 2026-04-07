CLASS z2ui5_cl_demo_app_009 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_suggestion,
        selkz TYPE abap_bool,
        value TYPE string,
        descr TYPE string,
      END OF ty_s_suggestion.
    TYPES ty_t_suggestion TYPE STANDARD TABLE OF ty_s_suggestion WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_city,
        value TYPE string,
        descr TYPE string,
      END OF ty_s_city.

    TYPES:
      BEGIN OF ty_s_employee,
        selkz    TYPE abap_bool,
        city     TYPE string,
        nr       TYPE string,
        name     TYPE string,
        lastname TYPE string,
      END OF ty_s_employee.
    TYPES ty_t_employee TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.

    DATA:
      BEGIN OF s_screen,
        color_01 TYPE string,
        color_02 TYPE string,
        color_03 TYPE string,
        city     TYPE string,
        name     TYPE string,
        lastname TYPE string,
        quantity TYPE string,
        unit     TYPE string,
      END OF s_screen.

    DATA t_suggestion     TYPE ty_t_suggestion.
    DATA t_suggestion_sel TYPE ty_t_suggestion.
    DATA t_cities         TYPE STANDARD TABLE OF ty_s_city WITH EMPTY KEY.
    DATA t_employees_sel  TYPE ty_t_employee.

  PROTECTED SECTION.
    DATA client      TYPE REF TO z2ui5_if_client.
    DATA t_employees TYPE ty_t_employee.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS popup_value_suggestion.
    METHODS popup_value_employee.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_009 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_suggestion = VALUE #(
        ( descr = `this is the color Green`  value = `GREEN` )
        ( descr = `this is the color Blue`   value = `BLUE` )
        ( descr = `this is the color Black`  value = `BLACK` )
        ( descr = `this is the color Grey`   value = `GREY` )
        ( descr = `this is the color Blue2`  value = `BLUE2` )
        ( descr = `this is the color Blue3`  value = `BLUE3` ) ).

    t_cities = VALUE #(
        ( value = `London` descr = `London` )
        ( value = `Paris`  descr = `Paris` )
        ( value = `Rome`   descr = `Rome` ) ).

    t_employees = VALUE #(
        ( city = `London` name = `Tom`       lastname = `lastname1`  nr = `00001` )
        ( city = `London` name = `Tom2`      lastname = `lastname2`  nr = `00002` )
        ( city = `London` name = `Tom3`      lastname = `lastname3`  nr = `00003` )
        ( city = `London` name = `Tom4`      lastname = `lastname4`  nr = `00004` )
        ( city = `Rome`   name = `Michaela1` lastname = `lastname5`  nr = `00005` )
        ( city = `Rome`   name = `Michaela2` lastname = `lastname6`  nr = `00006` )
        ( city = `Rome`   name = `Michaela3` lastname = `lastname7`  nr = `00007` )
        ( city = `Rome`   name = `Michaela4` lastname = `lastname8`  nr = `00008` )
        ( city = `Paris`  name = `Hermine1`  lastname = `lastname9`  nr = `00009` )
        ( city = `Paris`  name = `Hermine2`  lastname = `lastname10` nr = `00010` )
        ( city = `Paris`  name = `Hermine3`  lastname = `lastname11` nr = `00011` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `POPUP_TABLE_value`.
        t_suggestion_sel = t_suggestion.
        popup_value_suggestion( ).
      WHEN `POPUP_TABLE_value_CUSTOM`.
        t_employees_sel = VALUE #( ).
        popup_value_employee( ).
      WHEN `SEARCH`.
        t_employees_sel = t_employees.

        IF s_screen-city IS NOT INITIAL.
          DELETE t_employees_sel WHERE city <> s_screen-city.
        ENDIF.
        popup_value_employee( ).
      WHEN `POPUP_TABLE_value_CUSTOM_CONTINUE`.
        DELETE t_employees_sel WHERE selkz = abap_false.

        IF lines( t_employees_sel ) = 1.

          s_screen-name     = t_employees_sel[ 1 ]-name.
          s_screen-lastname = t_employees_sel[ 1 ]-lastname.
          client->message_toast_display( `value value selected` ).
          client->popup_destroy( ).

        ENDIF.
      WHEN `POPUP_TABLE_value_CONTINUE`.
        DELETE t_suggestion_sel WHERE selkz = abap_false.

        IF lines( t_suggestion_sel ) = 1.

          s_screen-color_02 = t_suggestion_sel[ 1 ]-value.
          client->message_toast_display( `value value selected` ).
          client->popup_destroy( ).

        ENDIF.
      WHEN `BUTTON_SEND`.
        client->message_box_display( `success - values send to the server` ).
      WHEN `BUTTON_CLEAR`.
        s_screen = VALUE #( ).
        client->message_box_display( `View initialized` ).
    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Value Help Examples`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(form) = page->grid( `L7 M7 S7`
        )->content( `layout`
            )->simple_form( `Input with Value Help`
                )->content( `form` ).

    form->label( `Input with suggestion items`
        )->input(
            value           = client->_bind_edit( s_screen-color_01 )
            placeholder     = `fill in your favorite colour`
            suggestionitems = client->_bind( t_suggestion )
            showsuggestion  = abap_true
        )->get(
        )->suggestion_items( )->get(
            )->list_item(
                text           = `{VALUE}`
                additionaltext = `{DESCR}` ).

    form->label( `Input only numbers allowed`
        )->input(
            value       = client->_bind_edit( s_screen-quantity )
            type        = `Number`
            placeholder = `quantity` ).

    form->label( `Input with value`
        )->input(
            value            = client->_bind_edit( s_screen-color_02 )
            placeholder      = `fill in your favorite colour`
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( `POPUP_TABLE_value` ) ).

    form->label( `Custom value Popup`
        )->input(
            value            = client->_bind_edit( s_screen-name )
            placeholder      = `name`
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( `POPUP_TABLE_value_CUSTOM` )
        )->input(
            value            = client->_bind_edit( s_screen-lastname )
            placeholder      = `lastname`
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( `POPUP_TABLE_value_CUSTOM` ) ).

    page->footer(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text    = `Clear`
                press   = client->_event( `BUTTON_CLEAR` )
                type    = `Reject`
                enabled = abap_false
                icon    = `sap-icon://delete`
            )->button(
                text    = `Send to Server`
                press   = client->_event( `BUTTON_SEND` )
                enabled = abap_false
                type    = `Success` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_value_suggestion.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    DATA(dialog) = popup->dialog( `abap2UI5 - value Value Help` ).
    DATA(tab) = dialog->table(
        mode  = `SingleSelectLeft`
        items = client->_bind_edit( t_suggestion_sel ) ).

    tab->columns(
        )->column( `20rem`
            )->text( `Color` )->get_parent(
        )->column(
            )->text( `Description` )->get_parent( ).

    tab->items( )->column_list_item( selected = `{SELKZ}`
        )->cells(
            )->text( `{VALUE}`
            )->text( `{DESCR}` ).

    dialog->buttons(
        )->button(
            text  = `continue`
            press = client->_event( `POPUP_TABLE_value_CONTINUE` )
            type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_value_employee.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    DATA(dialog) = popup->dialog( `abap2UI5 - value Value Help` ).

    dialog->simple_form(
        )->label( `Location`
        )->input(
            value           = client->_bind_edit( s_screen-city )
            suggestionitems = client->_bind( t_cities )
            showsuggestion  = abap_true
        )->get(
        )->suggestion_items( )->get(
            )->list_item(
                text           = `{VALUE}`
                additionaltext = `{DESCR}`
        )->get_parent( )->get_parent(
        )->button(
            text  = `search...`
            press = client->_event( `SEARCH` ) ).

    DATA(tab) = dialog->table(
        headertext = `Employees`
        mode       = `SingleSelectLeft`
        items      = client->_bind_edit( t_employees_sel ) ).

    tab->columns(
        )->column( `10rem`
            )->text( `City` )->get_parent(
        )->column( `10rem`
            )->text( `Nr` )->get_parent(
        )->column( `15rem`
            )->text( `Name` )->get_parent(
        )->column( `30rem`
            )->text( `Lastname` )->get_parent( ).

    tab->items( )->column_list_item( selected = `{SELKZ}`
        )->cells(
            )->text( `{CITY}`
            )->text( `{NR}`
            )->text( `{NAME}`
            )->text( `{LASTNAME}` ).

    dialog->buttons(
        )->button(
            text  = `continue`
            press = client->_event( `POPUP_TABLE_value_CUSTOM_CONTINUE` )
            type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
