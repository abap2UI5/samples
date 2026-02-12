CLASS z2ui5_cl_demo_app_253 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_253 IMPLEMENTATION.

  METHOD display_view.

    DATA(lv_css) = `.equalColumns .columns {`               &&
                `    min-height: 200px;`                 &&
                `}`                                      &&
                ``                                       &&
                `.equalColumns .columns .sapMFlexItem {` &&
                `    padding: 0.5rem;`                   &&
                `}`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( lv_css )->get_parent( ).

    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Equal Height Cols`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxCols` ).

    DATA(lo_layout) = lo_page->vertical_layout( class = `sapUiContentPadding equalColumns`
                                          width = `100%`
                          )->flex_box( class = `columns`
                              )->text( text = `Although they have different amounts of text, both columns are of equal height.` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor       = `1`
                                                         basesize         = `0`
                                                         backgrounddesign = `Solid`
                                                         styleclass       = `sapUiTinyMargin` )->get_parent( )->get_parent(
                              )->text( text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
                                              `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                              `At vero eos et accusam et justo hey nonny no duo dolores et ea rebum. ` &&
                                              `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                              `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                              `sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                                              `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor       = `1`
                                                         basesize         = `0`
                                                         backgrounddesign = `Solid`
                                                         styleclass       = `sapUiTinyMargin` )->get_parent( ).

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
                                  description = `You can create balanced areas with Flex Box, such as these columns with equal height regardless of content.` ).

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
