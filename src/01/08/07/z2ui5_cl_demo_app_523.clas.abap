"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.FormToolbar
"! A form that uses Toolbars as Form header and FormContainer headers.
CLASS z2ui5_cl_demo_app_523 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA supplier_name TYPE string.
    DATA street TYPE string.
    DATA house_number TYPE string.
    DATA zip_code TYPE string.
    DATA city TYPE string.
    DATA country TYPE string.
    DATA url TYPE string.
    DATA twitter TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_523 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " Data of the first entry of the demo model sap/ui/demo/mock/supplier.json
    supplier_name = `Red Point Stores`.
    street        = `Main St`.
    house_number  = `1618`.
    zip_code      = `31415`.
    city          = `Maintown`.
    country       = `Germany`.
    url           = `http://www.sap.com`.
    twitter       = `@sap`.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: Fullscreen - with toolbar`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.Form/sample/sap.ui.layout.sample.FormToolbar` ).

    DATA(form) = page->vbox( `sapUiSmallMargin`
        )->_generic(
            name   = `Form`
            ns     = `form`
            t_prop = VALUE #( ( n = `id`             v = `FormToolbar` )
                              ( n = `editable`       v = `true` )
                              ( n = `ariaLabelledBy` v = `Title1` ) ) ).

    form->form_toolbar(
        )->toolbar( id = `TB1`
        )->title(
            id   = `Title1`
            text = `Address`
        )->toolbar_spacer(
        )->button( icon = `sap-icon://settings`
        )->button( icon = `sap-icon://drop-down-list` ).

    form->_generic( name = `layout`
                    ns   = `form`
        )->_generic(
            name   = `ResponsiveGridLayout`
            ns     = `form`
            t_prop = VALUE #( ( n = `labelSpanXL`             v = `4` )
                              ( n = `labelSpanL`              v = `3` )
                              ( n = `labelSpanM`              v = `4` )
                              ( n = `labelSpanS`              v = `12` )
                              ( n = `adjustLabelSpan`         v = `false` )
                              ( n = `emptySpanXL`             v = `0` )
                              ( n = `emptySpanL`              v = `4` )
                              ( n = `emptySpanM`              v = `0` )
                              ( n = `emptySpanS`              v = `0` )
                              ( n = `columnsXL`               v = `2` )
                              ( n = `columnsL`                v = `1` )
                              ( n = `columnsM`                v = `1` )
                              ( n = `singleContainerFullSize` v = `false` ) ) ).

    DATA(containers) = form->_generic( name = `formContainers`
                                       ns   = `form` ).

    DATA(container_office) = containers->_generic(
        name   = `FormContainer`
        ns     = `form`
        t_prop = VALUE #( ( n = `ariaLabelledBy` v = `Title2` ) ) ).

    container_office->form_toolbar(
        )->toolbar(
        )->title(
            id   = `Title2`
            text = `Office`
        )->toolbar_spacer(
        )->button( icon = `sap-icon://settings` ).

    DATA(elements_office) = container_office->_generic( name = `formElements`
                                                        ns   = `form` ).

    elements_office->_generic( name   = `FormElement`
                               ns     = `form`
                               t_prop = VALUE #( ( n = `label` v = `Name` ) )
        )->_generic( name = `fields`
                     ns   = `form`
        )->input(
            id    = `name`
            value = client->_bind_edit( supplier_name ) ).

    DATA(fields_street) = elements_office->_generic( name   = `FormElement`
                                                     ns     = `form`
                                                     t_prop = VALUE #( ( n = `label` v = `Street` ) )
        )->_generic( name = `fields`
                     ns   = `form` ).
    fields_street->input( client->_bind_edit( street ) ).
    fields_street->input( client->_bind_edit( house_number ) )->get(
        )->layout_data(
        )->grid_data( `XL2 L1 M3 S4` ).

    DATA(fields_zip) = elements_office->_generic( name   = `FormElement`
                                                  ns     = `form`
                                                  t_prop = VALUE #( ( n = `label` v = `ZIP Code/City` ) )
        )->_generic( name = `fields`
                     ns   = `form` ).
    fields_zip->input( client->_bind_edit( zip_code ) )->get(
        )->layout_data(
        )->grid_data( `XL2 L1 M3 S4` ).
    fields_zip->input( client->_bind_edit( city ) ).

    elements_office->_generic( name   = `FormElement`
                               ns     = `form`
                               t_prop = VALUE #( ( n = `label` v = `Country` ) )
        )->_generic( name = `fields`
                     ns   = `form`
        )->select(
            id          = `country`
            width       = `100%`
            selectedkey = client->_bind_edit( country )
        )->items(
        )->item(
            text = `Germany`
            key  = `Germany`
        )->item(
            text = `USA`
            key  = `USA`
        )->item(
            text = `England`
            key  = `England` ).

    DATA(container_online) = containers->_generic(
        name   = `FormContainer`
        ns     = `form`
        t_prop = VALUE #( ( n = `ariaLabelledBy` v = `Title3` ) ) ).

    container_online->form_toolbar(
        )->toolbar(
        )->title(
            id   = `Title3`
            text = `Online`
        )->toolbar_spacer(
        )->button( icon = `sap-icon://settings` ).

    DATA(elements_online) = container_online->_generic( name = `formElements`
                                                        ns   = `form` ).

    elements_online->_generic( name   = `FormElement`
                               ns     = `form`
                               t_prop = VALUE #( ( n = `label` v = `Web` ) )
        )->_generic( name = `fields`
                     ns   = `form`
        )->input(
            id    = `url`
            type  = `Url`
            value = client->_bind_edit( url ) ).

    elements_online->_generic( name   = `FormElement`
                               ns     = `form`
                               t_prop = VALUE #( ( n = `label` v = `Twitter` ) )
        )->_generic( name = `fields`
                     ns   = `form`
        )->input(
            id    = `twitter`
            value = client->_bind_edit( twitter ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
