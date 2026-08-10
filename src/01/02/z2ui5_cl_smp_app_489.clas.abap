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
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS on_event_post.
    METHODS on_event_received.
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

    connections = z2ui5_cl_smp_app_489_ws=>get_active_connections( ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `POST`.
        on_event_post( ).
      WHEN `WS_RECEIVED`.
        on_event_received( ).
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
                   `and publishing goes back into the AMC channel from ABAP.`
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
    " message into WS_MESSAGE and raises WS_RECEIVED so the app can process it.
    page->_z2ui5( )->websocket(
        path     = `/sap/bc/apc/sap/z2ui5_apc_smp_2`
        value    = client->_bind( ws_message )
        received = client->_event( `WS_RECEIVED` ) ).

    DATA(form) = page->simple_form( editable = abap_true
                                    title    = `Publish news`
                                    class    = `sapUiTinyMarginBottom`
                    )->content( `form` ).

    form->feed_input(
        value = client->_bind( news_input )
        post  = client->_event( `POST` ) ).

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
