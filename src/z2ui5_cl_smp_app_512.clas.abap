" @keywords messagebox global object control_global follow_up_action options icon contentwidth textdirection closeonnavigation dependenton actions onclose
" @summary The MessageBox steered as the UI5 control it is: the display method IS the box type, and every sap.m.MessageBox option travels 1:1 in the option object of the global call.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_512 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA answer TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS render_demo
      IMPORTING
        form  TYPE REF TO z2ui5_cl_ui5_view_builder
        label TYPE string
        text  TYPE string
        descr TYPE string
        press TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_512 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA row TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    DATA temp1 LIKE temp3.
    DATA type LIKE LINE OF temp1.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Message - MessageBox via the Global Object`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `follow_up_action( cs_event-control_global ) calls sap.m.MessageBox itself: the ` &&
                   `display method is the box type, and the last argument is the option object of that API 1:1. ` &&
                   `Use it when you want the CONTROL - an icon, a width, a text direction, a dependent box. Use ` &&
                   `client->message_box_display( ) when you want the ABAP side - a BAPIRET2 table, an exception, ` &&
                   `a structure thrown in as it is: Z2UI5_CL_SMP_APP_502 shows that half.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->a( n = `layout`   v = `ResponsiveGridLayout`
        )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `The method is the type` ).

    
    row = form->ele( `HBox` ).

    
    CLEAR temp3.
    INSERT `information` INTO TABLE temp3.
    INSERT `success` INTO TABLE temp3.
    INSERT `warning` INTO TABLE temp3.
    INSERT `error` INTO TABLE temp3.
    
    temp1 = temp3.
    
    LOOP AT temp1 INTO type.
      row->tag( `Button`
          )->a( n = `text`  t = type
          )->a( n = `press` v = client->_event( val = `TYPE`
                                                arg = type )
          )->a( n = `class` v = `sapUiTinyMarginEnd` ).
    ENDLOOP.

    render_demo( form  = form
                 label = `Options`
                 text  = `icon, contentWidth, textDirection, ...`
                 descr = `The UI5 options, by their UI5 names - none of them is a parameter of the client method`
                 press = client->_event( `OPTIONS` ) ).

    render_demo( form  = form
                 label = `dependentOn`
                 text  = `A box tied to a control`
                 descr = `The id travels, the frontend resolves it - the box is destroyed with the control (UI5 1.124)`
                 press = client->_event( `DEPENDENT` ) ).

    render_demo( form  = form
                 label = `Actions`
                 text  = `Buttons and the answer`
                 descr = `onClose stays a backend event - the pressed action comes back as the first event argument`
                 press = client->_event( `ACTIONS` ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Your answer` ).

    form->tag( `Text`
        )->a( n = `text` v = client->_bind( answer ) ).

    " ... and the call WIRED into the view: the same box, opened by the
    " press itself. The backend never sees this button - which is the second
    " reason the global object exists
    form->tag( `Label`
        )->a( n = `text` v = `Wired` ).

    
    CLEAR temp2.
    INSERT `MESSAGE_BOX` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Opened by the press itself - the backend never saw it.` INTO TABLE temp2.
    form->tag( `Button`
        )->a( n = `text`  v = `No round-trip at all`
        )->a( n = `press` v = client->follow_up_action(
                                  val   = client->cs_event-control_global
                                  t_arg = temp2 ) ).

    page->ele( `Panel`
        )->a( n = `id`         v = `demoPanel`
        )->a( n = `headerText` v = `demoPanel - the control the dependent box hangs on`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->tag( `Text`
            )->a( n = `text` v = `A box opened with dependentOn is destroyed when this panel is.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp4 TYPE string_table.
        DATA temp5 LIKE LINE OF temp4.
        DATA temp6 TYPE string_table.
        DATA temp7 LIKE LINE OF temp6.
        DATA temp8 TYPE string_table.
        DATA temp10 TYPE string_table.
        DATA temp9 LIKE LINE OF temp10.

    CASE client->get_event( ).

      WHEN `TYPE`.
        " The display method IS the box type: show, alert, confirm,
        " information, warning, error, success - the seven methods
        " sap.m.MessageBox carries, called by name. No mapping, no
        " translation, nothing this sample has to keep in sync with UI5
        
        CLEAR temp4.
        INSERT `MESSAGE_BOX` INTO TABLE temp4.
        INSERT client->get_event_arg( ) INTO TABLE temp4.
        
        temp5 = |MessageBox.{ client->get_event_arg( ) }( ) - called by its own name|.
        INSERT temp5 INTO TABLE temp4.
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = temp4 ).

      WHEN `OPTIONS`.
        " Everything sap.m.MessageBox takes, in the option object of the
        " call: a t_arg that starts with a brace is embedded as REAL JSON,
        " so this arrives as an object and the names are the UI5 names.
        " These five have no parameter on client->message_box_display( ) -
        " they belong to the control, not to the ABAP app, and this is
        " where they are set. Z2UI5_CL_SMP_APP_502 is the other half: the
        " same box, filled with whatever data the app already holds
        
        CLEAR temp6.
        INSERT `MESSAGE_BOX` INTO TABLE temp6.
        INSERT `warning` INTO TABLE temp6.
        INSERT `The delivery date lies in the past.` INTO TABLE temp6.
        
        temp7 = `{"title":"Please check","icon":"WARNING","contentWidth":"25rem",` && `"textDirection":"Inherit","closeOnNavigation":false,"styleClass":"sapUiSizeCompact"}`.
        INSERT temp7 INTO TABLE temp6.
        client->follow_up_action(
            val   = client->cs_event-control_global
            t_arg = temp6 ).

      WHEN `DEPENDENT`.
        " dependentOn ties the box to the lifecycle of a control - it is
        " destroyed with it. The backend sends the control id and the
        " frontend resolves it; an id it cannot resolve drops the option
        " rather than handing UI5 a string it would choke on. UI5 1.124 on
        
        CLEAR temp8.
        INSERT `MESSAGE_BOX` INTO TABLE temp8.
        INSERT `information` INTO TABLE temp8.
        INSERT `This box is a dependent of the panel below - it dies with it.` INTO TABLE temp8.
        INSERT `{"dependentOn":"demoPanel"}` INTO TABLE temp8.
        client->follow_up_action(
            val   = client->cs_event-control_global
            t_arg = temp8 ).

      WHEN `ACTIONS`.
        " onClose is a BACKEND event name even here: the frontend turns it
        " into the round-trip that reaches the ANSWERED branch below, with
        " the pressed action as the first event argument. So the raw call
        " is not a one-way street - it reaches the app again like any event
        
        CLEAR temp10.
        INSERT `MESSAGE_BOX` INTO TABLE temp10.
        INSERT `warning` INTO TABLE temp10.
        INSERT `Delete document 4711?` INTO TABLE temp10.
        
        temp9 = `{"title":"Delete","actions":["DELETE","Later","CANCEL"],` && `"emphasizedAction":"DELETE","initialFocus":"CANCEL","onClose":"ANSWERED"}`.
        INSERT temp9 INTO TABLE temp10.
        client->follow_up_action(
            val   = client->cs_event-control_global
            t_arg = temp10 ).

      WHEN `ANSWERED`.
        " the answer of the box above. Nothing is rendered here: `answer` is
        " bound, and changed bound data reaches the open view on its own
        answer = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.


  METHOD render_demo.
    DATA row TYPE REF TO z2ui5_cl_ui5_view_builder.

    form->tag( `Label`
        )->a( n = `text` t = label ).

    
    row = form->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->a( n = `wrap`       v = `Wrap` ).

    row->tag( `Button`
        )->a( n = `text`  t = text
        )->a( n = `press` v = press
        )->a( n = `width` v = `15rem` ).

    row->tag( `Text`
        )->a( n = `text`  t = descr
        )->a( n = `class` v = `sapUiSmallMarginBegin` ).

  ENDMETHOD.

ENDCLASS.
