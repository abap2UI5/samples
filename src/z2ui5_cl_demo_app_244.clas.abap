class z2ui5_cl_demo_app_244 definition
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



CLASS z2ui5_cl_demo_app_244 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Size Adjustments`
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
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxSizeAdjustments' ).

    DATA(layout) = page->vbox(
                          )->panel( headertext = `Equal flexibility and content` class = `sapUiDemoFlexBoxSizeAdjustments`
                              )->flex_box( alignitems = `Start`
                                  )->button( text = `1` width = `100%` type = `Emphasized` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `2` width = `100%` type = `Reject` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                         )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `3` width = `100%` type = `Accept` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent( )->get_parent( )->get_parent(

                          )->panel( headertext = `Different flexibility, equal content` class = `sapUiDemoFlexBoxSizeAdjustments`
                              )->flex_box( alignitems = `Start`
                                  )->button( text = `1` width = `100%` type = `Emphasized` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `2` width = `100%` type = `Reject` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                         )->flex_item_data( growfactor = `2` )->get_parent( )->get_parent(
                                  )->button( text = `3` width = `100%` type = `Accept` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `3` )->get_parent( )->get_parent( )->get_parent( )->get_parent(

                          )->panel( headertext = `Equal flexibility, different content` class = `sapUiDemoFlexBoxSizeAdjustments`
                              )->flex_box( alignitems = `Start`
                                  )->button( text = `1` width = `50px` type = `Emphasized` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `2` width = `100px` type = `Reject` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                         )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `3` width = `150px` type = `Accept` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`)->get_parent( )->get_parent( )->get_parent( )->get_parent(

                          )->panel( headertext = `Equal flexibility, different content, width 0` class = `sapUiDemoFlexBoxSizeAdjustments`
                              )->flex_box( alignitems = `Start` class = `sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems`
                                  )->button( text = `1` width = `100%` type = `Emphasized` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `2` width = `100%` type = `Reject` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                         )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `3` width = `100%` type = `Accept` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`)->get_parent( )->get_parent( )->get_parent( )->get_parent(

                          )->panel( headertext = `Different flexibility and content, width 0` class = `sapUiDemoFlexBoxSizeAdjustments`
                              )->flex_box( alignitems = `Start` class = `sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems`
                                  )->button( text = `1` width = `50px` type = `Emphasized` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `2` width = `100px` type = `Reject` class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                         )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                  )->button( text = `3` width = `150px` type = `Accept` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`)->get_parent(

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
                                  description = `Automatic size adjustments can be achieved for Flex Items with the use of Flex Item Data settings on the contained controls.`
          ).

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
