CLASS z2ui5_cl_demo_app_376 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA time_default TYPE string.
    DATA time_short TYPE string.
    DATA time_steps TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_376 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      time_default = `09:15:00`.
      time_short   = `14:30:00`.
      time_steps   = `08:00:00`.

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Time Picker`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TimePicker` ).

    DATA(vbox) = page->vbox( `sapUiSmallMargin` ).

    vbox->label( `Default with seconds:` ).
    vbox->time_picker( value         = client->_bind_edit( time_default )
                       valueformat   = `HH:mm:ss`
                       displayformat = `HH:mm:ss`
                       width         = `12rem`
                       change        = client->_event( `CHANGE` ) ).

    vbox->label( text  = `Display format HH:mm (24 hours):`
                 class = `sapUiSmallMarginTop` ).
    vbox->time_picker( value         = client->_bind_edit( time_short )
                       valueformat   = `HH:mm:ss`
                       displayformat = `HH:mm`
                       width         = `12rem`
                       change        = client->_event( `CHANGE` ) ).

    vbox->label( text  = `Minutes in steps of 15:`
                 class = `sapUiSmallMarginTop` ).
    vbox->time_picker( value         = client->_bind_edit( time_steps )
                       valueformat   = `HH:mm:ss`
                       displayformat = `HH:mm`
                       minutesstep   = `15`
                       width         = `12rem`
                       change        = client->_event( `CHANGE` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CHANGE`.
        client->message_toast_display( |Times: { time_default }, { time_short }, { time_steps }| ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The time picker lets the user select a time via input or clock face. Value format, display format and minute steps are configurable.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
