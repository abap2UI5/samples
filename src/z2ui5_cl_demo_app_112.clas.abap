class z2ui5_cl_demo_app_112 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CLIENT type ref to Z2UI5_IF_CLIENT .
  data MO_VIEW_PARENT type ref to Z2UI5_CL_XML_VIEW .
  data MV_CLASS_2 type STRING .
  data MV_INIT type ABAP_BOOL .
  data MR_DATA type ref to DATA .

    METHODS bind_clear
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  methods ON_INIT .
  methods ON_EVENT .
  methods DISPLAY_VIEW
    changing
      !XML type ref to Z2UI5_CL_XML_VIEW optional .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_112 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_A_B_C->DISPLAY_VIEW
* +-------------------------------------------------------------------------------------------------+
* | [<-->] XML                            TYPE REF TO Z2UI5_CL_XML_VIEW(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD DISPLAY_VIEW.

    mo_view_parent->input( value = client->_bind_edit( MV_CLASS_2 ) placeholder = `Input From Class 2` ).

  ENDMETHOD.

    METHOD bind_clear.

    client->_bind_clear( `MO_APP_SUB` ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_A_B_C->ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ON_EVENT.

    CASE client->get( )-event.

      WHEN 'MESSAGE_SUB'.
        client->message_box_display( `event sub app` ).

    ENDCASE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_A_B_C->ON_INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ON_INIT.

*    mv_descr = `data sub app`.
    display_view( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_A_B_C->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.
