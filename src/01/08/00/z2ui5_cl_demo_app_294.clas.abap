"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DatePicker/sample/sap.m.sample.DatePickerValueState
"! This example shows different DatePicker value states.
CLASS z2ui5_cl_demo_app_294 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_a_data,
        label            TYPE string,
        value_state      TYPE string,
        value_state_text TYPE string,
      END OF ty_s_a_data.
    DATA lt_a_data TYPE STANDARD TABLE OF ty_s_a_data.
    DATA s_text TYPE string.

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


CLASS z2ui5_cl_demo_app_294 IMPLEMENTATION.

  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Date Picker - Value States`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DatePicker/sample/sap.m.sample.DatePickerValueState` ).

    page->flex_box( items     = client->_bind( lt_a_data )
                    direction = `Column`
             )->vbox( `sapUiTinyMargin`
                 )->label( text     = `{LABEL}`
                           labelfor = `DP`
                 )->date_picker(
                     id             = `DP`
                     width          = `100%`
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
                                  description = `This example shows different DatePicker value states.` ).

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

    DATA temp1 TYPE string.
    DATA temp2 LIKE lt_a_data.
    DATA temp3 TYPE z2ui5_cl_demo_app_294=>ty_s_a_data.
    DATA temp4 TYPE z2ui5_cl_demo_app_294=>ty_s_a_data.
    DATA temp5 TYPE z2ui5_cl_demo_app_294=>ty_s_a_data.
    DATA temp6 TYPE z2ui5_cl_demo_app_294=>ty_s_a_data.
    DATA temp7 TYPE z2ui5_cl_demo_app_294=>ty_s_a_data.
    CLEAR temp1.
    s_text    = temp1.
    
    CLEAR temp2.
    lt_a_data = temp2.

    s_text = `DatePicker with valueState `.

    " Append entries to the internal table
    
    CLEAR temp3.
    temp3-label = s_text && `None`.
    temp3-value_state = `None`.
    APPEND temp3 TO lt_a_data.

    
    CLEAR temp4.
    temp4-label = s_text && `Information`.
    temp4-value_state = `Information`.
    APPEND temp4 TO lt_a_data.

    
    CLEAR temp5.
    temp5-label = s_text && `Success`.
    temp5-value_state = `Success`.
    APPEND temp5 TO lt_a_data.

    
    CLEAR temp6.
    temp6-label = s_text && `Warning and long valueStateText`.
    temp6-value_state = `Warning`.
    temp6-value_state_text = `Warning message. This is an extra long text used as a warning message. ` && `It illustrates how the text wraps into two or more lines without truncation to show the full length of the message.`.
    APPEND temp6 TO lt_a_data.

    
    CLEAR temp7.
    temp7-label = s_text && `Error`.
    temp7-value_state = `Error`.
    APPEND temp7 TO lt_a_data.

  ENDMETHOD.

ENDCLASS.
