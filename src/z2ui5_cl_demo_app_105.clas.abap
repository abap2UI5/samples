CLASS z2ui5_cl_demo_app_105 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA client TYPE REF TO z2ui5_if_client .
    DATA mo_view_parent TYPE REF TO z2ui5_cl_xml_view .
    DATA MV_CLASS_1 TYPE string .
    DATA mv_init TYPE abap_bool .
    DATA mr_data TYPE REF TO data .

    METHODS on_init .
    METHODS bind_clear
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS on_event .
    METHODS display_view
      CHANGING
        !xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_105 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_105->BIND_CLEAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bind_clear.

    client->_bind_clear( `MO_APP_SUB` ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_105->DISPLAY_VIEW
* +-------------------------------------------------------------------------------------------------+
* | [<-->] XML                            TYPE REF TO Z2UI5_CL_XML_VIEW(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD display_view.

    mo_view_parent->input( value = client->_bind_edit( MV_CLASS_1 ) placeholder = `Input From Class 1` ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_105->ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'MESSAGE_SUB'.
        client->message_box_display( `event sub app` ).

    ENDCASE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_105->ON_INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_init.

*    mv_descr = `data sub app`.
    display_view( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_105->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.
