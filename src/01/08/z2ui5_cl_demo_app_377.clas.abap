CLASS z2ui5_cl_demo_app_377 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA datetime_default TYPE string.
    DATA datetime_state TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_377 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      datetime_default = `2026-07-11T10:30:00`.
      datetime_state   = `2026-07-11T18:00:00`.

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Date Time Picker`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateTimePicker` ).

    DATA(vbox) = page->vbox( `sapUiSmallMargin` ).

    vbox->label( `Default:` ).
    vbox->date_time_picker( client->_bind_edit( datetime_default ) ).

    vbox->label( text  = `With placeholder:`
                 class = `sapUiSmallMarginTop` ).
    vbox->date_time_picker( placeholder = `Enter delivery date and time` ).

    vbox->label( text  = `Value state Warning:`
                 class = `sapUiSmallMarginTop` ).
    vbox->date_time_picker( value      = client->_bind_edit( datetime_state )
                            valuestate = `Warning` ).

    vbox->label( text  = `Disabled:`
                 class = `sapUiSmallMarginTop` ).
    vbox->date_time_picker( value   = client->_bind( datetime_default )
                            enabled = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `CLICK_HINT_ICON` ).
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The date time picker combines a date picker and a time picker in one input. It supports placeholders, value states and a disabled mode.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
