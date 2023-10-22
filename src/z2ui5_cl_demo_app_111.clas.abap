class Z2UI5_CL_DEMO_APP_111 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab .
  types:
    ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY .

  data MV_SEARCH_VALUE type STRING .
  data MT_TABLE type TY_T_TABLE .
  data MV_KEY type STRING .
  data MV_PRODUCT type STRING .
  data MV_CREATE_DATE type STRING .
  data MV_CREATE_BY type STRING .
  data MV_STORAGE_LOCATION type STRING .
  data MV_QUANTITY type STRING .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_search.
    METHODS z2ui5_set_data.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_111 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      z2ui5_set_data( ).


      DATA(lv_script) = `debugger;sap.z2ui5.InitSvm = () => {` && |\n| &&
                        ` var oView = sap.z2ui5.oView` && |\n| &&
                        ` var oSmartVariantManagement = oView.byId("svm");` && |\n| &&
                        ` var oFilterBar = oView.byId("fbar");` && |\n| &&
                        ` var aData = _registerFetchData(oFilterBar);` && |\n| &&
                        ` oFilterBar.registerFetchData( aData );` && |\n| &&
                        ` oFilterBar.registerApplyData( _registerApplyData(oFilterBar, aData));` && |\n| &&
                        ` oFilterBar.registerGetFiltersWithValues( _registerGetFiltersWithValues(oFilterBar));` && |\n| &&
                        ` var oPersInfo = new sap.ui.comp.smartvariants.PersonalizableInfo({` && |\n| &&
                        `   type: "filterBar",` && |\n| &&
                        `   keyName: "persistencyKey",` && |\n| &&
                        `   dataSource: "",` && |\n| &&
                        `   control: oFilterBar` && |\n| &&
                        ` });` && |\n| &&
                        ` oSmartVariantManagement.addPersonalizableControl(oPersInfo);` && |\n| &&
                        ` oSmartVariantManagement.initialise(function () {oSmartVariantManagement.currentVariantSetModified(false);}, oFilterBar);` && |\n| &&
                        `};` && |\n| &&
                        `_registerFetchData = (oFilterBar) => {` && |\n| &&
                        ` var aData = oFilterBar.getAllFilterItems().reduce(function (aResult, oFilterItem) {` && |\n| &&
                        `   aResult.push({` && |\n| &&
                        `     groupName: oFilterItem.getGroupName(),` && |\n| &&
                        `     fieldName: oFilterItem.getName(),` && |\n| &&
                        `     fieldData: oFilterItem.getControl().getValue()` && |\n| &&
                        `   });` && |\n| &&
                        `   return aResult;` && |\n| &&
                        ` }, []);` && |\n| &&
                        ` return aData;` && |\n| &&
                        `};` && |\n| &&
                        `_registerApplyData = (oFilterBar, aData) => {` && |\n| &&
                        ` aData.forEach(function (oDataObject) {` && |\n| &&
                        `   var oControl = oFilterBar.determineControlByName(oDataObject.fieldName, oDataObject.groupName);` && |\n| &&
                        `   oControl.setValue(oDataObject.fieldData);` && |\n| &&
                        ` });` && |\n| &&
                        `};` && |\n| &&
                        `_registerGetFiltersWithValues = (oFilterBar) => {` && |\n| &&
                        ` var aFiltersWithValue = oFilterBar.getFilterGroupItems().reduce(function (aResult, oFilterGroupItem) {` && |\n| &&
                        `   var oControl = oFilterGroupItem.getControl();` && |\n| &&
                        `   if (oControl &amp;&amp; oControl.getValue &amp;&amp; oControl.getValue().length > 0) {` && |\n| &&
                        `       aResult.push(oFilterGroupItem);` && |\n| &&
                        `   }` && |\n| &&
                        `   return aResult;` && |\n| &&
                        ` }, []);` && |\n| &&
                        ` return aFiltersWithValue;` && |\n| &&
                        `};` && |\n| &&
                        `sap.z2ui5.onSearch = () => {` && |\n| &&
                        ` var oView = sap.z2ui5.oView` && |\n| &&
                        ` var oFilterBar = oView.byId("fbar");` && |\n| &&
                        ` var oTable = oView.byId("table1");` && |\n| &&
                        ` var aTableFilters = oFilterBar.getFilterGroupItems().reduce(function (aResult, oFilterGroupItem) {` && |\n| &&
                        `   var oControl = oFilterGroupItem.getControl(),` && |\n| &&
                        `       aSelectedKey = oControl.getValue(),` && |\n| &&
                        `       aFilters = return new sap.ui.model.Filter({` && |\n| &&
                        `                   path: oFilterGroupItem.getName(),` && |\n| &&
                        `                   operator: "Contains",` && |\n| &&
                        `                   value1: sSelectedKey` && |\n| &&
                        `                });` && |\n| &&
