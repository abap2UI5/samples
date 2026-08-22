" @keywords dirty unsaved changes leave confirmation warning
" @summary Refuses to leave an app with unsaved changes: the confirmation popup in front of nav_app_leave, and how the dirty flag gets there.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/navigation
CLASS z2ui5_cl_smp_app_279 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA text_input TYPE string.
    DATA dirty TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_confirm_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_279 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:tnt`    v = `sap.tnt`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Navigation - Data Loss Protection on Leaving`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event( `BACK` ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Unsaved input marks the page dirty via a custom control; navigating back then opens a confirmation ` &&
                   `popup instead of leaving and losing the data.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    box = page->ele( `FlexBox`
        )->a( n = `class`      v = `sapUiTinyMargin`
        )->a( n = `alignItems` v = `Start`
        )->a( n = `direction`  v = `Row` ).

    box->tag( `Input`
        )->a( n = `id`          v = `input`
        )->a( n = `placeholder` v = `Enter data, submit and navigate back to trigger data loss protection`
        )->a( n = `value`       v = client->_bind( text_input )
        )->a( n = `submit`      v = client->_event( `SUBMIT` )
        )->a( n = `width`       v = `40rem` ).

    box->ele( n = `InfoLabel` ns = `tnt`
        )->a( n = `class`       v = `sapUiSmallMarginBegin sapUiTinyMarginTop`
        )->a( n = `text`        v = `dirty`
        )->a( n = `colorScheme` v = `8`
        )->a( n = `visible`     v = client->_bind( dirty ) ).

    box->tag( `Button`
        )->a( n = `press`   v = client->_event( `RESET` )
        )->a( n = `text`    v = `Reset`
        )->a( n = `visible` v = client->_bind( dirty )
        )->a( n = `class`   v = `sapUiSmallMarginBegin` ).

    page->tag( n = `Dirty` ns = `z2ui5` ).

    client->view_display( page->stringify( ) ).

    
    CLEAR temp1.
    INSERT `input` INTO TABLE temp1.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_focus
        t_arg = temp1 ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE abap_bool.
        DATA temp1 TYPE xsdboolean.
        DATA temp4 TYPE abap_bool.
        DATA temp5 TYPE string.

    CASE client->get_event( ).
      WHEN `BACK`.

        IF dirty = abap_true.
          popup_confirm_display( ).

        ELSE.
          client->nav_app_leave( ).
        ENDIF.
      WHEN `POPUP_LEAVE`.

        client->popup_destroy( ).
        
        CLEAR temp3.
        dirty = temp3.
        client->nav_app_leave( ).

      WHEN `POPUP_CANCEL`.
        client->popup_destroy( ).
      WHEN `SUBMIT`.
        
        temp1 = boolc( text_input IS NOT INITIAL ).
        dirty = temp1.
      WHEN `RESET`.

        
        CLEAR temp4.
        dirty      = temp4.
        
        CLEAR temp5.
        text_input = temp5.

    ENDCASE.

  ENDMETHOD.


  METHOD popup_confirm_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:tnt`  v = `sap.tnt` ).
    popup->ele( `Dialog`
        )->a( n = `title` v = `Warning`
        )->a( n = `icon`  v = `sap-icon://status-critical`
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Text`
                )->a( n = `text`  v = `Your entries will be lost when you leave this page.`
        )->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP_CANCEL` )
                )->a( n = `text`  v = `Cancel`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP_LEAVE` )
                )->a( n = `text`  v = `Leave Page`
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
