CLASS z2ui5_cl_smp_app_464 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_464 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `RAISE_EXCEPTION`.
        RAISE EXCEPTION TYPE z2ui5_cx_smp_error
          EXPORTING
            val = `Intentional error to demonstrate the error popup`.

      WHEN `DIVIDE_BY_ZERO`.
        DATA(lv_zero) = 0.
        DATA(lv_result) = 1 / lv_zero.

      WHEN `ASSERT`.
        ASSERT 1 = 0.

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Navigation - Uncaught Error and Error Popup`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Trigger an unexpected error. The client shows a popup "An unexpected error ` &&
                   `occurred" with two buttons: Details jumps into the DebugTool's Error tab (full ` &&
                   `error text plus Retry/Refresh/Logout), Restart reloads the app. Open the ` &&
                   `DebugTool any time with Ctrl+F12.`
        type     = `Warning`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `Raise an exception`
                   icon  = `sap-icon://error`
                   type  = `Reject`
                   press = client->_event( `RAISE_EXCEPTION` )
        )->button( text  = `Trigger a runtime dump (divide by zero)`
                   icon  = `sap-icon://alert`
                   press = client->_event( `DIVIDE_BY_ZERO` )
                   class = `sapUiTinyMarginTop`
        )->button( text  = `Trigger an Assert`
                   icon  = `sap-icon://alert`
                   press = client->_event( `ASSERT` )
                   class = `sapUiTinyMarginTop`
                   ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
