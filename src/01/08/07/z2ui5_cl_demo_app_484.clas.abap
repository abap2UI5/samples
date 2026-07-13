"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextAreaValueUpdate
"! Since 1.30 the value property of sap.m.TextArea is not updated on every keystroke, but first when
"! the user presses Enter or leaves the input. The change was necessary to fully support the standard
"! UI5 data binding with formatters and types. If you still need immediate update you have 2 options:
"! Handle liveChange events or enable the boolean property valueLiveUpdate.
CLASS z2ui5_cl_demo_app_484 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value_live_update TYPE abap_bool.
    DATA input_value TYPE string.
    DATA get_value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_484 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      get_value = ` `.
      view_display( ).

    ELSEIF client->check_on_event( `LIVE_CHANGE` ).

      get_value = client->get_event_arg( 1 ).
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: TextArea - Value Update`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TextArea/sample/sap.m.sample.TextAreaValueUpdate` ).

    page->simple_form(
            editable = abap_true
            layout   = `ResponsiveGridLayout`
            )->content( `form`
            )->label( `ValueLiveUpdate`
            )->switch( state = client->_bind_edit( value_live_update )
            )->label( `Type here`
            )->text_area(
                id              = `TypeHere`
                value           = client->_bind_edit( input_value )
                valueliveupdate = client->_bind_edit( value_live_update )
            " the liveChange event is not part of the typed view API - added via the generic property helper
            )->get(
                )->_generic_property( VALUE #(
                    n = `liveChange`
                    v = client->_event( val   = `LIVE_CHANGE`
                                        t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) )
            )->get_parent(
            )->label( `input.getValue()`
            )->text(
                id   = `getValue`
                text = client->_bind( get_value )
            )->label( `model.getProperty()`
            )->text(
                id   = `getProperty`
                text = client->_bind_edit( input_value ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
