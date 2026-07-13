"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButton
"! The Segmented Button allows the user to pick one out of many options for displaying the content of
"! the current page. It is a UI pattern from iOS, now also available for other platforms. Putting the
"! Segmented Button to a Bar control on non-iOS platforms will result in something very close to a
"! tab.
CLASS z2ui5_cl_demo_app_474 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_item_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_474 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_event( `SELECTION_CHANGE` ).

      client->message_toast_display( |oEvent.getParameter('item').getText(): '{ client->get_event_arg( 1 ) }' selected| ).
      selected_item_text = |getSelectedItem(): { client->get_event_arg( 1 ) }|.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Segmented Button`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButton` ).

    DATA(page2) = page->page(
        showheader = abap_false
        class      = `sapUiContentPadding` ).

    page2->sub_header(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->segmented_button( `kids`
                )->items(
                    )->segmented_button_item(
                        text = `Kids`
                        key  = `kids`
                    )->segmented_button_item( text = `Adults`
                    )->segmented_button_item( text = `Seniors`
                )->get_parent(
            )->get_parent(
            )->toolbar_spacer( ).

    DATA(vbox) = page2->vbox( width = `100%` ).

    vbox->_generic(
        name   = `SegmentedButton`
        t_prop = VALUE #( ( n = `selectedKey` v = `satellite` )
                          ( n = `class`       v = `sapUiSmallMarginBottom` ) )
        )->items(
            )->segmented_button_item( text = `Map`
            )->segmented_button_item(
                text = `Satellite`
                key  = `satellite`
            )->segmented_button_item( text = `Hybrid` ).

    vbox->_generic(
        name   = `SegmentedButton`
        t_prop = VALUE #( ( n = `selectedKey` v = `competitor` )
                          ( n = `class`       v = `sapUiSmallMarginBottom` ) )
        )->items(
            )->segmented_button_item( icon = `sap-icon://taxi`
            )->segmented_button_item( icon = `sap-icon://lab`
            )->segmented_button_item(
                icon = `sap-icon://competitor`
                key  = `competitor` ).

    vbox->_generic(
        name   = `SegmentedButton`
        t_prop = VALUE #( ( n = `class` v = `sapUiSmallMarginBottom` ) )
        )->items(
            )->segmented_button_item( text = `Selected`
            )->segmented_button_item( text = `Enabled`
            )->segmented_button_item(
                text    = `Disabled`
                enabled = abap_false ).

    vbox->label( `Fire selectionChange event` ).

    vbox->segmented_button( selection_change = client->_event(
                                val   = `SELECTION_CHANGE`
                                t_arg = VALUE #( ( `${$parameters>/item/mProperties/text}` ) ) )
        )->items(
            )->segmented_button_item( text = `One`
            )->segmented_button_item( text = `Two`
            )->segmented_button_item( text = `Three` ).

    vbox->text( client->_bind( selected_item_text ) ).

    page2->footer(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->segmented_button( `small`
                )->items(
                    )->segmented_button_item(
                        text = `Small`
                        key  = `small`
                    )->segmented_button_item( text = `Medium`
                    )->segmented_button_item( text = `Large`
                )->get_parent(
            )->get_parent(
            )->toolbar_spacer( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
