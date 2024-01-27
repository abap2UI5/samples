CLASS z2ui5_cl_demo_app_080 DEFINITION
PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

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

    METHODS z2ui5_display_view .
    METHODS z2ui5_on_event .
    METHODS z2ui5_set_data .
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_080 IMPLEMENTATION.


  METHOD z2ui5_display_view.
    DATA(lv_s_date) =  '2023-04-22T08:15:00'.
    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic_property( VALUE #( n = `core:require` v = `{Helper:'z2ui5/Util'}` ) ).

    DATA(page) = view->page( id = `page_main`
            title          = 'abap2UI5 - Planning Calendar'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            class = 'sapUiContentPadding' ).

    page->header_content(
          )->link( text = 'Demo' target = '_blank' href = `https://twitter.com/abap2UI5/status/1688451062137573376`
          )->link(
              text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( ) ).
    DATA(lo_vbox) = page->vbox( class ='sapUiSmallMargin' ).

    DATA(lo_planningcalendar) = lo_vbox->planning_calendar(
                                                          startdate = `{= Helper.DateCreateObject($` && client->_bind_local( lv_s_date ) && ') }'
                                                          rows = `{path: '` && client->_bind_local( val = lt_people path = abap_true ) && `'}`
                                                          appointmentselect = client->_event( val = 'AppSelected' t_arg = VALUE #( ( `${$parameters>/appointment/mProperties/title}`) ) )
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
                                                                  startdate = `{= Helper.DateCreateObject(${START} ) }`
                                                                  enddate   = `{= Helper.DateCreateObject(${END} ) }`
                                                                  icon = '{PIC}'
                                                                  title = '{TITLE}'
                                                                  text = '{INFO}'
                                                                  type = '{TYPE}'
                                                                  tentative = '{TENTATIVE}' ).

    lo_planningcalendarrow->interval_headers( )->calendar_appointment(
                                                                      startdate = `{= Helper.DateCreateObject(${START} ) }`
                                                                      enddate   = `{= Helper.DateCreateObject(${END} ) }`
                                                                      icon = '{PIC}'
                                                                      title = '{TITLE}'
                                                                      text = '{INFO}'
                                                                      type = '{TYPE}'
                                                        ).

    client->view_display( view->stringify(  ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_set_data( ).
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true or client->get( )-event = 'DISPLAY_VIEW'.
      z2ui5_display_view( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.
    CASE client->get( )-event.
      WHEN 'AppSelected' .
        DATA(ls_client) = client->get( ).
        client->message_toast_display( |Event AppSelected with appointment {  ls_client-t_event_arg[ 1 ] }| ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.


  METHOD z2ui5_set_data.
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
