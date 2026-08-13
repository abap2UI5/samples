" @keywords style stylesheet inline html class own design
CLASS z2ui5_cl_smp_app_050 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_050 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      product  = `tomato`.
      quantity = `500`.
    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON_POST`.
        client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDCASE.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - CSS - Ship Your Own CSS with the View`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `An inline html style element is sent to the frontend with the view, so the sample can restyle ` &&
                   `standard UI5 controls - here the inputs are enlarged and the post button turns red.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->_generic( ns   = `html`
                    name = `style` )->_cc_plain_xml(
                    `.sapMInput {` && |\n| &&
                         `    height: 80px !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `}` && |\n| &&
                         |\n| &&
                         `input {` && |\n| &&
                         `    height: 80% !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `}` && |\n| &&
                         |\n| &&
                         `input[role="textbox"] {` && |\n| &&
                         `    height: 80px !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `}` && |\n| &&
                         |\n| &&
                         `input[role="text"] {` && |\n| &&
                         `    height: 80px !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `}` && |\n| &&
                         |\n| &&
                         `.sapUiSearchField {` && |\n| &&
                         `    height: 35px;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `}` && |\n| &&
                         |\n| &&
                         `.sapUiTfCombo:hover {` && |\n| &&
                         `    height: 2rem;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `}` && |\n| &&
                         |\n| &&
                         `.sapMInputBaseInner::placeholder {` && |\n| &&
                         `    font-size: 1.4rem !important;` && |\n| &&
                         `}`
            )->get_parent(
            )->button(
                        text  = `post`
                        press = client->_event( `BUTTON_POST` )
                        class = `mySuperRedButton`
            )->input( client->_bind( quantity )
            )->simple_form( title    = `Form Title`
                            editable = abap_true
                )->content( `form`
                    )->title( `Input`
                    )->label( `quantity`
                    )->input( client->_bind( quantity )
                    )->label( `product`
                    )->input(
                        value   = product
                        enabled = abap_false
                    )->button(
                        text  = `post`
                        press = client->_event( `BUTTON_POST` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
