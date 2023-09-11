class Z2UI5_CL_DEMO_APP_105 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data:
    BEGIN OF ms_screen,
            partner TYPE string,
          END OF ms_screen .
  data MV_CHECK_POPUP type ABAP_BOOL .
  data MV_CHECK_INITIALIZED type ABAP_BOOL .
protected section.

  methods Z2UI5_ON_INIT .
  methods Z2UI5_ON_EVENT
    importing
      !IR_CLIENT type ref to Z2UI5_IF_CLIENT .
  methods Z2UI5_ON_RENDER
    importing
      !IR_CLIENT type ref to Z2UI5_IF_CLIENT .
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_105 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.
      z2ui5_on_render( ir_client = client ).
    ENDIF.

    IF mv_check_popup = abap_true.
      mv_check_popup = abap_false.
      DATA(app) = CAST z2ui5_cl_demo_app_104( client->get_app( client->get( )-s_draft-id_prev_app )  ).
      client->message_toast_display( app->mv_shlp_result ).
      me->ms_screen-partner = app->mv_shlp_result.
      "client->view_model_update( ).
      z2ui5_on_render( ir_client = client ).
    ENDIF.

    z2ui5_on_event( ir_client = client ).


  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE ir_client->get( )-event.
      WHEN `FILTER_VALUE_HELP`.
        mv_check_popup = abap_true.
        ir_client->nav_app_call( z2ui5_cl_demo_app_104=>factory(
          iv_popup_title = 'THIS is the DDIC SHLP title'
          iv_shlp_id = 'F4SHLP_ACMDTUI_DDLSOURCE' ) ).

      WHEN 'BACK'.
        ir_client->nav_app_leave( ir_client->get_app( ir_client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_ON_INIT.

  ENDMETHOD.


  METHOD z2ui5_on_render.
    DATA(view) = z2ui5_cl_xml_view=>factory( ir_client ).

    DATA(page) = view->page( id = `page_main`
             title          = 'abap2UI5 - Run generic DDIC searchelp'
             navbuttonpress = ir_client->_event( 'BACK' )
             shownavbutton  = abap_true ).


    DATA(grid) = page->grid( 'L7 M12 S12' )->content( 'layout'
        )->simple_form( 'run DDIC searchhelp in new app' )->content( 'form'
            )->label( `Partner`
            )->input(  value = ir_client->_bind_edit( ms_screen-partner )
                  showvaluehelp                = abap_true
                  valuehelprequest             = ir_client->_event( 'FILTER_VALUE_HELP' ) ).

    IR_client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
