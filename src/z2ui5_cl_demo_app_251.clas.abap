CLASS z2ui5_cl_demo_app_251 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_251 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Description`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputDescription` ).

    DATA(lo_layout) = lo_page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    lo_layout->input( value       = `10`
                   description = `PC`
                   width       = `100px`
                   fieldwidth  = `60%`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->input( value       = `220`
                   description = `EUR / 5 pieces`
                   width       = `200px`
                   fieldwidth  = `60px`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->input( value         = `220.00`
                   description   = `EUR`
                   width         = `250px`
                   fieldwidth    = `80%`
                   showclearicon = abap_true
                   class         = `sapUiSmallMarginBottom` ).

    lo_layout->input( value       = `007`
                   description = `Bastian Schweinsteiger`
                   width       = `300px`
                   fieldwidth  = `50px`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->input( value           = `EDP_LAPTOP`
                   ariadescribedby = `descriptionNodeId`
                   description     = `IT Laptops`
                   width           = `400px`
                   fieldwidth      = `75%`
                   class           = `sapUiSmallMarginBottom` ).

    lo_layout->invisible_text( ns   = `core`
                            id   = `descriptionNodeId`
                            text = `Additional input description refferenced by aria-describedby.` ).

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
                                  description = `This sample illustrates the usage of the description with input fields, e.g. description for units of measurements and currencies.` ).

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
