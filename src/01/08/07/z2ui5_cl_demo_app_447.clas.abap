"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBoxInitialFocus
"! Shows how to set initial focus to MessageBox button.
CLASS z2ui5_cl_demo_app_447 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_447 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Message Box Initial Focus`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBoxInitialFocus` ).

    " The ariaHasPopup property of the buttons in the original sample is omitted here (available only since UI5 1.84)
    page->vertical_layout( class = `sapUiContentPadding`
                           width = `100%`
        )->text( `Different approaches to set Initial focus`
        )->button(
            text  = `Action`
            class = `sapUiSmallMarginBottom`
            press = client->_event( `INITIAL_FOCUS_ON_ACTION` )
            width = `250px`
        )->button(
            text  = `Custom action`
            class = `sapUiSmallMarginBottom`
            press = client->_event( `INITIAL_FOCUS_ON_CUSTOM_ACTION` )
            width = `250px` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " The emphasizedAction and dependentOn options of the original sample are omitted here (available only since UI5 1.75 / 1.124)
    IF client->check_on_event( `INITIAL_FOCUS_ON_ACTION` ).

      client->message_box_display(
        text         = |Initial button focus is set by attribute \n initialFocus: sap.m.MessageBox.Action.CANCEL|
        type         = `warning`
        icon         = `WARNING`
        title        = `Focus on a Button`
        actions      = VALUE #( ( `OK` ) ( `CANCEL` ) )
        initialfocus = `CANCEL`
        styleclass   = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

    ELSEIF client->check_on_event( `INITIAL_FOCUS_ON_CUSTOM_ACTION` ).

      client->message_box_display(
        text         = |Initial button focus is set by attribute \n initialFocus: "Custom button" \n Note: The name is not case sensitive|
        type         = `show`
        icon         = `WARNING`
        title        = `Focus on a Custom Action`
        actions      = VALUE #( ( `YES` ) ( `NO` ) ( `Custom Action` ) )
        initialfocus = `Custom Action`
        styleclass   = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer` ).

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
