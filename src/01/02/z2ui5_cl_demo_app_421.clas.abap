CLASS z2ui5_cl_demo_app_421 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_421 IMPLEMENTATION.

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

    CASE client->get( )-event.
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

    client->view_model_update( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Focus a Table Cell`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Set the keyboard focus to any editable table cell from the backend - type a column id ` &&
                   `(Title, Color, Info, Checkbox or Description) and a row index, then press Set Focus, or ` &&
                   `use Next / Reset. No JavaScript is shipped with the view: every cell has a stable control ` &&
                   `id (<column>_<row>) that the set_focus follow-up action targets, and the framework reports ` &&
                   `the currently focused cell back to the backend in s_focus.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(tab) = page->table(
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( client->_bind( focusid )
                )->toolbar_spacer(
                )->label( `Column Id`
                )->input(
                    value       = client->_bind_edit( focuscolumn )
                    submit      = client->_event( `FOCUS` )
                    placeholder = `Column`
                    width       = `8rem`
                )->label( `Row Index`
                )->input(
                    value       = client->_bind_edit( focusrow )
                    submit      = client->_event( `FOCUS` )
                    placeholder = `Row`
                    type        = `Number`
                    width       = `6rem`
                )->button(
                    text  = `Set Focus`
                    press = client->_event( `FOCUS` )
                )->button(
                    text  = `Next Focus`
                    press = client->_event( `NEXT` )
                )->button(
                    text  = `Reset Focus`
                    press = client->_event( `RESET` )
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column( )->text( `Index` )->get_parent(
        )->column( )->text( `Title` )->get_parent(
        )->column( )->text( `Color` )->get_parent(
        )->column( )->text( `Info` )->get_parent(
        )->column( )->text( `Checkbox` )->get_parent(
        )->column( )->text( `Description` ).

    " Build the rows explicitly (no aggregation binding): only then does every
    " cell keep the stable control id <column>_<row> that set_focus can target.
    " A bound template would clone the cells under randomly generated ids.
    DATA(path)  = client->_bind_edit( val = t_tab path = abap_true ).
    DATA(items) = tab->items( ).

    LOOP AT t_tab REFERENCE INTO DATA(row).

      DATA(i) = sy-tabix - 1.

      items->column_list_item(
          )->cells(
              )->text( |{ row->index }|
              )->input(
                  id     = |{ cs_column-title }_{ i }|
                  value  = |\{{ path }/{ i }/TITLE\}|
                  submit = client->_event( `NEXT` )
              )->input(
                  id     = |{ cs_column-color }_{ i }|
                  value  = |\{{ path }/{ i }/VALUE\}|
                  submit = client->_event( `NEXT` )
              )->input(
                  id     = |{ cs_column-info }_{ i }|
                  value  = |\{{ path }/{ i }/INFO\}|
                  submit = client->_event( `NEXT` )
              )->checkbox(
                  id       = |{ cs_column-checkbox }_{ i }|
                  selected = |\{{ path }/{ i }/CHECKBOX\}|
              )->input(
                  id     = |{ cs_column-description }_{ i }|
                  value  = |\{{ path }/{ i }/DESCRIPTION\}|
                  submit = client->_event( `NEXT` ) ).

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
