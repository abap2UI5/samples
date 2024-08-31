CLASS z2ui5_cl_demo_app_279 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA text_input TYPE string .
    DATA info_area_visible TYPE abap_bool .

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA initialized TYPE abap_bool.
    DATA dirty TYPE abap_bool.

    METHODS display_view.
    METHODS on_event.
    METHODS render_popup.

ENDCLASS.



CLASS z2ui5_cl_demo_app_279 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory(
                   )->shell(
                   )->page(
                      title          = 'abap2UI5 - data loss protection'
                      navbuttonpress = client->_event( 'BACK' )
                      shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(box) = page->flex_box( direction = `Row` alignitems = `Start` class = 'sapUiTinyMargin' ).

    box->input(
      id          = `input`
      value       = client->_bind_edit( text_input )
      submit      = client->_event( 'submit' )
      width       = `40rem`
      placeholder = `Enter data, submit and navigate back to trigger data loss protection` ).

    box->info_label(
      text        = 'dirty'
      colorscheme = '8'
      icon        = 'sap-icon://message-success'
      class       = `sapUiSmallMarginBegin sapUiTinyMarginTop`
      visible     = client->_bind( info_area_visible ) ).

    box->button(
      text    = 'Reset'
      press   = client->_event( 'reset' )
      class   = `sapUiSmallMarginBegin`
      visible = client->_bind( info_area_visible ) ).

    page->_z2ui5( )->focus( focusid = `input` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        IF dirty = abap_true.
          render_popup( ).
        ELSE.
          client->nav_app_leave( ).
        ENDIF.
      WHEN 'submit'.
        dirty = xsdbool( text_input IS NOT INITIAL ).
      WHEN 'reset'.
        CLEAR:
          dirty,
          text_input.
      WHEN 'popup_decide_cancel'.
        CLEAR: dirty.
        client->popup_destroy( ).
        client->nav_app_leave( ).
      WHEN 'popup_decide_continue'.
        client->popup_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD render_popup.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    popup->dialog( title = 'Warning' icon = 'sap-icon://status-critical'
        )->vbox(
            )->text( text = 'Your entries will be lost when you leave this page.'
                     class ='sapUiSmallMargin'
        )->get_parent(
        )->buttons(
            )->button(
                text  = 'Leave Page'
                type  = 'Emphasized'
                press = client->_event( 'popup_decide_cancel' )
            )->button(
                text  = 'Cancel'
                press = client->_event( 'popup_decide_continue' ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    on_event( ).

    client->dirty( dirty ).

    IF initialized = abap_false.
      initialized = abap_true.
      display_view( ).
    ELSE.
      info_area_visible = dirty.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
