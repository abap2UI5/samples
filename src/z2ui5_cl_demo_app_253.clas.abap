class Z2UI5_CL_DEMO_APP_253 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
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



CLASS Z2UI5_CL_DEMO_APP_253 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(css) = `.equalColumns .columns {`               &&
                `    min-height: 200px;`                 &&
                `}`                                      &&
                ``                                       &&
                `.equalColumns .columns .sapMFlexItem {` &&
                `    padding: 0.5rem;`                   &&
                `}`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Equal Height Cols`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'POPOVER' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FlexBox/sample/sap.m.sample.FlexBoxCols' ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding equalColumns` width = `100%`
                          )->flex_box( class = `columns`
                              )->text( text = `Although they have different amounts of text, both columns are of equal height.` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1`
                                                         basesize = `0`
                                                         backgrounddesign = `Solid`
                                                         styleclass = `sapUiTinyMargin` )->get_parent( )->get_parent(
                              )->text( text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
                                              `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                              `At vero eos et accusam et justo hey nonny no duo dolores et ea rebum. ` &&
                                              `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                              `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                              `sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                                              `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.` )->get(
                                  )->layout_data(
                                      )->flex_item_data( growfactor = `1`
                                                         basesize = `0`
                                                         backgrounddesign = `Solid`
                                                         styleclass = `sapUiTinyMargin` )->get_parent(
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `You can create balanced areas with Flex Box, such as these columns with equal height regardless of content.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
