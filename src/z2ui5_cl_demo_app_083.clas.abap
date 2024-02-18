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
    DATA mv_value2      TYPE string.
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

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render_main.
    METHODS z2ui5_on_render_pop_filter.
    METHODS z2ui5_set_data.

  PRIVATE SECTION.
    DATA mt_cols TYPE string_table.

ENDCLASS.



CLASS z2ui5_cl_demo_app_083 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.

        CREATE DATA mt_table TYPE (mv_name).
        z2ui5_on_render_main( ).

      WHEN `FILTER_UPDATE`.
        IF mv_value IS NOT INITIAL.
          DATA ls_range TYPE z2ui5_cl_util_api=>ty_s_range.
          ls_range = z2ui5_cl_util=>filter_get_range_by_token( mv_value ).
          INSERT ls_range INTO TABLE ms_filter-product.
        ENDIF.

      WHEN `FILTER_VALUE_HELP_OK`.
        CLEAR ms_filter-product.
        LOOP AT mt_filter REFERENCE INTO DATA(lr_filter).
          INSERT VALUE #(
              sign = `I`
              option = lr_filter->option
              low = lr_filter->low
              high = lr_filter->high
           ) INTO TABLE ms_filter-product.
        ENDLOOP.

        client->popup_destroy( ).

      WHEN `POPUP_ADD`.
        INSERT VALUE #( key = z2ui5_cl_util=>uuid_get_c32( ) ) INTO TABLE mt_filter.
        client->popup_model_update( ).

      WHEN `POPUP_DELETE`.
        DATA(lt_item) = client->get( )-t_event_arg.
        DELETE mt_filter WHERE key = lt_item[ 1 ].
        client->popup_model_update( ).

      WHEN `POPUP_DELETE_ALL`.
        mt_filter = VALUE #( ).
        client->popup_model_update( ).

      WHEN `FILTER_VALUE_HELP`.
        z2ui5_on_render_pop_filter( ).

        CLEAR mt_filter.
        LOOP AT ms_filter-product REFERENCE INTO DATA(lr_product).
          INSERT VALUE #(
                   low = lr_product->low
                   high = lr_product->high
                   option = lr_product->option
                   key = z2ui5_cl_util=>uuid_get_c32( )
           ) INTO TABLE mt_filter.

        ENDLOOP.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    mt_01 = VALUE #( ( screen_name = `screen_01` ) ( screen_name = `screen_02` ) ).

    mt_02 = VALUE #(
    ( screen_name = `screen_01` field_doma = `CHAR30` field = `MATNR` )
    ( screen_name = `screen_01` field_doma = `STRING` field = `LGNUM` )
    ( screen_name = `screen_02` field_doma = `PRODUCT` field = `PRODUCT` )
    ).

    mv_name = `screen_01`.
    z2ui5_on_render_main( ).

    mt_mapping = VALUE #(
    (   n = `EQ`     v = `={LOW}`    )
    (   n = `LT`     v = `<{LOW}`   )
    (   n = `LE`     v = `<={LOW}`  )
    (   n = `GT`     v = `>{LOW}`   )
    (   n = `GE`     v = `>={LOW}`  )
    (   n = `CP`     v = `*{LOW}*`  )
    (   n = `BT`     v = `{LOW}...{HIGH}` )
    (   n = `NE`     v = `!(={LOW})`    )
    (   n = `NE`     v = `!(<leer>)`    )
    (   n = `<leer>` v = `<leer>`    )
    ).

  ENDMETHOD.

  METHOD z2ui5_on_render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view = view->page( id = `page_main`
             title          = 'abap2UI5 - Select-Options'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         )->header_content(
             )->link(
                 text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    DATA(page) = view->dynamic_page(
            headerexpanded = abap_true
            headerpinned   = abap_true
            ).

    DATA(header_title) = page->title( ns = 'f'
            )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->hbox(
        )->title( `Select-Option` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    DATA(vbox) = lo_box->vbox( ).
    vbox->simple_form(  editable = abap_true
            )->content( `form`
                )->title( 'Table'
                )->label( 'Name' ).

    vbox->input( client->_bind_edit( mv_name  ) ).

    vbox->button(
                text  = 'read'
                press = client->_event( 'BUTTON_POST' )
            ).

    vbox = lo_box->vbox( ).

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
      vbox->list(
        items = client->_bind( mt_tab_02_input )
        headertext      = `Filter`
        )->custom_list_item(
            )->hbox(
                )->text( `{NAME}`
            )->multi_input(
                tokens          = client->_bind( mt_token )
                showclearicon   = abap_true
                value           = `{VALUE}`
                tokenupdate     = client->_event( val = 'FILTER_UPDATE1'  )
                submit          = client->_event( 'FILTER_UPDATE' )
                id              = `FILTER`
                valuehelprequest  = client->_event( 'FILTER_VALUE_HELP' )
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

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD z2ui5_on_render_pop_filter.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog(
    contentheight = `50%`
    contentwidth = `50%`
        title = 'Define Conditons - Product' ).

    DATA(vbox) = lo_popup->vbox( height = `100%` justifycontent = 'SpaceBetween' ).

    DATA(pan)  = vbox->panel(
         expandable = abap_false
         expanded   = abap_true
         headertext = `Product`
     ).
    DATA(item) = pan->list(
           "   headertext = `Product`
              nodata = `no conditions defined`
             items           = client->_bind_edit( mt_filter )
             selectionchange = client->_event( 'SELCHANGE' )
                )->custom_list_item( ).

    DATA(grid) = item->grid( ).

    grid->combobox(
                 selectedkey = `{OPTION}`
                 items       = client->_bind_edit( mt_mapping )
             )->item(
                     key = '{N}'
                     text = '{N}'
             )->get_parent(
             )->input( value = `{LOW}`
             )->input( value = `{HIGH}`  visible = `{= ${OPTION} === 'BT' }`
             )->button( icon = 'sap-icon://decline' type = `Transparent` press = client->_event( val = `POPUP_DELETE` t_arg = VALUE #( ( `${KEY}` ) ) )
             ).

    lo_popup->footer( )->overflow_toolbar(
        )->button( text = `Delete All` icon = 'sap-icon://delete' type = `Transparent` press = client->_event( val = `POPUP_DELETE_ALL` )
        )->button( text = `Add Item`   icon = `sap-icon://add` press = client->_event( val = `POPUP_ADD` )
        )->toolbar_spacer(
        )->button(
            text  = 'OK'
            press = client->_event( 'FILTER_VALUE_HELP_OK' )
            type  = 'Emphasized'
       )->button(
            text  = 'Cancel'
            press = client->_event( 'FILTER_VALUE_HELP_CANCEL' )
       ).

    client->popup_display( lo_popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    "replace this with a db select here...
*    mt_table = VALUE #(
*        ( product = 'table'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
*        ( product = 'chair'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
*        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
*        ( product = 'computer' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
*        ( product = 'oven'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
*        ( product = 'table2'   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
*    ).

    "put the range in the where clause of your abap sql command
    "using internal table instead
*    DELETE mt_table WHERE product NOT IN ms_filter-product.

  ENDMETHOD.
ENDCLASS.
