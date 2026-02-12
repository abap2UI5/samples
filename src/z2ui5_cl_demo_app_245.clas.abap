CLASS z2ui5_cl_demo_app_245 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

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

CLASS z2ui5_cl_demo_app_245 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Direction & Order`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `hint_icon`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `POPOVER` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxDirectionOrder` ).

    DATA(lo_layout) = lo_page->vbox(
                          )->panel( headertext = `Reverse, horizontal`
                              )->flex_box( direction  = `RowReverse`
                                           alignitems = `Start`
                                  )->button( text = `1`
                                             type = `Emphasized`
                                  )->button( text = `2`
                                             type = `Reject`
                                  )->button( text = `3`
                                             type = `Accept` )->get_parent( )->get_parent(
      )->panel( headertext = `Top to bottom, vertical`
                              )->flex_box( direction  = `Column`
                                           alignitems = `Start`
                                  )->button( text = `1`
                                             type = `Emphasized`
                                  )->button( text = `2`
                                             type = `Reject`
                                  )->button( text = `3`
                                             type = `Accept` )->get_parent( )->get_parent(
      )->panel( headertext = `Bottom to top, reverse vertical`
                              )->flex_box( direction  = `ColumnReverse`
                                           alignitems = `Start`
                                  )->button( text = `1`
                                             type = `Emphasized`
                                  )->button( text = `2`
                                             type = `Reject`
                                  )->button( text = `3`
                                             type = `Accept` )->get_parent( )->get_parent(
      )->panel( headertext = `Arbitrary flex item order`
                              )->flex_box( alignitems = `Start`
                                  )->button( text  = `1`
                                             type  = `Emphasized`
                                             class = `sapUiTinyMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( order = `2` )->get_parent( )->get_parent(
                                  )->button( text  = `2`
                                             type  = `Reject`
                                             class = `sapUiTinyMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( order = `3` )->get_parent( )->get_parent(
                                  )->button( text  = `3`
                                             type  = `Accept`
                                             class = `sapUiTinyMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( order = `1` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `POPOVER` ).
      display_popover( `hint_icon` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `You can influence the direction and order of elements in horizontal and vertical Flex Box controls with the direction property.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
