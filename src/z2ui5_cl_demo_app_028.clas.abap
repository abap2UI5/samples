CLASS z2ui5_cl_demo_app_028 DEFINITION PUBLIC.

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
    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_counter TYPE i.
    DATA mv_check_active TYPE abap_bool.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_028 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client     = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
      view_display( ).
    ENDIF.

    IF mo_client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `TIMER_FINISHED` ).
      mv_counter = mv_counter + 1.
      INSERT VALUE #( title = `entry` && mv_counter   info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
          INTO TABLE mt_tab.

      IF mv_counter = 3.
        mv_check_active = abap_false.
        mo_client->message_toast_display( `timer deactivated` ).
      ENDIF.

      mo_client->view_model_update( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_init.

    mv_counter = 1.
    mv_check_active = abap_true.

    mt_tab = VALUE #(
            ( title = `entry` && mv_counter  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->_z2ui5( )->timer(
        finished    = mo_client->_event( `TIMER_FINISHED` )
        delayms     = `2000`
        checkactive = mo_client->_bind( mv_check_active ) ).

    DATA(lo_page) = lo_view->shell( )->page(
             title          = `abap2UI5 - CL_GUI_TIMER - Monitor`
             navbuttonpress = mo_client->_event_nav_app_leave( )
             shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->list(
         headertext = `Data auto refresh (2 sec)`
         items      = mo_client->_bind( mt_tab )
         )->standard_list_item(
             title       = `{TITLE}`
             description = `{DESCR}`
             icon        = `{ICON}`
             info        = `{INFO}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
