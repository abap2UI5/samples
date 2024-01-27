CLASS Z2UI5_CL_DEMO_APP_091 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

    TYPES: children_array TYPE STANDARD TABLE OF int4 WITH NON-UNIQUE KEY table_line.
    TYPES: texts_array TYPE STANDARD TABLE OF string WITH NON-UNIQUE KEY table_line.

    TYPES: BEGIN OF t_children3,
             children TYPE i,
           END OF t_children3.
    TYPES: t_texts4 TYPE string.
    TYPES: tt_children3 TYPE STANDARD TABLE OF t_children3 WITH DEFAULT KEY.
    TYPES: tt_texts4 TYPE STANDARD TABLE OF t_texts4 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_nodes2,
             id                TYPE string,
             lane              TYPE string,
             title             TYPE string,
             titleabbreviation TYPE string,
             children          TYPE children_array,
             state             TYPE string,
             statetext         TYPE string,
             focused           TYPE abap_bool,
             highlighted       TYPE abap_bool,
             texts             TYPE texts_array,
           END OF t_nodes2.
    TYPES: BEGIN OF t_lanes5,
             id       TYPE string,
             icon     TYPE string,
             label    TYPE string,
             position TYPE i,
           END OF t_lanes5.
    TYPES: tt_nodes2 TYPE STANDARD TABLE OF t_nodes2 WITH DEFAULT KEY.
    TYPES: tt_lanes5 TYPE STANDARD TABLE OF t_lanes5 WITH DEFAULT KEY.

    DATA: mt_nodes TYPE tt_nodes2.
    DATA: mt_lanes TYPE tt_lanes5.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_set_data.
    METHODS Z2UI5_view_display.
    METHODS Z2UI5_on_event.


  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_091 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      Z2UI5_set_data( ).

      Z2UI5_view_display( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_set_data.

    mt_nodes = VALUE #( ( id = `1` lane = `0` title = `Sales Order 1` titleabbreviation = `SO 1` children = VALUE #( ( 10 ) ( 11 ) ( 12 ) ) state = `Positive` statetext = `OK status` focused = abap_true
                          highlighted = abap_false texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `10` lane = `1` title = `Outbound Delivery 40` titleabbreviation = `OD 40` state = `Positive` statetext = `OK status` focused = abap_true highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `11` lane = `1` title = `Outbound Delivery 43` titleabbreviation = `OD 43` children = VALUE #( ( 21 ) ) state = `Neutral` statetext = `OK status` focused = abap_true highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `12` lane = `1` title = `Outbound Delivery 45` titleabbreviation = `OD 45` children = VALUE #( ( 20 ) ) state = `Neutral` focused = abap_false highlighted = abap_false
                         texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `20` lane = `2` title = `Invoice 9` titleabbreviation = `I 9` state = `Positive` statetext = `OK status` focused = abap_false highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                        ( id = `21` lane = `2` title = `Invoice Planned` titleabbreviation = `IP` state = `PlannedNegative` focused = abap_false highlighted = abap_false
                        texts = VALUE #( ( `Sales Order Document Overdue long text for the wrap up all the aspects` ) ( `Not cleared` ) ) )
                      ).

    mt_lanes = VALUE #( ( id = `0` icon = `sap-icon://order-status` label = `Order Processing` position = 0 )
                        ( id = `1` icon = `sap-icon://monitor-payments` label = `Delivery Processing` position = 1 )
                        ( id = `2` icon = `sap-icon://payment-approval` label = `Invoicing` position = 2 )
                      ).
  ENDMETHOD.


  METHOD Z2UI5_view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        title          = 'abap2UI5 - Process Flow'
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        class = 'sapUiContentPadding' ).

    DATA(process_flow) = page->process_flow(
        id = `processflow1`
        scrollable = abap_true
        wheelzoomable = abap_false
        foldedcorners = abap_true
        nodepress = client->_event( val = `NODE_PRESS` )
        nodes = client->_bind_edit( mt_nodes )
        lanes = client->_bind_edit( mt_lanes )
      )->nodes(
        )->process_flow_node(
          laneid = `{LANE}`
          nodeid = `{ID}`
          title = `{TITLE}`
          titleabbreviation = `{TITLEABBREVIATION}`
          children = `{CHILDREN}`
          state = `{STATE}`
          statetext = `{STATETEXT}`
*          texts = `{TEXTS}`
          highlighted = `{HIGHLIGHTED}`
          focused = `{FOCUSED}`
        )->get_parent( )->get_parent(
      )->lanes(
        )->process_flow_lane_header(
          laneid = `{ID}`
          iconsrc = `{ICON}`
          text = `{LABEL}`
          position = `{POSITION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
