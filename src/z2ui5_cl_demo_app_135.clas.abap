CLASS z2ui5_cl_demo_app_135 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

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


    "boolean
    DATA: mv_boolean TYPE abap_bool.
    DATA mt_messaging TYPE z2ui5_cl_cc_messaging=>ty_t_items.

    DATA: mv_messages_count TYPE i.


    DATA check_initialized TYPE abap_bool .

    METHODS z2ui5_display_view .
    METHODS z2ui5_display_popover
      IMPORTING
        !id TYPE string .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_135 IMPLEMENTATION.


  METHOD z2ui5_display_popover.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    popup = popup->message_popover(
              placement = `Top`
               items      = client->_bind_edit( mt_messaging )
               groupitems = abap_true
               afterclose = client->_event( `POPOVER_CLOSE` )
        )->message_item(
            type        = `{TYPE}`
            title       = `{MESSAGE}`
            subtitle    = `{MESSAGE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    client->popover_display( xml = popup->stringify( ) by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->_z2ui5( )->messaging( client->_bind_edit( mt_messaging )
        )->shell(
        )->page( class = `sapUiContentPadding `
            title          = 'abap2UI5 - Messaging'
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
                       class = `sapUiTinyMarginBeginEnd` ).

    page->footer( )->overflow_toolbar(
         )->button(
             id = 'test'
*             text  = 'Messages'
             icon  = 'sap-icon://message-popup'
             press = client->_event( 'POPOVER' )
             type  = 'Default'
*             class = `sapUiSizeCozy`
             )->get( )->custom_data(
              )->badge_custom_data(
                                    value = '{= ${' && client->_bind_edit( val = mt_messaging path = abap_true ) && '}.length}'
*                                    value = client->_bind_edit( mv_messages_count )
                                    visible = abap_true
                                    key = 'badge' )->get_parent( )->get_parent(
         )->toolbar_spacer(
         )->button(
             text  = 'REMOVE_MSG'
             press = client->_event( 'REMOVE_MSG' )
             type  = 'Success'
         )->button(
             text  = 'ADD_MSG'
             press = client->_event( 'ADD_MSG' )
             type  = 'Success'
         )->button(
             text  = 'Send to Server'
             press = client->_event( 'BUTTON_SEND' )
             type  = 'Success' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display(
        view->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_messaging=>get_js( )
            )->_z2ui5( )->timer( client->_event( `ON_CC_LOADED` )
            )->stringify( ) ).
      RETURN.

    ENDIF.

    CASE client->get( )-event.

      WHEN `ON_CC_LOADED`.
        z2ui5_display_view( ).

      WHEN `REMOVE_MSG`.
        CLEAR mt_messaging.
        z2ui5_display_view( ).
        client->view_model_update( ).

      WHEN `ADD_MSG`.
        INSERT VALUE #(
            message  = `this is a message`
            type = `Error`
            target = `testINPUT/value`
         ) INTO TABLE mt_messaging.
        client->view_model_update( ).

      WHEN 'POPOVER_CLOSE'.
        client->message_toast_display( `POPOVER_CLOSE` ).

      WHEN 'BUTTON_SEND'.
        DATA(lv_string) = `mt_messaging is filled with data`.

      WHEN 'POPOVER'.
        z2ui5_display_popover( `test` ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
