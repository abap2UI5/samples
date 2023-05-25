CLASS z2ui5_cl_app_demo_56 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        key     TYPE string,
        text    TYPE string,
        visible TYPE abap_bool,
        selkz   TYPE abap_bool,
        editable   TYPE abap_bool,
      END OF ty_S_token.

    DATA mv_value TYPE string.
    DATA mt_token            TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY.
    DATA mt_token_sugg       TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY.

    DATA mt_mapping TYPE z2ui5_if_client=>ty_t_name_value.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.

    TYPES:
      BEGIN OF ty_S_filter,
        product TYPE RANGE OF string,
      END OF ty_S_filter.
    DATA ms_filter TYPE ty_s_filter.


  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_client=>ty_s_get,
        next              TYPE z2ui5_if_client=>ty_s_next,
      END OF app.


    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.
    METHODS z2ui5_on_render_main.
    METHODS z2ui5_on_render_pop_filter.

    METHODS z2ui5_set_data.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_56 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).
    app-view_popup = ``.
    app-next-title = `Filter`.


    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render( ).

    client->set_next( app-next ).
    CLEAR app-get.
    CLEAR app-next.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-get-event.

      WHEN `BUTTON_START`.
        z2ui5_set_data( ).

      WHEN `FILTER_UPDATE`.

        app-next-s_cursor-id = `FILTER`.
        app-next-s_cursor-cursorpos = `999`.
        app-next-s_cursor-selectionend = `999`.
        app-next-s_cursor-selectionstart  = `999`.

    if mv_value is not INITIAL.
        DATA ls_range LIKE LINE OF ms_filter-product.
        DATA(lv_length) = strlen( mv_value ) - 1.
        CASE mv_value(1).

          WHEN `=`.
            ls_range = VALUE #(  option = `EQ` low = mv_value+1 ).

          WHEN `<`.
            IF mv_value+1(1) = `=`.
              ls_range = VALUE #(  option = `LE` low = mv_value+2 ).
            ELSE.
              ls_range = VALUE #(  option = `LT` low = mv_value+1 ).
            ENDIF.
          WHEN `>`.
            IF mv_value+1(1) = `=`.
              ls_range = VALUE #(  option = `GE` low = mv_value+2 ).
            ELSE.
              ls_range = VALUE #(  option = `GT` low = mv_value+1 ).
            ENDIF.

          WHEN `*`.
            IF mv_value+lv_length(1) = `*`.
              SHIFT mv_value RIGHT DELETING TRAILING `*`.
              SHIFT mv_value LEFT DELETING LEADING `*`.
              ls_range = VALUE #(  option = `CP` low = mv_value ).
            ENDIF.

            "wenn letzt

          WHEN OTHERS.

            IF mv_value CP `...`.
              SPLIT mv_value AT `...` INTO ls_range-low ls_range-high.
              ls_range-option = `BT`.
           else.
            ls_range = VALUE #( option = `EQ` low = mv_value ).
           endif.

        ENDCASE.

        INSERT ls_range INTO TABLE ms_filter-product.

        endif.
      WHEN `FILTER_VALUE_HELP`.
        app-next-s_cursor-id = `FILTER`.
        app-next-s_cursor-cursorpos = `999`.
        app-next-s_cursor-selectionend = `999`.
        app-next-s_cursor-selectionstart  = `999`.
        app-view_popup = `VALUE_HELP`.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-id_prev_app_stack ) ).

    ENDCASE.


    clear mv_value.
    clear mt_token.
    LOOP AT ms_filter-product REFERENCE INTO DATA(lr_row).

      DATA(lv_value) = mt_mapping[ name = lr_row->option ]-value.

      REPLACE `{LOW}` IN lv_value WITH lr_row->low.
      REPLACE `{HIGH}` IN lv_value WITH lr_row->high.

      INSERT VALUE #( key = lv_value text = lv_value visible = abap_true editable = abap_false ) INTO TABLE mt_token.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    app-view_main = `MAIN`.

    mt_mapping = VALUE #(
    (  name = `EQ` value = `={LOW}`    )
    (   name = `LT` value = `<{LOW}`   )
    (   name = `LE` value = `<={LOW}`  )
    (   name = `GT` value = `>{LOW}`   )
    (   name = `GE` value = `>={LOW}`  )
    (   name = `CP` value = `*{LOW}*`  )

    (   name = `BT` value = `{LOW}...{HIGH}` )
    (   name = `NE` value = `!(={LOW})`    )
    (   name = `NE` value = `!(<leer>)`    )
    ( name = `<leer>` value = `<leer>`    )

   ).


  ENDMETHOD.


  METHOD z2ui5_on_render.

    CASE app-view_popup.
      WHEN `VALUE_HELP`.
        z2ui5_on_render_pop_filter( ).
    ENDCASE.

    CASE app-view_main.
      WHEN 'MAIN'.
        z2ui5_on_render_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory(
        )->page( id = `page_main`
                title          = 'abap2UI5 - List Report Features'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/OblomovDev/status/1637163852264624139'
                )->link(
                    text = 'Source_Code' target = '_blank' href = z2ui5_cl_xml_view=>hlp_get_source_code_url( app = me get = client->get( ) )
           )->get_parent( ).

    DATA(page) = view->dynamic_page(
            headerexpanded = abap_true
            headerpinned   = abap_true
            ).

    DATA(header_title) = page->title( ns = 'f'
            )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->hbox(
        )->title( `Filter` ).

    header_title->expanded_content( 'f' ).

    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

    lo_box->vbox(
        )->text(  `Product:`
        )->multi_input(
                    tokens          = client->_bind( mt_token )
                    showclearicon   = abap_true
                    value           = client->_bind( mv_value )
*                    tokenUpdate     = client->_event( val = 'FILTER_UPDATE1' data = `$event` )
                    tokenUpdate     = client->_event( val = 'FILTER_UPDATE1' data = `JSON.parse( ${$parameters>/removedTokens} )` )
                    submit          = client->_event( 'FILTER_UPDATE' )
                    id              = `FILTER`
                    valueHelpRequest  = client->_event( 'FILTER_VALUE_HELP' )
*                    enabled = abap_false
                )->item(
                        key = `{KEY}`
                        text = `{TEXT}`
                )->tokens(
                    )->token(
                        key = `{KEY}`
                        text = `{TEXT}`
                        visible = `{VISIBLE}`
                        selected = `{SELKZ}`
                        editable = `{EDITABLE}`
        ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go` press = client->_event( `BUTTON_START` ) type = `Emphasized`
        ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->table( items = client->_bind( val = mt_table ) ).

    DATA(lo_columns) = tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    DATA(lo_cells) = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    app-next-xml_main = page->get_root( )->xml_get( ).

  ENDMETHOD.



  METHOD z2ui5_on_render_pop_filter.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup->dialog( 'abap2UI5 - Popup to select entry'
*        )->table(
*            mode = 'MultiSelect'
*            items = client->_bind( ms_layout-t_filter_show )
*            )->columns(
*                )->column( )->text( 'Title' )->get_parent(
*                )->column( )->text( 'Color' )->get_parent(
*                )->column( )->text( 'Info' )->get_parent(
*                )->column( )->text( 'Description' )->get_parent(
*            )->get_parent(
*            )->items( )->column_list_item( selected = '{SELKZ}'
*                )->cells(
*             "       )->checkbox( '{SELKZ}'
*                    )->text( '{NAME}'
*                    )->text( '{VALUE}'
*             "       )->text( '{DESCR}'
*        )->get_parent( )->get_parent( )->get_parent( )->get_parent(
        )->footer( )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text  = 'continue'
                press = client->_event( 'FILTER_VALUE_HELP_CONTINUE' )
                type  = 'Emphasized' ).

    app-next-xml_popup = lo_popup->get_root( )->xml_get( ).

  ENDMETHOD.

  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( product = 'table'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'computer' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'oven'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'table2'   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
    ).

  ENDMETHOD.

ENDCLASS.
