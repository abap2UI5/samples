CLASS Z2UI5_CL_DEMO_APP_050 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_050 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      product  = 'tomato'.
      quantity = '500'.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BUTTON_POST'.
        client->message_toast_display( |{ product } { quantity } - send to the server| ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
    ENDCASE.

   client->view_display( Z2UI5_cl_xml_view=>factory( client
        )->shell(
        )->page(
                title          = 'abap2UI5 - Changed CSS'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    href = Z2UI5_CL_XML_VIEW=>factory( client )->hlp_get_source_code_url( )
                    target = '_blank'
            )->get_parent(
            )->_cc_plain_xml( `<html:style> .sapMInput {` && |\n|  &&
                         `    height: 80px !important;` && |\n|  &&
                         `    font-size: 2.5rem !important;` && |\n|  &&
                         `}` && |\n|  &&
                         |\n|  &&
                         `input {` && |\n|  &&
                         `    height: 80% !important;` && |\n|  &&
                         `    font-size: 2.5rem !important;` && |\n|  &&
                         `}` && |\n|  &&
                         |\n|  &&
                         `input[role="textbox"] {` && |\n|  &&
                         `    height: 80px !important;` && |\n|  &&
                         `    font-size: 2.5rem !important;` && |\n|  &&
                         `}` && |\n|  &&
                         |\n|  &&
                         `input[role="text"] {` && |\n|  &&
                         `    height: 80px !important;` && |\n|  &&
                         `    font-size: 2.5rem !important;` && |\n|  &&
                         `}` && |\n|  &&
                         |\n|  &&
                         `.sapUiSearchField {` && |\n|  &&
                         `    height: 35px;` && |\n|  &&
                         `    font-size: 2.5rem !important;` && |\n|  &&
                         `}` && |\n|  &&
                         |\n|  &&
                         `.sapUiTfCombo:hover {` && |\n|  &&
                         `    height: 2rem;` && |\n|  &&
                         `    font-size: 2.5rem !important;` && |\n|  &&
                         `}` && |\n|  &&
                         |\n|  &&
                         `.sapMInputBaseInner::placeholder {` && |\n|  &&
                         `    font-size: 1.4rem !important;` && |\n|  &&
                         `}</html:style> `
            )->button(
                        text  = 'post'
                        press = client->_event( 'BUTTON_POST' )
                        class = `mySuperRedButton`
            )->input( value = client->_bind( quantity )
            )->simple_form( title = 'Form Title' editable = abap_true
                )->content( 'form'
                    )->title( 'Input'
                    )->label( 'quantity'
                    )->input( value = client->_bind( quantity )
                    )->label( 'product'
                    )->input(
                        value   = product
                        enabled = abap_false
                    )->button(
                        text  = 'post'
                        press = client->_event( 'BUTTON_POST' )
         )->get_root( )->xml_get( ) ).

  ENDMETHOD.
ENDCLASS.
