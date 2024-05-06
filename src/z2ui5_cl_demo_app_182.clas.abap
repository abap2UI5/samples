CLASS z2ui5_cl_demo_app_182 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF t_attributes3,
             label TYPE i,
             value TYPE string,
           END OF t_attributes3.
    TYPES: tt_attributes3 TYPE STANDARD TABLE OF t_attributes3 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_nodes2,
             id         TYPE string,
             title      TYPE string,
             src        TYPE string,
             attributes TYPE tt_attributes3,
             team       TYPE i,
             supervisor TYPE string,
             location   TYPE string,
             position   TYPE string,
             email      TYPE string,
             phone      TYPE string,
           END OF t_nodes2.
    TYPES: BEGIN OF t_lines4,
             from TYPE string,
             to   TYPE string,
           END OF t_lines4.
    TYPES: tt_nodes2 TYPE STANDARD TABLE OF t_nodes2 WITH DEFAULT KEY.
    TYPES: tt_lines4 TYPE STANDARD TABLE OF t_lines4 WITH DEFAULT KEY.
    TYPES: BEGIN OF t_json1,
             nodes TYPE tt_nodes2,
             lines TYPE tt_lines4,
           END OF t_json1.

    DATA mv_initialized TYPE abap_bool .
    DATA mt_data TYPE t_json1 .

    METHODS on_event .
    METHODS view_display .
    METHODS detail_popover
      IMPORTING
        id TYPE string
        node TYPE t_nodes2.
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_182 IMPLEMENTATION.


  METHOD detail_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    DATA(qv) = view->quick_view( placement = `Left`
              )->quick_view_page(
                                  header = `Employee`
                                  title  = node-title
                                  description = node-position
                )->get( )->quick_view_page_avatar( )->avatar( src = node-src displayshape = `Square` )->get_parent(
                )->quick_view_group( heading = `Contact Detail`
                  )->quick_view_group_element( label = `Location` value = node-location )->get_parent(
                  )->quick_view_group_element( label = `Mobile`   value = node-phone type = `phone` )->get_parent(
                  )->quick_view_group_element( label = `Email`   value = node-email type = `email` emailsubject  = `Contact` && node-id ).

    IF node-team IS NOT INITIAL.
      qv = qv->get_parent( )->get_parent(
        )->quick_view_group( heading = `Team`
           )->quick_view_group_element( label = `Size` value = CONV string( node-team ) ).
    ENDIF.

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'LINE_PRESS'.
        client->message_toast_display( 'LINE_PRESSED' ).

      WHEN 'DETAIL_POPOVER'.
        DATA(lt_arg) = client->get( )-t_event_arg.

        READ TABLE mt_data-nodes INTO DATA(ls_node) WITH KEY id = lt_arg[ 2 ].

        detail_popover( id = lt_arg[ 1 ] node = ls_node ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->page(
                    title          = 'abap2UI5 - Network Graph - Org Tree'
                    navbuttonpress = client->_event( val = 'BACK' )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->header_content(
                    )->link(
                        text = 'Source_Code'
                        target = '_blank'
                )->get_parent( ).

    DATA(graph) = page->network_graph( enablewheelzoom = abap_false
                                       orientation = `TopBottom`
                                       nodes = client->_bind( mt_data-nodes )
                                       lines = client->_bind( mt_data-lines )
                                       layout = `Layered`
                                       searchsuggest = `suggest`
                                       search = `search`
                                       id = `graph`
                                     )->get( )->layout_algorithm( )->layered_layout( mergeedges = abap_true nodeplacement = `Simple` nodespacing = `40`
                                     )->get_parent(
                                     )->get_parent(
                                  )->nodes( ns = `networkgraph`
                                    )->node( icon = `sap-icon://action-settings`
                                             key  = `{ID}`
                                             description  = `{TITLE}`
                                             title  = `{TITLE}`
                                             width  = `90`
                                             collapsed  = `{COLLAPSED}`
                                             attributes  = `{ATTRIBUTES}`
                                             showactionlinksbutton  = abap_false
                                             showdetailbutton  = abap_false
                                             descriptionlinesize  = `0`
                                             shape  = `Box`
*                                            )->get( )->custom_data( ns = `networkgraph` )->core_custom_data( key = `supervisor` value = `{SUPERVISOR}`
*                                                                                        )->core_custom_data( key = `team` value = `{TEAM}`
*                                                                                        )->core_custom_data( key = `location` value = `{LOCATION}`
*                                                                                        )->core_custom_data( key = `position` value = `{POSITION}`
*                                                                                        )->core_custom_data( key = `team` value = `{TEAM}`
*                                                                                        )->core_custom_data( key = `email` value = `{EMAIL}`
*                                                                                        )->core_custom_data( key = `phone` value = `{PHONE}`
*                                           )->get_parent(
*                                           )->get( )->get_parent( )->get_parent( )->attributes( ns = `networkgraph`
                                           )->get( )->attributes( ns = `networkgraph`
                                            )->element_attribute( label = `{LABEL}` value = `{VALUE}`
                                           )->get_parent(
                                           )->get_parent(
                                           )->get( )->get_parent( )->get_parent( )->action_buttons(
                                            )->action_button( "id = `{ID}`
                                                              position = `Left`
                                                              title = `Detail`
                                                              icon = `sap-icon://employee`
                                                              press = client->_event( val = `DETAIL_POPOVER` t_arg = VALUE #( ( `${$source>/id}` )
                                                                                                                              ( `${ID}` )
*                                                                                                                              ( `${TEAM}` )
*                                                                                                                              ( `${LOCATION}` )
*                                                                                                                              ( `${POSITION}` )
*                                                                                                                              ( `${EMAIL}` )
*                                                                                                                              ( `${PHONE}` )
                                                                                                                             ) )
                                           )->get_parent(
                                           )->get_parent(
                                           )->get( )->get_parent( )->get_parent( )->_generic( ns = `networkgraph` name = `image`
                                            )->node_image( src = `{SRC}`
                                                           width = `80`
                                                           height = `100`
                                                          )->get_parent(
                                                       )->get_parent(
                                                )->get_parent(
                                          )->get_parent(
                                          )->lines(
                                            )->line( from = `{FROM}`
                                                     to   = `{TO}`
                                                     arroworientation = `None`
                                                     press = client->_event( `LINE_PRESS` )


    ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.

      mt_data = VALUE #( nodes = VALUE #( ( id = `Dinter`
                                            title = `Sophie Dinter`
                                            src = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/female_IngallsB.jpg`
                                            attributes = VALUE #( ( label = 35 value = `` ) )
                                            team = 13
                                            location = `Walldorf`
                                            position = `lobal Solutions Manager`
                                            email = `sophie.dinter@example.com`
                                            phone = `+000 423 230 000`
                                          )
                                          ( id = `Ninsei`
                                            title = `Yamasaki Ninsei`
                                            src = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/male_GordonR.jpg`
                                            attributes = VALUE #( ( label = 9 value = `` ) )
                                            supervisor = `Dinter`
                                            team = 9
                                            location = `Walldorf`
                                            position = `Lead Markets Manage`
                                            email = `yamasaki.ninsei@example.com`
                                            phone = `+000 423 230 002`
                                         )
                                         ( id = `Mills`
                                           title = `Henry Mills`
                                           src = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/male_MillerM.jpg`
                                           attributes = VALUE #( ( label = 4 value = `` ) )
                                           supervisor = `Ninsei`
                                           team = 4
                                           location = `Praha`
                                           position = `Sales Manager`
                                           email = `henry.mills@example.com`
                                           phone = `+000 423 232 003`
                                        )
                                        ( id = `Polak`
                                          title = `Adam Polak`
                                          src = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/male_PlatteR.jpg`
                                          supervisor = `Mills`
                                          location = `Praha`
                                          position = `Marketing Specialist`
                                          email = `adam.polak@example.com`
                                          phone = `+000 423 232 004`
                                       )
                                       ( id = `Sykorova`
                                          title = `Vlasta Sykorova`
                                          src = `https://ui5.sap.com/test-resources/sap/suite/ui/commons/demokit/images/people/female_SpringS.jpg`
                                          supervisor = `Mills`
                                          location = `Praha`
                                          position = `Human Assurance Officer`
                                          email = `vlasta.sykorova@example.com`
                                          phone = `+000 423 232 005`
                                       )
                                     )
                                     lines = VALUE #( ( from = `Dinter` to = `Ninsei` )
                                                      ( from = `Ninsei` to = `Mills` )
                                                      ( from = `Mills` to = `Polak` )
                                                      ( from = `Mills` to = `Sykorova` )
                                    ) ).

      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.
