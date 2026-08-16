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
      ty_t_node_level3 TYPE STANDARD TABLE OF ty_s_node_level3 WITH EMPTY KEY,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        nodes TYPE ty_t_node_level3,
      END OF ty_s_node_level2,
      ty_t_node_level2 TYPE STANDARD TABLE OF ty_s_node_level2 WITH EMPTY KEY,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        nodes TYPE ty_t_node_level2,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_460 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_nodes = VALUE #(
          ( text = `Documents` nodes = VALUE #(
              ( text = `Projects` nodes = VALUE #(
                  ( text = `Roadmap.docx` )
                  ( text = `Budget.xlsx` ) ) )
              ( text = `Reports` nodes = VALUE #(
                  ( text = `Q1.pdf` )
                  ( text = `Q2.pdf` ) ) ) ) )
          ( text = `Pictures` nodes = VALUE #(
              ( text = `Vacation` nodes = VALUE #(
                  ( text = `Beach.jpg` ) ) ) ) )
          ( text = `Music` ) ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
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
