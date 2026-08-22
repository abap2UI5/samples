" @keywords template repeat runtime generated columns if then else
" @summary Builds the columns of a table at runtime with template:repeat, including the if/then/else the templating language brings.
" @docs https://abap2ui5.github.io/docs/cookbook/view/xml_templating
CLASS z2ui5_cl_smp_app_173 DEFINITION PUBLIC.

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
        merge   TYPE string,
        visible TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH DEFAULT KEY.

    DATA mv_flag TYPE abap_bool.
    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_173 IMPLEMENTATION.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`   v = `true`
            )->a( n = `height`         v = `100%`
            )->a( n = `xmlns`          v = `sap.m`
            )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`     v = `sap.ui.core`
            )->a( n = `xmlns:template` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1` ).

    view           = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Templating - Build Columns Dynamically (template:repeat)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `id`             v = `page_main` ).

    view->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample builds table columns and cells dynamically from a layout table ` &&
                   `using template repeat, plus a template if/then/else that re-renders on a switch.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    view->ele( `Table`
        )->a( n = `items` v = client->_bind( mt_data )
        )->ele( `columns`
            )->ele( n = `repeat` ns = `template`
                )->a( n = `list` v = `{template>/MT_LAYOUT}`
                )->a( n = `var`  v = `L0`
                )->ele( `Column`
                    )->a( n = `mergeDuplicates` v = `{L0>MERGE}`
                    )->a( n = `visible`         v = `{L0>VISIBLE}`
                    )->tag( `Text`
                        )->a( n = `text` v = `{L0>FNAME}`
                )->end(
            )->end(
        )->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->ele( `cells`
                    )->ele( n = `repeat` ns = `template`
                        )->a( n = `list` v = `{template>/MT_LAYOUT}`
                        )->a( n = `var`  v = `L1`
                        )->ele( `ObjectIdentifier`
                            )->a( n = `text` v = `{= '{' + ${L1>FNAME} + '}' }` ).

    view->tag( `Label`
        )->a( n = `text` v = `IF Template (with re-rendering)` ).
    view->tag( `Switch`
        )->a( n = `state`  v = client->_bind( mv_flag )
        )->a( n = `change` v = client->_event( `CHANGE_FLAG` ) ).
                  view   = view->ele( `VBox` ).

    view->ele( n = `if` ns = `template`
        )->a( n = `test` v = `{template>/MV_FLAG}`
        )->ele( n = `then` ns = `template`
            )->tag( n = `Icon` ns = `core`
                )->a( n = `color` v = `green`
                )->a( n = `src`   v = `sap-icon://accept`
        )->end(
        )->ele( n = `else` ns = `template`
            )->tag( n = `Icon` ns = `core`
                )->a( n = `color` v = `red`
                )->a( n = `src`   v = `sap-icon://decline` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_smp_app_173=>ty_t_data.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_smp_app_173=>ty_t_layout.
      DATA temp4 LIKE LINE OF temp3.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      client->_bind( mt_layout ).

      
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
      temp4-merge = `false`.
      temp4-visible = `true`.
      INSERT temp4 INTO TABLE temp3.
      temp4-fname = `DATE`.
      temp4-merge = `false`.
      temp4-visible = `true`.
      INSERT temp4 INTO TABLE temp3.
      temp4-fname = `AGE`.
      temp4-merge = `false`.
      temp4-visible = `false`.
      INSERT temp4 INTO TABLE temp3.
      mt_layout = temp3.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

    IF client->get_event( ) = `CHANGE_FLAG`.
      view_display( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
