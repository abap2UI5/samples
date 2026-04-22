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


CLASS z2ui5_cl_demo_app_202 IMPLEMENTATION.

  METHOD view_display.

    DATA(lr_view) = z2ui5_cl_xml_view=>factory( ).

    lr_view->_generic( name = `script`
                       ns   = `html` )->_cc_plain_xml( `sap.z2ui5.decideNextStep = (stepId, nextStepId) => {debugger;` && |\n| &&
                                                                     ` var wiz = sap.z2ui5.oView.byId('wiz');` && |\n| &&
                                                                     ` wiz.discardProgress(sap.z2ui5.oView.byId(stepId));` && |\n| &&
                                                                     ` var step = sap.z2ui5.oView.byId(stepId);` && |\n| &&
                                                                     ` var nextStep = sap.z2ui5.oView.byId(nextStepId);` && |\n| &&
                                                                     ` step.setNextStep(nextStep);` && |\n| &&
                                                                     `}` ).

    lr_view = lr_view->shell( )->page( id = `page_main`
             title                        = `abap2UI5 - Demo Wizard Control`
             navbuttonpress               = client->_event_nav_app_leave( )
             shownavbutton                = client->check_app_prev_stack( ) ).

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
        press = client->_event(`STEP22` ) ).
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
      WHEN `STEP22`.

        client->follow_up_action( 'sap.z2ui5.decideNextStep(`STEP2`,`STEP22`);' ).

      WHEN `STEP23`.

        client->follow_up_action( 'sap.z2ui5.decideNextStep(`STEP2`,`STEP23`);' ).

    ENDCASE.
    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
