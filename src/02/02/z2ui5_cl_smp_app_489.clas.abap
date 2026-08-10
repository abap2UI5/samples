CLASS z2ui5_cl_smp_app_489 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_news,
        text   TYPE string,
        author TYPE string,
      END OF ty_s_news.
    TYPES ty_t_news TYPE STANDARD TABLE OF ty_s_news WITH NON-UNIQUE DEFAULT KEY.

    DATA news_input TYPE string.
    DATA author_input TYPE string.
    DATA t_news TYPE ty_t_news.
    DATA connections TYPE i.
    DATA ws_message TYPE string.
    DATA ws_active TYPE abap_bool.
    DATA ws_status TYPE string.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.


    METHODS on_init.
    METHODS on_event.
    METHODS on_event_post.
    METHODS on_event_received.
    METHODS on_event_toggle.
    METHODS on_event_error.
    METHODS view_display.
    METHODS popover_display.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_489 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " Counted before the control connects - our own connection is added
    " when the APC handler broadcasts __NEW_CONNECTION__ back to us.
    connections = z2ui5_cl_smp_app_489_ws=>get_active_connections( ).
    ws_active   = abap_true.
    ws_status   = `Connected`.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `POST`.
        on_event_post( ).
      WHEN `WS_RECEIVED`.
        on_event_received( ).
      WHEN `WS_ERROR`.
        on_event_error( ).
      WHEN `TOGGLE_CONNECTION`.
        on_event_toggle( ).
      WHEN `CLEAR`.
        t_news = VALUE #( ).
      WHEN `CLICK_HINT_ICON`.
        popover_display( ).
        RETURN.
    ENDCASE.

    " The view is displayed once, on init - the Websocket control lives in
    " it and must not be torn down and reconnected on every message, so
    " every event only refreshes the model.
    client->view_model_update( ).

  ENDMETHOD.


  METHOD on_event_post.

    DATA(s_news) = VALUE ty_s_news(
        text   = news_input
        author = COND #( WHEN author_input IS INITIAL THEN `Anonymous` ELSE author_input ) ).

    TRY.
        " Published from ABAP straight into the AMC channel - every APC
        " connection bound to it, this app's own included, receives it back
        " through the Websocket control.
        z2ui5_cl_smp_app_489_ws=>send( z2ui5_cl_ajson=>create_empty(
            )->set(
                iv_path         = `/`
                iv_val          = s_news
                iv_ignore_empty = abap_false
            )->stringify( ) ).
        news_input = ``.
      CATCH cx_root INTO DATA(error).
        client->message_box_display( error->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD on_event_received.

    CASE ws_message.
      WHEN z2ui5_cl_smp_app_489_ws=>c_msg-__new_connection__.
        connections = connections + 1.

      WHEN z2ui5_cl_smp_app_489_ws=>c_msg-__closed__.
        connections = connections - 1.

      WHEN OTHERS.
        TRY.
            DATA(s_news) = VALUE ty_s_news( ).
            z2ui5_cl_ajson=>parse( ws_message
              )->to_abap_corresponding_only(
              )->to_abap( IMPORTING ev_container = s_news ).
            INSERT s_news INTO TABLE t_news.
          CATCH z2ui5_cx_ajson_error INTO DATA(error).
            client->message_toast_display( error->get_text( ) ).
        ENDTRY.
    ENDCASE.

  ENDMETHOD.


  METHOD on_event_toggle.

    " The ToggleButton binds WS_ACTIVE two-way, so the control has already
    " opened or closed the connection client-side when this event arrives -
    " only the counter and the label are left to sort out.
    IF ws_active = abap_true.

      " Reconnecting needs no counting here either: __NEW_CONNECTION__
      " comes back through the reopened connection and adds us.
      ws_status = `Connected`.

    ELSE.

      " We are gone, so the __CLOSED__ broadcast the others receive never
      " reaches us - drop ourselves from the count directly.
      connections = connections - 1.
      ws_status   = `Disconnected`.

    ENDIF.

  ENDMETHOD.


  METHOD on_event_error.

    ws_active = abap_false.
    ws_status = `Disconnected`.
    " The connection is down, so the count can no longer be maintained from
    " the broadcasts - read it from the channel instead.
    connections = z2ui5_cl_smp_app_489_ws=>get_active_connections( ).

    client->message_box_display(
        text = |The WebSocket connection failed ({ client->get_event_arg( 1 ) }): { client->get_event_arg( 2 ) }|
        type = `error` ).

  ENDMETHOD.


  METHOD view_display.

    SELECT
      SINGLE FROM icfservloc
      FIELDS icfactive
      WHERE icf_name = `Z2UI5_APC_SMP_2`
      INTO @DATA(icfactive).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
                    )->page(
                       title          = `abap2UI5 - Sample: News Feed over WebSocket`
                       navbuttonpress = client->_event_nav_app_leave( )
                       shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->message_strip(
        text     = `This sample consumes an ABAP Push Channel without a line of JavaScript: the z2ui5:Websocket ` &&
                   `custom control keeps the connection open, reports every message through its 'received' event ` &&
                   `and a failure through 'error'; publishing goes back into the AMC channel from ABAP. The ` &&
                   `button in the footer opens and closes the connection.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    IF icfactive = abap_false.
      page->message_strip(
          text    = `ICF Service '/sap/bc/apc/sap/z2ui5_apc_smp_2' is not active. WebSocket communication will not work. Please activate the ICF Service in transaction SICF.`
          type    = `Warning`
          visible = abap_true ).
    ENDIF.

    " The connection itself: an invisible control that writes each inbound
    " message into WS_MESSAGE and raises WS_RECEIVED so the app can process
    " it. Built generically rather than through _z2ui5( )->websocket( ),
    " because that builder method predates the control's error event.
    page->_generic(
        name   = `Websocket`
        ns     = `z2ui5`
        t_prop = VALUE #(
            ( n = `path`        v = `/sap/bc/apc/sap/z2ui5_apc_smp_2` )
            ( n = `value`       v = client->_bind( ws_message ) )
            ( n = `checkActive` v = client->_bind( ws_active ) )
            ( n = `received`    v = client->_event( `WS_RECEIVED` ) )
            ( n = `error`       v = client->_event(
                                        val   = `WS_ERROR`
                                        t_arg = VALUE #( ( `${$parameters>/code}` )
                                                         ( `${$parameters>/message}` ) ) ) ) ) ).

    DATA(form) = page->simple_form( editable = abap_true
                                    title    = `Publish news`
                                    class    = `sapUiTinyMarginBottom`
                    )->content( `form` ).

    " Publishing while disconnected would work - it goes into the channel
    " from ABAP - but the app would not see its own news come back.
    form->feed_input(
        value   = client->_bind( news_input )
        enabled = client->_bind( ws_active )
        post    = client->_event( `POST` ) ).

    form->label( text = `Author`
       )->input( value       = client->_bind( author_input )
                 placeholder = `Anonymous` ).

    page->list(
              headertext = `News`
              items      = client->_bind( t_news )
         )->feed_list_item(
              sender   = `{AUTHOR}`
              text     = `{TEXT}`
              showicon = abap_false ).

    DATA(footer) = page->footer( )->overflow_toolbar( ).
    footer->info_label(
        text        = client->_bind( connections )
        colorscheme = `7`
        icon        = `sap-icon://connected` ).

    " Two-way bound to the control's checkActive, so pressing it opens or
    " closes the connection in the browser right away; the roundtrip only
    " brings the counter and the label up to date.
    footer->toggle_button(
        text    = client->_bind( ws_status )
        icon    = `sap-icon://connected`
        pressed = client->_bind( ws_active )
        press   = client->_event( `TOGGLE_CONNECTION` ) ).

    footer->toolbar_spacer( )->button(
        text  = `Clear`
        icon  = `sap-icon://clear-all`
        press = client->_event( `CLEAR` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample shows how to consume APC messages over websocket. Open the app multiple times and post something.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = `button_hint_id` ).

  ENDMETHOD.

ENDCLASS.
