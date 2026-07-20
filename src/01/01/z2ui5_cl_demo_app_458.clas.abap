CLASS z2ui5_cl_demo_app_458 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_458 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      amount = 42.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Message Model - automatic validation`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Type letters into the amount field and press Enter: the failed Integer ` &&
                   `validation is collected AUTOMATICALLY into the message> model (no app code, ` &&
                   `no roundtrip), renders in the list below and sets the field's valueState. ` &&
                   `A valid number clears it again.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the Integer type on the two-way binding is what triggers the client-
    " side validation; the framework's message> model catches its errors
    page->vbox( `sapUiSmallMargin`
        )->label( `Amount (integer only)`
        )->input( width = `12rem`
                  value = |\{ path: '{ client->_bind( val = amount path = abap_true ) }', | &&
                          |type: 'sap.ui.model.type.Integer' \}| ).

    page->list( headertext = `Validation messages ({message>/})`
                items      = `{message>/}`
                nodatatext = `no validation errors`
                class      = `sapUiSmallMargin`
        )->standard_list_item( title = `{message>message}`
                               info  = `{message>type}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
