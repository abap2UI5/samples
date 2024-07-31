class Z2UI5_CL_DEMO_APP_251 definition
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



CLASS Z2UI5_CL_DEMO_APP_251 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Input - Description'
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
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputDescription' ).

    DATA(layout) = page->vertical_layout( class  = `sapUiContentPadding` width = `100%` ).

    layout->input( value = `10`
                   description = `PC`
                   width = `100px`
                   fieldWidth = `60%`
                   class = `sapUiSmallMarginBottom` ).

    layout->input( value = `220`
                   description = `EUR / 5 pieces`
                   width = `200px`
                   fieldWidth = `60px`
                   class = `sapUiSmallMarginBottom` ).

    layout->input( value = `220.00`
                   description = `EUR`
                   width = `250px`
                   fieldWidth = `80%`
                   showClearIcon = abap_true
                   class = `sapUiSmallMarginBottom` ).

    layout->input( value = `007`
                   description = `Bastian Schweinsteiger`
                   width = `300px`
                   fieldWidth = `50px`
                   class = `sapUiSmallMarginBottom` ).

    layout->input( value = `EDP_LAPTOP`
                   ariaDescribedBy = `descriptionNodeId`
                   description = `IT Laptops`
                   width = `400px`
                   fieldWidth = `75%`
                   class = `sapUiSmallMarginBottom` ).

    layout->invisible_text( ns = `core` id = `descriptionNodeId` text = `Additional input description refferenced by aria-describedby.` ).

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
                                  description = `This sample illustrates the usage of the description with input fields, e.g. description for units of measurements and currencies.` ).

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
