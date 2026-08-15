CLASS z2ui5_cl_smp_app_322 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_322 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_navigated( ).
      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`
              )->a( n = `xmlns:form`   v = `sap.ui.layout.form`

              )->ele( `Shell`
                  )->ele( `Page`
                      )->a( n = `title`          v = `abap2UI5 - Navigation with app state`
                      )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                      )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )

                      )->tag( `MessageStrip`
                          )->a( n = `text`     v = `set_push_state( ) pushes an app-owned suffix onto the browser URL, so the app can `
                                                && `write its own hash (here /head/pos/<draft id>) and the browser back button `
                                                && `navigates through those entries.`
                          )->a( n = `type`     v = `Information`
                          )->a( n = `showIcon` b = abap_true
                          )->a( n = `class`    v = `sapUiSmallMargin`

                      )->ele( n = `SimpleForm` ns = `form`
                          )->a( n = `title`    v = `Form Title`
                          )->a( n = `editable` b = abap_true

                          )->ele( n = `content` ns = `form`
                              )->tag( `Title`
                                  )->a( n = `text`  v = `Input`
                              )->tag( `Label`
                                  )->a( n = `text`  v = `quantity`
                              )->tag( `Input`
                                  )->a( n = `value` v = client->_bind( mv_quantity )
                              )->tag( `Button`
                                  )->a( n = `press` v = client->_event( `BUTTON_POST` )
                                  )->a( n = `text`  v = `post`

                              )->tag( `Button`
                                  )->a( n = `press` v = client->_event( `BUTTON_BACK` )
                                  )->a( n = `text`  v = `back` ).

      client->view_display( view->stringify( ) ).

      IF client->check_app_prev_stack( ).
        client->set_push_state( `/head/pos/` && client->get( )-s_draft-id ).
      ENDIF.
      RETURN.
    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON_POST`.
        client->set_push_state( `/head/pos/` && client->get( )-s_draft-id ).
        client->message_toast_display( `data updated` ).

      WHEN `BUTTON_BACK`.
        " step back through the entries set_push_state( ) pushed - the same
        " thing the browser back button does. follow_up_action( ) runs a raw
        " JavaScript expression when what it gets is not a framework event
        " name, which is how a browser capability without its own event is
        " reached
        " abap2ui5lint-disable-next-line raw-javascript-to-frontend -- the raw-JS escape hatch is what this sample demonstrates: a browser capability with no framework event of its own
        client->follow_up_action( |history.back()| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
