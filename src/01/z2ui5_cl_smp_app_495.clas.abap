" @keywords lifecycle roundtrip main dispatcher state serialize check_on_init check_on_event check_on_navigated
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

    METHODS log
      IMPORTING
        val TYPE string.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_495 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      log( `check_on_init( ) - the very first call, nothing exists yet` ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).

      log( `check_on_navigated( ) - the sub-app returned, re-display the view` ).
      view_display( ).

    ELSEIF client->check_on_event( `LOG` ).
      log( `check_on_event( ) - a button was pressed, the view stays as it is` ).

    ELSEIF client->check_on_event( `CALL` ).

      log( `check_on_event( ) - calling Basics I as a sub-app` ).
      client->nav_app_call( NEW z2ui5_cl_smp_app_493( ) ).

    ENDIF.

  ENDMETHOD.


  METHOD log.

    INSERT VALUE #(
        no    = |{ lines( t_log ) + 1 }|
        check = val ) INTO TABLE t_log.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Basics III - Lifecycle: Init, Event, Navigated`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `main( ) runs on every roundtrip - the three checks tell it what the ` &&
                   `roundtrip is about. The list logs each call, and it survives them all: ` &&
                   `every public attribute is serialized between the roundtrips, so the app ` &&
                   `keeps its state without a database. Press Log - only the model is pushed, ` &&
                   `the view is not rebuilt. Call the sub-app and come back with its back ` &&
                   `button - that is the roundtrip check_on_navigated( ) answers.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->hbox( class = `sapUiSmallMargin`
        )->button(
            text  = `Log an Event`
            press = client->_event( `LOG` )
        )->button(
            text  = `Call a Sub-App`
            press = client->_event( `CALL` )
            class = `sapUiTinyMarginBegin` ).

    page->list(
        headertext = `Calls of main( )`
        items      = client->_bind( t_log )
        class      = `sapUiSmallMargin`
        )->standard_list_item(
            title       = `{CHECK}`
            description = `call {NO}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
