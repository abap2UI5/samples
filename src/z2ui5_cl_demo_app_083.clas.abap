CLASS Z2UI5_CL_DEMO_APP_083 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_S_tab_01,
        screen_name TYPE string,
      END OF ty_S_tab_01.

    DATA mt_01 TYPE STANDARD TABLE OF ty_s_tab_01 WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_S_tab_02,
        screen_name TYPE string,
        field       TYPE string,
        field_doma  TYPE string,
      END OF ty_S_tab_02.

    DATA mt_02 TYPE STANDARD TABLE OF ty_s_tab_02 WITH EMPTY KEY.
    data mt_02_display TYPE STANDARD TABLE OF ty_s_tab_02 WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_S_tab_02_input,
        name        TYPE string,
        value       TYPE string,
      END OF ty_S_tab_02_input.

    DATA mt_tab_02_input TYPE STANDARD TABLE OF ty_s_tab_02_input WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_S_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_S_filter_pop.
    DATA mt_filter TYPE STANDARD TABLE OF ty_S_filter_pop WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ty_S_token.

    DATA mv_value       TYPE string.
    DATA mv_value2      TYPE string.
    DATA mt_token       TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY.

    DATA mt_mapping TYPE Z2UI5_if_client=>ty_t_name_value.

*    TYPES:
*      BEGIN OF ty_s_tab,
*        selkz            TYPE abap_bool,
*        product          TYPE string,
*        create_date      TYPE string,
*        create_by        TYPE string,
*        storage_location TYPE string,
*        quantity         TYPE i,
*      END OF ty_s_tab.
*    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

