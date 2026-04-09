CLASS z2ui5_cl_demo_app_027 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE i.
    DATA input2   TYPE string.
    DATA input31  TYPE i.
    DATA input32  TYPE i.
    DATA input41  TYPE string.
    DATA input51  TYPE string.
    DATA input52  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_027 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      product  = `tomato`.
      quantity = `500`.
      input41  = `faasdfdfsaVIp`.

    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA bind_input31 TYPE string.
    DATA bind_input32 TYPE string.
    DATA bind_quantity TYPE string.
    DATA bind_input51  TYPE string.
    DATA bind_input52  TYPE string.

    bind_input31 = client->_bind( val = input31 path = abap_true ).
    bind_input32 = client->_bind( val = input32 path = abap_true ).
    bind_quantity = client->_bind( val = quantity path = abap_true ).
    bind_input51  = client->_bind( val = input51 path = abap_true ).
    bind_input52  = client->_bind( val = input52 path = abap_true ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(form) = view->shell(
        )->page(
            title          = `abap2UI5 - Binding Syntax`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
        )->simple_form(
            title    = `Binding Syntax`
            editable = abap_true
        )->content( `form` ).

    form->title( `Expression Binding`
        )->label( `Documentation`
        )->link(
            text = `Expression Binding`
            href = `https://sapui5.hana.ondemand.com/sdk/#/topic/daf6852a04b44d118963968a1239d2c0`
        )->label( `input in uppercase`
        )->input( client->_bind( input2 )
        )->input(
            value   = |\{= ${ client->_bind( input2 ) }.toUpperCase() \}|
            enabled = abap_false
        )->label( `max value of the first two inputs`
        )->input(
            `{ type : "sap.ui.model.type.Integer",` &&
            `  path:"` && bind_input31 && `" }`
        )->input(
            `{ type : "sap.ui.model.type.Integer",` && |\n| &&
            `  path:"` && bind_input32 && `" }`
        )->input(
            value   = |\{= Math.max(${ client->_bind( input31 ) }, ${ client->_bind( input32 ) }) \}|
            enabled = abap_false
        )->label( `only enabled when the quantity equals 500`
        )->input(
            `{ type : "sap.ui.model.type.Integer",` &&
            `  path:"` && bind_quantity && `" }`
        )->input(
            value   = product
            enabled = |\{= 500===${ client->_bind( quantity ) } \}|
        )->label( `RegExp Set to enabled if the input contains VIP, ignoring the case.`
        )->input( client->_bind( input41 )
        )->button(
            text    = `VIP`
            enabled = |\{= RegExp('vip', 'i').test(${ client->_bind( input41 ) }) \}|
        )->label( `concatenate both inputs`
        )->input( client->_bind( input51 )
        )->input( client->_bind( input52 )
        )->input(
            value   = `{ parts: [` && |\n| &&
                      `                "` && bind_input51 && `",` && |\n| &&
                      `                "` && bind_input52 && `"` && |\n| &&
                      `               ]  }`
            enabled = abap_false ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
