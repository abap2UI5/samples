CLASS z2ui5_cl_demo_app_043 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

*    TYPES:
*      BEGIN OF t_flight,
*        carrid TYPE string,
*        connid TYPE string,
*        fldate TYPE sflight-fldate,
*        price  TYPE sflight-price,
*      END OF t_flight.
*    DATA: mt_flight TYPE STANDARD TABLE OF t_flight.
*    DATA mv_key TYPE string.
ENDCLASS.

CLASS z2ui5_cl_demo_app_043 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

*    SELECT carrid connid fldate price FROM sflight INTO TABLE mt_flight UP TO 50 ROWS.
*
*    DATA(page) = z2ui5_cl_xml_view=>factory( )->page(
*            )->scroll_container( height = '70%' vertical = abap_true ).
*
*    DATA(tab) = page->table( items = client->_bind( mt_flight ) ).
*
*    tab->header_toolbar( )->overflow_toolbar(
*            )->title( 'title of the table'
*            )->button(
*                text  = 'left side button'
*                icon  = 'sap-icon://account'
*                press = client->_event( 'BUTTON_SORT' )
*            )->segmented_button( selected_key = mv_key
*                )->items(
*                    )->segmented_button_item(
*                        key = 'BLUE'
*                        icon = 'sap-icon://accept'
*                        text = 'blue'
*                    )->segmented_button_item(
*                        key = 'GREEN'
*                        icon = 'sap-icon://add-favorite'
*                        text = 'green'
*            )->get_parent( )->get_parent(
*            )->toolbar_spacer(
*            )->generic_tag(
*                    text           = 'Project Cost'
*                    design         = 'StatusIconHidden'
*                    status         = 'Error'
*                )->object_number(
*                    state      = 'Error'
*                    emphasized = 'false'
*                    number     = '3.5M'
*                    unit       = 'EUR'
*            )->get_parent(
*            )->toolbar_spacer(
*            )->button(
*                text  = 'Sort'
*                icon = 'sap-icon://sort-descending'
*                press = client->_event( 'BUTTON_SORT' )
*            )->button(
*                icon  = 'sap-icon://edit'
*                press = client->_event( 'BUTTON_POST' ) ).
*
*    tab->columns(
*        )->column( )->text( 'Carrid' )->get_parent(
*        )->column( )->text( 'Connid' )->get_parent(
*        )->column( )->text( 'Fldate' )->get_parent(
*        )->column( )->text( 'Price'  )->get_parent(
*    )->get_parent(
*    )->items( )->column_list_item( )->cells(
*        )->text( '{CARRID}'
*        )->text( '{CONNID}'
*        )->text( '{FLDATE}'
*        )->text( '{PRICE}' ).
*
*
*    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
