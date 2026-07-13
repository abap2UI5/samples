"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Currency/sample/sap.ui.unified.sample.CurrencyInTable
"! Display Currencies in Table
CLASS z2ui5_cl_demo_app_527 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_expense,
        expense              TYPE string,
        transaction_amount   TYPE decfloat34,
        transaction_currency TYPE string,
        exchange_rate        TYPE string,
        amount               TYPE string,
      END OF ty_s_expense.
    DATA t_expenses TYPE STANDARD TABLE OF ty_s_expense WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_527 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " The float type formatting of the original sample is replaced by preformatted strings
    t_expenses = VALUE #(
      ( expense              = `Flight`
        transaction_amount   = `560.67`
        transaction_currency = `EUR`
        exchange_rate        = `1.00000`
        amount               = `560.67` )
      ( expense              = `Meals`
        transaction_amount   = `180.50`
        transaction_currency = `USD`
        exchange_rate        = `0.85654`
        amount               = `154.72` )
      ( expense              = `Hotel`
        transaction_amount   = `675.00`
        transaction_currency = `USD`
        exchange_rate        = `0.85654`
        amount               = `578.57` )
      ( expense              = `Taxi`
        transaction_amount   = `15`
        transaction_currency = `USD`
        exchange_rate        = `0.85654`
        amount               = `12.86` )
      ( expense              = `Daily allowance`
        transaction_amount   = `80.00`
        transaction_currency = `BGN`
        exchange_rate        = `0.51129`
        amount               = `40.90` )
      ( expense              = `Daily allowance Japan`
        transaction_amount   = `7000`
        transaction_currency = `JPY`
        exchange_rate        = `0.00670`
        amount               = `46.69` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: Currency in Table`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Currency/sample/sap.ui.unified.sample.CurrencyInTable` ).

    DATA(tab) = page->table(
        id    = `idProductsTable`
        items = client->_bind( t_expenses ) ).

    DATA(columns) = tab->columns( ).
    columns->column(
        id     = `exapnseColumn`
        halign = `Begin`
        )->text( `Expense` ).
    columns->column(
        id     = `transactionAmountColumn`
        halign = `End`
        )->text( `Transaction amount` ).
    columns->column(
        id     = `exchangeRateColumn`
        halign = `End`
        )->text( `Exchange rate` ).
    columns->column(
        id     = `amountColumn`
        halign = `End`
        )->text( `Amount` ).

    DATA(cells) = tab->items( )->column_list_item( )->cells( ).
    cells->object_identifier( text = `{EXPENSE}` ).
    cells->currency(
        value        = `{TRANSACTION_AMOUNT}`
        currency     = `{TRANSACTION_CURRENCY}`
        maxprecision = `2`
        usesymbol    = abap_false ).
    cells->object_number( number = `{EXCHANGE_RATE}` ).
    cells->object_number(
        number = `{AMOUNT}`
        unit   = `EUR` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
