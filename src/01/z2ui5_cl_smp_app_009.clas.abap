" @keywords f4 search help suggestion input dialog select
" @summary The value help, both halves: suggestions while typing and the F4 dialog behind the field, over the same data.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popup https://abap2ui5.github.io/docs/cookbook/expert_more/value_help
CLASS z2ui5_cl_smp_app_009 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_009 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE z2ui5_cl_smp_app_009=>ty_t_suggestion.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE t_cities.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smp_app_009=>ty_t_employee.
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
        DATA temp7 TYPE z2ui5_cl_smp_app_009=>ty_t_employee.
          DATA temp8 LIKE LINE OF t_employees_sel.
          DATA temp9 LIKE sy-tabix.
          DATA temp10 LIKE LINE OF t_employees_sel.
          DATA temp11 LIKE sy-tabix.
          DATA temp12 LIKE LINE OF t_suggestion_sel.
          DATA temp13 LIKE sy-tabix.
        DATA temp14 LIKE s_screen.

    CASE client->get_event( ).
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

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popup - Value Help: Suggestions and F4 Dialog`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Four value-help patterns: inline suggestions, numeric-only input, a value-help popup with a selectable table, ` &&
                   `and a custom popup with a city search. Fill the fields, then Clear resets the view and Send simulates a submit.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L7 M7 S7`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title`    v = `Input with Value Help`
                )->a( n = `editable` b = abap_true
                )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `Input with suggestion items`
        )->ele( `Input`
            )->a( n = `placeholder`     v = `fill in your favorite colour`
            )->a( n = `value`           v = client->_bind( s_screen-color_01 )
            )->a( n = `suggestionItems` v = client->_bind( t_suggestion )
            )->a( n = `showSuggestion`  b = abap_true
            )->ele( `suggestionItems`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `text`           v = `{VALUE}`
                    )->a( n = `additionalText` v = `{DESCR}` ).

    form->tag( `Label`
        )->a( n = `text` v = `Input only numbers allowed`
        )->tag( `Input`
            )->a( n = `placeholder` v = `quantity`
            )->a( n = `type`        v = `Number`
            )->a( n = `value`       v = client->_bind( s_screen-quantity ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Input with value`
        )->tag( `Input`
            )->a( n = `placeholder`      v = `fill in your favorite colour`
            )->a( n = `value`            v = client->_bind( s_screen-color_02 )
            )->a( n = `valueHelpRequest` v = client->_event( `POPUP_TABLE_VALUE` )
            )->a( n = `showValueHelp`    b = abap_true ).

    form->tag( `Label`
        )->a( n = `text` v = `Custom value Popup`
        )->tag( `Input`
            )->a( n = `placeholder`      v = `name`
            )->a( n = `value`            v = client->_bind( s_screen-name )
            )->a( n = `valueHelpRequest` v = client->_event( `POPUP_TABLE_VALUE_CUSTOM` )
            )->a( n = `showValueHelp`    b = abap_true
        )->tag( `Input`
            )->a( n = `placeholder`      v = `lastname`
            )->a( n = `value`            v = client->_bind( s_screen-lastname )
            )->a( n = `valueHelpRequest` v = client->_event( `POPUP_TABLE_VALUE_CUSTOM` )
            )->a( n = `showValueHelp`    b = abap_true ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_CLEAR` )
                )->a( n = `text`  v = `Clear`
                )->a( n = `icon`  v = `sap-icon://delete`
                )->a( n = `type`  v = `Reject`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_SEND` )
                )->a( n = `text`  v = `Send to Server`
                )->a( n = `icon`  v = `sap-icon://paper-plane`
                )->a( n = `type`  v = `Accept` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_value_suggestion.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    dialog = popup->ele( `Dialog`
        )->a( n = `title` v = `abap2UI5 - Value Help` ).
    
    tab = dialog->ele( `Table`
        )->a( n = `items` v = client->_bind( t_suggestion_sel )
        )->a( n = `mode`  v = `SingleSelectLeft` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->a( n = `width` v = `20rem`
            )->tag( `Text`
                )->a( n = `text` v = `Color`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Description`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELKZ}`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{VALUE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{DESCR}` ).

    dialog->ele( `buttons`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `POPUP_TABLE_VALUE_CONTINUE` )
            )->a( n = `text`  v = `continue`
            )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_value_employee.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    dialog = popup->ele( `Dialog`
        )->a( n = `title` v = `abap2UI5 - Value Help` ).

    dialog->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->tag( `Label`
            )->a( n = `text` v = `Location`
        )->ele( `Input`
            )->a( n = `value`           v = client->_bind( s_screen-city )
            )->a( n = `suggestionItems` v = client->_bind( t_cities )
            )->a( n = `showSuggestion`  b = abap_true
            )->ele( `suggestionItems`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `text`           v = `{VALUE}`
                    )->a( n = `additionalText` v = `{DESCR}`
            )->end(
        )->end(
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `SEARCH` )
            )->a( n = `text`  v = `search...` ).

    
    tab = dialog->ele( `Table`
        )->a( n = `items`      v = client->_bind( t_employees_sel )
        )->a( n = `headerText` v = `Employees`
        )->a( n = `mode`       v = `SingleSelectLeft` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->a( n = `width` v = `10rem`
            )->tag( `Text`
                )->a( n = `text` v = `City`
        )->end(
        )->ele( `Column`
            )->a( n = `width` v = `10rem`
            )->tag( `Text`
                )->a( n = `text` v = `Nr`
        )->end(
        )->ele( `Column`
            )->a( n = `width` v = `15rem`
            )->tag( `Text`
                )->a( n = `text` v = `Name`
        )->end(
        )->ele( `Column`
            )->a( n = `width` v = `30rem`
            )->tag( `Text`
                )->a( n = `text` v = `Lastname`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELKZ}`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{CITY}`
                )->tag( `Text`
                    )->a( n = `text` v = `{NR}`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`
                )->tag( `Text`
                    )->a( n = `text` v = `{LASTNAME}` ).

    dialog->ele( `buttons`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `POPUP_TABLE_VALUE_CUSTOM_CONTINUE` )
            )->a( n = `text`  v = `continue`
            )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
