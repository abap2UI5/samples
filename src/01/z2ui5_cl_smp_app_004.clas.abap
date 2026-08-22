" @keywords roundtrip restart second view uncaught error controller basics
" @summary What one event does to a running app: a second view replaces the first, the state comes back with it, and an uncaught error surfaces where you can see it.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/life_cycle https://abap2ui5.github.io/docs/cookbook/expert_more/snippets https://abap2ui5.github.io/docs/tutorials/walkthrough/step-3
CLASS z2ui5_cl_smp_app_004 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client    TYPE REF TO z2ui5_if_client.
    DATA view_main TYPE string.

    METHODS on_init.
    METHODS on_event.
    METHODS view_main_display.
    METHODS view_second_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_004 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.

      " the app has two views and remembers which one is up, so returning
      " from a sub-app brings back the one the user left, not the first
      IF view_main = `SECOND`.
        view_second_display( ).
      ELSE.
        view_main_display( ).
      ENDIF.

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    view_main_display( ).
    client->message_box_display( `app started, init values set` ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE REF TO z2ui5_cl_smp_app_004.
        DATA dummy TYPE i.

    CASE client->get_event( ).
      WHEN `BUTTON_ROUNDTRIP`.
        client->message_box_display( `server-client roundtrip, method on_event of the abap controller was called` ).
      WHEN `BUTTON_RESTART`.
        
        CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_004.
        client->nav_app_leave( temp1 ).
      WHEN `BUTTON_CHANGE_VIEW`.
        CASE view_main.
          WHEN `MAIN`.
            view_second_display( ).
          WHEN `SECOND`.
            view_main_display( ).
        ENDCASE.
      WHEN `BUTTON_ERROR`.
        
        dummy = 1 / 0.
        client->message_box_display( |{ dummy }| ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_main_display.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.

    view_main = `MAIN`.

    
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
            )->a( n = `title`          v = `abap2UI5 - Basics IV - Events, Views and Roundtrips`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Controller basics: the buttons trigger a server roundtrip, restart the app, ` &&
                   `switch to a second view, or raise an uncaught error.`
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
                        )->a( n = `text` v = `Roundtrip`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_ROUNDTRIP` )
                        )->a( n = `text`  v = `Client/Server Interaction`
                    )->tag( `Label`
                        )->a( n = `text` v = `System`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_RESTART` )
                        )->a( n = `text`  v = `Restart App`
                    )->tag( `Label`
                        )->a( n = `text` v = `Change View`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_CHANGE_VIEW` )
                        )->a( n = `text`  v = `Display View SECOND`
                    )->tag( `Label`
                        )->a( n = `text` v = `CX_SY_ZERO_DIVIDE`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_ERROR` )
                        )->a( n = `text`  v = `Error not catched by the user` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD view_second_display.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.

    view_main = `SECOND`.

    
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
            )->a( n = `title`          v = `abap2UI5 - Basics IV - Events, Views and Roundtrips`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L12 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title` v = `View Second`
                )->ele( n = `content` ns = `form`
                    )->tag( `Label`
                        )->a( n = `text` v = `Change View`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_CHANGE_VIEW` )
                        )->a( n = `text`  v = `Display View MAIN` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
