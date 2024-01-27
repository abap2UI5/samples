class Z2UI5_CL_DEMO_APP_163 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA mv_check_initialized TYPE abap_bool.
    METHODS on_event.
    METHODS view_display.
    METHODS view_action_sheet.

  PRIVATE SECTION.
*    DATA mt_range TYPE z2ui5_cl_util_func=>ty_t_sql_multi.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_163 IMPLEMENTATION.


  METHOD ON_EVENT.

    CASE client->get( )-event.

      WHEN 'OPEN_ACTION_SHEET'.
        view_action_sheet( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_action_sheet.

    DATA(action_sheet_view) = z2ui5_cl_xml_view=>factory_popup( ).

    action_sheet_view->_generic_property( VALUE #( n = `core:require` v = `{ MessageToast: 'sap/m/MessageToast' }` ) ).

    action_sheet_view->action_sheet( placement = `Botton` showcancelbutton = abap_true title = `Choose Your Action`
      )->button( text = `Accept`  icon = `sap-icon://accept`    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text = `Reject`  icon = `sap-icon://decline`   press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text = `Email`   icon = `sap-icon://email`     press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text = `Forward` icon = `sap-icon://forward`   press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text = `Delete`  icon = `sap-icon://delete`    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text = `Other`                                 press = `MessageToast.show('selected action is ' + ${$source>/text})`
    ).

   client->popover_display( xml = action_sheet_view->stringify( ) by_id = `actionSheet` ).

  ENDMETHOD.


  METHOD VIEW_DISPLAY.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view = view->shell( )->page( id = `page_main`
             title          = 'abap2UI5 - Action Sheet'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         )->header_content(
             )->link(
                 text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    DATA(vbox) = view->vbox( ).

    vbox->button( text = 'Open Action Sheet' press = client->_event( 'OPEN_ACTION_SHEET' ) id = `actionSheet` class = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.
      view_display( ).
      RETURN.
    ENDIF.

   on_event( ).

  ENDMETHOD.
ENDCLASS.
