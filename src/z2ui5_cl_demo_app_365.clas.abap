CLASS z2ui5_cl_demo_app_365 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_365 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->shell(
          )->page(
              title          = `abap2UI5 - Popup CL_DEMO_OUTPUT`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( )
              )->button(
                  text  = `Open CL_DEMO_OUTPUT Popup...`
                  press = client->_event( `POPUP` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `POPUP` ).

      TYPES: BEGIN OF ty_s_carrier,
               carrid TYPE c LENGTH 3,
               name   TYPE string,
               url    TYPE string,
             END OF ty_s_carrier.
      DATA t_carriers TYPE STANDARD TABLE OF ty_s_carrier WITH EMPTY KEY.
      t_carriers = VALUE #(
          ( carrid = `AA` name = `American Airlines`  url = `http://www.aa.com` )
          ( carrid = `LH` name = `Lufthansa`          url = `http://www.lufthansa.com` )
          ( carrid = `SQ` name = `Singapore Airlines` url = `http://www.singaporeair.com` ) ).

      " CL_DEMO_OUTPUT is a classic ABAP class (not released for ABAP Cloud),
      " so it is instantiated dynamically here to keep the sample portable.
      " The popup itself accepts the output generically (TYPE REF TO object).
      DATA output TYPE REF TO object.
      CALL METHOD ('CL_DEMO_OUTPUT')=>('NEW')
        RECEIVING
          result = output.
      CALL METHOD output->('WRITE_TEXT')
        EXPORTING
          text = `The HTML below is produced by the standard SAP class CL_DEMO_OUTPUT` &&
                 ` and rendered inside an abap2UI5 popup. Use the footer button to`  &&
                 ` toggle between popup and fullscreen.`.
      CALL METHOD output->('WRITE_DATA')
        EXPORTING
          value = t_carriers.

      client->nav_app_call( z2ui5_cl_pop_demo_output=>factory( output ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
