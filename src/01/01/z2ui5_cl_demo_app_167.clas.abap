CLASS z2ui5_cl_demo_app_167 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_value TYPE string.

    METHODS set_view.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_167 IMPLEMENTATION.


  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp2 LIKE LINE OF temp3.
    DATA temp5 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp9 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
                title          = `abap2UI5 - Event with add Information and t_arg`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This sample shows how to pass extra arguments to an event via t_arg - fixed ` &&
                   `values, model values, or client-side expressions - and read them in the backend.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->link( text   = `More Infos..`
                target = `_blank`
                href   = `https://sapui5.hana.ondemand.com/sdk/#/topic/b0fb4de7364f4bcbb053a99aa645affe` ).

    
    CLEAR temp1.
    INSERT `FIX_VAL` INTO TABLE temp1.
    page->button( text  = `EVENT_FIX_VAL`
                  press = client->_event( val = `EVENT_FIX_VAL` t_arg = temp1 ) ).

    page->input( client->_bind( mv_value ) ).
    
    CLEAR temp3.
    
    temp2 = `$` && client->_bind( mv_value ).
    INSERT temp2 INTO TABLE temp3.
    page->button( text  = `EVENT_MODEL_VALUE`
                  press = client->_event( val = `EVENT_MODEL_VALUE` t_arg = temp3 ) ).

    
    CLEAR temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    page->button( text  = `SOURCE_PROPERTY_TEXT`
                  press = client->_event( val = `SOURCE_PROPERTY_TEXT` t_arg = temp5 ) ).

    
    CLEAR temp7.
    INSERT `${$parameters>/value}` INTO TABLE temp7.
    page->input(
        description = `make an input and press enter - `
        submit      = client->_event( val = `EVENT_PROPERTY_VALUE` t_arg = temp7 ) ).

    
    CLEAR temp9.
    INSERT `$event.oSource.oParent.sId` INTO TABLE temp9.
    page->button( text  = `PARENT_PROPERTY_ID`
                  press = client->_event( val = `PARENT_PROPERTY_ID` t_arg = temp9 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      mv_value = `my value`.
      set_view( ).
    ENDIF.

    CASE client->get( )-event.
      WHEN `EVENT_FIX_VAL` OR `EVENT_MODEL_VALUE` OR `SOURCE_PROPERTY_TEXT` OR `EVENT_PROPERTY_VALUE` OR `PARENT_PROPERTY_ID`.
        client->message_box_display( |backend event: { client->get_event_arg( ) }| ).
    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.
ENDCLASS.
