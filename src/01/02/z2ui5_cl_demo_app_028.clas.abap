CLASS z2ui5_cl_demo_app_028 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

    DATA counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS start_timer.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_028 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( `TIMER_FINISHED` ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.
    DATA temp1 LIKE t_tab.
    DATA temp2 LIKE LINE OF temp1.

    counter = 1.
    
    CLEAR temp1.
    
    temp2-title = |entry{ counter }|.
    temp2-info = `completed`.
    temp2-descr = `this is a description`.
    temp2-icon = `sap-icon://account`.
    INSERT temp2 INTO TABLE temp1.
    t_tab = temp1.

    start_timer( ).

  ENDMETHOD.


  METHOD on_event.
    DATA temp3 TYPE z2ui5_cl_demo_app_028=>ty_s_row.

    counter = counter + 1.
    
    CLEAR temp3.
    temp3-title = |entry{ counter }|.
    temp3-info = `completed`.
    temp3-descr = `this is a description`.
    temp3-icon = `sap-icon://account`.
    INSERT temp3
      INTO TABLE t_tab.

    IF counter < 3.
      start_timer( ).
    ELSE.
      client->message_toast_display( `timer deactivated` ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD start_timer.

    DATA temp4 TYPE string_table.
    CLEAR temp4.
    INSERT `TIMER_FINISHED` INTO TABLE temp4.
    INSERT `2000` INTO TABLE temp4.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-start_timer
        t_arg = temp4 ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - CL_GUI_TIMER - Monitor`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The list refreshes itself automatically: a client-side timer (follow_up_action) fires ` &&
                   `every 2 seconds, appending a new entry on the server until three rows exist.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->list(
        headertext = `Data auto refresh (2 sec)`
        items      = client->_bind( t_tab )
        )->standard_list_item(
            title       = `{TITLE}`
            description = `{DESCR}`
            icon        = `{ICON}`
            info        = `{INFO}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
