CLASS z2ui5_cl_demo_app_295 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_a_data,
        label            TYPE string,
        value_state      TYPE string,
        value_state_text TYPE string,
      END OF ty_a_data.

    DATA lt_a_data TYPE STANDARD TABLE OF ty_a_data.
    DATA s_text TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_set_data.
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



CLASS z2ui5_cl_demo_app_295 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Date Range Selection - Value States'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelectionValueState' ).

    page->flex_box( items = client->_bind( lt_a_data ) direction = `Column`
             )->vbox( class = `sapUiTinyMargin`
                 )->label( text = '{LABEL}'
                 )->date_range_selection(
                     width = `100%`
                     valuestate = '{VALUE_STATE}'
                     valuestatetext = '{VALUE_STATE_TEXT}' )->get_parent(
             )->get_parent(
          ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `This example shows different DateRangeSelection value states.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
      z2ui5_set_data( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    CLEAR s_text.
    CLEAR lt_a_data.

    s_text = 'DateRangeSelection with valueState '.

    " Append entries to the internal table
    APPEND VALUE #( label = s_text && 'None'
                    value_state = 'None' ) TO lt_a_data.

    APPEND VALUE #( label = s_text && 'Information'
                    value_state = 'Information' ) TO lt_a_data.

    APPEND VALUE #( label = s_text && 'Success'
                    value_state = 'Success' ) TO lt_a_data.

    APPEND VALUE #( label = s_text && 'Warning and long valueStateText'
                    value_state = 'Warning'
                    value_state_text = 'Warning message. This is an extra long text used as a warning message. ' &&
                                       'It illustrates how the text wraps into two or more lines without truncation to show the full length of the message.' ) TO lt_a_data.

    APPEND VALUE #( label = s_text && 'Error'
                    value_state = 'Error' ) TO lt_a_data.
  ENDMETHOD.
ENDCLASS.
