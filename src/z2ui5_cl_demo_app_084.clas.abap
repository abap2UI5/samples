CLASS z2ui5_cl_demo_app_084 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA mt_messaging TYPE z2ui5_cl_cc_messaging=>ty_t_items.

    "string - constraints
    DATA: mv_maxlength_string            TYPE string,
          mv_minlength_string            TYPE string,
          mv_startswith_string           TYPE string,
          mv_startswithignorecase_string TYPE string,
          mv_endswith_string             TYPE string,
          mv_endswithignorecase_string   TYPE string,
          mv_contains_string             TYPE string,
          mv_equals_string               TYPE string,
          mv_search_string               TYPE string.

    "integer - formatOptions
    DATA: mv_minintegerdigits_int  TYPE string,
          mv_maxintegerdigits_int  TYPE string,
          mv_groupingenabled_int   TYPE string,
          mv_groupingseparator_int TYPE string.

    "integer - constraints
    DATA: mv_maximum_int TYPE string,
          mv_minimum_int TYPE string.

    "integer - formatOptions
    DATA: mv_minfractiondigits_float TYPE string,
          mv_maxfractiondigits_float TYPE string,
          mv_decimalseparator_float  TYPE string.

    "integer - constraints
    DATA: mv_maximum_float TYPE string,
          mv_minimum_float TYPE string.

    "date - constraints
    DATA: mv_maximum_date TYPE string,
          mv_minimum_date TYPE string.

    DATA mv_input_master TYPE string.
    DATA check_initialized TYPE abap_bool .
    METHODS z2ui5_display_view .

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_084 IMPLEMENTATION.

  METHOD z2ui5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_z2ui5( )->message_manager( client->_bind_edit( mt_messaging ) ).
    DATA(page) = view->shell(
        )->page( class = `sapUiContentPadding `
            title          = 'abap2UI5 - Input Validation'
            navbuttonpress = client->_event( val = 'BACK' )
           shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            ).

    "string
    page->flex_box( justifycontent = `SpaceAround` )->panel( headertext = `sap.ui.model.type.String`
       )->vbox(
         )->title( text = `CONSTRAINTS` level = `H3`
         )->vbox(
           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `maxLength (5)`
             )->input( id = `testINPUT` value = `{path:'` && client->_bind_edit( val = mv_maxlength_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ maxLength: 5 } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd`
          )->input( id = `inputMain`
     value = `{path:'` && client->_bind_edit( val = mv_input_master path = abap_true ) && `',type:'sap.ui.model.type.String', constraints: { maxLength: 3 } }`
    )->get_parent(
           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `minLength (3)`
             )->input( value = `{path:'` && client->_bind_edit( val = mv_minlength_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ minLength: 3 } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd` )->get_parent(

           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `startsWith (a2ui5)`
             )->input( value = `{path:'` && client->_bind_edit( val = mv_startswith_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ startsWith: 'a2ui5' } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd` )->get_parent(

           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `startsWithIgnoreCase (a2ui5)`
             )->input( value = `{path:'` && client->_bind_edit( val = mv_startswithignorecase_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ startsWithIgnoreCase: 'a2ui5' } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd` )->get_parent(

           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `endsWith (a2ui5)`
             )->input( value = `{path:'` && client->_bind_edit( val = mv_endswith_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ endsWith: 'a2ui5' } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd` )->get_parent(

           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `endsWithIgnoreCase (a2ui5)`
             )->input( value = `{path:'` && client->_bind_edit( val = mv_endswithignorecase_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ endsWithIgnoreCase: 'a2ui5' } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd` )->get_parent(

           )->get_parent( )->get_parent( )->get_parent(
           )->panel( headertext = `sap.ui.model.type.Integer`
              )->vbox(
               )->title( text = `FORMAT OPTIONS and CONSTRAINTS` level = `H3`
               )->vbox(
                 )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
                   )->label( text = `minIntegerDigits (1)`
                   )->input( value = `{path:'` && client->_bind_edit( val = mv_minintegerdigits_int path = abap_true ) && `',type: 'sap.ui.model.type.Integer', formatOptions:{ minIntegerDigits: 1 }, constraints:{ maximum: 10 } }`
                             editable = abap_true
                             class = `sapUiTinyMarginBeginEnd` )->get_parent(

                 )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
                   )->label( text = `maxIntegerDigits (3)`
                   )->input( value = `{path:'` && client->_bind_edit( val = mv_maxintegerdigits_int path = abap_true ) && `',type: 'sap.ui.model.type.Integer', formatOptions:{ maxIntegerDigits: 3 }, constraints:{ minimum: 100 }  }`
                             editable = abap_true
                             class = `sapUiTinyMarginBeginEnd` )->get_parent(

                 )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
                   )->label( text = `groupingEnabled`
                   )->input( value = `{path:'` && client->_bind_edit( val = mv_groupingenabled_int path = abap_true ) && `',type: 'sap.ui.model.type.Integer', formatOptions:{ groupingEnabled: true } }`
                             editable = abap_true
                             class = `sapUiTinyMarginBeginEnd` )->get_parent(

                 )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
                   )->label( text = `groupingSeparator (-)`
                   )->input( value = `{path:'` && client->_bind_edit( val = mv_groupingseparator_int path = abap_true ) && `',type: 'sap.ui.model.type.Integer', formatOptions:{ groupingEnabled: true, groupingSeparator: '-' } }`
                             editable = abap_true
                             class = `sapUiTinyMarginBeginEnd` )->get_parent(


          )->get_parent( )->get_parent( )->get_parent(
          )->panel( headertext = `sap.ui.model.type.Float`
              )->vbox(
               )->title( text = `FORMAT OPTIONS and CONSTRAINTS` level = `H3`
               )->vbox(
                 )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
                   )->label( text = `minFractionDigits (2)`
                   )->input( value = `{path:'` && client->_bind_edit( val = mv_minfractiondigits_float path = abap_true ) && `',type: 'sap.ui.model.type.Float', formatOptions:{ minFractionDigits: 2 } }`
                             editable = abap_true
                             class = `sapUiTinyMarginBeginEnd` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display(
        view->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_message_manager=>get_js( )
            )->_z2ui5( )->timer( client->_event( `ON_CC_LOADED` )
            )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'ON_CC_LOADED'.
        z2ui5_display_view( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
