" @keywords binding json string spliced model node object array pre-serialized _bind json = abap_true no abap type
" @summary A string that already holds JSON is spliced into the model as a node instead of a quoted string - a list bound to an array nobody declared an ABAP type for.
"! Every bound value is serialized from its ABAP type. A string that
"! already CONTAINS JSON - read from a table column, returned by a service,
"! written by hand - would arrive as one quoted string. `_bind( val = x
"! json = abap_true )` splices it into the model as a JSON node instead, so
"! a list binds to the array and a text to a member, and no ABAP structure
"! has to mirror keys that may not even be valid ABAP names. Outbound only:
"! the client sends nothing back into that node.
CLASS z2ui5_cl_smp_app_509 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA products_json TYPE string.
    DATA config_json   TYPE string.
    DATA products_raw  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_509 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      " what a service or a JSON column would hand over: an array with keys
      " no ABAP type declares, and an object with a key (`sap.app`) that no
      " ABAP component could even be named after
      products_json = `[ { "name": "Notebook 15\"", "price": 1299, "tags": "hardware, mobile" },` &&
                      ` { "name": "USB-C Dock", "price": 189, "tags": "accessories" },` &&
                      ` { "name": "Headset", "price": 79, "tags": "audio, accessories" } ]`.
      config_json   = `{ "title": "Products from JSON", "sap.app": { "id": "z2ui5.demo", "version": "1.0.0" } }`.
      products_raw  = products_json.
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the bare path of the spliced object, so the view can reach into it
    DATA(config_path) = client->_bind( val  = config_json
                                       json = abap_true
                                       path = abap_true ).

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Pre-serialized JSON (json)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Two strings hold JSON the app never parsed. Bound with json = abap_true they become ` &&
                   `model nodes: the list binds to the array, the title reads a member of the object - even ` &&
                   `one called sap.app. The same string bound the ordinary way arrives as text, which is ` &&
                   `what the last field shows.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Spliced in as JSON`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `a member of the object - its title` ).
    form->tag( `Text`
        )->a( n = `text` v = |\{{ config_path }/title\}| ).

    form->tag( `Label`
        )->a( n = `text` v = `a key no ABAP component could carry - sap.app/id` ).
    form->tag( `Text`
        )->a( n = `text` v = |\{{ config_path }/sap.app/id\} version \{{ config_path }/sap.app/version\}| ).

    form->tag( `Label`
        )->a( n = `text` v = `the array, as an aggregation binding` ).
    form->ele( `List`
        )->a( n = `items` v = client->_bind( val  = products_json
                                             json = abap_true )
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{name}`
            )->a( n = `description` v = `{tags}`
            )->a( n = `info`        v = `{price} EUR` ).

    form->tag( `Label`
        )->a( n = `text` v = `the same string, bound without json - one quoted string` ).
    form->tag( `TextArea`
        )->a( n = `value`    v = client->_bind( products_raw )
        )->a( n = `editable` b = abap_false
        )->a( n = `rows`     v = `4`
        )->a( n = `width`    v = `100%` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
