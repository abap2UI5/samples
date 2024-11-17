CLASS z2ui5_cl_demo_app_266 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_266 IMPLEMENTATION.

  METHOD display_view.

    DATA(page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( title          = `abap2UI5 - Sample: Toggle Button`
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page_01->header_content(
       )->button( id      = `button_hint_id`
                  icon    = `sap-icon://hint`
                  tooltip = `Sample information`
                  press   = client->_event( 'CLICK_HINT_ICON' ) ).

    page_01->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/#/entity/sap.m.ToggleButton/sample/sap.m.sample.ToggleButton' ).

    DATA(page_02) = page_01->page( title = `Page`
                                   class = `sapUiContentPadding`
                              )->custom_header(
                                  )->bar(
                                      )->content_middle(
                                          )->title( level = `H2`
                                                    text  = `Title`
                                      )->get_parent(
                                      )->content_right(
                                          )->toggle_button(
                                              icon  = `sap-icon://edit`
                                              press = client->_event(
                                                  val   = `onPress`
                                                  t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->sub_header(
                                  )->bar(
                                      )->content_left(
                                          )->toggle_button(
                                              text    = `Pressed`
                                              enabled = abap_true
                                              pressed = abap_true
                                              press   = client->_event(
                                                  val   = `onPress`
                                                  t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                          )->toggle_button(
                                              text    = `Pressed & Disabled`
                                              enabled = abap_false
                                              pressed = abap_true
                                              press   = client->_event(
                                                  val   = `onPress`
                                                  t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                      )->get_parent(
                                      )->content_right(
                                          )->toggle_button(
                                              icon  = `sap-icon://action`
                                              press = client->_event(
                                                  val   = `onPress`
                                                  t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                          )->toggle_button(
                                              icon    = `sap-icon://home`
                                              enabled = abap_false
                                              press   = client->_event(
                                                  val   = `onPress`
                                                  t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->hbox(
                                  )->toggle_button(
                                      text    = `Disabled`
                                      enabled = `false`
                                      press   = client->_event(
                                          val   = `onPress`
                                          t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) ) )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`
                                      )->get_parent(
                                  )->get_parent(
                                  )->toggle_button(
                                      text    = `Pressed`
                                      enabled = abap_true
                                      pressed = abap_true
                                      press   = client->_event(
                                          val   = `onPress`
                                          t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) ) )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`
                                      )->get_parent(
                                  )->get_parent(
                                  )->toggle_button(
                                      icon    = `sap-icon://action`
                                      enabled = abap_true
                                      pressed = abap_true
                                      press   = client->_event(
                                          val   = `onPress`
                                          t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) ) )->get(
                                      )->layout_data(
                                          )->flex_item_data( growfactor = `1`
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->footer(
                                   )->bar(
                                       )->content_right(
                                           )->toggle_button(
                                               text    = `Pressed & Disabled`
                                               enabled = abap_false
                                               pressed = abap_true
                                               press   = client->_event(
                                                   val   = `onPress`
                                                   t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                           )->toggle_button(
                                               icon  = `sap-icon://action`
                                               press = client->_event(
                                                   val   = `onPress`
                                                   t_arg = VALUE #( ( `${$source>/pressed}` ) ( `${$source>/id}` ) ) )
                                       )->get_parent(
                                   )->get_parent(
                              )->get_parent(
                             ).
    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
      WHEN 'onPress'.
        IF client->get_event_arg( 1 ) = 'X'.
          client->message_toast_display( |{ client->get_event_arg( 2 ) } Pressed| ).
        ELSE.
          client->message_toast_display( |{ client->get_event_arg( 2 ) } Unpressed| ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Toggle Buttons can be toggled between pressed and normal state.` ).

    client->popover_display( xml   = view->stringify( )
                             by_id = id
    ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
