CLASS z2ui5_cl_smp_app_094 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_01,
        input TYPE string,
        BEGIN OF ty_s_02,
          input TYPE string,
          BEGIN OF ty_s_03,
            input TYPE string,
            BEGIN OF ty_s_04,
              input TYPE string,
            END OF ty_s_04,
          END OF ty_s_03,
        END OF ty_s_02,
      END OF ty_s_01.
    DATA ms_screen TYPE ty_s_01.
    DATA mr_input  TYPE REF TO data.
    DATA mr_screen TYPE REF TO data.
    DATA mo_app    TYPE REF TO z2ui5_cl_smp_app_094.
    DATA mv_val    TYPE string.

    METHODS on_init.
    METHODS view_build.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_094 IMPLEMENTATION.

  METHOD on_init.

    FIELD-SYMBOLS <input> TYPE any.
    FIELD-SYMBOLS <screen> TYPE ty_s_01.

    ms_screen-input = `structure level 01 - working`.

    CREATE DATA mr_input TYPE string.
    ASSIGN mr_input->* TO <input>.

    <input> = `ref data - working`.

    CREATE DATA mr_screen TYPE ty_s_01.
    ASSIGN mr_screen->* TO <screen>.

    <screen>-input = `ref data struc - working`.

    ms_screen-ty_s_02-input = `struc deep dissolve - working`.

    ms_screen-ty_s_02-ty_s_03-ty_s_04-input = `struc deep switch guid name - working`.

    mo_app = NEW #( ).
    mo_app->mv_val = `instance attribute val - working`.
    mo_app->ms_screen-input = `instance attribute struc - working`.

  ENDMETHOD.


  METHOD view_build.

    FIELD-SYMBOLS <input> TYPE any.
    FIELD-SYMBOLS <screen> TYPE ty_s_01.
    ASSIGN mr_input->* TO <input>.

    ASSIGN mr_screen->* TO <screen>.

    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `test`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    DATA(o_grid) = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout` ).

    DATA(content) = o_grid->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title` v = `Input`
        )->ele( n = `content` ns = `form` ).

    content->tag( `Label`
        )->a( n = `text` v = `structure level 01`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( ms_screen-input )
        )->tag( `Label`
            )->a( n = `text` v = `ref data`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( <input> )
        )->tag( `Label`
            )->a( n = `text` v = `ref data struc field`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( <screen>-input )
        )->tag( `Label`
            )->a( n = `text` v = `struc deep dissolve`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( ms_screen-ty_s_02-input )
        )->tag( `Label`
            )->a( n = `text` v = `struc deep switch guid name`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( ms_screen-ty_s_02-ty_s_03-ty_s_04-input )
        )->tag( `Label`
            )->a( n = `text` v = `instance attribute val`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( mo_app->mv_val )
        )->tag( `Label`
            )->a( n = `text` v = `instance attribute struc`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( mo_app->ms_screen-input ) ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                " abap2ui5lint-disable-next-line event-without-handler -- internal test app
                )->a( n = `press` v = client->_event( `BUTTON_DELETE` )
                )->a( n = `text`  v = `Delete`
                )->a( n = `icon`  v = `sap-icon://delete`
                )->a( n = `type`  v = `Reject`
            )->tag( `Button`
                " abap2ui5lint-disable-next-line event-without-handler -- internal test app
                )->a( n = `press` v = client->_event( `BUTTON_ADD` )
                )->a( n = `text`  v = `Add`
                )->a( n = `icon`  v = `sap-icon://add`
                )->a( n = `type`  v = `Default`
            )->tag( `Button`
                " abap2ui5lint-disable-next-line event-without-handler -- internal test app
                )->a( n = `press` v = client->_event( `BUTTON_SAVE` )
                )->a( n = `text`  v = `Save`
                )->a( n = `type`  v = `Accept` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_build( ).

    ENDIF.

    view_build( ).
    client->message_toast_display( `server roundtrip` ).

  ENDMETHOD.

ENDCLASS.
