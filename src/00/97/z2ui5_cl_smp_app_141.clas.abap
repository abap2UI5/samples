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
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `POPUP_OPEN`.
        s_input = VALUE #( hint   = `this label was styled from ABAP`
                           value1 = `value1` ).
        popup_display( ).

      WHEN `POPUP_CONFIRM`.
        client->popup_destroy( ).
        client->message_toast_display( |{ s_input-value1 } / { s_input-value2 }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title          = `abap2UI5 - Popups`
                                       navbuttonpress = client->_event_nav_app_leave( )
                                       shownavbutton  = client->check_app_prev_stack( ) ).

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
    page->_generic( name   = `HTML`
                    ns     = `core`
                    t_prop = VALUE #( ( n = `content`
                                        v = `<style>.demoHighlight \{ color: #bb0000 !important; font-size: 1.5rem !important; \}</style>` ) ) ).

    page->message_strip(
        text     = `Changes a control INSIDE an open popup from the backend. The ` &&
                   `label text is an ordinary two-way binding; the style class has ` &&
                   `no bindable equivalent and is applied with follow_up_action( ` &&
                   `control_by_id ) scoped to the popup view. No custom JavaScript ` &&
                   `is involved.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form( `Inputs` )->content( `form`
        )->label( `01`
        )->button( text  = `Popup Get Input Values`
                   press = client->_event( `POPUP_OPEN` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(dialog) = popup->dialog( title         = `Title`
                                  contentheight = `500px`
                                  contentwidth  = `500px` ).

    dialog->content(
        )->simple_form( editable = abap_true
            )->content( `form`
                )->label( id   = `lbl1`
                          text = client->_bind( s_input-hint )
                )->label( `Input1`
                )->input( client->_bind( s_input-value1 )
                )->label( `Input2`
                )->input( client->_bind( s_input-value2 )
                )->label( `Checkbox`
                )->checkbox( selected = client->_bind( s_input-is_active )
                             text     = `this is a checkbox`
                             enabled  = abap_true )->get_parent( )->get_parent( )->get_parent(
        " the `buttons` aggregation, not `footer`: sap.m.Dialog only got a
        " public footer around UI5 1.110, and an aggregation tag the parent
        " does not have is resolved as a CONTROL CLASS - it 404s and takes the
        " whole view with it (abap2UI5 AGENTS rule 15). `buttons` exists since
        " 1.21.1 and right-aligns them the same way.
        )->buttons(
            )->button( text  = `Cancel`
                       press = client->_event_client( client->cs_event-popup_close )
            )->button( text  = `Confirm`
                       type  = `Emphasized`
                       press = client->_event( `POPUP_CONFIRM` ) ).

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
