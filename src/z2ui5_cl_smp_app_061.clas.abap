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

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    FIELD-SYMBOLS <tab> TYPE table.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Dynamic Table Typed at Runtime (RTTI)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    
    ASSIGN t_tab->* TO <tab>.

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A table typed dynamically at runtime via RTTI from a DDIC table type, with editable ` &&
                   `multi-select rows bound directly to the dynamically created data. The row type gets an extra ` &&
                   `SELKZ component at runtime, and the selection is bound to it - so it survives the roundtrip.`
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
                )->a( n = `text` v = `user`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `date`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `time`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELKZ}`
            )->ele( `cells`
                )->tag( `Input`
                    )->a( n = `value` v = `{UNAME}`
                )->tag( `Input`
                    )->a( n = `value` v = `{DATUM}`
                )->tag( `Input`
                    )->a( n = `value` v = `{UZEIT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <tab> TYPE table.
      DATA temp1 TYPE REF TO cl_abap_structdescr.
      DATA row_type LIKE temp1.
      DATA components TYPE abap_component_tab.
      DATA temp2 TYPE abap_componentdescr.
      DATA temp3 TYPE REF TO cl_abap_datadescr.
      DATA tab_type TYPE REF TO cl_abap_tabledescr.
        FIELD-SYMBOLS <row> LIKE LINE OF <tab>.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      " The point of this sample is a row type built at runtime from a DDIC
      " name. SYST - the structure behind sy - is present on every release
      " abap2UI5 runs on, ABAP Cloud included; the framework's own draft table
      " is not an API (building-apps guide, section 5) and is not used here.
      
      temp1 ?= cl_abap_typedescr=>describe_by_name( `SYST` ).
      
      row_type = temp1.

      " the DDIC components plus a SELKZ flag that exists in no dictionary:
      " the Table's selection binds to it, so a selected row stays selected
      " across roundtrips and re-renders instead of living in the control
      
      components = row_type->get_components( ).
      
      CLEAR temp2.
      temp2-name = `SELKZ`.
      
      temp3 ?= cl_abap_typedescr=>describe_by_name( `ABAP_BOOL` ).
      temp2-type = temp3.
      INSERT temp2 INTO TABLE components.
      
      tab_type = cl_abap_tabledescr=>create( cl_abap_structdescr=>create( components ) ).

      CREATE DATA t_tab TYPE HANDLE tab_type.
      ASSIGN t_tab->* TO <tab>.

      " sy IS a SYST, so the rows are filled by component name - the only
      " way to write a structure whose type exists at runtime alone
      DO 3 TIMES.
        
        APPEND INITIAL LINE TO <tab> ASSIGNING <row>.
        MOVE-CORRESPONDING sy TO <row>.
      ENDDO.

      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
