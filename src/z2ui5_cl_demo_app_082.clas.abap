CLASS z2ui5_cl_demo_app_082 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mv_counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_082 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ).
      on_init( ).
      view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `TIMER_FINISHED` ).
      mv_counter = mv_counter + 1.
      INSERT VALUE #( title = `entry` && mv_counter   info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
          INTO TABLE t_tab.

      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    mv_counter = 1.

    t_tab = VALUE #(
            ( title = `entry` && mv_counter  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->_z2ui5( )->timer( finished    = client->_event( `TIMER_FINISHED` )
                               delayms     = `2000`
                               checkrepeat = abap_true ).

    DATA(page) = lo_view->shell( )->page(
             title          = `abap2UI5 - Roundtrip Speed Test`
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

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
