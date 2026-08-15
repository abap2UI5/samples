" @keywords f4 search help suggestion input dialog select
CLASS z2ui5_cl_smp_app_009 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_009 IMPLEMENTATION.

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

    CASE client->get_event( ).
      WHEN `POPUP_TABLE_VALUE`.
        t_suggestion_sel = t_suggestion.
        popup_value_suggestion( ).
      WHEN `POPUP_TABLE_VALUE_CUSTOM`.
        t_employees_sel = VALUE #( ).
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

          s_screen-name     = t_employees_sel[ 1 ]-name.
          s_screen-lastname = t_employees_sel[ 1 ]-lastname.
          client->message_toast_display( `value selected` ).
          client->popup_destroy( ).

        ELSE.
          client->message_toast_display( `please select exactly one employee` ).
        ENDIF.
      WHEN `POPUP_TABLE_VALUE_CONTINUE`.
        DELETE t_suggestion_sel WHERE selkz = abap_false.

        IF lines( t_suggestion_sel ) = 1.

          s_screen-color_02 = t_suggestion_sel[ 1 ]-value.
          client->message_toast_display( `value selected` ).
          client->popup_destroy( ).

        ELSE.
          client->message_toast_display( `please select exactly one color` ).
        ENDIF.
      WHEN `BUTTON_SEND`.
        client->message_box_display( `success - values sent to the server` ).
      WHEN `BUTTON_CLEAR`.
        s_screen = VALUE #( ).
        client->message_box_display( `View initialized` ).
    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    DATA(page) = view->ele( `Shell`
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

    DATA(form) = page->ele( n = `Grid` ns = `layout`
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

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    DATA(dialog) = popup->ele( `Dialog`
        )->a( n = `title` v = `abap2UI5 - Value Help` ).
    DATA(tab) = dialog->ele( `Table`
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

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    DATA(dialog) = popup->ele( `Dialog`
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

    DATA(tab) = dialog->ele( `Table`
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
