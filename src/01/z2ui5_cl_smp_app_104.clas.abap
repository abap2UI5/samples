" @keywords sub app class embed instantiate another app rtti
CLASS z2ui5_cl_smp_app_104 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_s_row.

    DATA app_sub   TYPE REF TO object.
    DATA classname TYPE string.

    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA layout      TYPE string.
    DATA grid_sub    TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA view_nested TYPE REF TO z2ui5_cl_ui5_view_builder.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.
    METHODS on_event_sub.
    METHODS on_init_sub.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_104 IMPLEMENTATION.

  METHOD on_event_sub.

    IF app_sub IS BOUND.

      ASSIGN app_sub->(`VIEW_PARENT`) TO FIELD-SYMBOL(<fs>).
      <fs> = grid_sub.
      CALL METHOD app_sub->(`Z2UI5_IF_APP~MAIN`) EXPORTING client = client.

    ENDIF.

  ENDMETHOD.


  METHOD on_init_sub.

    classname = to_upper( classname ).
    CREATE OBJECT app_sub TYPE (classname).

    ASSIGN app_sub->(`VIEW_PARENT`) TO FIELD-SYMBOL(<fs>).
    <fs> = grid_sub.
    CALL METHOD app_sub->(`Z2UI5_IF_APP~MAIN`) EXPORTING client = client.

    " render explicitly: check_on_init( ) is the TOP app's lifecycle flag,
    " not the sub-app's - on this (SELCHANGE) roundtrip it is false, so the
    " sub-app's own main( ) would add nothing to the detail column
    CALL METHOD app_sub->(`VIEW_DISPLAY`).

  ENDMETHOD.


  METHOD view_display_detail.

    view_nested = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:layout` v = `sap.ui.layout`
            " the sub-apps build into this shared root, so their prefixes are
            " declared here - z2ui5_cl_smp_app_105 injects a form:SimpleForm
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    DATA(page) = view_nested->ele( `Page`
        )->a( n = `title` v = `Nested View` ).
    grid_sub = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L12 M12 S12`
        )->ele( n = `content` ns = `layout` ).

  ENDMETHOD.


  METHOD view_display_master.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:layout` v = `sap.ui.layout`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Nested View - Embed Another App's View`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Selecting a list row instantiates another abap2UI5 app by its class name and ` &&
                   `embeds that app's own view into the detail column.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(col_layout) = page->ele( n = `FlexibleColumnLayout` ns = `f`
        )->a( n = `layout` v = client->_bind( layout )
        )->a( n = `id`     v = `test` ).

    DATA(master) = col_layout->ele( n = `beginColumnPages` ns = `f` ).

    DATA(list) = master->ele( `List`
        )->a( n = `headerText`      v = `List Output`
        )->a( n = `items`           v = client->_bind( val = t_tab )
        )->a( n = `mode`            v = `SingleSelectMaster`
        )->a( n = `selectionChange` v = client->_event( val = `SELCHANGE` )
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `description` v = `{DESCR}`
            )->a( n = `icon`        v = `{ICON}`
            )->a( n = `info`        v = `{INFO}`
            )->a( n = `press`       v = client->_event( `TEST` )
            )->a( n = `selected`    v = `{SELECTED}` ).

    client->view_display( list->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_tab = VALUE #(
        ( title = `Class 1`  info = `z2ui5_cl_smp_app_105`   descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Class 2`  info = `z2ui5_cl_smp_app_112` descr = `this is a description` icon = `sap-icon://account` ) ).

      layout = `OneColumn`.
      view_display_master( ).
      view_display_detail( ).

    ELSEIF client->check_on_event( `SELCHANGE` ).

      DATA(t_sel) = t_tab.
      DELETE t_sel WHERE selected = abap_false.
      READ TABLE t_sel INTO DATA(s_sel) INDEX 1.

      IF classname IS NOT INITIAL.
        view_display_master( ).
      ENDIF.
      classname = s_sel-info.

      layout = `TwoColumnsMidExpanded`.
      view_display_detail( ).
      on_init_sub( ).

      client->nest_view_display(
        val            = view_nested->stringify( )
        id             = `test`
        method_insert  = `addMidColumnPage`
        method_destroy = `removeAllMidColumnPages` ).

    ENDIF.

    on_event_sub( ).

  ENDMETHOD.

ENDCLASS.
