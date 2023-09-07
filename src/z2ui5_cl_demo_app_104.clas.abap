CLASS z2ui5_cl_demo_app_104 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ts_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ts_token .
    TYPES:
      tt_token TYPE STANDARD TABLE OF ts_token WITH EMPTY KEY .
    TYPES:
      tt_range TYPE RANGE OF string .
    TYPES:
      ts_range TYPE LINE OF tt_range .
    TYPES:
      BEGIN OF ts_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ts_filter_pop .
    TYPES:
      BEGIN OF ts_selopt_mapping,
        key   TYPE string,
        text  TYPE string,
        value TYPE string,
      END OF ts_selopt_mapping .
    TYPES:
      tt_selopt_mapping TYPE STANDARD TABLE OF ts_selopt_mapping WITH KEY key .

    DATA mv_check_initialized TYPE abap_bool .
    DATA mv_shlp_id TYPE char30 .
    DATA mv_popup_title TYPE string .
    DATA mv_shlp_result TYPE string .
    DATA mr_shlp_result TYPE REF TO data .
    DATA mr_shlp_fields TYPE REF TO data .
    DATA:
      mt_filter TYPE STANDARD TABLE OF ts_filter_pop WITH EMPTY KEY .
    DATA mt_mapping TYPE tt_selopt_mapping .
    CONSTANTS mc_evt_shlp_close TYPE string VALUE 'EVT_SHLP_CLOSE' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_go TYPE string VALUE 'EVT_SHLP_GO' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_open TYPE string VALUE 'EVT_SHLP_SELOPT_OPEN' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_token TYPE string VALUE 'EVT_SHLP_SELOPT_TOKEN' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_add TYPE string VALUE 'EVT_SHLP_SELOPT_ADD' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_cancel TYPE string VALUE 'EVT_SHLP_SELOPT_CANCEL' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_ok TYPE string VALUE 'EVT_SHLP_SELOPT_OK' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_delete TYPE string VALUE 'EVT_SHLP_SELOPT_DELETE' ##NO_TEXT.
    CONSTANTS mc_evt_shlp_selopt_delete_all TYPE string VALUE 'EVT_SHLP_SELOPT_DELETE_ALL' ##NO_TEXT.

    CLASS-METHODS factory
      IMPORTING
        !iv_shlp_id     TYPE clike
        !iv_popup_title TYPE clike
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_demo_app_104 .
  PROTECTED SECTION.

    DATA mv_selopt_fieldname TYPE string .

    METHODS on_rendering
      IMPORTING
        !ir_client TYPE REF TO z2ui5_if_client .
    METHODS on_event
      IMPORTING
        !ir_client TYPE REF TO z2ui5_if_client .
    METHODS generate_ddic_shlp
      IMPORTING
        !ir_parent  TYPE REF TO z2ui5_cl_xml_view
        !ir_client  TYPE REF TO z2ui5_if_client
        !iv_shlp_id TYPE char30 .
    METHODS select_ddic_shlp
      IMPORTING
        !ir_controller TYPE REF TO object
        !iv_shlp_id    TYPE char30
        !iv_maxrows    TYPE i DEFAULT 150 .
    METHODS build_data_ref
      IMPORTING
        !ir_client TYPE REF TO z2ui5_if_client .
    METHODS generate_ddic_shlp_selopt
      IMPORTING
        !ir_client    TYPE REF TO z2ui5_if_client
        !iv_fieldname TYPE clike
        !iv_shlp_id   TYPE char30 .
    METHODS get_shlp_range_by_value
      IMPORTING
        !iv_value        TYPE string
      RETURNING
        VALUE(rs_result) TYPE ts_range .
    METHODS get_shlp_uuid
      RETURNING
        VALUE(rv_result) TYPE string .
    METHODS get_selopt_mapping
      RETURNING
        VALUE(rt_mapping) TYPE tt_selopt_mapping .
    METHODS on_init
      IMPORTING
        !ir_client TYPE REF TO z2ui5_if_client .
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_104 IMPLEMENTATION.


  METHOD build_data_ref.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp        TYPE shlp_descr,
          lt_comp        TYPE cl_abap_structdescr=>component_table,
          lr_struct_type TYPE REF TO cl_abap_structdescr,
          lr_table_type  TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS: <ls_fielddescr> TYPE dfies,
                   <ls_comp>       LIKE LINE OF lt_comp.

* ---------- Get searchhelp description -----------------------------------------------------------
    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = me->mv_shlp_id
      IMPORTING
        shlp     = ls_shlp.

* -------------------------------------------------------------------------------------------------
* Build up search result component table
* -------------------------------------------------------------------------------------------------
    LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
      APPEND INITIAL LINE TO lt_comp ASSIGNING <ls_comp>.
      <ls_comp>-name = <ls_fielddescr>-fieldname.
      <ls_comp>-type ?= cl_abap_datadescr=>describe_by_name( <ls_fielddescr>-rollname ).
    ENDLOOP.

* ---------- Create Dynamic table using component table -------------------------------------------
    lr_struct_type = cl_abap_structdescr=>create( lt_comp ).
    lr_table_type  = cl_abap_tabledescr=>create( p_line_type = lr_struct_type ).

