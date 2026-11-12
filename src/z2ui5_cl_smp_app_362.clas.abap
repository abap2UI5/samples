" @keywords position pixel scroll_to restore refresh toolbar
" @summary Scrolls to a pixel position and back: reading the position before a refresh and restoring it afterwards.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/scrolling
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
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.
    METHODS restore_scroll.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_362 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Scroll - Scroll to a Pixel Position`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `id_page` ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Toolbar buttons scroll the page to a specific pixel position. Refresh keeps the current position by reading client->get( )-s_scroll-main and pushing it back via SCROLL_TO.`
        )->a( n = `type` v = `Information` ).

    
    table = page->ele( `Table`
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


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp7 TYPE string_table.

    " The SCROLL_TO client event sets scrollTop / scrollLeft by pixel.
    " args: ( control-id, scrollTop, scrollLeft, behavior )
    " behavior is one of: "auto" (default, instant), "smooth", "instant".
    CASE client->get_event( ).
      WHEN `SCROLL_TOP`.
        
        CLEAR temp1.
        INSERT `id_page` INTO TABLE temp1.
        INSERT `0` INTO TABLE temp1.
        INSERT `0` INTO TABLE temp1.
        INSERT `smooth` INTO TABLE temp1.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp1 ).
      WHEN `SCROLL_MIDDLE`.
        
        CLEAR temp3.
        INSERT `id_page` INTO TABLE temp3.
        INSERT `1500` INTO TABLE temp3.
        INSERT `0` INTO TABLE temp3.
        INSERT `smooth` INTO TABLE temp3.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp3 ).
      WHEN `SCROLL_BOTTOM`.
        
        CLEAR temp5.
        INSERT `id_page` INTO TABLE temp5.
        INSERT `99999` INTO TABLE temp5.
        INSERT `0` INTO TABLE temp5.
        INSERT `smooth` INTO TABLE temp5.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp5 ).
      WHEN `SCROLL_JUMP`.
        " Same target as middle but without smooth - instant snap.
        
        CLEAR temp7.
        INSERT `id_page` INTO TABLE temp7.
        INSERT `1500` INTO TABLE temp7.
        INSERT `0` INTO TABLE temp7.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-scroll_to
            t_arg = temp7 ).
      WHEN `REFRESH`.
        " The redraw of the view resets the scroll position.
        " The current scroll info comes in on every roundtrip via
        " client->get( )-s_scroll, so we push it back via SCROLL_TO and
        " the user lands at the exact same spot after the redraw.
        view_display( ).
        restore_scroll( ).
        client->message_toast_display( `Table refreshed, scroll preserved` ).
    ENDCASE.

  ENDMETHOD.


  METHOD restore_scroll.

    DATA scroll TYPE z2ui5_if_client=>ty_s_get-s_scroll-main.
    DATA temp9 TYPE string_table.
    DATA temp1 LIKE LINE OF temp9.
    DATA temp2 LIKE LINE OF temp9.
    scroll = client->get( )-s_scroll-main.

    IF scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    
    CLEAR temp9.
    INSERT scroll-id INTO TABLE temp9.
    
    temp1 = |{ scroll-y }|.
    INSERT temp1 INTO TABLE temp9.
    
    temp2 = |{ scroll-x }|.
    INSERT temp2 INTO TABLE temp9.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = temp9 ).

  ENDMETHOD.


  METHOD model_init.
      DATA temp11 TYPE z2ui5_cl_smp_app_362=>ty_s_row.

    DO 100 TIMES.
      
      CLEAR temp11.
      temp11-title = |Row { sy-index }|.
      temp11-value = `red`.
      temp11-info = `completed`.
      temp11-descr = `this is a description`.
      INSERT temp11
             INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.
ENDCLASS.
