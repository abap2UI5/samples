" @keywords confirm warning error success information dialog action
" @summary Every MessageBox type - confirm, warning, error, success, information - and what a custom action button changes about the answer.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_382 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA title TYPE string.
    DATA message TYPE string.
    DATA details TYPE string.

  PROTECTED SECTION.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_382 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    title   = `abap2UI5`.
    message = `This is a message box.`.
    details = `These are additional details about the message.`.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.

    CASE client->get_event( ).
      WHEN `CUSTOM`.
        
        CLEAR temp1.
        INSERT `Approve` INTO TABLE temp1.
        INSERT `Reject` INTO TABLE temp1.
        client->message_box_display(
            text             = message
            title            = title
            type             = `information`
            details          = details
            actions          = temp1
            emphasizedaction = `Approve` ).
      WHEN OTHERS.
        client->message_box_display(
            text    = message
            title   = title
            type    = client->get_event( )
            details = details ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Message - MessageBox, Types and Custom Actions`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample demonstrates MessageBox: open confirm, information, success, ` &&
                   `warning, error, or a custom dialog with your own actions.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `headerContent`
        )->tag( `Link`
            )->a( n = `text`   v = `UI5 Demo Kit`
            )->a( n = `target` v = `_blank`
            )->a( n = `href`   v = `https://sdk.openui5.org/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBox` ).

    page->ele( `Panel`
        )->a( n = `headerText` v = `Message Box Configuration`
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `title`    v = `Settings`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Title`
                )->tag( `Input`
                    )->a( n = `value` v = client->_bind( title )
                )->tag( `Label`
                    )->a( n = `text` v = `Message`
                )->tag( `Input`
                    )->a( n = `value` v = client->_bind( message )
                )->tag( `Label`
                    )->a( n = `text` v = `Details`
                )->tag( `TextArea`
                    )->a( n = `value` v = client->_bind( details )
                    )->a( n = `rows`  v = `3` ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `Text`
                )->a( n = `text` v = `Open Message Box:`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `confirm` )
                )->a( n = `text`  v = `Confirm`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `information` )
                )->a( n = `text`  v = `Information`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `success` )
                )->a( n = `text`  v = `Success`
                )->a( n = `type`  v = `Accept`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `warning` )
                )->a( n = `text`  v = `Warning`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `error` )
                )->a( n = `text`  v = `Error`
                )->a( n = `type`  v = `Reject`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `CUSTOM` )
                )->a( n = `text`  v = `Custom`
                )->a( n = `type`  v = `Emphasized` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
