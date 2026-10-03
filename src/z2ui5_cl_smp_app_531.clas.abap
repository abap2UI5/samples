" @keywords transition animation slide fade flip navcontainer transition_back nav_app_leave
" @summary The next view arrives with a page transition - slide, baseSlide, fade, flip or show - and every way back plays it reversed: nav_app_leave, the browser Back button, an app's own Previous step.
"! The page transitions of client->view_display( transition = ... ). Every
"! button opens the page z2ui5_cl_smp_app_532 with one transition; the way
"! back plays it reversed - the rule of sap.m.NavContainer: the page being
"! left runs the way it ARRIVED, backwards. Two more entries show the cases
"! the framework cannot tell by itself, or tells without being asked: an app
"! with screens of its own (z2ui5_cl_smp_app_533, transition_back), and the
"! browser Back and Forward buttons under hash routing.
CLASS z2ui5_cl_smp_app_531 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " hash routing (KEEP), switched with the Switch - the browser buttons
    " then move between the pages as well, with the same transitions
    DATA routing TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_531 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE REF TO z2ui5_cl_smp_app_533.
      DATA temp2 TYPE string.
      DATA mode LIKE temp2.
      DATA temp3 TYPE string_table.

    me->client = client.

    " this app names no transition of its own: a way back TO it plays what
    " the page being left arrived with
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `GO` ) IS NOT INITIAL.
      client->nav_app_call( z2ui5_cl_smp_app_532=>factory( transition = client->get_event_arg( ) level = 1 ) ).

    ELSEIF client->check_on_event( `WIZARD` ) IS NOT INITIAL.
      
      CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_533.
      client->nav_app_call( temp1 ).

    ELSEIF client->check_on_event( `ROUTING` ) IS NOT INITIAL.

      " the Switch wrote the new state before main( ) ran
      
      IF routing = abap_true.
        temp2 = client->cs_nav_mode-keep.
      ELSE.
        temp2 = client->cs_nav_mode-default.
      ENDIF.
      
      mode = temp2.
      
      CLEAR temp3.
      INSERT mode INTO TABLE temp3.
      client->follow_up_action( val = client->cs_event-hash_routing t_arg = temp3 ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA content TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA buttons TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE string_table.
    DATA t_transition LIKE temp5.
    DATA transition LIKE LINE OF t_transition.
      DATA temp7 TYPE string.
      DATA name LIKE temp7.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Navigation - Page Transitions (view_display transition)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Each button opens a page with one transition. Leave that page with the nav button in ` &&
                   `its header: the transition plays reversed - the page being left runs the way it arrived, ` &&
                   `backwards, as in sap.m.NavContainer. baseSlide needs UI5 1.74, older releases play slide.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    content = page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    content->tag( `Title`
        )->a( n = `text`  v = `view_display( transition = ... )`
        )->a( n = `level` v = `H2` ).

    
    buttons = content->ele( `HBox`
        )->a( n = `wrap`  v = `Wrap`
        )->a( n = `class` v = `sapUiSmallMarginTop` ).
    " the five cs_transition names, and none at all to compare with
    
    CLEAR temp5.
    INSERT client->cs_transition-slide INTO TABLE temp5.
    INSERT client->cs_transition-base_slide INTO TABLE temp5.
    INSERT client->cs_transition-fade INTO TABLE temp5.
    INSERT client->cs_transition-flip INTO TABLE temp5.
    INSERT client->cs_transition-show INTO TABLE temp5.
    INSERT `` INTO TABLE temp5.
    
    t_transition = temp5.
    
    LOOP AT t_transition INTO transition.
      
      IF transition IS INITIAL.
        temp7 = `none`.
      ELSE.
        temp7 = transition.
      ENDIF.
      
      name = temp7.
      buttons->tag( `Button`
          )->a( n = `id`    t = |go-{ name }|
          )->a( n = `text`  t = name
          )->a( n = `icon`  v = `sap-icon://navigation-right-arrow`
          )->a( n = `class` v = `sapUiTinyMarginEnd sapUiTinyMarginBottom`
          )->a( n = `press` v = client->_event( val = `GO` arg = transition ) ).
    ENDLOOP.

    content->tag( `Title`
        )->a( n = `text`  v = `More`
        )->a( n = `level` v = `H3`
        )->a( n = `class` v = `sapUiMediumMarginTop` ).
    content->tag( `Button`
        )->a( n = `id`    v = `wizard`
        )->a( n = `text`  v = `An app with screens of its own - Next and Previous (transition_back)`
        )->a( n = `icon`  v = `sap-icon://step`
        )->a( n = `class` v = `sapUiTinyMarginBottom`
        )->a( n = `press` v = client->_event( `WIZARD` ) ).
    content->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->tag( `Switch`
            )->a( n = `id`     v = `routing`
            )->a( n = `state`  v = client->_bind( routing )
            )->a( n = `change` v = client->_event( `ROUTING` )
        )->tag( `Label`
            )->a( n = `text`  v = `Hash routing (KEEP) - the browser Back and Forward buttons move the pages too`
            )->a( n = `class` v = `sapUiTinyMarginBegin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
