CLASS z2ui5_cl_demo_app_195 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_t002,
      id    TYPE string,
      count TYPE string,
      table TYPE string,
      class TYPE string,
      END OF ty_s_t002.
    TYPES ty_t_t002 TYPE STANDARD TABLE OF ty_s_t002 WITH DEFAULT KEY.

    DATA mv_selectedkey     TYPE string.
    DATA mv_selectedkey_tmp TYPE string.
    DATA mt_t002            TYPE ty_t_t002.
    DATA mo_app             TYPE REF TO object.

  PROTECTED SECTION.
    DATA mo_client            TYPE REF TO z2ui5_if_client.

    DATA mo_main_page      TYPE REF TO z2ui5_cl_xml_view.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.

    METHODS render_sub_app.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_195 IMPLEMENTATION.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `ON_SELECT_ICON_TAB_BAR`.

        CASE mv_selectedkey.
          WHEN space.
          WHEN OTHERS.
        ENDCASE.
      WHEN `BACK`.
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    mt_t002 = VALUE #( ( id = `1` class = `Z2UI5_CL_DEMO_APP_194`  count = `10` table = `Z2UI5_T_11`)
                       ( id = `2` class = `Z2UI5_CL_DEMO_APP_194`  count = `20` table = `Z2UI5_T_12`)
                       ( id = `3` class = `Z2UI5_CL_DEMO_APP_194`  count = `30` table = `Z2UI5_T_11`)
                       ( id = `4` class = `Z2UI5_CL_DEMO_APP_194`  count = `40` table = `Z2UI5_T_12`) ).

    mv_selectedkey = `1`.
  ENDMETHOD.

  METHOD render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( )->shell( ).
    DATA(lo_page) = lo_view->page( id             = `page_main`
                             title          = `Main App calling Subapps`
                             navbuttonpress = mo_client->_event_nav_app_leave( )
                             shownavbutton  = mo_client->check_app_prev_stack( )
                             class          = `sapUiContentPadding` ).

    DATA(lo_items) = lo_page->icon_tab_bar( class       = `sapUiResponsiveContentPadding`
                                         selectedkey = mo_client->_bind_edit( mv_selectedkey )
                                         select      = mo_client->_event( `ON_SELECT_ICON_TAB_BAR` )
                                                       )->items( ).

    LOOP AT mt_t002 REFERENCE INTO DATA(line).
      lo_items->icon_tab_filter( text  = line->class
                                 count = line->count
                                 key   = line->id ).
      lo_items->icon_tab_separator( ).
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

    CASE mv_selectedkey.
      WHEN OTHERS.

        IF mv_selectedkey <> mv_selectedkey_tmp.
          CREATE OBJECT mo_app TYPE (t002->class).
        ENDIF.
        TRY.

            CALL METHOD mo_app->(`SET_APP_DATA`)
              EXPORTING
                table = t002->table.

            render_main( ).

            ASSIGN mo_app->(`MO_PARENT_VIEW`) TO FIELD-SYMBOL(<lo_view>).
            IF <lo_view> IS ASSIGNED.
              <lo_view> = mo_main_page.
            ENDIF.

            CALL METHOD mo_app->(`Z2UI5_IF_APP~MAIN`)
              EXPORTING
                mo_client = mo_client.

          CATCH cx_root.
            RETURN.
        ENDTRY.
    ENDCASE.

    mo_client->view_model_update( ).

    ASSIGN mo_app->(`MV_VIEW_DISPLAY`) TO <view_display>.

    IF <view_display> = abap_true.
      <view_display> = abap_false.
      mo_client->view_display( mo_main_page->stringify( ) ).
    ENDIF.

    IF mv_selectedkey <> mv_selectedkey_tmp.

      mo_client->view_display( mo_main_page->stringify( ) ).
      mv_selectedkey_tmp = mv_selectedkey.

    ENDIF.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      on_init( ).
      render_main( ).
    ENDIF.

    on_event( ).
    render_sub_app( ).
  ENDMETHOD.
ENDCLASS.
