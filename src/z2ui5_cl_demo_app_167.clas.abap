CLASS z2ui5_cl_demo_app_167 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_value TYPE string.

    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_167 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title          = `abap2UI5 - Event with add Information and t_arg`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->link( text   = `More Infos..`
                target = `_blank`
                href   = `https://sapui5.hana.ondemand.com/sdk/#/topic/b0fb4de7364f4bcbb053a99aa645affe` ).

    lo_page->button( text  = `EVENT_FIX_VAL`
                  press = mo_client->_event( val = `EVENT_FIX_VAL` t_arg = VALUE #(
        ( `FIX_VAL` ) ) ) ).

    lo_page->input( mo_client->_bind_edit( mv_value ) ).
    lo_page->button( text  = `EVENT_MODEL_VALUE`
                  press = mo_client->_event( val = `EVENT_MODEL_VALUE` t_arg = VALUE #(
        ( `$` && mo_client->_bind_edit( mv_value ) ) ) ) ).

    lo_page->button( text  = `SOURCE_PROPERTY_TEXT`
                  press = mo_client->_event( val = `SOURCE_PROPERTY_TEXT` t_arg = VALUE #(
        ( `${$source>/text}` ) ) ) ).

    lo_page->input(
        description = `make an input and press enter - `
        submit      = mo_client->_event( val = `EVENT_PROPERTY_VALUE` t_arg = VALUE #(
        ( `${$parameters>/value}` ) ) ) ).

    lo_page->button( text  = `PARENT_PROPERTY_ID`
                  press = mo_client->_event( val = `PARENT_PROPERTY_ID` t_arg = VALUE #(
        ( `$event.oSource.oParent.sId` ) ) ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      mv_value = `my value`.
      set_view( ).
    ENDIF.

    DATA(lt_arg) = mo_client->get( )-t_event_arg.
    CASE mo_client->get( )-event.
      WHEN `EVENT_FIX_VAL` OR `EVENT_MODEL_VALUE` OR `SOURCE_PROPERTY_TEXT` OR `EVENT_PROPERTY_VALUE` OR `PARENT_PROPERTY_ID`.
        mo_client->message_box_display( `backend event :` && lt_arg[ 1 ] ).
    ENDCASE.

    mo_client->view_model_update( ).
  ENDMETHOD.
ENDCLASS.