* ---------- Create Dynamic Internal table --------------------------------------------------------
    CREATE DATA me->mr_shlp_result TYPE HANDLE lr_table_type.

    CLEAR: lt_comp, lr_struct_type,lr_table_type.
    UNASSIGN: <ls_comp>.

* -------------------------------------------------------------------------------------------------
* Build up search fields component table
* -------------------------------------------------------------------------------------------------
    DATA: lt_token TYPE tt_token.

    LOOP AT ls_shlp-fielddescr ASSIGNING <ls_fielddescr>.
      APPEND INITIAL LINE TO lt_comp ASSIGNING <ls_comp>.
      <ls_comp>-name = <ls_fielddescr>-fieldname.
      <ls_comp>-type ?= cl_abap_datadescr=>describe_by_data( lt_token ).
    ENDLOOP.

* ---------- Create structure using component table -----------------------------------------------
    lr_struct_type = cl_abap_structdescr=>create( lt_comp ).

* ---------- Create Dynamic structure -------------------------------------------------------------
    CREATE DATA me->mr_shlp_fields TYPE HANDLE lr_struct_type.






  ENDMETHOD.


  METHOD factory.

    result = NEW #( ).

    result->mv_shlp_id      = iv_shlp_id.
    result->mv_popup_title  = iv_popup_title.
  ENDMETHOD.


  METHOD generate_ddic_shlp.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp           TYPE  shlp_descr,
          lv_grid_form_no   TYPE i,
          lt_arg            TYPE TABLE OF stringval,
          lv_arg_fieldname  TYPE stringval,
          lv_cell_fieldname TYPE stringval,
          lt_fieldprop_sel  TYPE ddshfprops,
          lt_fieldprop_lis  TYPE ddshfprops.

    FIELD-SYMBOLS: <ls_fielddescr>    TYPE dfies,
                   <ls_fieldprop_sel> TYPE ddshfprop,
                   <ls_fieldprop_lis> TYPE ddshfprop,
                   <lt_result_itab>   TYPE ANY TABLE,
                   <ls_shlp_fields>   TYPE any,
                   <lv_field>         TYPE any.

* ---------- Get result itab reference ------------------------------------------------------------
    ASSIGN me->mr_shlp_result->* TO <lt_result_itab>.

* ---------- Get searchhelp input fields structure reference --------------------------------------
    ASSIGN me->mr_shlp_fields->* TO <ls_shlp_fields>.

    IF  <lt_result_itab>  IS NOT ASSIGNED OR
        <ls_shlp_fields>  IS NOT ASSIGNED.
      RETURN.
    ENDIF.

* ---------- Get searchhelp description -----------------------------------------------------------
    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = iv_shlp_id
      IMPORTING
        shlp     = ls_shlp.

* ---------- Set Selection and List properties ----------------------------------------------------
    lt_fieldprop_sel = ls_shlp-fieldprop.
    lt_fieldprop_lis = ls_shlp-fieldprop.
    DELETE lt_fieldprop_sel WHERE shlpselpos IS INITIAL.
    DELETE lt_fieldprop_lis WHERE shlplispos IS INITIAL.
    SORT lt_fieldprop_sel BY shlpselpos.
    SORT lt_fieldprop_lis BY shlplispos.

* -------------------------------------------------------------------------------------------------
* Searchfield Grid
* -------------------------------------------------------------------------------------------------
    DATA(lr_grid_shlp) = ir_parent->grid( 'L3 M3 S3' )->content( 'layout' ).

* ---------- Create 4 forms (grid columns) --------------------------------------------------------
    DATA(lr_form_shlp_1) = lr_grid_shlp->simple_form( )->content( 'form' ).
    DATA(lr_form_shlp_2) = lr_grid_shlp->simple_form( )->content( 'form' ).
    DATA(lr_form_shlp_3) = lr_grid_shlp->simple_form( )->content( 'form' ).
    DATA(lr_form_shlp_4) = lr_grid_shlp->simple_form( )->content( 'form' ).

    LOOP AT lt_fieldprop_sel ASSIGNING <ls_fieldprop_sel>.
* ---------- Init loop data -----------------------------------------------------------------------
      UNASSIGN: <lv_field>, <ls_fielddescr>.

* ---------- Get corresponding field description --------------------------------------------------
      ASSIGN ls_shlp-fielddescr[ fieldname = <ls_fieldprop_sel>-fieldname ] TO <ls_fielddescr>.
      IF <ls_fielddescr> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

* ---------- Get field reference ------------------------------------------------------------------
      ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_shlp_fields> TO <lv_field>.
      IF <lv_field> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

* ---------- Determine grid form number -----------------------------------------------------------
      IF lv_grid_form_no IS INITIAL.
        lv_grid_form_no = 1.
      ELSEIF lv_grid_form_no = 4.
        lv_grid_form_no = 1.
      ELSE.
        lv_grid_form_no = lv_grid_form_no + 1.
      ENDIF.

      CASE lv_grid_form_no.
        WHEN 1.
* ---------- Grid 1--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_1->label( <ls_fielddescr>-scrtext_l ).

