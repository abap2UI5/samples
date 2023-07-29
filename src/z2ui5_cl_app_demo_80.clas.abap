CLASS z2ui5_cl_app_demo_80 DEFINITION
PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_s_appointments,
        start     TYPE string,
        end       TYPE string,
        title     TYPE string,
        type      TYPE string,
        info      TYPE string,
        pic       TYPE string,
        tentative TYPE boolean,
      END OF ty_s_appointments .
    TYPES:
      BEGIN OF ty_s_headers,
        start     TYPE string,
        end       TYPE string,
        title     TYPE string,
        type      TYPE string,
        info      TYPE string,
        pic       TYPE string,
        tentative TYPE boolean,
      END OF ty_s_headers .
    TYPES:
      BEGIN OF ty_s_people,
        name         TYPE string,
        pic          TYPE string,
        role         TYPE string,
        appointments TYPE TABLE OF ty_s_appointments WITH NON-UNIQUE DEFAULT KEY,
        headers      TYPE TABLE OF ty_s_headers      WITH NON-UNIQUE DEFAULT KEY,
      END OF ty_s_people .

    DATA:
      lt_people TYPE STANDARD TABLE OF ty_s_people .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_on_init .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .
  PRIVATE SECTION.

    DATA lv_ts1 TYPE timestamp .
    DATA lv_ts2 TYPE timestamp .
    DATA lv_ts3 TYPE timestamp .
    DATA lv_ts4 TYPE timestamp .
    DATA lv_ts5 TYPE timestamp .
    DATA lv_ts6 TYPE timestamp .

    METHODS set_filter .
ENDCLASS.



