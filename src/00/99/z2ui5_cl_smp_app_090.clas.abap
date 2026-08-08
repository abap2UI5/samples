CLASS z2ui5_cl_smp_app_090 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_column,
        name    TYPE string,
        label   TYPE string,
        visible TYPE abap_bool,
      END OF ty_s_column.
    TYPES:
      BEGIN OF ty_s_sort,
        name       TYPE string,
        label      TYPE string,
        sorted     TYPE abap_bool,
        descending TYPE abap_bool,
      END OF ty_s_sort.
    TYPES:
      BEGIN OF ty_s_group,
        name    TYPE string,
        label   TYPE string,
        grouped TYPE abap_bool,
      END OF ty_s_group.

    DATA t_columns TYPE STANDARD TABLE OF ty_s_column WITH EMPTY KEY.
    DATA t_sort TYPE STANDARD TABLE OF ty_s_sort WITH EMPTY KEY.
    DATA t_group TYPE STANDARD TABLE OF ty_s_group WITH EMPTY KEY.

  PROTECTED SECTION.
    CONSTANTS c_panel_columns TYPE string VALUE `columnsPanel`.
    CONSTANTS c_panel_sort TYPE string VALUE `sortPanel`.
    CONSTANTS c_panel_group TYPE string VALUE `groupPanel`.
    CONSTANTS c_popup TYPE string VALUE `p13nPopup`.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS on_event_open.
    METHODS view_display.
    METHODS panel_seed
      IMPORTING
        panel TYPE string
        val   TYPE any.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_090 IMPLEMENTATION.

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

    data_read( ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `P13N_OPEN`.
        on_event_open( ).

      WHEN `COLUMNS_CHANGED`.
        TRY.
            z2ui5_cl_ajson=>parse( client->get_event_arg( )
              )->to_abap_corresponding_only(
              )->to_abap( IMPORTING ev_container = t_columns ).
          CATCH z2ui5_cx_ajson_error INTO DATA(lx).
            client->message_box_display( lx->get_text( ) ).
        ENDTRY.

      WHEN `SORT_CHANGED`.
        TRY.
            z2ui5_cl_ajson=>parse( client->get_event_arg( )
              )->to_abap_corresponding_only(
              )->to_abap( IMPORTING ev_container = t_sort ).
          CATCH z2ui5_cx_ajson_error INTO lx.
            client->message_box_display( lx->get_text( ) ).
        ENDTRY.

      WHEN `GROUP_CHANGED`.
        TRY.
            z2ui5_cl_ajson=>parse( client->get_event_arg( )
              )->to_abap_corresponding_only(
              )->to_abap( IMPORTING ev_container = t_group ).
          CATCH z2ui5_cx_ajson_error INTO lx.
            client->message_box_display( lx->get_text( ) ).
        ENDTRY.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_open.

    " The p13n panels take their items ONLY through setP13nData - they expose
    " no aggregation to bind against - so the list travels as one JSON payload
    " through the control_by_id frontend action. The follow-up actions run in
    " order after the response rendered, so the panels are filled before the
    " popup opens.
    panel_seed( panel = c_panel_columns
                val   = t_columns ).
    panel_seed( panel = c_panel_sort
                val   = t_sort ).
    panel_seed( panel = c_panel_group
                val   = t_group ).

    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( c_popup ) ( `open` ) ) ).

  ENDMETHOD.


  METHOD panel_seed.

    TRY.
        DATA(json) = z2ui5_cl_ajson=>create_empty(
            ii_custom_mapping = z2ui5_cl_ajson_mapping=>create_lower_case( )
          )->set( iv_path = `/`
                  iv_val  = val )->stringify( ).
      CATCH z2ui5_cx_ajson_error INTO DATA(lx).
        client->message_box_display( lx->get_text( ) ).
        RETURN.
    ENDTRY.

    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( panel ) ( `setP13nData` ) ( json ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title          = `abap2UI5 - P13N Dialog`
                                       navbuttonpress = client->_event_nav_app_leave( )
                                       shownavbutton  = client->check_app_prev_stack( )
                                       class          = `sapUiContentPadding` ).

    page->message_strip(
        text     = `A sap.m.p13n popup driven entirely from ABAP. Its panels are ` &&
                   `filled with follow_up_action( control_by_id, setP13nData ) and ` &&
                   `report the user's changes back through their own change event, ` &&
                   `so the personalization state lives in the backend model. No ` &&
                   `custom JavaScript is involved.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(popup) = page->vbox(
      )->_generic( name   = `Popup`
                   ns     = `p13n`
                   t_prop = VALUE #( ( n = `id`    v = c_popup )
                                     ( n = `title` v = `My Custom View Settings` ) )
        )->_generic( name = `panels`
                     ns   = `p13n` ).

    popup->_generic( name   = `SelectionPanel`
                     ns     = `p13n`
                     t_prop = VALUE #( ( n = `id`     v = c_panel_columns )
                                       ( n = `title`  v = `Columns` )
                                       ( n = `change` v = client->_event(
                                             val   = `COLUMNS_CHANGED`
                                             t_arg = VALUE #( ( `$event.oSource.getP13nData()` ) ) ) ) )
      )->get_parent( ).

    popup->_generic( name   = `SortPanel`
                     ns     = `p13n`
                     t_prop = VALUE #( ( n = `id`     v = c_panel_sort )
                                       ( n = `title`  v = `Sort` )
                                       ( n = `change` v = client->_event(
                                             val   = `SORT_CHANGED`
                                             t_arg = VALUE #( ( `$event.oSource.getP13nData()` ) ) ) ) )
      )->get_parent( ).

    popup->_generic( name   = `GroupPanel`
                     ns     = `p13n`
                     t_prop = VALUE #( ( n = `id`     v = c_panel_group )
                                       ( n = `title`  v = `Group` )
                                       ( n = `change` v = client->_event(
                                             val   = `GROUP_CHANGED`
                                             t_arg = VALUE #( ( `$event.oSource.getP13nData()` ) ) ) ) )
      )->get_parent( )->get_parent( )->get_parent( ).

    page->button( text  = `Open P13N Popup`
                  type  = `Emphasized`
                  press = client->_event( `P13N_OPEN` )
                  class = `sapUiTinyMarginBeginEnd` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD data_read.

    t_columns = VALUE #( ( name = `key1` label = `City`    visible = abap_true )
                         ( name = `key2` label = `Country` visible = abap_false )
                         ( name = `key3` label = `Region`  visible = abap_false ) ).

    t_sort = VALUE #( ( name = `key1` label = `City`    sorted = abap_true  descending = abap_true )
                      ( name = `key2` label = `Country` sorted = abap_false descending = abap_false )
                      ( name = `key3` label = `Region`  sorted = abap_false descending = abap_false ) ).

    t_group = VALUE #( ( name = `key1` label = `City`    grouped = abap_true )
                       ( name = `key2` label = `Country` grouped = abap_false )
                       ( name = `key3` label = `Region`  grouped = abap_false ) ).

  ENDMETHOD.

ENDCLASS.
