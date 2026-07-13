"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsSingleSided
"! Clear the space to the left, right, top or bottom of your control. Choose a size ('Tiny', 'Small',
"! 'Medium' or 'Large', which stands for 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px (3rem)
"! respectively) and a direction ('Begin', 'End', 'Top' or 'Bottom', where 'Begin' is left and 'End'
"! is right and vice versa in right-to-left mode). If you would like to clear a 32px space to the
"! left (resp. right in rtl mode), you would add class 'sapUiMediumMarginBegin'. You may also add
"! several classes which have to point to different directions though, for example you would add
"! classes 'sapUiLargeMarginEnd sapUiLargeMarginBottom' to clear a 48px space to the bottom and to
"! the right (resp. to the left in rtl mode).
CLASS z2ui5_cl_demo_app_495 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_495 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Single-Sided Margins`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsSingleSided` ).

    page->panel(
        width = `auto`
        class = `sapUiLargeMarginBegin sapUiLargeMarginBottom`
        )->content(
            )->text(
                text  = `This panel uses margin classes 'sapUiLargeMarginBegin' and 'sapUiLargeMarginBottom' to clear a 48px (3rem) space to the left and bottom.`
                class = `sapMH4FontSize`
            )->text( `Since panels have a default width of 100%, horizontal margins are not displayed appropriately. Therefore we need to set the panel's 'width' property to 'auto'.` ).

    page->text(
        text  = `To see what happens in Right-To-Left mode open 'Settings' by pressing the cog wheel button next to 'Entities'.`
        class = `sapUiExploredNoMarginInfo` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
