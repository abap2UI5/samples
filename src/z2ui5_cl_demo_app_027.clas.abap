CLASS z2ui5_cl_demo_app_027 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_product  TYPE string.
    DATA mv_quantity TYPE i.
    DATA mv_input2 TYPE string.
    DATA mv_input31 TYPE i.
    DATA mv_input32 TYPE i.
    DATA mv_input41 TYPE string.
    DATA mv_input51 TYPE string.
    DATA mv_input52 TYPE string.

  PROTECTED SECTION.

    DATA mo_client            TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        s_get             TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS on_init.
    METHODS on_event.
    METHODS on_render.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_027 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client     = mo_client.
    app-s_get      = mo_client->get( ).
    app-view_popup = ``.

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      on_init( ).
    ENDIF.

    IF app-s_get-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

    on_render( ).

    CLEAR app-s_get.
  ENDMETHOD.

  METHOD on_event.

    CASE app-s_get-event.
      WHEN `BACK`.
        mo_client->nav_app_leave( mo_client->get_app( app-s_get-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    mv_product  = `tomato`.
    mv_quantity = `500`.
    app-view_main = `VIEW_MAIN`.
    mv_input41 = `faasdfdfsaVIp`.
  ENDMETHOD.

  METHOD on_render.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lv_xml) = lo_view->shell(
      )->page(
              title          = `abap2UI5 - Binding Syntax`
              navbuttonpress = mo_client->_event( `BACK` )
              shownavbutton  = mo_client->check_app_prev_stack( )
          )->simple_form( title    = `Binding Syntax`
                          editable = abap_true
              )->content( `form`
                )->title( `Expression Binding`
      )->label( `Documentation`
                )->link(
                  text = `Expression Binding`
                  href = `https://sapui5.hana.ondemand.com/sdk/#/topic/daf6852a04b44d118963968a1239d2c0`
                )->label( `input in uppercase`
                )->input( mo_client->_bind( mv_input2 )
                )->input(
                    value   = `{= $` && mo_client->_bind( mv_input2 ) && `.toUpperCase() }`
                    enabled = abap_false
      )->label( `max value of the first two inputs`
                )->input( `{ type : "sap.ui.model.type.Integer",` &&
                          `  path:"` && mo_client->_bind( val  = mv_input31
                                                       path = abap_true ) && `" }`
                )->input( `{ type : "sap.ui.model.type.Integer",` && |\n| &&
                          `  path:"` && mo_client->_bind( val  = mv_input32
                                                       path = abap_true ) && `" }`
                )->input(
                    value   = `{= Math.max($` && mo_client->_bind( mv_input31 ) &&`, $` && mo_client->_bind( mv_input32 ) && `) }`
                    enabled = abap_false
      )->label( `only enabled when the quantity equals 500`
                )->input( `{ type : "sap.ui.model.type.Integer",` &&
                          `  path:"` && mo_client->_bind( val  = mv_quantity
                                                       path = abap_true ) && `"  }`
                )->input(
                    value   = mv_product
                    enabled = `{= 500===$` && mo_client->_bind( mv_quantity ) && ` }`
      )->label( `RegExp Set to enabled if the input contains VIP, ignoring the case.`
                )->input( mo_client->_bind( mv_input41 )
                )->button(
                    text    = `VIP`
                    enabled = `{= RegExp('vip', 'i').test($` && mo_client->_bind( mv_input41 ) && `) }`
      )->label( `concatenate both inputs`
                )->input( mo_client->_bind( mv_input51 )
                )->input( mo_client->_bind( mv_input52 )
                )->input(
                    value   = `{ parts: [` && |\n| &&
                              `                "` && mo_client->_bind( val = mv_input51 path = abap_true ) && `",` && |\n| &&
                              `                "` && mo_client->_bind( val = mv_input52 path = abap_true ) && `"` && |\n| &&
                              `               ]  }`
                    enabled = abap_false
      )->stringify( ).

    mo_client->view_display( lv_xml ).
  ENDMETHOD.
ENDCLASS.
