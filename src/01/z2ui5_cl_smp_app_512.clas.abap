" @keywords messagebox global object control_global follow_up_action options icon contentwidth textdirection closeonnavigation dependenton actions onclose
" @summary The MessageBox steered as the UI5 control it is: the display method IS the box type, and every sap.m.MessageBox option travels 1:1 in the option object of the global call.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_512 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA answer TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
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
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TYPE`.
        " The display method IS the box type: show, alert, confirm,
        " information, warning, error, success - the seven methods
        " sap.m.MessageBox carries, called by name. No mapping, no
        " translation, nothing this sample has to keep in sync with UI5
        client->follow_up_action( val   = client->cs_event-control_global
                                  t_arg = VALUE #( ( `MESSAGE_BOX` )
                                                   ( client->get_event_arg( ) )
                                                   ( |MessageBox.{ client->get_event_arg( ) }( ) - called by its own name| ) ) ).

      WHEN `OPTIONS`.
        " Everything sap.m.MessageBox takes, in the option object of the
        " call: a t_arg that starts with a brace is embedded as REAL JSON,
        " so this arrives as an object and the names are the UI5 names.
        " These five have no parameter on client->message_box_display( ) -
        " they belong to the control, not to the ABAP app, and this is
        " where they are set. Z2UI5_CL_SMP_APP_502 is the other half: the
        " same box, filled with whatever data the app already holds
        client->follow_up_action(
            val   = client->cs_event-control_global
            t_arg = VALUE #( ( `MESSAGE_BOX` )
                             ( `warning` )
                             ( `The delivery date lies in the past.` )
                             ( `{"title":"Please check","icon":"WARNING","contentWidth":"25rem",` &&
                               `"textDirection":"Inherit","closeOnNavigation":false,"styleClass":"sapUiSizeCompact"}` ) ) ).

      WHEN `DEPENDENT`.
        " dependentOn ties the box to the lifecycle of a control - it is
        " destroyed with it. The backend sends the control id and the
        " frontend resolves it; an id it cannot resolve drops the option
        " rather than handing UI5 a string it would choke on. UI5 1.124 on
        client->follow_up_action(
            val   = client->cs_event-control_global
            t_arg = VALUE #( ( `MESSAGE_BOX` )
                             ( `information` )
                             ( `This box is a dependent of the panel below - it dies with it.` )
                             ( `{"dependentOn":"demoPanel"}` ) ) ).

      WHEN `ACTIONS`.
        " onClose is a BACKEND event name even here: the frontend turns it
        " into the round-trip that reaches the ANSWERED branch below, with
        " the pressed action as the first event argument. So the raw call
        " is not a one-way street - it reaches the app again like any event
        client->follow_up_action(
            val   = client->cs_event-control_global
            t_arg = VALUE #( ( `MESSAGE_BOX` )
                             ( `warning` )
                             ( `Delete document 4711?` )
                             ( `{"title":"Delete","actions":["DELETE","Later","CANCEL"],` &&
                               `"emphasizedAction":"DELETE","initialFocus":"CANCEL","onClose":"ANSWERED"}` ) ) ).

      WHEN `ANSWERED`.
        " the answer of the box above. Nothing is rendered here: `answer` is
        " bound, and changed bound data reaches the open view on its own
        answer = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
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

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->a( n = `layout`   v = `ResponsiveGridLayout`
        )->ele( n = `content` ns = `form` ).

    DATA(row) = form->tag( `Label`
        )->a( n = `text` v = `The method is the type`
        )->ele( `HBox` ).

    LOOP AT VALUE string_table( ( `information` )
                                ( `success` )
                                ( `warning` )
                                ( `error` ) ) INTO DATA(type).
      row->tag( `Button`
          )->a( n = `text`  v = type
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
        )->a( n = `text` v = `Your answer`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( answer ) ).

    " ... and the call WIRED into the view: the same box, opened by the
    " press itself. The backend never sees this button - which is the second
    " reason the global object exists
    form->tag( `Label`
        )->a( n = `text` v = `Wired`
        )->tag( `Button`
            )->a( n = `text`  v = `No round-trip at all`
            )->a( n = `press` v = client->follow_up_action(
                                      val   = client->cs_event-control_global
                                      t_arg = VALUE #( ( `MESSAGE_BOX` )
                                                       ( `show` )
                                                       ( `Opened by the press itself - the backend never saw it.` ) ) ) ).

    page->ele( `Panel`
        )->a( n = `id`         v = `demoPanel`
        )->a( n = `headerText` v = `demoPanel - the control the dependent box hangs on`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->tag( `Text`
            )->a( n = `text` v = `A box opened with dependentOn is destroyed when this panel is.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD render_demo.

    form->tag( `Label`
        )->a( n = `text` t = label ).

    DATA(row) = form->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->a( n = `wrap`       v = `Wrap` ).

    row->tag( `Button`
        )->a( n = `text`  t = text
        )->a( n = `press` v = press
        )->a( n = `width` v = `15rem`
        )->tag( `Text`
            )->a( n = `text`  t = descr
            )->a( n = `class` v = `sapUiSmallMarginBegin` ).

  ENDMETHOD.

ENDCLASS.
