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

*    DATA mt_table TYPE t_json1.
    DATA mt_table TYPE t_root6.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_on_init .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .
    METHODS z2ui5_load_date_function.
  PRIVATE SECTION.
    DATA check_date_function_loaded TYPE abap_bool.

ENDCLASS.



CLASS z2ui5_cl_app_demo_76 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    me->client     = client.

    IF check_date_function_loaded = abap_false.
      check_date_function_loaded = abap_true.
      z2ui5_load_date_function( ).
      RETURN.
    ENDIF.

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
            )->tree_column( label = 'Col 1' )->tree_template( )->text( text = `{TEXT}` )->get_parent( )->get_parent( )->get_parent(
*            )->tree_column( label = 'Col 1' template = 'text' )->get_parent( )->get_parent(
          )->row_settings_template(
            )->gantt_row_settings( rowid = `{ID}` shapes1 = `{TASK}` shapes2 = `{SUBTASK}`
              )->shapes1(
                )->task( time = `{= Date.createObject(${STARTTIME} ) }`
                endtime = `{= Date.createObject(${ENDTIME} ) }` type = `SummaryExpanded` color = `sapUiAccent5` )->get_parent( )->get_parent(

              )->shapes2(
                )->task( time = `{= Date.createObject(${STARTTIME} ) }`
                endtime = `{= Date.createObject(${ENDTIME} ) }` ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.


    mt_table = VALUE #( children = VALUE #( ( id = `line`
   text = `Level 1`
   task = VALUE #( ( id = `rectangle1` starttime = `2018-11-01T09:00:00` endtime = `2018-11-27T09:00:00`
) )
children = VALUE #( ( id = `line2` text = `Level 2`
                         subtask = VALUE #( ( id = `chevron1` starttime = `2018-11-01T09:00:00` endtime = `2018-11-13T09:00:00` )
                                            ( id = `chevron2` starttime = `2018-11-15T09:00:00` endtime = `2018-11-27T09:00:00` ) )

) ) ) ) ) .

  ENDMETHOD.

  METHOD z2ui5_load_date_function.


    client->view_display( z2ui5_cl_xml_view=>factory( client
         )->zz_plain(  `<html:script> ` &&
                                 `        jQuery.sap.require("sap.ui.core.date.UI5Date");` && |\n| &&
                           `                // s type is String -> pattern: YYYY-MM-DDTHH:mm:ss ` && |\n| &&
                           `                Date.createObject = (s => new Date(s));` && |\n| &&
                           `                // abap timestamp convert to JS Date ` && |\n| &&
                           `                Date.abapTimestampToDate = (sTimestamp => new sap.gantt.misc.Format.abapTimestampToDate(sTimestamp));` && |\n| &&
                           `                // abap date to JS Date object => pattern: YYYYMMDD ` && |\n| &&
                           `                Date.abapDateToDateObject = (d => new Date(d.slice(0,4), (d[4]+d[5])-1, d[6]+d[7]));` && |\n| &&
                           `                // abap date and time to JS Date object => pattern: d = YYYYMMDD , t = HHmmss ` && |\n| &&
                           `               Date.abapDateTimeToDateObject = ((d,t = '000000') => new Date(d.slice(0,4), (d[4]+d[5])-1, d[6]+d[7],t.slice(0,2),t.slice(2,4),t.slice(4,6)));` && |\n| &&
          `  </html:script>`
         )->stringify( ) ).

    client->timer_set(
      interval_ms    = '0'
      event_finished = client->_event( 'DISPLAY_VIEW' )
    ).

  ENDMETHOD.

ENDCLASS.
