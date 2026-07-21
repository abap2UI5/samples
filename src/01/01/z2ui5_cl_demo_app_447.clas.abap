CLASS z2ui5_cl_demo_app_447 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        index TYPE i,
        text  TYPE string,
      END OF ty_s_row.
    DATA mt_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_447 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      DO 30 TIMES.
        INSERT VALUE #( index = sy-index
                        text  = |Row number { sy-index }| ) INTO TABLE mt_row.
      ENDDO.

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      " t_arg is positional: id, method, params (the view defaults to
      " cs_view-main and can be omitted for a main-view control)
      WHEN `FOCUS`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = VALUE #( ( `nameInput` )
                                                   ( `focus` ) ) ).

      WHEN `SCROLL`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = VALUE #( ( `bigTable` )
                                                   ( `scrollToIndex` )
                                                   ( `25` ) ) ).

    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Action - CONTROL_BY_ID`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The backend calls a whitelisted method on a control resolved by id via ` &&
                   `follow_up_action( cs_event-control_by_id ), after the response renders: ` &&
                   `focus() on the input, scrollToIndex() on the table.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->input( id          = `nameInput`
                  placeholder = `this input can be focused from the backend`
        )->button( text  = `focus( ) the input`
                   icon  = `sap-icon://edit`
                   press = client->_event( `FOCUS` )
                   class = `sapUiTinyMarginTop`
        )->button( text  = `scrollToIndex( 25 ) on the table`
                   icon  = `sap-icon://down`
                   press = client->_event( `SCROLL` )
                   class = `sapUiTinyMarginTop` ).

    DATA(tab) = page->table( id    = `bigTable`
                             items = client->_bind( mt_row ) ).

    tab->columns(
        )->column( )->text( `Index` )->get_parent(
        )->column( )->text( `Text` )->get_parent( ).

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( `{INDEX}`
                )->text( `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
