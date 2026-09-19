" @keywords t100 message class number exception cx_root error abend
" @summary Turns what ABAP already has into a MessageBox - a SY message, a BAPIRET2 table or a caught exception.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/exception https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_008 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_008 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE symsg.
        DATA ls_msg_sy LIKE temp1.
        DATA temp2 TYPE bapiret2.
        DATA ls_msg_bapiret LIKE temp2.
            DATA lv_val TYPE i.
            DATA lx TYPE REF TO cx_root.

    CASE client->get_event( ).
      WHEN `BUTTON_MESSAGE_BOX_SY`.
        " only the message key - message_box_display( ) reads the text from
        " T100 itself, exactly as it does for the BAPIRET2 structure below
        
        CLEAR temp1.
        temp1-msgty = `I`.
        temp1-msgid = `NET`.
        temp1-msgno = `001`.
        
        ls_msg_sy = temp1.
        client->message_box_display( ls_msg_sy ).
      WHEN `BUTTON_MESSAGE_BOX_BAPIRET`.
        
        CLEAR temp2.
        temp2-id = `NET`.
        temp2-number = `001`.
        
        ls_msg_bapiret = temp2.
        client->message_box_display( ls_msg_bapiret ).
      WHEN `BUTTON_MESSAGE_BOX_CX_ROOT`.
        TRY.
            
            lv_val = 1 / 0.
            client->message_box_display( |{ lv_val }| ).
            
          CATCH cx_root INTO lx.
            client->message_box_display( lx ).
        ENDTRY.
    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Message - MessageBox from SY, BAPIRET2 or Exception`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->ele( `headerContent`
                )->tag( `Link`
            )->end( ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The three buttons feed a MessageBox with the message objects ABAP ` &&
                   `produces: a SY message read from T100, a BAPIRET2 structure and a ` &&
                   `caught CX_ROOT exception. message_box_display( ) accepts each of them ` &&
                   `directly, no conversion in the app.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title` v = `Message Box from ABAP Object`
                )->ele( n = `content` ns = `form`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_MESSAGE_BOX_SY` )
                        )->a( n = `text`  v = `SY Message`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_MESSAGE_BOX_BAPIRET` )
                        )->a( n = `text`  v = `BAPIRET2`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_MESSAGE_BOX_CX_ROOT` )
                        )->a( n = `text`  v = `CX_ROOT` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
