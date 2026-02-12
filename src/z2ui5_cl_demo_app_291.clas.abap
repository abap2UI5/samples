CLASS z2ui5_cl_demo_app_291 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA lv_default TYPE string.
    DATA lv_error   TYPE string.
    DATA lv_warning TYPE string.
    DATA lv_success TYPE string.

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

CLASS z2ui5_cl_demo_app_291 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Message Strip with enableFormattedText`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageStrip/sample/sap.m.sample.MessageStripWithEnableFormattedText` ).

    lo_page->vertical_layout(
           class = `sapUiContentPadding`
           width = `100%`
           )->content( ns = `layout`
      )->message_strip(
                  text                = mo_client->_bind( lv_default )
                  enableformattedtext = abap_true
                  showicon            = abap_true
                  showclosebutton     = abap_true
                  class               = `sapUiMediumMarginBottom`
      )->message_strip(
                  text                = mo_client->_bind( lv_error )
                  type                = `Error`
                  enableformattedtext = abap_true
                  showicon            = abap_true
                  showclosebutton     = abap_true
                  class               = `sapUiMediumMarginBottom`
      )->message_strip(
                  text                = mo_client->_bind( lv_warning )
                  type                = `Warning`
                  enableformattedtext = abap_true
                  showicon            = abap_true
                  showclosebutton     = abap_true
                  class               = `sapUiMediumMarginBottom`
      )->message_strip(
                  text                = mo_client->_bind( lv_success )
                  type                = `Success`
                  enableformattedtext = abap_true
                  showicon            = abap_true
                  showclosebutton     = abap_true
                  class               = `sapUiMediumMarginBottom` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `CLICK_HINT_ICON` ).
      display_popover( `button_hint_id` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `A sample MessageStrip that shows status messages with additional formatting.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).

      lv_default = `Default <em>(Information)</em> with default icon and <strong>close button</strong>:`.
      lv_error   = `<strong>Error</strong> with link to ` && `<a target="_blank" href="http://www.sap.com">SAP Homepage</a> <em>(For more info)</em>`.
      lv_warning = `<strong>Warning</strong> with default icon and close button:`.
      lv_success = `<strong>Success</strong> with default icon and close button:`.

    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
