CLASS z2ui5_cl_demo_app_180 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES z2ui5_if_app .

    DATA mv_initialized TYPE abap_bool.
    DATA mv_url TYPE string.

    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_180 IMPLEMENTATION.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'CUSTOM_JS_FROM_EB'.

        client->follow_up_action( val = `sap.z2ui5.afterBE()` ).

      WHEN 'CALL_EF'.

        mv_url = `https://www.google.com`.

        client->view_model_update( ).
        client->follow_up_action( val = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( mv_url ) ) ) ).

      WHEN 'BACK'.
        client->nav_app_leave( ).
        RETURN.

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( `sap.z2ui5.afterBE = () => { alert("afterBE triggered !!"); }` ).

    DATA(page) = view->shell( )->page(
        title          = `Client->FOLLOW_UP_ACTION use cases`
        class          = `sapUiContentPadding`
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).
    page = page->vbox( ).
    page->button( text  = `call frontend event from backend event`
                  press = client->_event( `CALL_EF` ) ).
    page->label( text = `MV_URL was set AFTER backend event and model update to:` ).
    page->label( text = client->_bind_edit( mv_url ) ).

    page->get_parent( )->hbox( class = `sapUiSmallMargin` ).
    page->button( text  = `call custom JS from EB`
                  press = client->_event( 'CUSTOM_JS_FROM_EB' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.

      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.
