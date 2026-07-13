"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendar
"! PlanningCalendar with single row selection that illustrates the built-in views.
CLASS z2ui5_cl_demo_app_080 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_appointment,
        start     TYPE string,
        end       TYPE string,
        title     TYPE string,
        type      TYPE string,
        info      TYPE string,
        pic       TYPE string,
        tentative TYPE abap_bool,
      END OF ty_s_appointment.
    TYPES ty_t_appointment TYPE STANDARD TABLE OF ty_s_appointment WITH NON-UNIQUE DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_person,
        name         TYPE string,
        pic          TYPE string,
        role         TYPE string,
        appointments TYPE ty_t_appointment,
        headers      TYPE ty_t_appointment,
      END OF ty_s_person.
    DATA t_people TYPE STANDARD TABLE OF ty_s_person.
    DATA start_date TYPE string.
    DATA t_built_in_views TYPE string_table.
    DATA t_selected_views TYPE string_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_080 IMPLEMENTATION.

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

    set_data( ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `APPOINTMENT_SELECT` ).

      DATA(selection) = COND string( WHEN client->get_event_arg( 2 ) = `true`
                                     THEN `selected`
                                     ELSE `deselected` ).
      client->message_box_display( |'{ client->get_event_arg( 1 ) }' { selection }| ).

    ELSEIF client->check_on_event( `SELECTION_FINISH` ).

      t_built_in_views = t_selected_views.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic_property( VALUE #( n = `core:require` v = `{Helper:'z2ui5/Util'}` ) ).

    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Sample: Planning Calendar`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( )
        class          = `sapUiContentPadding` ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PlanningCalendar/sample/sap.m.sample.PlanningCalendar` ).

    DATA(vbox) = page->vbox( `sapUiSmallMargin` ).

    " The event `rowHeaderPress` of the original sample is available since UI5 1.119 and therefore omitted here
    DATA(calendar) = vbox->planning_calendar(
        id                        = `PC1`
        startdate                 = `{= Helper.DateCreateObject($` && client->_bind( start_date ) && `) }`
        rows                      = `{path: '` && client->_bind( val = t_people path = abap_true ) && `'}`
        builtinviews              = client->_bind( t_built_in_views )
        appointmentsvisualization = `Filled`
        appointmentselect         = client->_event( val   = `APPOINTMENT_SELECT`
                                                    t_arg = VALUE #( ( `${$parameters>/appointment/mProperties/title}` )
                                                                     ( `${$parameters>/appointment/mProperties/selected}` ) ) )
        showemptyintervalheaders  = abap_false
        showweeknumbers           = abap_true ).

    " The calendar type selects of the original toolbar are omitted - the properties
    " `primaryCalendarType`/`secondaryCalendarType` are available since UI5 1.108/1.109
    calendar->_generic( `toolbarContent`
        )->title(
            text       = `Title`
            titlestyle = `H4` ).

    DATA(row) = calendar->rows( )->planning_calendar_row(
        icon            = `{PIC}`
        title           = `{NAME}`
        text            = `{ROLE}`
        appointments    = `{path: 'APPOINTMENTS', templateShareable: false}`
        intervalheaders = `{path: 'HEADERS', templateShareable: false}` ).

    row->custom_data(
       )->core_custom_data(
           key        = `emp-name`
           value      = `{NAME}`
           writetodom = abap_true ).

    " The property `ariaHasPopup` of the original appointment template is not available in the view API and therefore omitted here
    row->appointments( )->calendar_appointment(
        startdate = `{= Helper.DateCreateObject(${START} ) }`
        enddate   = `{= Helper.DateCreateObject(${END} ) }`
        icon      = `{PIC}`
        title     = `{TITLE}`
        text      = `{INFO}`
        type      = `{TYPE}`
        tentative = `{TENTATIVE}` ).

    row->interval_headers( )->calendar_appointment(
        startdate = `{= Helper.DateCreateObject(${START} ) }`
        enddate   = `{= Helper.DateCreateObject(${END} ) }`
        icon      = `{PIC}`
        title     = `{TITLE}`
        type      = `{TYPE}` ).

    vbox->label( `Add available built-in views to the example:` ).
    vbox->multi_combobox(
        width           = `230px`
        placeholder     = `Choose built-in views`
        selectedkeys    = client->_bind_edit( t_selected_views )
        selectionfinish = client->_event( `SELECTION_FINISH` )
        )->item(
            key  = `Hour`
            text = `Hour`
        )->item(
            key  = `Day`
            text = `Day`
        )->item(
            key  = `Month`
            text = `Month`
        )->item(
            key  = `Week`
            text = `1 week`
        )->item(
            key  = `One Month`
            text = `1 month` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD set_data.

    DATA base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    start_date = `2017-01-15T08:00:00`.

    t_people = VALUE #(
      ( name         = `John Miller`
        pic          = base_url && `test-resources/sap/ui/documentation/sdk/images/John_Miller.png`
        role         = `team member`
        appointments = VALUE #(
          ( start = `2017-01-08T08:30:00` end = `2017-01-08T09:30:00` title = `Meet Max Mustermann` type = `Type02` )
          ( start = `2017-01-11T10:00:00` end = `2017-01-11T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-12T11:30:00` end = `2017-01-12T13:30:00` title = `Lunch` type = `Type03` info = `canteen` tentative = abap_true )
          ( start = `2017-01-15T08:30:00` end = `2017-01-15T09:30:00` title = `Meet Max Mustermann` type = `Type02` )
          ( start = `2017-01-15T10:00:00` end = `2017-01-15T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-15T11:30:00` end = `2017-01-15T13:30:00` title = `Lunch` type = `Type03` info = `canteen` tentative = abap_true )
          ( start = `2017-01-15T13:30:00` end = `2017-01-15T17:30:00` title = `Discussion with clients` type = `Type02` info = `online meeting` )
          ( start = `2017-01-16T04:00:00` end = `2017-01-16T22:30:00` title = `Discussion of the plan` type = `Type04` info = `Online meeting` )
          ( start = `2017-01-18T08:30:00` end = `2017-01-18T09:30:00` title = `Meeting with the manager` type = `Type02` )
          ( start = `2017-01-18T11:30:00` end = `2017-01-18T13:30:00` title = `Lunch` type = `Type03` info = `canteen` tentative = abap_true )
          ( start = `2017-01-18T01:00:00` end = `2017-01-18T22:00:00` title = `Team meeting` type = `Type01` info = `regular` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-21T00:30:00` end = `2017-01-21T23:30:00` title = `New Product` type = `Type03` info = `room 105` tentative = abap_true )
          ( start = `2017-01-25T11:30:00` end = `2017-01-25T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true )
          ( start = `2017-01-29T10:00:00` end = `2017-01-29T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-30T08:30:00` end = `2017-01-30T09:30:00` title = `Meet Max Mustermann` type = `Type02` )
          ( start = `2017-01-30T10:00:00` end = `2017-01-30T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-30T11:30:00` end = `2017-01-30T13:30:00` title = `Lunch` type = `Type03` tentative = abap_true )
          ( start = `2017-01-30T13:30:00` end = `2017-01-30T17:30:00` title = `Discussion with clients` type = `Type02` )
          ( start = `2017-01-31T10:00:00` end = `2017-01-31T11:30:00` title = `Discussion of the plan` type = `Type04` info = `Online meeting` )
          ( start = `2017-02-03T08:30:00` end = `2017-02-13T09:30:00` title = `Meeting with the manager` type = `Type02` )
          ( start = `2017-02-04T10:00:00` end = `2017-02-04T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-03-30T10:00:00` end = `2017-06-02T12:00:00` title = `Working out of the building` type = `Type07` pic = `sap-icon://sap-ui5` ) )
        headers      = VALUE #(
          ( start = `2017-01-15T08:00:00` end = `2017-01-15T10:00:00` title = `Reminder` type = `Type06` )
          ( start = `2017-01-15T17:00:00` end = `2017-01-15T19:00:00` title = `Reminder` type = `Type06` )
          ( start = `2017-09-01T00:00:00` end = `2017-11-30T23:59:00` title = `New quarter` type = `Type10` )
          ( start = `2018-02-01T00:00:00` end = `2018-04-30T23:59:00` title = `New quarter` type = `Type10` ) ) )
      ( name         = `Donna Moore`
        pic          = base_url && `test-resources/sap/ui/documentation/sdk/images/Donna_Moore.jpg`
        role         = `team member`
        appointments = VALUE #(
          ( start = `2017-01-10T18:00:00` end = `2017-01-10T19:10:00` title = `Discussion of the plan` type = `Type04` info = `Online meeting` )
          ( start = `2017-01-09T10:00:00` end = `2017-01-13T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-15T08:00:00` end = `2017-01-15T09:30:00` title = `Discussion of the plan` type = `Type04` info = `Online meeting` )
          ( start = `2017-01-15T10:00:00` end = `2017-01-15T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-15T18:00:00` end = `2017-01-15T19:10:00` title = `Discussion of the plan` type = `Type04` info = `Online meeting` )
          ( start = `2017-01-16T10:00:00` end = `2017-01-31T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` )
          ( start = `2018-01-01T00:00:00` end = `2018-03-31T23:59:00` title = `New quarter` type = `Type10` )
          ( start = `2017-02-11T10:00:00` end = `2017-03-20T12:00:00` title = `Team collaboration` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-04-01T10:00:00` end = `2017-05-01T12:00:00` title = `Workshop out of the country` type = `Type07` pic = `sap-icon://sap-ui5` )
          ( start = `2017-05-01T10:00:00` end = `2017-05-31T12:00:00` title = `Out of the office` type = `Type08` )
          ( start = `2017-08-01T00:00:00` end = `2017-08-31T23:59:00` title = `Vacation` type = `Type04` info = `out of office` ) )
        headers      = VALUE #(
          ( start = `2017-01-15T09:00:00` end = `2017-01-15T10:00:00` title = `Payment reminder` type = `Type06` )
          ( start = `2017-01-15T16:30:00` end = `2017-01-15T18:00:00` title = `Private appointment` type = `Type06` ) ) )
      ( name         = `Max Mustermann`
        pic          = `sap-icon://employee`
        role         = `team member`
        appointments = VALUE #(
          ( start = `2017-01-15T08:30:00` end = `2017-01-15T09:30:00` title = `Meet John Miller` type = `Type02` )
          ( start = `2017-01-15T10:00:00` end = `2017-01-15T12:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-15T13:00:00` end = `2017-01-15T16:00:00` title = `Discussion with clients` type = `Type02` info = `online` )
          ( start = `2017-01-16T00:00:00` end = `2017-01-16T23:59:00` title = `Vacation` type = `Type04` info = `out of office` )
          ( start = `2017-01-17T01:00:00` end = `2017-01-18T22:00:00` title = `Workshop` type = `Type07` info = `regular` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-19T08:30:00` end = `2017-01-19T18:30:00` title = `Meet John Doe` type = `Type02` )
          ( start = `2017-01-19T10:00:00` end = `2017-01-19T16:00:00` title = `Team meeting` type = `Type01` info = `room 1` pic = `sap-icon://sap-ui5` )
          ( start = `2017-01-19T07:00:00` end = `2017-01-19T17:30:00` title = `Discussion with clients` type = `Type02` )
          ( start = `2017-01-20T00:00:00` end = `2017-01-20T23:59:00` title = `Vacation` type = `Type04` info = `out of office` )
          ( start = `2017-01-22T07:00:00` end = `2017-01-27T17:30:00` title = `Discussion with clients` type = `Type02` info = `out of office` )
          ( start = `2017-03-13T09:00:00` end = `2017-03-17T10:00:00` title = `Payment week` type = `Type06` )
          ( start = `2017-04-10T00:00:00` end = `2017-06-16T23:59:00` title = `Vacation` type = `Type04` info = `out of office` )
          ( start = `2017-08-01T00:00:00` end = `2017-10-31T23:59:00` title = `New quarter` type = `Type10` ) )
        headers      = VALUE #(
          ( start = `2017-01-16T00:00:00` end = `2017-01-16T23:59:00` title = `Private` type = `Type05` ) ) ) ).

  ENDMETHOD.

ENDCLASS.
