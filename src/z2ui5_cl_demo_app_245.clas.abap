class z2ui5_cl_demo_app_245 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_245 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Direction & Order`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'POPOVER' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxDirectionOrder' ).

    DATA(layout) = page->vbox(
                          )->panel( headertext = `Reverse, horizontal`
                              )->flex_box( direction = `RowReverse` alignItems = `Start`
                                  )->button( text = `1` type = `Emphasized`
                                  )->button( text = `2` type = `Reject`
                                  )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(

                          )->panel( headertext = `Top to bottom, vertical`
                              )->flex_box( direction = `Column` alignItems = `Start`
                                  )->button( text = `1` type = `Emphasized`
                                  )->button( text = `2` type = `Reject`
                                  )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(

                          )->panel( headertext = `Bottom to top, reverse vertical`
                              )->flex_box( direction = `ColumnReverse` alignItems = `Start`
                                  )->button( text = `1` type = `Emphasized`
                                  )->button( text = `2` type = `Reject`
                                  )->button( text = `3` type = `Accept` )->get_parent( )->get_parent(

                          )->panel( headertext = `Arbitrary flex item order`
                              )->flex_box( alignItems = `Start`
                                  )->button( text = `1` type = `Emphasized` class = `sapUiTinyMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( order = `2` )->get_parent( )->get_parent(
                                  )->button( text = `2` type = `Reject` class = `sapUiTinyMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( order = `3` )->get_parent( )->get_parent(
                                  )->button( text = `3` type = `Accept` class = `sapUiTinyMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( order = `1`
                         ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `You can influence the direction and order of elements in horizontal and vertical Flex Box controls with the direction property.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
