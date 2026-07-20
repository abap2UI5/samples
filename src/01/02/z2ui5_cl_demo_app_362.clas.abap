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
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS restore_scroll.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_362 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.
      DATA temp1 TYPE z2ui5_cl_demo_app_362=>ty_s_row.

    DO 100 TIMES.
      
      CLEAR temp1.
      temp1-title = |Row { sy-index }|.
      temp1-value = `red`.
      temp1-info = `completed`.
      temp1-descr = `this is a description`.
      INSERT temp1
             INTO TABLE t_tab.
    ENDDO.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp2 TYPE string_table.
        DATA temp4 TYPE string_table.
        DATA temp6 TYPE string_table.
        DATA temp8 TYPE string_table.

    " The SCROLL_TO client event sets scrollTop / scrollLeft by pixel.
    " args: ( control-id, scrollTop, scrollLeft, behavior )
    " behavior is one of: "auto" (default, instant), "smooth", "instant".
    CASE client->get( )-event.
      WHEN `SCROLL_TOP`.
        
        CLEAR temp2.
        INSERT `id_page` INTO TABLE temp2.
        INSERT `0` INTO TABLE temp2.
        INSERT `0` INTO TABLE temp2.
        INSERT `smooth` INTO TABLE temp2.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp2 ).
      WHEN `SCROLL_MIDDLE`.
        
        CLEAR temp4.
        INSERT `id_page` INTO TABLE temp4.
        INSERT `1500` INTO TABLE temp4.
        INSERT `0` INTO TABLE temp4.
        INSERT `smooth` INTO TABLE temp4.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp4 ).
      WHEN `SCROLL_BOTTOM`.
        
        CLEAR temp6.
        INSERT `id_page` INTO TABLE temp6.
        INSERT `99999` INTO TABLE temp6.
        INSERT `0` INTO TABLE temp6.
        INSERT `smooth` INTO TABLE temp6.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp6 ).
      WHEN `SCROLL_JUMP`.
        " Same target as middle but without smooth - instant snap.
        
        CLEAR temp8.
        INSERT `id_page` INTO TABLE temp8.
        INSERT `1500` INTO TABLE temp8.
        INSERT `0` INTO TABLE temp8.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp8 ).
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

    DATA scroll TYPE z2ui5_if_types=>ty_s_get-s_scroll-main.
    DATA temp10 TYPE string_table.
    DATA temp1 LIKE LINE OF temp10.
    DATA temp2 LIKE LINE OF temp10.
    scroll = client->get( )-s_scroll-main.

    IF scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    
    CLEAR temp10.
    INSERT scroll-id INTO TABLE temp10.
    
    temp1 = |{ scroll-y }|.
    INSERT temp1 INTO TABLE temp10.
    
    temp2 = |{ scroll-x }|.
    INSERT temp2 INTO TABLE temp10.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = temp10 ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
            id             = `id_page`
            title          = `scroll_to - set & restore scroll position`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text = `Toolbar buttons scroll the page to a specific pixel position. Refresh keeps the current position by reading client->get( )-s_scroll-main and pushing it back via SCROLL_TO.`
        type = `Information` ).

    
    table = page->table( sticky     = `ColumnHeaders,HeaderToolbar`
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
