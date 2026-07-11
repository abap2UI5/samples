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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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

    IF client->check_on_init( ).

      set_data( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar` ).

    DATA(items) = page->icon_tab_bar( class       = `sapUiResponsiveContentPadding`
                                      selectedkey = client->_bind_edit( selectedkey )
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

    t_products = VALUE #(
        ( productname = `table`    suppliername = `Company 1` measure = 100 unit = `KG` )
        ( productname = `chair`    suppliername = `Company 2` measure = 123 unit = `KG` )
        ( productname = `sofa`     suppliername = `Company 3` measure = 700 unit = `KG` )
        ( productname = `computer` suppliername = `Company 4` measure = 200 unit = `KG` )
        ( productname = `printer`  suppliername = `Company 5` measure = 90  unit = `KG` )
        ( productname = `table2`   suppliername = `Company 6` measure = 600 unit = `KG` ) ).

    cnt_total      = lines( t_products ).
    cnt_ok         = REDUCE i( INIT i = 0 FOR row IN t_products WHERE ( measure <= 100 ) NEXT i = i + 1 ).
    cnt_heavy      = REDUCE i( INIT j = 0 FOR row IN t_products WHERE ( measure > 100 AND measure <= 500 ) NEXT j = j + 1 ).
    cnt_overweight = REDUCE i( INIT k = 0 FOR row IN t_products WHERE ( measure > 500 ) NEXT k = k + 1 ).

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

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
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
