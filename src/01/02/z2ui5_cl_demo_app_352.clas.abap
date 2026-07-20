CLASS z2ui5_cl_demo_app_352 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_352 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE string_table.
      DATA temp3 TYPE string_table.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
      
      CLEAR temp1.
      INSERT `ZINPUT` INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = temp1 ).
      
      CLEAR temp3.
      INSERT `ZINPUT` INTO TABLE temp3.
      INSERT `numeric` INTO TABLE temp3.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-keyboard_set_mode
          t_arg = temp3 ).
    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
             )->page(
                 title          = `abap2UI5 - Softkeyboard on/off`
                 navbuttonpress = client->_event_nav_app_leave( )
                 shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Set the on-screen soft keyboard mode (numeric or off) via the keyboard_set_mode follow-up action, and ` &&
                   `focus the input on load.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form(
              editable = abap_true
         )->content( `form`
             )->title( `Keyboard on/off`
             )->label( `Input (numeric keyboard)`
             )->input(
                 id               = `ZINPUT`
                 value            = client->_bind( input )
                 showvaluehelp    = abap_true
                 valuehelprequest = client->_event( `CALL_KEYBOARD` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp5 TYPE string_table.

    IF client->check_on_event( `CALL_KEYBOARD` ) IS NOT INITIAL.
      
      CLEAR temp5.
      INSERT `ZINPUT` INTO TABLE temp5.
      INSERT `none` INTO TABLE temp5.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-keyboard_set_mode
          t_arg = temp5 ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
