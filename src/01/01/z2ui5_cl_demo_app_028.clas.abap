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
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).

    ELSEIF client->check_on_event( `TIMER_FINISHED` ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    counter = 1.

    t_tab = VALUE #(
        ( title = |entry{ counter }|
          info  = `completed`
          descr = `this is a description`
          icon  = `sap-icon://account` ) ).

    start_timer( ).

  ENDMETHOD.


  METHOD on_event.

    counter = counter + 1.
    INSERT VALUE #(
        title = |entry{ counter }|
        info  = `completed`
        descr = `this is a description`
        icon  = `sap-icon://account` )
      INTO TABLE t_tab.

    IF counter < 3.
      start_timer( ).
    ELSE.
      client->message_toast_display( `timer deactivated` ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD start_timer.

    client->action->gen(
        val   = z2ui5_if_client=>cs_event-start_timer
        t_arg = VALUE #( ( client->_event( `TIMER_FINISHED` ) ) ( `2000` ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - CL_GUI_TIMER - Monitor`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

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