CLASS z2ui5_cl_app_demo_80 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method Z2UI5_CL_APP_DEMO_PC_TEST->SET_FILTER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_filter.
*    z2ui5_set_data( ).
*    CASE lv_selectedkey.
*      WHEN 'ALL'.
*      WHEN 'OK'.
*        DELETE mt_table WHERE  NOT measure BETWEEN 0 AND 100.
*      WHEN 'HEAVY'.
*        DELETE mt_table WHERE NOT measure BETWEEN 101 AND 500.
*      WHEN 'OVERWEIGHT'.
*        DELETE mt_table WHERE NOT measure > 500 .
*    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_APP_DEMO_PC_TEST->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
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


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_APP_DEMO_PC_TEST->Z2UI5_ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'AppSelected' .
        client->message_toast_display( |Event AppSelected| ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_APP_DEMO_PC_TEST->Z2UI5_ON_INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_on_init.
    DATA: lv_date TYPE p.
    DATA: lv_time TYPE t.

    lv_time = '060000'.
    lv_date = '20200410'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP DATA(lv_ts_start) TIME ZONE sy-zonlo.
    DATA(lv_s_date) =  '2020-04-23T06:00:00'.
    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = view->page( id = `page_main`
            title          = 'abap2UI5 - Planing Calendar'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true
            class = 'sapUiContentPadding' ).

    page->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url(  ) ).
    DATA(lo_vbox) = page->vbox( class ='sapUiSmallMargin' ).

    DATA(lo_planningcalendar) = lo_vbox->planning_calendar(
*                                                          startdate = '{= Date.createObject(${LV_S_DATE})}'
*                                                          rows = `{path: 'LT_PEOPLE'}`
                                                          rows = `{path: '` && client->_bind( val = lt_people path = abap_true ) && `'}`
*                                                          appointmentsVisualization = 'Filled'
                                                          appointmentselect = client->_event( val = 'AppSelected' )
*                                                          showEmptyIntervalHeaders = abap_false
                                                          showweeknumbers = abap_true ).
    DATA(lo_rows) = lo_planningcalendar->rows( ).
    DATA(lo_planningcalendarrow) = lo_rows->planning_calendar_row(
                                                     appointments = `{path:'APPOINTMENTS'}`
                                                     icon =  '{PIC}'
                                                     title = '{NAME}'
                                                     text = '{ROLE}'
                                                     intervalheaders = `{path:'HEADERS'}`
                                                     ).
    lo_planningcalendarrow->appointments( )->calendar_appointment(
                                                                  startdate = '{= Date.createObject(${START})}'
                                                                  enddate   = '{= Date.createObject(${END})}'
                                                                  icon = '{PIC}'
                                                                  title = '{TITLE}'
                                                                  text = '{INFO}'
                                                                  type = '{TYPE}'
                                                                  tentative = '{TENTATIVE}' ).

    lo_planningcalendarrow->interval_headers( )->calendar_appointment(
                                                                      startdate = '{= Date.createObject(${START})}'
                                                                      enddate   = '{= Date.createObject(${END})}'
                                                                      icon = '{PIC}'
                                                                      title = '{TITLE}'
                                                                      text = '{INFO}'
                                                                      type = '{TYPE}'
                                                                       ).

    client->view_display( view->stringify(  ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_APP_DEMO_PC_TEST->Z2UI5_SET_DATA
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_set_data.
    DATA: lv_date TYPE p.
    DATA: lv_time TYPE t.

    lv_date = '20200422'.
    lv_time = '081500'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_ts1 TIME ZONE sy-zonlo.

    lv_date = '20200423'.
    lv_time = '081500'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_ts2 TIME ZONE sy-zonlo.

    lv_date = '20200425'.
    lv_time = '103000'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_ts3 TIME ZONE sy-zonlo.

    lv_date = '20200426'.
    lv_time = '113000'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_ts4 TIME ZONE sy-zonlo.


    lv_date = '20200410'.
    lv_time = '103000'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_ts5 TIME ZONE sy-zonlo.

    lv_date = '20200411'.
    lv_time = '113000'.
    CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_ts6 TIME ZONE sy-zonlo.

    lt_people = VALUE #(
     ( name = 'Olaf' role = 'Team Member' pic = 'sap-icon://employee'
          appointments = VALUE #(
          ( start = '2023-04-22T08:15:00' end = '2023-04-23T08:15:00' info = 'Mittag1' type = 'Type01' title = 'App1' tentative = abap_false pic = 'sap-icon://sap-ui5' )
          ( start = '2023-04-25T10:30:00' end = '2023-04-26T11:30:00' info = 'Mittag2' type = 'Type02' title = 'App2' tentative = abap_false pic = 'sap-icon://sap-ui5' )
          ( start = '2023-04-10T10:30:00' end = '2023-04-11T11:30:00' info = 'Mittag3' type = 'Type03' title = 'App3' tentative = abap_false pic = 'sap-icon://sap-ui5' ) )
          headers = VALUE #(
              ( start = '2020-04-22T08:15:00' end = '2020-04-23T08:15:00' type = 'Type11' title = 'Reminder1' tentative =  abap_true )
              ( start = '2020-04-25T10:30:00' end = '2020-04-26T11:30:00' type = 'Type12' title = 'Reminder2' tentative =  abap_false ) ) )
     ( name = 'Stefanie' role = 'Team Member' pic = 'sap-icon://employee'
          appointments = VALUE #(
          ( start = '2023-04-22T08:15:00' end = '2023-04-23T08:15:00' info = 'Mittag11' type = 'Type11' title = 'App11' tentative = abap_false pic = 'sap-icon://sap-ui5' )
          ( start = '2023-04-25T10:30:00' end = '2023-04-26T11:30:00' info = 'Mittag21' type = 'Type12' title = 'App12' tentative = abap_false pic = 'sap-icon://sap-ui5' )
          ( start = '2023-04-10T10:30:00' end = '2023-04-11T11:30:00' info = 'Mittag31' type = 'Type13' title = 'App13' tentative = abap_false pic = 'sap-icon://sap-ui5' ) )
          headers = VALUE #(
              ( start = '2023-04-22T08:15:00' end = '2023-04-23T08:15:00' type = 'Type11' title = 'Reminder11' tentative =  abap_true )
              ( start = '2023-04-25T10:30:00' end = '2023-04-26T11:30:00' type = 'Type12' title = 'Reminder21' tentative =  abap_false ) ) )
              ) .
  ENDMETHOD.
ENDCLASS.
