" @keywords navcontainer dialog pages back forward
" @summary A NavContainer inside a dialog: several pages in one popup, with back and forward between them.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popup
CLASS z2ui5_cl_smp_app_170 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_selected_key TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS simple_popup1.
    METHODS simple_popup2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_170 IMPLEMENTATION.

  METHOD simple_popup1.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    
    dialog = popup->ele( `Dialog`
        )->a( n = `stretch`    b = abap_true
        )->a( n = `afterClose` v = client->_event( `BTN_OK_1ND` )
        )->ele( `content` ).

    
    CLEAR temp1.
    INSERT `NavCon` INTO TABLE temp1.
    INSERT `to` INTO TABLE temp1.
    INSERT `${$parameters>/selectedKey}` INTO TABLE temp1.
    dialog->ele( `IconTabBar`
        )->a( n = `select`      v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                         view  = client->cs_view-popup
                                                                                         t_arg = temp1 )
        )->a( n = `expandable`  b = abap_false
        )->a( n = `expanded`    b = abap_true
        )->a( n = `headerMode`  v = `Inline`
        )->a( n = `selectedKey` v = client->_bind( mv_selected_key )
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
                )->a( n = `key`  v = `page3`
            )->end(
        )->end(
        )->ele( `content`
            )->ele( `VBox`
                )->a( n = `height` v = `100%`
                )->ele( `NavContainer`
                    )->a( n = `initialPage`           v = `page1`
                    )->a( n = `id`                    v = `NavCon`
                    )->a( n = `height`                v = `400px`
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

    dialog->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BTN_OK_1ND` )
                )->a( n = `text`  v = `OK`
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD simple_popup2.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    
    dialog = popup->ele( `Dialog`
        )->a( n = `afterClose` v = client->_event( `BTN_OK_2ND` )
        )->ele( `content` ).

    dialog->tag( `Label`
        )->a( n = `text` v = `this is a second popup` ).

    dialog->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BTN_OK_2ND` )
                )->a( n = `text`  v = `GOTO 1ST POPUP`
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popup - Navigate between Dialogs (NavContainer)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Press the button to open a dialog; from there a second popup can be opened and navigated ` &&
                   `back to the first, demonstrating popup-to-popup navigation.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( `POPUP` )
        )->a( n = `text`  v = `Open Popup...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `GOTO_2ND`.
        simple_popup2( ).

      WHEN `BTN_OK_2ND`.
        client->popup_destroy( ).
        simple_popup1( ).

      WHEN `BTN_OK_1ND`.
        client->popup_destroy( ).

      WHEN `POPUP`.
        simple_popup1( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
