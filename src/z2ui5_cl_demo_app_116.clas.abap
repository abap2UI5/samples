CLASS z2ui5_cl_demo_app_116 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_prodh_node_level3,
        is_selected TYPE abap_bool,
        text        TYPE string,
        counter     TYPE i,
        prodh       TYPE string,
      END OF ty_prodh_node_level3 .
    TYPES:
      BEGIN OF ty_prodh_node_level2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        counter     TYPE i,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level3 WITH DEFAULT KEY,
      END OF ty_prodh_node_level2 .
    TYPES:
      BEGIN OF ty_prodh_node_level1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        counter     TYPE i,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY,
      END OF ty_prodh_node_level1 .
    TYPES
      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY .
    TYPES
      ty_prin_nodes TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY.

    DATA mv_prodh_nodes TYPE ty_prodh_nodes .
    DATA mv_user TYPE c LENGTH 12.
    DATA mv_date TYPE d.

    DATA mv_run_js TYPE abap_bool VALUE abap_false.

    METHODS display_view .
    METHODS display_popover
      IMPORTING
        !id TYPE string .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS initialize.
    METHODS add_node
      IMPORTING p_prodh TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_116 IMPLEMENTATION.

  METHOD add_node.

    LOOP AT mv_prodh_nodes ASSIGNING FIELD-SYMBOL(<fs1>).
      IF <fs1>-prodh = p_prodh.
        <fs1>-counter = <fs1>-counter + 1.
        EXIT.
      ELSE.
        LOOP AT <fs1>-nodes ASSIGNING FIELD-SYMBOL(<fs2>).
          IF <fs2>-prodh = p_prodh.
            <fs2>-counter = <fs2>-counter + 1.
            EXIT.
          ELSE.
            LOOP AT <fs2>-nodes ASSIGNING FIELD-SYMBOL(<fs3>).
              IF <fs3>-prodh = p_prodh.
                <fs3>-counter = <fs3>-counter + 1.
                EXIT.

              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_popover) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_popover->popover( placement = `Right`
                         title     = `SS` "text-028 "`Stock - Details:`
                                                         "&& '-' && gv_matnr  "contentwidth = `32%`
            )->footer(
             )->overflow_toolbar(
                )->toolbar_spacer(
                )->button(
                    text  = `OK`
                    press = mo_client->_event( `POPOVER_OK` )
                    type  = `Emphasized`
           )->get_parent( )->get_parent(
           )->text( `TEST` ).

    mo_client->popover_display( xml   = lo_popover->stringify( )
                             by_id = id ).
  ENDMETHOD.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->object_page_layout(
            showtitleinheadercontent = abap_true
            uppercaseanchorbar       = abap_false ).

    DATA(lo_header_title) = lo_page->header_title( )->object_page_dyn_header_title( ).
    lo_header_title->expanded_heading(
            )->hbox(
                )->title( text = `PriceList` ).

    DATA(lo_header_content) = lo_page->header_content( ns = `uxap`).
    lo_header_content->block_layout(
      )->block_layout_row(
      )->block_layout_cell( backgroundcolorset   = `ColorSet10`
                            backgroundcolorshade = `ShadeE`
      )->flex_box( justifycontent = `SpaceBetween`
      )->hbox(
      )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
          )->label( design = `Bold`
                    text   = `Something:`
      )->get_parent(
      )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
        )->text( text = `Other`
      )->get_parent( )->get_parent(
      )->hbox( justifycontent = `End`
        )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
          )->label( design = `Bold`
                    text   = `User:`
          )->label( design = `Bold`
                    text   = `Date:`
        )->get_parent(
      )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
        )->text( mo_client->_bind( mv_user )
        )->text( mo_client->_bind( mv_date ) ).

    DATA(lo_sections) = lo_page->sections( ).

    DATA(lo_cont) = lo_sections->object_page_section( titleuppercase = abap_false
                                                id             = `Sets`
                                                title          = `Sets`
        )->heading( ns = `uxap`
        )->get_parent(
        )->sub_sections(
            )->object_page_sub_section( id    = `SETS`
                                        title = `Sets`
                )->scroll_container( vertical = abap_true
                 )->vbox(
                      )->tree_table( id  = `treeTable`
                         rows            = `{path:'` && mo_client->_bind( val = mv_prodh_nodes path = abap_true ) && `', parameters: {arrayNames:['NODES']}}`
                         toggleopenstate = `saveState()`
                         )->tree_columns(
                          )->tree_column( label = `Label`
                          )->tree_template(
                           )->text( text = `{####}`
                          )->get_parent( )->get_parent(
                          )->tree_column( label = `PRODH`
                          )->tree_template(
                           )->text( text = `{PRODH}`
                          )->get_parent( )->get_parent(
                          )->tree_column( label = `Counter`
                          )->tree_template(
                           )->link( text    = `{COUNTER}`
                                      press = mo_client->_event( val = `POPOVER` t_arg = VALUE #( ( `${$source>/id}` ) ) )
      )->get_parent( )->get_parent(
                          )->tree_column( label = `ADD`
                          )->tree_template(
                           )->button( icon = `sap-icon://add`
                                 press     = mo_client->_event( val = `ROW_ADD` t_arg = VALUE #( ( `${PRODH}` ) ) )
                                 tooltip   = `ADD`
                          )->get_parent( )->get_parent( ).
    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD initialize.

    mv_prodh_nodes =
      VALUE #( ( text = `Machines`
               prodh  = `00100`
               nodes  = VALUE #( ( text = `Pumps`
                                  prodh = `0010000100`
                                  nodes = VALUE #( ( text  = `Pump 001`
                                                     prodh = `001000010000000100` )
                                                   ( text  = `Pump 002`
                                                     prodh = `001000010000000105` ) )
                       ) ) )
             ( text  = `Paints`
               prodh = `00110`
               nodes = VALUE #( ( text  = `Gloss paints`
                                  prodh = `0011000105`
                                  nodes = VALUE #( ( text  = `Paint 001`
                                                     prodh = `001100010500000100` )
                                                   ( text  = `Paint 002`
                                                     prodh = `001100010500000105` ) )
                       ) )
             ) ).

    mv_user = sy-uname.
    mv_date = sy-datum.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    DATA lt_event_arg TYPE string_table.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      initialize( ).

      DATA(lv_save_state_js) = `function saveState() {debugger;` && |\n| &&
                         `  var treeTable = sap.z2ui5.oView.byId("treeTable");` && |\n| &&
                         `  sap.z2ui5.treeState = treeTable.getBinding('rows').getCurrentTreeState();` && |\n| &&
                         ` }; `.

      DATA(lv_reset_state_js) = `function setState() {debugger;` && |\n| &&
                                ` var treeTable = sap.z2ui5.oView.byId("treeTable");` && |\n| &&
                                ` if( sap.z2ui5.treeState == undefined ) {` && |\n| &&
                                `     sap.z2ui5.treeState = treeTable.getBinding('rows').getCurrentTreeState();` && |\n| &&
                                ` } else {` && |\n| &&
                                `     treeTable.getBinding("rows").setTreeState(sap.z2ui5.treeState);` && |\n| &&
                                `     treeTable.getBinding("rows").refresh();` && |\n| &&
                                `     sap.z2ui5.treeState = treeTable.getBinding('rows').getCurrentTreeState();` && |\n| &&
                                ` };` && |\n| &&
                                `};`.

      mo_client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer( mo_client->_event( `START` )
          )->_generic( ns   = `html`
                       name = `script` )->_cc_plain_xml( lv_save_state_js )->get_parent(
          )->_generic( ns   = `html`
                       name = `script` )->_cc_plain_xml( lv_reset_state_js
          )->stringify( ) ).
    ENDIF.

    lt_event_arg = mo_client->get( )-t_event_arg.
    CASE mo_client->get( )-event.
      WHEN `START`.
        display_view( ).
      WHEN `CONTINUE`.
        mo_client->popup_destroy( ).
      WHEN `CANCEL`.
        mo_client->popup_destroy( ).
      WHEN `POPOVER`.
        lt_event_arg = mo_client->get( )-t_event_arg.
        DATA(lv_open_by_id) = lt_event_arg[ 1 ].
        display_popover( lv_open_by_id ).
      WHEN `ROW_ADD`.
        add_node( lt_event_arg[ 1 ] ).

        mv_run_js = abap_true.

        mo_client->view_model_update( ).

        mo_client->follow_up_action( val = `setState();` ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
