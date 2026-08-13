" @keywords developer tools devtools ctrl f12 debug inspect payload previous request response view xml view model source code log error adt export
CLASS z2ui5_cl_smp_app_496 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        name  TYPE string,
        descr TYPE string,
      END OF ty_s_tab.

    " a public attribute is serialized between the roundtrips - so everything
    " on this page is part of what the View Model tab of the tools shows
    DATA t_tab      TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.
    DATA text       TYPE string.
    DATA roundtrips TYPE i.

  PROTECTED SECTION.
    CONSTANTS:
      BEGIN OF cs_event,
        ping  TYPE string VALUE `PING`,
        where TYPE string VALUE `WHERE`,
      END OF cs_event.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS tabs_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_496 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      text = `change me and press Send`.
      tabs_init( ).
      view_display( ).

    ELSEIF client->check_on_event( cs_event-ping ).

      " nothing to compute - the point is the roundtrip itself, so there is
      " something to look at in Previous Request and Response
      roundtrips = roundtrips + 1.

    ELSEIF client->check_on_event( cs_event-where ).

      " there is no ABAP call that opens the tools: they are a control of the
      " frontend, toggled by the shortcut - the framework's own start page
      " answers this question the same way
      client->message_box_display(
          title = `Developer Tools`
          text  = `Press Ctrl+F12 to open and close the developer tools. They belong to the framework, ` &&
                  `not to this sample - the shortcut works in every abap2UI5 app.` ).

    ENDIF.

  ENDMETHOD.


  METHOD tabs_init.

    t_tab = VALUE #(
      ( name  = `Error`
        descr = `The last uncaught exception with its call stack - the same one the error popup shows.` )
      ( name  = `Log`
        descr = `What the frontend did since the app started: roundtrips, frontend actions, events.` )
      ( name  = `Previous Request`
        descr = `The JSON this browser sent last - your event, the changed model, the app state.` )
      ( name  = `Response`
        descr = `The JSON the backend sent back - the new view, the new model, the follow-up actions.` )
      ( name  = `Source Code`
        descr = `The ABAP class behind the running app, with an ADT jump link in the dialog footer.` )
      ( name  = `View`
        descr = `The XML view your ABAP built - what z2ui5_cl_xml_view stringified into the response.` )
      ( name  = `View Model`
        descr = `The model behind that view: every bound attribute of this class with its live value.` )
      ( name  = `Popup, Popover, Nest1, Nest2`
        descr = `The same two tabs - view and model - for each of the other view slots of the app.` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Basics V - The Developer Tools (Ctrl+F12)`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Press Ctrl+F12 - here and in every other abap2UI5 app - and the developer tools ` &&
                   `open over the app. They show what travels between this class and the browser: the ` &&
                   `XML view your ABAP built, the model behind it, and the JSON of the last request and ` &&
                   `response. Change the text below, press Send, and look at Previous Request: the value ` &&
                   `you typed is in it. Then look at View Model - it is there too, because a public ` &&
                   `attribute is the model.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form(
        title    = `Something to look at`
        editable = abap_true
        )->content( `form`
        )->label( `bound to the public attribute TEXT`
        )->input( client->_bind( text )
        )->label( `roundtrips so far`
        )->text( client->_bind( roundtrips )
        )->label( `send it to the backend`
        )->button(
            text  = `Send`
            press = client->_event( cs_event-ping )
        )->label( `how do I open the tools?`
        )->button(
            text  = `Show me`
            icon  = `sap-icon://sys-help`
            press = client->_event( cs_event-where ) ).

    page->list(
        headertext = `What the tabs of the tools show`
        items      = client->_bind( t_tab )
        class      = `sapUiSmallMargin`
        )->standard_list_item(
            title       = `{NAME}`
            description = `{DESCR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
