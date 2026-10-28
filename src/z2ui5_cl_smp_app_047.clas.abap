" @keywords type conversion sum amount number field
" @summary Binding types for integer, decimal, date and time - the conversion between the ABAP field and what the control shows, with a sum over the bound table.
" @docs https://abap2ui5.github.io/docs/cookbook/model/binding
CLASS z2ui5_cl_smp_app_047 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        date TYPE d,
        time TYPE t,
      END OF ty_s_row.

    DATA int1    TYPE i.
    DATA int2    TYPE i.
    DATA int_sum TYPE i.

    DATA dec1    TYPE p LENGTH 10 DECIMALS 4.
    DATA dec2    TYPE p LENGTH 10 DECIMALS 4.
    DATA dec_sum TYPE p LENGTH 10 DECIMALS 4.

    DATA date    TYPE d.
    DATA time    TYPE t.

    DATA mt_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_047 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    DATA t_skipped TYPE z2ui5_if_client=>ty_t_model_skip.
      FIELD-SYMBOLS <temp1> LIKE LINE OF t_skipped.
      DATA temp2 LIKE sy-tabix.
      DATA temp3 LIKE mt_tab.
      DATA temp4 LIKE LINE OF temp3.
          DATA temp5 TYPE i.
          DATA temp6 LIKE dec_sum.

    me->client = client.

    " text typed into an Input bound to TYPE i or p does not dump: the framework
    " keeps the old number and names the field in t_model_skipped - so the
    " sum would silently use a value the screen no longer shows
    
    t_skipped = client->get( )-t_model_skipped.
    IF t_skipped IS NOT INITIAL.
      
      
      temp2 = sy-tabix.
      READ TABLE t_skipped INDEX 1 ASSIGNING <temp1>.
      sy-tabix = temp2.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      client->message_box_display( text = |'{ <temp1>-value }' is no number this field can hold - it keeps its old value.|
                                   type = `error` ).
      RETURN.
    ENDIF.

    IF client->check_on_init( ) IS NOT INITIAL.

      date = sy-datum.
      time = sy-uzeit.
      dec1 = - 1 / 3.
      dec2 = 2 / 3.
      
      CLEAR temp3.
      
      temp4-date = sy-datum.
      temp4-time = sy-uzeit.
      INSERT temp4 INTO TABLE temp3.
      mt_tab = temp3.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `BUTTON_INT` ) IS NOT INITIAL.
      " both summands are typed by the user - their sum can leave the range
      " of TYPE i even when each of them fits
      TRY.
          int_sum = int1 + int2.
        CATCH cx_sy_arithmetic_overflow cx_sy_conversion_overflow.
          
          CLEAR temp5.
          int_sum = temp5.
          client->message_box_display( text = `The sum does not fit TYPE i.`
                                       type = `error` ).
      ENDTRY.
    ELSEIF client->check_on_event( `BUTTON_DEC` ) IS NOT INITIAL.
      TRY.
          dec_sum = dec1 + dec2.
        CATCH cx_sy_arithmetic_overflow cx_sy_conversion_overflow.
          
          CLEAR temp6.
          dec_sum = temp6.
          client->message_box_display( text = `The sum does not fit TYPE p LENGTH 10 DECIMALS 4.`
                                       type = `error` ).
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Binding - Types for Integer, Decimal, Date and Time`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Numeric and date/time binding: integer and decimal fields use automatic type ` &&
                   `conversion, buttons calculate the sums, and a growing table lists the values.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Integer and Decimals`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `Input`
            )->tag( `Label`
                )->a( n = `text` v = `integer`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( int1 )
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( int2 )
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( int_sum )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_INT` )
                )->a( n = `text`  v = `calc sum`
            )->tag( `Label`
                )->a( n = `text` v = `decimals`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( dec1 )
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( dec2 )
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( dec_sum )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_DEC` )
                )->a( n = `text`  v = `calc sum`
            )->tag( `Label`
                )->a( n = `text` v = `date`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( date )
            )->tag( `Label`
                )->a( n = `text` v = `time`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( time ) ).

    
    tab = page->ele( `ScrollContainer`
        )->a( n = `height`   v = `70%`
        )->a( n = `vertical` b = abap_true
        )->ele( `Table`
            )->a( n = `items`               v = client->_bind( mt_tab )
            )->a( n = `growing`             b = abap_true
            )->a( n = `growingThreshold`    v = `20`
            )->a( n = `growingScrollToLoad` b = abap_true
            )->a( n = `sticky`              v = `ColumnHeaders,HeaderToolbar` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Date`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Time`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{DATE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{TIME}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
