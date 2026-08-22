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
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        fname   TYPE string,
        merge   TYPE string,
        visible TYPE string,
        binding TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH DEFAULT KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

    METHODS main_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.
    METHODS nest_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_176 IMPLEMENTATION.

  METHOD main_view.

    DATA lo_view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    lo_view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`   v = `true`
            )->a( n = `height`         v = `100%`
            )->a( n = `xmlns`          v = `sap.m`
            )->a( n = `xmlns:mvc`      v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`     v = `sap.ui.core`
            )->a( n = `xmlns:template` v = `http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1` ).

    
    page = lo_view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Templating - Dynamic Content in a Nested View`
            )->a( n = `showNavButton`  b = i_client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = i_client->_event_nav_app_leave( )
            )->a( n = `id`             v = `test` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample renders a main view and then embeds a second view into it as ` &&
                   `nested content via nest_view_display.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    i_client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.


  METHOD nest_view.
    DATA temp1 TYPE z2ui5_cl_smp_app_176=>ty_t_data.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_cl_smp_app_176=>ty_t_layout.
    DATA temp4 LIKE LINE OF temp3.
    DATA lo_view_nested TYPE REF TO z2ui5_cl_ui5_view_builder.

    i_client->_bind( mt_layout ).

    
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
    temp4-binding = `{NAME}`.
    INSERT temp4 INTO TABLE temp3.
    temp4-fname = `DATE`.
    temp4-merge = `false`.
    temp4-visible = `true`.
    temp4-binding = `{DATE}`.
    INSERT temp4 INTO TABLE temp3.
    temp4-fname = `AGE`.
    temp4-merge = `false`.
    temp4-visible = `false`.
    temp4-binding = `{AGE}`.
    INSERT temp4 INTO TABLE temp3.
    mt_layout = temp3.

    
    lo_view_nested = z2ui5_cl_ui5_view_builder=>factory(
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
                )->a( n = `items` v = i_client->_bind( mt_data )
                )->ele( `columns`
                    )->ele( n = `repeat` ns = `template`
                        )->a( n = `list` v = `{template>/MT_LAYOUT}`
                        )->a( n = `var`  v = `LO`
                        )->ele( `Column`
                            )->a( n = `mergeDuplicates` v = `{LO>MERGE}`
                            )->a( n = `visible`         v = `{LO>VISIBLE}`
                        )->end(
                    )->end(
                )->end(
                )->ele( `items`
                    )->ele( `ColumnListItem`
                        )->ele( `cells`
                            )->ele( n = `repeat` ns = `template`
                                )->a( n = `list` v = `{template>/MT_LAYOUT}`
                                )->a( n = `var`  v = `LO2`
                                )->ele( `ObjectIdentifier`
                                    )->a( n = `text` v = `{= '{' + ${LO2>FNAME} + '}' }` ).

    i_client->nest_view_display( val           = lo_view_nested->stringify( )
                                 id            = `test`
                                 method_insert = `addContent` ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    main_view( client ).
    nest_view( client ).

  ENDMETHOD.

ENDCLASS.
