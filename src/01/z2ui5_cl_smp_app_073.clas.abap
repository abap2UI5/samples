" @keywords url window open_new_tab link target
" @summary Opens a URL in a new browser tab from an event, leaving the running app where it is.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/url_handling
CLASS z2ui5_cl_smp_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS url_own_get
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_073 IMPLEMENTATION.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
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
      DATA temp1 TYPE string_table.

    me->client = client.

    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

    IF client->get_event( ) = `BUTTON_OPEN_NEW_TAB`.

      
      CLEAR temp1.
      INSERT url_own_get( ) INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-open_new_tab
          t_arg = temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD url_own_get.

    DATA lt_param TYPE string_table.

    " s_config carries the browser's own location: origin, path and query
    DATA ls_config TYPE z2ui5_if_client=>ty_s_get-s_config.
    DATA lv_query TYPE string.
    DATA lv_param LIKE LINE OF lt_param.
    ls_config = client->get( )-s_config.

    " keep every query parameter the current URL already has - sap-client and
    " sap-language among them - and swap app_start for this class, so the new
    " tab opens this app instead of whatever the current URL points to. The
    " hash is left out on purpose: it holds THIS app's state, and the backend
    " would prefer it over app_start.
    SPLIT shift_left( val = ls_config-search sub = `?` ) AT `&` INTO TABLE lt_param.

    
    lv_query = `app_start=z2ui5_cl_smp_app_073`.
    
    LOOP AT lt_param INTO lv_param.
      IF lv_param IS INITIAL
      OR to_lower( substring_before( val = lv_param sub = `=` ) ) = `app_start`.
        CONTINUE.
      ENDIF.
      lv_query = |{ lv_query }&{ lv_param }|.
    ENDLOOP.

    result = |{ ls_config-origin }{ ls_config-pathname }?{ lv_query }|.

  ENDMETHOD.

ENDCLASS.
