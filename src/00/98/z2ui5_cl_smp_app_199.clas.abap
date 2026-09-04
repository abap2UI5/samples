CLASS z2ui5_cl_smp_app_199 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table   TYPE REF TO data.
    DATA mv_counter TYPE string.
    DATA mt_comp    TYPE abap_component_tab.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

    METHODS refresh_data.
    METHODS add_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_199 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get_event( ).
      WHEN `CLEAR`.
        refresh_data( ).

      WHEN `ADD`.
        add_data( ).

    ENDCASE.

  ENDMETHOD.


  METHOD on_init.

    refresh_data( ).
    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    FIELD-SYMBOLS <tab> TYPE data.
    ASSIGN mt_table->* TO <tab>.

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `Refresh`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `id`             v = `page_main` ).
    DATA(table) = page->ele( `Table`
        )->a( n = `items`   v = client->_bind( <tab> )
        )->a( n = `growing` v = `true`
        )->a( n = `width`   v = `auto` ).

    DATA(columns) = table->ele( `columns` ).

    LOOP AT mt_comp INTO DATA(comp).
      columns->ele( `Column`
          )->tag( `Text`
              )->a( n = `text` v = comp-name ).
    ENDLOOP.

    DATA(cells) = columns->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->a( n = `vAlign` v = `Middle`
                )->a( n = `type`   v = `Navigation`
                )->ele( `cells` ).

    LOOP AT mt_comp INTO comp.
      cells->ele( `ObjectIdentifier`
          )->a( n = `text` v = |\{{ comp-name }\}| ).
    ENDLOOP.

    page->tag( `Button`
        )->a( n = `press` v = client->_event( `CLEAR` )
        )->a( n = `text`  v = `Clear`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `ADD` )
            )->a( n = `text`  v = `Add` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

    ASSIGN mt_table->* TO <tab>.

    IF lines( <tab> ) <> mv_counter AND mv_counter IS NOT INITIAL.
      client->message_box_display( text = `Frontend Lines <> Backend!` type = `error` ).
    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD refresh_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    TRY.

        CREATE DATA mt_table TYPE STANDARD TABLE OF z2ui5_t_01.
        ASSIGN mt_table->* TO <table>.
        mt_comp = CAST cl_abap_structdescr(
                      CAST cl_abap_tabledescr(
                          cl_abap_typedescr=>describe_by_data( <table> ) )->get_table_line_type( ) )->get_components( ).

        SELECT id, id_prev FROM z2ui5_t_01
          ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 2 ROWS.

        mv_counter = 2.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD add_data.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.
    APPEND LINES OF <tab> TO <tab>.

    mv_counter = lines( <tab> ).

  ENDMETHOD.

ENDCLASS.
