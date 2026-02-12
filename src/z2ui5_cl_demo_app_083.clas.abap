CLASS z2ui5_cl_demo_app_083 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab_01,
        screen_name TYPE string,
      END OF ty_s_tab_01.

    DATA mt_01 TYPE STANDARD TABLE OF ty_s_tab_01 WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_tab_02,
        screen_name TYPE string,
        field       TYPE string,
        field_doma  TYPE string,
      END OF ty_s_tab_02.

    DATA mt_02 TYPE STANDARD TABLE OF ty_s_tab_02 WITH EMPTY KEY.
    DATA mt_02_display TYPE STANDARD TABLE OF ty_s_tab_02 WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_tab_02_input,
        name  TYPE string,
        value TYPE string,
      END OF ty_s_tab_02_input.

    DATA mt_tab_02_input TYPE STANDARD TABLE OF ty_s_tab_02_input WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop.
    DATA mt_filter TYPE STANDARD TABLE OF ty_s_filter_pop WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ty_s_token.

    DATA mv_value       TYPE string.
    DATA mt_token       TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

    DATA mt_mapping TYPE z2ui5_if_types=>ty_t_name_value.

    TYPES ty_t_range TYPE RANGE OF string.
    TYPES ty_s_range TYPE LINE OF ty_t_range.
    TYPES:
      BEGIN OF ty_s_filter,
        product TYPE ty_t_range,
      END OF ty_s_filter.

    DATA ms_filter TYPE ty_s_filter.
    DATA mv_name TYPE string.

    DATA mt_table TYPE REF TO data.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS on_render_main.
    METHODS on_render_pop_filter.

  PRIVATE SECTION.
    DATA mt_cols TYPE string_table.

ENDCLASS.

