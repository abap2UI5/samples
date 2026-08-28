" @keywords popup dialog change control backend control_by_id update running
" @summary Changes a control INSIDE an open popup from the backend, by ID, without closing and rebuilding the dialog.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popup
CLASS z2ui5_cl_smp_app_141 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_input,
        hint      TYPE string,
        value1    TYPE string,
        value2    TYPE string,
        is_active TYPE abap_bool,
      END OF ty_s_input.
    DATA s_input TYPE ty_s_input.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_141 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `POPUP_OPEN`.
        s_input = VALUE #( hint = `this label was styled from ABAP` value1 = `value1` ).
        popup_display( ).

      WHEN `POPUP_CONFIRM`.
        client->popup_destroy( ).
        client->message_toast_display( |{ s_input-value1 } / { s_input-value2 }| ).

    ENDCASE.

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
            )->a( n = `title`          v = `abap2UI5 - Popups`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    " A style class the app owns. There is no bindable property for "carry
    " this CSS class", so the class itself is declared here and put on the
    " control by a frontend action below - the one case where a control
    " method beats a binding.
    "
    " It has to travel in the `content` ATTRIBUTE of a core:HTML control. An
    " html:style ELEMENT does not survive into the DOM (raw XHTML nodes in an
    " XMLView are deprecated), which leaves the class with no rule behind it:
    " addStyleClass then succeeds and nothing changes visually.
    "
    " The literal CSS braces must be escaped \{ \} in a BACKTICK literal - the
    " XMLView binding parser reads an unescaped { in any attribute value as a
    " binding and crashes, and a |...| template would collapse \{ back to {.
    page->ele( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>.demoHighlight \{ color: #bb0000 !important; font-size: 1.5rem !important; \}</style>` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Changes a control INSIDE an open popup from the backend. The ` &&
                   `label text is an ordinary binding; the style class has ` &&
                   `no bindable equivalent and is applied with follow_up_action( ` &&
                   `control_by_id ) scoped to the popup view. No custom JavaScript ` &&
                   `is involved.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title` v = `Inputs`
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `01`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP_OPEN` )
                )->a( n = `text`  v = `Popup Get Input Values` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    DATA(dialog) = popup->ele( `Dialog`
        )->a( n = `title`         v = `Title`
        )->a( n = `contentWidth`  v = `500px`
        )->a( n = `contentHeight` v = `500px` ).

    dialog->ele( `content`
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = client->_bind( s_input-hint )
                    )->a( n = `id`   v = `lbl1`
                )->tag( `Label`
                    )->a( n = `text` v = `Input1`
                )->tag( `Input`
                    )->a( n = `value` v = client->_bind( s_input-value1 )
                )->tag( `Label`
                    )->a( n = `text` v = `Input2`
                )->tag( `Input`
                    )->a( n = `value` v = client->_bind( s_input-value2 )
                )->tag( `Label`
                    )->a( n = `text` v = `Checkbox`
                )->tag( `CheckBox`
                    )->a( n = `text`     v = `this is a checkbox`
                    )->a( n = `selected` v = client->_bind( s_input-is_active )
                    )->a( n = `enabled`  b = abap_true
            )->end(
        )->end(
    )->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )
                )->a( n = `text`  v = `Cancel`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP_CONFIRM` )
                )->a( n = `text`  v = `Confirm`
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

    " A follow-up action runs after the response has rendered - so after the
    " popup of this same roundtrip is open. `view` scopes the id lookup to the
    " popup, which is what makes `lbl1` resolvable at all.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              view  = client->cs_view-popup
                              t_arg = VALUE #( ( `lbl1` )
                                               ( `addStyleClass` )
                                               ( `demoHighlight` ) ) ).

  ENDMETHOD.

ENDCLASS.
