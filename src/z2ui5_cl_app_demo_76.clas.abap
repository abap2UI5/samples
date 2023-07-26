CLASS z2ui5_cl_app_demo_76 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF t_subtask5,
             id        TYPE string,
             starttime TYPE string,
             endtime   TYPE string,
           END OF t_subtask5.
    TYPES: tt_subtask5 TYPE STANDARD TABLE OF t_subtask5 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_task3,
             id        TYPE string,
             starttime TYPE string,
             endtime   TYPE string,
           END OF t_task3.
    TYPES: BEGIN OF t_children4,
             id      TYPE string,
             text    TYPE string,
             subtask TYPE tt_subtask5,
           END OF t_children4.
    TYPES: tt_task3 TYPE STANDARD TABLE OF t_task3 WITH DEFAULT KEY.
    TYPES: tt_children4 TYPE STANDARD TABLE OF t_children4 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_children2,
             id       TYPE string,
             text     TYPE string,
             task     TYPE tt_task3,
             children TYPE tt_children4,
           END OF t_children2.
    TYPES: tt_children2 TYPE STANDARD TABLE OF t_children2 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_root6,
             children TYPE tt_children2,
           END OF t_root6.
    TYPES: BEGIN OF t_json1,
             root TYPE t_root6,
           END OF t_json1.

    DATA mt_table TYPE t_json1.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_on_init .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .
  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_76 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_set_data( ).
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.


    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = view->page( id = `page_main`
            title          = 'abap2UI5 - Gantt'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true
            class = 'sapUiContentPadding' ).



    DATA(gantt) = page->gantt_chart_container(
      )->gantt_chart_with_table( id = `gantt` shapeselectionmode = `Single`
        )->axis_time_strategy(
          )->proportion_zoom_strategy(
            )->total_horizon(
              )->time_horizon( starttime = `20181029000000` endtime = `20181129000000` )->get_parent( )->get_parent(
            )->visible_horizon(
              )->time_horizon( starttime = `20181029000000` endtime = `20181129000000` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
      )->gantt_table(
        )->tree_table( rows = `{path: '` && client->_bind( val = mt_table path = abap_true ) && `', parameters: {arrayNames: ['CHILDREN'],numberOfExpandedLevels: 1}}`
          )->tree_columns(
            )->tree_column( label = 'Col 1' )->tree_template( )->text( text = `{ID}` )->get_parent( )->get_parent( )->get_parent(
*            )->tree_column( label = 'Col 1' template = 'text' )->get_parent( )->get_parent(
          )->row_settings_template(
            )->gantt_row_settings( rowid = `{ID}` shapes1 = `{path: '{TASK}', templateShareable:false}` shapes2 = `{path: '{SUBTASK}', templateShareable:false}`
              )->shapes1(
*                )->task( time = `{path: 'starttime'}` endtime = `{path: 'endtime'}` type = `SummaryExpanded` color = `sapUiAccent5` )->get_parent( )->get_parent(
                )->task( time = `{path: '{STARTTIME}', formatter: '.fnTimeConverter'}` endtime = `{path: '{ENDTIME}', formatter: '.fnTimeConverter'}` type = `SummaryExpanded` color = `sapUiAccent5` )->get_parent( )->get_parent(
              )->shapes2(
*                )->task( time = `{path: 'starttime'}` endtime = `{path: 'endtime'}` ).
                )->task( time = `{path: '{STARTTIME}', formatter: '.fnTimeConverter'}` endtime = `{path: '{ENDTIME}', formatter: '.fnTimeConverter'}` ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #( root = VALUE #( children = VALUE #( ( id = `line`
                                                              text = `Level 1`
                                                              task = VALUE #( ( id = `rectangle1` starttime = `20181101090000` endtime = `20181127090000`
                                                           ) )
                                                           children = VALUE #( ( id = `line2` text = `Level 2`
                                                                                    subtask = VALUE #( ( id = `chevron1` starttime = `20181101090000` endtime = `20181113090000` )
                                                                                                       ( id = `chevron2` starttime = `20181115090000` endtime = `20181127090000` ) )

                                                           ) ) ) ) ) ).

*    mt_table = VALUE #( children = VALUE #( ( id = `line`
*                                                              text = `Level 1`
*                                                              task = VALUE #( ( id = `rectangle1` starttime = `20181101090000` endtime = `20181127090000`
*                                                           ) )
*                                                           children = VALUE #( ( id = `line2` text = `Level 2`
*                                                                                    subtask = VALUE #( ( id = `chevron1` starttime = `20181101090000` endtime = `20181113090000` )
*                                                                                                       ( id = `chevron2` starttime = `20181115090000` endtime = `20181127090000` ) )
*
*                                                           ) ) ) ) ) .


  ENDMETHOD.
ENDCLASS.
