CLASS z2ui5_cl_demo_app_240 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_240 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Switch`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Switch/sample/sap.m.sample.Switch` ).

    DATA(lo_layout) = lo_page->vbox(
                            class = `sapUiSmallMargin`
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
                                  description = `"Some say it is only a switch, I say it is one of the most stylish controls in the universe of mobile UI controls." (unknown developer)` ).

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
