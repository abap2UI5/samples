"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.ImageModeBackground
"! Visualizes the state of the control when the mode property is set to ImageMode.Background.
CLASS z2ui5_cl_demo_app_434 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_434 IMPLEMENTATION.

  METHOD view_display.

    DATA(pic1) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.
    DATA(pic3) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Image with ImageMode.Background`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.ImageModeBackground` ).

    DATA(grid) = page->vertical_layout( class = `sapUiContentPadding`
                                        width = `100%`
                     )->content( `layout`
                     )->grid( `XL3 L3 M6 S12`
                     )->content( `layout` ).

    " image size is device dependent in the original (5em on a phone) - fixed to 10em here
    DATA(box1) = grid->vbox( alignitems = `Center` ).
    box1->image( src    = pic1
                 mode   = `Background`
                 height = `10em`
                 width  = `10em`
        )->get( )->layout_data( )->flex_item_data( growfactor = `1` ).
    box1->text( text  = `Background covers the entire container`
                class = `sapUiSmallMarginTop` ).

    DATA(box2) = grid->vbox( alignitems = `Center` ).
    box2->image( src                = pic1
                 mode               = `Background`
                 height             = `10em`
                 backgroundsize     = `5em 5em`
                 backgroundposition = `center`
                 width              = `10em`
        )->get( )->layout_data( )->flex_item_data( growfactor = `1` ).
    box2->text( text  = `Center placed background`
                class = `sapUiSmallMarginTop` ).

    DATA(box3) = grid->vbox( alignitems = `Center` ).
    box3->image( src              = pic1
                 mode             = `Background`
                 height           = `10em`
                 backgroundsize   = `2em 2em`
                 backgroundrepeat = `repeat`
                 width            = `10em`
        )->get( )->layout_data( )->flex_item_data( growfactor = `1` ).
    box3->text( text  = `Repeating background`
                class = `sapUiSmallMarginTop` ).

    " custom CSS class imageContainer (light blue background color) of the original omitted
    DATA(box4) = grid->vbox( alignitems = `Center` ).
    box4->hbox(
        )->image( src                = pic3
                  mode               = `Background`
                  height             = `10em`
                  backgroundsize     = `contain`
                  backgroundposition = `center center`
                  width              = `6em` ).
    box4->text( text  = `The background adjusts its lower dimension in order to fit in the container`
                class = `sapUiSmallMarginTop` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
