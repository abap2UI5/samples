CLASS z2ui5_cl_demo_app_059 DEFINITION PUBLIC.

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
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mt_table TYPE ty_t_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_059 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      set_data( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    me->client = client.

    IF client->check_on_event( `BUTTON_SEARCH` ) IS NOT INITIAL.
      set_data( ).
      z2ui5_cl_sample_context=>itab_filter_by_val(
          EXPORTING
              val = client->get_event_arg( )
          CHANGING
              tab = mt_table ).

      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD set_data.

    DATA temp1 TYPE z2ui5_cl_demo_app_059=>ty_t_table.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product = `table`.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `chair`.
    temp2-create_date = `01.01.2022`.
    temp2-create_by = `James`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 123.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `sofa`.
    temp2-create_date = `01.05.2021`.
    temp2-create_by = `Simone`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 700.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `computer`.
    temp2-create_date = `27.01.2023`.
    temp2-create_by = `Theo`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 200.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `printer`.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Hannah`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 90.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `table2`.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Julia`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 110.
    INSERT temp2 INTO TABLE temp1.
    mt_table = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    DATA temp1 TYPE z2ui5_if_types=>ty_s_event_control.
    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page1 = view->shell( )->page( id = `page_main`
            title                          = `abap2UI5 - Search Field with Backend Live Change`
            navbuttonpress                 = client->_event_nav_app_leave( )
            shownavbutton                  = client->check_app_prev_stack( ) ).

    page1->message_strip(
        text     = `The search field's livechange event sends every keystroke to the backend (multiple ` &&
                   `parallel requests allowed) to live-filter the table as the user types.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    CLEAR temp3.
    INSERT `${$source>/value}` INTO TABLE temp3.
    
    CLEAR temp1.
    temp1-check_allow_multi_req = abap_true.
    
    lo_box = page1->vbox( )->text( `Search`
        )->search_field( width      = `17.5rem`
                         livechange = client->_event(
                         val        = `BUTTON_SEARCH`
                         t_arg      = temp3
                         s_ctrl     = temp1 ) ).

    
    tab = lo_box->table( client->_bind( mt_table ) ).
    
    lo_columns = tab->columns( ).
    lo_columns->column( )->text( `Product` ).
    lo_columns->column( )->text( `Date` ).
    lo_columns->column( )->text( `Name` ).
    lo_columns->column( )->text( `Location` ).
    lo_columns->column( )->text( `Quantity` ).

    
    lo_cells = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
