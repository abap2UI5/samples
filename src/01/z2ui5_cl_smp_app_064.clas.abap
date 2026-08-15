" @keywords progressindicator busy wait long running backend
CLASS z2ui5_cl_smp_app_064 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz     TYPE abap_bool,
        row_id    TYPE string,
        carrid    TYPE string,
        connid    TYPE string,
        fldate    TYPE string,
        planetype TYPE string,
      END OF ty_s_tab.
    TYPES
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop.

    DATA mt_mapping TYPE z2ui5_if_types=>ty_t_name_value.
    DATA mv_search_value TYPE string.
    DATA mt_table TYPE ty_t_table.
    DATA lv_selkz TYPE abap_bool.
    DATA mv_check_active TYPE abap_bool.
    DATA:
      BEGIN OF screen,
        progress_value TYPE string VALUE `0`,
        display_value  TYPE string VALUE ``,
      END OF screen.

    DATA mv_percent TYPE i.
    DATA mv_check_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_064 IMPLEMENTATION.

  METHOD set_selkz.

    FIELD-SYMBOLS <ls_table> TYPE ty_s_tab.

    LOOP AT mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    DATA lt_arg TYPE string_table.
    DATA ls_arg TYPE string.

    IF client->check_on_event( `LOAD` ).

      mv_percent       = mv_percent + 25.
      mv_check_active  = abap_true.
      mv_check_enabled = abap_false.

      IF mv_percent > 100.

        mv_percent       = 0.
        mv_check_active  = abap_false.
        mv_check_enabled = abap_true.
      ENDIF.

      client->message_toast_display( `loaded` ).
      WAIT UP TO 2 SECONDS.

      IF mv_check_active = abap_true.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-start_timer
            t_arg = VALUE #( ( `LOAD` ) ( `0` ) ) ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page1 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE abap_bool.
    DATA layout TYPE REF TO z2ui5_cl_ui5_view_builder.
    temp1 = VALUE #( ).

    mv_check_enabled = abap_true.
    view             = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).

    temp5          = client->check_app_prev_stack( ).
    page1          = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Timer - Progress Indicator during a Backend Call`
            )->a( n = `showNavButton`  b = temp5
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `id`             v = `page_main` ).

    page1->tag( `MessageStrip`
        )->a( n = `text`     v = `A ProgressIndicator driven from the backend: pressing Load runs a WAIT-delayed server ` &&
                   `step and re-arms a client timer (follow_up_action), advancing the bar in 25% steps until it completes.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    layout = page1->ele( n = `VerticalLayout` ns = `layout`
        )->a( n = `class` v = `sapuicontentpadding`
        )->a( n = `width` v = `100%` ).
    layout->ele( `VBox`
        )->tag( `ProgressIndicator`
            )->a( n = `percentValue` v = client->_bind( mv_percent )
            )->a( n = `displayValue` v = client->_bind( screen-display_value )
            )->a( n = `showValue`    b = abap_true
            )->a( n = `state`        v = `Success` ).

    layout->tag( `Button`
        )->a( n = `press`   v = client->_event( `LOAD` )
        )->a( n = `text`    v = `Load`
        )->a( n = `enabled` v = client->_bind( mv_check_enabled ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
