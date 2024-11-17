CLASS z2ui5_cl_demo_app_187 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

ENDCLASS.


CLASS z2ui5_cl_demo_app_187 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( )->shell(
        )->page( title          = 'abap2UI5 - Popup To Confirm'
                 navbuttonpress = client->_event( val = 'BACK' )
                 shownavbutton  = client->check_app_prev_stack( )
       )->button( text  = 'SY'
                  press = client->_event( 'SY' )
                )->button( text  = 'BAPIRET'
                           press = client->_event( 'BAPIRET' )
                )->button( text  = 'CX_ROOT'
                           press = client->_event( 'CX_ROOT' )
       )->stringify( ) ).

      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN 'SY'.
        MESSAGE ID 'NET' TYPE 'E' NUMBER '001' INTO DATA(lv_dummy) ##NEEDED.
        client->message_box_display( sy ).

      WHEN 'BAPIRET'.
        DATA ls_msg TYPE bapiret2.

*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          IMPORTING
*            return = ls_msg.
        ls_msg = VALUE #( id     = 'NET'
                          number = '001' ).
        client->message_box_display( ls_msg ).

      WHEN 'CX_ROOT'.
        TRY.
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(lv_val) = 1 / 0.
          CATCH cx_root INTO DATA(lx).
            client->message_box_display( lx ).
        ENDTRY.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
