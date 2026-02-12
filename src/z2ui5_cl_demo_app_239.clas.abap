CLASS z2ui5_cl_demo_app_239 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_239 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Check Box`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CheckBox/sample/sap.m.sample.CheckBox` ).

    DATA(lo_layout) = lo_page->vbox(
                          )->checkbox( text     = `Option a`
                                       selected = abap_true
                          )->checkbox( text = `Option b`
                          )->checkbox( text     = `Option c`
                                       selected = abap_true
                          )->checkbox( text = `Option d`
                          )->checkbox( text    = `Option e`
                                       enabled = abap_false
                          )->checkbox( text              = `Option partially selected`
                                       selected          = abap_true
                                       partiallyselected = abap_true
                          )->checkbox( text     = `Required option`
                                       required = abap_true
                          )->checkbox( text       = `Warning`
                                       valuestate = `Warning`
                          )->checkbox( text       = `Warning disabled`
                                       valuestate = `Warning`
                                       enabled    = abap_false
                                       selected   = abap_true
                          )->checkbox( text       = `Error`
                                       valuestate = `Error`
                          )->checkbox( text       = `Error disabled`
                                       valuestate = `Error`
                                       enabled    = abap_false
                                       selected   = abap_true
                          )->checkbox( text       = `Information`
                                       valuestate = `Information`
                          )->checkbox( text       = `Information disabled`
                                       valuestate = `Information`
                                       enabled    = abap_false
                                       selected   = abap_true
                          )->checkbox( text     = `Checkbox with wrapping='true' and long text`
                                       wrapping = abap_true
                                       width    = `150px` ).
    lo_layout->simple_form(
             editable   = abap_true
             layout     = `ResponsiveGridLayout`
             labelspanl = `4`
             labelspanm = `4`
             )->content( ns = `form`
                 )->label( text = `Clearing with Customer`
                 )->checkbox( text = `Option`
                 )->checkbox( text     = `Option 2`
                              selected = abap_true )->get(
                     )->layout_data(
                         )->grid_data( linebreak = abap_true
                                       indentl   = `4`
                                       indentm   = `4` )->get_parent( )->get_parent(
                 )->checkbox( id   = `focusMe`
                              text = `Option 3` )->get(
                     )->layout_data(
                         )->grid_data( linebreak = abap_true
                                       indentl   = `4`
                                       indentm   = `4` )->get_parent( )->get_parent(
                 )->checkbox( text     = `Checkbox with wrapping='true' and long text placed in a form`
                              wrapping = abap_true
                              width    = `200px` )->get(
                     )->layout_data(
                         )->grid_data( linebreak = abap_true
                                       indentl   = `4`
                                       indentm   = `4` ).

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
                                  description = `Checkboxes allow users to select a subset of options. If you want to offer an off/on setting you should use the Switch control instead.` ).

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
