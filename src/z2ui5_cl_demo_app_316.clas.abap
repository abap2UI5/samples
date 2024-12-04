CLASS z2ui5_cl_demo_app_316 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

    DATA check_initialized TYPE abap_bool.

    DATA phone  TYPE string.
    DATA mobile TYPE string.

    DATA: BEGIN OF email,
            email      TYPE string,
            subject    TYPE string,
            body       TYPE string,
            cc         TYPE string,
            bcc        TYPE string,
            new_window TYPE string,
          END OF email.

    DATA: BEGIN OF url,
            url        TYPE string,
            new_window TYPE string,
          END OF url.

  PROTECTED SECTION.
    METHODS display_view
      IMPORTING !client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING !client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_316 IMPLEMENTATION.
  METHOD display_view.
    url = VALUE #( url        = `http://www.sap.com`
                   new_window = `true` ).
    email = VALUE #( email      = `email@email.com`
                     subject    = `subject`
                     body       = `body`
                     new_window = `true` ).

    DATA(page) = z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->title( `URL Helper Sample`
        )->shell(
            )->page( title          = 'abap2UI5 - Sample: URL Helper'
                     navbuttonpress = client->_event( 'BACK' )
                     shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    DATA(email_form) = layout->simple_form( title = `Trigger E-Mail` ).

    email_form->label( text     = `E-Mail`
                       labelfor = `inputEmail` ).
    email_form->input( id          = `inputEmail`
                       value       = client->_bind_edit( email-email )
                       type        = `Email`
                       placeholder = `Enter email`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->input( id          = `inputCcEmail`
                       value       = client->_bind_edit( email-cc )
                       type        = `Email`
                       placeholder = `Enter cc email`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->input( id          = `inputBccEmail`
                       value       = client->_bind_edit( email-bcc )
                       type        = `Email`
                       placeholder = `Enter bcc email`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->label( text     = `Subject`
                       labelfor = `inputText` ).
    email_form->input( id          = `inputText`
                       value       = client->_bind_edit( email-subject )
                       placeholder = `Enter text`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->label( `Mail Body`
         )->text_area( valueliveupdate = abap_true
                       value           = client->_bind_edit( email-body )
                       growing         = abap_true
                       growingmaxlines = '7'
                       width           = '100%' ).

    email_form->button( text  = `Trigger Email`
                        press = client->_event_client( val   = client->cs_event-urlhelper
                                                       t_arg = VALUE #( ( `TRIGGER_EMAIL` )
                                                                        ( |${  client->_bind_edit( email ) }| ) ) ) ).

    DATA(telephone_form) = layout->simple_form( title = `Trigger Telephone` ).

    telephone_form->label( text     = `Telephone`
                           labelfor = `inputTel` ).
    telephone_form->input( id          = `inputTel`
                           value       = client->_bind_edit( phone )
                           type        = `Tel`
                           placeholder = `Enter telephone number`
                           class       = `sapUiSmallMarginBottom` ).
    telephone_form->button(
        text  = `Trigger Telephone`
        press = client->_event_client( val   = client->cs_event-urlhelper
                                       t_arg = VALUE #( ( `TRIGGER_TEL` )
                                                        ( |${ client->_bind_edit( phone ) }| ) ) ) ).

    DATA(mobile_form) = layout->simple_form( title = `Trigger SMS` ).

    mobile_form->label( text     = `Number`
                        labelfor = `inputNumber` ).
    mobile_form->input( id          = `inputNumber`
                        value       = client->_bind_edit( mobile )
                        type        = `Number`
                        placeholder = `Enter a number`
                        class       = `sapUiSmallMarginBottom` ).
    mobile_form->button( text  = `Trigger SMS`
                         press = client->_event_client( val   = client->cs_event-urlhelper
                                                        t_arg = VALUE #( ( `TRIGGER_SMS` )
                                                                         ( |${ client->_bind_edit( mobile ) }| ) ) )  ).

    DATA(url_form) = layout->simple_form( title = `Redirect` ).
    url_form->label( text     = `URL`
                     labelfor = `inputUrl` ).
    url_form->input( id          = `inputUrl`
                     value       = client->_bind_edit( url-url )
                     type        = `Url`
                     placeholder = `Enter URL`
                     class       = `sapUiSmallMarginBottom` ).
    url_form->button( text  = `Redirect`
                      press = client->_event_client( val   = client->cs_event-urlhelper
                                                     t_arg = VALUE #( ( `REDIRECT` )
                                                                      ( |${ client->_bind_edit( url ) }| ) ) ) ).

    client->view_display( page->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).
  ENDMETHOD.
ENDCLASS.
