" @keywords reload refresh restart location_reload url
" @summary Navigates the browser to a same-domain URL with the location_reload front-end action, with a scratch input beside it to show what the reload takes with it.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/url_handling
CLASS z2ui5_cl_smp_app_492 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA url TYPE string.
    DATA scratch TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_492 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA s_config TYPE z2ui5_if_client=>ty_s_get-s_config.
      DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp1 TYPE string_table.

    IF client->check_on_navigated( ) IS NOT INITIAL.

      
      s_config = client->get( )-s_config.
      url = s_config-pathname && s_config-search.

      
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
              )->a( n = `title`          v = `abap2UI5 - Browser - Reload the Page`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `The location_reload front-end action navigates the browser to a same-domain URL. The url field is ` &&
                     `prefilled with this page's own address, so the button reloads the app from scratch - type something ` &&
                     `into the scratch field first and watch it get lost. Cross-origin URLs are blocked by the framework.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiSmallMargin` ).

      page->ele( n = `SimpleForm` ns = `form`
          )->a( n = `title`    v = `Reload`
          )->a( n = `editable` b = abap_true
          )->ele( n = `content` ns = `form`
              )->tag( `Label`
                  )->a( n = `text` v = `scratch input`
              )->tag( `Input`
                  )->a( n = `placeholder` v = `type something - it is lost after the reload`
                  )->a( n = `value`       v = client->_bind( scratch )
              )->tag( `Label`
                  )->a( n = `text` v = `url`
              )->tag( `Input`
                  )->a( n = `value` v = client->_bind( url )
              )->tag( `Button`
                  )->a( n = `press` v = client->_event( `RELOAD` )
                  )->a( n = `text`  v = `Reload Page` ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `RELOAD` ) IS NOT INITIAL.

      
      CLEAR temp1.
      INSERT url INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-location_reload
          t_arg = temp1 ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
