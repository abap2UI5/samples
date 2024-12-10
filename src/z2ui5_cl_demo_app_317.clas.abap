CLASS z2ui5_cl_demo_app_317 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_node4,
        id   TYPE string,
        text TYPE string,
*        nodes TYPE STANDARD TABLE OF ty_node5 WITH DEFAULT KEY,
      END OF ty_node4,
      BEGIN OF ty_node3,
        id    TYPE string,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_node4 WITH DEFAULT KEY,
      END OF ty_node3,
      BEGIN OF ty_node2,
        id    TYPE string,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_node3 WITH DEFAULT KEY,
      END OF ty_node2,
      BEGIN OF ty_node1,
        id    TYPE string,
        text  TYPE string,
        nodes TYPE STANDARD TABLE OF ty_node2 WITH DEFAULT KEY,
      END OF ty_node1,
      ty_tree TYPE STANDARD TABLE OF ty_node1 WITH DEFAULT KEY.
    DATA mt_tree    TYPE ty_tree.

    TYPES:
      BEGIN OF ty_S_node,
        id        TYPE string,
        id_parent TYPE string,
        text      TYPE string,
      END OF ty_S_node.
    DATA mt_node TYPE STANDARD TABLE OF ty_S_node WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS build_tree.
    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

ENDCLASS.

CLASS z2ui5_cl_demo_app_317 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mt_node = VALUE #(
          ( id   = '01' id_parent = ''   text = 'Machines'     )
          ( id   = '03' id_parent = '01' text = 'Pumps'        )
          ( id   = '04' id_parent = '03' text = 'Pump 001'     )
          ( id   = '05' id_parent = '03' text = 'Pump 002'     )
          ( id   = '02' id_parent = ''   text = 'Paints'       )
          ( id   = '06' id_parent = '02' text = 'Gloss paints' )
          ( id   = '07' id_parent = '06' text = 'Paint 001'    )
          ( id   = '08' id_parent = '06' text = 'Paint 002'    ) ).

      build_tree( ).
      display_view( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'expand'.
        client->follow_up_action( `debugger; z2ui5.oView.byId( 'tree' ).expandToLevel(10);`).

      WHEN 'onDrop'.
        mt_node[ id = client->get_event_arg( 1 ) ]-id_parent = client->get_event_arg( 2 ).
        build_tree( ).
        display_view( client ).
    ENDCASE.


  ENDMETHOD.

  METHOD build_tree.

    CLEAR mt_tree.
    LOOP AT mt_node INTO DATA(ls_node) WHERE id_parent IS INITIAL.

      DATA(ls_root) = CORRESPONDING ty_node1( ls_node ).
      INSERT ls_root INTO TABLE mt_tree.

    ENDLOOP.


    LOOP AT mt_tree REFERENCE INTO DATA(lr_node).

      LOOP AT mt_node INTO ls_node WHERE id_parent = lr_node->id.
        DATA(ls_root2) = CORRESPONDING ty_node2( ls_node ).
        INSERT ls_root2 INTO TABLE lr_node->nodes.
      ENDLOOP.

    ENDLOOP.


    LOOP AT mt_tree REFERENCE INTO lr_node.
      LOOP AT lr_node->nodes REFERENCE INTO DATA(lr_node2).

        LOOP AT mt_node INTO ls_node WHERE id_parent = lr_node2->id.
          DATA(ls_root3) = CORRESPONDING ty_node3( ls_node ).
          INSERT ls_root3 INTO TABLE lr_node2->nodes.
        ENDLOOP.

      ENDLOOP.
    ENDLOOP.


    LOOP AT mt_tree REFERENCE INTO lr_node.
      LOOP AT lr_node->nodes REFERENCE INTO lr_node2.
        LOOP AT lr_node2->nodes REFERENCE INTO DATA(lr_node3).

          LOOP AT mt_node INTO ls_node WHERE id_parent = lr_node3->id.
            DATA(ls_root4) = CORRESPONDING ty_node4( ls_node ).
            INSERT ls_root4 INTO TABLE lr_node3->nodes.
          ENDLOOP.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->page( ).

    page->_generic( name = `script` ns = `html`
        )->_cc_plain_xml(
          |function myFunction() \{ z2ui5.oView.byId('tree').expandToLevel(5); \}|
        ).

    DATA(tree) = page->tree( items = client->_bind( mt_tree ) id = `tree` ).
    tree->items(
        )->standard_tree_item( title = '{TEXT}'
        )->get(
          )->custom_data(
              )->core_custom_data( key   = 'ID' value = '{ID}').

    tree->drag_drop_config( ns = `` )->Drag_Drop_Info(
      sourceAggregation = `items`
      targetAggregation = `items`
      dragStart         = `Horizontal`
      drop              = client->_event(
                              val   = 'onDrop'
                              t_arg = VALUE #(
                           ( `${$parameters>/draggedControl/mAggregations/customData/0/mProperties/value}` )
                           ( `${$parameters>/droppedControl/mAggregations/customData/0/mProperties/value}` )
    ) ) ).

    client->follow_up_action( `myFunction()` ).
    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
