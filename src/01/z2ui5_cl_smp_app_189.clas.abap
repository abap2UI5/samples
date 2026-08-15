" @keywords cursor enter tab next field form set_focus
CLASS z2ui5_cl_smp_app_189 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA one   TYPE string.
    DATA two   TYPE string.
    DATA three TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS render.
    METHODS dispatch.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_189 IMPLEMENTATION.


  METHOD dispatch.

    CASE client->get_event( ).
      WHEN `one_enter`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( `IdTwo` ) ) ).
      WHEN `two_enter`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( `IdThree` ) ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD render.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Focus - Jump to the Next Input on Enter`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Pressing Enter in an input field jumps the cursor to the next one via the set_focus follow-up action.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `One (Press Enter)`
            )->tag( `Input`
                )->a( n = `id`     v = `IdOne`
                )->a( n = `value`  v = client->_bind( one )
                )->a( n = `submit` v = client->_event( `one_enter` )
            )->tag( `Label`
                )->a( n = `text` v = `Two`
            )->tag( `Input`
                )->a( n = `id`     v = `IdTwo`
                )->a( n = `value`  v = client->_bind( two )
                )->a( n = `submit` v = client->_event( `two_enter` )
            )->tag( `Label`
                )->a( n = `text` v = `Three`
            )->tag( `Input`
                )->a( n = `id`    v = `IdThree`
                )->a( n = `value` v = client->_bind( three ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      render( ).
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = VALUE #( ( `IdOne` ) ) ).
    ENDIF.

    dispatch( ).

  ENDMETHOD.
ENDCLASS.
