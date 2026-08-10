"! Follow-up of https://github.com/abap2UI5/abap2UI5/issues/988#issuecomment-1978738754
CLASS z2ui5_cl_smp_app_179 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_relation,
        relationid  TYPE string,
        type        TYPE string,
        predecessor TYPE string,
        successor   TYPE string,
      END OF ty_s_relation.
    TYPES ty_t_relation TYPE STANDARD TABLE OF ty_s_relation WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_task,
        objectid      TYPE string,
        objectname    TYPE string,
        starttime     TYPE string,
        endtime       TYPE string,
        relationships TYPE ty_t_relation,
      END OF ty_s_task.
    TYPES:
      BEGIN OF ty_s_phase,
        objectid      TYPE string,
        objectname    TYPE string,
        starttime     TYPE string,
        endtime       TYPE string,
        relationships TYPE ty_t_relation,
        children      TYPE STANDARD TABLE OF ty_s_task WITH DEFAULT KEY,
      END OF ty_s_phase.
    TYPES:
      BEGIN OF ty_s_root,
        children TYPE STANDARD TABLE OF ty_s_phase WITH DEFAULT KEY,
      END OF ty_s_root.
    DATA s_root TYPE ty_s_root.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_179 IMPLEMENTATION.


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

    DATA(page) = view->shell( )->page(
        id             = `page_main`
        title          = `abap2UI5 - Gantt Chart with Relationships`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( )
        class          = `sapUiContentPadding` ).

    page->message_strip(
        text     = `A sap.gantt chart whose shapes are connected by relationships: ` &&
                   `every row carries a nested RELATIONSHIPS table, and each entry ` &&
                   `draws a connector of its own type (FinishToStart, StartToStart, ...) ` &&
                   `from a predecessor to a successor shape. Use the container toolbar ` &&
                   `to zoom, search and switch the display type.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(container) = page->scroll_container( horizontal = abap_true
      )->gantt_chart_container( ).

    container->gantt_toolbar(
      )->container_toolbar( showsearchbutton      = abap_true
                            showdisplaytypebutton = abap_true
                            showlegendbutton      = abap_true
                            showsettingbutton     = abap_true
                            showtimezoomcontrol   = abap_true ).

    DATA(gantt) = container->gantt_chart_with_table(
        id                        = `gantt`
        shapeselectionmode        = `Single`
        isconnectordetailsvisible = abap_true ).

    gantt->axis_time_strategy(
      )->proportion_zoom_strategy(
        )->total_horizon(
          )->time_horizon( starttime = `20181101000000`
                           endtime   = `20181130000000` )->get_parent( )->get_parent(
        )->visible_horizon(
          )->time_horizon( starttime = `20181101000000`
                           endtime   = `20181130000000` ).

    DATA(tree) = gantt->gantt_table(
      )->tree_table( rows = |\{ path: '{ client->_bind( val  = s_root
                                                        path = abap_true ) }', | &&
                            |parameters: \{ arrayNames: ['CHILDREN'], numberOfExpandedLevels: 2 \} \}| ).

    DATA(column) = tree->ui_columns( )->ui_column( id = `col_objectname` ).

    column->ui_custom_data(
      )->core_custom_data( key   = `exportTableColumnConfig`
                           value = `{"columnKey": "OBJECTNAME", ` &&
                                   `"leadingProperty": "OBJECTNAME", ` &&
                                   `"dataType": "string", ` &&
                                   `"wrap": true}` ).

    column->text( `Object Name` ).
    column->tree_template( )->label( `{OBJECTNAME}` ).

    DATA(row_settings) = tree->row_settings_template(
      )->gantt_row_settings( rowid         = `{OBJECTID}`
                             relationships = `{path: 'RELATIONSHIPS', templateShareable: false}` ).

    row_settings->shapes1(
      )->base_rectangle( shapeid                 = `{OBJECTID}`
                         time                    = `{= Formatter.DateCreateObject(${STARTTIME}) }`
                         endtime                 = `{= Formatter.DateCreateObject(${ENDTIME}) }`
                         height                  = `19`
                         title                   = `{OBJECTNAME}`
                         connectable             = abap_true
                         horizontaltextalignment = `Start` ).

    row_settings->relationships(
      )->relationship( shapeid     = `{RELATIONID}`
                       type        = `{TYPE}`
                       predecessor = `{PREDECESSOR}`
                       successor   = `{SUCCESSOR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD data_read.

    s_root = VALUE #(
        children = VALUE #(
            ( objectid      = `object-0-1`
              objectname    = `Phase 1 - Design`
              starttime     = `2018-11-01T09:00:00`
              endtime       = `2018-11-10T17:00:00`
              relationships = VALUE #( ( relationid  = `rls-4`
                                         type        = `StartToFinish`
                                         predecessor = `object-0-1`
                                         successor   = `object-0-2` ) )
              children      = VALUE #(
                  ( objectid      = `object-0-1-1`
                    objectname    = `Draft`
                    starttime     = `2018-11-01T09:00:00`
                    endtime       = `2018-11-05T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-0`
                                               type        = `StartToFinish`
                                               predecessor = `object-0-1-1`
                                               successor   = `object-0-1-2` ) ) )
                  ( objectid   = `object-0-1-2`
                    objectname = `Review`
                    starttime  = `2018-11-06T09:00:00`
                    endtime    = `2018-11-10T17:00:00` ) ) )

            ( objectid   = `object-0-2`
              objectname = `Phase 2 - Build`
              starttime  = `2018-11-11T09:00:00`
              endtime    = `2018-11-24T17:00:00`
              children   = VALUE #(
                  ( objectid      = `object-0-2-1`
                    objectname    = `Prepare`
                    starttime     = `2018-11-11T09:00:00`
                    endtime       = `2018-11-13T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-2`
                                               type        = `StartToStart`
                                               predecessor = `object-0-2-1`
                                               successor   = `object-0-2-4` )
                                             ( relationid  = `rls-3`
                                               type        = `FinishToFinish`
                                               predecessor = `object-0-2-1`
                                               successor   = `object-0-2-3` ) ) )
                  ( objectid      = `object-0-2-2`
                    objectname    = `Implement`
                    starttime     = `2018-11-14T09:00:00`
                    endtime       = `2018-11-17T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-1`
                                               type        = `FinishToFinish`
                                               predecessor = `object-0-2-2`
                                               successor   = `object-0-2-3` ) ) )
                  ( objectid   = `object-0-2-3`
                    objectname = `Test`
                    starttime  = `2018-11-18T09:00:00`
                    endtime    = `2018-11-20T17:00:00` )
                  ( objectid      = `object-0-2-4`
                    objectname    = `Ship`
                    starttime     = `2018-11-21T09:00:00`
                    endtime       = `2018-11-22T17:00:00`
                    relationships = VALUE #( ( relationid  = `rls-5`
                                               type        = `FinishToStart`
                                               predecessor = `object-0-2-4`
                                               successor   = `object-0-2-5` ) ) )
                  ( objectid   = `object-0-2-5`
                    objectname = `Handover`
                    starttime  = `2018-11-23T09:00:00`
                    endtime    = `2018-11-24T17:00:00` ) ) )

            ( objectid      = `object-0-3`
              objectname    = `Phase 3 - Close`
              starttime     = `2018-11-25T09:00:00`
              endtime       = `2018-11-29T17:00:00`
              relationships = VALUE #( ( relationid  = `rls-6`
                                         type        = `FinishToStart`
                                         predecessor = `object-0-3`
                                         successor   = `object-0-3-1` ) )
              children      = VALUE #(
                  ( objectid   = `object-0-3-1`
                    objectname = `Sign off`
                    starttime  = `2018-11-25T09:00:00`
                    endtime    = `2018-11-29T17:00:00` ) ) ) ) ).

  ENDMETHOD.
ENDCLASS.
