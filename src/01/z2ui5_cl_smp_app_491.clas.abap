" @keywords favicon icon tab image data uri
" @summary Sets the browser tab's favicon at runtime, from an image the backend hands over as a data URI.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/title
CLASS z2ui5_cl_smp_app_491 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA favicon TYPE string VALUE `data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'><circle cx='8' cy='8' r='7' fill='%23f60'/></svg>`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_491 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp1 TYPE string_table.

    IF client->check_on_navigated( ) IS NOT INITIAL.

      
      view = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`
              )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
      
      page = view->ele( `Shell`
          )->ele( `Page`
              )->a( n = `title`          v = `abap2UI5 - Browser - Set the Tab Favicon`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `Enter an image URL (or data URI) and press the button to run the set_favicon front-end action, ` &&
                     `which updates the browser tab icon (the link rel="icon" tag) without reloading the page.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiSmallMargin` ).

      page->ele( n = `SimpleForm` ns = `form`
          )->a( n = `title`    v = `Favicon`
          )->a( n = `editable` b = abap_true
          )->ele( n = `content` ns = `form`
              )->tag( `Label`
                  )->a( n = `text` v = `favicon url`
              )->tag( `Input`
                  )->a( n = `value` v = client->_bind( favicon )
              )->tag( `Button`
                  )->a( n = `press` v = client->_event( `SET_FAVICON` )
                  )->a( n = `text`  v = `Set Favicon` ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `SET_FAVICON` ) IS NOT INITIAL.

      
      CLEAR temp1.
      INSERT favicon INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_favicon
          t_arg = temp1 ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
