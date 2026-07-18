CLASS z2ui5_cl_demo_app_460 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_460 IMPLEMENTATION.

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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Tree - nested model`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `A nested ABAP table (three levels of NODES) serializes into nested JSON arrays; ` &&
                   `sap.m.Tree binds them directly - no flattening, no extra code.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->tree( id         = `tree1`
                headertext = `Files`
                items      = client->_bind_edit( t_nodes )
        )->standard_tree_item( title = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
