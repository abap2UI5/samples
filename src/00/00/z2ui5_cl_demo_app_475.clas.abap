CLASS z2ui5_cl_demo_app_475 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE string,
      END OF ty_s_row.
    DATA t_table TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA product TYPE string.
    DATA create_date TYPE string.
    DATA create_by TYPE string.
    DATA storage_location TYPE string.
    DATA quantity TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_search.
    METHODS view_display.
    METHODS data_read.
    METHODS filter_groups
      RETURNING
        VALUE(result) TYPE string.
    METHODS filter_group
      IMPORTING
        name          TYPE string
        value         TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_475 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `SEARCH` ).
      on_search( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    data_read( ).

    view_display( ).

  ENDMETHOD.


  METHOD on_search.

    " the filter values travelled with the event through the two-way binding of
    " the filter fields, so the search only has to hand the table's items
    " binding a filter - the rows themselves never move again (the client-side
    " equivalent of oTable.getBinding( 'items' ).filter( ... ))
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-binding_call
                              t_arg = VALUE #( ( `table1` )
                                               ( `items` )
                                               ( `filter` )
                                               ( filter_groups( ) ) ) ).

  ENDMETHOD.


  METHOD data_read.

    t_table = VALUE #(
        ( product          = `table`
          create_date      = `01.01.2023`
          create_by        = `Peter`
          storage_location = `AREA_001`
          quantity         = `400` )
        ( product          = `chair`
          create_date      = `01.01.2022`
          create_by        = `James`
          storage_location = `AREA_001`
          quantity         = `123` )
        ( product          = `sofa`
          create_date      = `01.05.2021`
          create_by        = `Simone`
          storage_location = `AREA_002`
          quantity         = `700` )
        ( product          = `computer`
          create_date      = `27.01.2023`
          create_by        = `Theo`
          storage_location = `AREA_002`
          quantity         = `200` )
        ( product          = `printer`
          create_date      = `01.01.2023`
          create_by        = `Hannah`
          storage_location = `AREA_003`
          quantity         = `90` )
        ( product          = `table2`
          create_date      = `01.01.2023`
          create_by        = `Julia`
          storage_location = `AREA_003`
          quantity         = `110` ) ).

  ENDMETHOD.


  METHOD filter_groups.

    " the compound payload of cs_event-binding_call: an array of groups, each
    " group an array of [ path, operator, value ] rows - OR inside a group, AND
    " across the groups. One group per filled field therefore ANDs the fields,
    " and an empty array clears the filter again
    DATA(t_groups) = VALUE string_table(
        ( filter_group( name  = `PRODUCT`
                        value = product ) )
        ( filter_group( name  = `CREATE_DATE`
                        value = create_date ) )
        ( filter_group( name  = `CREATE_BY`
                        value = create_by ) )
        ( filter_group( name  = `STORAGE_LOCATION`
                        value = storage_location ) )
        ( filter_group( name  = `QUANTITY`
                        value = quantity ) ) ).

    DELETE t_groups WHERE table_line IS INITIAL.

    result = |[{ concat_lines_of( table = t_groups
                                  sep   = `,` ) }]|.

  ENDMETHOD.


  METHOD filter_group.

    IF value IS INITIAL.
      RETURN.
    ENDIF.

    DATA(value_json) = value.
    REPLACE ALL OCCURRENCES OF `\` IN value_json WITH `\\`.
    REPLACE ALL OCCURRENCES OF `"` IN value_json WITH `\"`.

    result = |[["{ name }","Contains","{ value_json }"]]|.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Filter Bar with Variant Management`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `A list report built entirely in ABAP: the sap.ui.comp FilterBar is wired to the ` &&
                   `SmartVariantManagement by cs_event-filter_bar_variant_init, so saving, selecting ` &&
                   `and restoring a variant works without the controller boilerplate such an app ` &&
                   `usually needs. Go filters the table's items binding via cs_event-binding_call - ` &&
                   `client-side, the rows never travel again. No JavaScript in the view.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(dynamic_page) = page->dynamic_page( headerexpanded = abap_true
                                             headerpinned   = abap_true ).

    dynamic_page->title( ns = `f` )->get( )->dynamic_page_title(
        )->heading( `f`
            )->smart_variant_management( id                     = `svm`
                                         showexecuteonselection = abap_true ).

    dynamic_page->header( )->dynamic_page_header( abap_true
        )->filter_bar( id             = `fbar`
                       persistencykey = `myPersKey`
                       usetoolbar     = abap_false
                       search         = client->_event( `SEARCH` )
            )->filter_group_items(
                )->filter_group_item( name               = `PRODUCT`
                                      label              = `Product`
                                      groupname          = `group1`
                                      visibleinfilterbar = abap_true
                    )->fb_control(
                        )->input( value           = client->_bind( product )
                                  suggest         = abap_true
                                  suggestionitems = client->_bind( t_table )
                            )->get( )->suggestion_items( )->item( text = `{PRODUCT}`
                            )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                )->filter_group_item( name               = `CREATE_DATE`
                                      label              = `Create Date`
                                      groupname          = `group1`
                                      visibleinfilterbar = abap_true
                    )->fb_control(
                        )->input( client->_bind( create_date ) )->get_parent( )->get_parent(
                )->filter_group_item( name               = `CREATE_BY`
                                      label              = `Create By`
                                      groupname          = `group1`
                                      visibleinfilterbar = abap_true
                    )->fb_control(
                        )->input( client->_bind( create_by ) )->get_parent( )->get_parent(
                )->filter_group_item( name               = `STORAGE_LOCATION`
                                      label              = `Storage Location`
                                      groupname          = `group1`
                                      visibleinfilterbar = abap_true
                    )->fb_control(
                        )->input( client->_bind( storage_location ) )->get_parent( )->get_parent(
                )->filter_group_item( name               = `QUANTITY`
                                      label              = `Quantity`
                                      groupname          = `group1`
                                      visibleinfilterbar = abap_true
                    )->fb_control(
                        )->input( client->_bind( quantity ) ).

    DATA(table) = dynamic_page->content( `f`
        )->table( id    = `table1`
                  items = client->_bind( t_table ) ).

    DATA(columns) = table->columns( ).
    columns->column( )->text( `Product` ).
    columns->column( )->text( `Date` ).
    columns->column( )->text( `Name` ).
    columns->column( )->text( `Location` ).
    columns->column( )->text( `Quantity` ).

    DATA(cells) = table->items( )->column_list_item( ).
    cells->text( `{PRODUCT}` ).
    cells->text( `{CREATE_DATE}` ).
    cells->text( `{CREATE_BY}` ).
    cells->text( `{STORAGE_LOCATION}` ).
    cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

    " the handshake between FilterBar and SmartVariantManagement that a list
    " report normally hand-writes in its controller (registerFetchData,
    " registerApplyData, registerGetFiltersWithValues, addPersonalizableControl
    " and a change handler per field). Re-sent after every view_display, since
    " a rebuilt view brings new control instances
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-filter_bar_variant_init
                              t_arg = VALUE #( ( `svm` )
                                               ( `fbar` ) ) ).

  ENDMETHOD.

ENDCLASS.
