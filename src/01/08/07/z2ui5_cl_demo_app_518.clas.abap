"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridXL
"! The major layout features of the Grid control are shown in this example. Features like indentation,
"! making content visible/invisible based on the screen size, moving content forward and backwards are
"! demonstrated.
CLASS z2ui5_cl_demo_app_518 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA intro_text1 TYPE string.
    DATA intro_text2 TYPE string.
    DATA intro_text3 TYPE string.
    DATA description1 TYPE string.
    DATA description2 TYPE string.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_518 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Grid - Features Demo`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridXL` ).

    DATA(grid1) = page->grid(
        hspacing     = `0`
        default_span = `XL6 L6 M6 S12`
        class        = `sapUiSmallMargin` ).

    grid1->vertical_layout( class = `sapUiTinyMarginEnd`
        )->title(
            level      = `H1`
            titlestyle = `H1`
            text       = `Demo App`
            class      = `sapUiMediumMarginBottom`
        )->text(
            text  = client->_bind( intro_text1 )
            class = `sapUiTinyMarginBottom`
        )->text(
            text  = client->_bind( intro_text2 )
            class = `sapUiTinyMarginBottom`
        )->text(
            text  = client->_bind( intro_text3 )
            class = `sapUiTinyMarginBottom` ).

    " the wrapper grid_data method does not support the visible/linebreak/move properties - generic element used
    grid1->image(
        src          = `https://sapui5.hana.ondemand.com/resources/sap/ui/documentation/sdk/images/demoAppsTeaser.png`
        densityaware = abap_false
        width        = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `visibleS` v = `false` ) ) ).

    DATA(grid2) = page->grid(
        hspacing     = `0`
        vspacing     = `0`
        class        = `sapUiSmallMargin`
        default_span = `XL5 L5 M5 S12` ).
    " the wrapper grid method does not support the defaultIndent property - generic property used
    grid2->_generic_property( VALUE #( n = `defaultIndent` v = `XL1 L1 M1` ) ).

    grid2->title(
        level      = `H2`
        titlestyle = `H2`
        text       = `Products` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `span` v = `XL12 L12 M12 S12` )
                                  ( n = `indent` v = `XL0 L0 M0` ) ) ).

    grid2->image(
        src          = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
        densityaware = abap_false
        width        = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `moveForward` v = `M6` ) ) ).

    grid2->image(
        src          = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
        densityaware = abap_false
        width        = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `moveBackwards` v = `M6` ) ) ).

    DATA(grid3) = page->grid(
        hspacing     = `0`
        default_span = `XL3 L5 M5 S12`
        class        = `sapUiSmallMargin` ).

    grid3->image(
        src          = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`
        densityaware = abap_false
        width        = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `indent` v = `XL1 L1 M1` ) ) ).

    grid3->vertical_layout( class = `sapUiTinyMargin`
        )->text(
            text  = client->_bind( description1 )
            class = `sapUiTinyMarginBottom`
        )->text( client->_bind( description2 ) ).

    grid3->image(
        src          = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`
        densityaware = abap_false
        width        = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `linebreakXL` v = `false` )
                                  ( n = `linebreakL` v = `true` )
                                  ( n = `visibleM` v = `false` )
                                  ( n = `visibleS` v = `true` )
                                  ( n = `indent` v = `L1` ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      intro_text1 = `This Grid Layout sample application demonstrates the major features and capabilites of the Grid Layout. ` &&
        `There are 3 Grid Layouts used in this application.`.
      intro_text2 = `In the first Grid Layout, when the screen size is reduced to 'Small' or 'Mobile', the image on the right is ` &&
        `made invisible by using the property 'visibleOnSmall=false' of the GridData control.`.
      intro_text3 = `In the second Grid Layout, that is in the Products section, when the screen size is reduced to 'Medium' or 'Tablet', ` &&
        `the images are swapped by using properties 'moveForward' and 'moveBackwards' of the GridData control. There is also indentation ` &&
        `applied the images when the screen sizes are 'Extra-large, Large and Medium'.`.
      description1 = `In this Grid Layout, when the screen size is 'Extra-large' or 'Large Desktop' then there are 2 Images and 1 Text control ` &&
        `rendered in 1 row. But when the screen is reduced to 'Large' or 'Smaller Desktop', there is a line break for the image on the right ` &&
        `and it is rendered in a new row. This is achieved by using the properties 'linebreakXL=false' and 'linebreakL=true' of the GridData control.`.
      description2 = `When the screen is further reduced to 'Medium' or 'Tablet', the image rendered in the new row is made invisible by using ` &&
        `the property 'visibleOnMedium=false' of the GridData control and this image is visible again when the screen size if further reduced ` &&
        `to 'Small' or 'Mobile'.`.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
