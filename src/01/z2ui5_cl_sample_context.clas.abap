CLASS z2ui5_cl_sample_context DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    " Environment-abstracted character/format constants. Callers must read
    " these from z2ui5_cl_sample_context instead of referencing cl_abap_char_utilities /
    " cl_abap_format directly, so the dependency on those SAP standard classes
    " lives in exactly one place (this class' class_constructor) and can be
    " ported once for non-ABAP runtimes (e.g. transpiled JS).
    CLASS-DATA cv_char_util_newline        TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_char_util_cr_lf          TYPE c LENGTH 2 READ-ONLY.

    CLASS-DATA cv_char_util_horizontal_tab TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_char_util_charsize       TYPE i          READ-ONLY.

    CLASS-DATA cv_format_e_xml_attr             TYPE i          READ-ONLY.

    " RTTI type-kind / kind / visibility constants, so callers can branch on
    " stored type_kind/kind fields without referencing cl_abap_typedescr /
    " cl_abap_objectdescr directly.
    CLASS-DATA cv_typedescr_typekind_table   TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_typedescr_typekind_dref    TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_typedescr_typekind_oref    TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_typedescr_typekind_struct1 TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_typedescr_typekind_struct2 TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_typedescr_kind_struct      TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_typedescr_kind_ref         TYPE c LENGTH 1 READ-ONLY.

    CLASS-DATA cv_objectdescr_public         TYPE c LENGTH 1 READ-ONLY.

    CLASS-METHODS class_constructor.

    TYPES:
      BEGIN OF ty_s_name_value,
        n TYPE string,
        v TYPE string,
      END OF ty_s_name_value.

    TYPES ty_t_name_value TYPE STANDARD TABLE OF ty_s_name_value WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ty_s_token.

    TYPES ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_range,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE string,
        high   TYPE string,
      END OF ty_s_range.

    TYPES ty_t_range TYPE STANDARD TABLE OF ty_s_range WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_filter_multi,
        name            TYPE string,
        t_range         TYPE ty_t_range,
        t_token         TYPE ty_t_token,
        t_token_added   TYPE ty_t_token,
        t_token_removed TYPE ty_t_token,
      END OF ty_s_filter_multi.

    TYPES ty_t_filter_multi TYPE STANDARD TABLE OF ty_s_filter_multi WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_msg,
        text       TYPE string,
        id         TYPE string,
        no         TYPE string,
        type       TYPE string,
        v1         TYPE string,
        v2         TYPE string,
        v3         TYPE string,
        v4         TYPE string,
        timestampl TYPE timestampl,
        t_meta     TYPE ty_t_name_value,
      END OF ty_s_msg,
      ty_t_msg TYPE STANDARD TABLE OF ty_s_msg WITH DEFAULT KEY.

    CLASS-METHODS msg_get_t
      IMPORTING
        VALUE(val)    TYPE any
        VALUE(val2)   TYPE any OPTIONAL
      RETURNING
        VALUE(result) TYPE ty_t_msg.

    CLASS-METHODS msg_get
      IMPORTING
        VALUE(val)    TYPE any
        VALUE(val2)   TYPE any OPTIONAL
      RETURNING
        VALUE(result) TYPE ty_s_msg.

    CLASS-METHODS msg_get_by_msg
      IMPORTING
        id            TYPE any
        no            TYPE any
        v1            TYPE any OPTIONAL
        v2            TYPE any OPTIONAL
        v3            TYPE any OPTIONAL
        v4            TYPE any OPTIONAL
      RETURNING
        VALUE(result) TYPE ty_s_msg.

    CLASS-METHODS rtti_get_t_attri_by_include
      IMPORTING
        !type         TYPE REF TO cl_abap_datadescr
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    CLASS-METHODS itab_get_itab_by_csv
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE REF TO data.

    CLASS-METHODS itab_get_csv_by_itab
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS filter_itab
      IMPORTING
        filter TYPE ty_t_filter_multi
      CHANGING
        val     TYPE STANDARD TABLE.

    CLASS-METHODS filter_get_multi_by_data
      IMPORTING
        val           TYPE data
      RETURNING
        VALUE(result) TYPE ty_t_filter_multi.

    CLASS-METHODS url_param_get
      IMPORTING
        val           TYPE string
        url           TYPE string
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS xml_parse
      IMPORTING
        !xml TYPE clike
      EXPORTING
        !any TYPE any.

    CLASS-METHODS xml_stringify
      IMPORTING
        !any          TYPE any
      RETURNING
        VALUE(result) TYPE string
      RAISING
        cx_xslt_serialization_error.

    CLASS-METHODS boolean_check_by_data
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE abap_bool.

    CLASS-METHODS boolean_abap_2_json
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS json_parse
      IMPORTING
        val   TYPE any
      CHANGING
        !data TYPE any.

    CLASS-METHODS c_trim_upper
      IMPORTING
        val           TYPE clike
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS xml_srtti_stringify
      IMPORTING
        !data         TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS xml_srtti_parse
      IMPORTING
        rtti_data     TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO data.

    CLASS-METHODS time_get_timestampl
      RETURNING
        VALUE(result) TYPE timestampl.

    CLASS-METHODS c_trim
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS c_trim_lower
      IMPORTING
        val           TYPE clike
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS url_param_get_tab
      IMPORTING
        i_val            TYPE clike
      RETURNING
        VALUE(rt_params) TYPE ty_t_name_value.

    CLASS-METHODS rtti_get_t_attri_by_any
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE cl_abap_structdescr=>component_table.

    CLASS-METHODS rtti_get_t_attri_by_table_name
      IMPORTING
        table_name    TYPE any
      RETURNING
        VALUE(result) TYPE cl_abap_structdescr=>component_table.

    CLASS-METHODS rtti_check_class_exists
      IMPORTING
        val           TYPE clike
      RETURNING
        VALUE(result) TYPE abap_bool.

    CLASS-METHODS boolean_check_by_name
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE abap_bool.

    CLASS-METHODS filter_get_range_t_by_token_t
      IMPORTING
        val           TYPE ty_t_token
      RETURNING
        VALUE(result) TYPE ty_t_range.

    CLASS-METHODS filter_get_range_by_token
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_s_range.

    CLASS-METHODS filter_get_token_t_by_range_t
      IMPORTING
        val           TYPE ANY TABLE
      RETURNING
        VALUE(result) TYPE ty_t_token ##NEEDED.

    CLASS-METHODS filter_get_token_range_mapping
      RETURNING
        VALUE(result) TYPE ty_t_name_value.

    CLASS-METHODS itab_corresponding
      IMPORTING
        val  TYPE STANDARD TABLE
      CHANGING
        !tab TYPE STANDARD TABLE.

    CLASS-METHODS itab_filter_by_val
      IMPORTING
        val         TYPE clike
        fields      TYPE string_table OPTIONAL
        ignore_case TYPE abap_bool DEFAULT abap_false
      CHANGING
        !tab        TYPE STANDARD TABLE.

    CLASS-METHODS uuid_get_c32
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS conv_decode_x_base64
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE xstring.

    CLASS-METHODS conv_encode_x_base64
      IMPORTING
        val           TYPE xstring
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS conv_get_string_by_xstring
      IMPORTING
        val           TYPE xstring
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS conv_get_xstring_by_string
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE xstring.

    TYPES:
      BEGIN OF ty_s_dfies,
        tabname     TYPE c LENGTH 30,
        fieldname   TYPE c LENGTH 30,
        langu       TYPE string,
        position    TYPE n LENGTH 4,
        offset      TYPE n LENGTH 6,
        domname     TYPE c LENGTH 30,
        rollname    TYPE c LENGTH 30,
        checktable  TYPE c LENGTH 30,
        leng        TYPE n LENGTH 6,
        intlen      TYPE n LENGTH 6,
        outputlen   TYPE n LENGTH 6,
        decimals    TYPE n LENGTH 6,
        datatype    TYPE c LENGTH 4,
        inttype     TYPE c LENGTH 1,
        reftable    TYPE c LENGTH 30,
        reffield    TYPE c LENGTH 30,
        precfield   TYPE c LENGTH 30,
        authorid    TYPE c LENGTH 3,
        memoryid    TYPE c LENGTH 20,
        logflag     TYPE c LENGTH 1,
        mask        TYPE c LENGTH 20,
        masklen     TYPE n LENGTH 4,
        convexit    TYPE c LENGTH 5,
        headlen     TYPE n LENGTH 2,
        scrlen1     TYPE n LENGTH 2,
        scrlen2     TYPE n LENGTH 2,
        scrlen3     TYPE n LENGTH 2,
        fieldtext   TYPE c LENGTH 60,
        reptext     TYPE c LENGTH 55,
        scrtext_s   TYPE c LENGTH 10,
        scrtext_m   TYPE c LENGTH 20,
        scrtext_l   TYPE c LENGTH 40,
        keyflag     TYPE c LENGTH 1,
        lowercase   TYPE c LENGTH 1,
        mac         TYPE c LENGTH 1,
        genkey      TYPE c LENGTH 1,
        noforkey    TYPE c LENGTH 1,
        valexi      TYPE c LENGTH 1,
        noauthch    TYPE c LENGTH 1,
        sign        TYPE c LENGTH 1,
        dynpfld     TYPE c LENGTH 1,
        f4availabl  TYPE c LENGTH 1,
        comptype    TYPE c LENGTH 1,
        lfieldname  TYPE c LENGTH 132,
        ltrflddis   TYPE c LENGTH 1,
        bidictrlc   TYPE c LENGTH 1,
        outputstyle TYPE n LENGTH 2,
        nohistory   TYPE c LENGTH 1,
        ampmformat  TYPE c LENGTH 1,
      END OF ty_s_dfies,
      ty_t_dfies TYPE STANDARD TABLE OF ty_s_dfies WITH DEFAULT KEY.

    CLASS-METHODS rtti_get_t_dfies_by_table_name
      IMPORTING
        table_name    TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_dfies.



    CLASS-METHODS context_check_abap_cloud
      RETURNING
        VALUE(result) TYPE abap_bool.


    CLASS-METHODS rtti_get_type_kind
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS rtti_get_t_attri_by_oref
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE abap_attrdescr_tab.

    CLASS-METHODS rtti_check_clike
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_s_bool_cache,
        absolute_name TYPE string,
        is_bool       TYPE abap_bool,
      END OF ty_s_bool_cache.

    CLASS-DATA mt_bool_cache TYPE HASHED TABLE OF ty_s_bool_cache WITH UNIQUE KEY absolute_name.

    TYPES:
      BEGIN OF ty_s_attri_cache,
        absolute_name TYPE string,
        o_struct      TYPE REF TO cl_abap_structdescr,
        t_attri       TYPE cl_abap_structdescr=>component_table,
      END OF ty_s_attri_cache.

    CLASS-DATA mt_attri_cache TYPE HASHED TABLE OF ty_s_attri_cache WITH UNIQUE KEY absolute_name.

    CLASS-METHODS rtti_get_t_attri_on_prem
      IMPORTING
        tabname       TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_dfies.

    CLASS-METHODS rtti_get_t_attri_on_cloud
      IMPORTING
        tabname       TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_dfies ##NEEDED.



    CLASS-DATA gv_check_cloud TYPE abap_bool.

    CLASS-DATA gv_check_cloud_cached TYPE abap_bool.


    CLASS-METHODS msg_map
      IMPORTING
        name          TYPE clike
        val           TYPE data
        is_msg        TYPE ty_s_msg
      RETURNING
        VALUE(result) TYPE ty_s_msg.

    CLASS-METHODS msg_get_internal
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE ty_t_msg.

    CLASS-METHODS msg_get_by_oref
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE ty_t_msg.

    CLASS-METHODS check_is_rap_struct
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE abap_bool.

    CLASS-METHODS msg_get_rap
      IMPORTING
        val           TYPE any
        entity_name   TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE ty_t_msg.

    CLASS-METHODS msg_get_rap_row
      IMPORTING
        val         TYPE any
        entity_name TYPE string OPTIONAL
      EXPORTING
        messages    TYPE ty_t_msg
        is_row      TYPE abap_bool.

    CLASS-METHODS msg_get_rap_element
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_state_area
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_action
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_pid
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_cid
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_tky
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_flatten
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS msg_get_rap_meta
      IMPORTING
        val           TYPE any
      RETURNING
        VALUE(result) TYPE ty_t_name_value.

    CLASS-METHODS msg_get_rap_fail_text
      IMPORTING
        cause         TYPE i
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.


