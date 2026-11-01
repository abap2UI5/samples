" @keywords clipboard copy cellselector copyprovider copysparse copypreference template spreadsheet control_by_id
" @summary The CopyProvider's options on a responsive table: several fields per column with a text/html template, sparse copying, cells or full rows - paste the result below to see what the clipboard holds. Needs UI5 1.119+.
CLASS z2ui5_cl_smp_app_539 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
        supplier   TYPE string,
        quantity   TYPE string,
        uom        TYPE string,
        price      TYPE string,
        currency   TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    " the CopyProvider's options, bound - a change needs no roundtrip
    DATA copy_sparse     TYPE abap_bool.
    DATA copy_preference TYPE string.

    " whatever the user pastes into the text area
    DATA clipboard_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_539 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `INSPECT` ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.

    copy_preference = `Cells`.
    
    CLEAR temp1.
    
    temp2-product_id = `HT-1000`.
    temp2-name = `Notebook Basic 15`.
    temp2-supplier = `Very Best Screens`.
    temp2-quantity = `10`.
    temp2-uom = `PC`.
    temp2-price = `956.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1001`.
    temp2-name = `Notebook Basic 17`.
    temp2-supplier = `Very Best Screens`.
    temp2-quantity = `20`.
    temp2-uom = `PC`.
    temp2-price = `1249.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1007`.
    temp2-name = `ITelO Vault`.
    temp2-supplier = `Technocom`.
    temp2-quantity = `15`.
    temp2-uom = `PC`.
    temp2-price = `299.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1010`.
    temp2-name = `Notebook Professional 15`.
    temp2-supplier = `Very Best Screens`.
    temp2-quantity = `16`.
    temp2-uom = `PC`.
    temp2-price = `1999.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1063`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-supplier = `Titanium`.
    temp2-quantity = `50`.
    temp2-uom = `PC`.
    temp2-price = `14.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-product_id = `HT-1070`.
    temp2-name = `Photo Scan`.
    temp2-supplier = `Red Point Stores`.
    temp2-quantity = `8`.
    temp2-uom = `PC`.
    temp2-price = `129.00`.
    temp2-currency = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    " the clipboard's text format is a spreadsheet's: a tab between two
    " cells, a line break between two rows
    DATA t_line TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA cells TYPE i.
    DATA line LIKE LINE OF t_line.
      DATA t_cell TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    SPLIT clipboard_text AT cl_abap_char_utilities=>newline INTO TABLE t_line.
    DELETE t_line WHERE table_line IS INITIAL.

    
    cells = 0.
    
    LOOP AT t_line INTO line.
      
      SPLIT line AT cl_abap_char_utilities=>horizontal_tab INTO TABLE t_cell.
      cells = cells + lines( t_cell ).
    ENDLOOP.

    client->message_toast_display( |{ lines( t_line ) } row(s) with { cells } cell(s) arrived in the backend| ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    DATA inspect TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`  v = `true`
            )->a( n = `height`        v = `100%`
            )->a( n = `xmlns`         v = `sap.m`
            )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`    v = `sap.ui.core`
            )->a( n = `xmlns:plugins` v = `sap.m.plugins`
            )->a( n = `xmlns:app`     v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`
            " the CopyProvider's extractData callback ships with the framework
            )->a( n = `core:require`  v = `{Clipboard: 'z2ui5/model/clipboard'}` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Copy Options of the CopyProvider (UI5 1.119+)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Select rows or drag over cells, press Copy and paste into the text area below. Each ` &&
                   `column copies the fields its app:bindings names, one clipboard cell each - app:template is the ` &&
                   `formatted variant a spreadsheet shows. Sparse keeps the gaps between selected rows, Full copies ` &&
                   `whole rows. Needs UI5 1.119 or newer.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    table = page->ele( `Table`
        )->a( n = `id`    v = `products`
        )->a( n = `mode`  v = `MultiSelect`
        )->a( n = `items` v = client->_bind( t_products )
        )->a( n = `class` v = `sapUiSmallMargin` ).

    table->ele( `dependents`
        )->tag( n = `CellSelector` ns = `plugins`
        )->tag( n = `CopyProvider` ns = `plugins`
            )->a( n = `id`             v = `copyProvider`
            )->a( n = `extractData`    v = `Clipboard.extractData`
            )->a( n = `copySparse`     v = client->_bind( copy_sparse )
            )->a( n = `copyPreference` v = client->_bind( copy_preference ) ).

    
    CLEAR temp3.
    INSERT `copyProvider` INTO TABLE temp3.
    INSERT `copySelectionData` INTO TABLE temp3.
    INSERT `X` INTO TABLE temp3.
    table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products`
            )->tag( `ToolbarSpacer`
            )->tag( `Label`
                )->a( n = `text` v = `Sparse`
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( copy_sparse )
            )->ele( `SegmentedButton`
                )->a( n = `selectedKey` v = client->_bind( copy_preference )
                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Cells`
                        )->a( n = `text` v = `Cells`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `key`  v = `Full`
                        )->a( n = `text` v = `Full Rows`

                )->end(
            )->end(
            " the copy has to run inside the click - the browser only lets a
            " user gesture write the clipboard - so no roundtrip: a frontend
            " action calls copySelectionData on the plugin directly
            )->tag( `OverflowToolbarButton`
                )->a( n = `icon`    v = `sap-icon://copy`
                )->a( n = `text`    v = `Copy`
                )->a( n = `tooltip` v = `Copy`
                )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                  t_arg = temp3 ) ).

    " several fields per column: app:bindings lists them, app:template is
    " the formatted text/html variant (a formatMessage pattern)
    table->ele( `columns`
        )->ele( `Column`
            )->a( n = `app:bindings` v = `NAME,PRODUCT_ID`
            )->a( n = `app:template` v = `\{0\} (\{1\})`
            )->tag( `Text`
                )->a( n = `text` v = `Product`

        )->end(
        )->ele( `Column`
            )->a( n = `app:bindings` v = `SUPPLIER`
            )->tag( `Text`
                )->a( n = `text` v = `Supplier`

        )->end(
        )->ele( `Column`
            )->a( n = `hAlign`       v = `End`
            )->a( n = `app:bindings` v = `QUANTITY,UOM`
            )->a( n = `app:template` v = `\{0\} \{1\}`
            )->tag( `Text`
                )->a( n = `text` v = `Quantity`

        )->end(
        )->ele( `Column`
            )->a( n = `hAlign`       v = `End`
            )->a( n = `app:bindings` v = `PRICE,CURRENCY`
            )->a( n = `app:template` v = `\{0\} \{1\}`
            )->tag( `Text`
                )->a( n = `text` v = `Price` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `ObjectIdentifier`
                    )->a( n = `title` v = `{NAME}`
                    )->a( n = `text`  v = `{PRODUCT_ID}`
                )->tag( `Text`
                    )->a( n = `text` v = `{SUPPLIER}`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = `{QUANTITY}`
                    )->a( n = `unit`   v = `{UOM}`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = `{PRICE}`
                    )->a( n = `unit`   v = `{CURRENCY}` ).

    
    inspect = page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin` ).
    inspect->tag( `TextArea`
        )->a( n = `value`       v = client->_bind( clipboard_text )
        )->a( n = `rows`        v = `6`
        )->a( n = `width`       v = `100%`
        )->a( n = `placeholder` v = `Paste here (Ctrl+V) to see what the clipboard holds` ).
    inspect->tag( `Button`
        )->a( n = `text`  v = `Send to the Backend`
        )->a( n = `icon`  v = `sap-icon://upload`
        )->a( n = `press` v = client->_event( `INSPECT` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
