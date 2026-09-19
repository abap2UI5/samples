" @keywords r_data result get_app_prev return event payload
" @summary The way back carries data: the called app returns an event name and a payload (r_data) that the caller reads from get_app_prev.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/navigation/inner_app
"! Calls a second app (z2ui5_cl_smp_app_489) via client->nav_app_call( ). The
"! called app comes back with client->nav_app_leave( event = ... r_data = ... ),
"! handing an event name and a data payload to its caller without knowing who
"! called it. On return this app enters main( ) via check_on_navigated( ) and
"! reads both from client->get( ): the event name from -event, the payload as a
"! data reference from -r_event_data.
CLASS z2ui5_cl_smp_app_488 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA s_result       TYPE z2ui5_cl_smp_app_489=>ty_s_result.
    DATA returned_event TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_navigation.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_488 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE REF TO z2ui5_cl_smp_app_489.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      on_navigation( ).

    ELSEIF client->check_on_event( `CALL_APP` ) IS NOT INITIAL.
      
      CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_489.
      client->nav_app_call( temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_navigation.

    DATA ls_get TYPE z2ui5_if_client=>ty_s_get.
        FIELD-SYMBOLS <s_result> TYPE data.
        DATA temp2 TYPE z2ui5_cl_smp_app_489=>ty_s_result.
    ls_get = client->get( ).
    returned_event = ls_get-event.

    CASE returned_event.

      WHEN `DATA_CONFIRMED`.

        " the payload handed over by nav_app_leave( r_data = ... ) arrives as a
        " generic data reference - the receiver decides the type
        
        ASSIGN ls_get-r_event_data->* TO <s_result>.

        IF <s_result> IS ASSIGNED.

          s_result = <s_result>.
          client->message_toast_display( |Returned event { returned_event }, | &&
                                         |product { s_result-product }, quantity { s_result-quantity }| ).

        ENDIF.

      WHEN `DATA_CANCELLED`.

        
        CLEAR temp2.
        s_result = temp2.
        client->message_toast_display( `Returned event DATA_CANCELLED, no data passed` ).

    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
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
            )->a( n = `title`          v = `abap2UI5 - Navigation - Return Data and Events to the Caller`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Calls a second app that returns via nav_app_leave with an event and a data ` &&
                   `payload (r_data). On return this app reads both from client->get( ) in its ` &&
                   `check_on_navigated( ) branch and shows them below.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title`    v = `Result returned by the called app`
                )->a( n = `editable` b = abap_true
                )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `Open the input app` ).
    form->tag( `Button`
        )->a( n = `press` v = client->_event( `CALL_APP` )
        )->a( n = `text`  v = `call app (nav_app_call)`
        )->a( n = `type`  v = `Emphasized` ).

    form->tag( `Label`
        )->a( n = `text` v = `Returned event` ).
    form->tag( `Input`
        )->a( n = `enabled` b = abap_false
        )->a( n = `value`   v = client->_bind( returned_event ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Returned product` ).
    form->tag( `Input`
        )->a( n = `enabled` b = abap_false
        )->a( n = `value`   v = client->_bind( s_result-product ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Returned quantity` ).
    form->tag( `Input`
        )->a( n = `enabled` b = abap_false
        )->a( n = `value`   v = client->_bind( s_result-quantity ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
