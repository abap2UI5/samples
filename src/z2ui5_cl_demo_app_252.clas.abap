CLASS z2ui5_cl_demo_app_252 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_252 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Render Type`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxRenderType` ).

    DATA(lo_layout) = lo_page->vbox(
                          )->panel( headertext = `Render Type - Div`
                              )->flex_box( rendertype = `Div`
                                  )->button( text  = `Some text`
                                             type  = `Emphasized`
                                             class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `3` )->get_parent( )->get_parent(
                                  )->input( value = `Some value`
                                            width = `auto`
                                            class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `2` )->get_parent( )->get_parent(
                                  )->button( icon = `sap-icon://download` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->panel( headertext = `Render Type - Bare`
                              )->flex_box( rendertype = `Bare`
                                  )->button( text  = `Some text`
                                             type  = `Emphasized`
                                             class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `3` )->get_parent( )->get_parent(
                                  )->input( value = `Some value`
                                            width = `auto`
                                            class = `sapUiSmallMarginEnd` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `2` )->get_parent( )->get_parent(
                                  )->button( icon = `sap-icon://download` )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1` )->get_parent( ).

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
                                  description = `Flex items can be rendered differently. By default, they are wrapped in a div element. ` &&
                                                `Optionally, the bare controls can be rendered directly. This can affect the resulting layout.` ).

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
