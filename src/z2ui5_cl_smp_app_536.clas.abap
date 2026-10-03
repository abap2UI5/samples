" @keywords customdata data app namespace attach control list template t_arg
" @summary Attaches data objects to controls - with the app: namespace shortcut, bound or static, and as a CustomData template in a list binding - and reads them back with data( ) when an event fires.
CLASS z2ui5_cl_smp_app_536 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_question,
        question TYPE string,
        answer   TYPE string,
      END OF ty_s_question.
    DATA coords      TYPE string.
    DATA answer      TYPE string.
    DATA t_questions TYPE STANDARD TABLE OF ty_s_question WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_536 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_questions.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      coords      = `49.29, 8.64`.
      
      CLEAR temp1.
      
      temp2-question = `What does data( ) return without a key?`.
      temp2-answer = `A plain object that holds all custom data of the control.`.
      INSERT temp2 INTO TABLE temp1.
      temp2-question = `Which namespace makes the attribute shortcut work?`.
      temp2-answer = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1`.
      INSERT temp2 INTO TABLE temp1.
      temp2-question = `Can the value of a custom data be bound?`.
      temp2-answer = `Yes - it is a normal property and follows its binding like any other.`.
      INSERT temp2 INTO TABLE temp1.
      t_questions = temp1.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE abap_true.

      WHEN client->check_on_event( `STATIC` ).
        client->message_toast_display( |data( "mySuperExtraData" ) = { client->get_event_arg( ) }| ).

      WHEN client->check_on_event( `BOUND` ).
        client->message_toast_display( |data( "coords" ) = { client->get_event_arg( ) }| ).

      WHEN client->check_on_event( `ALL` ).
        " data( ) without a key answers a plain object - an object argument
        " reaches the backend as its JSON text
        client->message_toast_display( |data( ) = { client->get_event_arg( ) }| ).

      WHEN client->check_on_event( `SELECT` ).
        " the answer is not looked up in t_questions - it arrives as the
        " custom data of the list item the user selected
        answer = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA panel TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA list TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:app`    v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.CustomData/1` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Event - Custom Data Attached to Controls`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Every control can carry data objects of its own with data( ). In an XML view they are written as ` &&
                   `app:key="value" attributes or as core:CustomData elements, statically or bound, and an event ` &&
                   `argument reads them back with data( 'key' ) when the control fires.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " app:key="value" is the shortcut for a core:CustomData element in the
    " customData aggregation - it needs the xmlns:app namespace declared above.
    " The backend SETS custom data through the binding (app:coords follows the
    " input), and reads it back with data( ) as an event argument. Writing it
    " into the HTML DOM as a data-* attribute is Z2UI5_CL_SMP_APP_535
    
    panel = page->ele( `Panel`
        )->a( n = `headerText` v = `The app: namespace shortcut`
        )->a( n = `class`      v = `sapUiResponsiveMargin`
        )->a( n = `width`      v = `auto` ).

    panel->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->tag( `Button`
            )->a( n = `text`                 v = `Without Binding`
            )->a( n = `class`                v = `sapUiSmallMarginEnd`
            )->a( n = `app:mySuperExtraData` v = `just great`
            )->a( n = `press`                v = client->_event( val = `STATIC`
                                                                 arg = `$event.getSource().data('mySuperExtraData')` )
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( coords )
            )->a( n = `width` v = `12rem`
            )->a( n = `class` v = `sapUiSmallMarginEnd`
        )->tag( `Button`
            )->a( n = `text`       v = `With Binding`
            )->a( n = `class`      v = `sapUiSmallMarginEnd`
            )->a( n = `app:coords` v = client->_bind( coords )
            )->a( n = `press`      v = client->_event( val = `BOUND`
                                                       arg = `$event.getSource().data('coords')` )
        )->tag( `Button`
            )->a( n = `text`                 v = `All Custom Data`
            )->a( n = `app:myData`           v = `Hello`
            )->a( n = `app:mySuperExtraData` v = `just great`
            )->a( n = `press`                v = client->_event( val = `ALL`
                                                                 arg = `$event.getSource().data()` ) ).

    " a core:CustomData in the item template is cloned for every row, and its
    " value binding resolves against that row - so each item carries its answer
    
    list = page->ele( `List`
        )->a( n = `headerText`      v = `CustomData in a list binding - select a question`
        )->a( n = `mode`            v = `SingleSelectMaster`
        )->a( n = `items`           v = client->_bind( t_questions )
        )->a( n = `class`           v = `sapUiResponsiveMargin`
        )->a( n = `width`           v = `auto`
        )->a( n = `selectionChange` v = client->_event( val = `SELECT`
                                                        arg = `${$parameters>/listItem}.data('answer')` ) ).

    list->ele( `StandardListItem`
        )->a( n = `title` v = `{QUESTION}`
        )->ele( `customData`
            )->tag( n = `CustomData` ns = `core`
                )->a( n = `key`   v = `answer`
                )->a( n = `value` v = `{ANSWER}` ).

    page->tag( `Text`
        )->a( n = `text`  v = `Answer read from the selected item: ` && client->_bind( answer )
        )->a( n = `class` v = `sapUiResponsiveMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
