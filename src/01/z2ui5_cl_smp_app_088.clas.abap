" @keywords navcontainer icontabbar icontabheader page switch control_by_id whitelisted
" @summary Switches the page of a NavContainer and the tab of an IconTabBar by ID, so navigation inside a view costs no roundtrip.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_088 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_selected_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    DATA mv_page TYPE string.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_088 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      mv_page = `page1`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    mv_page = client->get_event( ).
    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Switch NavContainer Page by ID`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                    )->ele( `content` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Selecting a tab in the IconTabHeader switches the NavContainer page on the client via the ` &&
                   `generic CONTROL_BY_ID front-end action (whitelisted method 'to'), without a backend roundtrip.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    CLEAR temp1.
    INSERT `NavCon` INTO TABLE temp1.
    INSERT `to` INTO TABLE temp1.
    INSERT `${$parameters>/key}` INTO TABLE temp1.
    page->ele( `IconTabHeader`
        )->a( n = `selectedKey` v = client->_bind( mv_selected_key )
        )->a( n = `select`      v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                     t_arg = temp1 )
        )->a( n = `mode`        v = `Inline`
        )->ele( `items`
            )->ele( `IconTabFilter`
                )->a( n = `text` v = `Home`
                )->a( n = `key`  v = `page1`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `text` v = `Applications`
                )->a( n = `key`  v = `page2`
            )->end(
            )->ele( `IconTabFilter`
                )->a( n = `text` v = `Users and Groups`
                )->a( n = `key`  v = `page3` ).

    page->ele( `NavContainer`
        )->a( n = `initialPage`           v = `page1`
        )->a( n = `id`                    v = `NavCon`
        )->a( n = `defaultTransitionName` v = `flip`
        )->ele( `pages`
            )->ele( `Page`
                )->a( n = `title` v = `first page`
                )->a( n = `id`    v = `page1`
            )->end(
            )->ele( `Page`
                )->a( n = `title` v = `second page`
                )->a( n = `id`    v = `page2`
            )->end(
            )->ele( `Page`
                )->a( n = `title` v = `third page`
                )->a( n = `id`    v = `page3` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
