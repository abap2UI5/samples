" @keywords wizard step branching discardprogress setnextstep control_by_id
" @summary Drives a Wizard from the backend: setting the next step and discarding progress by ID, which is how a branching wizard is steered.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_202 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA next_step TYPE string.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_202 IMPLEMENTATION.


  METHOD view_display.

    DATA lr_view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_wizard TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_wiz_step1 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_wiz_step2 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_wiz_step22 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_wiz_step23 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_wiz_step3 TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp1 TYPE string_table.
    lr_view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    lr_view        = lr_view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Wizard with Steps`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    lr_view->tag( `MessageStrip`
        )->a( n = `text`     v = `A sap.m.Wizard guides through numbered steps. Branching is enabled: ` &&
                   `step 2 offers two follow-up steps, and the button pressed there picks ` &&
                   `the branch - the backend calls discardProgress and setNextStep by id ` &&
                   `(follow_up_action with cs_event-control_by_id).`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    lr_wizard = lr_view->ele( `Wizard`
        )->a( n = `id`              v = `wiz`
        )->a( n = `enableBranching` b = abap_true ).
    
    lr_wiz_step1 = lr_wizard->ele( `WizardStep`
        )->a( n = `title`     v = `STEP1`
        )->a( n = `validated` b = abap_true
        )->a( n = `nextStep`  v = `STEP2` ).
    lr_wiz_step1->tag( `MessageStrip`
        )->a( n = `text` v = `STEP1` ).

    
    lr_wiz_step2 = lr_wizard->ele( `WizardStep`
        )->a( n = `id`              v = `STEP2`
        )->a( n = `title`           v = `STEP2`
        )->a( n = `validated`       b = abap_true
        )->a( n = `subsequentSteps` v = `STEP22, STEP23` ).

    lr_wiz_step2->tag( `MessageStrip`
        )->a( n = `text` v = `STEP2` ).
    lr_wiz_step2->tag( `Button`
        )->a( n = `press` v = client->_event( `STEP22` )
        )->a( n = `text`  v = `Press Step 2.2` ).
    lr_wiz_step2->tag( `Button`
        )->a( n = `press` v = client->_event( `STEP23` )
        )->a( n = `text`  v = `Press Step 2.3` ).

    
    lr_wiz_step22 = lr_wizard->ele( `WizardStep`
        )->a( n = `id`        v = `STEP22`
        )->a( n = `title`     v = `STEP2.2`
        )->a( n = `validated` b = abap_true ).

    lr_wiz_step22->tag( `MessageStrip`
        )->a( n = `text` v = `STEP22` ).

    
    lr_wiz_step23 = lr_wizard->ele( `WizardStep`
        )->a( n = `id`        v = `STEP23`
        )->a( n = `title`     v = `STEP2.3`
        )->a( n = `validated` b = abap_true ).

    lr_wiz_step23->tag( `MessageStrip`
        )->a( n = `text` v = `STEP23` ).

    
    lr_wiz_step3 = lr_wizard->ele( `WizardStep`
        )->a( n = `title`     v = `STEP3`
        )->a( n = `validated` b = abap_true ).

    lr_wiz_step3->tag( `MessageStrip`
        )->a( n = `text` v = `STEP3` ).

    client->view_display( lr_view->stringify( ) ).

    " nextStep is an ASSOCIATION: no binding can carry it, and view_display( )
    " has just destroyed the slot XMLView.create rebuilds - so the branch the
    " handler picked is gone from the fresh WizardStep while NEXT_STEP still
    " describes it. Re-issuing the same call here is what makes the choice
    " survive a navigation back, a draft restore or any later redisplay.
    IF next_step IS NOT INITIAL.
      
      CLEAR temp1.
      INSERT `STEP2` INTO TABLE temp1.
      INSERT `setNextStep` INTO TABLE temp1.
      INSERT next_step INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-control_by_id
          t_arg = temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.

    IF client->check_on_init( ) IS NOT INITIAL.

      view_display( client ).
      RETURN.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( client ).
    ENDIF.

    CASE client->get_event( ).
      WHEN `STEP22` OR `STEP23`.
        " the original wizard flow (discardProgress + setNextStep) as two
        " generic whitelisted control calls - t_arg is positional:
        " id, method, params (the step params are control ids; the view
        " defaults to cs_view-main)
        next_step = client->get_event( ).
        
        CLEAR temp3.
        INSERT `wiz` INTO TABLE temp3.
        INSERT `discardProgress` INTO TABLE temp3.
        INSERT `STEP2` INTO TABLE temp3.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-control_by_id
            t_arg = temp3 ).
        
        CLEAR temp5.
        INSERT `STEP2` INTO TABLE temp5.
        INSERT `setNextStep` INTO TABLE temp5.
        INSERT next_step INTO TABLE temp5.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-control_by_id
            t_arg = temp5 ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
