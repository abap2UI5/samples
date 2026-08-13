CLASS z2ui5_cl_smp_app_202 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA av_next TYPE string VALUE `Step22` ##NO_TEXT.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_202 IMPLEMENTATION.


  METHOD view_display.

    DATA(lr_view) = z2ui5_cl_xml_view=>factory( ).

    lr_view        = lr_view->shell( )->page( id = `page_main`
    title          = `abap2UI5 - Control - Wizard with Steps`
    navbuttonpress = client->_event_nav_app_leave( )
    shownavbutton  = client->check_app_prev_stack( ) ).

    lr_view->message_strip(
        text     = `A sap.m.Wizard guides through numbered steps. Branching is enabled: ` &&
                   `step 2 offers two follow-up steps, and the button pressed there picks ` &&
                   `the branch - the backend calls discardProgress and setNextStep by id ` &&
                   `(follow_up_action with cs_event-control_by_id).`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

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
        text  = `Press Step 2.2`
        press = client->_event( `STEP22` ) ).
    lr_wiz_step2->button(
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

    client->view_display( lr_view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      view_display( client ).
      RETURN.
    ENDIF.

    CASE client->get_event( ).
      WHEN `STEP22` OR `STEP23`.
        " the original wizard flow (discardProgress + setNextStep) as two
        " generic whitelisted control calls - t_arg is positional:
        " id, method, params (the step params are control ids; the view
        " defaults to cs_view-main)
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-control_by_id
            t_arg = VALUE #( ( `wiz` ) ( `discardProgress` ) ( `STEP2` ) ) ).
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-control_by_id
            t_arg = VALUE #( ( `STEP2` ) ( `setNextStep` ) ( client->get_event( ) ) ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