CLASS z2ui5_cl_sample_context IMPLEMENTATION.

  METHOD class_constructor.

    cv_char_util_newline        = cl_abap_char_utilities=>newline.
    cv_char_util_cr_lf          = cl_abap_char_utilities=>cr_lf.
    cv_char_util_horizontal_tab = cl_abap_char_utilities=>horizontal_tab.
    cv_char_util_charsize       = cl_abap_char_utilities=>charsize.
    cv_format_e_xml_attr             = cl_abap_format=>e_xml_attr.

    cv_typedescr_typekind_table      = cl_abap_typedescr=>typekind_table.
    cv_typedescr_typekind_dref       = cl_abap_typedescr=>typekind_dref.
    cv_typedescr_typekind_oref       = cl_abap_typedescr=>typekind_oref.
    cv_typedescr_typekind_struct1    = cl_abap_typedescr=>typekind_struct1.
    cv_typedescr_typekind_struct2    = cl_abap_typedescr=>typekind_struct2.
    cv_typedescr_kind_struct         = cl_abap_typedescr=>kind_struct.
    cv_typedescr_kind_ref            = cl_abap_typedescr=>kind_ref.
    cv_objectdescr_public            = cl_abap_objectdescr=>public.

  ENDMETHOD.

  METHOD boolean_abap_2_json.
      DATA temp1 TYPE string.

    IF boolean_check_by_data( val ) IS NOT INITIAL.
      
      IF val = abap_true.
        temp1 = `true`.
      ELSE.
        temp1 = `false`.
      ENDIF.
      result = temp1.
    ELSE.
      result = val.
    ENDIF.

  ENDMETHOD.

  METHOD boolean_check_by_data.
        DATA lo_descr TYPE REF TO cl_abap_typedescr.
        DATA temp2 TYPE string.
        DATA lv_abs_name LIKE temp2.
        DATA lr_cache TYPE REF TO z2ui5_cl_sample_context=>ty_s_bool_cache.
        DATA temp3 TYPE REF TO cl_abap_elemdescr.
        DATA lo_ele LIKE temp3.
        DATA temp4 TYPE z2ui5_cl_sample_context=>ty_s_bool_cache.

    TRY.
        
        lo_descr = cl_abap_elemdescr=>describe_by_data( val ).

        " all supported boolean types are character-like flags, this check
        " filters out every other type before the name based cache lookup
        IF lo_descr->type_kind <> cl_abap_typedescr=>typekind_char.
          RETURN.
        ENDIF.

        
        temp2 = lo_descr->absolute_name.
        
        lv_abs_name = temp2.

        
        READ TABLE mt_bool_cache REFERENCE INTO lr_cache
             WITH TABLE KEY absolute_name = lv_abs_name.
        IF sy-subrc = 0.
          result = lr_cache->is_bool.
          RETURN.
        ENDIF.

        
        temp3 ?= lo_descr.
        
        lo_ele = temp3.
        result = boolean_check_by_name( lo_ele->get_relative_name( ) ).

        
        CLEAR temp4.
        temp4-absolute_name = lv_abs_name.
        temp4-is_bool = result.
        INSERT temp4 INTO TABLE mt_bool_cache.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

  METHOD boolean_check_by_name.

    CASE val.
      WHEN `ABAP_BOOL`
          OR `XSDBOOLEAN`
          OR `FLAG`
          OR `XFLAG`
          OR `XFELD`
          OR `ABAP_BOOLEAN`
          OR `WDY_BOOLEAN`
          OR `BOOLE_D`
          OR `OS_BOOLEAN`.
        result = abap_true.
    ENDCASE.

  ENDMETHOD.

  METHOD c_trim.

    DATA temp5 TYPE string.
    temp5 = val.
    result = shift_left( shift_right( temp5 ) ).
    result = shift_right( val = result
                          sub = cv_char_util_horizontal_tab ).
    result = shift_left( val = result
                         sub = cv_char_util_horizontal_tab ).
    result = shift_left( shift_right( result ) ).

  ENDMETHOD.

  METHOD c_trim_lower.

    DATA temp6 TYPE string.
    temp6 = val.
    result = to_lower( c_trim( temp6 ) ).

  ENDMETHOD.

  METHOD c_trim_upper.

    DATA temp7 TYPE string.
    temp7 = val.
    result = to_upper( c_trim( temp7 ) ).

  ENDMETHOD.

  METHOD filter_itab.

    DATA ref TYPE REF TO data.
      DATA ls_filter LIKE LINE OF filter.
        FIELD-SYMBOLS <field> TYPE any.

    LOOP AT val REFERENCE INTO ref.

      
      LOOP AT filter INTO ls_filter.

        
        ASSIGN ref->(ls_filter-name) TO <field>.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        IF <field> NOT IN ls_filter-t_range.
          DELETE val.
          EXIT.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD filter_get_multi_by_data.

    DATA temp8 TYPE abap_component_tab.
    DATA temp1 LIKE LINE OF temp8.
    DATA lr_comp LIKE REF TO temp1.
      DATA temp9 TYPE z2ui5_cl_sample_context=>ty_s_filter_multi.
    temp8 = rtti_get_t_attri_by_any( val ).
    
    
    LOOP AT temp8 REFERENCE INTO lr_comp.
      
      CLEAR temp9.
      temp9-name = lr_comp->name.
      INSERT temp9 INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.

  METHOD filter_get_range_by_token.

    DATA lv_value LIKE val.
    DATA lv_length TYPE i.
    lv_value = val.
    IF lv_value IS INITIAL.
      RETURN.
    ENDIF.
    
    lv_length = strlen( lv_value ) - 1.

    CASE lv_value(1).

      WHEN `=`.
        CLEAR result.
        result-sign = `I`.
        result-option = `EQ`.
        result-low = lv_value+1.
      WHEN `<`.
        IF lv_value+1(1) = `=`.
          CLEAR result.
          result-sign = `I`.
          result-option = `LE`.
          result-low = lv_value+2.
        ELSE.
          CLEAR result.
          result-sign = `I`.
          result-option = `LT`.
          result-low = lv_value+1.
        ENDIF.
      WHEN `>`.
        IF lv_value+1(1) = `=`.
          CLEAR result.
          result-sign = `I`.
          result-option = `GE`.
          result-low = lv_value+2.
        ELSE.
          CLEAR result.
          result-sign = `I`.
          result-option = `GT`.
          result-low = lv_value+1.
        ENDIF.

      WHEN `*`.
        IF lv_length > 0 AND lv_value+lv_length(1) = `*`.
          lv_value = substring( val = lv_value off = 1 len = lv_length - 1 ).
          CLEAR result.
          result-sign = `I`.
          result-option = `CP`.
          result-low = lv_value.
        ELSEIF lv_length = 0.
          " Single '*' means contains-pattern with empty value
          CLEAR result.
          result-sign = `I`.
          result-option = `CP`.
          result-low = ``.
        ENDIF.

      WHEN OTHERS.
        IF lv_value CS `...`.
          SPLIT lv_value AT `...` INTO result-low result-high.
          result-sign   = `I`.
          result-option = `BT`.
        ELSE.
          CLEAR result.
          result-sign = `I`.
          result-option = `EQ`.
          result-low = lv_value.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD filter_get_range_t_by_token_t.

    DATA ls_token LIKE LINE OF val.
    LOOP AT val INTO ls_token.
      INSERT filter_get_range_by_token( ls_token-text ) INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.

  METHOD filter_get_token_range_mapping.

    DATA temp10 TYPE z2ui5_cl_sample_context=>ty_t_name_value.
    DATA temp11 LIKE LINE OF temp10.
    CLEAR temp10.
    
    temp11-n = `EQ`.
    temp11-v = `={LOW}`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `LT`.
    temp11-v = `<{LOW}`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `LE`.
    temp11-v = `<={LOW}`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `GT`.
    temp11-v = `>{LOW}`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `GE`.
    temp11-v = `>={LOW}`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `CP`.
    temp11-v = `*{LOW}*`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `BT`.
    temp11-v = `{LOW}...{HIGH}`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `NB`.
    temp11-v = `!({LOW}...{HIGH})`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `NE`.
    temp11-v = `!(={LOW})`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `NP`.
    temp11-v = `!(*{LOW}*)`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `!<leer>`.
    temp11-v = `!(<leer>)`.
    INSERT temp11 INTO TABLE temp10.
    temp11-n = `<leer>`.
    temp11-v = `<leer>`.
    INSERT temp11 INTO TABLE temp10.
    result = temp10.

  ENDMETHOD.

  METHOD filter_get_token_t_by_range_t.

    DATA lt_mapping TYPE z2ui5_cl_sample_context=>ty_t_name_value.
    DATA temp12 TYPE ty_t_range.
    DATA lt_tab LIKE temp12.
    DATA temp13 LIKE LINE OF lt_tab.
    DATA lr_row LIKE REF TO temp13.
      DATA lv_value TYPE z2ui5_cl_sample_context=>ty_s_name_value-v.
      DATA temp2 LIKE LINE OF lt_mapping.
      DATA temp3 LIKE sy-tabix.
      DATA temp14 TYPE z2ui5_cl_sample_context=>ty_s_token.
    lt_mapping = filter_get_token_range_mapping( ).

    
    CLEAR temp12.
    
    lt_tab = temp12.

    itab_corresponding( EXPORTING val = val
                        CHANGING  tab = lt_tab
    ).

    
    
    LOOP AT lt_tab REFERENCE INTO lr_row.

      
      
      
      temp3 = sy-tabix.
      READ TABLE lt_mapping WITH KEY n = lr_row->option INTO temp2.
      sy-tabix = temp3.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      lv_value = temp2-v.
      REPLACE `{LOW}`  IN lv_value WITH lr_row->low.
      REPLACE `{HIGH}` IN lv_value WITH lr_row->high.

      
      CLEAR temp14.
      temp14-key = lv_value.
      temp14-text = lv_value.
      temp14-visible = abap_true.
      temp14-editable = abap_true.
      INSERT temp14 INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.

  METHOD itab_filter_by_val.
    " TRANSPILER NOTE: ABAP CS operator is ALWAYS case-insensitive regardless
    " of the ignore_case flag. The flag only pre-converts to uppercase for
    " consistency, but CS itself never does case-sensitive matching.
    " JS equivalent: always use toLowerCase().includes(toLowerCase()).
    FIELD-SYMBOLS <row>   TYPE any.
    FIELD-SYMBOLS <field> TYPE any.
    DATA temp15 TYPE string.
    DATA lv_search LIKE temp15.
      DATA lv_check_found LIKE abap_false.
      DATA lv_index TYPE i.
          DATA lv_name LIKE LINE OF fields.
          DATA temp4 LIKE LINE OF fields.
          DATA temp5 LIKE sy-tabix.
        DATA lv_value TYPE string.

    " an empty search matches everything (and find( sub = `` ) would dump
    " with CX_SY_STRG_PAR_VAL), so leave the table untouched
    IF val IS INITIAL.
      RETURN.
    ENDIF.

    
    IF ignore_case = abap_true.
      temp15 = to_upper( val ).
    ELSE.
      temp15 = val.
    ENDIF.
    
    lv_search = temp15.

    LOOP AT tab ASSIGNING <row>.

      
      lv_check_found = abap_false.
      
      lv_index = 1.
      DO.
        IF fields IS INITIAL.
          ASSIGN COMPONENT lv_index OF STRUCTURE <row> TO <field>.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
        ELSE.
          IF lv_index > lines( fields ).
            EXIT.
          ENDIF.
          
          
          
          temp5 = sy-tabix.
          READ TABLE fields INDEX lv_index INTO temp4.
          sy-tabix = temp5.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          lv_name = temp4.
          ASSIGN COMPONENT lv_name OF STRUCTURE <row> TO <field>.
          IF sy-subrc <> 0.
            lv_index = lv_index + 1.
            CONTINUE.
          ENDIF.
        ENDIF.

        
        lv_value = |{ <field> }|.
        IF ignore_case = abap_true.
          lv_value = to_upper( lv_value ).
          IF lv_value CS lv_search.
            lv_check_found = abap_true.
            EXIT.
          ENDIF.
        ELSE.
          " Case-sensitive: use find() because CS is always case-insensitive
          IF find( val = lv_value sub = lv_search ) >= 0.
            lv_check_found = abap_true.
            EXIT.
          ENDIF.
        ENDIF.

        lv_index = lv_index + 1.
      ENDDO.

      IF lv_check_found = abap_false.
        DELETE tab.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD itab_get_csv_by_itab.

    FIELD-SYMBOLS <tab> TYPE table.
    DATA lt_lines TYPE string_table.
    DATA lv_line TYPE string.
    DATA temp16 TYPE REF TO cl_abap_tabledescr.
    DATA tab LIKE temp16.
    DATA temp17 TYPE REF TO cl_abap_structdescr.
    DATA struc LIKE temp17.
    DATA temp18 TYPE abap_component_tab.
    DATA temp6 LIKE LINE OF temp18.
    DATA lr_comp LIKE REF TO temp6.
    DATA lr_row TYPE REF TO data.
      DATA lv_index TYPE i.
        FIELD-SYMBOLS <row> TYPE data.
        FIELD-SYMBOLS <field> TYPE any.
        DATA lv_field_val TYPE string.

    ASSIGN val TO <tab>.
    
    temp16 ?= cl_abap_typedescr=>describe_by_data( <tab> ).
    
    tab = temp16.

    
    temp17 ?= tab->get_table_line_type( ).
    
    struc = temp17.

    CLEAR lv_line.
    
    temp18 = struc->get_components( ).
    
    
    LOOP AT temp18 REFERENCE INTO lr_comp.
      lv_line = |{ lv_line }{ lr_comp->name };|.
    ENDLOOP.
    INSERT lv_line INTO TABLE lt_lines.

    
    LOOP AT <tab> REFERENCE INTO lr_row.

      CLEAR lv_line.
      
      lv_index = 1.
      DO.
        
        ASSIGN lr_row->* TO <row>.
        
        ASSIGN COMPONENT lv_index OF STRUCTURE <row> TO <field>.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        lv_index = lv_index + 1.
        
        lv_field_val = |{ <field> }|.
        REPLACE ALL OCCURRENCES OF `;` IN lv_field_val WITH `,`.
        lv_line = |{ lv_line }{ lv_field_val };|.
      ENDDO.
      INSERT lv_line INTO TABLE lt_lines.
    ENDLOOP.

    result = concat_lines_of( table = lt_lines sep = cv_char_util_cr_lf ).

  ENDMETHOD.

  METHOD itab_get_itab_by_csv.

    DATA lt_comp TYPE cl_abap_structdescr=>component_table.
    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    DATA lr_row TYPE REF TO data.

    DATA lt_rows TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lt_cols TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA temp7 LIKE LINE OF lt_rows.
    DATA temp8 LIKE sy-tabix.
    DATA temp19 LIKE LINE OF lt_cols.
    DATA lr_col LIKE REF TO temp19.
      DATA lv_name TYPE string.
      DATA temp20 TYPE abap_componentdescr.
    DATA struc TYPE REF TO cl_abap_structdescr.
    DATA temp21 TYPE REF TO cl_abap_datadescr.
    DATA data LIKE temp21.
    DATA o_table_desc TYPE REF TO cl_abap_tabledescr.
    DATA temp22 LIKE LINE OF lt_rows.
    DATA lr_rows LIKE REF TO temp22.
        FIELD-SYMBOLS <row> TYPE data.
        FIELD-SYMBOLS <field> TYPE any.
    SPLIT val AT cv_char_util_newline INTO TABLE lt_rows.
    
    
    
    temp8 = sy-tabix.
    READ TABLE lt_rows INDEX 1 INTO temp7.
    sy-tabix = temp8.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    SPLIT temp7 AT `;` INTO TABLE lt_cols.

    
    
    LOOP AT lt_cols REFERENCE INTO lr_col.

      
      lv_name = c_trim_upper( lr_col->* ).
      REPLACE ALL OCCURRENCES OF ` ` IN lv_name WITH `_`.

      
      CLEAR temp20.
      temp20-name = lv_name.
      temp20-type = cl_abap_elemdescr=>get_c( 40 ).
      INSERT temp20 INTO TABLE lt_comp.
    ENDLOOP.

    
    struc = cl_abap_structdescr=>get( lt_comp ).
    
    temp21 ?= struc.
    
    data = temp21.
    
    o_table_desc = cl_abap_tabledescr=>create( p_line_type  = data
                                                     p_table_kind = cl_abap_tabledescr=>tablekind_std
                                                     p_unique     = abap_false ).

    CREATE DATA result TYPE HANDLE o_table_desc.
    ASSIGN result->* TO <tab>.
    DELETE lt_rows WHERE table_line IS INITIAL.

    
    
    LOOP AT lt_rows REFERENCE INTO lr_rows FROM 2.

      SPLIT lr_rows->* AT `;` INTO TABLE lt_cols.
      CREATE DATA lr_row TYPE HANDLE struc.

      LOOP AT lt_cols REFERENCE INTO lr_col.
        
        ASSIGN lr_row->* TO <row>.
        
        ASSIGN COMPONENT sy-tabix OF STRUCTURE <row> TO <field>.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        <field> = lr_col->*.
      ENDLOOP.

      INSERT <row> INTO TABLE <tab>.
    ENDLOOP.

  ENDMETHOD.

  METHOD json_parse.
        DATA x TYPE REF TO cx_root.
    TRY.

        z2ui5_cl_ajson=>parse( val )->to_abap( EXPORTING iv_corresponding = abap_true
                                               IMPORTING ev_container     = data ).

        
      CATCH cx_root INTO x.
        RAISE EXCEPTION TYPE z2ui5_cx_sample_error
          EXPORTING
            val = x.
    ENDTRY.
  ENDMETHOD.

  METHOD rtti_check_class_exists.

    TRY.
        cl_abap_classdescr=>describe_by_name( EXPORTING  p_name         = val
                                              EXCEPTIONS type_not_found = 1 ).
        IF sy-subrc = 0.
          result = abap_true.
        ENDIF.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

  METHOD rtti_get_t_attri_by_include.
        DATA type_desc TYPE REF TO cl_abap_typedescr.
        DATA x TYPE REF TO cx_root.
    DATA temp23 TYPE REF TO cl_abap_structdescr.
    DATA sdescr LIKE temp23.
    DATA comps TYPE abap_component_tab.
    DATA temp24 LIKE LINE OF comps.
    DATA lr_comp LIKE REF TO temp24.
        DATA incl_comps TYPE abap_component_tab.
        DATA temp25 LIKE LINE OF incl_comps.
        DATA lr_incl_comp LIKE REF TO temp25.

    TRY.

        
        cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = type->absolute_name
                                             RECEIVING  p_descr_ref    = type_desc
                                             EXCEPTIONS type_not_found = 1 ).

        
      CATCH cx_root INTO x.
        RAISE EXCEPTION TYPE z2ui5_cx_sample_error
          EXPORTING
            previous = x.
    ENDTRY.
    
    temp23 ?= type_desc.
    
    sdescr = temp23.
    
    comps = sdescr->get_components( ).

    
    
    LOOP AT comps REFERENCE INTO lr_comp.

      IF lr_comp->as_include = abap_true.

        
        incl_comps = rtti_get_t_attri_by_include( lr_comp->type ).

        
        
        LOOP AT incl_comps REFERENCE INTO lr_incl_comp.
          APPEND lr_incl_comp->* TO result.
        ENDLOOP.

      ELSE.

        APPEND lr_comp->* TO result.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD rtti_get_t_attri_by_any.

    DATA lo_struct TYPE REF TO cl_abap_structdescr.
    DATA lo_type   TYPE REF TO cl_abap_typedescr.
        DATA temp26 TYPE REF TO cl_abap_structdescr.
        DATA temp27 TYPE REF TO cl_abap_structdescr.
        DATA temp9 TYPE REF TO cl_abap_tabledescr.
    DATA temp28 TYPE string.
    DATA lv_absolute_name LIKE temp28.
    DATA lr_cache TYPE REF TO z2ui5_cl_sample_context=>ty_s_attri_cache.
    DATA comps TYPE abap_component_tab.
    DATA temp29 LIKE LINE OF comps.
    DATA lr_comp LIKE REF TO temp29.
        DATA lt_attri TYPE abap_component_tab.
      DATA temp30 TYPE z2ui5_cl_sample_context=>ty_s_attri_cache.

    TRY.
        lo_type = cl_abap_typedescr=>describe_by_data( val ).
        IF lo_type->kind = cl_abap_typedescr=>kind_ref.
          lo_type = cl_abap_typedescr=>describe_by_data_ref( val ).
        ENDIF.
      CATCH cx_root.
        TRY.
            lo_type = cl_abap_typedescr=>describe_by_data_ref( val ).
          CATCH cx_root.
            lo_type = cl_abap_structdescr=>describe_by_name( val ).
        ENDTRY.
    ENDTRY.

    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        
        temp26 ?= lo_type.
        lo_struct = temp26.
      WHEN cl_abap_typedescr=>kind_table.
        
        
        temp9 ?= lo_type.
        temp27 ?= temp9->get_table_line_type( ).
        lo_struct = temp27.
      WHEN OTHERS.
        lo_struct ?= lo_type.
    ENDCASE.

    " descriptor instances are singletons per type, so the identity check
    " guards against absolute names reused by other (local/anonymous) types
    
    temp28 = lo_struct->absolute_name.
    
    lv_absolute_name = temp28.
    
    READ TABLE mt_attri_cache REFERENCE INTO lr_cache
         WITH TABLE KEY absolute_name = lv_absolute_name.
    IF sy-subrc = 0 AND lr_cache->o_struct = lo_struct.
      result = lr_cache->t_attri.
      RETURN.
    ENDIF.

    
    comps = lo_struct->get_components( ).

    
    
    LOOP AT comps REFERENCE INTO lr_comp.

      IF lr_comp->as_include = abap_false.
        APPEND lr_comp->* TO result.
      ELSE.
        
        lt_attri = rtti_get_t_attri_by_include( lr_comp->type ).
        APPEND LINES OF lt_attri TO result.
      ENDIF.
    ENDLOOP.

    IF lr_cache IS BOUND.
      lr_cache->o_struct = lo_struct.
      lr_cache->t_attri  = result.
    ELSE.
      
      CLEAR temp30.
      temp30-absolute_name = lv_absolute_name.
      temp30-o_struct = lo_struct.
      temp30-t_attri = result.
      INSERT temp30 INTO TABLE mt_attri_cache.
    ENDIF.

  ENDMETHOD.

  METHOD time_get_timestampl.
    GET TIME STAMP FIELD result.
  ENDMETHOD.

  METHOD url_param_get.

    DATA lt_params TYPE z2ui5_cl_sample_context=>ty_t_name_value.
    DATA lv_val TYPE string.
    DATA temp31 TYPE string.
    DATA temp32 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
    lt_params = url_param_get_tab( url ).
    
    lv_val = c_trim_lower( val ).
    
    CLEAR temp31.
    
    READ TABLE lt_params INTO temp32 WITH KEY n = lv_val.
    IF sy-subrc = 0.
      temp31 = temp32-v.
    ENDIF.
    result = temp31.

  ENDMETHOD.

  METHOD url_param_get_tab.

    DATA lv_search TYPE string.
    DATA lv_search2 TYPE string.
    DATA temp33 TYPE string.
    DATA lt_param TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA temp34 LIKE LINE OF lt_param.
    DATA lr_param LIKE REF TO temp34.
      DATA lv_name TYPE string.
      DATA lv_value TYPE string.
      DATA temp35 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
    lv_search = replace( val  = i_val
                               sub  = `%3D`
                               with = `=`
                               occ  = 0 ).

    lv_search = replace( val  = lv_search
                         sub  = `%26`
                         with = `&`
                         occ  = 0 ).

    lv_search = shift_left( val = lv_search
                            sub = `?` ).

    
    lv_search2 = substring_after( val = lv_search
                                        sub = `&sap-startup-params=` ).
    
    IF lv_search2 IS NOT INITIAL.
      temp33 = lv_search2.
    ELSE.
      temp33 = lv_search.
    ENDIF.
    lv_search = temp33.

    lv_search2 = substring_after( val = c_trim_lower( lv_search )
                                  sub = `?` ).
    IF lv_search2 IS NOT INITIAL.
      lv_search = lv_search2.
    ENDIF.

    
    SPLIT lv_search AT `&` INTO TABLE lt_param.

    
    
    LOOP AT lt_param REFERENCE INTO lr_param.
      
      
      SPLIT lr_param->* AT `=` INTO lv_name lv_value.
      
      CLEAR temp35.
      temp35-n = lv_name.
      temp35-v = lv_value.
      INSERT temp35 INTO TABLE rt_params.
    ENDLOOP.

  ENDMETHOD.

  METHOD xml_parse.

    IF xml IS INITIAL.
      CLEAR any.
      RETURN.
    ENDIF.

    CALL TRANSFORMATION id
         SOURCE XML xml
         RESULT data = any.

  ENDMETHOD.

  METHOD xml_srtti_parse.

    DATA srtti TYPE REF TO object.
    DATA rtti_type TYPE REF TO cl_abap_typedescr.
    DATA lo_datadescr TYPE REF TO cl_abap_datadescr.
    FIELD-SYMBOLS <variable> TYPE data.
    CALL TRANSFORMATION id SOURCE XML rtti_data RESULT srtti = srtti.

    
    CALL METHOD srtti->(`GET_RTTI`)
      RECEIVING
        rtti = rtti_type.

    
    lo_datadescr ?= rtti_type.

    CREATE DATA result TYPE HANDLE lo_datadescr.
    
    ASSIGN result->* TO <variable>.
    CALL TRANSFORMATION id SOURCE XML rtti_data RESULT dobj = <variable>.

  ENDMETHOD.

  METHOD xml_srtti_stringify.
      DATA srtti TYPE REF TO object.
      DATA lv_classname TYPE string.
          DATA lv_text TYPE string.

    IF rtti_check_class_exists( `ZCL_SRTTI_TYPEDESCR` ) = abap_true.

      
      
      lv_classname = `ZCL_SRTTI_TYPEDESCR`.
      CALL METHOD (lv_classname)=>(`CREATE_BY_DATA_OBJECT`)
        EXPORTING
          data_object = data
        RECEIVING
          srtti       = srtti.
      CALL TRANSFORMATION id SOURCE srtti = srtti dobj = data RESULT XML result.

    ELSE.

      TRY.
          CALL METHOD z2ui5_cl_srt_typedescr=>(`CREATE_BY_DATA_OBJECT`)
            EXPORTING
              data_object = data
            RECEIVING
              srtti       = srtti.
          CALL TRANSFORMATION id SOURCE srtti = srtti dobj = data RESULT XML result.

        CATCH cx_root.

          
          lv_text = `UNSUPPORTED_FEATURE`.
          RAISE EXCEPTION TYPE z2ui5_cx_sample_error
            EXPORTING
              val = lv_text.

      ENDTRY.
    ENDIF.

  ENDMETHOD.

  METHOD xml_stringify.

    CALL TRANSFORMATION id
         SOURCE data = any
         RESULT XML result
         OPTIONS data_refs = `heap-or-create`.

  ENDMETHOD.

  METHOD rtti_get_t_attri_by_table_name.
        DATA lo_obj TYPE REF TO cl_abap_typedescr.
        DATA temp36 TYPE REF TO cl_abap_structdescr.
        DATA lo_struct LIKE temp36.
            DATA temp37 TYPE REF TO cl_abap_tabledescr.
            DATA lo_tab LIKE temp37.
            DATA temp38 TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE abap_component_tab.
    DATA temp39 LIKE LINE OF lt_comps.
    DATA lr_comp LIKE REF TO temp39.
        DATA lt_attri TYPE abap_component_tab.

    IF table_name IS INITIAL.
      RAISE EXCEPTION TYPE z2ui5_cx_sample_error
        EXPORTING
          val = `TABLE_NAME_INITIAL_ERROR`.
    ENDIF.

    TRY.
        
        cl_abap_structdescr=>describe_by_name( EXPORTING  p_name         = table_name
                                               RECEIVING  p_descr_ref    = lo_obj
                                               EXCEPTIONS type_not_found = 1
                                                          OTHERS         = 2
            ).

        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE z2ui5_cx_sample_error
            EXPORTING
              val = |TABLE_NOT_FOUD_NAME___{ table_name }|.
        ENDIF.
        
        temp36 ?= lo_obj.
        
        lo_struct = temp36.

      CATCH cx_root.

        TRY.
            cl_abap_structdescr=>describe_by_name( EXPORTING  p_name         = table_name
                                                   RECEIVING  p_descr_ref    = lo_obj
                                                   EXCEPTIONS type_not_found = 1
                                                              OTHERS         = 2
            ).
            IF sy-subrc <> 0.
              RAISE EXCEPTION TYPE z2ui5_cx_sample_error
                EXPORTING
                  val = |TABLE_NOT_FOUD_NAME___{ table_name }|.
            ENDIF.

            
            temp37 ?= lo_obj.
            
            lo_tab = temp37.
            
            temp38 ?= lo_tab->get_table_line_type( ).
            lo_struct = temp38.
          CATCH cx_root.
            RETURN.
        ENDTRY.

    ENDTRY.

    
    lt_comps = lo_struct->get_components( ).

    
    
    LOOP AT lt_comps REFERENCE INTO lr_comp.
      IF lr_comp->as_include = abap_true.
        
        lt_attri = rtti_get_t_attri_by_include( lr_comp->type ).
        INSERT LINES OF lt_attri INTO TABLE result.
      ELSE.
        INSERT lr_comp->* INTO TABLE result.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD itab_corresponding.

    FIELD-SYMBOLS <row_in>  TYPE any.
    FIELD-SYMBOLS <row_out> TYPE any.

    LOOP AT val ASSIGNING <row_in>.
      APPEND INITIAL LINE TO tab ASSIGNING <row_out>.
      MOVE-CORRESPONDING <row_in> TO <row_out>.
    ENDLOOP.

  ENDMETHOD.

  METHOD msg_get_t.

    result = msg_get_internal( val ).
    IF result IS INITIAL AND val2 IS NOT INITIAL.
      result = msg_get_internal( val2 ).
    ENDIF.

  ENDMETHOD.

  METHOD msg_get.

    DATA lt_msg TYPE z2ui5_cl_sample_context=>ty_t_msg.
    DATA temp40 LIKE LINE OF lt_msg.
    DATA temp41 LIKE sy-tabix.
    lt_msg = msg_get_t( val = val val2 = val2 ).
    
    
    temp41 = sy-tabix.
    READ TABLE lt_msg INDEX 1 INTO temp40.
    sy-tabix = temp41.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    result = temp40.

  ENDMETHOD.

  METHOD msg_get_by_msg.

    DATA temp42 TYPE ty_s_msg.
    DATA ls_msg LIKE temp42.
    CLEAR temp42.
    temp42-id = id.
    temp42-no = no.
    temp42-v1 = v1.
    temp42-v2 = v2.
    temp42-v3 = v3.
    temp42-v4 = v4.
    
    ls_msg = temp42.
    result = msg_get( ls_msg ).

  ENDMETHOD.

  METHOD conv_decode_x_base64.
    DATA lv_web_http_name TYPE c LENGTH 19.
    DATA classname        TYPE c LENGTH 15.

    TRY.

        lv_web_http_name = `CL_WEB_HTTP_UTILITY`.
        CALL METHOD (lv_web_http_name)=>(`DECODE_X_BASE64`)
          EXPORTING
            encoded = val
          RECEIVING
            decoded = result.

      CATCH cx_root.

        classname = `CL_HTTP_UTILITY`.
        CALL METHOD (classname)=>(`DECODE_X_BASE64`)
          EXPORTING
            encoded = val
          RECEIVING
            decoded = result.

    ENDTRY.

  ENDMETHOD.

  METHOD conv_encode_x_base64.
    DATA lv_web_http_name TYPE c LENGTH 19.
    DATA classname        TYPE c LENGTH 15.

    TRY.

        lv_web_http_name = `CL_WEB_HTTP_UTILITY`.
        CALL METHOD (lv_web_http_name)=>(`ENCODE_X_BASE64`)
          EXPORTING
            unencoded = val
          RECEIVING
            encoded   = result.

      CATCH cx_root.

        classname = `CL_HTTP_UTILITY`.
        CALL METHOD (classname)=>(`ENCODE_X_BASE64`)
          EXPORTING
            unencoded = val
          RECEIVING
            encoded   = result.

    ENDTRY.

  ENDMETHOD.

  METHOD conv_get_string_by_xstring.

    DATA conv          TYPE REF TO object.
    DATA conv_codepage TYPE c LENGTH 21.
    DATA conv_in_class TYPE c LENGTH 18.

    TRY.

        conv_codepage = `CL_ABAP_CONV_CODEPAGE`.
        CALL METHOD (conv_codepage)=>create_in
          RECEIVING
            instance = conv.

        CALL METHOD conv->(`IF_ABAP_CONV_IN~CONVERT`)
          EXPORTING
            source = val
          RECEIVING
            result = result.

      CATCH cx_root.

        conv_in_class = `CL_ABAP_CONV_IN_CE`.
        CALL METHOD (conv_in_class)=>create
          EXPORTING
            encoding = `UTF-8`
          RECEIVING
            conv     = conv.

        CALL METHOD conv->(`CONVERT`)
          EXPORTING
            input = val
          IMPORTING
            data  = result.
    ENDTRY.

  ENDMETHOD.

  METHOD conv_get_xstring_by_string.

    DATA conv           TYPE REF TO object.
    DATA conv_codepage  TYPE c LENGTH 21.
    DATA conv_out_class TYPE c LENGTH 19.

    TRY.

        conv_codepage = `CL_ABAP_CONV_CODEPAGE`.
        CALL METHOD (conv_codepage)=>create_out
          RECEIVING
            instance = conv.

        CALL METHOD conv->(`IF_ABAP_CONV_OUT~CONVERT`)
          EXPORTING
            source = val
          RECEIVING
            result = result.

      CATCH cx_root.

        conv_out_class = `CL_ABAP_CONV_OUT_CE`.
        CALL METHOD (conv_out_class)=>create
          EXPORTING
            encoding = `UTF-8`
          RECEIVING
            conv     = conv.

        CALL METHOD conv->(`CONVERT`)
          EXPORTING
            data   = val
          IMPORTING
            buffer = result.
    ENDTRY.

  ENDMETHOD.

  METHOD uuid_get_c32.
    DATA lv_uuid      TYPE c LENGTH 32.
    DATA lv_classname TYPE string.
    DATA lv_fm        TYPE string.

    TRY.

        TRY.

            lv_classname = `CL_SYSTEM_UUID`.
            CALL METHOD (lv_classname)=>if_system_uuid_static~create_uuid_c32
              RECEIVING
                uuid = lv_uuid.

          CATCH cx_root.

            lv_fm = `GUID_CREATE`.
            CALL FUNCTION lv_fm
              IMPORTING
                ev_guid_32 = lv_uuid.

        ENDTRY.

        result = lv_uuid.

      CATCH cx_root.
        ASSERT 1 = 0.
    ENDTRY.
  ENDMETHOD.


  METHOD rtti_get_t_attri_on_prem.

    DATA structdescr TYPE REF TO cl_abap_structdescr.
    DATA dfies       TYPE REF TO data.
    DATA s_dfies     TYPE ty_s_dfies.

    FIELD-SYMBOLS <dfies> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <line>  TYPE any.

    DATA temp9           TYPE cl_abap_structdescr=>component_table.
    DATA comps           LIKE temp9.
    DATA temp10          TYPE REF TO cl_abap_structdescr.
    DATA lo_struct       LIKE temp10.
    DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
    DATA new_table_desc  TYPE REF TO cl_abap_tabledescr.
    DATA comp            LIKE LINE OF comps.
    FIELD-SYMBOLS <value>      TYPE any.
    FIELD-SYMBOLS <value_dest> TYPE any.

    comps = temp9.

