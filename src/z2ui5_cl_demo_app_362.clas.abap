CLASS z2ui5_cl_demo_app_362 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
        info  TYPE string,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS restore_scroll.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_362 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DO 100 TIMES.
      INSERT VALUE #( title = |Row { sy-index }|
                      value = `red`
                      info  = `completed`
                      descr = `this is a description` )
             INTO TABLE t_tab.
    ENDDO.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    " The SCROLL_TO client event sets scrollTop / scrollLeft by pixel.
    " args: ( control-id, scrollTop, scrollLeft, behavior )
    " behavior is one of: "auto" (default, instant), "smooth", "instant".
    CASE client->get( )-event.
      WHEN `SCROLL_TOP`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `0` ) ( `0` ) ( `smooth` ) ) ).
      WHEN `SCROLL_MIDDLE`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `1500` ) ( `0` ) ( `smooth` ) ) ).
      WHEN `SCROLL_BOTTOM`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `99999` ) ( `0` ) ( `smooth` ) ) ).
      WHEN `SCROLL_JUMP`.
        " Same target as middle but without smooth - instant snap.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `1500` ) ( `0` ) ) ).
      WHEN `REFRESH`.
        " A redraw of the table would normally reset the scroll position.
        " The current scroll info comes in on every roundtrip via
        " client->get( )-s_scroll, so we push it back via SCROLL_TO and
        " the user lands at the exact same spot after the redraw.
        restore_scroll( ).
        client->message_toast_display( `Table refreshed, scroll preserved` ).
    ENDCASE.

  ENDMETHOD.


  METHOD restore_scroll.

    DATA(scroll) = client->get( )-s_scroll-main.

    IF scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    client->action->gen(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = VALUE #( ( scroll-id )
                         ( |{ scroll-y }| )
                         ( |{ scroll-x }| ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            id             = `id_page`
            title          = `scroll_to - set & restore scroll position`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text = `Toolbar buttons scroll the page to a specific pixel position. Refresh keeps the current position by reading client->get( )-s_scroll-main and pushing it back via SCROLL_TO.`
        type = `Information` ).

    DATA(table) = page->table( sticky     = `ColumnHeaders,HeaderToolbar`
                               headertext = `100 entries`
                               items      = client->_bind( t_tab ) ).

    table->columns(
        )->column( )->text( `Title` )->get_parent(
        )->column( )->text( `Color` )->get_parent(
        )->column( )->text( `Info` )->get_parent(
        )->column( )->text( `Description` ).

    table->items( )->column_list_item( )->cells(
       )->text( `{TITLE}`
       )->text( `{VALUE}`
       )->text( `{INFO}`
       )->text( `{DESCR}` ).

    page->footer( )->overflow_toolbar(
         )->button( text  = `Top (smooth)`
                    press = client->_event( `SCROLL_TOP` )
         )->button( text  = `Middle (smooth)`
                    press = client->_event( `SCROLL_MIDDLE` )
         )->button( text  = `Bottom (smooth)`
                    press = client->_event( `SCROLL_BOTTOM` )
         )->button( text  = `Middle (jump)`
                    press = client->_event( `SCROLL_JUMP` )
         )->button( text  = `Refresh (keep position)`
                    press = client->_event( `REFRESH` )
                    type  = `Emphasized` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
