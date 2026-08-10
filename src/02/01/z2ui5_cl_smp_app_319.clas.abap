"! SmartMultiInput (sap.ui.comp) - the strength of one control: it gives the user
"! a full SELECT-OPTIONS experience (value help from OData, multiple conditions,
"! operators like contains / between / greater-than, and include/exclude) and
"! hands the backend a structured range that maps 1:1 onto an ABAP SELECT-OPTIONS.
"!
"! This demo wires that end to end: define conditions on "Product Type" via the
"! value help, and the backend translates the returned ranges into an ABAP range
"! table (r in ty_s_range -> SIGN/OPTION/LOW/HIGH) and filters a local product
"! list with `... WHERE product_type IN r_product_type`. Both the derived SELECT-OPTIONS
"! and the matching rows are shown, so the "UI condition -> ABAP range" mapping is
"! visible.
"!
"! Needs SAPUI5 (sap.ui.comp is SAPUI5-only) and a reachable, value-list-annotated
"! OData V2 service - see the OData service block in on_init.
CLASS z2ui5_cl_smp_app_319 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_token,
      t_tokens TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_range,
        exclude      TYPE abap_bool,
        operation    TYPE string,
        value1       TYPE string,
        value2       TYPE string,
        keyfield     TYPE string,
        tokentext    TYPE string,
        tokenlongkey TYPE string,
      END OF ty_s_range,
      t_ranges TYPE STANDARD TABLE OF ty_s_range WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_product,
        product_type TYPE string,
        name         TYPE string,
      END OF ty_s_product.
    TYPES:
      " display row for the derived SELECT-OPTIONS (plain strings so binding
      " serializes safely everywhere; the real RANGE is only built locally)
      BEGIN OF ty_s_selopt,
        sign   TYPE string,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
      END OF ty_s_selopt.

    DATA:
      BEGIN OF m_selection,
        BEGIN OF product_type,
          tokens_added   TYPE t_tokens,
          tokens_removed TYPE t_tokens,
          ranges         TYPE t_ranges,
        END OF product_type,
      END OF m_selection.

    " local demo data (source) + the filtered result + the derived SELECT-OPTIONS
    DATA t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_result  TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_selopt  TYPE STANDARD TABLE OF ty_s_selopt WITH EMPTY KEY.
    DATA hint      TYPE string.

  PROTECTED SECTION.
    DATA m_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS do_search.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_319 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    m_client = client.

    IF m_client->check_on_init( ).
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD on_init.

    " local demo product list the derived range filters (see class doc). The
    " product types are readable words so the "contains"/"starts with" operators
    " visibly hit something when you type free text into the value help.
    t_product = VALUE #(
      ( product_type = `SERVICE`  name = `Cloud Hosting` )
      ( product_type = `SERVER`   name = `Rack Server X1` )
      ( product_type = `SENSOR`   name = `IoT Sensor` )
      ( product_type = `SOFTWARE` name = `ERP License` )
      ( product_type = `HARDWARE` name = `Laptop Pro` )
      ( product_type = `MATERIAL` name = `Steel Sheet` )
      ( product_type = `SUPPORT`  name = `Gold Support` )
      ( product_type = `TRAINING` name = `ABAP Course` )
      ( product_type = `LICENSE`  name = `DB License` )
      ( product_type = `SEMIFIN`  name = `Semi-finished Part` ) ).
    t_result = t_product.
    hint     = `No conditions yet - showing all demo products. Open the value help and add conditions.`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title      = `SmartMultiInput - conditions to ABAP SELECT-OPTIONS`
                                       navbuttonpress = m_client->_event_nav_app_leave( )
                                       shownavbutton  = m_client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Open the value help (icon on the right), add one or more conditions on Product Type ` &&
                   `(contains, between, greater than, exclude ...). Each condition is turned into an ABAP ` &&
                   `SELECT-OPTIONS row and filters the demo product list below.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the invisible companion mirrors tokens + range data into the (switched) app
    " model so the backend can read AND restore the input across roundtrips
    page->_z2ui5( )->smartmultiinput_ext(
                          addedtokens   = m_client->_bind( val = m_selection-product_type-tokens_added switch_default_model = abap_true )
                          removedtokens = m_client->_bind( val = m_selection-product_type-tokens_removed switch_default_model = abap_true )
                          rangedata     = m_client->_bind( val = m_selection-product_type-ranges switch_default_model = abap_true )
                          change        = m_client->_event( `PRODTYPE_CHANGED` )
                          multiinputid  = `ProductTypeMultiInput` ).

    page->smart_multi_input(
      id                = `ProductTypeMultiInput`
      value             = `{ProductType}`
      entityset         = `ProductType_2`
      supportranges     = `true`
      enableodataselect = `true` ).

    page->button( text  = `Search`
                  type  = `Emphasized`
                  icon  = `sap-icon://search`
                  press = m_client->_event( `SEARCH` )
                  class = `sapUiSmallMarginBegin` ).

    page->object_status( text  = m_client->_bind( val = hint switch_default_model = abap_true )
                         class = `sapUiSmallMargin` ).

    " derived ABAP SELECT-OPTIONS (r_product_type): SIGN / OPTION / LOW / HIGH
    DATA(sel) = page->table( m_client->_bind( val = t_selopt switch_default_model = abap_true ) ).
    sel->header_toolbar( )->overflow_toolbar( )->title( `Derived ABAP SELECT-OPTIONS  ( ... WHERE ProductType IN r_product_type )` ).
    sel->columns(
        )->column( )->text( `SIGN` )->get_parent(
        )->column( )->text( `OPTION` )->get_parent(
        )->column( )->text( `LOW` )->get_parent(
        )->column( )->text( `HIGH` ).
    sel->items(
        )->column_list_item(
            )->cells(
                )->text( `{http>SIGN}`
                )->text( `{http>OPTION}`
                )->text( `{http>LOW}`
                )->text( `{http>HIGH}` ).

    " the rows the range selects out of the demo product list
    DATA(res) = page->table( m_client->_bind( val = t_result switch_default_model = abap_true ) ).
    res->header_toolbar( )->overflow_toolbar( )->title( `Matching demo products (local sample data)` ).
    res->columns(
        )->column( )->text( `Product Type` )->get_parent(
        )->column( )->text( `Name` ).
    res->items(
        )->column_list_item(
            )->cells(
                )->text( `{http>PRODUCT_TYPE}`
                )->text( `{http>NAME}` ).

    " OData service block - adjust to your value-list-annotated Gateway service.
    " The SmartMultiInput's value help (Product Type) comes from here; the demo
    " filter above is pure ABAP and independent of it.
    m_client->view_display( val                           = page->stringify( )
                            switch_default_model_path     = `/sap/opu/odata/sap/UI_PRODUCTLIST`
                            switch_default_model_anno_uri = `/sap/opu/odata/IWFND/CATALOGSERVICE;v=2/Annotations(TechnicalName='UI_PRODUCTLIST_VAN',Version='0001')/$value` ).

  ENDMETHOD.


  METHOD on_event.

    CASE m_client->get( )-event.
      WHEN `PRODTYPE_CHANGED` OR `SEARCH`.
        do_search( ).
        m_client->view_model_update( ).
    ENDCASE.

  ENDMETHOD.


  METHOD do_search.

    " translate the UI5 range operators the SmartMultiInput returns into ABAP
    " SELECT-OPTIONS. This is the payoff: a rich UI filter becomes a real ABAP
    " RANGE (lr_type) you drop straight into any SELECT; t_selopt is just its
    " readable copy for the display table.
    DATA lr_type TYPE RANGE OF string.
    DATA sign    TYPE c LENGTH 1.
    DATA option  TYPE c LENGTH 2.
    DATA low     TYPE string.
    DATA high    TYPE string.

    t_selopt = VALUE #( ).
    lr_type  = VALUE #( ).
    LOOP AT m_selection-product_type-ranges INTO DATA(s).

      sign   = COND #( WHEN s-exclude = abap_true THEN `E` ELSE `I` ).
      option = `EQ`.
      low    = s-value1.
      high   = s-value2.

      CASE to_upper( s-operation ).
        WHEN `EQ`.           option = `EQ`.
        WHEN `NE`.           option = `NE`.
        WHEN `CONTAINS`.     option = `CP`. low = |*{ s-value1 }*|.
        WHEN `NOTCONTAINS`.  option = `CP`. low = |*{ s-value1 }*|. sign = `E`.
        WHEN `STARTSWITH`.   option = `CP`. low = |{ s-value1 }*|.
        WHEN `ENDSWITH`.     option = `CP`. low = |*{ s-value1 }|.
        WHEN `BT`.           option = `BT`.
        WHEN `NB`.           option = `NB`.
        WHEN `GT`.           option = `GT`.
        WHEN `GE`.           option = `GE`.
        WHEN `LT`.           option = `LT`.
        WHEN `LE`.           option = `LE`.
        WHEN `EMPTY`.        option = `EQ`. low = ``.
        WHEN OTHERS.         option = `EQ`.
      ENDCASE.

      APPEND VALUE #( sign = sign option = option low = low high = high ) TO lr_type.
      APPEND VALUE #( sign = sign option = option low = low high = high ) TO t_selopt.
    ENDLOOP.

    " apply the derived SELECT-OPTIONS just like any ABAP query would
    t_result = VALUE #( ).
    IF lr_type IS INITIAL.
      t_result = t_product.
      hint     = |No conditions - showing all { lines( t_product ) } demo products.|.
    ELSE.
      LOOP AT t_product INTO DATA(p) WHERE product_type IN lr_type.
        APPEND p TO t_result.
      ENDLOOP.
      hint = |{ lines( t_selopt ) } condition(s) -> { lines( t_result ) } of { lines( t_product ) } demo products match.|.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
