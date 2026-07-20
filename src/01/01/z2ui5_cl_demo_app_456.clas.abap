CLASS z2ui5_cl_demo_app_456 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_appointment,
        start_at TYPE string,
        end_at   TYPE string,
        title    TYPE string,
        type     TYPE string,
      END OF ty_s_appointment,
      ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH EMPTY KEY,
      BEGIN OF ty_s_person,
        name           TYPE string,
        t_appointments TYPE ty_t_appointment,
      END OF ty_s_person.
    DATA t_people   TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.
    DATA start_date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_456 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      start_date = `2026-07-20T07:00:00`.
      t_people = VALUE #(
          ( name = `Anna Miller`
            t_appointments = VALUE #(
                ( start_at = `2026-07-20T08:00:00` end_at = `2026-07-20T09:00:00`
                  title = `Team meeting` type = `Type01` )
                ( start_at = `2026-07-20T11:00:00` end_at = `2026-07-20T12:30:00`
                  title = `Customer call` type = `Type08` ) ) )
          ( name = `Tom Schmidt`
            t_appointments = VALUE #(
                ( start_at = `2026-07-20T09:30:00` end_at = `2026-07-20T10:30:00`
                  title = `Code review` type = `Type06` ) ) ) ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " calendar date properties (CalendarAppointment startDate/endDate,
    " PlanningCalendar startDate) are typed "object" - they demand a real JS
    " Date; a plain string binding crashes view creation ("Date must be a
    " JavaScript or UI5Date date object"). Formatter.DateCreateObject from
    " the curated module converts the model's ISO strings at the point of
    " use - the model itself stays plain strings everywhere.
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter: 'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Formatter - Date objects for the PlanningCalendar`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The model carries plain ISO strings; Formatter.DateCreateObject turns them into ` &&
                   `the real JS Date objects the object-typed calendar properties require - only at ` &&
                   `the bindings that need them.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the startDate path must come from _bind_edit - a hardcoded binding
    " path is never registered in the model, the frontend then receives no
    " data and the formatter passes a non-Date into the object property
    page->planning_calendar(
        id        = `PC1`
        class     = `sapUiSmallMargin`
        startdate = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', | &&
                    |formatter: 'Formatter.DateCreateObject' \}|
        rows      = client->_bind( t_people )
        )->rows(
        )->planning_calendar_row(
            title        = `{NAME}`
            appointments = `{path: 'T_APPOINTMENTS', templateShareable: true}`
            )->appointments(
            )->calendar_appointment(
                startdate = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                enddate   = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                title     = `{TITLE}`
                type      = `{TYPE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
