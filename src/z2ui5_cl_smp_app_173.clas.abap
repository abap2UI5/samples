" @keywords xml templating xmlpreprocessor template:repeat template:if template:elseif template:with meta model metamodel metadata driven dynamic columns form nested repeat startindex length
" @summary XML templating driven by a meta model: table columns built with template:repeat, a form generated from a field catalogue with nested template:repeat, template:with and template:if/elseif/else, and a template:if that re-renders on a switch.
" @docs https://abap2ui5.github.io/docs/cookbook/view/xml_templating
"! The view is expanded by the UI5 XMLPreprocessor before its controls exist.
"! Its input is a meta model: data ABOUT the view - which columns a table has,
"! which fields a form has and of which type - instead of the data it shows.
"! A UI5 app would hand the preprocessor an OData meta model; here the meta
"! model is plain ABAP data, bound like any attribute and read under the
"! template> model name. The rows the controls then display stay ordinary
"! runtime bindings against the default model.
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

    TYPES:
      BEGIN OF ty_s_field,
        name  TYPE string,
        label TYPE string,
        type  TYPE string,
      END OF ty_s_field,
      ty_t_field TYPE STANDARD TABLE OF ty_s_field WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_group,
        title   TYPE string,
        t_field TYPE ty_t_field,
      END OF ty_s_group,
      ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_meta,
        entity  TYPE string,
        t_group TYPE ty_t_group,
      END OF ty_s_meta.

    TYPES:
      BEGIN OF ty_s_detail,
        name   TYPE string,
        date   TYPE string,
        city   TYPE string,
        age    TYPE i,
        active TYPE abap_bool,
      END OF ty_s_detail.

    DATA mv_flag   TYPE abap_bool.
    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.
    DATA ms_meta   TYPE ty_s_meta.
    DATA ms_detail TYPE ty_s_detail.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_173 IMPLEMENTATION.


  METHOD view_display.

    " the template model is the view model, so what the repeat, the with and
    " the if read are bound attributes - their paths are composed from the
    " bind call, never written by hand
    DATA layout_path TYPE string.
    DATA flag_path TYPE string.
    DATA meta_path TYPE string.
    DATA detail_path TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA field TYPE REF TO z2ui5_cl_ui5_view_builder.
    layout_path = |\{template>{ client->_bind( val = mt_layout path = abap_true ) }\}|.
    
    flag_path   = |\{template>{ client->_bind( val = mv_flag path = abap_true ) }\}|.
    
    meta_path   = |template>{ client->_bind( val = ms_meta path = abap_true ) }|.
    
    detail_path = |\{{ client->_bind( val = ms_detail path = abap_true ) }\}|.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`   v = `true`
            )->a( n = `height`         v = `100%`
            )->a( n = `xmlns`          v = `sap.m`
            )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`     v = `sap.ui.core`
            )->a( n = `xmlns:form`     v = `sap.ui.layout.form`
            )->a( n = `xmlns:template` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1` ).

    view           = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Templating - Metadata-Driven Table and Form`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `id`             v = `page_main` ).

    view->tag( `MessageStrip`
        )->a( n = `text`     v = `XML templating expands the view from a meta model before any control exists: ` &&
                   `the table columns come from a layout table (template:repeat), the form from a field catalogue ` &&
                   `(template:with, nested template:repeat, template:if/elseif/else), and the icon below re-renders on the switch.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " 1 - columns and cells from the layout table
    view->tag( `Title`
        )->a( n = `text`  v = `Table - columns from a layout table (template:repeat)`
        )->a( n = `class` v = `sapUiSmallMarginTop` ).

    view->ele( `Table`
        )->a( n = `items` v = client->_bind( mt_data )
        )->ele( `columns`
            )->ele( n = `repeat` ns = `template`
                )->a( n = `list` v = layout_path
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
                        )->a( n = `list` v = layout_path
                        )->a( n = `var`  v = `L1`
                        )->ele( `ObjectIdentifier`
                            )->a( n = `text` v = `{= '{' + ${L1>FNAME} + '}' }` ).

    " 2 - a form from the field catalogue of the meta model. template:with
    " gives the meta model a short name, the outer repeat builds one title
    " per group, the inner repeat one label and one control per field, and
    " the if/elseif/else picks the control from the field's type
    view->tag( `Title`
        )->a( n = `text`  v = `Form - fields from a meta model (template:with, nested repeat, if/elseif/else)`
        )->a( n = `class` v = `sapUiMediumMarginTop` ).

    
    box = view->ele( n = `with` ns = `template`
        )->a( n = `path` v = meta_path
        )->a( n = `var`  v = `meta`
        )->ele( `VBox`
            )->a( n = `binding` v = detail_path ).

    " startIndex and length cut the list - the header shows the first two
    " fields of the first group only
    box->ele( `ObjectHeader`
        )->a( n = `title` v = `{meta>ENTITY}`
        )->ele( `attributes`
            )->ele( n = `repeat` ns = `template`
                )->a( n = `list` v = `{path: 'meta>T_GROUP/0/T_FIELD', startIndex: 0, length: 2}`
                )->a( n = `var`  v = `head`
                )->tag( `ObjectAttribute`
                    )->a( n = `title` v = `{head>LABEL}`
                    )->a( n = `text`  v = `{= '{' + ${head>NAME} + '}' }` ).

    
    field = box->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->a( n = `layout`   v = `ResponsiveGridLayout`
        )->ele( n = `content` ns = `form`
            )->ele( n = `repeat` ns = `template`
                )->a( n = `list` v = `{meta>T_GROUP}`
                )->a( n = `var`  v = `group`
                )->tag( n = `Title` ns = `core`
                    )->a( n = `text` v = `{group>TITLE}`
                )->ele( n = `repeat` ns = `template`
                    )->a( n = `list` v = `{group>T_FIELD}`
                    )->a( n = `var`  v = `field` ).

    field->tag( `Label`
        )->a( n = `text` v = `{field>LABEL}` ).

    field->ele( n = `if` ns = `template`
        )->a( n = `test` v = `{= ${field>TYPE} === 'BOOLEAN' }`
        )->ele( n = `then` ns = `template`
            )->tag( `Switch`
                )->a( n = `state` v = `{= '{' + ${field>NAME} + '}' }`
        )->end(
        )->ele( n = `elseif` ns = `template`
            )->a( n = `test` v = `{= ${field>TYPE} === 'DATE' }`
            )->tag( `DatePicker`
                )->a( n = `value`       v = `{= '{' + ${field>NAME} + '}' }`
                )->a( n = `valueFormat` v = `yyyy-MM-dd`
        )->end(
        )->ele( n = `elseif` ns = `template`
            )->a( n = `test` v = `{= ${field>TYPE} === 'NUMBER' }`
            )->tag( `StepInput`
                )->a( n = `value` v = `{= '{' + ${field>NAME} + '}' }`
        )->end(
        )->ele( n = `else` ns = `template`
            )->tag( `Input`
                )->a( n = `value` v = `{= '{' + ${field>NAME} + '}' }` ).

    " 3 - an if on a bound flag, re-rendered by the switch
    view->tag( `Title`
        )->a( n = `text`  v = `IF Template (with re-rendering)`
        )->a( n = `class` v = `sapUiMediumMarginTop` ).
    view->tag( `Switch`
        )->a( n = `state`  v = client->_bind( mv_flag )
        )->a( n = `change` v = client->_event( `CHANGE_FLAG` ) ).
                  view   = view->ele( `VBox` ).

    view->ele( n = `if` ns = `template`
        )->a( n = `test` v = flag_path
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


  METHOD model_init.

    DATA temp1 TYPE z2ui5_cl_smp_app_173=>ty_t_data.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smp_app_173=>ty_t_layout.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smp_app_173=>ty_t_group.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smp_app_173=>ty_t_field.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smp_app_173=>ty_t_field.
    DATA temp10 LIKE LINE OF temp9.
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

    " the meta model - which fields the form has, in which group, of which
    " type. Reorder a field, move it to the other group or change its type
    " and the generated form follows, no view code changes
    CLEAR ms_meta.
    ms_meta-entity = `Person`.
    
    CLEAR temp5.
    
    temp6-title = `General`.
    
    CLEAR temp7.
    
    temp8-name = `NAME`.
    temp8-label = `Name`.
    temp8-type = `STRING`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `DATE`.
    temp8-label = `Birth Date`.
    temp8-type = `DATE`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `CITY`.
    temp8-label = `City`.
    temp8-type = `STRING`.
    INSERT temp8 INTO TABLE temp7.
    temp6-t_field = temp7.
    INSERT temp6 INTO TABLE temp5.
    temp6-title = `Details`.
    
    CLEAR temp9.
    
    temp10-name = `AGE`.
    temp10-label = `Age`.
    temp10-type = `NUMBER`.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `ACTIVE`.
    temp10-label = `Active`.
    temp10-type = `BOOLEAN`.
    INSERT temp10 INTO TABLE temp9.
    temp6-t_field = temp9.
    INSERT temp6 INTO TABLE temp5.
    ms_meta-t_group = temp5.

    CLEAR ms_detail.
    ms_detail-name = `Lore`.
    ms_detail-date = `2000-01-01`.
    ms_detail-city = `Walldorf`.
    ms_detail-age = 26.
    ms_detail-active = abap_true.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `CHANGE_FLAG` ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
