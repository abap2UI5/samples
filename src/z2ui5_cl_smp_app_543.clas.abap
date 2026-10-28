" @keywords offline network connection queue inventory count capture warehouse offline_queue follow_up_action
" @summary A stock count that keeps working through a dead spot: SAVE waits in the browser while the backend cannot be reached and is sent, in order, once it can.
CLASS z2ui5_cl_smp_app_543 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_count,
        pos      TYPE i,
        bin      TYPE string,
        material TYPE string,
        quantity TYPE string,
      END OF ty_s_count.
    DATA t_counts  TYPE STANDARD TABLE OF ty_s_count WITH DEFAULT KEY.
    DATA bin       TYPE string.
    DATA material  TYPE string.
    DATA quantity  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_543 IMPLEMENTATION.


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
    DATA temp1 TYPE string_table.

    bin = `A-01-03`.
    view_display( ).

    " SAVE is the one event of this app that may wait for the network: while
    " the backend cannot be reached it is kept in the browser - with what was
    " typed - and sent once it can, in the order it was made. &1 in the toast
    " is how many wait. Every other event (CLEAR here) fails as usual.
    
    CLEAR temp1.
    INSERT `Saved offline - &1 waiting, sent when the network is back` INTO TABLE temp1.
    INSERT `SAVE` INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-offline_queue
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE z2ui5_cl_smp_app_543=>ty_s_count.

    CASE client->get_event( ).

      WHEN `SAVE`.
        " a queued SAVE arrives here late, but like any other: the app checks
        " what it would check anyway
        IF material IS INITIAL OR quantity IS INITIAL.
          client->message_box_display( text = `Material and quantity are required.` type = `error` ).
          RETURN.
        ENDIF.
        
        CLEAR temp3.
        temp3-pos = lines( t_counts ) + 1.
        temp3-bin = bin.
        temp3-material = material.
        temp3-quantity = quantity.
        INSERT temp3 INTO TABLE t_counts.
        CLEAR material.
        CLEAR quantity.
        client->message_toast_display( |Counted - { lines( t_counts ) } entries| ).

      WHEN `CLEAR`.
        CLEAR t_counts.

    ENDCASE.

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
            )->a( n = `title`          v = `abap2UI5 - Browser - Offline Queue for a Stock Count`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Count a bin, then take the network away (the browser's developer tools: Network - Offline) ` &&
                   `and save a few more: each one waits in the browser instead of failing. Bring the network back and ` &&
                   `they are sent in the order they were made. Experimental - the page itself still needs the network to load.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Label`
            )->a( n = `text`     v = `Bin`
            )->a( n = `labelFor` v = `inpBin`
        )->tag( `Input`
            )->a( n = `id`    v = `inpBin`
            )->a( n = `value` v = client->_bind( bin )
        )->tag( `Label`
            )->a( n = `text`     v = `Material`
            )->a( n = `labelFor` v = `inpMaterial`
        )->tag( `Input`
            )->a( n = `id`    v = `inpMaterial`
            )->a( n = `value` v = client->_bind( material )
        )->tag( `Label`
            )->a( n = `text`     v = `Quantity`
            )->a( n = `labelFor` v = `inpQuantity`
        )->tag( `Input`
            )->a( n = `id`    v = `inpQuantity`
            )->a( n = `value` v = client->_bind( quantity )
            )->a( n = `type`  v = `Number`
        )->ele( `HBox`
            )->tag( `Button`
                )->a( n = `text`  v = `Save`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `SAVE` )
            )->tag( `Button`
                )->a( n = `text`  v = `Clear List`
                )->a( n = `class` v = `sapUiSmallMarginBegin`
                )->a( n = `press` v = client->_event( `CLEAR` ) ).

    
    table = page->ele( `Table`
        )->a( n = `items`      v = client->_bind( t_counts )
        )->a( n = `noDataText` v = `Nothing counted yet`
        )->a( n = `class`      v = `sapUiSmallMargin` ).

    table->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `#`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Bin`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Material`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Quantity` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{POS}`
                )->tag( `Text`
                    )->a( n = `text` v = `{BIN}`
                )->tag( `Text`
                    )->a( n = `text` v = `{MATERIAL}`
                )->tag( `Text`
                    )->a( n = `text` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
