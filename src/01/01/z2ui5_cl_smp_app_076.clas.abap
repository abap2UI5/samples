CLASS z2ui5_cl_smp_app_076 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_shape,
        id        TYPE string,
        starttime TYPE string,
        endtime   TYPE string,
      END OF ty_s_shape.
    TYPES ty_t_shape TYPE STANDARD TABLE OF ty_s_shape WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_level2,
        id      TYPE string,
        text    TYPE string,
        subtask TYPE ty_t_shape,
      END OF ty_s_level2.
    TYPES:
      BEGIN OF ty_s_level1,
        id       TYPE string,
        text     TYPE string,
        task     TYPE ty_t_shape,
        children TYPE STANDARD TABLE OF ty_s_level2 WITH DEFAULT KEY,
      END OF ty_s_level1.
    TYPES:
      BEGIN OF ty_s_root,
        children TYPE STANDARD TABLE OF ty_s_level1 WITH DEFAULT KEY,
      END OF ty_s_root.
    DATA s_root TYPE ty_s_root.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_076 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      data_read( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter:'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->page(
        id             = `page_main`
        title          = `abap2UI5 - Gantt Chart`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( )
        class          = `sapUiContentPadding` ).

    page->message_strip(
        text     = `A sap.gantt chart fed from a plain ABAP structure: the TreeTable ` &&
                   `builds the rows from the nested CHILDREN tables, every row draws its ` &&
                   `own shapes from TASK (level 1) and SUBTASK (level 2). The ISO ` &&
                   `timestamps are turned into JavaScript Date objects at the point of ` &&
                   `use, because the shape time properties are object-typed.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(gantt) = page->gantt_chart_container(
      )->gantt_chart_with_table( id                 = `gantt`
                                 shapeselectionmode = `Single` ).

    gantt->axis_time_strategy(
      )->proportion_zoom_strategy(
        )->total_horizon(
          )->time_horizon( starttime = `20181029000000`
                           endtime   = `20181129000000` )->get_parent( )->get_parent(
        )->visible_horizon(
          )->time_horizon( starttime = `20181029000000`
                           endtime   = `20181129000000` ).

    DATA(tree) = gantt->gantt_table(
      )->tree_table( rows = |\{ path: '{ client->_bind( val  = s_root
                                                        path = abap_true ) }', | &&
                            |parameters: \{ arrayNames: ['CHILDREN'], numberOfExpandedLevels: 1 \} \}| ).

    tree->tree_columns(
      )->tree_column( `Task`
        )->tree_template(
          )->text( `{TEXT}` ).

    tree->row_settings_template(
      )->gantt_row_settings( rowid   = `{ID}`
                             shapes1 = `{path: 'TASK', templateShareable: false}`
                             shapes2 = `{path: 'SUBTASK', templateShareable: false}`
        )->shapes1(
          )->task( time    = `{= Formatter.DateCreateObject(${STARTTIME}) }`
                   endtime = `{= Formatter.DateCreateObject(${ENDTIME}) }`
                   type    = `SummaryExpanded`
                   color   = `sapUiAccent5` )->get_parent( )->get_parent(
      )->shapes2(
          )->task( time    = `{= Formatter.DateCreateObject(${STARTTIME}) }`
                   endtime = `{= Formatter.DateCreateObject(${ENDTIME}) }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD data_read.

    s_root = VALUE #(
        children = VALUE #(
            ( id       = `line`
              text     = `Level 1`
              task     = VALUE #( ( id        = `rectangle1`
                                    starttime = `2018-11-01T09:00:00`
                                    endtime   = `2018-11-27T09:00:00` ) )
              children = VALUE #(
                  ( id      = `line2`
                    text    = `Level 2`
                    subtask = VALUE #( ( id        = `chevron1`
                                         starttime = `2018-11-01T09:00:00`
                                         endtime   = `2018-11-13T09:00:00` )
                                       ( id        = `chevron2`
                                         starttime = `2018-11-15T09:00:00`
                                         endtime   = `2018-11-27T09:00:00` ) ) ) ) ) ) ).

  ENDMETHOD.
ENDCLASS.
