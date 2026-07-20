"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBar
"! In this example, the Icon Tab Bar is used to apply filters on a table and display the count of the
"! items for each view.
CLASS z2ui5_cl_demo_app_368 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productname  TYPE string,
        suppliername TYPE string,
        measure      TYPE i,
        unit         TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA cnt_total TYPE i.
    DATA cnt_ok TYPE i.
    DATA cnt_heavy TYPE i.
    DATA cnt_overweight TYPE i.
    DATA selectedkey TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS set_data.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_368 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      set_data( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA items TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Icon Tab Bar - Filter Table`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBar` ).

    
    items = page->icon_tab_bar( class       = `sapUiResponsiveContentPadding`
                                      selectedkey = client->_bind( selectedkey )
                                      select      = client->_event( `TAB_SELECT` ) )->items( ).

    items->icon_tab_filter( count   = client->_bind( cnt_total )
                            text    = `Products`
                            key     = `ALL`
                            showall = abap_true ).
    items->icon_tab_separator( ).
    items->icon_tab_filter( icon      = `sap-icon://begin`
                            iconcolor = `Positive`
                            count     = client->_bind( cnt_ok )
                            text      = `OK`
                            key       = `OK` ).
    items->icon_tab_filter( icon      = `sap-icon://compare`
                            iconcolor = `Critical`
                            count     = client->_bind( cnt_heavy )
                            text      = `Heavy`
                            key       = `HEAVY` ).
    items->icon_tab_filter( icon      = `sap-icon://inventory`
                            iconcolor = `Negative`
                            count     = client->_bind( cnt_overweight )
                            text      = `Overweight`
                            key       = `OVERWEIGHT` ).

    page->table( inset          = abap_false
                 showseparators = `Inner`
                 headertext     = `Products`
                 items          = client->_bind( t_products )
        )->columns(
            )->column(
                )->text( `Product` )->get_parent(
            )->column(
                )->text( `Supplier` )->get_parent(
            )->column( halign = `End`
                )->text( `Weight` )->get_parent( )->get_parent(
        )->items(
            )->column_list_item(
               )->cells(
                 )->text( `{PRODUCTNAME}`
                 )->text( `{SUPPLIERNAME}`
                 )->text( `{MEASURE} {UNIT}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `TAB_SELECT`.

        set_data( ).
        client->view_model_update( ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE i.
    DATA i TYPE i.
    DATA temp4 LIKE LINE OF t_products.
    DATA temp5 TYPE i.
    DATA j TYPE i.
    DATA temp6 LIKE LINE OF t_products.
    DATA temp7 TYPE i.
    DATA k TYPE i.
    DATA row LIKE LINE OF t_products.
    CLEAR temp1.
    
    temp2-productname = `table`.
    temp2-suppliername = `Company 1`.
    temp2-measure = 100.
    temp2-unit = `KG`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productname = `chair`.
    temp2-suppliername = `Company 2`.
    temp2-measure = 123.
    temp2-unit = `KG`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productname = `sofa`.
    temp2-suppliername = `Company 3`.
    temp2-measure = 700.
    temp2-unit = `KG`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productname = `computer`.
    temp2-suppliername = `Company 4`.
    temp2-measure = 200.
    temp2-unit = `KG`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productname = `printer`.
    temp2-suppliername = `Company 5`.
    temp2-measure = 90.
    temp2-unit = `KG`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productname = `table2`.
    temp2-suppliername = `Company 6`.
    temp2-measure = 600.
    temp2-unit = `KG`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

    cnt_total      = lines( t_products ).
    
    
    i = 0.
    
    LOOP AT t_products INTO temp4 WHERE measure <= 100.
      i = i + 1.
    ENDLOOP.
    temp3 = i.
    cnt_ok         = temp3.
    
    
    j = 0.
    
    LOOP AT t_products INTO temp6 WHERE measure > 100 AND measure <= 500.
      j = j + 1.
    ENDLOOP.
    temp5 = j.
    cnt_heavy      = temp5.
    
    
    k = 0.
    
    LOOP AT t_products INTO row WHERE measure > 500.
      k = k + 1.
    ENDLOOP.
    temp7 = k.
    cnt_overweight = temp7.

    CASE selectedkey.
      WHEN `OK`.
        DELETE t_products WHERE measure > 100.
      WHEN `HEAVY`.
        DELETE t_products WHERE measure <= 100 OR measure > 500.
      WHEN `OVERWEIGHT`.
        DELETE t_products WHERE measure <= 500.
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The icon tab filters show a count per category and filter the table below on selection. The counts are bound to the backend and updated with the model.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
