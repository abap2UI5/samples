" @keywords nav_app_call nav_app_leave sub app stack call back
" @summary Calling another app and coming back: nav_app_call puts the caller on a stack, nav_app_leave returns to it.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/navigation
CLASS z2ui5_cl_smp_app_024 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input         TYPE string.
    DATA input2        TYPE string.
    DATA backend_event TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_024 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
        DATA temp1 TYPE REF TO z2ui5_cl_smp_app_025.
        DATA app_025 LIKE temp1.
        DATA temp2 TYPE string.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.

      IF backend_event = `CALL_PREVIOUS_APP_INPUT_RETURN`.

        
        temp1 ?= client->get_app_prev( ).
        
        app_025 = temp1.
        
        CLEAR temp2.
        backend_event = temp2.
        client->message_box_display( |Input made in the previous app: { app_025->input }| ).

      ENDIF.

      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE REF TO z2ui5_cl_smp_app_025.
        DATA app TYPE REF TO z2ui5_cl_smp_app_025.
        DATA app_next TYPE REF TO z2ui5_cl_smp_app_025.

    CASE client->get_event( ).

      WHEN `CALL_NEW_APP`.
        
        CREATE OBJECT temp3 TYPE z2ui5_cl_smp_app_025.
        client->nav_app_call( temp3 ).

      WHEN `CALL_NEW_APP_VIEW`.
        
        CREATE OBJECT app TYPE z2ui5_cl_smp_app_025.
        app->show_view = `SECOND`.
        client->nav_app_call( app ).

      WHEN `CALL_NEW_APP_READ`.
        
        CREATE OBJECT app_next TYPE z2ui5_cl_smp_app_025.
        app_next->input_previous_set = input.
        client->nav_app_call( app_next ).

      WHEN `CALL_NEW_APP_EVENT`.
        CREATE OBJECT app_next TYPE z2ui5_cl_smp_app_025.
        app_next->event_backend = `NEW_APP_EVENT`.
        client->nav_app_call( app_next ).

    ENDCASE.

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
            )->a( n = `title`          v = `abap2UI5 - Navigation - Call and Leave Apps (nav_app_call)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `App-to-app navigation: calls a second app in different ways - open a view, raise ` &&
                   `an event or pass data - and reads the input it returns.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title`    v = `Controller`
                )->a( n = `editable` b = abap_true
                )->ele( n = `content` ns = `form`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `CALL_NEW_APP` )
                        )->a( n = `text`  v = `call new app (first View)`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `CALL_NEW_APP_VIEW` )
                        )->a( n = `text`  v = `call new app (second View)`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `CALL_NEW_APP_EVENT` )
                        )->a( n = `text`  v = `call new app (set Event)`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Input`
                        )->a( n = `value` v = client->_bind( input )
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `CALL_NEW_APP_READ` )
                        )->a( n = `text`  v = `call new app (set data)`
                    )->tag( `Label`
                        )->a( n = `text` v = `some data, you can read in the next app`
                    )->tag( `Input`
                        )->a( n = `value` v = client->_bind( input2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
