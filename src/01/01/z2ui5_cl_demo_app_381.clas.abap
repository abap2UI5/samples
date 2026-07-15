CLASS z2ui5_cl_demo_app_381 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA toast_text TYPE string.
    DATA duration TYPE string.
    DATA width TYPE string.
    DATA my TYPE string.
    DATA at TYPE string.
    DATA offset TYPE string.
    DATA animation_timing TYPE string.
    DATA animation_duration TYPE string.
    DATA autoclose TYPE abap_bool.
    DATA box_title TYPE string.
    DATA box_text TYPE string.
    DATA box_details TYPE string.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS get_positions
      RETURNING
        VALUE(result) TYPE string_table.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_381 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    toast_text         = `This is a message toast.`.
    duration           = `3000`.
    width              = `15em`.
    my                 = `center bottom`.
    at                 = `center bottom`.
    offset             = `0 0`.
    animation_timing   = `ease`.
    animation_duration = `1000`.
    autoclose          = abap_true.

    box_title   = `abap2UI5`.
    box_text    = `This is a message box.`.
    box_details = `These are additional details about the message.`.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `SHOW_TOAST`.
        client->message_toast_display(
            text                    = toast_text
            duration                = duration
            width                   = width
            my                      = my
            at                      = at
            offset                  = offset
            animationtimingfunction = animation_timing
            animationduration       = animation_duration
            autoclose               = autoclose ).
      WHEN `CUSTOM`.
        client->message_box_display(
            text             = box_text
            title            = box_title
            type             = `information`
            details          = box_details
            actions          = VALUE #( ( `Approve` ) ( `Reject` ) )
            emphasizedaction = `Approve` ).
      WHEN `confirm` OR `information` OR `success` OR `warning` OR `error`.
        client->message_box_display(
            text    = box_text
            title   = box_title
            type    = client->get( )-event
            details = box_details ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Messages`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(header) = page->header_content( ).
    header->link(
        text   = `UI5 Demo Kit - MessageToast`
        target = `_blank`
        href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageToast/sample/sap.m.sample.MessageToast` ).
    header->link(
        text   = `UI5 Demo Kit - MessageBox`
        target = `_blank`
        href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBox` ).

    DATA(toast_form) = page->panel( headertext = `Message Toast`
                                )->simple_form(
                                    title    = `Settings`
                                    editable = abap_true
                                    )->content( `form` ).

    toast_form->label( `Text`
        )->input( client->_bind_edit( toast_text )
        )->label( `Duration (ms)`
        )->input(
            value = client->_bind_edit( duration )
            type  = `Number`
        )->label( `Width`
        )->input( client->_bind_edit( width ) ).

    DATA(select_my) = toast_form->label( `my`
                          )->select( selectedkey = client->_bind_edit( my ) ).
    DATA(select_at) = toast_form->label( `at`
                          )->select( selectedkey = client->_bind_edit( at ) ).

    LOOP AT get_positions( ) INTO DATA(position).
      select_my->item(
          key  = position
          text = position ).
      select_at->item(
          key  = position
          text = position ).
    ENDLOOP.

    toast_form->label( `offset` ).
    toast_form->input( client->_bind_edit( offset ) ).

    DATA(select_animation) = toast_form->label( `animationTimingFunction`
                                 )->select( selectedkey = client->_bind_edit( animation_timing ) ).
    select_animation->item( key = `ease`        text = `ease`
                 )->item( key = `linear`        text = `linear`
                 )->item( key = `ease-in`       text = `ease-in`
                 )->item( key = `ease-out`      text = `ease-out`
                 )->item( key = `ease-in-out`   text = `ease-in-out` ).

    toast_form->label( `animationDuration (ms)`
        )->input(
            value = client->_bind_edit( animation_duration )
            type  = `Number`
        )->label( `autoClose`
        )->checkbox( client->_bind_edit( autoclose ) ).

    toast_form->button(
        text  = `Show Message Toast`
        type  = `Emphasized`
        press = client->_event( `SHOW_TOAST` ) ).

    DATA(box_form) = page->panel( headertext = `Message Box`
                              )->simple_form(
                                  title    = `Settings`
                                  editable = abap_true
                                  )->content( `form` ).

    box_form->label( `Title`
        )->input( client->_bind_edit( box_title )
        )->label( `Message`
        )->input( client->_bind_edit( box_text )
        )->label( `Details`
        )->text_area(
            value = client->_bind_edit( box_details )
            rows  = `3` ).

    box_form->hbox( class = `sapUiSmallMarginTop`
        )->button(
            text  = `Confirm`
            press = client->_event( `confirm` )
        )->button(
            text  = `Information`
            press = client->_event( `information` )
        )->button(
            text  = `Success`
            type  = `Success`
            press = client->_event( `success` )
        )->button(
            text  = `Warning`
            press = client->_event( `warning` )
        )->button(
            text  = `Error`
            type  = `Reject`
            press = client->_event( `error` )
        )->button(
            text  = `Custom`
            type  = `Emphasized`
            press = client->_event( `CUSTOM` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_positions.

    result = VALUE #(
      ( `begin top` )
      ( `begin center` )
      ( `begin bottom` )
      ( `left top` )
      ( `left center` )
      ( `left bottom` )
      ( `center top` )
      ( `center center` )
      ( `center bottom` )
      ( `right top` )
      ( `right center` )
      ( `right bottom` )
      ( `end top` )
      ( `end center` )
      ( `end bottom` ) ).

  ENDMETHOD.

ENDCLASS.
