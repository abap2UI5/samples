CLASS z2ui5_cl_demo_app_266 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_266 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Toggle Button`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page_01->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/#/entity/sap.m.ToggleButton/sample/sap.m.sample.ToggleButton` ).

    DATA(lo_page_02) = lo_page_01->page(
                              title = `Page`
                              class = `sapUiContentPadding`
                              )->custom_header(
                                  )->bar(
                                      )->content_middle(
                                          )->title( level = `H2`
                                                    text  = `Title`
                                      )->get_parent(
                                      )->content_right(
                                          )->toggle_button( icon  = `sap-icon://edit`
                                                            press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->sub_header(
                                  )->bar(
                                      )->content_left(
                                          )->toggle_button( text    = `Pressed`
                                                            enabled = abap_true
                                                            pressed = abap_true
                                                            press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                          )->toggle_button( text    = `Pressed & Disabled`
                                                            enabled = abap_false
                                                            pressed = abap_true
                                                            press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                      )->get_parent(
                                      )->content_right(
                                          )->toggle_button( icon  = `sap-icon://action`
                                                            press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                          )->toggle_button( icon    = `sap-icon://home`
                                                            enabled = abap_false
                                                            press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->hbox(
                                  )->toggle_button( text    = `Disabled`
                                                    enabled = `false`
                                                    press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) ) )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`
                                      )->get_parent(
                                  )->get_parent(
                                  )->toggle_button( text    = `Pressed`
                                                    enabled = abap_true
                                                    pressed = abap_true
                                                    press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) ) )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`
                                      )->get_parent(
                                  )->get_parent(
                                  )->toggle_button( icon    = `sap-icon://action`
                                                    enabled = abap_true
                                                    pressed = abap_true
                                                    press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) ) )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->footer(
                                   )->bar(
                                       )->content_right(
                                           )->toggle_button( text    = `Pressed & Disabled`
                                                             enabled = abap_false
                                                             pressed = abap_true
                                                             press   = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                           )->toggle_button( icon  = `sap-icon://action`
                                                             press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                       )->get_parent(
                                   )->get_parent(
                              )->get_parent( ).
    mo_client->view_display( lo_page_02->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `ON_PRESS`.
        IF mo_client->get_event_arg( 1 ) = `X`.
          mo_client->message_toast_display( mo_client->get_event_arg( 2 ) && ` Pressed` ).
        ELSE.
          mo_client->message_toast_display( mo_client->get_event_arg( 2 ) && ` Unpressed` ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Toggle Buttons can be toggled between pressed and normal state.` ).

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
