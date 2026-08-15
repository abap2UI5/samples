" @keywords live search parallel requests busy queue typing
CLASS z2ui5_cl_smp_app_059 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

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
    DATA mv_field TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_059 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      set_data( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `BUTTON_SEARCH` ).

      set_data( ).
      z2ui5_cl_smp_context=>itab_filter_by_val(
        EXPORTING
          val = mv_field
        CHANGING
          tab = mt_table ).

    ENDIF.

  ENDMETHOD.


  METHOD set_data.

    mt_table = VALUE #( ).
    DO 1000 TIMES.
      INSERT LINES OF VALUE ty_t_table(
          ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
          ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
          ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
          ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
          ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
          ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
          ) INTO TABLE mt_table.

    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page1) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Live Search with Parallel Requests`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    page1->tag( `MessageStrip`
        )->a( n = `text`     v = `By default abap2UI5 handles only one backend request at a time - the app is set busy and further ` &&
                   `requests are ignored until the running one is finished. A live search needs the opposite: only the ` &&
                   `newest request matters and older ones can be dropped. Set check_allow_multi_req on the event to ` &&
                   `allow that - type in both fields and compare.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(lo_box) = page1->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMarginBegin` ).

    lo_box->ele( `VBox`
        )->tag( `Text`
            )->a( n = `text` v = `Search disabled parallel (default)`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `value`       v = client->_bind( mv_field )
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->_event( `BUTTON_SEARCH` ) ).

    lo_box->ele( `VBox`
        )->tag( `Text`
            )->a( n = `text` v = `Search parallel`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `value`       v = client->_bind( mv_field )
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->_event(
                val    = `BUTTON_SEARCH`
                s_ctrl = VALUE #( check_allow_multi_req = abap_true ) ) ).

    DATA(tab) = page1->ele( `Table`
        )->a( n = `items` v = client->_bind( mt_table ) ).
    DATA(lo_columns) = tab->ele( `columns` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Product` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Date` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Name` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Location` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Quantity` ).

    DATA(lo_cells) = tab->ele( `items`
        )->ele( `ColumnListItem` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{PRODUCT}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{CREATE_DATE}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{CREATE_BY}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{STORAGE_LOCATION}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
