" @keywords developer tools devtools ctrl f12 debug inspect payload previous request response view xml view model source code log error adt export
" @summary What Ctrl+F12 opens: the request and response payload, the generated XML view, the model, the source and the error log - the first place to look when something does not render.
" @docs https://abap2ui5.github.io/docs/cookbook/troubleshooting/common_failures
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

    IF client->check_on_init( ) IS NOT INITIAL.

      text = `change me and press Send`.
      tabs_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( cs_event-ping ) IS NOT INITIAL.

      " nothing to compute - the point is the roundtrip itself, so there is
      " something to look at in Previous Request and Response
      roundtrips = roundtrips + 1.

    ELSEIF client->check_on_event( cs_event-where ) IS NOT INITIAL.

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

    DATA temp1 LIKE t_tab.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Error`.
    temp2-descr = `The last uncaught exception with its call stack - the same one the error popup shows.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Log`.
    temp2-descr = `What the frontend did since the app started: roundtrips, frontend actions, events.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Previous Request`.
    temp2-descr = `The JSON this browser sent last - your event, the changed model, the app state.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Response`.
    temp2-descr = `The JSON the backend sent back - the new view, the new model, the follow-up actions.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Source Code`.
    temp2-descr = `The ABAP class behind the running app, with an ADT jump link in the dialog footer.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `View`.
    temp2-descr = `The XML view your ABAP built - what z2ui5_cl_ui5_view_builder stringified into the response.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `View Model`.
    temp2-descr = `The model behind that view: every bound attribute of this class with its live value.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Popup, Popover, Nest1, Nest2`.
    temp2-descr = `The same two tabs - view and model - for each of the other view slots of the app.`.
    INSERT temp2 INTO TABLE temp1.
    t_tab = temp1.

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
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Basics V - The Developer Tools (Ctrl+F12)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Press Ctrl+F12 - here and in every other abap2UI5 app - and the developer tools ` &&
                   `open over the app. They show what travels between this class and the browser: the ` &&
                   `XML view your ABAP built, the model behind it, and the JSON of the last request and ` &&
                   `response. Change the text below, press Send, and look at Previous Request: the value ` &&
                   `you typed is in it. Then look at View Model - it is there too, because a public ` &&
                   `attribute is the model.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Something to look at`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `bound to the public attribute TEXT`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( text )
            )->tag( `Label`
                )->a( n = `text` v = `roundtrips so far`
            )->tag( `Text`
                )->a( n = `text` v = client->_bind( roundtrips )
            )->tag( `Label`
                )->a( n = `text` v = `send it to the backend`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( cs_event-ping )
                )->a( n = `text`  v = `Send`
            )->tag( `Label`
                )->a( n = `text` v = `how do I open the tools?`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( cs_event-where )
                )->a( n = `text`  v = `Show me`
                )->a( n = `icon`  v = `sap-icon://sys-help` ).

    page->ele( `List`
        )->a( n = `headerText` v = `What the tabs of the tools show`
        )->a( n = `items`      v = client->_bind( t_tab )
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{NAME}`
            )->a( n = `description` v = `{DESCR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
