"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.MultiHeader
"! Example for multi-header of table
CLASS z2ui5_cl_demo_app_525 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_contact,
        supplier    TYPE string,
        street      TYPE string,
        city        TYPE string,
        phone       TYPE string,
        open_orders TYPE i,
      END OF ty_s_contact.
    DATA t_data TYPE STANDARD TABLE OF ty_s_contact WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_525 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_data = VALUE #(
      ( supplier    = `Titanium`
        street      = `401 23rd St`
        city        = `Port Angeles`
        phone       = `5682-121-828`
        open_orders = 10 )
      ( supplier    = `Technocom`
        street      = `51 39th St`
        city        = `Smallfield`
        phone       = `2212-853-789`
        open_orders = 0 )
      ( supplier    = `Red Point Stores`
        street      = `451 55th St`
        city        = `Meridian`
        phone       = `2234-245-898`
        open_orders = 5 )
      ( supplier    = `Technocom`
        street      = `40 21st St`
        city        = `Bethesda`
        phone       = `5512-125-643`
        open_orders = 0 )
      ( supplier    = `Very Best Screens`
        street      = `123 72nd St`
        city        = `McLean`
        phone       = `5412-543-765`
        open_orders = 6 ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: Multi Header`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.table.Table/sample/sap.ui.table.sample.MultiHeader` ).

    DATA(tab) = page->ui_table(
        id            = `table1`
        rows          = client->_bind_edit( t_data )
        selectionmode = `MultiToggle`
        )->_generic_property( VALUE #( n = `enableColumnFreeze` v = `true` ) ).

    tab->ui_extension(
        )->overflow_toolbar( style = `Clear`
        )->title(
            id   = `title`
            text = `Contacts` ).

    DATA(columns) = tab->ui_columns( ).

    columns->ui_column(
        width          = `11rem`
        sortproperty   = `SUPPLIER`
        filterproperty = `SUPPLIER`
        )->label(
            text      = `Supplier`
            textalign = `Center`
            width     = `100%`
        )->ui_template(
        )->text( `{SUPPLIER}` ).

    columns->ui_column(
        width          = `11rem`
        sortproperty   = `STREET`
        filterproperty = `STREET`
        )->_generic_property( VALUE #( n = `headerSpan` v = `3,2` )
        )->_generic( name = `multiLabels`
                     ns   = `table`
        )->label(
            text      = `Contact`
            textalign = `Center`
            width     = `100%`
        )->label(
            text      = `Address`
            textalign = `Center`
            width     = `100%`
        )->label(
            text      = `Street`
            textalign = `Center`
            width     = `100%` )->get_parent(
        )->ui_template(
        )->text(
            text     = `{STREET}`
            wrapping = abap_false ).

    columns->ui_column(
        width        = `11rem`
        sortproperty = `CITY`
        )->_generic_property( VALUE #( n = `headerSpan` v = `2` )
        )->_generic( name = `multiLabels`
                     ns   = `table`
        )->label( `Contact`
        )->label( `Address`
        )->label(
            text      = `City`
            textalign = `Center`
            width     = `100%` )->get_parent(
        )->ui_template(
        )->input( `{CITY}` ).

    columns->ui_column(
        width        = `11rem`
        sortproperty = `PHONE`
        )->_generic( name = `multiLabels`
                     ns   = `table`
        )->label( `Contact`
        )->label(
            text      = `Phone`
            textalign = `Center`
            width     = `100%` )->get_parent(
        )->ui_template(
        )->input( `{PHONE}` ).

    columns->ui_column(
        width  = `8rem`
        halign = `End`
        )->_generic( name = `multiLabels`
                     ns   = `table`
        )->label( visible = abap_false
        )->label( visible = abap_false
        )->label( `Open Orders` )->get_parent(
        )->ui_template(
        )->text( `{OPEN_ORDERS}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
