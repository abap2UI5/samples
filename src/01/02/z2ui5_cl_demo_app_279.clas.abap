CLASS z2ui5_cl_demo_app_279 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA text_input TYPE string.
    DATA dirty TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS security_check_popup.
    METHODS on_navigation.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_279 IMPLEMENTATION.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA box TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    page = z2ui5_cl_xml_view=>factory(
                   )->shell(
                   )->page(
                      title          = `abap2UI5 - data loss protection`
                      navbuttonpress = client->_event( `BACK` )
                      shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Unsaved input marks the page dirty via a custom control; navigating back then opens a confirmation ` &&
                   `popup instead of leaving and losing the data.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    box = page->flex_box( direction  = `Row`
                                alignitems = `Start`
                                class      = `sapUiTinyMargin` ).

    box->input(
      id          = `input`
      value       = client->_bind( text_input )
      submit      = client->_event( `submit` )
      width       = `40rem`
      placeholder = `Enter data, submit and navigate back to trigger data loss protection` ).

    box->info_label(
      text        = `dirty`
      colorscheme = `8`
      icon        = `sap-icon://message-success`
      class       = `sapUiSmallMarginBegin sapUiTinyMarginTop`
      visible     = client->_bind( dirty ) ).

    box->button(
      text    = `Reset`
      press   = client->_event( `reset` )
      class   = `sapUiSmallMarginBegin`
      visible = client->_bind( dirty ) ).

    page->_z2ui5( )->dirty( client->_bind( dirty ) ).

    client->view_display( page->stringify( ) ).

    
    CLEAR temp1.
    INSERT `input` INTO TABLE temp1.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_focus
        t_arg = temp1 ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE xsdboolean.
        DATA temp3 TYPE abap_bool.
        DATA temp4 TYPE string.

    CASE client->get( )-event.
      WHEN `BACK`.
        IF dirty = abap_true.
          security_check_popup( ).

        ELSE.
          client->nav_app_leave( ).
        ENDIF.
      WHEN `submit`.
        
        temp1 = boolc( text_input IS NOT INITIAL ).
        dirty = temp1.
      WHEN `reset`.
        
        CLEAR temp3.
        dirty      = temp3.
        
        CLEAR temp4.
        text_input = temp4.
    ENDCASE.

  ENDMETHOD.


  METHOD security_check_popup.

    client->nav_app_call( z2ui5_cl_pop_to_confirm=>factory(
                              i_question_text       = `Your entries will be lost when you leave this page.`
                              i_title               = `Warning`
                              i_icon                = `sap-icon://status-critical`
                              i_button_text_confirm = `Leave Page`
                              i_button_text_cancel  = `Cancel` ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      on_navigation( ).
    ENDIF.
    on_event( ).
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_navigation.
        DATA prev TYPE REF TO z2ui5_if_app.
        DATA temp5 TYPE REF TO z2ui5_cl_pop_to_confirm.
        DATA confirm_leave TYPE abap_bool.
      DATA temp6 TYPE abap_bool.

    TRY.
        
        prev = client->get_app( client->get( )-s_draft-id_prev_app ).
        
        temp5 ?= prev.
        
        confirm_leave = temp5->result( ).

      CATCH cx_root.
    ENDTRY.

    IF confirm_leave = abap_true.

      
      CLEAR temp6.
      dirty = temp6.
      client->nav_app_leave( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
