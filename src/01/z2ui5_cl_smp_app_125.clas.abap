" @keywords document.title tab caption headline set_title
" @summary Sets the browser tab title from the app, so a bookmarked or duplicated window says which app it holds.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/title
CLASS z2ui5_cl_smp_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA title TYPE string VALUE `my title`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_125 IMPLEMENTATION.


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
              )->a( n = `title`          v = `abap2UI5 - Browser - Set the Tab Title`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `Enter a title and press the button to run the set_title front-end action, which updates ` &&
                     `the browser tab title (document.title) without reloading the page.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiSmallMargin` ).

      page->ele( n = `SimpleForm` ns = `form`
          )->a( n = `title`    v = `Form Title`
          )->a( n = `editable` b = abap_true
          )->ele( n = `content` ns = `form`
              )->tag( `Label`
                  )->a( n = `text` v = `title`
              )->tag( `Input`
                  )->a( n = `value` v = client->_bind( title )
              )->tag( `Button`
                  )->a( n = `press` v = client->_event( `SET_TITLE` )
                  )->a( n = `text`  v = `Set Title` ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `SET_TITLE` ) IS NOT INITIAL.

      
      CLEAR temp1.
      INSERT title INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_title
          t_arg = temp1 ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
