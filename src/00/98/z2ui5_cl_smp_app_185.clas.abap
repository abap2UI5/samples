CLASS z2ui5_cl_smp_app_185 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_t002,
      id    TYPE string,
      count TYPE string,
      table TYPE string,
      class TYPE string,
      END OF ty_s_t002.
    TYPES ty_t_t002 TYPE STANDARD TABLE OF ty_s_t002 WITH EMPTY KEY.

    DATA mv_selectedkey     TYPE string.
    DATA mv_selectedkey_tmp TYPE string.
    DATA mt_t002            TYPE ty_t_t002.
    DATA mo_app             TYPE REF TO object.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.

    DATA mo_main_page      TYPE REF TO z2ui5_cl_ui5_view_builder.

    METHODS on_init.
    METHODS view_display.

    METHODS render_sub_app.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_185 IMPLEMENTATION.


  METHOD on_init.

    mt_t002 = VALUE #( ( id = `1` class = `Z2UI5_CL_SMP_APP_184`  count = `10` table = `Z2UI5_T_01` )
                       ( id = `2` class = `Z2UI5_CL_SMP_APP_184`  count = `12` table = `Z2UI5_T_01` ) ).

    mv_selectedkey = `1`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Shell` ).
    DATA(page) = view->ele( `Page`
        )->a( n = `title`          v = `Main App calling Subapps`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
        )->a( n = `class`          v = `sapUiContentPadding`
        )->a( n = `id`             v = `page_main` ).

    DATA(lo_items) = page->ele( `IconTabBar`
        )->a( n = `class`       v = `sapUiResponsiveContentPadding`
        " abap2ui5lint-disable-next-line event-without-handler -- the roundtrip alone is the point: selectedKey is written back by the binding, render_sub_app( ) reads it
        )->a( n = `select`      v = client->_event( `ONSELECTICONTABBAR` )
        )->a( n = `selectedKey` v = client->_bind( mv_selectedkey )
        )->ele( `items` ).

    LOOP AT mt_t002 REFERENCE INTO DATA(line).
      lo_items->ele( `IconTabFilter`
          )->a( n = `count` v = line->count
          )->a( n = `text`  v = line->class
          )->a( n = `key`   v = line->id ).
      lo_items->ele( `IconTabSeparator` ).
    ENDLOOP.

    mo_main_page = lo_items.

  ENDMETHOD.


  METHOD render_sub_app.

    FIELD-SYMBOLS <view_display> TYPE any.

    READ TABLE mt_t002 REFERENCE INTO DATA(t002)
         WITH KEY id = mv_selectedkey.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF mv_selectedkey <> mv_selectedkey_tmp.
      CREATE OBJECT mo_app TYPE (t002->class).
    ENDIF.
    TRY.

        CALL METHOD mo_app->(`SET_APP_DATA`)
          EXPORTING
            count = t002->count
            table = t002->table.

        view_display( ).

        ASSIGN mo_app->(`MO_PARENT_VIEW`) TO FIELD-SYMBOL(<view>).

        IF <view> IS ASSIGNED.
          <view> = mo_main_page.
        ENDIF.

        CALL METHOD mo_app->(`Z2UI5_IF_APP~MAIN`)
          EXPORTING
            client = client.

      CATCH cx_root.
        RETURN.
    ENDTRY.

    ASSIGN mo_app->(`MV_VIEW_DISPLAY`) TO <view_display>.

    IF sy-subrc = 0 AND <view_display> = abap_true.

      <view_display> = abap_false.
      client->view_display( mo_main_page->stringify( ) ).
    ENDIF.

    IF mv_selectedkey <> mv_selectedkey_tmp.

      client->view_display( mo_main_page->stringify( ) ).
      mv_selectedkey_tmp = mv_selectedkey.

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      render_sub_app( ).
    ENDIF.

    render_sub_app( ).

  ENDMETHOD.
ENDCLASS.
