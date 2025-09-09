CLASS z2ui5_cl_demo_app_067 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount            TYPE p LENGTH 14 DECIMALS 3.
    DATA currency          TYPE string.
    DATA numeric           TYPE n LENGTH 12.



  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_067 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.

      numeric = '000000000012'.
      amount = '123456789.123'.
      currency = `USD`.

    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( title          = 'abap2UI5 - Currency Format'
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = temp1 ).

    page->simple_form( title    = 'Currency'
                       editable = abap_true
      )->content( 'form'
         )->title( 'Input'
         )->label( 'Documentation'
         )->link( text = 'https://sapui5.hana.ondemand.com/#/entity/sap.ui.model.type.Currency'
                  href = 'https://sapui5.hana.ondemand.com/#/entity/sap.ui.model.type.Currency'
         )->label( 'One field'
         )->input(
             |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                 path = abap_true ) }', '{ client->_bind_edit(
                                                                               val  = currency
                                                                               path = abap_true ) }'],  type: 'sap.ui.model.type.Currency' \}|
         )->label( 'Two field'
         )->input(
             |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                 path = abap_true ) }', '{ client->_bind_edit(
                                                                               val  = currency
                                                                               path = abap_true ) }'],  type: 'sap.ui.model.type.Currency' , formatOptions: \{showMeasure: false\}  \}|
         )->input(
             |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                 path = abap_true ) }', '{ client->_bind_edit(
                                                                               val  = currency
                                                                               path = abap_true ) }'],  type: 'sap.ui.model.type.Currency' , formatOptions: \{showNumber: false\} \}|
         )->label( 'Default'
         )->text(
             |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                 path = abap_true ) }', '{ client->_bind_edit(
                                                                               val  = currency
                                                                               path = abap_true ) }'],  type: 'sap.ui.model.type.Currency' \}|
         )->label( 'preserveDecimals:false'
         )->text( |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                      path = abap_true ) }', '| && client->_bind_edit(
                                                                                       val  = currency
                                                                                       path = abap_true ) &&
                     |'],  type: 'sap.ui.model.type.Currency' , formatOptions: \{ preserveDecimals : false \} \}|
         )->label( 'currencyCode:false'
         )->text( |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                      path = abap_true ) }', '| && client->_bind_edit(
                                                                                       val  = currency
                                                                                       path = abap_true ) &&
                         |'],  type: 'sap.ui.model.type.Currency' , formatOptions: \{ currencyCode : false \} \}|
         )->label( `style:'short'`
         )->text(
             |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                 path = abap_true ) }', '{ client->_bind_edit(
                                                                               val  = currency
                                                                               path = abap_true ) }'],  type: 'sap.ui.model.type.Currency' , formatOptions: \{ style : 'short' \} \}|
         )->label( `style:'long'`
         )->text(
             |\{ parts: [ '{ client->_bind_edit( val  = amount
                                                 path = abap_true ) }', '{ client->_bind_edit(
                                                                               val  = currency
                                                                               path = abap_true ) }'],  type: 'sap.ui.model.type.Currency' , formatOptions: \{   style : 'long' \} \}|
         )->label( 'event'
         )->button( text  = 'send'
                    press = client->_event( 'BUTTON' ) ).

    page->simple_form( title    = 'No Zeros'
                       editable = abap_true
      )->content( 'form'
      )->title( 'Input'
      )->label( 'Documentation'
      )->link( text = 'https://sapui5.hana.ondemand.com/sdk/#/api/sap.ui.model.odata.type.String%23methods/formatValue'
         href       = 'https://sapui5.hana.ondemand.com/sdk/#/api/sap.ui.model.odata.type.String%23methods/formatValue'
      )->label( 'Numeric'
      )->input( value = client->_bind_edit( val = numeric )

      )->label( `Without leading Zeros`

      )->text(
      text = |\{path : '{ client->_bind_edit(
                            val  = numeric
                            path = abap_true ) }', type : 'sap.ui.model.odata.type.String', constraints : \{  isDigitSequence : true \} \}| ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
