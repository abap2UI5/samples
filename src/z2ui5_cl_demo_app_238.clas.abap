CLASS z2ui5_cl_demo_app_238 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_238 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Message Strip`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageStrip/sample/sap.m.sample.MessageStrip` ).

    DATA(lo_layout) = lo_page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    lo_layout->message_strip( text    = `Default (Information) with default icon and close button:`
                   showicon        = abap_true
                   showclosebutton = abap_true
                   class           = `sapUiMediumMarginBottom` ).

    lo_layout->message_strip( text    = `Error with default icon and close button:`
                   type            = `Error`
                   showicon        = abap_true
                   showclosebutton = abap_true
                   class           = `sapUiMediumMarginBottom` ).

    lo_layout->message_strip( text    = `Warning with default icon and close button:`
                   type            = `Warning`
                   showicon        = abap_true
                   showclosebutton = abap_true
                   class           = `sapUiMediumMarginBottom` ).

    lo_layout->message_strip( text    = `Success with default icon and close button:`
                   type            = `Success`
                   showicon        = abap_true
                   showclosebutton = abap_true
                   class           = `sapUiMediumMarginBottom` ).

    lo_layout->message_strip( text = `Information with default icon.`
                   type         = `Information`
                   showicon     = abap_true
                   class        = `sapUiMediumMarginBottom` ).

    lo_layout->message_strip( text = `Information with custom icon`
                   type         = `Information`
                   showicon     = abap_true
                   customicon   = `sap-icon://locked`
                   class        = `sapUiMediumMarginBottom` ).

    lo_layout->message_strip( text    = `Error with link`
                   type            = `Error`
                   showclosebutton = abap_true
                   class           = `sapUiMediumMarginBottom`
                   )->get(
                       )->link( text   = `Open SAP Homepage`
                                target = `_blank`
                                href   = `http://www.sap.com` ).

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
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `MessageStrip for showing status messages.` ).

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
