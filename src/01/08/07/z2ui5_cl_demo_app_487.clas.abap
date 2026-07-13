"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.Tree
"! Tree displays data in hierarchical structure.
CLASS z2ui5_cl_demo_app_487 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level5,
        text TYPE string,
        ref  TYPE string,
      END OF ty_s_node_level5,
      BEGIN OF ty_s_node_level4,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level5 WITH DEFAULT KEY,
      END OF ty_s_node_level4,
      BEGIN OF ty_s_node_level3,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level4 WITH DEFAULT KEY,
      END OF ty_s_node_level3,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level3 WITH DEFAULT KEY,
      END OF ty_s_node_level2,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        ref   TYPE string,
        nodes TYPE STANDARD TABLE OF ty_s_node_level2 WITH DEFAULT KEY,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_487 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_nodes = VALUE #(
        ( text  = `Node1`
          ref   = `sap-icon://attachment-audio`
          nodes = VALUE #(
              ( text  = `Node1-1`
                ref   = `sap-icon://attachment-e-pub`
                nodes = VALUE #(
                    ( text = `Node1-1-1`
                      ref  = `sap-icon://attachment-html` )
                    ( text  = `Node1-1-2`
                      ref   = `sap-icon://attachment-photo`
                      nodes = VALUE #(
                          ( text  = `Node1-1-2-1`
                            ref   = `sap-icon://attachment-text-file`
                            nodes = VALUE #(
                                ( text = `Node1-1-2-1-1`
                                  ref  = `sap-icon://attachment-video` )
                                ( text = `Node1-1-2-1-2`
                                  ref  = `sap-icon://attachment-zip-file` )
                                ( text = `Node1-1-2-1-3`
                                  ref  = `sap-icon://course-program` ) ) ) ) ) ) )
              ( text = `Node1-2`
                ref  = `sap-icon://create` ) ) )
        ( text = `Node2`
          ref  = `sap-icon://customer-financial-fact-sheet` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Tree - Basic`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Tree/sample/sap.m.sample.Tree` ).

    page->tree(
           id    = `Tree`
           items = client->_bind( t_nodes )
           )->items(
               )->standard_tree_item( title = `{TEXT}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
