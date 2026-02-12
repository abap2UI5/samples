CLASS z2ui5_cl_demo_app_295 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_a_data,
        label            TYPE string,
        value_state      TYPE string,
        value_state_text TYPE string,
      END OF ty_a_data.

    DATA lt_a_data TYPE STANDARD TABLE OF ty_a_data.
    DATA ms_text TYPE string.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
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

CLASS z2ui5_cl_demo_app_295 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Date Range Selection - Value States`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelectionValueState` ).

    lo_page->flex_box( items     = mo_client->_bind( lt_a_data )
                    direction = `Column`
             )->vbox( class = `sapUiTinyMargin`
                 )->label( text = `{LABEL}`
                 )->date_range_selection(
                     width          = `100%`
                     valuestate     = `{VALUE_STATE}`
                     valuestatetext = `{VALUE_STATE_TEXT}` )->get_parent(
             )->get_parent( ).

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
                                  description = `This example shows different DateRangeSelection value states.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
      set_data( ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.

  METHOD set_data.

    CLEAR ms_text.
    CLEAR lt_a_data.

    ms_text = `DateRangeSelection with valueState `.

    " Append entries to the internal table
    lt_a_data = VALUE #(
      ( label = ms_text && `None`        value_state = `None` )
      ( label = ms_text && `Information` value_state = `Information` )
      ( label = ms_text && `Success`     value_state = `Success` )
      ( label = ms_text && `Warning and long valueStateText` value_state = `Warning`
                value_state_text = `Warning message. This is an extra long text used as a warning message. ` &&
                                   `It illustrates how the text wraps into two or more lines without truncation to show the full length of the message.` )
      ( label = ms_text && `Error`    value_state = `Error` ) ).
  ENDMETHOD.
ENDCLASS.