CLASS z2ui5_cl_demo_app_083 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client     = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    DATA ls_range TYPE z2ui5_cl_util=>ty_s_range.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_POST`.
        CREATE DATA mt_table TYPE (mv_name).
        on_render_main( ).
      WHEN `FILTER_UPDATE`.
        IF mv_value IS NOT INITIAL.

          ls_range = z2ui5_cl_util=>filter_get_range_by_token( mv_value ).
          INSERT ls_range INTO TABLE ms_filter-product.
        ENDIF.
      WHEN `FILTER_VALUE_HELP_OK`.
        CLEAR ms_filter-product.
        LOOP AT mt_filter REFERENCE INTO DATA(lr_filter).
          INSERT VALUE #(
              sign   = `I`
              option = lr_filter->option
              low    = lr_filter->low
              high   = lr_filter->high
            ) INTO TABLE ms_filter-product.
        ENDLOOP.

        mo_client->popup_destroy( ).
      WHEN `POPUP_ADD`.
        INSERT VALUE #( key = z2ui5_cl_util=>uuid_get_c32( ) ) INTO TABLE mt_filter.
        mo_client->popup_model_update( ).
      WHEN `POPUP_DELETE`.
        DATA(lt_item) = mo_client->get( )-t_event_arg.
        DELETE mt_filter WHERE key = lt_item[ 1 ].
        mo_client->popup_model_update( ).
      WHEN `POPUP_DELETE_ALL`.
        mt_filter = VALUE #( ).
        mo_client->popup_model_update( ).
      WHEN `FILTER_VALUE_HELP`.
        on_render_pop_filter( ).

        CLEAR mt_filter.
        LOOP AT ms_filter-product REFERENCE INTO DATA(lr_product).
          INSERT VALUE #(
                   low    = lr_product->low
                   high   = lr_product->high
                   option = lr_product->option
                   key    = z2ui5_cl_util=>uuid_get_c32( )
            ) INTO TABLE mt_filter.

        ENDLOOP.
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    mt_01 = VALUE #( ( screen_name = `screen_01` ) ( screen_name = `screen_02` ) ).

    mt_02 = VALUE #(
      ( screen_name = `screen_01` field_doma = `CHAR30` field = `MATNR` )
      ( screen_name = `screen_01` field_doma = `STRING` field = `LGNUM` )
      ( screen_name = `screen_02` field_doma = `PRODUCT` field = `PRODUCT` ) ).

    mv_name = `screen_01`.
    on_render_main( ).

    mt_mapping = VALUE #(
      (   n = `EQ`     v = `={LOW}` )
      (   n = `LT`     v = `<{LOW}` )
      (   n = `LE`     v = `<={LOW}` )
      (   n = `GT`     v = `>{LOW}` )
      (   n = `GE`     v = `>={LOW}` )
      (   n = `CP`     v = `*{LOW}*` )
      (   n = `BT`     v = `{LOW}...{HIGH}` )
      (   n = `NE`     v = `!(={LOW})` )
      (   n = `NE`     v = `!(<leer>)` )
      (   n = `<leer>` v = `<leer>` ) ).
  ENDMETHOD.

  METHOD on_render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view = lo_view->page( id   = `page_main`
             title          = `abap2UI5 - Select-Options`
             navbuttonpress = mo_client->_event_nav_app_leave( )
             shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_page) = lo_view->dynamic_page(
            headerexpanded = abap_true
            headerpinned   = abap_true ).

    DATA(lo_header_title) = lo_page->title( ns = `f`
            )->get( )->dynamic_page_title( ).

    lo_header_title->heading( ns = `f` )->hbox(
        )->title( `Select-Option` ).
    lo_header_title->expanded_content( `f` ).
    lo_header_title->snapped_content( ns = `f` ).

    DATA(lo_box) = lo_page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems     = `Start`
                      justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    DATA(lo_vbox) = lo_box->vbox( ).
    lo_vbox->simple_form( editable = abap_true
            )->content( `form`
                )->title( `Table`
                )->label( `Name` ).

    lo_vbox->input( mo_client->_bind_edit( mv_name ) ).

    lo_vbox->button(
                text  = `read`
                press = mo_client->_event( `BUTTON_POST` ) ).

    lo_vbox = lo_box->vbox( ).

    IF mt_02 IS NOT INITIAL.

      mt_02_display = mt_02.
      DELETE mt_02_display WHERE screen_name <> mv_name.

      mt_tab_02_input = VALUE #( FOR line IN mt_cols ( name = line ) ).

      LOOP AT mt_02_display REFERENCE INTO DATA(lr_tab).
        INSERT VALUE #(
            name = lr_tab->field
*                value = lr_tab->field_doma
                 ) INTO TABLE mt_tab_02_input.
      ENDLOOP.
*
      lo_vbox->list(
        items      = mo_client->_bind( mt_tab_02_input )
        headertext = `Filter`
        )->custom_list_item(
            )->hbox(
                )->text( `{NAME}`
            )->multi_input(
                tokens           = mo_client->_bind( mt_token )
                showclearicon    = abap_true
                value            = `{VALUE}`
                tokenupdate      = mo_client->_event( `FILTER_UPDATE1` )
                submit           = mo_client->_event( `FILTER_UPDATE` )
                id               = `FILTER`
                valuehelprequest = mo_client->_event( `FILTER_VALUE_HELP` )
            )->item(
                    key  = `{KEY}`
                    text = `{TEXT}`
            )->tokens(
                )->token(
                    key      = `{KEY}`
                    text     = `{TEXT}`
                    visible  = `{VISIBLE}`
                    selected = `{SELKZ}`
                    editable = `{EDITABLE}` ).
    ENDIF.

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_render_pop_filter.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog(
      contentheight = `50%`
      contentwidth  = `50%`
        title       = `Define Conditons - Product` ).

    DATA(lo_vbox) = lo_popup->vbox( height         = `100%`
                                 justifycontent = `SpaceBetween` ).

    DATA(lo_pan)  = lo_vbox->panel(
         expandable = abap_false
         expanded   = abap_true
         headertext = `Product` ).
    DATA(lo_item) = lo_pan->list(
           "   headertext = `Product`
              nodata         = `no conditions defined`
             items           = mo_client->_bind_edit( mt_filter )
             selectionchange = mo_client->_event( `SELCHANGE` )
                )->custom_list_item( ).

    DATA(lo_grid) = lo_item->grid( ).

    lo_grid->combobox(
                 selectedkey = `{OPTION}`
                 items       = mo_client->_bind_edit( mt_mapping )
             )->item(
                     key  = `{N}`
                     text = `{N}`
             )->get_parent(
             )->input( value = `{LOW}`
             )->input( value   = `{HIGH}`
                       visible = `{= ${OPTION} === 'BT' }`
             )->button( icon  = `sap-icon://decline`
                        type  = `Transparent`
                        press = mo_client->_event( val = `POPUP_DELETE` t_arg = VALUE #( ( `${KEY}` ) ) ) ).

    lo_popup->footer( )->overflow_toolbar(
        )->button( text  = `Delete All`
                   icon  = `sap-icon://delete`
                   type  = `Transparent`
                   press = mo_client->_event( `POPUP_DELETE_ALL` )
        )->button( text  = `Add Item`
                   icon  = `sap-icon://add`
                   press = mo_client->_event( `POPUP_ADD` )
        )->toolbar_spacer(
        )->button(
            text  = `OK`
            press = mo_client->_event( `FILTER_VALUE_HELP_OK` )
            type  = `Emphasized`
       )->button(
            text  = `Cancel`
            press = mo_client->_event( `FILTER_VALUE_HELP_CANCEL` ) ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

ENDCLASS.
