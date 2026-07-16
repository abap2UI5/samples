"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.ResponsiveSplitter/sample/sap.ui.layout.sample.ResponsiveSplitter
"! ResponsiveSplitter is used to visually divide the content of its parent. It consists of
"! PaneContainers that further agregate other PaneContainers and SplitPanes. SplitPanes can be moved to
"! the pagination when a minimum width of their parent is reached.
CLASS z2ui5_cl_demo_app_103 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name       TYPE string,
        product_id TYPE string,
        quantity   TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_products TYPE ty_t_product.
    DATA t_products_sorted TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS resize_message
      IMPORTING
        val TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_103 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_products = VALUE #(
        ( name = `Notebook Basic 15`        product_id = `HT-1000` quantity = `10` )
        ( name = `Notebook Basic 17`        product_id = `HT-1001` quantity = `20` )
        ( name = `Notebook Basic 18`        product_id = `HT-1002` quantity = `10` )
        ( name = `Notebook Basic 19`        product_id = `HT-1003` quantity = `15` )
        ( name = `ITelO Vault`              product_id = `HT-1007` quantity = `15` )
        ( name = `Notebook Professional 15` product_id = `HT-1010` quantity = `16` )
        ( name = `Notebook Professional 17` product_id = `HT-1011` quantity = `17` )
        ( name = `ITelO Vault Net`          product_id = `HT-1020` quantity = `14` )
        ( name = `ITelO Vault SAT`          product_id = `HT-1021` quantity = `50` )
        ( name = `Comfort Easy`             product_id = `HT-1022` quantity = `30` )
        ( name = `Comfort Senior`           product_id = `HT-1023` quantity = `24` )
        ( name = `Ergo Screen E-I`          product_id = `HT-1030` quantity = `14` )
        ( name = `Ergo Screen E-II`         product_id = `HT-1031` quantity = `24` )
        ( name = `Ergo Screen E-III`        product_id = `HT-1032` quantity = `50` )
        ( name = `Flat Basic`               product_id = `HT-1035` quantity = `23` )
        ( name = `Flat Future`              product_id = `HT-1036` quantity = `22` ) ).
    " the original sorts the select items by name via a model sorter - a sorted copy of the table is bound instead
    t_products_sorted = t_products.
    SORT t_products_sorted BY name.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ROOT_RESIZE`.
        resize_message( `Root container is resized.` ).
      WHEN `INNER_RESIZE`.
        resize_message( `Inner container is resized.` ).
    ENDCASE.

  ENDMETHOD.


  METHOD resize_message.

    DATA(old_sizes) = client->get_event_arg( ).
    DATA(new_sizes) = client->get_event_arg( 2 ).
    DATA(message)   = val.

    IF old_sizes IS NOT INITIAL.
      message = |{ message }{ z2ui5_cl_sample_context=>cv_char_util_newline }Old panes sizes = [{ old_sizes }]|.
    ENDIF.

    message = |{ message }{ z2ui5_cl_sample_context=>cv_char_util_newline }New panes sizes = [{ new_sizes }]|.
    client->message_toast_display( message ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: ResponsiveSplitter`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.ResponsiveSplitter/sample/sap.ui.layout.sample.ResponsiveSplitter` ).

    " the original binds the pane sizes to a JSON model initialized with 'auto' - the sizes are set as literals instead
    DATA(root_container) = page->responsive_splitter( defaultpane = `default`
        )->pane_container( resize = client->_event( val   = `ROOT_RESIZE`
                                                    t_arg = VALUE #( ( `${$parameters>/oldSizes}` )
                                                                     ( `${$parameters>/newSizes}` ) ) ) ).

    root_container->split_pane(
        requiredparentwidth = `400`
        id                  = `default`
        )->layout_data( `layout`
            )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
        )->panel(
            headertext = `Minimum parent width 400`
            height     = `100%`
            )->text( `LayoutData.size=auto`
            )->list(
                headertext = `Products`
                items      = client->_bind( t_products )
                )->standard_list_item(
                    title   = `{NAME}`
                    counter = `{QUANTITY}` ).

    DATA(inner_container) = root_container->pane_container(
        orientation = `Vertical`
        resize      = client->_event( val   = `INNER_RESIZE`
                                      t_arg = VALUE #( ( `${$parameters>/oldSizes}` )
                                                       ( `${$parameters>/newSizes}` ) ) ) ).

    inner_container->split_pane( requiredparentwidth = `600`
        )->layout_data( `layout`
            )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
        )->panel( headertext = `Minimum parent width 600`
            )->vbox(
                )->text( `LayoutData.size=auto`
                )->select(
                    forceselection = abap_false
                    selectedkey    = `1239102`
                    items          = client->_bind( t_products_sorted )
                    )->item(
                        key  = `{PRODUCT_ID}`
                        text = `{NAME}` ).

    DATA(pane_page) = inner_container->split_pane( requiredparentwidth = `800`
        )->layout_data( `layout`
            )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
        )->page( `Minimum parent width 800` ).

    pane_page->text( `LayoutData.size=auto` ).

    pane_page->footer(
        )->overflow_toolbar(
            )->label( `Buttons:`
            )->toolbar_spacer(
            )->button(
                text = `New`
                type = `Transparent`
            )->button(
                text = `Open`
                type = `Transparent`
            )->button(
                text = `Save`
                type = `Transparent`
            )->button(
                text = `Save as`
                type = `Transparent`
            )->button(
                text = `Cut`
                type = `Transparent`
            )->button(
                text = `Copy`
                type = `Transparent`
            )->button(
                text = `Paste`
                type = `Transparent`
            )->button(
                text = `Undo`
                type = `Transparent` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
