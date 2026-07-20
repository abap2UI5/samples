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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE z2ui5_cl_demo_app_103=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-product_id = `HT-1000`.
    temp2-quantity = `10`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-product_id = `HT-1001`.
    temp2-quantity = `20`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-product_id = `HT-1002`.
    temp2-quantity = `10`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-product_id = `HT-1003`.
    temp2-quantity = `15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-product_id = `HT-1007`.
    temp2-quantity = `15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-product_id = `HT-1010`.
    temp2-quantity = `16`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-product_id = `HT-1011`.
    temp2-quantity = `17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-product_id = `HT-1020`.
    temp2-quantity = `14`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-product_id = `HT-1021`.
    temp2-quantity = `50`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-product_id = `HT-1022`.
    temp2-quantity = `30`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-product_id = `HT-1023`.
    temp2-quantity = `24`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-product_id = `HT-1030`.
    temp2-quantity = `14`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-product_id = `HT-1031`.
    temp2-quantity = `24`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-product_id = `HT-1032`.
    temp2-quantity = `50`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-product_id = `HT-1035`.
    temp2-quantity = `23`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-product_id = `HT-1036`.
    temp2-quantity = `22`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.
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

    DATA old_sizes TYPE string.
    DATA new_sizes TYPE string.
    DATA message LIKE val.
    old_sizes = client->get_event_arg( ).
    
    new_sizes = client->get_event_arg( 2 ).
    
    message = val.

    IF old_sizes IS NOT INITIAL.
      message = |{ message }{ z2ui5_cl_sample_context=>cv_char_util_newline }Old panes sizes = [{ old_sizes }]|.
    ENDIF.

    message = |{ message }{ z2ui5_cl_sample_context=>cv_char_util_newline }New panes sizes = [{ new_sizes }]|.
    client->message_toast_display( message ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    DATA root_container TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE string_table.
    DATA inner_container TYPE REF TO z2ui5_cl_xml_view.
    DATA pane_page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
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
    
    CLEAR temp3.
    INSERT `${$parameters>/oldSizes}` INTO TABLE temp3.
    INSERT `${$parameters>/newSizes}` INTO TABLE temp3.
    
    root_container = page->responsive_splitter( defaultpane = `default`
        )->pane_container( resize = client->_event( val   = `ROOT_RESIZE`
                                                    t_arg = temp3 ) ).

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

    
    CLEAR temp5.
    INSERT `${$parameters>/oldSizes}` INTO TABLE temp5.
    INSERT `${$parameters>/newSizes}` INTO TABLE temp5.
    
    inner_container = root_container->pane_container(
        orientation = `Vertical`
        resize      = client->_event( val   = `INNER_RESIZE`
                                      t_arg = temp5 ) ).

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

    
    pane_page = inner_container->split_pane( requiredparentwidth = `800`
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
