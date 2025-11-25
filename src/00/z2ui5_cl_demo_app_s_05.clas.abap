CLASS z2ui5_cl_demo_app_s_05 DEFINITION PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_news,
        text   TYPE string,
        author TYPE string,
      END OF t_news,
      tt_News TYPE STANDARD TABLE OF t_news
                   WITH NON-UNIQUE DEFAULT KEY.

    INTERFACES z2ui5_if_app.
    DATA news_input TYPE string.
    DATA author_input TYPE string.
    DATA news_list TYPE tt_News.
    DATA connections TYPE int8.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.
    METHODS z2ui5_display_popover.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_s_05 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF me->z2ui5_if_app~check_initialized = abap_false.
      connections = z2ui5_cl_demo_app_s_05_ws=>get_active_connections( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
      client->view_model_update( ).
      RETURN.
    ENDIF.

    z2ui5_on_render( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.
    DATA: news TYPE t_news.

    CASE client->get( )-event.
      WHEN `CLEAR`.

        CLEAR: news_list.

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'CLICK_HINT_ICON'.

        z2ui5_display_popover( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render.

    SELECT
      SINGLE FROM icfservloc
      FIELDS icfactive
      WHERE icf_name = 'Z2UI5_SAMPLE'
      INTO @DATA(icfactive).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
                    )->page(
                       title          = 'abap2UI5 - Sample: News Feed over WebSocket'
                       navbuttonpress = client->_event( 'BACK' )
                       shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( 'CLICK_HINT_ICON' ) ).

    IF icfactive = abap_false.
      page->message_strip(
          text    = `ICF Service '/sap/bc/apc/sap/z2ui5_sample' is not active. WebSocket communication will not work. Please activate the ICF Service in transaction SICF.`
          type    = `Warning`
          visible = abap_true ).
    ENDIF.

    DATA(form) = page->simple_form( editable = abap_true
                                    title    = `Publish news`
                                    class    = `sapUiTinyMarginBottom`
                    )->content( `form` ).

    form->feed_input(
        value = client->_bind_edit( news_input )
        post  = client->_event_client(
                  val   = `Z2UI5`
                  t_arg = VALUE #( ( `feedInputPost` ) )
                ) ).

    form->label( text = `Author`
       )->input( value       = client->_bind_edit( author_input )
                 placeholder = `Anonymous` ).

    page->list(
              headertext = `News`
              items      = client->_bind_edit( news_list )
         )->feed_list_item(
              sender     = `{AUTHOR}`
              text       = `{TEXT}`
              showicon   = abap_false ).

    DATA(footer) = page->footer( )->overflow_toolbar( ).
    footer->info_label(
        text          = client->_bind_edit( connections )
        colorscheme   = `7`
        icon          = `sap-icon://connected` ).

    footer->toolbar_spacer( )->button(
        text  = `Clear`
        icon  = `sap-icon://clear-all`
        press = client->_event( `CLEAR` ) ).

    IF me->z2ui5_if_app~check_initialized = abap_false.
      view->_generic( name = `script`
                      ns   = `html`
         )->_cc_plain_xml(
            `(()=>{ ` &&
            `  const ws_url = (window.location.origin + '/sap/bc/apc/sap/z2ui5_sample').replace('http','ws');` &&
            `  try { ` &&
            `    ws = new WebSocket(ws_url);` &&
            `  } catch (err) {` &&
            `    alert(err);` &&
            `  }` &&
            `  ws.onopen = ()=>{};` &&
            `  ws.onmessage = (msg)=>{` &&
            `    const model = z2ui5.oController.oView.getModel();` &&
            `    const data = model.getData();` &&
            `    if (msg.data === '` && z2ui5_cl_demo_app_s_05_ws=>c_msg-__new_connection__ && `') {` &&
            `      data.XX.CONNECTIONS += 1;` &&
            `    } else if (msg.data === '` && z2ui5_cl_demo_app_s_05_ws=>c_msg-__closed__ && `') {` &&
            `      data.XX.CONNECTIONS -= 1;` &&
            `    } else {` &&
            `      data.XX.NEWS_LIST.push(JSON.parse(msg.data));` &&
            `    }` &&
            `    model.setData(data);` &&
            `  };` &&
            `  ws.onclose = (msg)=>{};` &&
            `})()` ).

      view->_generic( name = `script`
                      ns   = `html`
          )->_cc_plain_xml(
             `z2ui5.feedInputPost = () => { ` &&
             `  const model = z2ui5.oView.getModel();` &&
             `  const data = model.getData();` &&
             `  ws.send(JSON.stringify({ ` &&
             `    TEXT : data.XX.NEWS_INPUT,` &&
             `    AUTHOR : data.XX.AUTHOR_INPUT ` &&
             `  }));` &&
             `  setTimeout( () => { ` &&
             `    data.XX.NEWS_INPUT = "";` &&
             `    model.setData(data);` &&
             `  }, 10 ); ` &&
             `}` ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample show how to consume APC-Messages over websocket. Open the app mutliple times and post something.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = `button_hint_id` ).

  ENDMETHOD.

ENDCLASS.
