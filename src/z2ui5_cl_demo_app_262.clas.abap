class Z2UI5_CL_DEMO_APP_262 definition
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



CLASS Z2UI5_CL_DEMO_APP_262 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Numeric Content of Different Colors'
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
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NumericContent/sample/sap.m.sample.NumericContentDifColors' ).

    page->numeric_content( value = `888.8` scale = `MM` class = `sapUiSmallMargin`
                             press = client->_event( 'press' ) truncatevalueto = `4` ).
    page->numeric_content( value = `65.5` scale = `MM`
                             valueColor = `Good` indicator = `Up` class = `sapUiSmallMargin`
                             press = client->_event( 'press' ) ).
    page->numeric_content( value = `6666` scale = `MM`
                             valueColor = `Critical` indicator = `Up` class = `sapUiSmallMargin`
                             press = client->_event( 'press' ) ).
    page->numeric_content( value = `65.5` scale = `MMill`
                             valueColor = `Error` indicator = `Down` class = `sapUiSmallMargin`
                             press = client->_event( 'press' ) ).
    page->generic_tile( class = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout` header = `Country-Specific Profit Margin` subheader = `Expenses` press = client->_event( 'press' )
             )->tile_content( unit = `EUR` footer = `Current Quarter`
                 )->numeric_content( scale = `M` value = `1.96` valueColor = `Error` indicator = `Up` withMargin = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'press'.
        client->message_toast_display( `The numeric content is pressed.` ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `Shows NumericContent including numbers, units of measurement, and status arrows indicating a trend. ` &&
                                                `The numbers can be colored according to their meaning.` ).

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
