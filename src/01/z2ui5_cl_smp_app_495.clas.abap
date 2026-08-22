" @keywords lifecycle roundtrip main dispatcher state serialize check_on_init check_on_event check_on_navigated
" @summary The three questions main( ) asks - init, event, navigated - as one dispatcher, showing what survives a roundtrip and what a navigation does to it.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/life_cycle https://abap2ui5.github.io/docs/cookbook/expert_more/snippets https://abap2ui5.github.io/docs/tutorials/walkthrough/step-3
CLASS z2ui5_cl_smp_app_495 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_step,
        no    TYPE string,
        check TYPE string,
      END OF ty_s_step.
    DATA t_log TYPE STANDARD TABLE OF ty_s_step WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS log_step
      IMPORTING
        val TYPE string.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_495 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE REF TO z2ui5_cl_smp_app_493.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      log_step( `check_on_init( ) - the very first call, nothing exists yet` ).
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.

      log_step( `check_on_navigated( ) - the sub-app returned, re-display the view` ).
      view_display( ).

    ELSEIF client->check_on_event( `LOG` ) IS NOT INITIAL.
      log_step( `check_on_event( ) - a button was pressed, the view stays as it is` ).

    ELSEIF client->check_on_event( `CALL` ) IS NOT INITIAL.

      log_step( `check_on_event( ) - calling Basics I as a sub-app` ).
      
      CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_493.
      client->nav_app_call( temp1 ).

    ENDIF.

  ENDMETHOD.


  METHOD log_step.

    DATA temp2 TYPE z2ui5_cl_smp_app_495=>ty_s_step.
    CLEAR temp2.
    temp2-no = |{ lines( t_log ) + 1 }|.
    temp2-check = val.
    INSERT temp2 INTO TABLE t_log.

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
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Basics III - Lifecycle: Init, Event, Navigated`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `main( ) runs on every roundtrip - the three checks tell it what the ` &&
                   `roundtrip is about. The list logs each call, and it survives them all: ` &&
                   `every public attribute is serialized between the roundtrips, so the app ` &&
                   `keeps its state without a database. Press Log - only the model is pushed, ` &&
                   `the view is not rebuilt. Call the sub-app and come back with its back ` &&
                   `button - that is the roundtrip check_on_navigated( ) answers.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `LOG` )
            )->a( n = `text`  v = `Log an Event`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `CALL` )
            )->a( n = `text`  v = `Call a Sub-App`
            )->a( n = `class` v = `sapUiTinyMarginBegin` ).

    page->ele( `List`
        )->a( n = `headerText` v = `Calls of main( )`
        )->a( n = `items`      v = client->_bind( t_log )
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{CHECK}`
            )->a( n = `description` v = `call {NO}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
