CLASS z2ui5_cl_demo_app_316 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

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
    METHODS view_display
      IMPORTING client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_316 IMPLEMENTATION.

  METHOD view_display.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA layout TYPE REF TO z2ui5_cl_xml_view.
    DATA email_form TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    DATA telephone_form TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    DATA temp4 LIKE LINE OF temp3.
    DATA mobile_form TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE string_table.
    DATA temp6 LIKE LINE OF temp5.
    DATA url_form TYPE REF TO z2ui5_cl_xml_view.
    DATA temp7 TYPE string_table.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE string_table.

    CLEAR url.
    url-url = `http://www.sap.com`.
    url-new_window = `true`.
    CLEAR email.
    email-email = `email@email.com`.
    email-subject = `subject`.
    email-body = `body`.
    email-new_window = `true`.

    
    page = z2ui5_cl_xml_view=>factory(
        )->shell(
            )->page( title          = `abap2UI5 - Browser - Open Telephone, Email etc.`
                     navbuttonpress = client->_event_nav_app_leave( )
                     shownavbutton  = client->check_app_prev_stack( )
                      ).

    page->message_strip(
        text     = `The URL helper triggers native browser actions from ABAP: open e-mail, telephone and SMS links, or ` &&
                   `redirect the browser to a URL.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    layout = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    
    email_form = layout->simple_form( `Trigger E-Mail` ).

    email_form->label( text     = `E-Mail`
                       labelfor = `inputEmail` ).
    email_form->input( id          = `inputEmail`
                       value       = client->_bind( email-email )
                       type        = `Email`
                       placeholder = `Enter email`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->input( id          = `inputCcEmail`
                       value       = client->_bind( email-cc )
                       type        = `Email`
                       placeholder = `Enter cc email`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->input( id          = `inputBccEmail`
                       value       = client->_bind( email-bcc )
                       type        = `Email`
                       placeholder = `Enter bcc email`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->label( text     = `Subject`
                       labelfor = `inputText` ).
    email_form->input( id          = `inputText`
                       value       = client->_bind( email-subject )
                       placeholder = `Enter text`
                       class       = `sapUiSmallMarginBottom` ).

    email_form->label( `Mail Body`
         )->text_area( valueliveupdate = abap_true
                       value           = client->_bind( email-body )
                       growing         = abap_true
                       growingmaxlines = `7`
                       width           = `100%` ).

    
    CLEAR temp1.
    INSERT `TRIGGER_EMAIL` INTO TABLE temp1.
    
    temp2 = |${ client->_bind( email ) }|.
    INSERT temp2 INTO TABLE temp1.
    email_form->button( text  = `Trigger Email`
                        press = client->_event_client( val   = client->cs_event-urlhelper
                        t_arg = temp1 ) ).

    
    telephone_form = layout->simple_form( `Trigger Telephone` ).

    telephone_form->label( text     = `Telephone`
                           labelfor = `inputTel` ).
    telephone_form->input( id          = `inputTel`
                           value       = client->_bind( phone )
                           type        = `Tel`
                           placeholder = `Enter telephone number`
                           class       = `sapUiSmallMarginBottom` ).
    
    CLEAR temp3.
    INSERT `TRIGGER_TEL` INTO TABLE temp3.
    
    temp4 = |${ client->_bind( phone ) }|.
    INSERT temp4 INTO TABLE temp3.
    telephone_form->button(
        text  = `Trigger Telephone`
        press = client->_event_client( val   = client->cs_event-urlhelper
        t_arg = temp3 ) ).

    
    mobile_form = layout->simple_form( `Trigger SMS` ).

    mobile_form->label( text     = `Number`
                        labelfor = `inputNumber` ).
    mobile_form->input( id          = `inputNumber`
                        value       = client->_bind( mobile )
                        type        = `Number`
                        placeholder = `Enter a number`
                        class       = `sapUiSmallMarginBottom` ).
    
    CLEAR temp5.
    INSERT `TRIGGER_SMS` INTO TABLE temp5.
    
    temp6 = |${ client->_bind( mobile ) }|.
    INSERT temp6 INTO TABLE temp5.
    mobile_form->button( text  = `Trigger SMS`
                         press = client->_event_client( val   = client->cs_event-urlhelper
                         t_arg = temp5 ) ).

    
    url_form = layout->simple_form( `Redirect` ).
    url_form->label( text     = `URL`
                     labelfor = `inputUrl` ).
    url_form->input( id          = `inputUrl`
                     value       = client->_bind( url-url )
                     type        = `Url`
                     placeholder = `Enter URL`
                     class       = `sapUiSmallMarginBottom` ).
    
    CLEAR temp7.
    INSERT `REDIRECT` INTO TABLE temp7.
    
    temp8 = |${ client->_bind( url ) }|.
    INSERT temp8 INTO TABLE temp7.
    url_form->button( text  = `Redirect`
                      press = client->_event_client( val   = client->cs_event-urlhelper
                      t_arg = temp7 ) ).

    client->view_display( page->stringify( ) ).

    
    CLEAR temp9.
    INSERT `URL Helper Sample` INTO TABLE temp9.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_title
        t_arg = temp9 ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
