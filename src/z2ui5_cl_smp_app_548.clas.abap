" @keywords calculator grid layout griddata span style stylesheet keypad buttons
" @summary A pocket calculator from standard controls: a layout Grid of four columns sets out the keypad, and a stylesheet shipped with the view makes the keys and the display large.
CLASS z2ui5_cl_smp_app_548 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA display TYPE string.
    DATA history TYPE string.

  PROTECTED SECTION.
    CONSTANTS max_length TYPE i VALUE 16.

    DATA client    TYPE REF TO z2ui5_if_client.
    DATA operand   TYPE decfloat34.
    DATA operator  TYPE string.
    DATA new_input TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.

    METHODS on_digit
      IMPORTING
        digit TYPE string.
    METHODS on_decimal.
    METHODS on_operator
      IMPORTING
        val TYPE string.
    METHODS on_equals.
    METHODS on_clear.
    METHODS on_backspace.
    METHODS on_sign.

    "! Applies the pending operator to the operand and the display value
    METHODS calculate
      RETURNING
        VALUE(result) TYPE abap_bool.

    METHODS display_get
      RETURNING
        VALUE(result) TYPE decfloat34.

    METHODS display_set
      IMPORTING
        val TYPE decfloat34.

    METHODS operator_sign
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.

    "! One key of the keypad - a Button filling its grid cell
    "! @parameter grid  | the layout Grid
    "! @parameter text  | the key's label
    "! @parameter icon  | an icon instead of a label
    "! @parameter event | the event the key raises
    "! @parameter arg   | the event's argument, e.g. the digit
    "! @parameter type  | the button type that colours the key
    "! @parameter span  | the GridData span, when the key is wider than one column
    METHODS key_add
      IMPORTING
        grid  TYPE REF TO z2ui5_cl_ui5_view_builder
        text  TYPE string OPTIONAL
        icon  TYPE string OPTIONAL
        event TYPE string
        arg   TYPE string OPTIONAL
        type  TYPE string DEFAULT `Default`
        span  TYPE string OPTIONAL.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_548 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_clear( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - CSS - Calculator Built from a Grid and a Stylesheet`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `No custom control: the keypad is a sap.ui.layout.Grid of four columns, every key a Button ` &&
                   `with width 100%, and the 0 key spans two columns through GridData. The stylesheet below only ` &&
                   `makes things large - the keys, their text and the display. The arithmetic runs in ABAP.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " raw markup travels in the content attribute of a core:HTML leaf - the
    " builder re-escapes it on stringify, so the literal markup is written here.
    " A Button's height and font size are not properties, so the own class
    " calcKey reaches into the button's inner elements
    page->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>` && |\n| &&
                         `.calcDisplay \{` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `    line-height: 3rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         `.calcHistory \{` && |\n| &&
                         `    font-size: 1.25rem !important;` && |\n| &&
                         `    min-height: 1.5rem;` && |\n| &&
                         `\}` && |\n| &&
                         `.calcKey, .calcKey .sapMBtnInner \{` && |\n| &&
                         `    width: 100% !important;` && |\n| &&
                         `    height: 4.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         `.calcKey .sapMBtnContent, .calcKey .sapMBtnText, .calcKey .sapMBtnIcon \{` && |\n| &&
                         `    font-size: 1.75rem !important;` && |\n| &&
                         `    line-height: 4.5rem !important;` && |\n| &&
                         `    max-height: none !important;` && |\n| &&
                         `\}` && |\n| &&
                         `</style>` ).

    DATA(box) = page->ele( `VBox`
        )->a( n = `width` v = `22rem`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    box->tag( `Text`
        )->a( n = `text`      v = client->_bind( history )
        )->a( n = `textAlign` v = `End`
        )->a( n = `width`     v = `100%`
        )->a( n = `class`     v = `calcHistory` ).
    box->tag( `Text`
        )->a( n = `text`      v = client->_bind( display )
        )->a( n = `textAlign` v = `End`
        )->a( n = `width`     v = `100%`
        )->a( n = `wrapping`  b = abap_false
        )->a( n = `class`     v = `calcDisplay sapUiSmallMarginBottom` ).

    " four keys per row on every screen size - S3 is a quarter of the 12 columns
    DATA(grid) = box->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `XL3 L3 M3 S3`
        )->a( n = `hSpacing`    v = `0.5`
        )->a( n = `vSpacing`    v = `0.5` ).

    key_add( grid = grid text = `C` event = `CLEAR` type = `Reject` ).
    key_add( grid = grid text = `+/-` event = `SIGN` ).
    key_add( grid = grid icon = `sap-icon://arrow-left` event = `BACKSPACE` ).
    key_add( grid = grid text = `/` event = `OPERATOR` arg = `DIV` type = `Emphasized` ).

    key_add( grid = grid text = `7` event = `DIGIT` arg = `7` ).
    key_add( grid = grid text = `8` event = `DIGIT` arg = `8` ).
    key_add( grid = grid text = `9` event = `DIGIT` arg = `9` ).
    key_add( grid = grid text = `*` event = `OPERATOR` arg = `MUL` type = `Emphasized` ).

    key_add( grid = grid text = `4` event = `DIGIT` arg = `4` ).
    key_add( grid = grid text = `5` event = `DIGIT` arg = `5` ).
    key_add( grid = grid text = `6` event = `DIGIT` arg = `6` ).
    key_add( grid = grid text = `-` event = `OPERATOR` arg = `SUB` type = `Emphasized` ).

    key_add( grid = grid text = `1` event = `DIGIT` arg = `1` ).
    key_add( grid = grid text = `2` event = `DIGIT` arg = `2` ).
    key_add( grid = grid text = `3` event = `DIGIT` arg = `3` ).
    key_add( grid = grid text = `+` event = `OPERATOR` arg = `ADD` type = `Emphasized` ).

    key_add( grid = grid text = `0` event = `DIGIT` arg = `0` span = `XL6 L6 M6 S6` ).
    key_add( grid = grid text = `.` event = `DECIMAL` ).
    key_add( grid = grid text = `=` event = `EQUALS` type = `Accept` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `DIGIT`.
        on_digit( client->get_event_arg( ) ).
      WHEN `OPERATOR`.
        on_operator( client->get_event_arg( ) ).
      WHEN `EQUALS`.
        on_equals( ).
      WHEN `DECIMAL`.
        on_decimal( ).
      WHEN `CLEAR`.
        on_clear( ).
      WHEN `BACKSPACE`.
        on_backspace( ).
      WHEN `SIGN`.
        on_sign( ).
    ENDCASE.

  ENDMETHOD.


  METHOD key_add.

    " an empty attribute is rendered as it is - text or icon, never both
    DATA(key) = grid->ele( `Button` ).
    IF icon IS INITIAL.
      key->a( n = `text` v = text ).
    ELSE.
      key->a( n = `icon` v = icon ).
    ENDIF.
    " the digit or operator travels as the event's argument - one event per
    " kind of key instead of one per key; a key without one sends it empty
    key->a( n = `type`  v = type
        )->a( n = `width` v = `100%`
        )->a( n = `class` v = `calcKey`
        )->a( n = `press` v = client->_event( val = event arg = arg ) ).

    IF span IS NOT INITIAL.
      key->ele( `layoutData`
          )->tag( n = `GridData` ns = `layout`
              )->a( n = `span` v = span ).
    ENDIF.

  ENDMETHOD.


  METHOD on_digit.

    IF new_input = abap_true OR display = `0`.
      display   = digit.
      new_input = abap_false.
      RETURN.
    ENDIF.

    IF strlen( display ) >= max_length.
      RETURN.
    ENDIF.

    display = display && digit.

  ENDMETHOD.


  METHOD on_decimal.

    IF new_input = abap_true.
      display   = `0.`.
      new_input = abap_false.
      RETURN.
    ENDIF.

    IF display CA `.` OR strlen( display ) >= max_length.
      RETURN.
    ENDIF.

    display = display && `.`.

  ENDMETHOD.


  METHOD on_operator.

    " a second operator right after the first only replaces it; after a
    " number it finishes the pending calculation first, as 2 + 3 * does
    IF operator IS NOT INITIAL AND new_input = abap_false.
      IF calculate( ) = abap_false.
        RETURN.
      ENDIF.
    ELSEIF operator IS INITIAL.
      operand = display_get( ).
    ENDIF.

    operator  = val.
    new_input = abap_true.

    display_set( operand ).
    history = |{ display } { operator_sign( operator ) }|.

  ENDMETHOD.


  METHOD on_equals.

    IF operator IS INITIAL.
      RETURN.
    ENDIF.

    DATA(line) = |{ history } { display } =|.

    IF calculate( ) = abap_false.
      RETURN.
    ENDIF.

    display_set( operand ).
    history   = line.
    new_input = abap_true.
    CLEAR operator.

  ENDMETHOD.


  METHOD on_clear.

    CLEAR operand.
    CLEAR operator.
    CLEAR history.
    display   = `0`.
    new_input = abap_true.

  ENDMETHOD.


  METHOD on_backspace.

    IF new_input = abap_true.
      RETURN.
    ENDIF.

    DATA(length) = strlen( display ) - 1.
    IF length > 0.
      display = display(length).
    ELSE.
      CLEAR display.
    ENDIF.

    IF display IS INITIAL OR display = `-`.
      display   = `0`.
      new_input = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD on_sign.

    IF display_get( ) = 0.
      RETURN.
    ENDIF.

    IF display(1) = `-`.
      display = substring( val = display off = 1 ).
    ELSE.
      display = `-` && display.
    ENDIF.

    " a negated result is the start of a new input
    new_input = abap_false.

  ENDMETHOD.


  METHOD calculate.

    DATA(value) = display_get( ).

    TRY.
        CASE operator.
          WHEN `ADD`.
            operand = operand + value.
          WHEN `SUB`.
            operand = operand - value.
          WHEN `MUL`.
            operand = operand * value.
          WHEN `DIV`.
            IF value = 0.
              client->message_toast_display( `Division by zero is not possible` ).
              RETURN.
            ENDIF.
            operand = operand / value.
        ENDCASE.
      CATCH cx_sy_arithmetic_error.
        client->message_toast_display( `The result is too large` ).
        RETURN.
    ENDTRY.

    result = abap_true.

  ENDMETHOD.


  METHOD display_get.

    TRY.
        result = display.
      CATCH cx_sy_conversion_error.
        CLEAR result.
    ENDTRY.

  ENDMETHOD.


  METHOD display_set.

    DATA value  TYPE decfloat34.
    DATA length TYPE i.

    value = val.
    TRY.
        value = round( val = value dec = 10 ).
      CATCH cx_sy_arithmetic_error.
        " too large to round - shown as it is
        value = val.
    ENDTRY.

    display = |{ value STYLE = SIMPLE }|.

    " trailing zeros of the fraction go, the zeros of an exponent stay
    IF display CA `.` AND display NA `E`.
      length = strlen( display ) - 1.
      WHILE length > 0 AND display+length(1) = `0`.
        display = display(length).
        length = length - 1.
      ENDWHILE.
      IF display+length(1) = `.`.
        display = display(length).
      ENDIF.
    ENDIF.

    IF display IS INITIAL OR display = `-0`.
      display = `0`.
    ENDIF.

  ENDMETHOD.


  METHOD operator_sign.

    CASE val.
      WHEN `ADD`.
        result = `+`.
      WHEN `SUB`.
        result = `-`.
      WHEN `MUL`.
        result = `*`.
      WHEN `DIV`.
        result = `/`.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
