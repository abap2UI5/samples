"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxSizeAdjustments
"! Automatic size adjustments can be achieved for Flex Items with the use of Flex Item Data settings
"! on the contained controls.
CLASS z2ui5_cl_demo_app_405 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_405 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " style.css of the original sample injected via html:style
    DATA(css) = `.sapUiDemoFlexBoxSizeAdjustments .sapMFlexItem {`               &&
                `  border: 1px dashed #000;`                                     &&
                `  margin: 0.1875rem;`                                           &&
                `  padding: 0.1875rem;`                                          &&
                `}`                                                              &&
                `.sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems .sapMFlexItem {` &&
                `  width: 0;`                                                    &&
                `}`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Flex Box - Size Adjustments`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxSizeAdjustments` ).

    DATA(vbox) = page->vbox( ).

    vbox->panel( headertext = `Equal flexibility and content`
                 class      = `sapUiDemoFlexBoxSizeAdjustments`
        )->flex_box( alignitems = `Start`
            )->button( text  = `1`
                       width = `100%`
                       type  = `Emphasized`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `2`
                       width = `100%`
                       type  = `Reject`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `3`
                       width = `100%`
                       type  = `Accept` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` ).

    vbox->panel( headertext = `Different flexibility, equal content`
                 class      = `sapUiDemoFlexBoxSizeAdjustments`
        )->flex_box( alignitems = `Start`
            )->button( text  = `1`
                       width = `100%`
                       type  = `Emphasized`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `2`
                       width = `100%`
                       type  = `Reject`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `2` )->get_parent( )->get_parent(
            )->button( text  = `3`
                       width = `100%`
                       type  = `Accept` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `3` ).

    vbox->panel( headertext = `Equal flexibility, different content`
                 class      = `sapUiDemoFlexBoxSizeAdjustments`
        )->flex_box( alignitems = `Start`
            )->button( text  = `1`
                       width = `50px`
                       type  = `Emphasized`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `2`
                       width = `100px`
                       type  = `Reject`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `3`
                       width = `150px`
                       type  = `Accept` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` ).

    vbox->panel( headertext = `Equal flexibility, different content, width 0`
                 class      = `sapUiDemoFlexBoxSizeAdjustments`
        )->flex_box( alignitems = `Start`
                     class      = `sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems`
            )->button( text  = `1`
                       width = `100%`
                       type  = `Emphasized`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `2`
                       width = `100%`
                       type  = `Reject`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `3`
                       width = `100%`
                       type  = `Accept` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` ).

    vbox->panel( headertext = `Different flexibility and content, width 0`
                 class      = `sapUiDemoFlexBoxSizeAdjustments`
        )->flex_box( alignitems = `Start`
                     class      = `sapUiDemoFlexBoxSizeAdjustmentsZeroWidthItems`
            )->button( text  = `1`
                       width = `50px`
                       type  = `Emphasized`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `2`
                       width = `100px`
                       type  = `Reject`
                       class = `sapUiSmallMarginEnd` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
            )->button( text  = `3`
                       width = `150px`
                       type  = `Accept` )->get(
                )->layout_data(
                    )->flex_item_data( growfactor = `1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
