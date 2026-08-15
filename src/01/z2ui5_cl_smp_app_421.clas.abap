" @keywords table cell column row aggregation set_focus
CLASS z2ui5_cl_smp_app_421 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        index       TYPE i,
        title       TYPE string,
        value       TYPE string,
        info        TYPE string,
        checkbox    TYPE abap_bool,
        description TYPE string,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA focuscolumn TYPE string.
    DATA focusrow    TYPE string.
    DATA focusid     TYPE string READ-ONLY.

  PROTECTED SECTION.
    CONSTANTS:
      BEGIN OF cs_column,
        title       TYPE string VALUE `Title`,
        color       TYPE string VALUE `Color`,
        info        TYPE string VALUE `Info`,
        checkbox    TYPE string VALUE `Checkbox`,
        description TYPE string VALUE `Description`,
      END OF cs_column.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS focus.
    METHODS read_focus.
    METHODS next_focus.
    METHODS default_focus.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_421 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_tab = VALUE #(
        ( index = 0 title = `entry 01` value = `red`    info = `completed` description = `this is a description` checkbox = abap_true )
        ( index = 1 title = `entry 02` value = `blue`   info = `completed` description = `this is a description` checkbox = abap_true )
        ( index = 2 title = `entry 03` value = `green`  info = `completed` description = `this is a description` checkbox = abap_true )
        ( index = 3 title = `entry 04` value = `orange` info = `completed` description = ``                     checkbox = abap_true )
        ( index = 4 title = `entry 05` value = `grey`   info = `completed` description = `this is a description` checkbox = abap_true )
        ( index = 5 ) ).

    default_focus( ).
    view_display( ).
    focus( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `FOCUS`.
        focus( ).
      WHEN `NEXT`.
        read_focus( ).
        next_focus( ).
        focus( ).
      WHEN `RESET`.
        default_focus( ).
        focus( ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Focus - Focus a Table Cell by Column and Row`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Set the keyboard focus to any editable table cell from the backend - type a column id ` &&
                   `(Title, Color, Info, Checkbox or Description) and a row index, then press Set Focus, or ` &&
                   `use Next / Reset. No JavaScript is shipped with the view: every cell has a stable control ` &&
                   `id (<column>_<row>) that the set_focus follow-up action targets, and the framework reports ` &&
                   `the currently focused cell back to the backend in s_focus.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = client->_bind( focusid )
                )->tag( `ToolbarSpacer`
                )->tag( `Label`
                    )->a( n = `text` v = `Column Id`
                )->tag( `Input`
                    )->a( n = `placeholder` v = `Column`
                    )->a( n = `value`       v = client->_bind( focuscolumn )
                    )->a( n = `submit`      v = client->_event( `FOCUS` )
                    )->a( n = `width`       v = `8rem`
                )->tag( `Label`
                    )->a( n = `text` v = `Row Index`
                )->tag( `Input`
                    )->a( n = `placeholder` v = `Row`
                    )->a( n = `type`        v = `Number`
                    )->a( n = `value`       v = client->_bind( focusrow )
                    )->a( n = `submit`      v = client->_event( `FOCUS` )
                    )->a( n = `width`       v = `6rem`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `FOCUS` )
                    )->a( n = `text`  v = `Set Focus`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `NEXT` )
                    )->a( n = `text`  v = `Next Focus`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `RESET` )
                    )->a( n = `text`  v = `Reset Focus`
            )->end(
        )->end( ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Index`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Title`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Color`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Info`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Checkbox`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Description` ).

    " Build the rows explicitly (no aggregation binding): only then does every
    " cell keep the stable control id <column>_<row> that set_focus can target.
    " A bound template would clone the cells under randomly generated ids.
    DATA(path)  = client->_bind( val = t_tab path = abap_true ).
    DATA(items) = tab->ele( `items` ).

    LOOP AT t_tab REFERENCE INTO DATA(row).

      DATA(i) = sy-tabix - 1.

      items->ele( `ColumnListItem`
          )->ele( `cells`
              )->tag( `Text`
                  )->a( n = `text` v = |{ row->index }|
              )->tag( `Input`
                  )->a( n = `id`     v = |{ cs_column-title }_{ i }|
                  )->a( n = `value`  v = |\{{ path }/{ i }/TITLE\}|
                  )->a( n = `submit` v = client->_event( `NEXT` )
              )->tag( `Input`
                  )->a( n = `id`     v = |{ cs_column-color }_{ i }|
                  )->a( n = `value`  v = |\{{ path }/{ i }/VALUE\}|
                  )->a( n = `submit` v = client->_event( `NEXT` )
              )->tag( `Input`
                  )->a( n = `id`     v = |{ cs_column-info }_{ i }|
                  )->a( n = `value`  v = |\{{ path }/{ i }/INFO\}|
                  )->a( n = `submit` v = client->_event( `NEXT` )
              )->tag( `CheckBox`
                  )->a( n = `id`       v = |{ cs_column-checkbox }_{ i }|
                  )->a( n = `selected` v = |\{{ path }/{ i }/CHECKBOX\}|
              )->tag( `Input`
                  )->a( n = `id`     v = |{ cs_column-description }_{ i }|
                  )->a( n = `value`  v = |\{{ path }/{ i }/DESCRIPTION\}|
                  )->a( n = `submit` v = client->_event( `NEXT` ) ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD focus.

    focusid = |{ focuscolumn }_{ focusrow }|.

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_focus
        t_arg = VALUE #( ( focusid ) ) ).

  ENDMETHOD.


  METHOD read_focus.

    SPLIT client->get( )-s_focus-id AT `_` INTO DATA(col) DATA(row).

    IF row IS NOT INITIAL
        AND row CO `0123456789`
        AND ( col = cs_column-title
           OR col = cs_column-color
           OR col = cs_column-info
           OR col = cs_column-checkbox
           OR col = cs_column-description ).

      focuscolumn = col.
      focusrow    = row.
    ENDIF.

  ENDMETHOD.


  METHOD next_focus.

    focuscolumn = SWITCH #( focuscolumn
                            WHEN cs_column-title    THEN cs_column-color
                            WHEN cs_column-color    THEN cs_column-info
                            WHEN cs_column-info     THEN cs_column-checkbox
                            WHEN cs_column-checkbox THEN cs_column-description
                            ELSE cs_column-title ).

    IF focuscolumn = cs_column-title.

      DATA(nextrow) = CONV i( focusrow ) + 1.
      IF line_exists( t_tab[ nextrow + 1 ] ).
        focusrow = |{ nextrow }|.
      ELSE.
        focusrow = `0`.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD default_focus.

    focuscolumn = cs_column-title.
    focusrow    = `0`.

  ENDMETHOD.

ENDCLASS.
