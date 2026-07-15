CLASS z2ui5_cl_demo_app_381 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA message TYPE string.
    DATA duration TYPE string.
    DATA width TYPE string.
    DATA my TYPE string.
    DATA at TYPE string.
    DATA offset TYPE string.
    DATA animation_timing TYPE string.
    DATA animation_duration TYPE string.
    DATA autoclose TYPE abap_bool.

  PROTECTED SECTION.


    METHODS on_init.
    METHODS show_toast.
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
    ELSEIF client->check_on_event( `SHOW` ).
      show_toast( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    message            = `This is a message toast.`.
    duration           = `3000`.
    width              = `15em`.
    my                 = `center bottom`.
    at                 = `center bottom`.
    offset             = `0 0`.
    animation_timing   = `ease`.
    animation_duration = `1000`.
    autoclose          = abap_true.

  ENDMETHOD.


  METHOD show_toast.

    client->message_toast_display(
        text                    = message
        duration                = duration
        width                   = width
        my                      = my
        at                      = at
        offset                  = offset
        animationtimingfunction = animation_timing
        animationduration       = animation_duration
        autoclose               = autoclose ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Message Toast`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageToast/sample/sap.m.sample.MessageToast` ).

    DATA(form) = page->panel( headertext = `Message Toast Configuration`
                          )->simple_form(
                              title    = `Settings`
                              editable = abap_true
                              )->content( `form` ).

    form->label( `Message`
        )->input( client->_bind_edit( message )
        )->label( `Duration (ms)`
        )->input(
            value = client->_bind_edit( duration )
            type  = `Number`
        )->label( `Width`
        )->input( client->_bind_edit( width ) ).

    DATA(select_my) = form->label( `my`
                          )->select( selectedkey = client->_bind_edit( my ) ).
    DATA(select_at) = form->label( `at`
                          )->select( selectedkey = client->_bind_edit( at ) ).

    LOOP AT get_positions( ) INTO DATA(position).
      select_my->item(
          key  = position
          text = position ).
      select_at->item(
          key  = position
          text = position ).
    ENDLOOP.

    form->label( `offset` ).
    form->input( client->_bind_edit( offset ) ).

    DATA(select_animation) = form->label( `animationTimingFunction`
                                 )->select( selectedkey = client->_bind_edit( animation_timing ) ).
    select_animation->item( key = `ease`        text = `ease`
                 )->item( key = `linear`        text = `linear`
                 )->item( key = `ease-in`       text = `ease-in`
                 )->item( key = `ease-out`      text = `ease-out`
                 )->item( key = `ease-in-out`   text = `ease-in-out` ).

    form->label( `animationDuration (ms)`
        )->input(
            value = client->_bind_edit( animation_duration )
            type  = `Number`
        )->label( `autoClose`
        )->checkbox( client->_bind_edit( autoclose ) ).

    form->button(
        text  = `Show Message Toast`
        type  = `Emphasized`
        press = client->_event( `SHOW` ) ).

    page->footer(
        )->overflow_toolbar(
            )->button(
                text  = `Back`
                icon  = `sap-icon://nav-back`
                press = client->_event_nav_app_leave( ) ).

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
