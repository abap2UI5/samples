" @keywords planningcalendar appointment javascript date object iso
CLASS z2ui5_cl_smp_app_456 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_456 IMPLEMENTATION.

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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:u`      v = `sap.ui.unified` ).

    " calendar date properties (CalendarAppointment startDate/endDate,
    " PlanningCalendar startDate) are typed "object" - they demand a real JS
    " Date; a plain string binding crashes view creation ("Date must be a
    " JavaScript or UI5Date date object"). Formatter.DateCreateObject from
    " the curated module converts the model's ISO strings at the point of
    " use - the model itself stays plain strings everywhere.
    view->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Formatter - Date Objects for the PlanningCalendar`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The model carries plain ISO strings; Formatter.DateCreateObject turns them into ` &&
                   `the real JS Date objects the object-typed calendar properties require - only at ` &&
                   `the bindings that need them.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the startDate path must come from _bind - a hardcoded binding
    " path is never registered in the model, the frontend then receives no
    " data and the formatter passes a non-Date into the object property
    page->ele( `PlanningCalendar`
        )->a( n = `rows`      v = client->_bind( t_people )
        )->a( n = `startDate` v = |\{ path: '{ client->_bind( val = start_date path = abap_true ) }', | &&
                    |formatter: 'Formatter.DateCreateObject' \}|
        )->a( n = `id`        v = `PC1`
        )->a( n = `class`     v = `sapUiSmallMargin`
        )->ele( `rows`
            )->ele( `PlanningCalendarRow`
                )->a( n = `appointments` v = `{path: 'T_APPOINTMENTS', templateShareable: true}`
                )->a( n = `title`        v = `{NAME}`
                )->ele( `appointments`
                    )->ele( n = `CalendarAppointment` ns = `u`
                        )->a( n = `startDate` v = `{ path: 'START_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `endDate`   v = `{ path: 'END_AT', formatter: 'Formatter.DateCreateObject' }`
                        )->a( n = `title`     v = `{TITLE}`
                        )->a( n = `type`      v = `{TYPE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
