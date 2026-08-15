" @keywords position pixel scroll_to restore refresh toolbar
CLASS z2ui5_cl_smp_app_362 DEFINITION PUBLIC.

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



CLASS z2ui5_cl_smp_app_362 IMPLEMENTATION.


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
    CASE client->get_event( ).
      WHEN `SCROLL_TOP`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `0` ) ( `0` ) ( `smooth` ) ) ).
      WHEN `SCROLL_MIDDLE`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `1500` ) ( `0` ) ( `smooth` ) ) ).
      WHEN `SCROLL_BOTTOM`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = VALUE #( ( `id_page` ) ( `99999` ) ( `0` ) ( `smooth` ) ) ).
      WHEN `SCROLL_JUMP`.
        " Same target as middle but without smooth - instant snap.
        client->follow_up_action(
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

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = VALUE #( ( scroll-id )
                         ( |{ scroll-y }| )
                         ( |{ scroll-x }| ) ) ).

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
            )->a( n = `title`          v = `abap2UI5 - Scroll - Scroll to a Pixel Position`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `id_page` ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Toolbar buttons scroll the page to a specific pixel position. Refresh keeps the current position by reading client->get( )-s_scroll-main and pushing it back via SCROLL_TO.`
        )->a( n = `type` v = `Information` ).

    DATA(table) = page->ele( `Table`
        )->a( n = `items`      v = client->_bind( t_tab )
        )->a( n = `headerText` v = `100 entries`
        )->a( n = `sticky`     v = `ColumnHeaders,HeaderToolbar` ).

    table->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Title`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Color`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Info`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Description` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{TITLE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{VALUE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{INFO}`
                )->tag( `Text`
                    )->a( n = `text` v = `{DESCR}` ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SCROLL_TOP` )
                )->a( n = `text`  v = `Top (smooth)`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SCROLL_MIDDLE` )
                )->a( n = `text`  v = `Middle (smooth)`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SCROLL_BOTTOM` )
                )->a( n = `text`  v = `Bottom (smooth)`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SCROLL_JUMP` )
                )->a( n = `text`  v = `Middle (jump)`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `REFRESH` )
                )->a( n = `text`  v = `Refresh (keep position)`
                )->a( n = `type`  v = `Emphasized` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
