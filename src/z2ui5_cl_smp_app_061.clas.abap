" @keywords generic data reference create data ddic dynamic itab rtti handle selkz
" @summary The row type is built at runtime from a DDIC name plus a SELKZ selection flag (RTTI, TYPE HANDLE), and the generic data reference is bound straight into the view - editable, multi-selectable, and it survives the roundtrip back to ABAP.
" @docs https://abap2ui5.github.io/docs/cookbook/model/binding
CLASS z2ui5_cl_smp_app_061 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA t_tab TYPE REF TO data.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_061 IMPLEMENTATION.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Dynamic Table Typed at Runtime (RTTI)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    FIELD-SYMBOLS <tab> TYPE table.
    ASSIGN t_tab->* TO <tab>.

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A table typed dynamically at runtime via RTTI from a DDIC table type, with editable ` &&
                   `multi-select rows bound directly to the dynamically created data. The row type gets an extra ` &&
                   `SELKZ component at runtime, and the selection is bound to it - so it survives the roundtrip.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
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

    me->client = client.

    IF client->check_on_init( ).

      " The point of this sample is a row type built at runtime from a DDIC
      " name; it needs SOME table that is present on every abap2UI5 system,
      " and the framework ships no RELEASED DDIC object to use instead. Reading
      " the draft table is not the lesson here - the dynamic typing is.
      " abap2ui5lint-disable non-released-api
      DATA(row_type) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( `Z2UI5_T_01` ) ).

      " the DDIC components plus a SELKZ flag that exists in no dictionary:
      " the Table's selection binds to it, so a selected row stays selected
      " across roundtrips and re-renders instead of living in the control
      DATA(components) = row_type->get_components( ).
      INSERT VALUE #( name = `SELKZ`
                      type = CAST #( cl_abap_typedescr=>describe_by_name( `ABAP_BOOL` ) ) ) INTO TABLE components.
      DATA(tab_type) = cl_abap_tabledescr=>create( cl_abap_structdescr=>create( components ) ).

      CREATE DATA t_tab TYPE HANDLE tab_type.
      ASSIGN t_tab->* TO <tab>.

      DATA(entry) = VALUE z2ui5_t_01( id = `this is an uuid` timestampl = `20230823124303.1234567` id_prev = `previous` ).
      DO 3 TIMES.
        APPEND INITIAL LINE TO <tab> ASSIGNING FIELD-SYMBOL(<row>).
        MOVE-CORRESPONDING entry TO <row>.
      ENDDO.
      " abap2ui5lint-enable non-released-api

      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
