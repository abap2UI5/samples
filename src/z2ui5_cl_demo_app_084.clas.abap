CLASS Z2UI5_CL_DEMO_APP_084 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

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

    "boolean
    DATA: mv_boolean TYPE abap_bool.

    DATA: mv_messages_count TYPE i.

    TYPES:
      BEGIN OF ty_msg,
        type        TYPE string,
        title       TYPE string,
        subtitle    TYPE string,
        description TYPE string,
        group       TYPE string,
      END OF ty_msg .

    DATA:
      t_msg TYPE STANDARD TABLE OF ty_msg WITH EMPTY KEY .
    DATA check_initialized TYPE abap_bool .

    METHODS Z2UI5_display_view .
    METHODS Z2UI5_display_popup .
    METHODS Z2UI5_display_popover
      IMPORTING
        !id TYPE string .
  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_084 IMPLEMENTATION.


  METHOD Z2UI5_display_popover.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( ).

    popup = popup->popover(
              placement = `Top`
              title = `Messages`
              contentheight = '50%'
              contentwidth = '50%' ).

    popup->message_view(
            items      = client->_bind_edit( t_msg )
            groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    client->popover_display( xml = popup->stringify( ) by_id = id ).

  ENDMETHOD.


  METHOD Z2UI5_display_popup.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( ).

    popup = popup->dialog(
          title = `Messages`
          contentheight = '50%'
          contentwidth = '50%' ).

    popup->message_view(
            items = client->_bind_edit( t_msg )
            groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    popup->footer( )->overflow_toolbar(
      )->toolbar_spacer(
      )->button(
          id    = `test2`
          text  = 'test'
          press = client->_event( `TEST` )
      )->button(
          text  = 'close'
          press = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page( class = `sapUiContentPadding `
            title          = 'abap2UI5 - Input Validation'
            navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
              shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Demo'  target = '_blank'
                    href = `https://twitter.com/abap2UI5/status/1647246029828268032`
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    "string
    page->flex_box( justifycontent = `SpaceAround` )->panel( headertext = `sap.ui.model.type.String`
       )->vbox(
         )->title( text = `CONSTRAINTS` level = `H3`
         )->vbox(
           )->hbox( class = `sapUiTinyMarginTopBottom` alignitems = `Center`
             )->label( text = `maxLength (5)`
             )->input( id = `testINPUT` value = `{path:'` && client->_bind_edit( val = mv_maxlength_string path = abap_true ) && `',type: 'sap.ui.model.type.String', constraints:{ maxLength: 5 } }`
                       editable = abap_true
                       class = `sapUiTinyMarginBeginEnd` )->get_parent(

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


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_display_view( ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'POPUP'.
        Z2UI5_display_popup( ).
      WHEN 'POPOVER'.
        Z2UI5_display_popover( `test` ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