*                        `     });` && |\n| &&
                        ` if (aSelectedKey.length > 0) {` && |\n| &&
                        `     aResult.push(new sap.ui.model.Filter({` && |\n| &&
                        `                   filters: aFilters,` && |\n| &&
                        `                   and: false` && |\n| &&
                        `                 }));` && |\n| &&
                        ` }` && |\n| &&
                        ` return aResult;` && |\n| &&
                        `     }, []);` && |\n| &&
                        `  oTable.getBinding("items").filter(aTableFilters);` && |\n| &&
                        `};` && |\n| &&
                        `sap.z2ui5.onChange = (oEvent) => {` && |\n| &&
                        ` var oView = sap.z2ui5.oView` && |\n| &&
                        ` var oFilterBar = oView.byId("fbar");` && |\n| &&
                        ` var oSmartVariantManagement = oView.byId("svm");` && |\n| &&
                        ` oSmartVariantManagement.currentVariantSetModified(true);` && |\n| &&
                        ` oFilterBar.fireFilterChange(oEvent);` && |\n| &&
                        `}`.


      client->view_display( Z2UI5_cl_xml_view=>factory( client
        )->_cc_plain_xml( `<html:script>` && lv_script && `</html:script>`
        )->stringify( ) ).

      client->timer_set( event_finished = client->_event( `START` ) interval_ms = `0` ).


      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'START'.
        z2ui5_view_display( ).

      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
*        z2ui5_set_data( ).
*        z2ui5_set_search( ).
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
    ).

  ENDMETHOD.


  METHOD z2ui5_set_search.

    IF mv_search_value IS NOT INITIAL.

      LOOP AT mt_table REFERENCE INTO DATA(lr_row).
        DATA(lv_row) = ``.
        DATA(lv_index) = 1.
        DO.
          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO FIELD-SYMBOL(<field>).
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    view->_cc_plain_xml( `<html:script> sap.z2ui5.InitSvm(); </html:script>` ).

    DATA(page1) = view->page( id = `page_main`
            title          = 'abap2UI5 - List Report Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true ).

    page1->header_content(
          )->link(
              text = 'Demo' target = '_blank'
              href = 'https://twitter.com/abap2UI5/status/1674437273943937025'
          )->link(
              text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url(  )
     ).

    DATA(page) = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    DATA(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->smart_variant_management( id = `svm` showexecuteonselection = abap_true ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA(lo_fb) = page->header( )->dynamic_page_header( pinnable = abap_true ).

    lo_fb->filter_bar( id = `fbar` persistencykey = `myPersKey` usetoolbar = abap_false search = `sap.z2ui5.onSearch();`
      )->filter_group_items(
        )->filter_group_item( name = `PRODUCT` label = `Product` groupname = `group1` visibleinfilterbar = abap_true
          )->fb_control(
            )->input( value = client->_bind_edit( mv_product ) suggest = abap_true suggestionitems = `{/EDIT/MT_TABLE}` change = `sap.z2ui5.onChange();`
              )->get( )->suggestion_items( )->item( text = `{PRODUCT}`
            )->get_parent(  )->get_parent( )->get_parent( )->get_parent(
        )->filter_group_item( name = `CREATE_DATE` label = `Create Date` groupname = `group1` visibleinfilterbar = abap_true
          )->fb_control(
            )->input( value = client->_bind_edit( mv_create_date ) change = `sap.z2ui5.onChange();` )->get_parent(  )->get_parent(
        )->filter_group_item( name = `CREATE_BY` label = `Create By` groupname = `group1` visibleinfilterbar = abap_true
          )->fb_control(
            )->input( value = client->_bind_edit( mv_create_by ) change = `sap.z2ui5.onChange();`  )->get_parent(  )->get_parent(
        )->filter_group_item( name = `STORAGE_LOCATION` label = `Storage Location` groupname = `group1` visibleinfilterbar = abap_true
          )->fb_control(
            )->input( value = client->_bind_edit( mv_storage_location ) change = `sap.z2ui5.onChange();` )->get_parent( )->get_parent(
        )->filter_group_item( name = `QUANTITY` label = `Quantity` groupname = `group1` visibleinfilterbar = abap_true
          )->fb_control(
            )->input( suggest = abap_true suggestionItems = `{/EDIT/MT_TABLE}` value = client->_bind_edit( mv_quantity ) change = `sap.z2ui5.onChange($event);`
              )->get( )->suggestion_items( )->item( text = `{QUANTITY}`
            )->get_parent( )->get_parent( )->get_parent( ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->table( id = `table1` items = client->_bind_edit( val = mt_table ) ).

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

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
