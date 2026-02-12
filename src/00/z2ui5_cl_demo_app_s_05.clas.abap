CLASS z2ui5_cl_demo_app_s_05 DEFINITION PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_news,
        text   TYPE string,
        author TYPE string,
      END OF t_news,
      tt_news TYPE STANDARD TABLE OF t_news
                   WITH NON-UNIQUE DEFAULT KEY.

    INTERFACES z2ui5_if_app.
    DATA mv_news_input TYPE string.
    DATA mv_author_input TYPE string.
    DATA mt_news_list TYPE tt_news.
    DATA mv_connections TYPE int8.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS on_render.
    METHODS display_popover.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_s_05 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF me->z2ui5_if_app~check_initialized = abap_false.
      mv_connections = z2ui5_cl_demo_app_s_05_ws=>get_active_connections( ).
    ENDIF.

    IF mo_client->get( )-event IS NOT INITIAL.
      on_event( ).
      mo_client->view_model_update( ).
      RETURN.
    ENDIF.

    on_render( ).
  ENDMETHOD.

  METHOD on_event.

    DATA: news TYPE t_news.

    CASE mo_client->get( )-event.
      WHEN `CLEAR`.

        CLEAR: mt_news_list.
      WHEN `CLICK_HINT_ICON`.

        display_popover( ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_render.

    SELECT
      SINGLE FROM icfservloc
      FIELDS icfactive
      WHERE icf_name = `Z2UI5_SAMPLE`
      INTO @DATA(icfactive).

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
                    )->page(
                       title          = `abap2UI5 - Sample: News Feed over WebSocket`
                       navbuttonpress = mo_client->_event_nav_app_leave( )
                       shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    IF icfactive = abap_false.
      lo_page->message_strip(
          text    = `ICF Service '/sap/bc/apc/sap/z2ui5_sample' is not active. WebSocket communication will not work. Please activate the ICF Service in transaction SICF.`
          type    = `Warning`
          visible = abap_true ).
    ENDIF.

    DATA(lo_form) = lo_page->simple_form( editable = abap_true
                                    title    = `Publish news`
                                    class    = `sapUiTinyMarginBottom`
                    )->content( `form` ).

    lo_form->feed_input(
        value = mo_client->_bind_edit( mv_news_input )
        post  = mo_client->_event_client(
                  val   = `Z2UI5`
                  t_arg = VALUE #( ( `feedInputPost` ) )
                ) ).

    lo_form->label( text = `Author`
       )->input( value       = mo_client->_bind_edit( mv_author_input )
                 placeholder = `Anonymous` ).

    lo_page->list(
              headertext = `News`
              items      = mo_client->_bind_edit( mt_news_list )
         )->feed_list_item(
              sender   = `{AUTHOR}`
              text     = `{TEXT}`
              showicon = abap_false ).

    DATA(lo_footer) = lo_page->footer( )->overflow_toolbar( ).
    lo_footer->info_label(
        text        = mo_client->_bind_edit( mv_connections )
        colorscheme = `7`
        icon        = `sap-icon://connected` ).

    lo_footer->toolbar_spacer( )->button(
        text  = `Clear`
        icon  = `sap-icon://clear-all`
        press = mo_client->_event( `CLEAR` ) ).

    IF me->z2ui5_if_app~check_initialized = abap_false.
      lo_view->_generic( name = `script`
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

      lo_view->_generic( name = `script`
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

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample show how to consume APC-Messages over websocket. Open the app mutliple times and post something.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = `button_hint_id` ).
  ENDMETHOD.
ENDCLASS.
