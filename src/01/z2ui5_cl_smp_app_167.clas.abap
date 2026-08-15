" @keywords argument parameter payload event data fixed value
CLASS z2ui5_cl_smp_app_167 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_value TYPE string.

    METHODS set_view.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_167 IMPLEMENTATION.


  METHOD set_view.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Event - Extra Arguments with t_arg`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample shows how to pass extra arguments to an event via t_arg - fixed ` &&
                   `values, model values, or client-side expressions - and read them in the backend.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Link`
        )->a( n = `text`   v = `More information...`
        )->a( n = `target` v = `_blank`
        )->a( n = `href`   v = `https://sapui5.hana.ondemand.com/sdk/#/topic/b0fb4de7364f4bcbb053a99aa645affe` ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( val = `EVENT_FIX_VAL` t_arg = VALUE #(
        ( `FIX_VAL` ) ) )
        )->a( n = `text`  v = `EVENT_FIX_VAL` ).

    page->tag( `Input`
        )->a( n = `value` v = client->_bind( mv_value ) ).
    page->tag( `Button`
        )->a( n = `press` v = client->_event( val = `EVENT_MODEL_VALUE` t_arg = VALUE #(
        ( `$` && client->_bind( mv_value ) ) ) )
        )->a( n = `text`  v = `EVENT_MODEL_VALUE` ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( val = `SOURCE_PROPERTY_TEXT` t_arg = VALUE #(
        ( `${$source>/text}` ) ) )
        )->a( n = `text`  v = `SOURCE_PROPERTY_TEXT` ).

    page->tag( `Input`
        )->a( n = `description` v = `make an input and press enter - `
        )->a( n = `submit`      v = client->_event( val = `EVENT_PROPERTY_VALUE` t_arg = VALUE #(
        ( `${$parameters>/value}` ) ) ) ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( val = `PARENT_PROPERTY_ID` t_arg = VALUE #(
        ( `$event.oSource.oParent.sId` ) ) )
        )->a( n = `text`  v = `PARENT_PROPERTY_ID` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      mv_value = `my value`.
      set_view( ).
    ENDIF.

    CASE client->get_event( ).
      WHEN `EVENT_FIX_VAL` OR `EVENT_MODEL_VALUE` OR `SOURCE_PROPERTY_TEXT` OR `EVENT_PROPERTY_VALUE` OR `PARENT_PROPERTY_ID`.
        client->message_box_display( |backend event: { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
