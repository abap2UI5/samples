" @keywords barcode scanner scan field submit enter soft keyboard none inputext focus warehouse
" @summary A scan field: InputExt keeps the soft keyboard down, the cursor is parked in the field, and the scanner's Enter fires submit straight into the backend.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/soft_keyboard
CLASS z2ui5_cl_smp_app_530 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_scan,
        pos  TYPE i,
        code TYPE string,
      END OF ty_s_scan.

    " what the field holds right now, and everything scanned so far
    DATA value TYPE string.
    DATA t_scans TYPE STANDARD TABLE OF ty_s_scan WITH EMPTY KEY.

    " bound straight onto InputExt.inputMode: `none` keeps the on-screen
    " keyboard down while the field goes on taking input, `text` brings it
    " back. It is model data, so the toggle is a plain model update
    DATA mode TYPE string VALUE `none`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    CONSTANTS c_field TYPE string VALUE `scanField`.

    METHODS view_display.
    METHODS on_event.
    METHODS focus_field.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_530 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
      " land in the field, so the first scan needs no tap at all
      focus_field( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SUBMIT`.
        " a scanner types the code and sends Enter - sap.m.Input raises
        " submit, and the wire carries the value with it, so the roundtrip
        " already has what was scanned
        IF value IS NOT INITIAL.
          INSERT VALUE #( pos  = lines( t_scans ) + 1
                          code = value ) INTO TABLE t_scans.
          value = ``.
        ENDIF.
        " back into the empty field, ready for the next code
        focus_field( ).

      WHEN `TOGGLE`.
        mode = COND #( WHEN mode = `none` THEN `text` ELSE `none` ).
        focus_field( ).

      WHEN `CLEAR`.
        t_scans = VALUE #( ).

    ENDCASE.

  ENDMETHOD.


  METHOD focus_field.

    client->follow_up_action( val   = client->cs_event-set_focus
                              t_arg = VALUE #( ( c_field ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Browser - Scan Field with Submit`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A warehouse scan field. The keyboard stays DOWN (InputExt inputMode = none) while the ` &&
                   `field keeps taking input, SET_FOCUS parks the cursor in it, and the scanner's Enter raises submit - ` &&
                   `so a whole shift of scanning needs no tap. Z2UI5_CL_SMP_APP_516 shows the inputMode values themselves.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( n = `InputExt` ns = `z2ui5`
            )->a( n = `id`          v = c_field
            )->a( n = `value`       v = client->_bind( value )
            )->a( n = `inputMode`   v = client->_bind( mode )
            )->a( n = `submit`      v = client->_event( `SUBMIT` )
            )->a( n = `placeholder` v = `scan a code, or type and press Enter`
            )->a( n = `width`       v = `24rem`

        )->tag( `ObjectStatus`
            )->a( n = `title` v = `inputMode`
            )->a( n = `text`  v = client->_bind( mode )
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiSmallMarginBottom` ).

    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMarginBegin`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `TOGGLE` )
            )->a( n = `text`  v = `keyboard on/off`
            )->a( n = `icon`  v = `sap-icon://keyboard-and-mouse`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `CLEAR` )
            )->a( n = `text`  v = `clear list`
            )->a( n = `icon`  v = `sap-icon://delete`
            )->a( n = `type`  v = `Reject` ).

    DATA(table) = page->ele( `Table`
        )->a( n = `items`      v = client->_bind( t_scans )
        )->a( n = `headerText` v = `Scanned`
        )->a( n = `class`      v = `sapUiSmallMargin` ).

    table->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `#`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Code` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{POS}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
