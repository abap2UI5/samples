" @keywords nested stack popup in popup second dialog
" @summary A dialog opened from inside a dialog, and what closing the inner one does to the stack.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popup
CLASS z2ui5_cl_smp_app_161 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.
    METHODS on_event.
    METHODS simple_popup1.
    METHODS simple_popup2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_161 IMPLEMENTATION.

  METHOD simple_popup1.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    
    dialog = popup->ele( `Dialog`
        )->a( n = `afterClose` v = client->_event( `BTN_OK_1ND` )
        )->ele( `content` ).

    dialog->tag( `Button`
        )->a( n = `press` v = client->_event( `GOTO_2ND` )
        )->a( n = `text`  v = `Open 2nd popup` ).

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
            )->a( n = `title`          v = `abap2UI5 - Popup - Dialog inside a Dialog`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample opens a popup from a button and then chains to a second popup ` &&
                   `from within the first one.`
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
      RETURN.
    ENDIF.
    on_event( ).

  ENDMETHOD.

ENDCLASS.
