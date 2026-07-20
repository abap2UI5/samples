"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelectionValueState
"! This example shows different DateRangeSelection value states.
CLASS z2ui5_cl_demo_app_295 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        label            TYPE string,
        value_state      TYPE string,
        value_state_text TYPE string,
      END OF ty_s_data.
    DATA t_data TYPE STANDARD TABLE OF ty_s_data.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_295 IMPLEMENTATION.

  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Date Range Selection - Value States`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelectionValueState` ).

    page->flex_box( items     = client->_bind( t_data )
                    direction = `Column`
             )->vbox( `sapUiTinyMargin`
                 )->label( `{LABEL}`
                 )->date_range_selection(
                     width          = `100%`
                     delimiter      = `–`
                     valuestate     = `{VALUE_STATE}`
                     valuestatetext = `{VALUE_STATE_TEXT}` )->get_parent(
             )->get_parent( ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `CLICK_HINT_ICON` ) IS NOT INITIAL.
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This example shows different DateRangeSelection value states.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      view_display( client ).
      set_data( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD set_data.

    DATA text TYPE string.
    DATA temp1 LIKE t_data.
    DATA temp2 LIKE LINE OF temp1.
    text = `DateRangeSelection with valueState `.
    
    CLEAR temp1.
    
    temp2-label = |{ text }None|.
    temp2-value_state = `None`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = |{ text }Information|.
    temp2-value_state = `Information`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = |{ text }Success|.
    temp2-value_state = `Success`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = |{ text }Warning and long valueStateText|.
    temp2-value_state = `Warning`.
    temp2-value_state_text = `Warning message. This is an extra long text used as a warning message. ` &&
`It illustrates how the text wraps into two or more lines without truncation to show the full length of the message.`.
    INSERT temp2 INTO TABLE temp1.
    temp2-label = |{ text }Error|.
    temp2-value_state = `Error`.
    INSERT temp2 INTO TABLE temp1.
    t_data = temp1.

  ENDMETHOD.

ENDCLASS.
