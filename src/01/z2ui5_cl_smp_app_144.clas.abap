" @keywords cell input internal table row field level
" @summary Edits one cell of an internal table: tab_index addresses the row, so the Input writes back to a single field instead of the whole line.
" @docs https://abap2ui5.github.io/docs/cookbook/model/binding
CLASS z2ui5_cl_smp_app_144 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title TYPE string,
        value TYPE string,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    METHODS set_view.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS Z2UI5_CL_SMP_APP_144 IMPLEMENTATION.


  METHOD set_view.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Single Table Cell (tab_index)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample demonstrates cell-level binding: each input is bound to one ` &&
                   `cell of an internal table via tab_index, so edits target exactly that row and field.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    LOOP AT t_tab REFERENCE INTO DATA(lr_row).
      DATA(lv_tabix) = sy-tabix.
      page->tag( `Input`
          )->a( n = `value` v = client->_bind( val = lr_row->title tab = t_tab tab_index = lv_tabix ) ).
      page->tag( `Input`
          )->a( n = `value` v = client->_bind( val = lr_row->value tab = t_tab tab_index = lv_tabix ) ).
    ENDLOOP.

    page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_tab )
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `title of the table`
            )->end(
        )->end(
        )->ele( `columns`
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Title`
            )->end(
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Value`
            )->end(
        )->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->ele( `cells`
                    )->tag( `Input`
                        )->a( n = `value` v = `{TITLE}`
                    )->tag( `Input`
                        )->a( n = `value` v = `{VALUE}` ).

    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = t_tab[ 1 ]-title tab = t_tab tab_index = 1 ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = t_tab[ 1 ]-value tab = t_tab tab_index = 1 ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = t_tab[ 2 ]-title tab = t_tab tab_index = 2 ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = t_tab[ 2 ]-value tab = t_tab tab_index = 2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

        t_tab = VALUE #( BASE t_tab
            ( title = `entry 01`  value = `red` )
            ( title = `entry 02`  value = `blue` ) ).
      set_view( ).
    ELSEIF client->check_on_navigated( ).
      set_view( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
