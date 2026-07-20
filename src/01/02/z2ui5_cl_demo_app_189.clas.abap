CLASS z2ui5_cl_demo_app_189 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA one   TYPE string.
    DATA two   TYPE string.
    DATA three TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS render.
    METHODS dispatch.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_189 IMPLEMENTATION.


  METHOD dispatch.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.

    CASE client->get( )-event.
      WHEN `one_enter`.
        
        CLEAR temp1.
        INSERT `IdTwo` INTO TABLE temp1.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = temp1 ).
      WHEN `two_enter`.
        
        CLEAR temp3.
        INSERT `IdThree` INTO TABLE temp3.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = temp3 ).
    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD render.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
          )->page(
              title          = `abap2UI5 - Focus II`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Pressing Enter in an input field jumps the cursor to the next one via the set_focus follow-up action.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form(
        editable = abap_true
       )->content( `form`
       )->label( `One (Press Enter)` )->input( id     = `IdOne`
                                               value  = client->_bind( one )
                                               submit = client->_event( `one_enter` )
       )->label( `Two` )->input( id     = `IdTwo`
                                 value  = client->_bind( two )
                                 submit = client->_event( `two_enter` )
       )->label( `Three` )->input( id    = `IdThree`
                                   value = client->_bind( three ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp5 TYPE string_table.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      render( ).
      
      CLEAR temp5.
      INSERT `IdOne` INTO TABLE temp5.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = temp5 ).
    ENDIF.

    dispatch( ).

  ENDMETHOD.
ENDCLASS.
