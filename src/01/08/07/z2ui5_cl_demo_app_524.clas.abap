"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleFormToolbar
"! A SimpleForm that uses Toolbars as Form header and FormContainer headers.
CLASS z2ui5_cl_demo_app_524 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_524 IMPLEMENTATION.

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
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.form.SimpleForm/sample/sap.ui.layout.sample.SimpleFormToolbar` ).

    DATA(form) = page->vbox( `sapUiSmallMargin`
        )->simple_form(
            id                      = `SimpleFormToolbar`
            editable                = abap_true
            layout                  = `ResponsiveGridLayout`
            labelspanxl             = `4`
            labelspanl              = `3`
            labelspanm              = `4`
            labelspans              = `12`
            adjustlabelspan         = abap_false
            emptyspanxl             = `0`
            emptyspanl              = `4`
            emptyspanm              = `0`
            emptyspans              = `0`
            columnsxl               = `2`
            columnsl                = `1`
            columnsm                = `1`
            singlecontainerfullsize = abap_false
        )->_generic_property( VALUE #( n = `ariaLabelledBy` v = `Title1` ) ).

    form->form_toolbar(
        )->toolbar( id = `TB1`
        )->title(
            id   = `Title1`
            text = `Address`
        )->toolbar_spacer(
        )->button( icon = `sap-icon://settings`
        )->button( icon = `sap-icon://drop-down-list` ).

    DATA(content) = form->content( `form` ).

    content->toolbar( )->_generic_property( VALUE #( n = `ariaLabelledBy` v = `Title2` )
        )->title(
            id   = `Title2`
            text = `Office`
        )->toolbar_spacer(
        )->button( icon = `sap-icon://settings` ).

    content->label( `Name`
        )->input( client->_bind_edit( supplier_name )
        )->label( `Street/No.`
        )->input( client->_bind_edit( street ) ).
    content->input( client->_bind_edit( house_number ) )->get(
        )->layout_data(
        )->grid_data( `XL2 L1 M3 S4` ).

    content->label( `ZIP Code/City` ).
    content->input( client->_bind_edit( zip_code ) )->get(
        )->layout_data(
        )->grid_data( `XL2 L1 M3 S4` ).
    content->input( client->_bind_edit( city )
        )->label( `Country`
        )->select(
            id          = `country`
            selectedkey = client->_bind_edit( country )
        )->items(
        )->item(
            text = `England`
            key  = `England`
        )->item(
            text = `Germany`
            key  = `Germany`
        )->item(
            text = `USA`
            key  = `USA` ).

    content->toolbar( )->_generic_property( VALUE #( n = `ariaLabelledBy` v = `Title3` )
        )->title(
            id   = `Title3`
            text = `Online`
        )->toolbar_spacer(
        )->button( icon = `sap-icon://settings` ).

    content->label( `Web`
        )->input(
            value = client->_bind_edit( url )
            type  = `Url`
        )->label( `Twitter`
        )->input( client->_bind_edit( twitter ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
