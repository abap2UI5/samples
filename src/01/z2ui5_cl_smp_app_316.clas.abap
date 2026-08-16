" @keywords mailto tel sms urlhelper redirect native link
" @summary Opens mailto:, tel: and sms: links through URLHelper, so the device answers with its own mail or phone app instead of the browser.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/url_handling
CLASS z2ui5_cl_smp_app_316 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_316 IMPLEMENTATION.

  METHOD view_display.

    url        = VALUE #( url        = `http://www.sap.com`
    new_window = `true` ).
    email      = VALUE #( email      = `email@email.com`
    subject    = `subject`
    body       = `body`
    new_window = `true` ).

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Browser - Open Mail, Phone and SMS Links`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The URL helper triggers native browser actions from ABAP: open e-mail, telephone and SMS links, or ` &&
                   `redirect the browser to a URL.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(layout) = page->ele( n = `VerticalLayout` ns = `layout`
        )->a( n = `class` v = `sapUiContentPadding`
        )->a( n = `width` v = `100%` ).

    DATA(email_form) = layout->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title` v = `Trigger E-Mail` ).

    email_form->tag( `Label`
        )->a( n = `text`     v = `E-Mail`
        )->a( n = `labelFor` v = `inputEmail` ).
    email_form->tag( `Input`
        )->a( n = `id`          v = `inputEmail`
        )->a( n = `placeholder` v = `Enter email`
        )->a( n = `type`        v = `Email`
        )->a( n = `value`       v = client->_bind( email-email )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).

    email_form->tag( `Input`
        )->a( n = `id`          v = `inputCcEmail`
        )->a( n = `placeholder` v = `Enter cc email`
        )->a( n = `type`        v = `Email`
        )->a( n = `value`       v = client->_bind( email-cc )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).

    email_form->tag( `Input`
        )->a( n = `id`          v = `inputBccEmail`
        )->a( n = `placeholder` v = `Enter bcc email`
        )->a( n = `type`        v = `Email`
        )->a( n = `value`       v = client->_bind( email-bcc )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).

    email_form->tag( `Label`
        )->a( n = `text`     v = `Subject`
        )->a( n = `labelFor` v = `inputText` ).
    email_form->tag( `Input`
        )->a( n = `id`          v = `inputText`
        )->a( n = `placeholder` v = `Enter text`
        )->a( n = `value`       v = client->_bind( email-subject )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).

    email_form->tag( `Label`
        )->a( n = `text` v = `Mail Body`
        )->tag( `TextArea`
            )->a( n = `value`           v = client->_bind( email-body )
            )->a( n = `width`           v = `100%`
            )->a( n = `valueLiveUpdate` b = abap_true
            )->a( n = `growing`         b = abap_true
            )->a( n = `growingMaxLines` v = `7` ).

    email_form->tag( `Button`
        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                        t_arg = VALUE #( ( `TRIGGER_EMAIL` )
                                                                        ( |${ client->_bind( email ) }| ) ) )
        )->a( n = `text`  v = `Trigger Email` ).

    DATA(telephone_form) = layout->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title` v = `Trigger Telephone` ).

    telephone_form->tag( `Label`
        )->a( n = `text`     v = `Telephone`
        )->a( n = `labelFor` v = `inputTel` ).
    telephone_form->tag( `Input`
        )->a( n = `id`          v = `inputTel`
        )->a( n = `placeholder` v = `Enter telephone number`
        )->a( n = `type`        v = `Tel`
        )->a( n = `value`       v = client->_bind( phone )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).
    telephone_form->tag( `Button`
        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
        t_arg = VALUE #( ( `TRIGGER_TEL` )
                                                        ( |${ client->_bind( phone ) }| ) ) )
        )->a( n = `text`  v = `Trigger Telephone` ).

    DATA(mobile_form) = layout->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title` v = `Trigger SMS` ).

    mobile_form->tag( `Label`
        )->a( n = `text`     v = `Number`
        )->a( n = `labelFor` v = `inputNumber` ).
    mobile_form->tag( `Input`
        )->a( n = `id`          v = `inputNumber`
        )->a( n = `placeholder` v = `Enter a number`
        )->a( n = `type`        v = `Number`
        )->a( n = `value`       v = client->_bind( mobile )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).
    mobile_form->tag( `Button`
        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                         t_arg = VALUE #( ( `TRIGGER_SMS` ) ( |${ client->_bind( mobile ) }| ) ) )
        )->a( n = `text`  v = `Trigger SMS` ).

    DATA(url_form) = layout->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title` v = `Redirect` ).
    url_form->tag( `Label`
        )->a( n = `text`     v = `URL`
        )->a( n = `labelFor` v = `inputUrl` ).
    url_form->tag( `Input`
        )->a( n = `id`          v = `inputUrl`
        )->a( n = `placeholder` v = `Enter URL`
        )->a( n = `type`        v = `Url`
        )->a( n = `value`       v = client->_bind( url-url )
        )->a( n = `class`       v = `sapUiSmallMarginBottom` ).
    url_form->tag( `Button`
        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                      t_arg = VALUE #( ( `REDIRECT` ) ( |${ client->_bind( url ) }| ) ) )
        )->a( n = `text`  v = `Redirect` ).

    client->view_display( page->stringify( ) ).

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_title
        t_arg = VALUE #( ( `URL Helper Sample` ) ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ELSEIF client->check_on_navigated( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