* ---------- Set input field ----------------------------------------------------------------------
          lr_form_shlp_1->multi_input(  tokens            = ir_client->_bind_local( <lv_field> )
                                        showclearicon     = abap_true
                                        valuehelprequest  = ir_client->_event( val    = mc_evt_shlp_selopt_open
                                                                               t_arg  = VALUE #( (  CONV #( <ls_fieldprop_sel>-fieldname ) ) ) )
                                        )->item(  key  = `{KEY}`
                                                  text = `{TEXT}`
                                                  )->tokens( )->token(  key      = `{KEY}`
                                                                        text     = `{TEXT}`
                                                                        visible  = `{VISIBLE}`
                                                                        selected = `{SELKZ}`
                                                                        editable = `{EDITABLE}` ).
        WHEN 2.
* ---------- Grid 2--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_2->label( <ls_fielddescr>-scrtext_l ).

* ---------- Set input field ----------------------------------------------------------------------
          lr_form_shlp_2->multi_input(  tokens            = ir_client->_bind_local( <lv_field> )
                                        showclearicon     = abap_true
                                        valuehelprequest  = ir_client->_event( val    = mc_evt_shlp_selopt_open
                                                                               t_arg  = VALUE #( (  CONV #( <ls_fieldprop_sel>-fieldname ) ) ) )
                                        )->item(  key  = `{KEY}`
                                                  text = `{TEXT}`
                                                  )->tokens( )->token(  key      = `{KEY}`
                                                                        text     = `{TEXT}`
                                                                        visible  = `{VISIBLE}`
                                                                        selected = `{SELKZ}`
                                                                        editable = `{EDITABLE}` ).

        WHEN 3.
* ---------- Grid 3--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_3->label( <ls_fielddescr>-scrtext_l ).

* ---------- Set input field ----------------------------------------------------------------------
          lr_form_shlp_3->multi_input(  tokens            = ir_client->_bind_local( <lv_field> )
                                        showclearicon     = abap_true
                                        valuehelprequest  = ir_client->_event( val    = mc_evt_shlp_selopt_open
                                                                               t_arg  = VALUE #( (  CONV #( <ls_fieldprop_sel>-fieldname ) ) ) )
                                        )->item(  key  = `{KEY}`
                                                  text = `{TEXT}`
                                                  )->tokens( )->token(  key      = `{KEY}`
                                                                        text     = `{TEXT}`
                                                                        visible  = `{VISIBLE}`
                                                                        selected = `{SELKZ}`
                                                                        editable = `{EDITABLE}` ).

        WHEN 4.
* ---------- Grid 4--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_4->label( <ls_fielddescr>-scrtext_l ).

* ---------- Set input field ----------------------------------------------------------------------
          lr_form_shlp_4->multi_input(  tokens            = ir_client->_bind_local( <lv_field> )
                                        showclearicon     = abap_true
                                        valuehelprequest  = ir_client->_event( val    = mc_evt_shlp_selopt_open
                                                                               t_arg  = VALUE #( (  CONV #( <ls_fieldprop_sel>-fieldname ) ) ) )
                                        )->item(  key  = `{KEY}`
                                                  text = `{TEXT}`
                                                  )->tokens( )->token(  key      = `{KEY}`
                                                                        text     = `{TEXT}`
                                                                        visible  = `{VISIBLE}`
                                                                        selected = `{SELKZ}`
                                                                        editable = `{EDITABLE}` ).
      ENDCASE.
    ENDLOOP.

* ---------- Create table -------------------------------------------------------------------------
    DATA(lr_table) = ir_parent->table( items = ir_client->_bind_edit( <lt_result_itab> ) ).
* ---------- Create Columns -----------------------------------------------------------------------
    DATA(lr_columns) = lr_table->columns( ).

* ---------- Set column ---------------------------------------------------------------------------
    LOOP AT lt_fieldprop_lis ASSIGNING <ls_fieldprop_lis>.
* ---------- Init loop data -----------------------------------------------------------------------
      UNASSIGN: <ls_fielddescr>.

* ---------- Get corresponding field description --------------------------------------------------
      ASSIGN ls_shlp-fielddescr[ fieldname = <ls_fieldprop_lis>-fieldname ] TO <ls_fielddescr>.
      IF <ls_fielddescr> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      lr_columns->column( )->text( <ls_fielddescr>-scrtext_l ).
    ENDLOOP.

* ---------- Build export parameter list ----------------------------------------------------------
    LOOP AT lt_fieldprop_lis ASSIGNING <ls_fieldprop_lis> WHERE shlpoutput = abap_true.
* ---------- Init loop data -----------------------------------------------------------------------
      CLEAR: lv_arg_fieldname.

* ---------- Build parameter name -----------------------------------------------------------------
      lv_arg_fieldname = `${` && <ls_fieldprop_lis>-fieldname && `}`.

* ---------- Collect output fields ----------------------------------------------------------------
      APPEND lv_arg_fieldname TO lt_arg.
    ENDLOOP.

    DATA(lr_item) = lr_table->items(
        )->column_list_item( type = 'Navigation'  press = ir_client->_event( val    = mc_evt_shlp_close
                                                                             t_arg  = lt_arg ) ).

* ---------- Set cell content ---------------------------------------------------------------------
    LOOP AT lt_fieldprop_lis ASSIGNING <ls_fieldprop_lis>.
* ---------- Init loop data -----------------------------------------------------------------------
      CLEAR: lv_cell_fieldname.

* ---------- Build cell name ----------------------------------------------------------------------
      lv_cell_fieldname = `{` && <ls_fieldprop_lis>-fieldname && `}`.
      lr_item->cells( )->text( lv_cell_fieldname ).
    ENDLOOP.
  ENDMETHOD.


  METHOD generate_ddic_shlp_selopt.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp       TYPE  shlp_descr,
          ls_fielddescr TYPE dfies.

* ---------- Get searchhelp description -----------------------------------------------------------
    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = iv_shlp_id
      IMPORTING
        shlp     = ls_shlp.

* ---------- Get field description for given searchhelp field -------------------------------------
    SELECT SINGLE * FROM @ls_shlp-fielddescr AS fielddescr ##ITAB_KEY_IN_SELECT
                    WHERE fieldname = @iv_fieldname
                    INTO @ls_fielddescr.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

* ---------- Create Popup -------------------------------------------------------------------------
    DATA(lr_popup) = z2ui5_cl_xml_view=>factory_popup( ir_client ).

* ---------- Create Dialog ------------------------------------------------------------------------
    DATA(lr_dialog) = lr_popup->dialog( contentheight = `50%`
                                  contentwidth = `50%`
                                  title = TEXT-t02 ).

* ---------- Create Vbox --------------------------------------------------------------------------
    DATA(lr_vbox) = lr_dialog->content( )->vbox( height = `100%` justifycontent = 'SpaceBetween' ).

* ---------- Create Panel -------------------------------------------------------------------------
    DATA(lr_panel)  = lr_vbox->panel( expandable = abap_false
                                      expanded   = abap_true
                                      headertext = ir_client->_bind_local( ls_fielddescr-scrtext_l ) ).

* ---------- Create List item ---------------------------------------------------------------------
    DATA(lr_item) = lr_panel->list(
              nodata = `no conditions defined`
             items           = ir_client->_bind_edit( me->mt_filter )
                )->custom_list_item( ).

* ---------- Create grid --------------------------------------------------------------------------
    DATA(lr_grid) = lr_item->grid( ).

* ---------- Create Combobox ----------------------------------------------------------------------
    lr_grid->combobox(
                 selectedkey = `{OPTION}`
                 items       = ir_client->_bind_edit( me->mt_mapping )
             )->item( key = '{KEY}'
                      text = '{TEXT}' ).

* ---------- Create input field based on the data type --------------------------------------------
    CASE ls_fielddescr-datatype.
      WHEN 'DATS'.
        lr_grid->date_picker( value  = `{LOW}` ).
        lr_grid->date_picker( value = `{HIGH}`  enabled = `{= ${OPTION} === 'BT' }` ).
      WHEN 'TIMS'.
        lr_grid->time_picker( value  = `{LOW}` ).
        lr_grid->time_picker( value = `{HIGH}`  enabled = `{= ${OPTION} === 'BT' }` ).
      WHEN OTHERS.
        lr_grid->input( value = `{LOW}` ).
        lr_grid->input( value = `{HIGH}`  visible = `{= ${OPTION} === 'BT' }` ).
    ENDCASE.

    lr_grid->button( icon = 'sap-icon://decline'
                     type = `Transparent`
                     press = ir_client->_event( val = 'EVT_SHLP_SELOPT_DELETE' t_arg = VALUE #( ( `${KEY}` ) ) ) ).

    lr_panel->hbox( justifycontent = `End`
        )->button( text = `Add` icon = `sap-icon://add` press = ir_client->_event( val = 'EVT_SHLP_SELOPT_ADD' ) ).

* --------- Create footer buttons -----------------------------------------------------------------
    lr_dialog->buttons(
        )->button( text = `Delete All` icon = 'sap-icon://delete' type = `Transparent` press = ir_client->_event( val = 'EVT_SHLP_SELOPT_DELETE_ALL' )
        )->button( text  = 'OK' press = ir_client->_event( 'EVT_SHLP_SELOPT_OK' ) type  = 'Emphasized'
        )->button( text  = 'Cancel' press = ir_client->_event( 'EVT_SHLP_SELOPT_CANCEL' ) ).

* ---------- Display popup window -----------------------------------------------------------------
    ir_client->popup_display( lr_popup->stringify( ) ).
  ENDMETHOD.


  METHOD get_selopt_mapping.
    rt_mapping = VALUE #(
  (   key = 'EQ'
      text = TEXT-l01
      value = `={LOW}`    )

  (   key = 'LT'
      text = TEXT-l02
      value = `<{LOW}`   )

  (   key = 'LE'
      text = TEXT-l03
      value = `<={LOW}`  )

  (   key = 'GT'
      text = TEXT-l04
      value = `>{LOW}`   )

  (   key = 'GE'
      text = TEXT-l05
      value = `>={LOW}`  )

  (   key = 'CP'
      text = TEXT-l06
      value = `*{LOW}*`  )

  (   key = 'BT'
      text = TEXT-l07
      value = `{LOW}...{HIGH}` )

  (   key = 'NE'
      text = TEXT-l08
      value = `!(={LOW})`    )
  ).
  ENDMETHOD.


  METHOD get_shlp_range_by_value.
    DATA(lv_length) = strlen( iv_value ) - 1.
    CASE iv_value(1).
      WHEN `=`.
        rs_result = VALUE #( sign = `I` option = `EQ` low = iv_value+1 ).
      WHEN `<`.
        IF iv_value+1(1) = `=`.
          rs_result = VALUE #( sign = `I` option = `LE` low = iv_value+2 ).
        ELSE.
          rs_result = VALUE #( sign = `I` option = `LT` low = iv_value+1 ).
        ENDIF.
      WHEN `>`.
        IF iv_value+1(1) = `=`.
          rs_result = VALUE #( sign = `I` option = `GE` low = iv_value+2 ).
        ELSE.
          rs_result = VALUE #( sign = `I` option = `GT` low = iv_value+1 ).
        ENDIF.

      WHEN `*`.
        rs_result = VALUE #( sign = `I` option = `CP` low = iv_value ).

      WHEN OTHERS.
        IF iv_value CS '...'.
          SPLIT iv_value AT '...' INTO rs_result-low rs_result-high.
          rs_result-option = `BT`.
        ELSE.
          rs_result = VALUE #( sign = `I` option = `EQ` low = iv_value  ).
        ENDIF.

    ENDCASE.
  ENDMETHOD.


  METHOD get_shlp_uuid.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA uuid TYPE sysuuid_c32.

    TRY.
        CALL METHOD ('CL_SYSTEM_UUID')=>create_uuid_c32_static
          RECEIVING
            uuid = uuid.
      CATCH cx_sy_dyn_call_illegal_class.

        DATA(lv_fm) = 'GUID_CREATE'.
        CALL FUNCTION lv_fm
          IMPORTING
            ev_guid_32 = uuid.
    ENDTRY.

    rv_result = uuid.
  ENDMETHOD.


  METHOD on_event.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: lt_event_arg TYPE string_table,
          ls_range     TYPE ts_range.

    FIELD-SYMBOLS: <lt_field_token> TYPE STANDARD TABLE,
                   <ls_field_token> TYPE any,
                   <lv_field>       TYPE any,
                   <ls_filter>      TYPE ts_filter_pop,
                   <ls_shlp_fields> TYPE any.

* ---------- Get event parameters -----------------------------------------------------------------
    lt_event_arg = ir_client->get( )-t_event_arg.

    CASE ir_client->get( )-event.
      WHEN mc_evt_shlp_close.
* ---------- Set search field value ---------------------------------------------------------------
        IF line_exists( lt_event_arg[ 1 ] ).
          me->mv_shlp_result = lt_event_arg[ 1 ].
        ENDIF.

        ir_client->popup_destroy( ).
        ir_client->nav_app_leave( ir_client->get_app( ir_client->get( )-s_draft-id_prev_app_stack ) ).
        RETURN.
      WHEN mc_evt_shlp_go.
* ---------- Init search result first -------------------------------------------------------------
*        FIELD-SYMBOLS <any> TYPE any.
*        UNASSIGN <any>.
*        ASSIGN me->mr_shlp_result->* TO <any>.
*        IF <any> IS ASSIGNED.
*          CLEAR <any>.
*        ENDIF.
*        CLEAR: me->mr_shlp_result->*.

* ---------- Fetch searchhelp result --------------------------------------------------------------
        me->select_ddic_shlp( ir_controller             = me
                              iv_shlp_id                = me->mv_shlp_id ).

* ---------- Update popup model binding -----------------------------------------------------------
        ir_client->popup_model_update( ).

      WHEN mc_evt_shlp_selopt_open.

        IF NOT line_exists( lt_event_arg[ 1 ] ).
          RETURN.
        ENDIF.

* ---------- Set select-option field name and title -----------------------------------------------
        CLEAR: me->mv_selopt_fieldname.
        me->mv_selopt_fieldname = lt_event_arg[ 1 ].

* ---------- Get searchhelp input fields structure reference --------------------------------------
        ASSIGN me->mr_shlp_fields->* TO <ls_shlp_fields>.

        IF <ls_shlp_fields> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

* ---------- Assign current select-option field ---------------------------------------------------
        ASSIGN COMPONENT me->mv_selopt_fieldname OF STRUCTURE <ls_shlp_fields> TO <lt_field_token>.
        IF <lt_field_token> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

* ---------- Init select-option variables ---------------------------------------------------------
        CLEAR: me->mt_filter.

* ---------- Close searchhelp Popup window --------------------------------------------------------
        ir_client->popup_destroy( ).

        IF <lt_field_token> IS NOT INITIAL.
          LOOP AT <lt_field_token> ASSIGNING <ls_field_token>.

* ---------- Get key value from token -------------------------------------------------------------
            UNASSIGN: <lv_field>.
            ASSIGN COMPONENT 'KEY' OF STRUCTURE <ls_field_token> TO <lv_field>.
            IF <lv_field> IS NOT ASSIGNED.
              CONTINUE.
            ENDIF.

* ---------- Convert token into range format ------------------------------------------------------
            ls_range = me->get_shlp_range_by_value( iv_value = <lv_field> ).
            IF ls_range IS INITIAL.
              CONTINUE.
            ENDIF.

* ---------- Build new filter record --------------------------------------------------------------
            APPEND INITIAL LINE TO me->mt_filter ASSIGNING <ls_filter>.
            <ls_filter>-key     = me->get_shlp_uuid( ).
            <ls_filter>-option  = ls_range-option.
            <ls_filter>-low     = ls_range-low.
            <ls_filter>-high    = ls_range-high.

          ENDLOOP.
        ENDIF.
* ---------- Handle select-option popup opening ---------------------------------------------------
        me->generate_ddic_shlp_selopt( ir_client    = ir_client
                                       iv_fieldname = me->mv_selopt_fieldname
                                       iv_shlp_id   = me->mv_shlp_id ).

      WHEN mc_evt_shlp_selopt_token.
        ir_client->popup_model_update( ).

* ---------- Get searchhelp input fields structure reference --------------------------------------
        ASSIGN me->mr_shlp_fields->* TO <ls_shlp_fields>.

        IF <ls_shlp_fields> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

* ---------- Assign current select-option field ---------------------------------------------------
        ASSIGN COMPONENT me->mv_selopt_fieldname OF STRUCTURE <ls_shlp_fields> TO <lt_field_token>.
        IF <lt_field_token> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

      WHEN mc_evt_shlp_selopt_add.
        INSERT VALUE #( key = me->get_shlp_uuid( ) ) INTO TABLE me->mt_filter.

        ir_client->popup_model_update( ).

      WHEN mc_evt_shlp_selopt_cancel.
* ---------- Close select-option Popup window -----------------------------------------------------
        ir_client->popup_destroy( ).
* ---------- Handle searchhelp popup opening ------------------------------------------------------
        me->on_rendering( ir_client = ir_client ).

      WHEN mc_evt_shlp_selopt_ok.
* ---------- Get searchhelp input fields structure reference --------------------------------------
        ASSIGN me->mr_shlp_fields->* TO <ls_shlp_fields>.

        IF <ls_shlp_fields> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

        ASSIGN COMPONENT me->mv_selopt_fieldname OF STRUCTURE <ls_shlp_fields> TO <lt_field_token>.
        IF <lt_field_token> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

        CLEAR: <lt_field_token>.

* ---------- Fill token ---------------------------------------------------------------------------
        LOOP AT me->mt_filter REFERENCE INTO DATA(lr_filter).
          DATA(lv_value) = me->mt_mapping[ key = lr_filter->option ]-value.
          REPLACE `{LOW}`  IN lv_value WITH lr_filter->low.
          REPLACE `{HIGH}` IN lv_value WITH lr_filter->high.

          APPEND INITIAL LINE TO <lt_field_token> ASSIGNING <ls_field_token>.

          UNASSIGN: <lv_field>.
          ASSIGN COMPONENT 'KEY' OF STRUCTURE <ls_field_token> TO <lv_field>.
          IF <lv_field> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.
          <lv_field> = lv_value.

          UNASSIGN: <lv_field>.
          ASSIGN COMPONENT 'TEXT' OF STRUCTURE <ls_field_token> TO <lv_field>.
          IF <lv_field> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.
          <lv_field> = lv_value.

          UNASSIGN: <lv_field>.
          ASSIGN COMPONENT 'VISIBLE' OF STRUCTURE <ls_field_token> TO <lv_field>.
          IF <lv_field> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.
          <lv_field> = abap_true.

          UNASSIGN: <lv_field>.
          ASSIGN COMPONENT 'EDITABLE' OF STRUCTURE <ls_field_token> TO <lv_field>.
          IF <lv_field> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.
          <lv_field> = abap_false.

        ENDLOOP.

* ---------- Close select-option Popup window -----------------------------------------------------
        ir_client->popup_destroy( ).
* ---------- Handle searchhelp popup opening ------------------------------------------------------
        me->on_rendering( ir_client = ir_client ).

      WHEN mc_evt_shlp_selopt_delete.
        IF NOT line_exists( lt_event_arg[ 1 ] ).
          RETURN.
        ENDIF.

        DELETE me->mt_filter WHERE key = lt_event_arg[ 1 ].
        ir_client->popup_model_update( ).

      WHEN mc_evt_shlp_selopt_delete_all.
        me->mt_filter = VALUE #( ).
        ir_client->popup_model_update( ).
    ENDCASE.
  ENDMETHOD.


  METHOD on_init.
    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.

* ---------- Prefill select-option mapping table --------------------------------------------------
      me->mt_mapping = me->get_selopt_mapping( ).

* ---------- Build searchhelp data references -----------------------------------------------------
      me->build_data_ref( ir_client = ir_client ).

      IF me->mr_shlp_result IS NOT BOUND OR
         me->mr_shlp_fields IS NOT BOUND.
        RETURN.
      ENDIF.

      me->on_rendering( ir_client = ir_client ).
    ENDIF.


  ENDMETHOD.


  METHOD on_rendering.
* ---------- Create Popup -------------------------------------------------------------------------
    DATA(lr_popup) = z2ui5_cl_xml_view=>factory_popup( ir_client ).

* ---------- Create Dialog ------------------------------------------------------------------------
    DATA(lr_dialog) = lr_popup->dialog( title     = me->mv_popup_title
                                        resizable = abap_true ).

* ---------- Create Popup content -----------------------------------------------------------------
    DATA(lr_dialog_content) = lr_dialog->content( ).

* ---------- Create "Go" button -------------------------------------------------------------------
    DATA(lr_toolbar) = lr_dialog_content->toolbar( ).
    lr_toolbar->toolbar_spacer( ).
    lr_toolbar->button(
                  text    = TEXT-t01
                  type    = 'Emphasized'
                  press   = ir_client->_event( 'EVT_SHLP_GO' ) ).

* -------------------------------------------------------------------------------------------------
* Generate Partner Searchfield
* -------------------------------------------------------------------------------------------------
    me->generate_ddic_shlp( ir_parent                 = lr_dialog_content
                            ir_client                 = ir_client
                            iv_shlp_id                = me->mv_shlp_id ).

* ---------- Create Button ------------------------------------------------------------------------
    lr_dialog->buttons( )->button(
                  text    = TEXT-t00
                  press   = ir_client->_event( 'EVT_SHLP_CLOSE' ) ).

* ---------- Display popup window -----------------------------------------------------------------
    ir_client->popup_display( lr_popup->stringify( ) ).
  ENDMETHOD.


  METHOD select_ddic_shlp.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp          TYPE shlp_descr,
          lt_return_values TYPE TABLE OF ddshretval,
          lt_record_tab    TYPE TABLE OF seahlpres,
          lv_convexit_name TYPE rs38l_fnam,
          lv_offset        TYPE i,
          lv_length        TYPE i,
          lt_fieldprop_sel TYPE ddshfprops,
          lt_fieldprop_lis TYPE ddshfprops,
          ls_range         TYPE ts_range,
          lv_date_out      TYPE sy-datum,
          lv_time_out      TYPE sy-uzeit.

    FIELD-SYMBOLS: <ls_fielddescr>    TYPE dfies,
                   <ls_record_tab>    TYPE seahlpres,
                   <ls_result>        TYPE any,
                   <ls_shlp_fields>   TYPE any,
                   <lv_field>         TYPE any,
                   <lt_token>         TYPE tt_token,
                   <ls_token>         TYPE ts_token,
                   <ls_fieldprop_sel> TYPE ddshfprop,
                   <ls_fieldprop_lis> TYPE ddshfprop,
                   <lt_result_itab>   TYPE STANDARD TABLE.

* ---------- Get result itab reference ------------------------------------------------------------
    ASSIGN me->mr_shlp_result->* TO <lt_result_itab>.

* ---------- Get searchhelp input fields structure reference --------------------------------------
    ASSIGN me->mr_shlp_fields->* TO <ls_shlp_fields>.

    IF <lt_result_itab> IS NOT ASSIGNED OR
      <ls_shlp_fields> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

* ---------- Get searchhelp description -----------------------------------------------------------
    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = iv_shlp_id
      IMPORTING
        shlp     = ls_shlp.

* ---------- Set Selection and List properties ----------------------------------------------------
    lt_fieldprop_sel = ls_shlp-fieldprop.
    lt_fieldprop_lis = ls_shlp-fieldprop.
    DELETE lt_fieldprop_sel WHERE shlpselpos IS INITIAL.
    DELETE lt_fieldprop_lis WHERE shlplispos IS INITIAL.
    SORT lt_fieldprop_sel BY shlpselpos.
    SORT lt_fieldprop_lis BY shlplispos.

* ---------- Set filter criteria ------------------------------------------------------------------
    LOOP AT lt_fieldprop_sel ASSIGNING <ls_fieldprop_sel>.
* ---------- Init loop data -----------------------------------------------------------------------
      UNASSIGN: <lt_token>, <ls_token>, <ls_fielddescr>.

* ---------- Get corresponding field description --------------------------------------------------
      ASSIGN ls_shlp-fielddescr[ fieldname = <ls_fieldprop_sel>-fieldname ] TO <ls_fielddescr>.
      IF <ls_fielddescr> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

* ---------- Get reference of given fieldname -----------------------------------------------------
      ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_shlp_fields> TO <lt_token>.

* ---------- In case no field found or the field is initial -> leave ------------------------------
      IF <lt_token> IS NOT ASSIGNED OR
         <lt_token> IS INITIAL.
        CONTINUE.
      ENDIF.

* ---------- Set filter criteria for given fieldname ----------------------------------------------
      LOOP AT <lt_token> ASSIGNING <ls_token>.
* ---------- Init loop data -----------------------------------------------------------------------
        CLEAR: ls_range, lv_date_out.

* ---------- Convert token into range format ------------------------------------------------------
        ls_range = me->get_shlp_range_by_value( iv_value = <ls_token>-key ).
        IF ls_range IS INITIAL.
          CONTINUE.
        ENDIF.

* ---------- Convert date and time into internal format -------------------------------------------
        CASE <ls_fielddescr>-datatype.
          WHEN 'DATS'.
            CLEAR: lv_date_out.
            CALL FUNCTION 'CONVERSION_EXIT_DATLO_INPUT'
              EXPORTING
                input        = ls_range-low
              IMPORTING
                output       = lv_date_out
              EXCEPTIONS
                unknown_code = 1
                OTHERS       = 2.

            IF sy-subrc = 0.
              ls_range-low = lv_date_out.
            ELSE.
* ---------- Keep format --------------------------------------------------------------------------
            ENDIF.

            CLEAR: lv_date_out.
            CALL FUNCTION 'CONVERSION_EXIT_DATLO_INPUT'
              EXPORTING
                input        = ls_range-high
              IMPORTING
                output       = lv_date_out
              EXCEPTIONS
                unknown_code = 1
                OTHERS       = 2.

            IF sy-subrc = 0.
              ls_range-high = lv_date_out.
            ELSE.
* ---------- Keep format --------------------------------------------------------------------------
            ENDIF.

          WHEN 'TIMS'.
            CLEAR: lv_time_out.
            CALL FUNCTION 'CONVERSION_EXIT_TIME_INPUT'
              EXPORTING
                input                 = ls_range-low
              IMPORTING
                output                = lv_time_out
              EXCEPTIONS
                wrong_format_in_input = 1
                OTHERS                = 2.

            IF sy-subrc = 0.
              ls_range-low = lv_time_out.
            ELSE.
* ---------- Keep format --------------------------------------------------------------------------
            ENDIF.

            CLEAR: lv_time_out.
            CALL FUNCTION 'CONVERSION_EXIT_TIME_INPUT'
              EXPORTING
                input                 = ls_range-high
              IMPORTING
                output                = lv_time_out
              EXCEPTIONS
                wrong_format_in_input = 1
                OTHERS                = 2.

            IF sy-subrc = 0.
              ls_range-high = lv_time_out.
            ELSE.
* ---------- Keep format --------------------------------------------------------------------------
            ENDIF.
        ENDCASE.

        APPEND VALUE #( shlpname  = ls_shlp-shlpname
                        shlpfield = <ls_fielddescr>-fieldname
                        sign      = 'I'
                        option    = ls_range-option
                        low       = ls_range-low
                        high      = ls_range-high ) TO ls_shlp-selopt.
      ENDLOOP.
    ENDLOOP.

* ---------- Fetch data from searchhelp -----------------------------------------------------------
    CALL FUNCTION 'F4IF_SELECT_VALUES'
      EXPORTING
        shlp           = ls_shlp
        maxrows        = iv_maxrows
        call_shlp_exit = abap_true
      TABLES
        record_tab     = lt_record_tab
        return_tab     = lt_return_values.

* ---------- Map string into structure ------------------------------------------------------------
    LOOP AT lt_record_tab ASSIGNING <ls_record_tab>.
* ---------- Create initial result record ---------------------------------------------------------
      APPEND INITIAL LINE TO <lt_result_itab> ASSIGNING <ls_result>.

* ---------- Perform data mapping -----------------------------------------------------------------
      LOOP AT lt_fieldprop_lis ASSIGNING <ls_fieldprop_lis>.
* ---------- Init loop data -----------------------------------------------------------------------
        CLEAR: lv_convexit_name, lv_offset, lv_length.
        UNASSIGN: <lv_field>, <ls_fielddescr>.

* ---------- Get corresponding field description --------------------------------------------------
        ASSIGN ls_shlp-fielddescr[ fieldname = <ls_fieldprop_lis>-fieldname ] TO <ls_fielddescr>.
        IF <ls_fielddescr> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

* ---------- Assign target field ------------------------------------------------------------------
        ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_result> TO <lv_field>.
        IF <lv_field> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

* ---------- Set offset and length ---------------------------------------------------------------
        lv_offset = <ls_fielddescr>-offset / 2. "For any reason offset shows always double values ;-)
        lv_length = <ls_fielddescr>-leng.

* ---------- Map data via offset -----------------------------------------------------------------
        <lv_field> = <ls_record_tab>-string+lv_offset(lv_length).

* ---------- Set intial values for date and time (if needed) ---------------------------------------
        CASE <ls_fielddescr>-datatype.
          WHEN 'DATS'.
            IF <lv_field> = space.
              <lv_field> = '00000000'.
            ENDIF.
          WHEN 'TIMS'.
            IF <lv_field> = space.
              <lv_field> = '000000'.
            ENDIF.
        ENDCASE.

        IF <lv_field> IS INITIAL.
          CONTINUE.
        ENDIF.

* ---------- Perform conversion exit ---------------------------------------------------------------
        IF <ls_fielddescr>-convexit IS NOT INITIAL.
* ---------- Build conversion exit name ------------------------------------------------------------
          lv_convexit_name = 'CONVERSION_EXIT_' && <ls_fielddescr>-convexit && '_OUTPUT'.

* ---------- Check if conversion exit function module exists ---------------------------------------
          CALL FUNCTION 'FUNCTION_EXISTS'
            EXPORTING
              funcname           = lv_convexit_name
            EXCEPTIONS
              function_not_exist = 1
              OTHERS             = 2.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

* ---------- Execute conversion exit ---------------------------------------------------------------
          CALL FUNCTION lv_convexit_name
            EXPORTING
              input  = <lv_field>
            IMPORTING
              output = <lv_field>.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->on_init( ir_client = client ).

    me->on_event( ir_client = client ).

  ENDMETHOD.
ENDCLASS.
