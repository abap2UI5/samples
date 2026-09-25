" @keywords template repeat runtime generated nested nest_view_display
" @summary XML templating inside a nested view: the generated content is built where the sub view is rendered.
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
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        fname   TYPE string,
        title   TYPE string,
        merge   TYPE string,
        visible TYPE string,
        binding TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

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

    me->client = client.
    IF client->check_on_init( ).

      mt_data = VALUE #( ( name = `Theo` date = `01.01.2000` age = `5` )
                        ( name = `Lore` date = `01.01.2000` age = `1` ) ).

      mt_layout = VALUE #( ( fname = `NAME` title = `Name` merge = `false` visible = `true`  binding = `{NAME}` )
                          ( fname = `DATE` title = `Date` merge = `false` visible = `true`  binding = `{DATE}` )
                          ( fname = `AGE`  title = `Age`  merge = `false` visible = `false` binding = `{AGE}` ) ).

      view_display( ).
      nest_view_display( ).

    ELSEIF client->check_on_navigated( ).

      view_display( ).
      nest_view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`   v = `true`
            )->a( n = `height`         v = `100%`
            )->a( n = `xmlns`          v = `sap.m`
            )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`     v = `sap.ui.core` ).

    DATA(page) = lo_view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Templating - Dynamic Content in a Nested View`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `test` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample renders a main view and then embeds a second view into it as ` &&
                   `nested content via nest_view_display; the nested table builds its columns and cells ` &&
                   `at runtime with template:repeat over a layout table.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.


  METHOD nest_view_display.

    " the template model is the view model, so the list the repeat runs over
    " is a bound attribute - its path is composed from the bind call, never
    " written by hand
    DATA(layout_path) = |\{template>{ client->_bind( val = mt_layout path = abap_true ) }\}|.

    DATA(lo_view_nested) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`   v = `true`
            )->a( n = `height`         v = `100%`
            )->a( n = `xmlns`          v = `sap.m`
            )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`     v = `sap.ui.core`
            )->a( n = `xmlns:template` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1` ).

    lo_view_nested->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title` v = `Nested View`
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

    client->nest_view_display( val = lo_view_nested->stringify( ) id = `test` method_insert = `addContent` ).

  ENDMETHOD.

ENDCLASS.
