CLASS z2ui5_cl_demo_app_179 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_relationships,
        id           TYPE string,
        successor    TYPE string,
        presuccessor TYPE string,
      END OF ty_s_relationships.

    TYPES ty_t_relation TYPE STANDARD TABLE OF ty_s_relationships WITH DEFAULT KEY .

    TYPES:
      BEGIN OF t_subtask5,
        id        TYPE string,
        starttime TYPE string,
        endtime   TYPE string,
      END OF t_subtask5 .
    TYPES:
      tt_subtask5 TYPE STANDARD TABLE OF t_subtask5 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF t_task3,
        id        TYPE string,
        starttime TYPE string,
        endtime   TYPE string,
      END OF t_task3 .
    TYPES:
      BEGIN OF t_children4,
        id        TYPE string,
        text      TYPE string,
        subtask   TYPE tt_subtask5,
        relations TYPE ty_t_relation,
      END OF t_children4 .
    TYPES:
      tt_task3 TYPE STANDARD TABLE OF t_task3 WITH DEFAULT KEY .
    TYPES:
      tt_children4 TYPE STANDARD TABLE OF t_children4 WITH DEFAULT KEY .

    TYPES:
      BEGIN OF t_children2,
        id            TYPE string,
        text          TYPE string,
        task          TYPE tt_task3,
        children      TYPE tt_children4,
        relationships TYPE ty_t_relation,
      END OF t_children2 .
    TYPES:
      tt_children2 TYPE STANDARD TABLE OF t_children2 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF t_root6,
        children TYPE tt_children2,
      END OF t_root6 .
    TYPES:
      BEGIN OF t_json1,
        root TYPE t_root6,
      END OF t_json1 .

    DATA mt_table TYPE t_root6 .
    DATA zoomlevel TYPE i .

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_on_init .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_179 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    me->client = client.

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


    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic_property( VALUE #( n = `core:require` v = `{Helper:'z2ui5/Util'}` ) ).

    DATA(page) = view->page( id = `page_main`
            title          = 'abap2UI5 - Gantt'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            class = 'sapUiContentPadding' ).

    DATA(cont) = page->scroll_container(
*               height     =
*               width      =
*               vertical   =
                   horizontal = abap_true
*               id         =
*               focusable  =
*               visible    =
                 ).

    DATA(tool) = cont->container_toolbar(
      EXPORTING
        showsearchbutton          = abap_true
        showdisplaytypebutton     =  abap_true
        showlegendbutton          =  abap_true
        showsettingbutton         =  abap_true
        showtimezoomcontrol       =  abap_true
        findbuttonpress           = client->_event( val = 'FIRE' )
*    stepcountofslider         =
*    zoomcontroltype           =
        zoomlevel                 = client->_bind_edit( zoomlevel )
*  RECEIVING
*    result                    =
    ).


    DATA(gantt_container) = cont->gantt_chart_container(   ).
    DATA(gantt) = gantt_container->gantt_chart_with_table( id = `gantt` shapeselectionmode = `Single` ).

    gantt->axis_time_strategy(
      )->proportion_zoom_strategy( zoomlevel = client->_bind_edit( zoomlevel )
        )->total_horizon(
          )->time_horizon( starttime = `20181029000000` endtime = `20181231000000` )->get_parent( )->get_parent(
        )->visible_horizon(
          )->time_horizon( starttime = `20181029000000` endtime = `20181131000000` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
  ).
    DATA(table) =  gantt->gantt_table( )->tree_table( rows = `{path: '` && client->_bind( val = mt_table path = abap_true ) && `', parameters: {arrayNames: ['CHILDREN'],numberOfExpandedLevels: 1}}`
        ).
    DATA(gantt_row_template) =   table->tree_columns(
           )->tree_column( label = 'Col 1' )->tree_template( )->text( text = `{TEXT}` )->get_parent( )->get_parent( )->get_parent(
*            )->tree_column( label = 'Col 1' template = 'text' )->get_parent( )->get_parent(
         )->row_settings_template(
           ).

    DATA gantt_rs TYPE REF TO z2ui5_cl_xml_view.
    gantt_rs =  gantt_row_template->gantt_row_settings( rowid = `{ID}`
                                  shapes1 = `{path: 'TASK', templateShareable:false}`
                                  shapes2 = `{path: 'SUBTASK', templateShareable:false}`
                                  relationships = `{path:'RELATIONSHIPS', templateShareable:false}`
            ).

    gantt_rs->shapes1(
            )->task( id = 'TSK1' time = `{= Helper.DateCreateObject(${STARTTIME} ) }`
            endtime = `{= Helper.DateCreateObject(${ENDTIME} ) }` type = `SummaryExpanded` color = `sapUiAccent5`  connectable = abap_true )."->get_parent( )->get_parent(

    gantt_rs->shapes2(
      )->task( id = 'TSK2' time = `{= Helper.DateCreateObject(${STARTTIME} ) }`
      endtime = `{= Helper.DateCreateObject(${ENDTIME} ) }`
      connectable = abap_true ).




    DATA lo_s TYPE REF TO z2ui5_cl_xml_view.
    lo_s = gantt_rs->relationships( ).


*                 <gnt2:relationships>
*                   <gnt2:Relationship shapeId="{data>RelationID}"
*                   predecessor="{data>PredecTaskID}" successor="{data>SuccTaskID}" type="{data>RelationType}" tooltip="{data>RelationType}"
*                   selectable="true"/>
*                 </gnt2:relationships>




    CALL METHOD lo_s->relationship
      EXPORTING
        shapeid          = '{ID}'
        successor   = '{SUCCESSOR}'
        predecessor = '{PRESUCCESSOR}'
        type        = 'StartToFinish'
      RECEIVING
        result      = DATA(lo_rel).

*  RECEIVING
*    result =.



    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.


    mt_table = VALUE #( children = VALUE #( ( id = `line`
   text = `Level 1`
   task = VALUE #( ( id = `rectangle1` starttime = `2018-11-01T09:00:00` endtime = `2018-11-27T09:00:00` ) )
   relationships =  VALUE #( ( id = '34' successor = `chevron1` presuccessor = `chevron2` ) )


children = VALUE #( ( id = `line2` text = `Level 2`
                         subtask = VALUE #( ( id = `chevron1` starttime = `2018-11-01T09:00:00` endtime = `2018-11-13T09:00:00` )
                                            ( id = `chevron2` starttime = `2018-11-15T09:00:00` endtime = `2018-11-27T09:00:00` ) )
                                               relations =  VALUE #( ( id = '34' successor = `chevron1` presuccessor = `chevron2` ) )


)  ) ) ) ) .

  ENDMETHOD.
ENDCLASS.
