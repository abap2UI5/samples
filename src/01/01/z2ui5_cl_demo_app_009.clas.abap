CLASS z2ui5_cl_demo_app_009 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_suggestion,
        selkz TYPE abap_bool,
        value TYPE string,
        descr TYPE string,
      END OF ty_s_suggestion.
    TYPES ty_t_suggestion TYPE STANDARD TABLE OF ty_s_suggestion WITH DEFAULT KEY.

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
    TYPES ty_t_employee TYPE STANDARD TABLE OF ty_s_employee WITH DEFAULT KEY.

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
    DATA t_cities         TYPE STANDARD TABLE OF ty_s_city WITH DEFAULT KEY.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE z2ui5_cl_demo_app_009=>ty_t_suggestion.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE t_cities.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_demo_app_009=>ty_t_employee.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp1.
    
    temp2-descr = `this is the color Green`.
    temp2-value = `GREEN`.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = `this is the color Blue`.
    temp2-value = `BLUE`.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = `this is the color Black`.
    temp2-value = `BLACK`.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = `this is the color Grey`.
    temp2-value = `GREY`.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = `this is the color Blue2`.
    temp2-value = `BLUE2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-descr = `this is the color Blue3`.
    temp2-value = `BLUE3`.
    INSERT temp2 INTO TABLE temp1.
    t_suggestion = temp1.

    
    CLEAR temp3.
    
    temp4-value = `London`.
    temp4-descr = `London`.
    INSERT temp4 INTO TABLE temp3.
    temp4-value = `Paris`.
    temp4-descr = `Paris`.
    INSERT temp4 INTO TABLE temp3.
    temp4-value = `Rome`.
    temp4-descr = `Rome`.
    INSERT temp4 INTO TABLE temp3.
    t_cities = temp3.

    
    CLEAR temp5.
    
    temp6-city = `London`.
    temp6-name = `Tom`.
    temp6-lastname = `lastname1`.
    temp6-nr = `00001`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `London`.
    temp6-name = `Tom2`.
    temp6-lastname = `lastname2`.
    temp6-nr = `00002`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `London`.
    temp6-name = `Tom3`.
    temp6-lastname = `lastname3`.
    temp6-nr = `00003`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `London`.
    temp6-name = `Tom4`.
    temp6-lastname = `lastname4`.
    temp6-nr = `00004`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Rome`.
    temp6-name = `Michaela1`.
    temp6-lastname = `lastname5`.
    temp6-nr = `00005`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Rome`.
    temp6-name = `Michaela2`.
    temp6-lastname = `lastname6`.
    temp6-nr = `00006`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Rome`.
    temp6-name = `Michaela3`.
    temp6-lastname = `lastname7`.
    temp6-nr = `00007`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Rome`.
    temp6-name = `Michaela4`.
    temp6-lastname = `lastname8`.
    temp6-nr = `00008`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Paris`.
    temp6-name = `Hermine1`.
    temp6-lastname = `lastname9`.
    temp6-nr = `00009`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Paris`.
    temp6-name = `Hermine2`.
    temp6-lastname = `lastname10`.
    temp6-nr = `00010`.
    INSERT temp6 INTO TABLE temp5.
    temp6-city = `Paris`.
    temp6-name = `Hermine3`.
    temp6-lastname = `lastname11`.
    temp6-nr = `00011`.
    INSERT temp6 INTO TABLE temp5.
    t_employees = temp5.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp7 TYPE z2ui5_cl_demo_app_009=>ty_t_employee.
          DATA temp8 LIKE LINE OF t_employees_sel.
          DATA temp9 LIKE sy-tabix.
          DATA temp10 LIKE LINE OF t_employees_sel.
          DATA temp11 LIKE sy-tabix.
          DATA temp12 LIKE LINE OF t_suggestion_sel.
          DATA temp13 LIKE sy-tabix.
        DATA temp14 LIKE s_screen.

    CASE client->get( )-event.
      WHEN `POPUP_TABLE_VALUE`.
        t_suggestion_sel = t_suggestion.
        popup_value_suggestion( ).
      WHEN `POPUP_TABLE_VALUE_CUSTOM`.
        
        CLEAR temp7.
        t_employees_sel = temp7.
        popup_value_employee( ).
      WHEN `SEARCH`.
        t_employees_sel = t_employees.

        IF s_screen-city IS NOT INITIAL.
          DELETE t_employees_sel WHERE city <> s_screen-city.
        ENDIF.
        popup_value_employee( ).
      WHEN `POPUP_TABLE_VALUE_CUSTOM_CONTINUE`.
        DELETE t_employees_sel WHERE selkz = abap_false.

        IF lines( t_employees_sel ) = 1.

          
          
          temp9 = sy-tabix.
          READ TABLE t_employees_sel INDEX 1 INTO temp8.
          sy-tabix = temp9.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          s_screen-name     = temp8-name.
          
          
          temp11 = sy-tabix.
          READ TABLE t_employees_sel INDEX 1 INTO temp10.
          sy-tabix = temp11.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          s_screen-lastname = temp10-lastname.
          client->message_toast_display( `value selected` ).
          client->popup_destroy( ).

        ELSE.
          client->message_toast_display( `please select exactly one employee` ).
        ENDIF.
      WHEN `POPUP_TABLE_VALUE_CONTINUE`.
        DELETE t_suggestion_sel WHERE selkz = abap_false.

        IF lines( t_suggestion_sel ) = 1.

          
          
          temp13 = sy-tabix.
          READ TABLE t_suggestion_sel INDEX 1 INTO temp12.
          sy-tabix = temp13.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          s_screen-color_02 = temp12-value.
          client->message_toast_display( `value selected` ).
          client->popup_destroy( ).

        ELSE.
          client->message_toast_display( `please select exactly one color` ).
        ENDIF.
      WHEN `BUTTON_SEND`.
        client->message_box_display( `success - values sent to the server` ).
      WHEN `BUTTON_CLEAR`.
        
        CLEAR temp14.
        s_screen = temp14.
        client->message_box_display( `View initialized` ).
    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA form TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Value Help Examples`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Four value-help patterns: inline suggestions, numeric-only input, a value-help popup with a selectable table, ` &&
                   `and a custom popup with a city search. Fill the fields, then Clear resets the view and Send simulates a submit.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    form = page->grid( `L7 M7 S7`
        )->content( `layout`
            )->simple_form( `Input with Value Help`
                )->content( `form` ).

    form->label( `Input with suggestion items`
        )->input(
            value           = client->_bind( s_screen-color_01 )
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
            value       = client->_bind( s_screen-quantity )
            type        = `Number`
            placeholder = `quantity` ).

    form->label( `Input with value`
        )->input(
            value            = client->_bind( s_screen-color_02 )
            placeholder      = `fill in your favorite colour`
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( `POPUP_TABLE_VALUE` ) ).

    form->label( `Custom value Popup`
        )->input(
            value            = client->_bind( s_screen-name )
            placeholder      = `name`
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( `POPUP_TABLE_VALUE_CUSTOM` )
        )->input(
            value            = client->_bind( s_screen-lastname )
            placeholder      = `lastname`
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( `POPUP_TABLE_VALUE_CUSTOM` ) ).

    page->footer(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text  = `Clear`
                press = client->_event( `BUTTON_CLEAR` )
                type  = `Reject`
                icon  = `sap-icon://delete`
            )->button(
                text  = `Send to Server`
                press = client->_event( `BUTTON_SEND` )
                type  = `Success`
                icon  = `sap-icon://paper-plane` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_value_suggestion.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).
    
    dialog = popup->dialog( `abap2UI5 - Value Help` ).
    
    tab = dialog->table(
        mode  = `SingleSelectLeft`
        items = client->_bind( t_suggestion_sel ) ).

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
            press = client->_event( `POPUP_TABLE_VALUE_CONTINUE` )
            type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_value_employee.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).
    
    dialog = popup->dialog( `abap2UI5 - Value Help` ).

    dialog->simple_form(
        )->label( `Location`
        )->input(
            value           = client->_bind( s_screen-city )
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

    
    tab = dialog->table(
        headertext = `Employees`
        mode       = `SingleSelectLeft`
        items      = client->_bind( t_employees_sel ) ).

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
            press = client->_event( `POPUP_TABLE_VALUE_CUSTOM_CONTINUE` )
            type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
