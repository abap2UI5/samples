CLASS z2ui5_cl_demo_app_301 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        name          TYPE string,
        attribute_1   TYPE string,
        attribute_2   TYPE string,
        status        TYPE string,
        overflow_mode TYPE string,
      END OF ty_product.

    DATA lt_o_data TYPE TABLE OF ty_product.
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_301 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page_01) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Expandable Text`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page_01->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ExpandableText/sample/sap.m.sample.ExpandableText` ).

    lo_page_01->table( mode       = `MultiSelect`
                 items         = mo_client->_bind( lt_o_data )
                 autopopinmode = abap_true
               )->columns(
                   )->column(
                       )->text( text = `Product`
                   )->get_parent(
                   )->column(
                       )->text( text = `Attribute 1`
                   )->get_parent(
                   )->column(
                       )->text( text = `Attribute 2`
                   )->get_parent(
                   )->column(
                       )->text( text = `Status`
                   )->get_parent(
               )->get_parent(
      )->items(
                   )->column_list_item(
                       )->cells(
                           )->text( text = `{NAME}` ")->get_parent(
                           )->expandable_text( class        = `sapUiTinyMarginBottom sapUiTinyMarginTop`
                                               text         = `{ATTRIBUTE_1}`
                                               overflowmode = `{OVERFLOW_MODE}` )->get_parent(
                           )->text( text = `{ATTRIBUTE_2}` )->get_parent(
                           )->text( text = `{STATUS}` )->get_parent(
                       )->get_parent(
                   )->get_parent(
               )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `CLICK_HINT_ICON` ).
      display_popover( `button_hint_id` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The ExpandableText control can be used to display a larger texts inside a table, list or form.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
      set_data( ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.

  METHOD set_data.

    CLEAR lt_o_data.

    lt_o_data = VALUE #(
      ( name          = `Product 1`
        attribute_1   = `The full text is displayed in place. Lorem ipsum dolor sit amet, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                      `At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore `  &&
                      `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr`
        attribute_2   = `Attribute related to label`
        status        = `Some status`
        overflow_mode = `InPlace` )
      ( name          = `Product 2`
        attribute_1   = `The full text is displayed in a popover. Lorem ipsum dolor sit amet, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                      `At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore `      &&
                      `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr`
        attribute_2   = `Attribute related to label`
        status        = `Some status`
        overflow_mode = `Popover` )
      ( name          = `Product 3`
        attribute_1   = `The full text is displayed in place. Lorem ipsum dolor sit amet, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                      `At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore `  &&
                      `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr`
        attribute_2   = `Attribute related to label`
        status        = `Some status`
        overflow_mode = `InPlace` )
      ( name          = `Product 4`
        attribute_1   = `The full text is displayed in a popover. Lorem ipsum dolor sit amet, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                      `At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore `      &&
                      `et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Lorem ipsum dolor sit amet, consetetur sadipscing elitr`
        attribute_2   = `Attribute related to label`
        status        = `Some status`
        overflow_mode = `Popover` ) ).
  ENDMETHOD.
ENDCLASS.
