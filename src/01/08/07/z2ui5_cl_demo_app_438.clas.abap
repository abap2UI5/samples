"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputSuggestionsCustomFilter
"! The default filtering for the suggestionItems aggregation uses a 'begins with' style operator. You
"! can override this with your own custom filter function using the Input control's setFilterFunction
"! method.
CLASS z2ui5_cl_demo_app_438 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_438 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Suggestions - Custom`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputSuggestionsCustomFilter` ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    " the custom filter function (setFilterFunction, native JavaScript) of the original cannot be
    " ported - the default 'begins with' suggestion filtering applies
    layout->label( text     = `Product`
                   labelfor = `productInput` ).
    layout->input( id              = `productInput`
                   placeholder     = `Enter product`
                   showsuggestion  = abap_true
                   suggestionitems = client->_bind( t_products )
        )->get( )->suggestion_items(
            )->item( text = `{NAME}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
          ( name = `Notebook Basic 15` )
          ( name = `Notebook Basic 17` )
          ( name = `Notebook Basic 18` )
          ( name = `Notebook Basic 19` )
          ( name = `ITelO Vault` )
          ( name = `Notebook Professional 15` )
          ( name = `Notebook Professional 17` )
          ( name = `ITelO Vault Net` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
