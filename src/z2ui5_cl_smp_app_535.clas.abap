" @keywords customdata writetodom data attribute selector marker test anchor
" @summary Writes bound values into the HTML DOM as data-* attributes with CustomData writeToDom, so a stylesheet colours controls by their data and tests find stable anchors.
CLASS z2ui5_cl_smp_app_535 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_order,
        id      TYPE string,
        product TYPE string,
        status  TYPE string,
      END OF ty_s_order.
    DATA status   TYPE string.
    DATA t_orders TYPE STANDARD TABLE OF ty_s_order WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS status_next.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_535 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_orders.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      status   = `new`.
      
      CLEAR temp1.
      
      temp2-id = `4711`.
      temp2-product = `Notebook`.
      temp2-status = `new`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `4712`.
      temp2-product = `Monitor`.
      temp2-status = `shipped`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `4713`.
      temp2-product = `Keyboard`.
      temp2-status = `delayed`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `4714`.
      temp2-product = `Mouse`.
      temp2-status = `shipped`.
      INSERT temp2 INTO TABLE temp1.
      temp2-id = `4715`.
      temp2-product = `Headset`.
      temp2-status = `delayed`.
      INSERT temp2 INTO TABLE temp1.
      t_orders = temp1.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `NEXT` ) IS NOT INITIAL.
      status_next( ).
    ENDIF.

  ENDMETHOD.


  METHOD status_next.

    DATA temp3 TYPE string.
    CASE status.
      WHEN `new`.
        temp3 = `shipped`.
      WHEN `shipped`.
        temp3 = `delayed`.
      WHEN OTHERS.
        temp3 = `new`.
    ENDCASE.
    status = temp3.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA panel TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - CSS - Style by Data with CustomData writeToDom`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A core:CustomData with writeToDom="true" writes its key and value as a data-* attribute on the ` &&
                   `root element of its control. A stylesheet selects on that attribute to style controls by their data, ` &&
                   `and automated tests use it as a stable anchor that does not depend on generated IDs.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " raw markup travels in the content attribute of a core:HTML leaf - the
    " builder re-escapes it on stringify, so the literal markup is written here.
    " Every rule selects on a data-* attribute, which exists only because the
    " CustomData elements below carry writeToDom="true". The first rule is the
    " one of the UI5 documentation, word for word
    page->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>` && |\n| &&
                         `button[data-mydata="Hello"] \{ border: 3px solid red !important; \}` && |\n| &&
                         `.sapMBtn[data-status="new"] .sapMBtnInner \{ background-color: #d1e8ff; \}` && |\n| &&
                         `.sapMBtn[data-status="shipped"] .sapMBtnInner \{ background-color: #c8f0c8; \}` && |\n| &&
                         `.sapMBtn[data-status="delayed"] .sapMBtnInner \{ background-color: #ffd6d6; \}` && |\n| &&
                         `.sapMListTblRow[data-status="shipped"] \{ background-color: #eefaee; \}` && |\n| &&
                         `.sapMListTblRow[data-status="delayed"] \{ background-color: #fff0f0; \}` && |\n| &&
                         `</style>` ).

    " writeToDom needs the expanded notation: the app:key="value" shortcut
    " creates a CustomData without the flag, so nothing reaches the DOM. The
    " key must be a valid HTML ID - keep it lower case, browsers may lower it
    page->ele( `Panel`
        )->a( n = `headerText` v = `A static value - the example of the documentation`
        )->a( n = `class`      v = `sapUiResponsiveMargin`
        )->a( n = `width`      v = `auto`
        )->ele( `Button`
            )->a( n = `text` v = `Renders as <button data-mydata="Hello" ...>`
            )->ele( `customData`
                )->tag( n = `CustomData` ns = `core`
                    )->a( n = `key`        v = `mydata`
                    )->a( n = `value`      v = `Hello`
                    )->a( n = `writeToDom` b = abap_true ).

    
    panel = page->ele( `Panel`
        )->a( n = `headerText` v = `Data-dependent styling`
        )->a( n = `class`      v = `sapUiResponsiveMargin`
        )->a( n = `width`      v = `auto` ).

    panel->tag( `Text`
        )->a( n = `text`  v = `Pick a status: the selection changes the bound value in the browser, the data-status attribute ` &&
                   `follows the binding and the button recolours without a roundtrip. Next Status changes it in the backend.`
        )->a( n = `class` v = `sapUiSmallMarginBottom` ).

    " writeToDom only writes a string value - any other type is skipped and logged
    panel->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->ele( `SegmentedButton`
            )->a( n = `selectedKey` v = client->_bind( status )
            )->a( n = `class`       v = `sapUiSmallMarginEnd`
            )->ele( `items`
                )->tag( `SegmentedButtonItem`
                    )->a( n = `key`  v = `new`
                    )->a( n = `text` v = `New`
                )->tag( `SegmentedButtonItem`
                    )->a( n = `key`  v = `shipped`
                    )->a( n = `text` v = `Shipped`
                )->tag( `SegmentedButtonItem`
                    )->a( n = `key`  v = `delayed`
                    )->a( n = `text` v = `Delayed`
            )->end(
        )->end(
        )->ele( `Button`
            )->a( n = `text`  v = `Order 4711`
            )->a( n = `class` v = `sapUiSmallMarginEnd`
            )->ele( `customData`
                )->tag( n = `CustomData` ns = `core`
                    )->a( n = `key`        v = `status`
                    )->a( n = `value`      v = client->_bind( status )
                    )->a( n = `writeToDom` b = abap_true
            )->end(
        )->end(
        )->tag( `Button`
            )->a( n = `text`  v = `Next Status`
            )->a( n = `icon`  v = `sap-icon://process`
            )->a( n = `press` v = client->_event( `NEXT` ) ).

    panel->tag( `Text`
        )->a( n = `text`  v = `The button renders as <button data-status="` && client->_bind( status ) && `" class="sapMBtn ...">`
        )->a( n = `class` v = `sapUiSmallMarginTop` ).

    
    tab = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_orders )
        )->a( n = `class` v = `sapUiResponsiveMargin`
        )->a( n = `width` v = `auto`
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `Stable anchors - every row carries data-status and data-testid`
            )->end(
        )->end( ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Order`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Product`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Status`
        )->end( ).

    " a test selects tr[data-testid="order-4711"] instead of a generated ID
    " like __item3-__clone7, which changes whenever the table is rebuilt
    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `customData`
                )->tag( n = `CustomData` ns = `core`
                    )->a( n = `key`        v = `status`
                    )->a( n = `value`      v = `{STATUS}`
                    )->a( n = `writeToDom` b = abap_true
                )->tag( n = `CustomData` ns = `core`
                    )->a( n = `key`        v = `testid`
                    )->a( n = `value`      v = `order-{ID}`
                    )->a( n = `writeToDom` b = abap_true
            )->end(
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{ID}`
                )->tag( `Text`
                    )->a( n = `text` v = `{PRODUCT}`
                )->tag( `Text`
                    )->a( n = `text` v = `{STATUS}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
