CLASS z2ui5_cl_sample_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS factory
      IMPORTING
        client          TYPE REF TO z2ui5_if_client
      RETURNING
        VALUE(r_result) TYPE REF TO z2ui5_cl_sample_utility.

    METHODS app_get_url_source_code
      RETURNING
        VALUE(result) TYPE string.

    METHODS app_get_url
      IMPORTING
        VALUE(classname) TYPE string OPTIONAL
      RETURNING
        VALUE(result)    TYPE string.

    METHODS url_param_get
      IMPORTING
        !val          TYPE string
      RETURNING
        VALUE(result) TYPE string.

    METHODS url_param_set
      IMPORTING
        !n TYPE clike
        !v TYPE clike.

  PROTECTED SECTION.

    DATA mi_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_sample_utility IMPLEMENTATION.

  METHOD factory.

    CREATE OBJECT r_result.

    r_result->mi_client = client.

  ENDMETHOD.

  METHOD app_get_url.

    result = z2ui5_cl_fw_utility=>app_get_url( mi_client ).

*    IF classname IS NOT SUPPLIED.
*      classname = z2ui5_cl_fw_utility=>rtti_get_classname_by_ref( mi_client->get( )-s_draft-app ).
*    ENDIF.
*
*    DATA(lv_url) = to_lower( mi_client->get( )-s_config-origin && mi_client->get( )-s_config-pathname ) && `?`.
*    DATA(lt_param) = z2ui5_cl_fw_utility=>url_param_get_tab( mi_client->get( )-s_config-search ).
*    DELETE lt_param WHERE n = `app_start`.
*    INSERT VALUE #( n = `app_start` v = to_lower( classname ) ) INTO TABLE lt_param.
*
*    result = lv_url && z2ui5_cl_fw_utility=>url_param_create_url( lt_param ).

  ENDMETHOD.


  METHOD app_get_url_source_code.

    result = z2ui5_cl_fw_utility=>app_get_url_source_code( mi_client ).

*    DATA(ls_draft) = mi_client->get( )-s_draft.
*    DATA(ls_config) = mi_client->get( )-s_config.
*
*    result = ls_config-origin && `/sap/bc/adt/oo/classes/`
*       && z2ui5_cl_fw_utility=>rtti_get_classname_by_ref( ls_draft-app ) && `/source/main`.

  ENDMETHOD.

  METHOD url_param_get.

    result = z2ui5_cl_fw_utility=>url_param_get(
      val = val
      url = mi_client->get( )-s_config-search ).

  ENDMETHOD.


  METHOD url_param_set.

    DATA(result) = z2ui5_cl_fw_utility=>url_param_set(
      url   = mi_client->get( )-s_config-search
      name  = n
      value = v ).

    mi_client->url_param_set( result ).

  ENDMETHOD.


ENDCLASS.
