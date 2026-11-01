" @keywords clipboard copy paste cellselector copyprovider pasteprovider excel spreadsheet grid control_by_id
" @summary Spreadsheet-style copy and paste on a grid table: select a cell block and copy it, or paste rows from Excel into the table and let the backend append them - needs UI5 1.119 or newer.
CLASS z2ui5_cl_smp_app_538 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
        category   TYPE string,
        price      TYPE string,
        currency   TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    TYPES ty_t_rows TYPE STANDARD TABLE OF string_table WITH DEFAULT KEY.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS on_event_paste.
    METHODS view_display.

    METHODS pasted_rows
      IMPORTING
        json          TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_rows.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_538 IMPLEMENTATION.

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

    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-category = `Laptops`.
    temp2-price = `956.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-category = `Laptops`.
    temp2-price = `1249.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-category = `Laptops`.
    temp2-price = `1999.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1030`.
    temp2-name = `Ergo Screen E-I`.
    temp2-category = `Flat Screens`.
    temp2-price = `230.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1040`.
    temp2-name = `Laser Professional Eco`.
    temp2-category = `Printers`.
    temp2-price = `830.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-category = `Keyboards`.
    temp2-price = `14.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1070`.
    temp2-name = `Photo Scan`.
    temp2-category = `Scanners`.
    temp2-price = `129.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `COPY`.
        " the CopyProvider's copy event - fired before the clipboard is written
        client->message_toast_display( `Selection copied to the clipboard` ).
      WHEN `PASTE`.
        on_event_paste( ).
    ENDCASE.

  ENDMETHOD.


  METHOD on_event_paste.

    " the pasted rows arrive in the backend, which decides what they mean -
    " here: the cells, in column order, become new products
    DATA rows TYPE z2ui5_cl_smp_app_538=>ty_t_rows.
    DATA cells LIKE LINE OF rows.
      DATA temp3 TYPE z2ui5_cl_smp_app_538=>ty_s_product.
      DATA temp1 TYPE z2ui5_cl_smp_app_538=>ty_s_product-product_id.
      DATA temp2 TYPE string.
      DATA temp4 TYPE z2ui5_cl_smp_app_538=>ty_s_product-name.
      DATA temp5 TYPE string.
      DATA temp6 TYPE z2ui5_cl_smp_app_538=>ty_s_product-category.
      DATA temp7 TYPE string.
      DATA temp8 TYPE z2ui5_cl_smp_app_538=>ty_s_product-price.
      DATA temp9 TYPE string.
      DATA temp10 TYPE z2ui5_cl_smp_app_538=>ty_s_product-currency.
      DATA temp11 TYPE string.
    rows = pasted_rows( client->get_event_arg( ) ).

    
    LOOP AT rows INTO cells.
      
      CLEAR temp3.
      
      CLEAR temp1.
      
      READ TABLE cells INTO temp2 INDEX 1.
      IF sy-subrc = 0.
        temp1 = temp2.
      ENDIF.
      temp3-product_id = temp1.
      
      CLEAR temp4.
      
      READ TABLE cells INTO temp5 INDEX 2.
      IF sy-subrc = 0.
        temp4 = temp5.
      ENDIF.
      temp3-name = temp4.
      
      CLEAR temp6.
      
      READ TABLE cells INTO temp7 INDEX 3.
      IF sy-subrc = 0.
        temp6 = temp7.
      ENDIF.
      temp3-category = temp6.
      
      CLEAR temp8.
      
      READ TABLE cells INTO temp9 INDEX 4.
      IF sy-subrc = 0.
        temp8 = temp9.
      ENDIF.
      temp3-price = temp8.
      
      CLEAR temp10.
      
      READ TABLE cells INTO temp11 INDEX 5.
      IF sy-subrc = 0.
        temp10 = temp11.
      ENDIF.
      temp3-currency = temp10.
      INSERT temp3 INTO TABLE t_products.
    ENDLOOP.

    client->message_toast_display( |{ lines( rows ) } row(s) pasted and appended| ).

  ENDMETHOD.


  METHOD pasted_rows.

    " the paste event's data parameter is string[][], so it reaches the
    " backend as JSON: [["HT-2000","Tablet"],["HT-2001","Phone"]]. One pass
    " over it - an opening quote starts a cell, a closing one ends it, and a
    " bracket that closes the second level ends a row.
    DATA row       TYPE string_table.
    DATA cell      TYPE string.
    DATA depth     TYPE i.
    DATA in_string TYPE abap_bool.
    DATA escaped   TYPE abap_bool.
      DATA char TYPE string.
          DATA temp4 TYPE string_table.

    DO strlen( json ) TIMES.
      
      char = substring( val = json
                              off = sy-index - 1
                              len = 1 ).

      IF in_string = abap_true.

        IF escaped = abap_true.
          cell    = |{ cell }{ char }|.
          escaped = abap_false.
        ELSEIF char = `\`.
          escaped = abap_true.
        ELSEIF char = `"`.
          INSERT cell INTO TABLE row.
          cell      = ``.
          in_string = abap_false.
        ELSE.
          cell = |{ cell }{ char }|.
        ENDIF.

      ELSEIF char = `"`.
        in_string = abap_true.
      ELSEIF char = `[`.
        depth = depth + 1.
      ELSEIF char = `]`.

        IF depth = 2.
          INSERT row INTO TABLE result.
          
          CLEAR temp4.
          row = temp4.
        ENDIF.
        depth = depth - 1.

      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`  v = `true`
            )->a( n = `height`        v = `100%`
            )->a( n = `xmlns`         v = `sap.m`
            )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`    v = `sap.ui.core`
            )->a( n = `xmlns:table`   v = `sap.ui.table`
            )->a( n = `xmlns:plugins` v = `sap.m.plugins`
            )->a( n = `xmlns:app`     v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`
            " the CopyProvider's extractData callback ships with the framework
            )->a( n = `core:require`  v = `{Clipboard: 'z2ui5/model/clipboard'}` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Copy & Paste, CellSelector (UI5 1.119+)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Drag over the cells to select a block, then press Copy or Ctrl+C - the CopyProvider writes ` &&
                   `it to the clipboard, as text for a spreadsheet. Copy a few rows in Excel and press Paste or ` &&
                   `Ctrl+V on the table: the rows travel to the backend, which appends them. Needs UI5 1.119 or newer.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    table = page->ele( n = `Table` ns = `table`
        )->a( n = `id`              v = `products`
        )->a( n = `rows`            v = client->_bind( t_products )
        )->a( n = `visibleRowCount` v = `8`
        )->a( n = `selectionMode`   v = `MultiToggle`
        )->a( n = `class`           v = `sapUiSmallMargin`
        )->a( n = `paste`           v = client->_event( val = `PASTE` arg = `${$parameters>/data}` ) ).

    table->ele( n = `dependents` ns = `table`
        )->tag( n = `CellSelector` ns = `plugins`
        )->tag( n = `CopyProvider` ns = `plugins`
            )->a( n = `id`          v = `copyProvider`
            )->a( n = `extractData` v = `Clipboard.extractData`
            )->a( n = `copy`        v = client->_event( `COPY` ) ).

    
    CLEAR temp5.
    INSERT `copyProvider` INTO TABLE temp5.
    INSERT `copySelectionData` INTO TABLE temp5.
    INSERT `X` INTO TABLE temp5.
    table->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products`
            )->tag( `ToolbarSpacer`
            " the copy has to run inside the click - the browser only lets a
            " user gesture write the clipboard - so no roundtrip: a frontend
            " action calls copySelectionData on the plugin directly
            )->tag( `OverflowToolbarButton`
                )->a( n = `icon`    v = `sap-icon://copy`
                )->a( n = `text`    v = `Copy`
                )->a( n = `tooltip` v = `Copy`
                )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                  t_arg = temp5 )

            " the PasteProvider turns this button into a paste button for the table
            )->ele( `Button`
                )->ele( `dependents`
                    )->tag( n = `PasteProvider` ns = `plugins`
                        )->a( n = `pasteFor` v = `products` ).

    " app:bindings names what a column copies - the clipboard module reads
    " it, one clipboard cell per path
    table->ele( n = `columns` ns = `table`
        )->ele( n = `Column` ns = `table`
            )->a( n = `app:bindings` v = `PRODUCT_ID`
            )->tag( `Label`
                )->a( n = `text` v = `Product ID`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{PRODUCT_ID}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `table`
            )->a( n = `app:bindings` v = `NAME`
            )->tag( `Label`
                )->a( n = `text` v = `Name`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `table`
            )->a( n = `app:bindings` v = `CATEGORY`
            )->tag( `Label`
                )->a( n = `text` v = `Category`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{CATEGORY}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `table`
            )->a( n = `app:bindings` v = `PRICE`
            )->tag( `Label`
                )->a( n = `text` v = `Price`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{PRICE}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `table`
            )->a( n = `app:bindings` v = `CURRENCY`
            )->tag( `Label`
                )->a( n = `text` v = `Currency`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{CURRENCY}`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
