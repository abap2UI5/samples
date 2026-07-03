CLASS z2ui5_cl_demo_app_365 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS nav_to_output
      IMPORTING
        as_page TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_365 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_navigated( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->shell(
          )->page(
              title          = `abap2UI5 - CL_DEMO_OUTPUT`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( )
              )->button(
                  text  = `Open in Popup`
                  press = client->_event( `POPUP` )
              )->button(
                  text  = `Open as Fullscreen App`
                  press = client->_event( `FULLSCREEN` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `POPUP` ).
      nav_to_output( abap_false ).

    ELSEIF client->check_on_event( `FULLSCREEN` ).
      nav_to_output( abap_true ).

    ENDIF.

  ENDMETHOD.


  METHOD nav_to_output.

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

    DATA(xml) = `<?xml version="1.0" encoding="UTF-8"?>` &&
                `<flightplan>` &&
                `<flight carrid="LH" connid="0400" cityfrom="FRANKFURT" cityto="NEW YORK"/>` &&
                `<flight carrid="AA" connid="0017" cityfrom="NEW YORK" cityto="SAN FRANCISCO"/>` &&
                `</flightplan>`.

    " CL_DEMO_OUTPUT is a classic ABAP class (not released for ABAP Cloud),
    " so it is instantiated dynamically here to keep the sample portable.
    " The popup itself accepts the output generically (TYPE REF TO object).
    DATA output TYPE REF TO object.

    DATA(classname) = `CL_DEMO_OUTPUT`.
    CALL METHOD (classname)=>(`NEW`)
      RECEIVING
        output = output.
    CALL METHOD output->(`WRITE_TEXT`)
      EXPORTING
        text = `The HTML below is produced by the standard SAP class CL_DEMO_OUTPUT` &&
               ` and rendered inside abap2UI5 - either as a popup or as a fullscreen` &&
               ` app with a back button. It contains text, table data and XML.`.
    CALL METHOD output->(`WRITE_DATA`)
      EXPORTING
        value = t_carriers.
    CALL METHOD output->(`WRITE_XML`)
      EXPORTING
        xml = xml.

    client->nav_app_call( z2ui5_cl_pop_demo_output=>factory(
        i_output  = output
        i_as_page = as_page ) ).

  ENDMETHOD.

ENDCLASS.
