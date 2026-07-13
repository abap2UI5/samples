"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemTitle
"! By default the title size adapts to the available space and gets bigger if the description is
"! empty. List items with and without descriptions results in titles with different sizes. In this
"! cases it is better to switch the size adaption off.
CLASS z2ui5_cl_demo_app_480 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_480 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Standard List Item - Adapt Title`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemTitle` ).

    DATA(list) = page->list( headertext = `Products` ).

    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 15` )
                          ( n = `description`      v = `HT-1000` )
                          ( n = `icon`             v = base_url && `HT-1000.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    " set this item's description be empty
    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 17` )
                          ( n = `description`      v = `` )
                          ( n = `icon`             v = base_url && `HT-1001.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 18` )
                          ( n = `description`      v = `HT-1002` )
                          ( n = `icon`             v = base_url && `HT-1002.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    " don't specify a description for this item
    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 19` )
                          ( n = `icon`             v = base_url && `HT-1003.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
