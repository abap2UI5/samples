CLASS z2ui5_cl_smp_app_025 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input              TYPE string.
    DATA input_previous     TYPE string.
    DATA input_previous_set TYPE string.
    DATA show_view          TYPE string.
    DATA event_backend      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_025 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      IF event_backend = `NEW_APP_EVENT`.
        client->message_box_display( `new app called and event NEW_APP_EVENT raised` ).
      ENDIF.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE REF TO z2ui5_cl_smp_app_025.
        DATA temp2 TYPE REF TO z2ui5_cl_smp_app_024.
        DATA app_024 LIKE temp2.
        DATA temp3 TYPE REF TO z2ui5_cl_smp_app_024.
        DATA app_back LIKE temp3.

    CASE client->get_event( ).

      WHEN `BUTTON_ROUNDTRIP`.
        client->message_box_display( `server-client roundtrip, method on_event of the abap controller was called` ).

      WHEN `BUTTON_RESTART`.
        
        CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_025.
        client->nav_app_call( temp1 ).

      WHEN `BUTTON_READ_PREVIOUS`.
        
        temp2 ?= client->get_app_prev( ).
        
        app_024 = temp2.
        input_previous = app_024->input2.
        client->message_toast_display( `data of previous app read` ).

      WHEN `SHOW_VIEW_MAIN`.
        show_view = `MAIN`.

      WHEN `BACK_WITH_EVENT`.
        
        temp3 ?= client->get_app( client->get( )-s_draft-id_prev_app_stack ).
        
        app_back = temp3.
        app_back->backend_event = `CALL_PREVIOUS_APP_INPUT_RETURN`.
        client->nav_app_leave( app_back ).

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
            )->a( n = `title`          v = `abap2UI5 - flow logic - APP 02`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The second app in the app-to-app flow: it reads the caller's data, returns to it ` &&
                   `optionally raising an event, and switches between two views.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    CASE show_view.

      WHEN `MAIN` OR ``.
        page->ele( n = `Grid` ns = `layout`
            )->a( n = `defaultSpan` v = `L6 M12 S12`
            )->ele( n = `content` ns = `layout`
                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `title`    v = `View: FIRST`
                    )->a( n = `editable` b = abap_true
                    )->ele( n = `content` ns = `form`
                        )->tag( `Label`
                            )->a( n = `text` v = `Input set by previous app`
                        )->tag( `Input`
                            )->a( n = `value` v = input_previous_set
                        )->tag( `Label`
                            )->a( n = `text` v = `Data of previous app`
                        )->tag( `Input`
                            )->a( n = `value` v = input_previous
                        )->tag( `Button`
                            )->a( n = `press` v = client->_event( `BUTTON_READ_PREVIOUS` )
                            )->a( n = `text`  v = `read`
                        )->tag( `Label`
                            )->a( n = `text` v = `Call previous app and show data of this app`
                        )->tag( `Input`
                            )->a( n = `value` v = client->_bind( input )
                        )->tag( `Button`
                            )->a( n = `press` v = client->_event( `BACK_WITH_EVENT` )
                            )->a( n = `text`  v = `back` ).

      WHEN `SECOND`.
        page->ele( n = `Grid` ns = `layout`
            )->a( n = `defaultSpan` v = `L6 M12 S12`
            )->ele( n = `content` ns = `layout`
                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `title`    v = `View: SECOND`
                    )->a( n = `editable` b = abap_true
                    )->ele( n = `content` ns = `form`
                        )->tag( `Label`
                            )->a( n = `text` v = `Demo`
                        )->tag( `Button`
                            )->a( n = `press` v = client->_event_nav_app_leave( )
                            )->a( n = `text`  v = `leave to previous app`
                        )->tag( `Label`
                            )->a( n = `text` v = `Demo`
                        )->tag( `Button`
                            )->a( n = `press` v = client->_event( `SHOW_VIEW_MAIN` )
                            )->a( n = `text`  v = `show view main` ).

    ENDCASE.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
