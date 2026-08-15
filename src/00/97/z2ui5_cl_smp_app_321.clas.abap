CLASS z2ui5_cl_smp_app_321 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_321 IMPLEMENTATION.

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
                      )->a( n = `navButtonPress` v = client->_event( `BACK` )

                      )->tag( `MessageStrip`
                          )->a( n = `text`     v = `set_app_state_active( ) carries the app state id in the URL, so the page can be `
                                                && `bookmarked and the entered data is restored when the bookmark is opened again. `
                                                && `Enter a quantity, press the button and reload the page.`
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
                                  )->a( n = `text`  v = `post with state` ).

      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON_POST`.
        client->message_toast_display( `data updated` ).
        "this is where the magic happens...
        client->set_app_state_active( ).
      WHEN `BACK`.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
