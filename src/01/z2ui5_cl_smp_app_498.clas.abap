" @keywords app state url bookmark share clipboard copy link restore deep link reload set_app_state_active clipboard_app_state sap-iapp-state sap-xapp-state
" @summary The Fiori app-state pattern: the URL carries the state id, so a bookmark, a reload or a shared link restores the entered data.
" @docs https://abap2ui5.github.io/docs/cookbook/expert_more/app_state_share
"! The abap2UI5 spelling of the Fiori app state (sap-iapp-state /
"! sap-xapp-state): the app state IS the draft the framework persists anyway,
"! so set_app_state_active( ) only has to carry its id in the URL
"! ('#/z2ui5-xapp-state=&lt;id&gt;'). From then on every roundtrip advances the id,
"! so the address bar always names the CURRENT state:
"!
"!  - reload or bookmark the page - the entered data comes back
"!  - press SHARE - the clipboard_app_state action copies a link to exactly
"!    this state, and a colleague who opens it starts where you are
"!
"! The state lives until the draft expires; an expired link starts the app
"! fresh and says so. Consolidates the former z2ui5_cl_smp_app_321 (bookmark)
"! and z2ui5_cl_smp_app_323 (share) into one sample.
CLASS z2ui5_cl_smp_app_498 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA quantity TYPE string.
    DATA notes    TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_498 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      " keep the current app state's id in the URL from the first render on -
      " the framework re-asserts it on every response, so the address bar
      " tracks every later roundtrip too. check_on_init implies
      " check_on_navigated, so the first display happens right below
      client->set_app_state_active( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


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
            )->a( n = `title`          v = `abap2UI5 - App State, Bookmark and Share`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `set_app_state_active( ) keeps the id of the CURRENT app state in the URL ` &&
                   `(#/z2ui5-xapp-state=...). Type something, press post - and then reload the page, ` &&
                   `bookmark it, or share it: the state comes back.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
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

    CASE client->get_event( ).

      WHEN `POST`.
        " any roundtrip advances the draft - and with it the id in the URL
        client->message_toast_display( `data updated - the URL now names this state` ).

      WHEN `SHARE`.
        client->follow_up_action( z2ui5_if_client=>cs_event-clipboard_app_state ).
        client->message_toast_display( `link copied - open it anywhere` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