*    DATA mt_table TYPE ty_t_table.

    TYPES ty_t_range TYPE RANGE OF string.
    TYPES ty_s_range TYPE LINE OF ty_T_range.
    TYPES:
      BEGIN OF ty_S_filter,
        product TYPE ty_t_range,
      END OF ty_S_filter.

    DATA ms_filter TYPE ty_s_filter.
    DATA mv_name TYPE string.

    DATA mt_table TYPE REF TO data.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_on_render_main.
    METHODS Z2UI5_on_render_pop_filter.
    METHODS Z2UI5_set_data.
    METHODS map_range_to_token.

    CLASS-METHODS hlp_get_range_by_value
      IMPORTING
        VALUE(value)  TYPE string
      RETURNING
        VALUE(result) TYPE ty_S_range.

    CLASS-METHODS hlp_get_uuid
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    DATA mt_cols TYPE string_table.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_083 IMPLEMENTATION.


  METHOD hlp_get_range_by_value.

    DATA(lv_length) = strlen( value ) - 1.
    CASE value(1).

      WHEN `=`.
        result = VALUE #(  option = `EQ` low = value+1 ).
      WHEN `<`.
        IF value+1(1) = `=`.
          result = VALUE #(  option = `LE` low = value+2 ).
        ELSE.
          result = VALUE #(  option = `LT` low = value+1 ).
        ENDIF.
      WHEN `>`.
        IF value+1(1) = `=`.
          result = VALUE #(  option = `GE` low = value+2 ).
        ELSE.
          result = VALUE #(  option = `GT` low = value+1 ).
        ENDIF.

      WHEN `*`.
        IF value+lv_length(1) = `*`.
          SHIFT value RIGHT DELETING TRAILING `*`.
          SHIFT value LEFT DELETING LEADING `*`.
          result = VALUE #( sign = `I` option = `CP` low = value ).
        ENDIF.

      WHEN OTHERS.
        IF value CP `...`.
          SPLIT value AT `...` INTO result-low result-high.
          result-option = `BT`.
        ELSE.
          result = VALUE #( sign = `I` option = `EQ` low = value ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD hlp_get_uuid.

    DATA uuid TYPE sysuuid_c32.

    TRY.
        CALL METHOD ('CL_SYSTEM_UUID')=>create_uuid_c32_static
          RECEIVING
            uuid = uuid.
      CATCH cx_sy_dyn_call_illegal_class.

        DATA(lv_fm) = 'GUID_CREATE'.
        CALL FUNCTION lv_fm
          IMPORTING
            ev_guid_32 = uuid.
    ENDTRY.

    result = uuid.

  ENDMETHOD.


  METHOD map_range_to_token.

    CLEAR mv_value.
    CLEAR mt_token.
    LOOP AT ms_filter-product REFERENCE INTO DATA(lr_row).

      DATA(lv_value) = mt_mapping[ n = lr_row->option ]-v.
      REPLACE `{LOW}`  IN lv_value WITH lr_row->low.
      REPLACE `{HIGH}` IN lv_value WITH lr_row->high.

      INSERT VALUE #( key = lv_value text = lv_value visible = abap_true editable = abap_false ) INTO TABLE mt_token.
    ENDLOOP.

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_on_init( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.

        CREATE DATA mt_table TYPE (mv_name).
        Z2UI5_on_render_main( ).

      WHEN `FILTER_UPDATE`.
        IF mv_value IS NOT INITIAL.
          DATA(ls_range) = hlp_get_range_by_value( mv_value ).
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
        INSERT VALUE #( key = hlp_get_uuid( ) ) INTO TABLE mt_filter.
        client->popup_model_update( ).

      WHEN `POPUP_DELETE`.
        DATA(lt_item) = client->get( )-t_event_arg.
        DELETE mt_filter WHERE key = lt_item[ 1 ].
        client->popup_model_update( ).

      WHEN `POPUP_DELETE_ALL`.
        mt_filter = VALUE #( ).
        client->popup_model_update( ).

      WHEN `FILTER_VALUE_HELP`.
        Z2UI5_on_render_pop_filter( ).

        CLEAR mt_filter.
        LOOP AT ms_filter-product REFERENCE INTO DATA(lr_product).
          INSERT VALUE #(
                   low = lr_product->low
                   high = lr_product->high
                   option = lr_product->option
                   key = hlp_get_uuid( )
           ) INTO TABLE mt_filter.

        ENDLOOP.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.

    mt_01 = VALUE #( ( screen_name = `screen_01` ) ( screen_name = `screen_02` ) ).

    mt_02 = VALUE #(
    ( screen_name = `screen_01` field_doma = `CHAR30` field = `MATNR` )
    ( screen_name = `screen_01` field_doma = `STRING` field = `LGNUM` )
    ( screen_name = `screen_02` field_doma = `PRODUCT` field = `PRODUCT` )
    ).



    mv_name = `screen_01`.

    Z2UI5_on_render_main( ).

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

  METHOD Z2UI5_on_render_main.

    DATA(view) = Z2UI5_cl_xml_view=>factory( client ).

    view = view->page( id = `page_main`
             title          = 'abap2UI5 - Select-Options'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton  = abap_true
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
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

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

    IF mt_02 IS not INITIAL.

    mt_02_display = mt_02.
    delete mt_02_display where screen_name <> mv_name.



*      FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
*      ASSIGN mt_table->* TO <tab>.

*      mt_cols = Z2UI5_tool_cl_utility=>get_fieldlist_by_table( mt_02 ).

      mt_tab_02_input = VALUE #( FOR line IN mt_cols ( name = line ) ).

        loop at mt_02_display REFERENCE INTO data(lr_tab).
            insert value #(
                name = lr_tab->field
*                value = lr_tab->field_doma
                     ) into table mt_tab_02_input.
        endloop.
*
      vbox->list(
        items = client->_bind( mt_tab_02_input )
        headertext      = `Filter`
        )->custom_list_item(
            )->hbox(
                )->text( `{NAME}`
*                )->input( value = `{VALUE}` enabled = abap_true

            )->multi_input(
                tokens          = client->_bind( mt_token )
                showclearicon   = abap_true
                value           = `{VALUE}`
                tokenUpdate     = client->_event( val = 'FILTER_UPDATE1'  )
                submit          = client->_event( 'FILTER_UPDATE' )
                id              = `FILTER`
                valueHelpRequest  = client->_event( 'FILTER_VALUE_HELP' )
            )->item(
                    key  = `{KEY}`
                    text = `{TEXT}`
            )->tokens(
                )->token(
                    key      = `{KEY}`
                    text     = `{TEXT}`
                    visible  = `{VISIBLE}`
                    selected = `{SELKZ}`
                    editable = `{EDITABLE}`

        ).

