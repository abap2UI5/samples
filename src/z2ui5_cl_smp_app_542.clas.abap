" @keywords zip cl_abap_zip csv export download_b64_file base64 xstring utf-8 itab
" @summary Downloads an editable table as a CSV file built in plain ABAP, and the same CSV together with a text note packed into one ZIP archive with cl_abap_zip.
CLASS z2ui5_cl_smp_app_542 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        id       TYPE string,
        name     TYPE string,
        quantity TYPE i,
        price    TYPE p LENGTH 9 DECIMALS 2,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA note       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

    METHODS csv_build
      RETURNING
        VALUE(result) TYPE string.

    METHODS csv_field
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.

    METHODS file_download
      IMPORTING
        name    TYPE string
        mime    TYPE string
        content TYPE xstring.

    " Both wrap a pair of classes that do the same job under different names:
    " the first is the ABAP Cloud one, the second the classic on-premise one.
    " Called dynamically so the class that is missing on a system is a caught
    " runtime error instead of a syntax error at activation.
    METHODS base64_encode
      IMPORTING
        val           TYPE xstring
      RETURNING
        VALUE(result) TYPE string.

    METHODS string_to_xstring
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE xstring.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_542 IMPLEMENTATION.


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

    " the second and third name hold the separator and quotes on purpose -
    " the CSV has to escape them
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-id = `P-001`.
    temp2-name = `Notebook Basic 15`.
    temp2-quantity = 3.
    temp2-price = `956.00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `P-002`.
    temp2-name = `Cable "USB-C"; 2 m`.
    temp2-quantity = 25.
    temp2-price = `9.90`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `P-003`.
    temp2-name = `Monitor 27"`.
    temp2-quantity = 4.
    temp2-price = `289.00`.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `P-004`.
    temp2-name = `Wireless Mouse`.
    temp2-quantity = 12.
    temp2-price = `24.50`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.
    note = `Stock list exported from abap2UI5.`.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
          DATA zip TYPE REF TO cl_abap_zip.
        DATA error TYPE REF TO cx_root.

    TRY.

        IF client->check_on_event( `DOWNLOAD_CSV` ) IS NOT INITIAL.
          file_download( name = `products.csv` mime = `text/csv` content = string_to_xstring( csv_build( ) ) ).

        ELSEIF client->check_on_event( `DOWNLOAD_ZIP` ) IS NOT INITIAL.

          
          CREATE OBJECT zip TYPE cl_abap_zip.
          zip->add( name = `products.csv` content = string_to_xstring( csv_build( ) ) ).
          zip->add( name = `note.txt`     content = string_to_xstring( note ) ).

          file_download( name = `export.zip` mime = `application/zip` content = zip->save( ) ).
        ENDIF.

        
      CATCH cx_root INTO error.
        client->message_box_display( text = error->get_text( ) type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD csv_build.
    DATA product LIKE LINE OF t_products.

    " a header line, then one line per row - separator ;, lines end in CRLF
    result = |ID;Name;Quantity;Price\r\n|.

    
    LOOP AT t_products INTO product.
      result = result && |{ csv_field( product-id ) };{ csv_field( product-name ) };| &&
                         |{ csv_field( |{ product-quantity }| ) };{ csv_field( |{ product-price }| ) }\r\n|.
    ENDLOOP.

  ENDMETHOD.


  METHOD csv_field.

    " RFC 4180: a value holding the separator, a quote or a line break is
    " enclosed in quotes, and every quote inside it is doubled
    result = val.

    IF result CA |;"\r\n|.
      result = |"{ replace( val = result sub = `"` with = `""` occ = 0 ) }"|.
    ENDIF.

  ENDMETHOD.


  METHOD file_download.

    " download_b64_file takes a base64 data URL and the name the browser
    " saves it under
    DATA temp3 TYPE string_table.
    DATA temp1 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp1 = |data:{ mime };base64,{ base64_encode( content ) }|.
    INSERT temp1 INTO TABLE temp3.
    INSERT name INTO TABLE temp3.
    client->follow_up_action(
        val   = client->cs_event-download_b64_file
        t_arg = temp3 ).

  ENDMETHOD.


  METHOD base64_encode.

    DATA lv_class TYPE string.

    TRY.
        lv_class = `CL_WEB_HTTP_UTILITY`.
        CALL METHOD (lv_class)=>(`ENCODE_X_BASE64`)
          EXPORTING
            unencoded = val
          RECEIVING
            encoded   = result.

      CATCH cx_root.
        lv_class = `CL_HTTP_UTILITY`.
        CALL METHOD (lv_class)=>(`ENCODE_X_BASE64`)
          EXPORTING
            unencoded = val
          RECEIVING
            encoded   = result.
    ENDTRY.

  ENDMETHOD.


  METHOD string_to_xstring.

    DATA lo_conv  TYPE REF TO object.
    DATA lv_class TYPE string.

    TRY.
        lv_class = `CL_ABAP_CONV_CODEPAGE`.
        CALL METHOD (lv_class)=>create_out
          RECEIVING
            instance = lo_conv.

        CALL METHOD lo_conv->(`IF_ABAP_CONV_OUT~CONVERT`)
          EXPORTING
            source = val
          RECEIVING
            result = result.

      CATCH cx_root.
        lv_class = `CL_ABAP_CONV_OUT_CE`.
        CALL METHOD (lv_class)=>create
          EXPORTING
            encoding = `UTF-8`
          RECEIVING
            conv     = lo_conv.

        CALL METHOD lo_conv->(`CONVERT`)
          EXPORTING
            data   = val
          IMPORTING
            buffer = result.
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - File - ZIP and CSV Download with cl_abap_zip`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Download CSV turns the table into a CSV file in plain ABAP - separator ;, values with a ` &&
                   `separator or a quote enclosed in quotes, CRLF line ends - encoded as UTF-8. Download ZIP packs that CSV ` &&
                   `and the note as note.txt into one archive with cl_abap_zip. Both reach the browser via download_b64_file.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    table = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_products )
        )->a( n = `class` v = `sapUiSmallMargin` ).

    table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products - edit a cell, then download` ).

    table->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `ID`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Name`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Quantity`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Price` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Input`
                    )->a( n = `value` v = `{ID}`
                )->tag( `Input`
                    )->a( n = `value` v = `{NAME}`
                )->tag( `Input`
                    )->a( n = `value` v = `{QUANTITY}`
                )->tag( `Input`
                    )->a( n = `value` v = `{PRICE}` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Label`
            )->a( n = `text`     v = `Note (note.txt in the ZIP)`
            )->a( n = `labelFor` v = `note`
        )->tag( `TextArea`
            )->a( n = `id`    v = `note`
            )->a( n = `value` v = client->_bind( note )
            )->a( n = `rows`  v = `3`
            )->a( n = `width` v = `100%` ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`  v = `Download CSV`
                )->a( n = `icon`  v = `sap-icon://download`
                )->a( n = `press` v = client->_event( `DOWNLOAD_CSV` )
            )->tag( `Button`
                )->a( n = `text`  v = `Download ZIP`
                )->a( n = `icon`  v = `sap-icon://attachment-zip-file`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `DOWNLOAD_ZIP` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
