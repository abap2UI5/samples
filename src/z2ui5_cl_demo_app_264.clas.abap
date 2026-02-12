CLASS z2ui5_cl_demo_app_264 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_a_data,
           label       TYPE string,
           value_state TYPE string,
         END OF ty_a_data .

    DATA
      lt_a_data TYPE STANDARD TABLE OF ty_a_data .
    DATA ms_text TYPE string .
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

CLASS z2ui5_cl_demo_app_264 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Step Input - Value States`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInputValueState` ).

    lo_page->flex_box( items     = mo_client->_bind( lt_a_data )
                    direction = `Column`
              )->vbox( class = `sapUiTinyMargin`
                  )->label( text     = `{LABEL}`
                            labelfor = `SI`
                  )->step_input(
                      id         = `SI`
                      width      = `100%`
                      value      = `5`
                      valuestate = `{VALUE_STATE}` ).

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
                                  description = `This example shows different StepInput value states.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <fs_a_data> TYPE ty_a_data.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).

      ms_text = `StepInput with valueState `.

      lt_a_data = VALUE #(
        ( value_state = `None` )
        ( value_state = `Information` )
        ( value_state = `Success` )
        ( value_state = `Warning` )
        ( value_state = `Error` ) ).

      " Use field symbols to concatenate the string and store it in the label column

      LOOP AT lt_a_data ASSIGNING <fs_a_data>.
        <fs_a_data>-label = ms_text && ` ` && <fs_a_data>-value_state.
      ENDLOOP.
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
