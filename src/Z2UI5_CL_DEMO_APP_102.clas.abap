CLASS z2ui5_CL_DEMO_APP_102 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA ms_shlp TYPE shlp_descr.

    TYPES:
      BEGIN OF ts_shlp_fields_xml,
        name        TYPE seoclsname,
        language    TYPE spras,
        description TYPE seodescr,
      END OF ts_shlp_fields_xml .


    DATA mv_check_initialized TYPE abap_bool .
    DATA:
      BEGIN OF ms_screen,
        selfield  TYPE string,
        selfield2 TYPE string,
      END OF ms_screen .
    DATA ms_shlp_fields TYPE ts_shlp_fields_xml .
    DATA ms_shlp_fields_xml TYPE ts_shlp_fields_xml .
    DATA:
      mt_shlp_result     TYPE STANDARD TABLE OF ts_shlp_fields_xml WITH EMPTY KEY,
      mt_shlp_result_xml TYPE STANDARD TABLE OF ts_shlp_fields_xml WITH EMPTY KEY.

    CLASS-METHODS generate_ddic_shlp
      IMPORTING
        !ir_parent                 TYPE REF TO z2ui5_cl_xml_view
        !ir_client                 TYPE REF TO z2ui5_if_client
        !ir_controller             TYPE REF TO object
        !iv_shlp_id                TYPE char30
        !iv_result_itab_name       TYPE clike
        !iv_result_itab_event      TYPE clike
        !iv_shlp_fields_struc_name TYPE clike .
    CLASS-METHODS select_ddic_shlp
      IMPORTING
        !ir_controller             TYPE REF TO object
        !iv_shlp_id                TYPE char30
        !iv_result_itab_name       TYPE clike
        !iv_shlp_fields_struc_name TYPE clike
        !iv_maxrows                TYPE i DEFAULT 150 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_102 IMPLEMENTATION.


  METHOD generate_ddic_shlp.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp             TYPE  shlp_descr,
          lv_grid_form_no     TYPE i,
          lt_arg              TYPE TABLE OF string,
          lv_arg_fieldname    TYPE string,
          lv_cell_fieldname   TYPE string,
          lv_path_result_itab TYPE string,
          lv_path_shlp_fields TYPE string,
          lt_fieldprop_sel    TYPE ddshfprops,
          lt_fieldprop_lis    TYPE ddshfprops.

    FIELD-SYMBOLS: <ls_fielddescr>    TYPE dfies,
                   <ls_fieldprop_sel> TYPE ddshfprop,
                   <ls_fieldprop_lis> TYPE ddshfprop,
                   <lt_result_itab>   TYPE ANY TABLE,
                   <ls_shlp_fields>   TYPE any,
                   <lv_field>         TYPE any.

* ---------- Get result itab reference ------------------------------------------------------------
    lv_path_result_itab = 'IR_CONTROLLER->' && iv_result_itab_name.
    ASSIGN (lv_path_result_itab) TO <lt_result_itab>.

* ---------- Get searchhelp input fields structure reference --------------------------------------
    lv_path_shlp_fields = 'IR_CONTROLLER->' && iv_shlp_fields_struc_name.
    ASSIGN (lv_path_shlp_fields) TO <ls_shlp_fields>.

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
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_1->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_1->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_1->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

        WHEN 2.
