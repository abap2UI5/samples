" @keywords exception dump error handling debugtool restart retry
" @summary What an uncaught exception looks like from the user's side - the error popup, and the way back into the app.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/exception
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
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA lv_zero TYPE i.
        DATA lv_result TYPE i.

    CASE client->get_event( ).

      WHEN `RAISE_EXCEPTION`.
        " the division dumps - nothing ever reads the result, and that is
        " the point of the sample
        
        lv_zero = 0.
        
        lv_result = 1 / lv_zero ##NEEDED.
      WHEN `ASSERT`.
        ASSERT 1 = 0.

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Navigation - Uncaught Error and Error Popup`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Trigger an unexpected error. The client shows a popup "An unexpected error ` &&
                   `occurred" with two buttons: Details jumps into the DebugTool's Error tab (full ` &&
                   `error text plus Retry/Refresh/Logout), Restart reloads the app. Open the ` &&
                   `DebugTool any time with Ctrl+F12.`
        )->a( n = `type`     v = `Warning`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `RAISE_EXCEPTION` )
            )->a( n = `text`  v = `Raise an exception`
            )->a( n = `icon`  v = `sap-icon://error`
            )->a( n = `type`  v = `Reject`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `ASSERT` )
            )->a( n = `text`  v = `Trigger an Assert Error / Dump`
            )->a( n = `icon`  v = `sap-icon://alert`
            )->a( n = `class` v = `sapUiTinyMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
