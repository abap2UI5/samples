CLASS z2ui5_cl_demo_app_309 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_309 IMPLEMENTATION.

  METHOD on_event.

    IF mo_client->check_on_event( `CUSTOM_JS_FROM_EB` ).

*        client->follow_up_action( val = `sap.z2ui5.afterBE()` ).
      mo_client->follow_up_action( `alert("afterBE triggered !!");` ).
    ENDIF.
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( `sap.z2ui5.afterBE = () => { alert("afterBE triggered !!"); }` ).

    DATA(lo_page) = lo_view->shell( )->page(
        title          = `Client->FOLLOW_UP_ACTION use cases`
        class          = `sapUiContentPadding`
        navbuttonpress = mo_client->_event_nav_app_leave( )
        shownavbutton  = mo_client->check_app_prev_stack( ) ).
    lo_page = lo_page->vbox( ).
    lo_page->get_parent( )->hbox( class = `sapUiSmallMargin` ).
    lo_page->button( text  = `call custom JS from EB`
                  press = mo_client->_event( `CUSTOM_JS_FROM_EB` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      view_display( ).

    ENDIF.

    on_event( ).
  ENDMETHOD.
ENDCLASS.
