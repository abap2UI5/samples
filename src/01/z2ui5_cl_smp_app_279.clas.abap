CLASS z2ui5_cl_smp_app_279 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA text_input TYPE string.
    DATA dirty TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_confirm_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_279 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory(
                   )->shell(
                   )->page(
                      title          = `abap2UI5 - Navigation - Data Loss Protection on Leaving`
                      navbuttonpress = client->_event( `BACK` )
                      shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Unsaved input marks the page dirty via a custom control; navigating back then opens a confirmation ` &&
                   `popup instead of leaving and losing the data.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(box) = page->flex_box( direction  = `Row`
                                alignitems = `Start`
                                class      = `sapUiTinyMargin` ).

    box->input(
      id          = `input`
      value       = client->_bind( text_input )
      submit      = client->_event( `SUBMIT` )
      width       = `40rem`
      placeholder = `Enter data, submit and navigate back to trigger data loss protection` ).

    box->info_label(
      text        = `dirty`
      colorscheme = `8`
      class       = `sapUiSmallMarginBegin sapUiTinyMarginTop`
      visible     = client->_bind( dirty ) ).

    box->button(
      text    = `Reset`
      press   = client->_event( `RESET` )
      class   = `sapUiSmallMarginBegin`
      visible = client->_bind( dirty ) ).

    page->_z2ui5( )->dirty( client->_bind( dirty ) ).

    client->view_display( page->stringify( ) ).

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_focus
        t_arg = VALUE #( ( `input` ) ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `BACK`.

        IF dirty = abap_true.
          popup_confirm_display( ).

        ELSE.
          client->nav_app_leave( ).
        ENDIF.
      WHEN `POPUP_LEAVE`.

        client->popup_destroy( ).
        dirty = VALUE #( ).
        client->nav_app_leave( ).

      WHEN `POPUP_CANCEL`.
        client->popup_destroy( ).
      WHEN `SUBMIT`.
        dirty = xsdbool( text_input IS NOT INITIAL ).
      WHEN `RESET`.

        dirty      = VALUE #( ).
        text_input = VALUE #( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_confirm_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    popup->dialog(
        title = `Warning`
        icon  = `sap-icon://status-critical`
        )->vbox( `sapUiSmallMargin`
            )->text( `Your entries will be lost when you leave this page.`
        )->get_parent(
        )->buttons(
            )->button(
                text  = `Cancel`
                press = client->_event( `POPUP_CANCEL` )
            )->button(
                text  = `Leave Page`
                press = client->_event( `POPUP_LEAVE` )
                type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
