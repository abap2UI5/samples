CLASS z2ui5_cl_demo_app_202 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA av_next TYPE string VALUE `Step22` ##NO_TEXT.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_202 IMPLEMENTATION.


  METHOD view_display.

    DATA(lr_view) = z2ui5_cl_xml_view=>factory( ).

    lr_view        = lr_view->shell( )->page( id = `page_main`
    title          = `abap2UI5 - Demo Wizard Control`
    navbuttonpress = client->_event_nav_app_leave( )
    shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(lr_wizard) = lr_view->wizard( id              = `wiz`
                                       enablebranching = abap_true ).
    DATA(lr_wiz_step1) = lr_wizard->wizard_step( title     = `STEP1`
                                                 validated = abap_true
                                                 nextstep  = `STEP2` ).
    lr_wiz_step1->message_strip( `STEP1` ).

    DATA(lr_wiz_step2) = lr_wizard->wizard_step( id              = `STEP2`
                                                 title           = `STEP2`
                                                 validated       = abap_true
                                                 subsequentsteps = `STEP22, STEP23` ).

    lr_wiz_step2->message_strip( `STEP2` ).
    lr_wiz_step2->button(
*      EXPORTING
        text  = `Press Step 2.2`
        press = client->_event( `STEP22` ) ).
    lr_wiz_step2->button(
*      EXPORTING
        text  = `Press Step 2.3`
        press = client->_event( `STEP23` ) ).

    DATA(lr_wiz_step22) = lr_wizard->wizard_step( id       = `STEP22`
                                                 title     = `STEP2.2`
                                                 validated = abap_true ).

    lr_wiz_step22->message_strip( `STEP22` ).

    DATA(lr_wiz_step23) = lr_wizard->wizard_step( id       = `STEP23`
                                                 title     = `STEP2.3`
                                                 validated = abap_true ).

    lr_wiz_step23->message_strip( `STEP23` ).

    DATA(lr_wiz_step3) = lr_wizard->wizard_step( title     = `STEP3`
                                                 validated = abap_true ).

    lr_wiz_step3->message_strip( `STEP3` ).

*
    client->view_display( lr_view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      view_display( client ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN `STEP22` OR `STEP23`.
        " the original wizard flow (discardProgress + setNextStep) as two
        " generic whitelisted control calls - t_arg is positional:
        " id, view, method, params (the step params are control ids)
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-control_by_id
            t_arg = VALUE #( ( `wiz` ) ( `MAIN` ) ( `discardProgress` ) ( `STEP2` ) ) ).
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-control_by_id
            t_arg = VALUE #( ( `STEP2` ) ( `MAIN` ) ( `setNextStep` ) ( client->get( )-event ) ) ).

    ENDCASE.
    client->view_model_update( ).

  ENDMETHOD.
ENDCLASS.
