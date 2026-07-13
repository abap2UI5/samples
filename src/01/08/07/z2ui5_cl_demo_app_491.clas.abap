"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsAll
"! Use standard margin classes 'sapUiTinyMargin', 'sapUiSmallMargin', 'sapUiMediumMargin' or
"! 'sapUiLargeMargin' to add a 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px (3rem) margin to your
"! control. This will clear the area all around your control (outside its border).
CLASS z2ui5_cl_demo_app_491 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_491 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Margins All Around`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsAll` ).

    page->text(
        text  = `Panels below illustrate the four standard margin sizes 'tiny', 'small', 'medium' and 'large'.`
        class = `sapUiExploredNoMarginInfo` ).

    page->panel(
        width = `auto`
        class = `sapUiTinyMargin`
        )->content(
            )->text(
                text  = `This panel uses margin class 'sapUiTinyMargin' to clear a 8px (0.5rem) space all around.`
                class = `sapMH4FontSize`
            )->text( `Since panels have a default width of 100%, horizontal margins are not displayed appropriately. Therefore we need to set the panel's 'width' property to 'auto'.` ).

    page->panel(
        width = `auto`
        class = `sapUiSmallMargin`
        )->content(
            )->text(
                text  = `This panel uses margin class 'sapUiSmallMargin' to clear a 16px (1rem) space all around.`
                class = `sapMH4FontSize` ).

    page->panel(
        width = `auto`
        class = `sapUiMediumMargin`
        )->content(
            )->text(
                text  = `This panel uses margin class 'sapUiMediumMargin' to clear a 32px (2rem) space all around.`
                class = `sapMH4FontSize` ).

    page->panel(
        width = `auto`
        class = `sapUiLargeMargin`
        )->content(
            )->text(
                text  = `This panel uses margin class 'sapUiLargeMargin' to clear a 48px (3rem) space all around.`
                class = `sapMH4FontSize` ).

    page->text(
        text  = `Each of the panels above has a margin all around. Please notice that this margins do not add up. Instead, they 'collapse'.`
        class = `sapUiExploredNoMarginInfo` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
