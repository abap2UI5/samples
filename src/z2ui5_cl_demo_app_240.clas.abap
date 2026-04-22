CLASS z2ui5_cl_demo_app_240 DEFINITION PUBLIC.

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
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_240 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Switch`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `POPOVER` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Switch/sample/sap.m.sample.Switch` ).

    DATA(layout) = page->vbox(
                            `sapUiSmallMargin`
                            )->hbox(
                                )->switch( state = abap_true )->get(
                                    )->layout_data(
                                        )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                )->switch( state = abap_false )->get(
                                    )->layout_data(
                                        )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                                )->switch( state   = abap_true
                                           enabled = abap_false )->get(
                                    )->layout_data(
                                        )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent( )->get_parent(
      )->hbox(
                              )->switch( state         = abap_true
                                         customtexton  = `Yes`
                                         customtextoff = `No` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                              )->switch( state         = abap_false
                                         customtexton  = `Yes`
                                         customtextoff = `No` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                              )->switch( state         = abap_true
                                         customtexton  = `Yes`
                                         customtextoff = `No`
                                         enabled       = abap_false )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent( )->get_parent(
      )->hbox(
                              )->switch( state         = abap_true
                                         customtexton  = ` `
                                         customtextoff = ` ` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                              )->switch( state         = abap_false
                                         customtexton  = ` `
                                         customtextoff = ` ` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                              )->switch( state         = abap_true
                                         customtexton  = ` `
                                         customtextoff = ` `
                                         enabled       = abap_false )->get(
                                 )->layout_data(
                                     )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent( )->get_parent(
      )->hbox(
                              )->switch( type  = `AcceptReject`
                                         state = abap_true )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                              )->switch( type = `AcceptReject` )->get(
                                  )->layout_data(
                                     )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
                              )->switch( type    = `AcceptReject`
                                         state   = abap_true
                                         enabled = abap_false )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `POPOVER` ).
      popover_display( `hint_icon` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `"Some say it is only a switch, I say it is one of the most stylish controls in the universe of mobile UI controls." (unknown developer)` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
