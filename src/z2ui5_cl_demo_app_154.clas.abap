CLASS z2ui5_cl_demo_app_154 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    METHODS ui5_display.
    METHODS ui5_event.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_154 IMPLEMENTATION.


  METHOD ui5_event.
    TYPES BEGIN OF ty_log_entry.
    TYPES msgnumber TYPE n LENGTH 6.
    TYPES msgty     TYPE c LENGTH 1.
    TYPES msgid     TYPE c LENGTH 20.
    TYPES msgno     TYPE n LENGTH 3.
    TYPES msgv1     TYPE c LENGTH 50.
    TYPES msgv2     TYPE c LENGTH 50.
    TYPES msgv3     TYPE c LENGTH 50.
    TYPES msgv4     TYPE c LENGTH 50.
    TYPES msgv1_src TYPE c LENGTH 15.
    TYPES msgv2_src TYPE c LENGTH 15.
    TYPES msgv3_src TYPE c LENGTH 15.
    TYPES msgv4_src TYPE c LENGTH 15.
    TYPES detlevel  TYPE c LENGTH 1.
    TYPES probclass TYPE c LENGTH 1.
    TYPES alsort    TYPE c LENGTH 3.
    TYPES time_stmp TYPE p LENGTH 8 DECIMALS 7.
    TYPES msg_count TYPE i.
    TYPES context   TYPE c LENGTH 255.
    TYPES params    TYPE c LENGTH 255.
    TYPES msg_txt   TYPE string.
    TYPES END OF ty_log_entry.
    DATA lt_bal TYPE STANDARD TABLE OF ty_log_entry WITH EMPTY KEY.

    CASE client->get( )-event.

      WHEN 'POPUP_BAPIRET'.

        DATA(lt_msg) = VALUE bapirettab(
            ( type = 'E' id = 'MSG1' number = '001' message = 'An empty Report field causes an empty XML Message to be sent' )
            ( type = 'I' id = 'MSG2' number = '002' message = 'Product already in use' ) ).

        client->nav_app_call( z2ui5_cl_pop_messages=>factory( lt_msg ) ).

      WHEN 'POPUP_BALLOG'.



        lt_bal = VALUE #(
          ( msgid = 'Z001' msgno = '001' msgty = 'S' time_stmp = z2ui5_cl_util=>time_get_timestampl( ) msgnumber = '01' )
          ( msgid = 'Z001' msgno = '002' msgty = 'S' time_stmp = z2ui5_cl_util=>time_get_timestampl( )  msgnumber = '02' ) ).

        client->nav_app_call( z2ui5_cl_pop_bal=>factory( lt_bal ) ).


      WHEN 'POPUP_EXCEPTION'.
        TRY.
            DATA(lv_dummy) = 1 / 0.
          CATCH cx_root INTO DATA(lx).
        ENDTRY.
        DATA(lo_app) = z2ui5_cl_pop_error=>factory( lx ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup Messages'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
           )->button(
            text  = 'Open Popup BAPIRET'
            press = client->_event( 'POPUP_BAPIRET' )
                  )->button(
            text  = 'Open Popup BALLOG'
            press = client->_event( 'POPUP_BALLOG' )
                             )->button(
            text  = 'Open Popup Exception'
            press = client->_event( 'POPUP_EXCEPTION' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

ENDCLASS.
