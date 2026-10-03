" @keywords xml templating xmlpreprocessor template:repeat meta model metamodel metadata driven dynamic columns nested view nest_view_display re-render refresh
" @summary XML templating inside a nested view: the columns come from a layout table via template:repeat, and a change to that table re-renders only the nested view with nest_view_display while the main view stays on screen.
" @docs https://abap2ui5.github.io/docs/cookbook/view/nested_views https://abap2ui5.github.io/docs/cookbook/view/xml_templating
CLASS z2ui5_cl_smp_app_176 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        date TYPE string,
        age  TYPE string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        fname   TYPE string,
        title   TYPE string,
        merge   TYPE string,
        visible TYPE string,
        binding TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH DEFAULT KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS nest_view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_176 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_smp_app_176=>ty_t_data.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_smp_app_176=>ty_t_layout.
      DATA temp4 LIKE LINE OF temp3.
      FIELD-SYMBOLS <age> TYPE z2ui5_cl_smp_app_176=>ty_s_layout.
      DATA temp5 TYPE z2ui5_cl_smp_app_176=>ty_s_layout-visible.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-name = `Theo`.
      temp2-date = `01.01.2000`.
      temp2-age = `5`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Lore`.
      temp2-date = `01.01.2000`.
      temp2-age = `1`.
      INSERT temp2 INTO TABLE temp1.
      mt_data = temp1.

      
      CLEAR temp3.
      
      temp4-fname = `NAME`.
      temp4-title = `Name`.
      temp4-merge = `false`.
      temp4-visible = `true`.
      temp4-binding = `{NAME}`.
      INSERT temp4 INTO TABLE temp3.
      temp4-fname = `DATE`.
      temp4-title = `Date`.
      temp4-merge = `false`.
      temp4-visible = `true`.
      temp4-binding = `{DATE}`.
      INSERT temp4 INTO TABLE temp3.
      temp4-fname = `AGE`.
      temp4-title = `Age`.
      temp4-merge = `false`.
      temp4-visible = `false`.
      temp4-binding = `{AGE}`.
      INSERT temp4 INTO TABLE temp3.
      mt_layout = temp3.

      view_display( ).
      nest_view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.

      view_display( ).
      nest_view_display( ).

    ELSEIF client->check_on_event( `TOGGLE_AGE` ) IS NOT INITIAL.

      " templating ran once, when the nested view was built - a changed
      " layout table only shows once the nested view is built again. The
      " main view is not sent, it stays on screen as it is
      
      READ TABLE mt_layout WITH KEY fname = `AGE` ASSIGNING <age>.
      
      IF <age>-visible = `true`.
        temp5 = `false`.
      ELSE.
        temp5 = `true`.
      ENDIF.
      <age>-visible = temp5.
      nest_view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA lo_view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    lo_view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    
    page = lo_view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Templating - Dynamic Content in a Nested View`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample renders a main view and then embeds a second view into it as ` &&
                   `nested content via nest_view_display; the nested table builds its columns and cells ` &&
                   `at runtime with template:repeat over a layout table. The button changes that table and ` &&
                   `re-renders only the nested view.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Button`
        )->a( n = `text`  v = `Show / Hide Age Column`
        )->a( n = `icon`  v = `sap-icon://refresh`
        )->a( n = `press` v = client->_event( `TOGGLE_AGE` )
        )->a( n = `class` v = `sapUiSmallMarginBegin` ).

    " the nested view goes into this box - a container of its own, so a
    " re-render replaces the nested view and nothing else on the page
    page->tag( `VBox`
        )->a( n = `id` v = `box_nest` ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.


  METHOD nest_view_display.

    " the template model is the view model, so the list the repeat runs over
    " is a bound attribute - its path is composed from the bind call, never
    " written by hand
    DATA layout_path TYPE string.
    DATA lo_view_nested TYPE REF TO z2ui5_cl_ui5_view_builder.
    layout_path = |\{template>{ client->_bind( val = mt_layout path = abap_true ) }\}|.

    
    lo_view_nested = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`   v = `true`
            )->a( n = `xmlns`          v = `sap.m`
            )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
            )->a( n = `xmlns:template` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1` ).

    lo_view_nested->ele( `Panel`
        )->a( n = `headerText` v = `Nested View`
        )->a( n = `class`      v = `sapUiSmallMarginTop`
        )->ele( `Table`
            )->a( n = `items` v = client->_bind( mt_data )
            )->ele( `columns`
                )->ele( n = `repeat` ns = `template`
                    )->a( n = `list` v = layout_path
                    )->a( n = `var`  v = `LO`
                    )->ele( `Column`
                        )->a( n = `mergeDuplicates` v = `{LO>MERGE}`
                        )->a( n = `visible`         v = `{LO>VISIBLE}`
                        )->tag( `Text`
                            )->a( n = `text` v = `{LO>TITLE}`
                    )->end(
                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->ele( `cells`
                        )->ele( n = `repeat` ns = `template`
                            )->a( n = `list` v = layout_path
                            )->a( n = `var`  v = `LO2`
                            )->ele( `ObjectIdentifier`
                                )->a( n = `text` v = `{= '{' + ${LO2>FNAME} + '}' }` ).

    client->nest_view_display( val            = lo_view_nested->stringify( )
                               id             = `box_nest`
                               method_insert  = `addItem`
                               method_destroy = `removeAllItems` ).

  ENDMETHOD.

ENDCLASS.
