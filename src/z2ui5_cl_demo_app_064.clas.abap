CLASS z2ui5_cl_demo_app_064 DEFINITION PUBLIC.
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
      END OF ty_s_tab .
    TYPES
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop .

    DATA mt_table TYPE ty_t_table .
    DATA mv_check_active TYPE abap_bool.
    DATA:
      BEGIN OF screen,
        progress_value TYPE string VALUE `0`,
        display_value  TYPE string VALUE ``,
      END OF screen.

    DATA mv_percent TYPE i.
    DATA mv_check_enabled TYPE abap_bool.
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
  PRIVATE SECTION.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.
ENDCLASS.

CLASS z2ui5_cl_demo_app_064 IMPLEMENTATION.

  METHOD set_selkz.

    FIELD-SYMBOLS <ls_table> TYPE ty_s_tab.

    LOOP AT mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
    ENDLOOP.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `LOAD` ).

      mv_percent = mv_percent + 25.
      mv_check_active = abap_true.
      mv_check_enabled = abap_false.
      IF mv_percent > 100.
        mv_percent = 0.
        mv_check_active = abap_false.
        mv_check_enabled = abap_true.
      ENDIF.

      mo_client->message_toast_display( `loaded` ).
      WAIT UP TO 2 SECONDS.
      mo_client->view_model_update( ).

    ENDIF.
  ENDMETHOD.

  METHOD on_init.

    DATA lt_temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA lo_view TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA lv_temp5 TYPE abap_bool.
    DATA lo_layout TYPE REF TO z2ui5_cl_xml_view.
    CLEAR lt_temp1.

    mv_check_enabled = abap_true.
    lo_view = z2ui5_cl_xml_view=>factory( ).

    lo_view->_z2ui5( )->timer(
        finished    = mo_client->_event( `LOAD` )
        checkactive = mo_client->_bind( mv_check_active ) ).

    lv_temp5 = mo_client->check_app_prev_stack( ).
    lo_page1 = lo_view->shell( )->page( id = `page_main`
      title                          = `abap2UI5 - Progress Bar while Server Request`
      navbuttonpress                 = mo_client->_event_nav_app_leave( )
      shownavbutton                  = lv_temp5
      class                          = `sapUiContentPadding` ).

    lo_layout = lo_page1->vertical_layout( class = `sapuicontentpadding`
                                     width = `100%` ).
    lo_layout->vbox( )->progress_indicator(
      percentvalue = mo_client->_bind_edit( mv_percent )
      displayvalue = mo_client->_bind_edit( screen-display_value )
      showvalue    = abap_true
           state   = `Success` ).

    lo_layout->button(
        text    = `Load`
        press   = mo_client->_event( `LOAD` )
        enabled = mo_client->_bind( mv_check_enabled ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
