CLASS z2ui5_cl_smp_app_447 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        index TYPE i,
        text  TYPE string,
      END OF ty_s_row.
    DATA t_rows TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_447 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      " enough rows that the table really scrolls - with a short list the
      " scrollToIndex demo has nothing to do
      DO 200 TIMES.
        INSERT VALUE #( index = sy-index text = |Row number { sy-index }| ) INTO TABLE t_rows.
      ENDDO.

      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

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
                                                   ( `150` ) ) ).

    ENDCASE.

    view_display( ).

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
            )->a( n = `title`          v = `abap2UI5 - Action - CONTROL_BY_ID`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The backend calls a whitelisted method on a control resolved by id via ` &&
                   `follow_up_action( cs_event-control_by_id ), after the response renders: ` &&
                   `focus() on the input, scrollToIndex() on the table.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Input`
            )->a( n = `id`          v = `nameInput`
            )->a( n = `placeholder` v = `this input can be focused from the backend`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `FOCUS` )
            )->a( n = `text`  v = `focus( ) the input`
            )->a( n = `icon`  v = `sap-icon://edit`
            )->a( n = `class` v = `sapUiTinyMarginTop`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `SCROLL` )
            )->a( n = `text`  v = `scrollToIndex( 150 ) on the table`
            )->a( n = `icon`  v = `sap-icon://down`
            )->a( n = `class` v = `sapUiTinyMarginTop` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_rows )
        )->a( n = `id`    v = `bigTable` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Index`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Text`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{INDEX}`
                )->tag( `Text`
                    )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