* ---------- Grid 2--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_2->label( <ls_fielddescr>-rollname ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_2->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_2->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_2->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

        WHEN 3.
* ---------- Grid 3--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_3->label( <ls_fielddescr>-rollname ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_3->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_3->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_3->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

        WHEN 4.
* ---------- Grid 4--------------------------------------------------------------------------------
* ---------- Set field label ----------------------------------------------------------------------
          lr_form_shlp_4->label( <ls_fielddescr>-rollname ).

* ---------- Set input field ----------------------------------------------------------------------
          CASE <ls_fielddescr>-datatype.
            WHEN 'DATS'.
              lr_form_shlp_4->date_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN 'TIMS'.
              lr_form_shlp_4->time_picker( value  = ir_client->_bind_edit( <lv_field> ) ).
            WHEN OTHERS.
              lr_form_shlp_4->input( value = ir_client->_bind_edit( <lv_field> ) ).
          ENDCASE.

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

      lr_columns->column( )->text( <ls_fielddescr>-rollname ).
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
        )->column_list_item( type = 'Navigation'  press = ir_client->_event( val    = iv_result_itab_event
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


  METHOD select_ddic_shlp.
*----------------------------------------------------------------------*
* LOCAL DATA DEFINITION
*----------------------------------------------------------------------*
    DATA: ls_shlp             TYPE shlp_descr,
          lv_path_result_itab TYPE string,
          lv_path_shlp_fields TYPE string,
          lt_return_values    TYPE TABLE OF ddshretval,
          lt_record_tab       TYPE TABLE OF seahlpres,
          lv_convexit_name    TYPE rs38l_fnam,
          lv_offset           TYPE i,
          lv_length           TYPE i,
          lt_fieldprop_sel    TYPE ddshfprops,
          lt_fieldprop_lis    TYPE ddshfprops.

    FIELD-SYMBOLS: <ls_fielddescr>    TYPE dfies,
                   <ls_record_tab>    TYPE seahlpres,
                   <lt_result>        TYPE STANDARD TABLE,
                   <ls_result>        TYPE any,
                   <ls_shlp_fields>   TYPE any,
                   <lv_field>         TYPE any,
                   <ls_fieldprop_sel> TYPE ddshfprop,
                   <ls_fieldprop_lis> TYPE ddshfprop.

* ---------- Get result itab reference ------------------------------------------------------------
    lv_path_result_itab = 'IR_CONTROLLER->' && iv_result_itab_name.
    ASSIGN (lv_path_result_itab) TO <lt_result>.

* ---------- Get searchhelp input fields structure reference --------------------------------------
    lv_path_shlp_fields = 'IR_CONTROLLER->' && iv_shlp_fields_struc_name.
    ASSIGN (lv_path_shlp_fields) TO <ls_shlp_fields>.

    IF <lt_result> IS NOT ASSIGNED OR
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
      UNASSIGN: <lv_field>, <ls_fielddescr>.

* ---------- Get corresponding field description --------------------------------------------------
      ASSIGN ls_shlp-fielddescr[ fieldname = <ls_fieldprop_sel>-fieldname ] TO <ls_fielddescr>.
      IF <ls_fielddescr> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

* ---------- Get reference of given fieldname -----------------------------------------------------
      ASSIGN COMPONENT <ls_fielddescr>-fieldname OF STRUCTURE <ls_shlp_fields> TO <lv_field>.

* ---------- In case no field found or the field is initial -> leave ------------------------------
      IF <lv_field> IS NOT ASSIGNED OR
         <lv_field> IS INITIAL.
        CONTINUE.
      ENDIF.

* ---------- Set filter criteria for given fieldname ----------------------------------------------
      APPEND VALUE #( shlpname = ls_shlp-shlpname shlpfield = <ls_fielddescr>-fieldname sign = 'I' option = 'CP' low = <lv_field> ) TO ls_shlp-selopt.
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
      APPEND INITIAL LINE TO <lt_result> ASSIGNING <ls_result>.

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
* -------------------------------------------------------------------------------------------------
* INITIALIZATION
* -------------------------------------------------------------------------------------------------
    IF me->mv_check_initialized = abap_false.
      me->mv_check_initialized = abap_true.


* -------------------------------------------------------------------------------------------------
* RENDERING
* -------------------------------------------------------------------------------------------------
* ---------- Set view -----------------------------------------------------------------------------
      DATA(lr_view) = z2ui5_cl_xml_view=>factory( client = client ).

      DATA(lr_page) = lr_view->page(
            title          = 'abap2UI5 - DDIC Searchhelp generator'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

      DATA(lr_grid) = lr_page->grid( 'L6 M12 S12'
              )->content( 'layout' ).

      lr_grid->simple_form( 'Input'
          )->content( 'form'
              )->label( 'Input with value help'
              )->input( value = client->_bind_edit( ms_screen-selfield )
                      showvaluehelp    = abap_true
                      valuehelprequest = client->_event( 'F4_POPUP_OPEN' )
              )->label( 'Input with value help from xml view class'
              )->input( value = client->_bind_edit( ms_screen-selfield2 )
                        showvaluehelp = abap_true
                        valuehelprequest = client->_event( 'F4_POPUP_OPEN_XML_VIEW' ) ).

* ---------- Set View -----------------------------------------------------------------------------
      client->view_display( lr_view->stringify( ) ).
    ENDIF.

* -------------------------------------------------------------------------------------------------
* EVENTS
* -------------------------------------------------------------------------------------------------
    CASE client->get( )-event.
      WHEN 'F4_POPUP_OPEN_XML_VIEW'.

        DATA(lr_popup1) = z2ui5_cl_xml_view=>factory_popup( client ).

* ---------- Create Dialog ------------------------------------------------------------------------
        DATA(lr_dialog1) = lr_popup1->dialog( title     = 'DDIC SHLP Generator'
                                            resizable = abap_true ).

** ---------- Create Popup content -----------------------------------------------------------------
*        DATA(lr_dialog_content1) = lr_dialog1->content( ).
*
** ---------- Create "Go" button -------------------------------------------------------------------
*        DATA(lr_toolbar1) = lr_dialog_content1->toolbar( ).
*        lr_toolbar1->toolbar_spacer( ).
*        lr_toolbar1->button(
*                      text    = 'Go'
*                      type    = 'Emphasized'
*                      press   = client->_event( 'F4_POPUP_GO_XML' )
*                 )->get_parent( ).

        "get shlp data
*        CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
*          EXPORTING
*            shlpname = 'SEO_CLASSES_INTERFACES'
*          IMPORTING
*            shlp     = ms_shlp.


*        lr_toolbar1 = lr_toolbar1->generate_ddic_shlp( irparent = lr_dialog_content1
        DATA(popup_f4) = lr_dialog1->zfc_ddic_search_help( irparent = lr_dialog1
                                                      irclient = client
                                                      resultitabevent = 'F4_POPUP_CLOSE_XML_VIEW'
                                                      resultitabname = 'MT_SHLP_RESULT_XML'
                                                      shlpfieldsstrucname = 'MS_SHLP_FIELDS_XML'
*                                                      isshlp = ms_shlp
                                                      shlpid = 'SEO_CLASSES_INTERFACES'
                                                      closebuttontext = `Close`
                                                      searchbuttontext = 'Search'
                                                      ircontroller = me
                                                      searchevent = 'F4_POPUP_GO_XML' ).
*       lr_dialog1->buttons( )->button(
*                      text    = 'Close'
*                      press   = client->_event( 'F4_POPUP_CLOSE_XML_VIEW' ) ).

        client->popup_display( lr_popup1->stringify( ) ).

      WHEN 'F4_POPUP_OPEN'.
* ---------- Create Popup -------------------------------------------------------------------------
        DATA(lr_popup) = z2ui5_cl_xml_view=>factory_popup( client ).

* ---------- Create Dialog ------------------------------------------------------------------------
        DATA(lr_dialog) = lr_popup->dialog( title     = 'DDIC SHLP Generator'
                                            resizable = abap_true ).

* ---------- Create Popup content -----------------------------------------------------------------
        DATA(lr_dialog_content) = lr_dialog->content( ).

* ---------- Create "Go" button -------------------------------------------------------------------
        DATA(lr_toolbar) = lr_dialog_content->toolbar( ).
        lr_toolbar->toolbar_spacer( ).
        lr_toolbar->button(
                      text    = 'Go'
                      type    = 'Emphasized'
                      press   = client->_event( 'F4_POPUP_GO' ) ).

* -------------------------------------------------------------------------------------------------
* Generate DDIC Searchfields
* -------------------------------------------------------------------------------------------------
        generate_ddic_shlp( ir_parent                 = lr_dialog_content
                            ir_client                 = client
                            ir_controller             = me
                            iv_shlp_id                = 'SEO_CLASSES_INTERFACES'
                            iv_result_itab_name       = 'MT_SHLP_RESULT'
                            iv_result_itab_event      = 'F4_POPUP_CLOSE'
                            iv_shlp_fields_struc_name = 'MS_SHLP_FIELDS' ).

* ---------- Create Button ------------------------------------------------------------------------
        lr_dialog->buttons( )->button(
                      text    = 'Close'
                      press   = client->_event( 'F4_POPUP_CLOSE' ) ).

* ---------- Display popup window -----------------------------------------------------------------
        client->popup_display( lr_popup->stringify( ) ).

      WHEN 'F4_POPUP_CLOSE'.
* ---------- Retrieve the event parameter ---------------------------------------------------------
        DATA(lt_arg) = client->get( )-t_event_arg.

* ---------- Set search field value ---------------------------------------------------------------
        IF line_exists( lt_arg[ 1 ] ).
          ms_screen-selfield = lt_arg[ 1 ].
          client->view_model_update( ).
        ENDIF.

        client->popup_destroy( ).

      WHEN 'F4_POPUP_CLOSE_XML_VIEW'.
* ---------- Retrieve the event parameter ---------------------------------------------------------
        DATA(lt_arg1) = client->get( )-t_event_arg.

* ---------- Set search field value ---------------------------------------------------------------
        IF line_exists( lt_arg1[ 1 ] ).
          ms_screen-selfield2 = lt_arg1[ 1 ].
          client->view_model_update( ).
        ENDIF.

        client->popup_destroy( ).

      WHEN 'F4_POPUP_GO'.
        CLEAR: me->mt_shlp_result.
* ---------- Fetch searchhelp result ----------------------------------------------------------
        select_ddic_shlp( ir_controller             = me
                          iv_shlp_id                = 'SEO_CLASSES_INTERFACES'
                          iv_result_itab_name       = 'MT_SHLP_RESULT'
                          iv_shlp_fields_struc_name = 'MS_SHLP_FIELDS' ).

* ---------- Update popup model binding -----------------------------------------------------------
        client->popup_model_update( ).

      WHEN 'F4_POPUP_GO_XML'.
        CLEAR: me->mt_shlp_result_xml.
* ---------- Fetch searchhelp result ----------------------------------------------------------
        select_ddic_shlp( ir_controller             = me
                          iv_shlp_id                = 'SEO_CLASSES_INTERFACES'
                          iv_result_itab_name       = 'MT_SHLP_RESULT_XML'
                          iv_shlp_fields_struc_name = 'MS_SHLP_FIELDS_XML' ).

* ---------- Update popup model binding -----------------------------------------------------------
        client->popup_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
