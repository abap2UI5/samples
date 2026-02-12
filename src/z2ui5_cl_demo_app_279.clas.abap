CLASS z2ui5_cl_demo_app_279 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_text_input TYPE string .
    DATA mv_dirty TYPE abap_bool.

  PRIVATE SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_view.
    METHODS on_event.
    METHODS security_check_popup.
    METHODS callback.

ENDCLASS.

CLASS z2ui5_cl_demo_app_279 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
                   )->page(
                      title          = `abap2UI5 - data loss protection`
                      navbuttonpress = mo_client->_event_nav_app_leave( )
                      shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_box) = lo_page->flex_box( direction  = `Row`
                                alignitems = `Start`
                                class      = `sapUiTinyMargin` ).

    lo_box->input(
      id          = `input`
      value       = mo_client->_bind_edit( mv_text_input )
      submit      = mo_client->_event( `SUBMIT` )
      width       = `40rem`
      placeholder = `Enter data, submit and navigate back to trigger data loss protection` ).

    lo_box->info_label(
      text        = `dirty`
      colorscheme = `8`
      icon        = `sap-icon://message-success`
      class       = `sapUiSmallMarginBegin sapUiTinyMarginTop`
      visible     = mo_client->_bind( mv_dirty ) ).

    lo_box->button(
      text    = `Reset`
      press   = mo_client->_event( `RESET` )
      class   = `sapUiSmallMarginBegin`
      visible = mo_client->_bind( mv_dirty ) ).

    lo_page->_z2ui5( )->focus( focusid = `input` ).

    lo_page->_z2ui5( )->dirty( mo_client->_bind( mv_dirty ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `BACK`.
        IF mv_dirty = abap_true.
          security_check_popup( ).
        ELSE.
          mo_client->nav_app_leave( ).
        ENDIF.
      WHEN `SUBMIT`.
        mv_dirty = xsdbool( mv_text_input IS NOT INITIAL ).
      WHEN `RESET`.
        CLEAR:
          mv_dirty,
          mv_text_input.
    ENDCASE.
  ENDMETHOD.

  METHOD security_check_popup.

    mo_client->nav_app_call( z2ui5_cl_pop_to_confirm=>factory(
                              i_question_text       = `Your entries will be lost when you leave this page.`
                              i_title               = `Warning`
                              i_icon                = `sap-icon://status-critical`
                              i_button_text_confirm = `Leave Page`
                              i_button_text_cancel  = `Cancel` ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      callback( ).
    ENDIF.

    on_event( ).

    IF mo_client->check_on_init( ).
      display_view( ).
    ELSE.
      mo_client->view_model_update( ).
    ENDIF.
  ENDMETHOD.

  METHOD callback.

    TRY.
        DATA(lo_prev) = mo_client->get_app( mo_client->get( )-s_draft-id_prev_app ).
        DATA(lo_confirm_leave) = CAST z2ui5_cl_pop_to_confirm( lo_prev )->result( ).

      CATCH cx_root.
    ENDTRY.

    IF lo_confirm_leave = abap_true.
      CLEAR mv_dirty.
      mo_client->nav_app_leave( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