*    TYPES: BEGIN OF ty_s_dfies,
*             tabname     TYPE c LENGTH 30,
*             fieldname   TYPE c LENGTH 30,
*             langu       TYPE c LENGTH 1,
*             position    TYPE n LENGTH 4,
*             offset      TYPE n LENGTH 6,
*             domname     TYPE c LENGTH 30,
*             rollname    TYPE c LENGTH 30,
*             checktable  TYPE c LENGTH 30,
*             leng        TYPE n LENGTH 6,
*             intlen      TYPE n LENGTH 6,
*             outputlen   TYPE n LENGTH 6,
*             decimals    TYPE n LENGTH 6,
*             datatype    TYPE c LENGTH 4,
*             inttype     TYPE c LENGTH 1,
*             reftable    TYPE c LENGTH 30,
*             reffield    TYPE c LENGTH 30,
*             precfield   TYPE c LENGTH 30,
*             authorid    TYPE c LENGTH 3,
*             memoryid    TYPE c LENGTH 20,
*             logflag     TYPE c LENGTH 1,
*             mask        TYPE c LENGTH 20,
*             masklen     TYPE n LENGTH 4,
*             convexit    TYPE c LENGTH 5,
*             headlen     TYPE n LENGTH 2,
*             scrlen1     TYPE n LENGTH 2,
*             scrlen2     TYPE n LENGTH 2,
*             scrlen3     TYPE n LENGTH 2,
*             fieldtext   TYPE c LENGTH 60,
*             reptext     TYPE c LENGTH 55,
*             scrtext_s   TYPE c LENGTH 10,
*             scrtext_m   TYPE c LENGTH 20,
*             scrtext_l   TYPE c LENGTH 40,
*             keyflag     TYPE c LENGTH 1,
*             lowercase   TYPE c LENGTH 1,
*             mac         TYPE c LENGTH 1,
*             genkey      TYPE c LENGTH 1,
*             noforkey    TYPE c LENGTH 1,
*             valexi      TYPE c LENGTH 1,
*             noauthch    TYPE c LENGTH 1,
*             sign        TYPE c LENGTH 1,
*             dynpfld     TYPE c LENGTH 1,
*             f4availabl  TYPE c LENGTH 1,
*             comptype    TYPE c LENGTH 1,
*             lfieldname  TYPE c LENGTH 132,
*             ltrflddis   TYPE c LENGTH 1,
*             bidictrlc   TYPE c LENGTH 1,
*             outputstyle TYPE n LENGTH 2,
*             nohistory   TYPE c LENGTH 1,
*             ampmformat  TYPE c LENGTH 1,
*           END OF ty_s_dfies.
*    temp10 ?= cl_abap_structdescr=>describe_by_name( `TY_S_DFIES` ).

    temp10 ?= cl_abap_structdescr=>describe_by_name( `DFIES` ).

    lo_struct = temp10.
    comps = lo_struct->get_components( ).

    TRY.

        new_struct_desc = cl_abap_structdescr=>create( comps ).

        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                     p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA dfies TYPE HANDLE new_table_desc.

        ASSIGN dfies->* TO <dfies>.
        IF <dfies> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

        IF tabname IS INITIAL.
          RAISE EXCEPTION TYPE z2ui5_cx_sample_error
            EXPORTING
              val = `RTTI_BY_NAME_TAB_INITIAL`.
        ENDIF.

        structdescr ?= cl_abap_structdescr=>describe_by_name( tabname ).
        <dfies> = structdescr->get_ddic_field_list( ).

        LOOP AT <dfies> ASSIGNING <line>.

          LOOP AT comps INTO comp.

            ASSIGN COMPONENT comp-name OF STRUCTURE <line> TO <value>.
            IF <value> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.

            ASSIGN COMPONENT comp-name OF STRUCTURE s_dfies TO <value_dest>.
            IF <value_dest> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.

            <value_dest> = <value>.

            UNASSIGN <value>.
            UNASSIGN <value_dest>.

          ENDLOOP.

          APPEND s_dfies TO result.
          CLEAR s_dfies.

        ENDLOOP.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

  METHOD rtti_get_t_attri_on_cloud.

    DATA obj TYPE REF TO object.
    DATA lv_tabname TYPE c LENGTH 16.
    DATA lr_ddfields TYPE REF TO data.
    TYPES ty_c30 TYPE c LENGTH 30.
    DATA names TYPE STANDARD TABLE OF ty_c30 WITH DEFAULT KEY.
    FIELD-SYMBOLS <any> TYPE any.
    FIELD-SYMBOLS <field> TYPE simple.
    FIELD-SYMBOLS <ddfields> TYPE ANY TABLE.
            DATA lv_method2 TYPE string.
            DATA workaround TYPE string.
            DATA temp43 TYPE REF TO cl_abap_structdescr.
    DATA lt_comp TYPE abap_component_tab.
    DATA temp44 LIKE LINE OF lt_comp.
    DATA lr_comp LIKE REF TO temp44.
      DATA lv_check_key LIKE abap_false.
      DATA temp45 LIKE sy-subrc.
      DATA temp46 TYPE z2ui5_cl_sample_context=>ty_s_dfies.

