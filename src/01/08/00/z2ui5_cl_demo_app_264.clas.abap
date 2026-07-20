"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInputValueState
"! This example shows different StepInput value states.
CLASS z2ui5_cl_demo_app_264 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_a_data,
           label       TYPE string,
           value_state TYPE string,
         END OF ty_s_a_data.

    DATA
      lt_a_data TYPE STANDARD TABLE OF ty_s_a_data.
    DATA ls_a_data TYPE ty_s_a_data.
    DATA s_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

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


CLASS z2ui5_cl_demo_app_264 IMPLEMENTATION.

  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Step Input - Value States`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `POPOVER` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInputValueState` ).

    page->flex_box( items     = client->_bind( lt_a_data )
                    direction = `Column`
              )->vbox( `sapUiTinyMargin`
                  )->label( text     = `{LABEL}`
                            labelfor = `SI`
                  )->step_input(
                      id         = `SI`
                      width      = `100%`
                      value      = `5`
                      valuestate = `{VALUE_STATE}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `POPOVER` ) IS NOT INITIAL.
      popover_display( `hint_icon` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This example shows different StepInput value states.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <fs_a_data> TYPE ty_s_a_data.
      DATA temp1 LIKE lt_a_data.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( client ).

      s_text = `StepInput with valueState `.

      
      CLEAR temp1.
      
      temp2-value_state = `None`.
      INSERT temp2 INTO TABLE temp1.
      temp2-value_state = `Information`.
      INSERT temp2 INTO TABLE temp1.
      temp2-value_state = `Success`.
      INSERT temp2 INTO TABLE temp1.
      temp2-value_state = `Warning`.
      INSERT temp2 INTO TABLE temp1.
      temp2-value_state = `Error`.
      INSERT temp2 INTO TABLE temp1.
      lt_a_data = temp1.

      " Use field symbols to concatenate the string and store it in the label column

      LOOP AT lt_a_data ASSIGNING <fs_a_data>.
        <fs_a_data>-label = s_text && <fs_a_data>-value_state.
      ENDLOOP.
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
