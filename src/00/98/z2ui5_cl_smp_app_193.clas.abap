CLASS z2ui5_cl_smp_app_193 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.

    DATA mt_kopf TYPE REF TO data.
    DATA mt_pos  TYPE REF TO data.

    DATA mt_kopf_xml  TYPE string.
    DATA mt_pos_xml   TYPE string.

    METHODS xml_parse.
    METHODS xml_stringify.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_193 IMPLEMENTATION.

  METHOD xml_parse.

    IF mt_pos_xml IS NOT INITIAL.

      mt_kopf = z2ui5_cl_smp_context=>xml_srtti_parse( mt_kopf_xml ).
      mt_kopf_xml = VALUE #( ).
    ENDIF.

    IF mt_pos_xml IS NOT INITIAL.

      mt_pos = z2ui5_cl_smp_context=>xml_srtti_parse( mt_pos_xml ).
      mt_pos_xml = VALUE #( ).
    ENDIF.

  ENDMETHOD.


  METHOD xml_stringify.

    ASSIGN mt_kopf->* TO FIELD-SYMBOL(<head>).

    IF sy-subrc = 0.

      mt_kopf_xml = z2ui5_cl_smp_context=>xml_srtti_stringify( <head> ).
      mt_kopf = VALUE #( ).
    ENDIF.

    ASSIGN mt_pos->* TO FIELD-SYMBOL(<pos>).

    IF sy-subrc = 0.

      mt_pos_xml = z2ui5_cl_smp_context=>xml_srtti_stringify( <pos> ).
      mt_pos = VALUE #( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
