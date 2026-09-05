" @keywords formatter parts conditional regexp visible enabled syntax
" @summary Expression binding in the view - conditions, composite parts and a regular expression decide visible and enabled without asking the backend.
" @docs https://abap2ui5.github.io/docs/cookbook/model/expression_binding
CLASS z2ui5_cl_smp_app_027 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_027 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      product  = `tomato`.
      quantity = `500`.
      input41  = `faasdfdfsaVIp`.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA bind_input31 TYPE string.
    DATA bind_input32 TYPE string.
    DATA bind_quantity TYPE string.
    DATA bind_input51  TYPE string.
    DATA bind_input52  TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.

    bind_input31  = client->_bind( val = input31 path = abap_true ).
    bind_input32  = client->_bind( val = input32 path = abap_true ).
    bind_quantity = client->_bind( val = quantity path = abap_true ).
    bind_input51  = client->_bind( val = input51 path = abap_true ).
    bind_input52  = client->_bind( val = input52 path = abap_true ).

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Expression Binding, Types and Composite Parts`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Advanced binding syntax: expression binding, typed bindings, conditional enabling ` &&
                   `with RegExp checks, and composite (parts) bindings.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Binding Syntax`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    form->tag( `Title`
        )->a( n = `text` v = `Expression Binding`
        )->tag( `Label`
            )->a( n = `text` v = `Documentation`
        )->tag( `Link`
            )->a( n = `text` v = `Expression Binding`
            )->a( n = `href` v = `https://sdk.openui5.org/topic/daf6852a04b44d118963968a1239d2c0`
        )->tag( `Label`
            )->a( n = `text` v = `input in uppercase`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( input2 )
        )->tag( `Input`
            )->a( n = `enabled` b = abap_false
            )->a( n = `value`   v = |\{= ${ client->_bind( input2 ) }.toUpperCase() \}|
        )->tag( `Label`
            )->a( n = `text` v = `max value of the first two inputs`
        )->tag( `Input`
            )->a( n = `value` v = `{ type : "sap.ui.model.type.Integer",` &&
            `  path:"` && bind_input31 && `" }`
        )->tag( `Input`
            )->a( n = `value` v = `{ type : "sap.ui.model.type.Integer",` && |\n| &&
            `  path:"` && bind_input32 && `" }`
        )->tag( `Input`
            )->a( n = `enabled` b = abap_false
            )->a( n = `value`   v = |\{= Math.max(${ client->_bind( input31 ) }, ${ client->_bind( input32 ) }) \}|
        )->tag( `Label`
            )->a( n = `text` v = `only enabled when the quantity equals 500`
        )->tag( `Input`
            )->a( n = `value` v = `{ type : "sap.ui.model.type.Integer",` &&
            `  path:"` && bind_quantity && `" }`
        )->tag( `Input`
            )->a( n = `enabled` v = |\{= 500===${ client->_bind( quantity ) } \}|
            )->a( n = `value`   v = product
        )->tag( `Label`
            )->a( n = `text` v = `RegExp Set to enabled if the input contains VIP, ignoring the case.`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( input41 )
        )->tag( `Button`
            )->a( n = `text`    v = `VIP`
            )->a( n = `enabled` v = |\{= RegExp('vip', 'i').test(${ client->_bind( input41 ) }) \}|
        )->tag( `Label`
            )->a( n = `text` v = `concatenate both inputs`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( input51 )
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( input52 )
        )->tag( `Input`
            )->a( n = `enabled` b = abap_false
            )->a( n = `value`   v = `{ parts: [` && |\n| &&
                      `                "` && bind_input51 && `",` && |\n| &&
                      `                "` && bind_input52 && `"` && |\n| &&
                      `               ]  }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
