" @keywords url window open_new_tab link target
CLASS z2ui5_cl_smp_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_073 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Browser - Open a URL in a New Tab`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Press the button to open the app's own URL in a new browser tab: the backend builds the ` &&
                   `URL and the open_new_tab front-end action launches it.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Form Title`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( val = `BUTTON_OPEN_NEW_TAB` )
                )->a( n = `text`  v = `open new tab` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

    CASE client->get_event( ).

      WHEN `BUTTON_OPEN_NEW_TAB`.

        DATA(ls_config) = client->get( )-s_config.
        DATA(result) = z2ui5_cl_smp_context=>app_get_url( classname = `z2ui5_cl_smp_app_073`
                                                          origin    = ls_config-origin
                                                          pathname  = ls_config-pathname
                                                          search    = ls_config-search
                                                          hash      = ls_config-hash ).

        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-open_new_tab
            t_arg = VALUE #(
                ( result )
                ) ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
