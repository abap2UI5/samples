"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsTwoSided
"! Clear the space to the left and right, top and bottom of your control. Choose a size ('Tiny',
"! 'Small', 'Medium' or 'Large', which stands for 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px
"! (3rem) respectively) and an orientation ('BeginEnd', 'TopBottom'). If you would like to clear a
"! 32px space to the left and right, you would add class 'sapUiMediumMarginBeginEnd'.
CLASS z2ui5_cl_demo_app_496 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_496 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Two-Sided Margins`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsTwoSided` ).

    page->text(
        text  = `This sample demonstrates convenience classes which let you set a margin at two opposite sides (top/bottom and begin/end).`
        class = `sapUiExploredNoMarginInfo` ).

    page->panel( class = `sapUiMediumMarginTopBottom`
        )->content(
            )->text(
                text  = `This panel uses margin class 'sapUiMediumMarginTopBottom' to clear a 32px (2rem) space at the panel's top and bottom.`
                class = `sapMH4FontSize`
            )->text( `Since we do not apply horizontal margins in this case, we do not need to reset the panel's default width in this case. Therefore it is NOT necessary to set the modify the panel's 'width' property.` ).

    page->panel(
        width = `auto`
        class = `sapUiMediumMarginBeginEnd`
        )->content(
            )->text(
                text  = `This panel uses margin class 'sapUiMediumMarginBeginEnd' to clear a 32px space at the panel's left and right side.`
                class = `sapMH4FontSize`
            )->text( `Since we do apply horizontal margins in this case, we have to set the panel's width to 'auto'.` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
