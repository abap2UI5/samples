" @keywords app state url bookmark share clipboard copy link restore deep link reload app_state_set_active app_state_get_href sap-iapp-state sap-xapp-state
" @summary The Fiori app-state pattern: the URL carries the state id, so a bookmark, a reload or a shared link restores the entered data.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/navigation/app_state
"! The abap2UI5 spelling of the Fiori app state (sap-iapp-state /
"! sap-xapp-state): the app state IS the draft the framework persists anyway,
"! so app_state_set_active( ) only has to carry its id in the URL
"! ('#/z2ui5-xapp-state=&lt;id&gt;'). From then on every roundtrip advances the id,
"! so the address bar always names the CURRENT state:
"!
"!  - reload or bookmark the page - the entered data comes back
"!  - press SHARE - app_state_get_href( ) hands the BACKEND the absolute
"!    link to exactly this state (FLP-safe: the shell hash survives in it),
"!    so the app shows it, copies it with the plain clipboard_copy action,
"!    and could just as well mail it or render it as a QR code
"!
"! The state lives until the draft expires; an expired link starts the app
"! fresh and says so. Consolidates the former z2ui5_cl_smp_app_321 (bookmark)
"! and z2ui5_cl_smp_app_323 (share) into one sample.
CLASS z2ui5_cl_smp_app_498 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA quantity   TYPE string.
    DATA notes      TYPE string.
    DATA share_link TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_498 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      " keep the current app state's id in the URL from the first render on -
      " the framework re-asserts it on every response, so the address bar
      " tracks every later roundtrip too. check_on_init implies
      " check_on_navigated, so the first display happens right below
      client->app_state_set_active( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
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
            )->a( n = `title`          v = `abap2UI5 - App State, Bookmark and Share`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `app_state_set_active( ) keeps the id of the CURRENT app state in the URL ` &&
                   `(#/z2ui5-xapp-state=...). Type something, press post - and then reload the page, ` &&
                   `bookmark it, or share it: the state comes back.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `The state a link can carry`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `quantity` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( quantity ) ).

    form->tag( `Label`
        )->a( n = `text` v = `notes` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( notes ) ).

    form->tag( `Button`
        )->a( n = `press` v = client->_event( `POST` )
        )->a( n = `text`  v = `post`
        )->a( n = `type`  v = `Emphasized` ).
    form->tag( `Button`
        )->a( n = `press` v = client->_event( `SHARE` )
        )->a( n = `text`  v = `share - copy the link`
        )->a( n = `icon`  v = `sap-icon://chain-link` ).

    " the backend OWNS the link string (app_state_get_href), so the app can
    " show it - something the old fire-and-forget clipboard action never could
    form->tag( `Label`
        )->a( n = `text` v = `the link the share button copies` ).
    form->tag( `Input`
        )->a( n = `value`    v = client->_bind( share_link )
        )->a( n = `editable` b = abap_false ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Share copies a link to exactly this state into the clipboard - the Fiori ` &&
                   `sap-xapp-state idea with the draft as the state container. The link lives until ` &&
                   `the draft expires; after that it starts the app fresh.`
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.

    CASE client->get_event( ).

      WHEN `POST`.
        " any roundtrip advances the draft - and with it the id in the URL
        client->message_toast_display( `data updated - the URL now names this state` ).

      WHEN `SHARE`.
        " the link to exactly THIS roundtrip's state, composed backend-side -
        " origin, path and (inside the FLP) the shell hash all survive in it.
        " Copying is then just the generic clipboard action; the same string
        " could go into a mail or a QR code
        share_link = client->app_state_get_href( ).
        
        CLEAR temp1.
        INSERT share_link INTO TABLE temp1.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-clipboard_copy
                                  t_arg = temp1 ).
        client->message_toast_display( `link copied - open it anywhere` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
