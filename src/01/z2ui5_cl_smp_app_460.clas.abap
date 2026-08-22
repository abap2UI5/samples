" @keywords hierarchy nodes nested json items
" @summary A nested ABAP table rendered as a sap.m.Tree - the hierarchy comes from the data, not from the view.
" @docs https://abap2ui5.github.io/docs/cookbook/model/trees
CLASS z2ui5_cl_smp_app_460 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level3,
        text TYPE string,
      END OF ty_s_node_level3,
      ty_t_node_level3 TYPE STANDARD TABLE OF ty_s_node_level3 WITH DEFAULT KEY,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        nodes TYPE ty_t_node_level3,
      END OF ty_s_node_level2,
      ty_t_node_level2 TYPE STANDARD TABLE OF ty_s_node_level2 WITH DEFAULT KEY,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        nodes TYPE ty_t_node_level2,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_460 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_nodes.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_smp_app_460=>ty_t_node_level2.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp7 TYPE z2ui5_cl_smp_app_460=>ty_t_node_level3.
      DATA temp8 LIKE LINE OF temp7.
      DATA temp9 TYPE z2ui5_cl_smp_app_460=>ty_t_node_level3.
      DATA temp10 LIKE LINE OF temp9.
      DATA temp5 TYPE z2ui5_cl_smp_app_460=>ty_t_node_level2.
      DATA temp6 LIKE LINE OF temp5.
      DATA temp11 TYPE z2ui5_cl_smp_app_460=>ty_t_node_level3.
      DATA temp12 LIKE LINE OF temp11.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-text = `Documents`.
      
      CLEAR temp3.
      
      temp4-text = `Projects`.
      
      CLEAR temp7.
      
      temp8-text = `Roadmap.docx`.
      INSERT temp8 INTO TABLE temp7.
      temp8-text = `Budget.xlsx`.
      INSERT temp8 INTO TABLE temp7.
      temp4-nodes = temp7.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `Reports`.
      
      CLEAR temp9.
      
      temp10-text = `Q1.pdf`.
      INSERT temp10 INTO TABLE temp9.
      temp10-text = `Q2.pdf`.
      INSERT temp10 INTO TABLE temp9.
      temp4-nodes = temp9.
      INSERT temp4 INTO TABLE temp3.
      temp2-nodes = temp3.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `Pictures`.
      
      CLEAR temp5.
      
      temp6-text = `Vacation`.
      
      CLEAR temp11.
      
      temp12-text = `Beach.jpg`.
      INSERT temp12 INTO TABLE temp11.
      temp6-nodes = temp11.
      INSERT temp6 INTO TABLE temp5.
      temp2-nodes = temp5.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `Music`.
      INSERT temp2 INTO TABLE temp1.
      t_nodes = temp1.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Tree - Nested ABAP Table in a sap.m.Tree`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A nested ABAP table (three levels of NODES) serializes into nested JSON arrays; ` &&
                   `sap.m.Tree binds them directly - no flattening, no extra code.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `Tree`
        )->a( n = `id`         v = `tree1`
        )->a( n = `items`      v = client->_bind( t_nodes )
        )->a( n = `headerText` v = `Files`
        )->tag( `StandardTreeItem`
            )->a( n = `title` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