* convert to correct type,
    lv_tabname = tabname.

    TRY.
        TRY.
            
            lv_method2 = `XCO_CP_ABAP_DICTIONARY`.
            CALL METHOD (lv_method2)=>(`DATABASE_TABLE`)
              EXPORTING
                iv_name           = lv_tabname
              RECEIVING
                ro_database_table = obj.
            ASSIGN obj->(`IF_XCO_DATABASE_TABLE~FIELDS->IF_XCO_DBT_FIELDS_FACTORY~KEY`) TO <any>.
            IF sy-subrc  <> 0.
* fallback to RTTI, KEY field does not exist in S/4 2020
              RAISE EXCEPTION TYPE cx_sy_dyn_call_illegal_class.
            ENDIF.
            obj = <any>.
            CALL METHOD obj->(`IF_XCO_DBT_FIELDS~GET_NAMES`)
              RECEIVING
                rt_names = names.
          CATCH cx_sy_dyn_call_illegal_class.
            
            workaround = `DDFIELDS`.
            CREATE DATA lr_ddfields TYPE (workaround).
            ASSIGN lr_ddfields->* TO <ddfields>.
            ASSERT sy-subrc = 0.
            
            temp43 ?= cl_abap_typedescr=>describe_by_name( lv_tabname ).
            <ddfields> = temp43->get_ddic_field_list( ).
            LOOP AT <ddfields> ASSIGNING <any>.
              ASSIGN COMPONENT `KEYFLAG` OF STRUCTURE <any> TO <field>.
              IF sy-subrc <> 0 OR <field> <> abap_true.
                CONTINUE.
              ENDIF.
              ASSIGN COMPONENT `FIELDNAME` OF STRUCTURE <any> TO <field>.
              ASSERT sy-subrc = 0.
              APPEND <field> TO names.
            ENDLOOP.
        ENDTRY.
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.


    
    lt_comp  =  rtti_get_t_attri_by_any( tabname ).
    
    
    LOOP AT lt_comp REFERENCE INTO lr_comp.

      
      lv_check_key = abap_false.
      
      READ TABLE names WITH KEY table_line = lr_comp->name TRANSPORTING NO FIELDS.
      temp45 = sy-subrc.
      IF temp45 = 0.
        lv_check_key = abap_true.
      ENDIF.

      
      CLEAR temp46.
      temp46-fieldname = lr_comp->name.
      temp46-rollname = lr_comp->name.
      temp46-keyflag = lv_check_key.
      temp46-scrtext_s = lr_comp->name.
      temp46-scrtext_m = lr_comp->name.
      temp46-scrtext_l = lr_comp->name.
      INSERT temp46 INTO TABLE result.

    ENDLOOP.
