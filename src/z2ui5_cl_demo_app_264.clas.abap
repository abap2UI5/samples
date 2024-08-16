class Z2UI5_CL_DEMO_APP_264 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ty_a_data,
           label      TYPE string,
           value_state TYPE string,
         END OF ty_a_data .

  data:
    lt_a_data TYPE STANDARD TABLE OF ty_a_data .
  data LS_A_DATA type TY_A_DATA .
  data S_TEXT type STRING .
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



CLASS Z2UI5_CL_DEMO_APP_264 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Step Input - Value States'
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
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInputValueState' ).

     page->flex_box( items = client->_bind( lt_a_data ) direction = `Column`
              )->vbox( class = `sapUiTinyMargin`
                  )->label( text = '{LABEL}' labelfor = `SI`
                  )->step_input(
                      id = `SI`
                      width = `100%`
                      value = `5`
                      valuestate = '{VALUE_STATE}' ).

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
                                  description = `This example shows different StepInput value states.` ).

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

      s_text = 'StepInput with valueState '.

      lt_a_data = VALUE #(
        ( value_state = 'None' )
        ( value_state = 'Information' )
        ( value_state = 'Success' )
        ( value_state = 'Warning' )
        ( value_state = 'Error' )
      ).

      " Use field symbols to concatenate the string and store it in the label column
      FIELD-SYMBOLS: <fs_a_data> TYPE ty_a_data.

      LOOP AT lt_a_data ASSIGNING <fs_a_data>.
        <fs_a_data>-label = s_text && ` ` && <fs_a_data>-value_state.
      ENDLOOP.
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
