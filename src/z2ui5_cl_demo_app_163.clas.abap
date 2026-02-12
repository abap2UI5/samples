CLASS z2ui5_cl_demo_app_163 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event.
    METHODS view_display.
    METHODS view_action_sheet.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_163 IMPLEMENTATION.

  METHOD on_event.

    IF mo_client->check_on_event( `OPEN_ACTION_SHEET` ).
      view_action_sheet( ).
    ENDIF.
  ENDMETHOD.

  METHOD view_action_sheet.

    DATA(lo_action_sheet_view) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_action_sheet_view->_generic_property( VALUE #( n = `core:require` v = `{ MessageToast: 'sap/m/MessageToast' }` ) ).

    lo_action_sheet_view->action_sheet( placement        = `Botton`
                                     showcancelbutton = abap_true
                                     title            = `Choose Your Action`
      )->button( text  = `Accept`
                 icon  = `sap-icon://accept`
                 press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text  = `Reject`
                 icon  = `sap-icon://decline`
                 press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text  = `Email`
                 icon  = `sap-icon://email`
                 press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text  = `Forward`
                 icon  = `sap-icon://forward`
                 press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text  = `Delete`
                 icon  = `sap-icon://delete`
                 press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->button( text  = `Other`
                 press = `MessageToast.show('selected action is ' + ${$source>/text})` ).

    mo_client->popover_display( xml   = lo_action_sheet_view->stringify( )
                             by_id = `actionSheet` ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view = lo_view->shell( )->page( id = `page_main`
             title                  = `abap2UI5 - Action Sheet`
             navbuttonpress         = mo_client->_event_nav_app_leave( )
             shownavbutton          = mo_client->check_app_prev_stack( ) ).

    DATA(lo_vbox) = lo_view->vbox( ).

    lo_vbox->button( text  = `Open Action Sheet`
                  press = mo_client->_event( `OPEN_ACTION_SHEET` )
                  id    = `actionSheet`
                  class = `sapUiSmallMargin` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      view_display( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.
ENDCLASS.