*            structdescr->
*        <dfies> = structdescr->get_ddic_field_list( ).

*        LOOP AT <dfies> ASSIGNING <line>.
*
*          LOOP AT comps INTO comp.
*
*            ASSIGN COMPONENT comp-name OF STRUCTURE <line> TO <value>.
*            IF <value> IS NOT ASSIGNED.
*              CONTINUE.
*            ENDIF.
*
*            ASSIGN COMPONENT comp-name OF STRUCTURE s_dfies TO <value_dest>.
*            IF <value_dest> IS NOT ASSIGNED.
*              CONTINUE.
*            ENDIF.
*
*            <value_dest> = <value>.
*
*            UNASSIGN <value>.
*            UNASSIGN <value_dest>.
*
*          ENDLOOP.
*
*          APPEND s_dfies TO result.
*          CLEAR s_dfies.
*
*        ENDLOOP.



*    DATA db        TYPE REF TO object.
*    DATA fields    TYPE REF TO object.
*    DATA r_names   TYPE REF TO data.
*    DATA t_param   TYPE abap_parmbind_tab.
*    DATA field     TYPE REF TO object.
*    DATA content   TYPE REF TO object.
*    DATA r_content TYPE REF TO data.
*    DATA type      TYPE REF TO object.
*    DATA element   TYPE REF TO object.
*    DATA tab       TYPE c LENGTH 16.
*
*    FIELD-SYMBOLS <any>   TYPE any.
*    FIELD-SYMBOLS <names> TYPE STANDARD TABLE.
*    FIELD-SYMBOLS <name>  TYPE any.
*    FIELD-SYMBOLS <fiel>  TYPE REF TO object.
*
*    tab = tabname.
*
*    CALL METHOD (`XCO_CP_ABAP_DICTIONARY`)=>database_table
*      EXPORTING
*        iv_name           = tab
*      RECEIVING
*        ro_database_table = db.
*
*    ASSIGN db->(`IF_XCO_DATABASE_TABLE~FIELDS->IF_XCO_DBT_FIELDS_FACTORY~ALL`) TO <any>.
*
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    fields = <any>.
*
*    CREATE DATA r_names TYPE (`SXCO_T_AD_FIELD_NAMES`).
*    ASSIGN r_names->* TO <Names>.
*    IF <Names> IS NOT ASSIGNED.
*      RETURN.
*    ENDIF.
*
*    CALL METHOD fields->(`IF_XCO_DBT_FIELDS~GET_NAMES`)
*      RECEIVING
*        rt_names = <Names>.
*
*    LOOP AT <Names> ASSIGNING <name>.
*
*      CLEAR t_param.
*
*      INSERT VALUE #( name  = `IV_NAME`
*                      kind  = cl_abap_objectdescr=>exporting
*                      value = REF #( <name> ) ) INTO TABLE t_param.
*      INSERT VALUE #( name  = `RO_FIELD`
*                      kind  = cl_abap_objectdescr=>receiving
*                      value = REF #( field ) ) INTO TABLE t_param.
*
*      CALL METHOD db->(`IF_XCO_DATABASE_TABLE~FIELD`)
*        PARAMETER-TABLE t_param.
*
*      ASSIGN t_param[ name = `RO_FIELD` ] TO FIELD-SYMBOL(<line>).
*      IF <line> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*      ASSIGN <line>-value->* TO <fiel>.
*      IF <fiel> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*
*      CALL METHOD <fiel>->(`IF_XCO_DBT_FIELD~CONTENT`)
*        RECEIVING
*          ro_content = content.
*
*      CREATE DATA r_content TYPE (`IF_XCO_DBT_FIELD_CONTENT=>TS_CONTENT`).
*      ASSIGN r_content->* TO FIELD-SYMBOL(<Content>) CASTING TYPE (`IF_XCO_DBT_FIELD_CONTENT=>TS_CONTENT`).
*      IF <content> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*
*      CALL METHOD content->(`IF_XCO_DBT_FIELD_CONTENT~GET`)
*        RECEIVING
*          rs_content = <Content>.
*
*      ASSIGN COMPONENT `KEY_INDICATOR` OF STRUCTURE <content> TO FIELD-SYMBOL(<key>).
*      IF <key> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*      ASSIGN COMPONENT `SHORT_DESCRIPTION` OF STRUCTURE <content> TO FIELD-SYMBOL(<text>).
*      IF <text> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*      ASSIGN COMPONENT `TYPE` OF STRUCTURE <content> TO FIELD-SYMBOL(<type>).
*      IF <type> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*
*      type = <type>.
*
*      CALL METHOD type->(`IF_XCO_DBT_FIELD_TYPE~GET_DATA_ELEMENT`)
*        RECEIVING
*          ro_data_element = element.
*
*      IF <text> IS INITIAL.
*        <text> = <name>.
*      ENDIF.
*
*      ASSIGN element->(`IF_XCO_AD_OBJECT~NAME`) TO FIELD-SYMBOL(<rname>).
*      IF <rname> IS NOT ASSIGNED.
*        CONTINUE.
*      ENDIF.
*
*      IF sy-subrc = 0.
*        result = VALUE #( BASE result
*                          ( fieldname = <name> keyflag = <key> tabname = tab scrtext_s = <text> rollname = <rname> ) ).
*      ELSE.
*        result = VALUE #( BASE result
*                          ( fieldname = <name> keyflag = <key> tabname = tab scrtext_s = <text> rollname = <name> ) ).
*      ENDIF.
*
*      UNASSIGN <Content>.
*      UNASSIGN <key>.
*      UNASSIGN <Text>.
*      UNASSIGN <type>.
*      UNASSIGN <rname>.
*
*    ENDLOOP.

  ENDMETHOD.

  METHOD rtti_get_t_dfies_by_table_name.

    IF context_check_abap_cloud( ) IS NOT INITIAL.
      result = rtti_get_t_attri_on_cloud( table_name ).
    ELSE.
      result = rtti_get_t_attri_on_prem( table_name ).
    ENDIF.

  ENDMETHOD.

  METHOD context_check_abap_cloud.

    IF gv_check_cloud_cached = abap_true.
      result = gv_check_cloud.
      RETURN.
    ENDIF.

    TRY.
        cl_abap_typedescr=>describe_by_name( `T100` ).
        gv_check_cloud = abap_false.
      CATCH cx_root.
        gv_check_cloud = abap_true.
    ENDTRY.
    gv_check_cloud_cached = abap_true.
    result = gv_check_cloud.

  ENDMETHOD.


  METHOD rtti_get_type_kind.

    result = cl_abap_datadescr=>get_data_type_kind( val ).

  ENDMETHOD.

  METHOD rtti_get_t_attri_by_oref.

    DATA lo_obj_ref TYPE REF TO cl_abap_typedescr.
    DATA temp47 TYPE REF TO cl_abap_classdescr.
    lo_obj_ref = cl_abap_objectdescr=>describe_by_object_ref( val ).
    
    temp47 ?= lo_obj_ref.
    result = temp47->attributes.

  ENDMETHOD.

  METHOD rtti_check_clike.

    DATA lv_type TYPE string.
    lv_type = rtti_get_type_kind( val ).
    CASE lv_type.
      WHEN cl_abap_datadescr=>typekind_char OR
          cl_abap_datadescr=>typekind_clike OR
          cl_abap_datadescr=>typekind_csequence OR
          cl_abap_datadescr=>typekind_string.
        result = abap_true.
    ENDCASE.

  ENDMETHOD.

  METHOD msg_get_internal.

    DATA lv_kind TYPE string.
        FIELD-SYMBOLS <tab> TYPE ANY TABLE.
        FIELD-SYMBOLS <row> TYPE ANY.
          DATA lt_tab TYPE z2ui5_cl_sample_context=>ty_t_msg.
        DATA lt_attri TYPE abap_component_tab.
        DATA temp48 TYPE ty_s_msg.
        DATA ls_result LIKE temp48.
        DATA temp49 LIKE LINE OF lt_attri.
        DATA ls_attri LIKE REF TO temp49.
          FIELD-SYMBOLS <comp> TYPE any.
          DATA temp50 TYPE z2ui5_cl_sample_context=>ty_s_msg.
    lv_kind = rtti_get_type_kind( val ).
    CASE lv_kind.

      WHEN cl_abap_datadescr=>typekind_table.
        
        ASSIGN val TO <tab>.
        
        LOOP AT <tab> ASSIGNING <row>.
          
          lt_tab = msg_get_internal( <row> ).
          INSERT LINES OF lt_tab INTO TABLE result.
        ENDLOOP.

      WHEN cl_abap_datadescr=>typekind_struct1 OR cl_abap_datadescr=>typekind_struct2.

        IF val IS INITIAL.
          RETURN.
        ENDIF.

        IF check_is_rap_struct( val ) = abap_true.
          result = msg_get_rap( val ).
          RETURN.
        ENDIF.

        
        lt_attri = rtti_get_t_attri_by_any( val ).

        
        CLEAR temp48.
        
        ls_result = temp48.
        
        
        LOOP AT lt_attri REFERENCE INTO ls_attri.
          
          ASSIGN COMPONENT ls_attri->name OF STRUCTURE val TO <comp>.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          IF ls_attri->name = `ITEM`.
            lt_tab = msg_get_internal( <comp> ).
            INSERT LINES OF lt_tab INTO TABLE result.
            RETURN.
          ELSE.
            ls_result = msg_map( name = ls_attri->name val = <comp> is_msg = ls_result ).
          ENDIF.

        ENDLOOP.
        IF ls_result-text IS INITIAL AND ls_result-id IS NOT INITIAL.
          ls_result-id = to_upper( ls_result-id ).
          MESSAGE ID ls_result-id TYPE `I` NUMBER ls_result-no
                  WITH ls_result-v1 ls_result-v2 ls_result-v3 ls_result-v4
                  INTO ls_result-text.
        ENDIF.
        INSERT ls_result INTO TABLE result.

      WHEN cl_abap_datadescr=>typekind_oref.
        result = msg_get_by_oref( val ).

      WHEN OTHERS.

        IF rtti_check_clike( val ) IS NOT INITIAL.
          
          CLEAR temp50.
          temp50-text = val.
          INSERT temp50 INTO TABLE result.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD msg_get_by_oref.

    FIELD-SYMBOLS <comp> TYPE any.
        DATA temp51 TYPE REF TO cx_root.
        DATA lx LIKE temp51.
        DATA temp52 TYPE ty_s_msg.
        DATA ls_result LIKE temp52.
        DATA lt_attri_o TYPE abap_attrdescr_tab.
        DATA temp53 LIKE LINE OF lt_attri_o.
        DATA ls_attri_o LIKE REF TO temp53.
          DATA lv_name LIKE ls_attri_o->name.
        DATA obj TYPE REF TO object.
            DATA lr_tab TYPE REF TO data.
            FIELD-SYMBOLS <tab2> TYPE data.
            DATA lt_tab2 TYPE z2ui5_cl_sample_context=>ty_t_msg.

    TRY.
        
        temp51 ?= val.
        
        lx = temp51.
        
        CLEAR temp52.
        temp52-type = `E`.
        temp52-text = lx->get_text( ).
        
        ls_result = temp52.
        
        lt_attri_o = rtti_get_t_attri_by_oref( val ).
        
        
        LOOP AT lt_attri_o REFERENCE INTO ls_attri_o
             WHERE visibility = `U`.
          
          lv_name = ls_attri_o->name.
          ASSIGN val->(lv_name) TO <comp>.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
          ls_result = msg_map( name = ls_attri_o->name val = <comp> is_msg = ls_result ).
        ENDLOOP.
        INSERT ls_result INTO TABLE result.
      CATCH cx_root.

        
        obj = val.

        TRY.

            
            CREATE DATA lr_tab TYPE (`if_bali_log=>ty_item_table`).
            
            ASSIGN lr_tab->* TO <tab2>.

            CALL METHOD obj->(`IF_BALI_LOG~GET_ALL_ITEMS`)
              RECEIVING
                item_table = <tab2>.

            
            lt_tab2 = msg_get_internal( <tab2> ).
            INSERT LINES OF lt_tab2 INTO TABLE result.

          CATCH cx_root.

            TRY.

                CREATE DATA lr_tab TYPE (`BAPIRETTAB`).
                ASSIGN lr_tab->* TO <tab2>.

                CALL METHOD obj->(`ZIF_LOGGER~EXPORT_TO_TABLE`)
                  RECEIVING
                    rt_bapiret = <tab2>.

                lt_tab2 = msg_get_internal( <tab2> ).
                INSERT LINES OF lt_tab2 INTO TABLE result.

              CATCH cx_root.

                lt_attri_o = rtti_get_t_attri_by_oref( val ).
                LOOP AT lt_attri_o REFERENCE INTO ls_attri_o
                     WHERE visibility = `U`.
                  lv_name = ls_attri_o->name.
                  ASSIGN obj->(lv_name) TO <comp>.
                  IF sy-subrc <> 0.
                    CONTINUE.
                  ENDIF.
                  ls_result = msg_map( name = ls_attri_o->name val = <comp> is_msg = ls_result ).
                ENDLOOP.
                INSERT ls_result INTO TABLE result.

            ENDTRY.
        ENDTRY.
    ENDTRY.

  ENDMETHOD.

  METHOD msg_map.

    result = is_msg.
    CASE name.
      WHEN `ID` OR `MSGID`.
        result-id = val.
      WHEN `NO` OR `NUMBER` OR `MSGNO`.
        result-no = val.
      WHEN `MESSAGE` OR `TEXT`.
        result-text = val.
      WHEN `TYPE` OR `MSGTY` OR `M_SEVERITY`.
        result-type = val.
      WHEN `MESSAGE_V1` OR `MSGV1` OR `V1`.
        result-v1 = val.
      WHEN `MESSAGE_V2` OR `MSGV2` OR `V2`.
        result-v2 = val.
      WHEN `MESSAGE_V3` OR `MSGV3` OR `V3`.
        result-v3 = val.
      WHEN `MESSAGE_V4` OR `MSGV4` OR `V4`.
        result-v4 = val.
      WHEN `TIME_STMP`.
        result-timestampl = val.
    ENDCASE.

  ENDMETHOD.

  METHOD check_is_rap_struct.

    DATA lt_attri TYPE abap_component_tab.
    DATA temp54 LIKE LINE OF lt_attri.
    DATA ls_attri LIKE REF TO temp54.
      FIELD-SYMBOLS <tab> TYPE any.
          DATA temp55 TYPE REF TO cl_abap_tabledescr.
          DATA lo_tab LIKE temp55.
          DATA lo_line TYPE REF TO cl_abap_datadescr.
          DATA temp56 TYPE REF TO cl_abap_structdescr.
          DATA lt_comps TYPE abap_component_tab.
          DATA temp57 LIKE LINE OF lt_comps.
          DATA ls_comp LIKE REF TO temp57.
    lt_attri = rtti_get_t_attri_by_any( val ).

    
    
    LOOP AT lt_attri REFERENCE INTO ls_attri.
      CASE ls_attri->name.
        WHEN `%MSG` OR `%FAIL` OR `%OTHER`.
          result = abap_true.
          RETURN.
      ENDCASE.
    ENDLOOP.

    LOOP AT lt_attri REFERENCE INTO ls_attri.
      
      ASSIGN COMPONENT ls_attri->name OF STRUCTURE val TO <tab>.
      CHECK sy-subrc = 0.
      CHECK rtti_get_type_kind( <tab> ) = cl_abap_datadescr=>typekind_table.

      TRY.
          
          temp55 ?= cl_abap_typedescr=>describe_by_data( <tab> ).
          
          lo_tab = temp55.
          
          lo_line = lo_tab->get_table_line_type( ).
          CHECK lo_line->kind = cl_abap_typedescr=>kind_struct.
          
          temp56 ?= lo_line.
          
          lt_comps = temp56->get_components( ).
          
          
          LOOP AT lt_comps REFERENCE INTO ls_comp.
            IF ls_comp->name = `%MSG` OR ls_comp->name = `%FAIL`.
              result = abap_true.
              RETURN.
            ENDIF.
          ENDLOOP.
        CATCH cx_root ##NO_HANDLER.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.

  METHOD msg_get_rap.

    DATA lv_kind TYPE string.
    DATA lv_is_row TYPE abap_bool.
    DATA lt_attri TYPE abap_component_tab.
    DATA temp58 LIKE LINE OF lt_attri.
    DATA ls_attri LIKE REF TO temp58.
      FIELD-SYMBOLS <tab> TYPE any.
      FIELD-SYMBOLS <ftab> TYPE ANY TABLE.
      FIELD-SYMBOLS <row> TYPE ANY.
    lv_kind = rtti_get_type_kind( val ).
    IF lv_kind <> cl_abap_datadescr=>typekind_struct1
       AND lv_kind <> cl_abap_datadescr=>typekind_struct2.
      RETURN.
    ENDIF.

    
    msg_get_rap_row( EXPORTING val         = val
                               entity_name = entity_name
                     IMPORTING messages    = result
                               is_row      = lv_is_row ).
    IF lv_is_row = abap_true.
      RETURN.
    ENDIF.

    
    lt_attri = rtti_get_t_attri_by_any( val ).
    
    
    LOOP AT lt_attri REFERENCE INTO ls_attri.
      
      ASSIGN COMPONENT ls_attri->name OF STRUCTURE val TO <tab>.
      CHECK sy-subrc = 0.
      CHECK rtti_get_type_kind( <tab> ) = cl_abap_datadescr=>typekind_table.

      
      ASSIGN <tab> TO <ftab>.

      
      LOOP AT <ftab> ASSIGNING <row>.
        IF rtti_get_type_kind( <row> ) = cl_abap_datadescr=>typekind_oref.
          IF <row> IS NOT INITIAL.
            TRY.
                INSERT LINES OF msg_get_t( <row> ) INTO TABLE result.
              CATCH cx_root ##NO_HANDLER.
            ENDTRY.
          ENDIF.
        ELSE.
          INSERT LINES OF msg_get_rap( val         = <row>
                                       entity_name = ls_attri->name ) INTO TABLE result.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD msg_get_rap_row.
    DATA lt_meta TYPE z2ui5_cl_sample_context=>ty_t_name_value.
    FIELD-SYMBOLS <msg> TYPE any.
            DATA lt_one TYPE z2ui5_cl_sample_context=>ty_t_msg.
            FIELD-SYMBOLS <m> LIKE LINE OF lt_one.
    FIELD-SYMBOLS <fail> TYPE any.
      FIELD-SYMBOLS <cause> TYPE any.
        DATA lv_cause TYPE i.
        DATA lv_text TYPE string.
        DATA temp59 TYPE z2ui5_cl_sample_context=>ty_s_msg.

    CLEAR messages.
    is_row = abap_false.

    
    lt_meta = msg_get_rap_meta( val ).

    
    ASSIGN COMPONENT `%MSG` OF STRUCTURE val TO <msg>.
    IF sy-subrc = 0.
      is_row = abap_true.
      IF <msg> IS NOT INITIAL.
        TRY.
            
            lt_one = msg_get_t( <msg> ).
            
            LOOP AT lt_one ASSIGNING <m>.
              <m>-t_meta = lt_meta.
            ENDLOOP.
            INSERT LINES OF lt_one INTO TABLE messages.
          CATCH cx_root ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDIF.

    
    ASSIGN COMPONENT `%FAIL` OF STRUCTURE val TO <fail>.
    IF sy-subrc = 0.
      is_row = abap_true.
      
      ASSIGN COMPONENT `CAUSE` OF STRUCTURE <fail> TO <cause>.
      IF sy-subrc = 0.
        
        lv_cause = <cause>.
        
        lv_text = msg_get_rap_fail_text( lv_cause ).
        IF entity_name IS NOT INITIAL.
          lv_text = |{ entity_name }: { lv_text }|.
        ENDIF.
        
        CLEAR temp59.
        temp59-type = `E`.
        temp59-text = lv_text.
        temp59-t_meta = lt_meta.
        INSERT temp59 INTO TABLE messages.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD msg_get_rap_element.

    DATA lt_attri TYPE abap_component_tab.
    DATA temp60 LIKE LINE OF lt_attri.
    DATA ls_attri LIKE REF TO temp60.
      FIELD-SYMBOLS <flag> TYPE any.
    lt_attri = rtti_get_t_attri_by_any( val ).
    
    
    LOOP AT lt_attri REFERENCE INTO ls_attri.
      CHECK strlen( ls_attri->name ) > 9.
      CHECK ls_attri->name(9) = `%ELEMENT-`.
      
      ASSIGN COMPONENT ls_attri->name OF STRUCTURE val TO <flag>.
      CHECK sy-subrc = 0.
      CHECK <flag> IS NOT INITIAL.

      IF result IS INITIAL.
        result = ls_attri->name+9.
      ELSE.
        result = |{ result }, { ls_attri->name+9 }|.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD msg_get_rap_state_area.

    FIELD-SYMBOLS <sa> TYPE any.
    ASSIGN COMPONENT `%STATE_AREA` OF STRUCTURE val TO <sa>.
    IF sy-subrc = 0.
      result = <sa>.
    ENDIF.

  ENDMETHOD.

  METHOD msg_get_rap_action.

    DATA lt_attri TYPE abap_component_tab.
    DATA temp61 LIKE LINE OF lt_attri.
    DATA ls_attri LIKE REF TO temp61.
      FIELD-SYMBOLS <flag> TYPE any.
    lt_attri = rtti_get_t_attri_by_any( val ).
    
    
    LOOP AT lt_attri REFERENCE INTO ls_attri.
      CHECK strlen( ls_attri->name ) > 12.
      CHECK ls_attri->name(12) = `%OP-%ACTION-`.
      
      ASSIGN COMPONENT ls_attri->name OF STRUCTURE val TO <flag>.
      CHECK sy-subrc = 0.
      CHECK <flag> IS NOT INITIAL.
      result = ls_attri->name+12.
      RETURN.
    ENDLOOP.

  ENDMETHOD.

  METHOD msg_get_rap_pid.

    FIELD-SYMBOLS <pid> TYPE any.
    ASSIGN COMPONENT `%PID` OF STRUCTURE val TO <pid>.
    IF sy-subrc = 0.
      result = <pid>.
    ENDIF.

  ENDMETHOD.

  METHOD msg_get_rap_cid.

    FIELD-SYMBOLS <cid> TYPE any.
    ASSIGN COMPONENT `%CID` OF STRUCTURE val TO <cid>.
    IF sy-subrc = 0.
      result = <cid>.
    ENDIF.

  ENDMETHOD.

  METHOD msg_get_rap_tky.

    FIELD-SYMBOLS <tky> TYPE any.
    ASSIGN COMPONENT `%TKY` OF STRUCTURE val TO <tky>.
    IF sy-subrc <> 0 OR <tky> IS INITIAL.
      RETURN.
    ENDIF.
    result = msg_get_rap_flatten( <tky> ).

  ENDMETHOD.

  METHOD msg_get_rap_flatten.

    DATA lv_kind TYPE string.
    DATA lt_attri TYPE abap_component_tab.
    DATA temp62 LIKE LINE OF lt_attri.
    DATA ls_attri LIKE REF TO temp62.
      FIELD-SYMBOLS <comp> TYPE any.
      DATA lv_sub_kind TYPE string.
        DATA lv_sub TYPE string.
            DATA lv_str TYPE string.
    lv_kind = rtti_get_type_kind( val ).
    IF lv_kind <> cl_abap_datadescr=>typekind_struct1
       AND lv_kind <> cl_abap_datadescr=>typekind_struct2.
      RETURN.
    ENDIF.

    
    lt_attri = rtti_get_t_attri_by_any( val ).
    
    
    LOOP AT lt_attri REFERENCE INTO ls_attri.
      
      ASSIGN COMPONENT ls_attri->name OF STRUCTURE val TO <comp>.
      CHECK sy-subrc = 0.

      
      lv_sub_kind = rtti_get_type_kind( <comp> ).
      IF lv_sub_kind = cl_abap_datadescr=>typekind_struct1
         OR lv_sub_kind = cl_abap_datadescr=>typekind_struct2.
        
        lv_sub = msg_get_rap_flatten( <comp> ).
        IF lv_sub IS NOT INITIAL.
          IF result IS NOT INITIAL.
            result = |{ result }, |.
          ENDIF.
          result = |{ result }{ lv_sub }|.
        ENDIF.
      ELSEIF <comp> IS NOT INITIAL.
        TRY.
            
            lv_str = <comp>.
            IF result IS NOT INITIAL.
              result = |{ result }, |.
            ENDIF.
            result = |{ result }{ ls_attri->name }={ lv_str }|.
          CATCH cx_root ##NO_HANDLER.
        ENDTRY.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD msg_get_rap_meta.

    DATA lv TYPE string.
      DATA temp63 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
      DATA temp64 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
      DATA temp65 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
      DATA temp66 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
      DATA temp67 TYPE z2ui5_cl_sample_context=>ty_s_name_value.
      DATA temp68 TYPE z2ui5_cl_sample_context=>ty_s_name_value.

    lv = msg_get_rap_element( val ).
    IF lv IS NOT INITIAL.
      
      CLEAR temp63.
      temp63-n = `element`.
      temp63-v = lv.
      INSERT temp63 INTO TABLE result.
    ENDIF.

    lv = msg_get_rap_state_area( val ).
    IF lv IS NOT INITIAL.
      
      CLEAR temp64.
      temp64-n = `state_area`.
      temp64-v = lv.
      INSERT temp64 INTO TABLE result.
    ENDIF.

    lv = msg_get_rap_action( val ).
    IF lv IS NOT INITIAL.
      
      CLEAR temp65.
      temp65-n = `action`.
      temp65-v = lv.
      INSERT temp65 INTO TABLE result.
    ENDIF.

    lv = msg_get_rap_pid( val ).
    IF lv IS NOT INITIAL.
      
      CLEAR temp66.
      temp66-n = `pid`.
      temp66-v = lv.
      INSERT temp66 INTO TABLE result.
    ENDIF.

    lv = msg_get_rap_cid( val ).
    IF lv IS NOT INITIAL.
      
      CLEAR temp67.
      temp67-n = `cid`.
      temp67-v = lv.
      INSERT temp67 INTO TABLE result.
    ENDIF.

    lv = msg_get_rap_tky( val ).
    IF lv IS NOT INITIAL.
      
      CLEAR temp68.
      temp68-n = `tky`.
      temp68-v = lv.
      INSERT temp68 INTO TABLE result.
    ENDIF.

  ENDMETHOD.

  METHOD msg_get_rap_fail_text.

    DATA temp69 TYPE string.
    CASE cause.
      WHEN 0.
        temp69 = `Operation failed`.
      WHEN 1.
        temp69 = `Entity not found`.
      WHEN 2.
        temp69 = `Entity is locked`.
      WHEN 3.
        temp69 = `Authorization failure`.
      WHEN 4.
        temp69 = `Concurrent modification`.
      WHEN 5.
        temp69 = `Concurrent modification`.
      WHEN 6.
        temp69 = `Operation disabled`.
      WHEN 7.
        temp69 = `Operation forbidden`.
      WHEN 8.
        temp69 = `Semantic error`.
      WHEN 9.
        temp69 = `Determination failed`.
      WHEN 10.
        temp69 = `Permission denied`.
      WHEN 11.
        temp69 = `Validation failed`.
      WHEN OTHERS.
        temp69 = |Operation failed (cause code { cause })|.
    ENDCASE.
    result = temp69.

  ENDMETHOD.

ENDCLASS.