*      DATA(tab) = view->get_parent( )->get_parent( )->simple_form( editable = abap_true
*                )->content( 'form' )->table(
*                  items = client->_bind( val = mt_02 )
*              ).
*
*      DATA(lo_columns) = tab->columns( ).
*
*
*      LOOP AT mt_cols INTO DATA(lv_field) FROM 2.
*        lo_columns->column( )->text( lv_field ).
*      ENDLOOP.
*
*      DATA(lo_cells) = tab->items( )->column_list_item( selected = '{SELKZ}' )->cells( ).
*      LOOP AT mt_cols INTO lv_field FROM 2.
*        lo_cells->input( `{` && lv_field && `}` ).
*      ENDLOOP.

    ENDIF.


*    DATA(vbox) = lo_box->vbox( ).
*    vbox->text(  `Product:`
*    )->multi_input(
*                tokens          = client->_bind( mt_token )
*                showclearicon   = abap_true
*                value           = client->_bind( mv_value )
*                tokenUpdate     = client->_event( val = 'FILTER_UPDATE1'  )
*                submit          = client->_event( 'FILTER_UPDATE' )
*                id              = `FILTER`
*                valueHelpRequest  = client->_event( 'FILTER_VALUE_HELP' )
*            )->item(
*                    key  = `{KEY}`
*                    text = `{TEXT}`
*            )->tokens(
*                )->token(
*                    key      = `{KEY}`
*                    text     = `{TEXT}`
*                    visible  = `{VISIBLE}`
*                    selected = `{SELKZ}`
*                    editable = `{EDITABLE}` ).
*
*    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
*        text = `Go` press = client->_event( `BUTTON_START` ) type = `Emphasized`
*        ).

*    DATA(cont) = page->content( ns = 'f' ).

*    DATA(tab) = cont->table( items = client->_bind( val = mt_table ) ).
*
*    DATA(lo_columns) = tab->columns( ).
*    lo_columns->column( )->text( text = `Product` ).
*    lo_columns->column( )->text( text = `Date` ).
*    lo_columns->column( )->text( text = `Name` ).
*    lo_columns->column( )->text( text = `Location` ).
*    lo_columns->column( )->text( text = `Quantity` ).
*
*    DATA(lo_cells) = tab->items( )->column_list_item( ).
*    lo_cells->text( `{PRODUCT}` ).
*    lo_cells->text( `{CREATE_DATE}` ).
*    lo_cells->text( `{CREATE_BY}` ).
*    lo_cells->text( `{STORAGE_LOCATION}` ).
*    lo_cells->text( `{QUANTITY}` ).

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD Z2UI5_on_render_pop_filter.

    DATA(lo_popup) = Z2UI5_cl_xml_view=>factory_popup( client ).

    lo_popup = lo_popup->dialog(
    contentheight = `50%`
    contentwidth = `50%`
        title = 'Define Conditons - Product' ).

    DATA(vbox) = lo_popup->vbox( height = `100%` justifyContent = 'SpaceBetween' ).

    DATA(pan)  = vbox->panel(
         expandable = abap_false
         expanded   = abap_true
         headertext = `Product`
     ).
    DATA(item) = pan->list(
           "   headertext = `Product`
              noData = `no conditions defined`
             items           = client->_bind_edit( mt_filter )
             selectionchange = client->_event( 'SELCHANGE' )
                )->custom_list_item( ).

    DATA(grid) = item->grid( ).

    grid->combobox(
                 selectedkey = `{OPTION}`
                 items       = client->_bind_Edit( mt_mapping )
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


  METHOD Z2UI5_set_data.

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
