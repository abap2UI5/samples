" @keywords generic data reference create data ddic dynamic itab
" @summary Builds a table whose columns are only known at runtime: RTTI over a DDIC name, CREATE DATA, and the generic reference bound into the view.
" @docs https://abap2ui5.github.io/docs/cookbook/model/binding
CLASS z2ui5_cl_smp_app_061 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA t_tab TYPE REF TO data.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_view.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_061 IMPLEMENTATION.


  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    FIELD-SYMBOLS <tab> TYPE table.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Dynamic Table Typed at Runtime (RTTI)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    
    ASSIGN t_tab->* TO <tab>.

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A table typed dynamically at runtime via RTTI from a DDIC table type, with editable ` &&
                   `multi-select rows bound directly to the dynamically created data.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    tab = page->ele( `Table`
        )->a( n = `items` v = client->_bind( <tab> )
        )->a( n = `mode`  v = `MultiSelect`
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `Dynamic typed table`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    " abap2ui5lint-disable-next-line event-without-handler -- the roundtrip IS the demo: the runtime-typed table travels back and re-renders
                    )->a( n = `press` v = client->_event( `SEND` )
                    )->a( n = `text`  v = `server <-> client`
            )->end(
        )->end( ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `uuid`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `time`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `previous`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELKZ}`
            )->ele( `cells`
                )->tag( `Input`
                    )->a( n = `value` v = `{ID}`
                )->tag( `Input`
                    )->a( n = `value` v = `{TIMESTAMPL}`
                )->tag( `Input`
                    )->a( n = `value` v = `{ID_PREV}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <tab> TYPE table.
      DATA temp1 TYPE z2ui5_t_01.
      DATA temp2 TYPE z2ui5_t_01.
      DATA temp3 TYPE z2ui5_t_01.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      " The point of this sample is CREATE DATA over a DDIC name computed at
      " runtime; it needs SOME table that is present on every abap2UI5 system,
      " and the framework ships no RELEASED DDIC object to use instead. Reading
      " the draft table is not the lesson here - the dynamic typing is.
      " abap2ui5lint-disable non-released-api
      CREATE DATA t_tab TYPE STANDARD TABLE OF (`Z2UI5_T_01`).
      ASSIGN t_tab->* TO <tab>.

      
      CLEAR temp1.
      temp1-id = `this is an uuid`.
      temp1-timestampl = `2023234243`.
      temp1-id_prev = `previous`.
      INSERT temp1
        INTO TABLE <tab>.
      
      CLEAR temp2.
      temp2-id = `this is an uuid`.
      temp2-timestampl = `2023234243`.
      temp2-id_prev = `previous`.
      INSERT temp2
        INTO TABLE <tab>.
      
      CLEAR temp3.
      temp3-id = `this is an uuid`.
      temp3-timestampl = `2023234243`.
      temp3-id_prev = `previous`.
      INSERT temp3
        INTO TABLE <tab>.
      " abap2ui5lint-enable non-released-api

      set_view( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      set_view( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
