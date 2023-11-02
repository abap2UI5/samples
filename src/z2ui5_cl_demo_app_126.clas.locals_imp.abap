*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS zcl_text_helper_99 DEFINITION
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA:
      mt_dd04t TYPE STANDARD TABLE OF dd04t WITH EMPTY KEY .
    CLASS-DATA:
      mt_t100 TYPE STANDARD TABLE OF t100 WITH EMPTY KEY .
    CLASS-DATA:
      MT_dd02t TYPE STANDARD TABLE OF dd02t WITH EMPTY KEY .


    CLASS-METHODS get_dd04t_l
      IMPORTING
        !iv_rollname  TYPE rollname
        !iv_langu     TYPE sy-langu OPTIONAL
      RETURNING
        VALUE(result) TYPE string .
    CLASS-METHODS get_dd04t
      IMPORTING
        !iv_type      TYPE char1 DEFAULT 'S'
        !iv_rollname  TYPE rollname
        !iv_langu     TYPE sy-langu OPTIONAL
      RETURNING
        VALUE(result) TYPE string .

    CLASS-METHODS get_dd02t
      IMPORTING
        !IV_tabname   TYPE string
        !iv_langu     TYPE sy-langu OPTIONAL
      RETURNING
        VALUE(result) TYPE string.

    CLASS-METHODS get_t100
    importing
     !iv_ARBGB type string
     !iv_MSGNR type string
        !iv_langu     TYPE sy-langu OPTIONAL
      RETURNING
        VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEXT_HELPER_99 IMPLEMENTATION.


  METHOD get_dd02t.

    IF iv_langu IS INITIAL.
      DATA(langu) = sy-langu.
    ENDIF.

    READ TABLE mt_dd02t INTO DATA(dd02t)
             WITH KEY tabname   = iv_tabname
                      ddlanguage = langu.
    IF sy-subrc NE 0.

      SELECT SINGLE * FROM dd02t INTO dd02t
                        WHERE tabname   = iv_tabname
                        AND   ddlanguage = langu.
      IF sy-subrc = 0.
        APPEND dd02t TO mt_dd02t.

      ELSE.

        SELECT SINGLE * FROM dd02t INTO dd02t
                        WHERE tabname   = iv_tabname
                        AND   ddlanguage = 'E'.
        IF sy-subrc = 0.
          APPEND dd02t TO mt_dd02t.
        ENDIF.
      ENDIF.

    ENDIF.

    IF dd02t IS NOT INITIAL.
      result = dd02t-ddtext.
    ELSE.
      result = iv_tabname.
    ENDIF.


  ENDMETHOD.


  METHOD get_dd04t.


    IF iv_langu IS INITIAL.
      DATA(langu) = sy-langu.
    ENDIF.


    READ TABLE mt_dd04t INTO DATA(dd04t)
             WITH KEY rollname   = iv_rollname
                      ddlanguage = langu.
    IF sy-subrc NE 0.

      SELECT SINGLE * FROM dd04t INTO dd04t
                        WHERE rollname   = iv_rollname
                        AND   ddlanguage = langu.
      IF sy-subrc = 0.
        APPEND dd04t TO mt_dd04t.

      ELSE.

        SELECT SINGLE * FROM dd04t INTO dd04t
                        WHERE rollname   = iv_rollname
                        AND   ddlanguage = 'E'.
        IF sy-subrc = 0.
          APPEND dd04t TO mt_dd04t.
        ENDIF.
      ENDIF.

    ENDIF.

    IF dd04t IS NOT INITIAL.
      CASE iv_type.
        WHEN 'S'."Feldbezeichner kurz
          result = dd04t-scrtext_s.
        WHEN 'M'."Feldbezeichner mittel
          result = dd04t-scrtext_m.
        WHEN 'L'."Feldbezeichner lang
          result = dd04t-scrtext_l.
        WHEN 'R'."Überschrift
          result = dd04t-reptext.
        WHEN 'D'."Kurzbeschreibung von Repository-Objekten
          result = dd04t-ddtext.
        WHEN ''.
          result = dd04t-scrtext_s.
        WHEN OTHERS.
          result = dd04t-scrtext_s.
      ENDCASE.
    ENDIF.

    IF result IS INITIAL.
      result = '???'.
    ENDIF.

  ENDMETHOD.


  METHOD get_dd04t_l.

    zcl_text_helper_99=>get_dd04t(
      EXPORTING
        iv_type     = 'L'
        iv_rollname = iv_rollname
        iv_langu    = iv_langu
      RECEIVING
        result      = result
    ).

  ENDMETHOD.


  METHOD get_t100.

      IF iv_langu IS INITIAL.
      DATA(langu) = sy-langu.
    ENDIF.

    READ TABLE mt_t100 INTO DATA(t100)
             WITH KEY arbgb   = iv_arbgb
                      msgnr   = iv_msgnr
                      SPRSL   = langu.
    IF sy-subrc NE 0.

      SELECT SINGLE * FROM t100 INTO t100
                        WHERE arbgb    = iv_arbgb
                        and   msgnr    = iv_msgnr
                        AND   SPRSL    = langu.
      IF sy-subrc = 0.
        APPEND t100 TO mt_t100.

      ELSE.

        SELECT SINGLE * FROM t100 INTO t100
                        WHERE arbgb   = iv_arbgb
                        and   msgnr   = iv_msgnr
                        AND   SPRSL   = 'E'.
        IF sy-subrc = 0.
          APPEND t100 TO mt_t100.
        ENDIF.
      ENDIF.

    ENDIF.

      result = t100-text.


  ENDMETHOD.
ENDCLASS.


CLASS lcl_demo_app_125 DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA mo_parent_view   TYPE REF TO z2ui5_cl_xml_view.

    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_value,
             val_1  TYPE string,
             val_2  TYPE string,
             val_3  TYPE string,
             val_4  TYPE string,
             val_5  TYPE string,
             val_6  TYPE string,
             val_7  TYPE string,
             val_8  TYPE string,
             val_9  TYPE string,
             val_10 TYPE string,
           END OF ty_s_value.


    DATA mv_search_value  TYPE string.
    DATA mt_table         TYPE REF TO data.
    DATA mt_comp          TYPE abap_component_tab.
    DATA mt_table_del     TYPE REF TO data.
    DATA ms_value         TYPE ty_s_value.
    DATA mv_table         TYPE string VALUE `USR01`.
    DATA mt_dfies         TYPE STANDARD TABLE OF dfies.
    DATA mv_activ_row     TYPE string.
    DATA mv_edit          TYPE abap_bool.

    METHODS get_xml
      RETURNING VALUE(result) TYPE REF TO z2ui5_cl_xml_view.
    METHODS set_xml
      IMPORTING
        !xml TYPE REF TO z2ui5_cl_xml_view.
    METHODS set_table
      IMPORTING
        !table TYPE string.

  PROTECTED SECTION.

    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.
    METHODS search.
    METHODS render_popup.
    METHODS get_data.
    METHODS set_row_id.
    METHODS popup_add_add.
    METHODS row_action_delete.
    METHODS get_dfies.
    METHODS row_action_edit.
    METHODS render_main.

  PRIVATE SECTION.
    METHODS data_to_table
      CHANGING
        row TYPE any.
    METHODS popup_add_edit.

    METHODS get_txt
      IMPORTING
                roll          TYPE string
                type          TYPE char1 OPTIONAL
      RETURNING VALUE(result) TYPE string.

    METHODS get_txt_l
      IMPORTING
                roll          TYPE string
      RETURNING VALUE(result) TYPE string.

    METHODS button_save.

    METHODS hlp_get_uuid
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.

CLASS lcl_demo_app_125 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

    ENDIF.

    on_event( ).

    render_main( ).

  ENDMETHOD.


  METHOD on_event.


    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'BUTTON_REFRESH'.

        get_data( ).
        client->view_model_update( ).

      WHEN 'BUTTON_SEARCH'.

        get_data( ).
        search( ).
        client->view_model_update( ).

      WHEN 'BUTTON_SAVE'.

        button_save( ).

      WHEN 'BUTTON_ADD'.

        mv_edit = abap_false.

        render_popup(  ).

        client->view_model_update( ).

      WHEN 'POPUP_ADD_ADD'.

        popup_add_add( ).

      WHEN 'POPUP_ADD_EDIT'.

        popup_add_edit( ).

      WHEN 'POPUP_INPUT_SCREEN'.

        CHECK mv_edit = abap_true.

      WHEN 'POPUP_ADD_CLOSE'.

        client->popup_destroy( ).


      WHEN 'ROW_ACTION_DELETE'.

        row_action_delete( ).

      WHEN 'ROW_ACTION_EDIT'.

        row_action_edit( ).

    ENDCASE.

  ENDMETHOD.

  METHOD button_save.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.
    FIELD-SYMBOLS <del> TYPE STANDARD TABLE.
    ASSIGN mt_table_del->* TO <del>.


    TRY.

        DATA(type_desc) = cl_abap_typedescr=>describe_by_name( mv_table ).
        DATA(struct_desc) = CAST cl_abap_structdescr( type_desc ).

        DATA(table_desc) = cl_abap_tabledescr=>create(
          p_line_type  = struct_desc
          p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        DATA: o_table TYPE REF TO data.
        CREATE DATA o_table TYPE HANDLE table_desc.

        FIELD-SYMBOLS <table> TYPE ANY TABLE.
        ASSIGN o_table->* TO <table>.

        MOVE-CORRESPONDING <del> TO <table>.

        IF <del> IS NOT INITIAL.

          DELETE (mv_table) FROM TABLE <table>.
          IF sy-subrc = 0.
            COMMIT WORK AND WAIT.
            CLEAR: mt_table_del.
          ENDIF.
        ENDIF.

        MOVE-CORRESPONDING <tab> TO <table>.

        MODIFY (mv_table) FROM TABLE <table>.
        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.

          client->message_toast_display( zcl_text_helper_99=>get_t100(
                                           iv_arbgb = '/SCWM/IT_DEVKIT'
                                           iv_msgnr = '012'   ) ).
        ENDIF.

        client->view_model_update( ).

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.



  METHOD popup_add_edit.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    READ TABLE <tab> ASSIGNING FIELD-SYMBOL(<row>) INDEX mv_activ_row.

    data_to_table( CHANGING row = <row> ).

  ENDMETHOD.



  METHOD data_to_table.

    DATA index TYPE int4.

    LOOP AT mt_dfies INTO DATA(dfies).

      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE row TO FIELD-SYMBOL(<value>).

      index = index + 1.

      DATA(val) = 'MS_VALUE-VAL_' && index.

      ASSIGN (val) TO FIELD-SYMBOL(<val>).

      IF <val> IS ASSIGNED AND <value> IS ASSIGNED.
        <value> = <val>.
      ENDIF.

    ENDLOOP.

    CLEAR: ms_value.

    set_row_id( ).
    client->popup_destroy( ).
    client->view_model_update( ).

  ENDMETHOD.



  METHOD row_action_edit.

    mv_edit = abap_true.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    DATA(lt_arg) = client->get( )-t_event_arg.
    READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.
    IF sy-subrc = 0.

      READ TABLE <tab> ASSIGNING FIELD-SYMBOL(<row>) INDEX ls_arg.
      IF sy-subrc = 0.

        mv_activ_row = ls_arg.

        LOOP AT mt_dfies INTO DATA(dfies).

          ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <row> TO FIELD-SYMBOL(<value>).

          DATA(val) = 'MS_VALUE-VAL_' && sy-tabix.

          ASSIGN (val) TO FIELD-SYMBOL(<val>).

          IF <val> IS ASSIGNED AND <value> IS ASSIGNED.
            <val> = <value>.
          ENDIF.

        ENDLOOP.

        render_popup(  ).

        client->view_model_update( ).

      ENDIF.
    ENDIF.

  ENDMETHOD.



  METHOD row_action_delete.

    DATA index TYPE int4.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    FIELD-SYMBOLS <del> TYPE STANDARD TABLE.
    ASSIGN mt_table_del->* TO <del>.

    DATA(t_arg) = client->get( )-t_event_arg.
    READ TABLE t_arg INTO DATA(ls_arg) INDEX 1.
    IF sy-subrc = 0.

      LOOP AT <tab> ASSIGNING FIELD-SYMBOL(<line>).

        index = index + 1.

        CHECK index = ls_arg.

        APPEND <line> TO <del>.
        DELETE <tab>.

      ENDLOOP.

      set_row_id(  ).
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.



  METHOD popup_add_add.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    APPEND INITIAL LINE TO <tab> ASSIGNING FIELD-SYMBOL(<row>).

    data_to_table( CHANGING row = <row> ).


  ENDMETHOD.




  METHOD on_init.

    get_data(  ).

    get_dfies( ).

    set_row_id(  ).


  ENDMETHOD.

  METHOD render_main.

    IF mo_parent_view IS INITIAL.

      DATA(view) = z2ui5_cl_xml_view=>factory( client )->shell( ).


      DATA(page) = view->page( title          = zcl_text_helper_99=>get_dd02t( mv_table )
                               navbuttonpress = client->_event( 'BACK' )
                               shownavbutton  = abap_true
                               class          = 'sapUiContentPadding' ).

    ELSE.

      page = mo_parent_view->get( `Page` ).

    ENDIF.

    page->header_content( )->scroll_container( height = '70%' vertical = abap_true ).

    FIELD-SYMBOLS <tab> TYPE any.
    ASSIGN mt_table->* TO <tab>.

    DATA(columns) = page->table(
                   growing    ='true'
                   width      ='auto'
                   items      = client->_bind( val = <tab> )
                   headertext = zcl_text_helper_99=>get_dd02t( mv_table )
                )->header_toolbar(
                )->overflow_toolbar(
                )->title(   level ='H1'
                            text = zcl_text_helper_99=>get_dd02t( mv_table )
                )->toolbar_spacer(
                )->search_field(
                                 value  = client->_bind_edit( mv_search_value )
                                 search = client->_event( 'BUTTON_SEARCH' )
                                 change = client->_event( 'BUTTON_SEARCH' )
                                 id     = `SEARCH`
                                 width  = '17.5rem'
                )->get_parent( )->get_parent(
                )->columns( ).


    LOOP AT mt_comp REFERENCE INTO DATA(comp).

      CHECK comp->name NE `MANDT`.



      READ TABLE mt_dfies INTO DATA(dfies) WITH KEY fieldname = comp->name.

      DATA(width) = COND #(  WHEN comp->name = 'ROW_ID' THEN '2rem' ELSE '' ).

      columns->column( width = width )->text( dfies-scrtext_s ).

    ENDLOOP.


    DATA(cells) = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type ='Navigation'
                                                            press = client->_event( val = 'ROW_ACTION_EDIT'
                                                                            t_arg = VALUE #( ( `${ROW_ID}`  ) ) )
                                       )->cells( ).

    LOOP AT mt_comp REFERENCE INTO comp.


      CHECK comp->name NE `MANDT`.

      READ TABLE mt_dfies INTO dfies WITH KEY fieldname = comp->name.

      DATA(text)  = COND #( WHEN dfies-keyflag = abap_false THEN '{' && comp->name && '}' ELSE '' ).
      DATA(title) = COND #( WHEN dfies-keyflag = abap_true  THEN '{' && comp->name && '}' ELSE '' ).


      cells->object_identifier( text  = text
                                title = title ).


    ENDLOOP.

    page->footer( )->overflow_toolbar(
                    )->toolbar_spacer(
                    )->button(
                        icon    = 'sap-icon://add'
                        text    =  get_txt( 'RSLPO_GUI_ADDPART' )
                        press   = client->_event( 'BUTTON_ADD' )
                        type    = 'Default'
                     )->button(
                        icon    = 'sap-icon://refresh'
                        text    = get_txt( '/SCMB/LOC_REFRESH' )
                        press   = client->_event( 'BUTTON_REFRESH' )
                        type    = 'Default'
                     )->button(
                        text    = get_txt( '/SCWM/DE_LM_LOGSAVE' )
                        press   = client->_event( 'BUTTON_SAVE' )
                        type    = 'Success' ).

    IF mo_parent_view IS INITIAL.

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

  METHOD hlp_get_uuid.

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

    result = uuid.

  ENDMETHOD.
  METHOD search.


    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.


    IF mv_search_value IS NOT INITIAL.

      LOOP AT <tab> ASSIGNING FIELD-SYMBOL(<f_row>).
        DATA(lv_row) = ``.
        DATA(lv_index) = 1.
        DO.
          ASSIGN COMPONENT lv_index OF STRUCTURE <f_row> TO FIELD-SYMBOL(<field>).
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE <tab>.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD get_data.

    DATA lo_struct          TYPE REF TO cl_abap_structdescr.
    DATA lo_tab             TYPE REF TO cl_abap_tabledescr.
    DATA selkz              TYPE boolean.
    DATA index              TYPE i.
    FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.

    DATA(o_type_desc) = cl_abap_typedescr=>describe_by_name( mv_table ).
    DATA(o_struct_desc) = CAST cl_abap_structdescr( o_type_desc ).
    DATA(comp) = o_struct_desc->get_components( ).

    TRY.

        mt_comp = VALUE cl_abap_structdescr=>component_table(
*                                                              ( name = 'SELKZ'
*                                                                type = CAST #( cl_abap_datadescr=>describe_by_data( selkz ) ) )
                                                              ( name = 'ROW_ID'
                                                                type = CAST #( cl_abap_datadescr=>describe_by_data( index ) ) ) ).

        APPEND LINES OF comp TO mt_comp.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( mt_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create(
          p_line_type  = new_struct_desc
          p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        DATA: o_table TYPE REF TO data.
        CREATE DATA o_table TYPE HANDLE new_table_desc.

        FIELD-SYMBOLS <table> TYPE ANY TABLE.
        ASSIGN o_table->* TO <table>.

        SELECT * FROM (mv_table) INTO CORRESPONDING FIELDS OF TABLE <table>.


        lo_tab ?= cl_abap_tabledescr=>describe_by_data( <table> ).
        CREATE DATA mt_table TYPE HANDLE lo_tab.
        ASSIGN mt_table->* TO <fs_tab>.
        <fs_tab> = <table>.


      CATCH cx_root.

    ENDTRY.

    set_row_id( ).


  ENDMETHOD.

  METHOD get_dfies.

*    DATA dfies TYPE STANDARD TABLE OF dfies.
*
*    " alle Texte zu der Tabelle lesen
*    CALL FUNCTION 'DDIF_FIELDINFO_GET'
*      EXPORTING
*        tabname        = CONV ddobjname( mv_table )
*        langu          = sy-langu
*      TABLES
*        dfies_tab      = mt_DFIES
*      EXCEPTIONS
*        not_found      = 1
*        internal_error = 2
*        OTHERS         = 3.
*    IF sy-subrc <> 0.
*    ENDIF.
*
*    " Notfall - Englishtexte dazulesen
*    CALL FUNCTION 'DDIF_FIELDINFO_GET'
*      EXPORTING
*        tabname        = CONV ddobjname( mv_table )
*        langu          = 'E'
*      TABLES
*        dfies_tab      = dfies
*      EXCEPTIONS
*        not_found      = 1
*        internal_error = 2
*        OTHERS         = 3.
*    IF sy-subrc <> 0.
*    ENDIF.


    DATA: lcl_abap_structdescr TYPE REF TO cl_abap_structdescr,
          lt_ddic_info         TYPE ddfields.

    FIELD-SYMBOLS: <ddic_info> TYPE LINE OF ddfields.

    lcl_abap_structdescr ?= cl_abap_structdescr=>describe_by_name( CONV ddobjname( mv_table ) ).

    lt_ddic_info = lcl_abap_structdescr->get_ddic_field_list( ).



    LOOP AT mt_dfies REFERENCE INTO DATA(d).

      READ TABLE lt_ddic_info REFERENCE INTO DATA(f) WITH KEY rollname = d->rollname.

      IF d->scrtext_s IS INITIAL.
        d->scrtext_s = f->scrtext_s.
      ENDIF.
      IF d->scrtext_m IS INITIAL.
        d->scrtext_m = f->scrtext_m.
      ENDIF.
      IF d->scrtext_l IS INITIAL.
        d->scrtext_l = f->scrtext_l.
      ENDIF.
      IF d->reptext IS INITIAL.
        d->reptext   = f->reptext.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD set_row_id.


    FIELD-SYMBOLS <line> TYPE any.
    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.

    LOOP AT <tab> ASSIGNING <line>.

      ASSIGN COMPONENT 'ROW_ID' OF STRUCTURE <line> TO FIELD-SYMBOL(<row>).
      IF <row> IS ASSIGNED.
        <row> = sy-tabix.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.




  METHOD render_popup.

    DATA index TYPE int4.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    DATA(title) = COND #( WHEN mv_edit = abap_true THEN get_txt( 'CRMST_UIU_EDIT' ) ELSE get_txt( 'RSLPO_GUI_ADDPART' ) ).

    DATA(simple_form) =  popup->dialog( title = title contentwidth = '40%'
          )->simple_form(
          title     = ''
          layout    = 'ResponsiveGridLayout'
          editable  = abap_true
          )->content( ns = 'form'
          ).

    " Gehe über alle Comps wenn wir im Edit sind dann sind keyfelder nicht eingabebereit.
    LOOP AT mt_comp REFERENCE INTO DATA(comp).

      READ TABLE mt_dfies INTO DATA(dfies) WITH KEY fieldname = comp->name.
      IF sy-subrc NE 0.
        dfies-scrtext_m = comp->name.
      ENDIF.

      CASE comp->name.
        WHEN 'SELKZ' OR 'ROW_ID'.

        WHEN OTHERS.

          index = index + 1.

          DATA(enabled) = COND #( WHEN dfies-keyflag = abap_true AND mv_edit = abap_true THEN abap_false ELSE abap_true ).
          DATA(visible) = COND #( WHEN dfies-fieldname = 'MANDT' THEN abap_false ELSE abap_true ).

          ASSIGN COMPONENT index OF STRUCTURE ms_value TO FIELD-SYMBOL(<val>).

          CHECK sy-subrc = 0.

          simple_form->label( text = dfies-scrtext_m
         )->input(
              value            = client->_bind_edit( <val> )
              showvaluehelp    = abap_false
              enabled          = enabled
              visible          = visible ).

      ENDCASE.

      CLEAR: dfies.

    ENDLOOP.

    DATA(event) =  COND #( WHEN mv_edit = abap_true THEN `POPUP_ADD_EDIT` ELSE `POPUP_ADD_ADD` ).


    DATA(toolbar) = simple_form->get_root( )->get_child(
         )->footer(
         )->overflow_toolbar( ).
    toolbar->toolbar_spacer(
     ).

    toolbar->button(
      text  = get_txt( 'BRF_TERMINATE_PS' )
      press = client->_event( 'POPUP_ADD_CLOSE' )
    ).

    IF mv_edit = abap_true.
      toolbar->button(
        text  = get_txt( 'MLCCS_D_XDELETE' )
        type  = 'Reject'
        icon  = 'sap-icon://delete'
        press = client->_event( val = 'ROW_ACTION_DELETE' t_arg = VALUE #( ( mv_activ_row ) ) ) ).
    ENDIF.

    toolbar->button(
      text  = get_txt( 'FB_TEXT_PROC_STATUS_SUCCSS_ALV' )
      press = client->_event( event )
      type  = 'Emphasized'
*     enabled = `{= $` && client->_bind_edit( mv_screen_name ) && ` !== '' && $` && client->_bind_edit( mv_screen_descr ) && ` !== '' }`
    ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD get_txt.

    zcl_text_helper_99=>get_dd04t(
      EXPORTING
        iv_rollname = CONV #( roll )
      RECEIVING
        result      = result ).

  ENDMETHOD.
  METHOD get_txt_l.

    zcl_text_helper_99=>get_dd04t(
      EXPORTING
        iv_rollname = CONV #( roll )
        iv_type     = 'L'
      RECEIVING
        result      = result ).

  ENDMETHOD.



  METHOD get_xml.

    result = mo_parent_view.

  ENDMETHOD.

  METHOD set_xml.

    mo_parent_view = xml.

  ENDMETHOD.

  METHOD set_table.

    mv_table = table.

  ENDMETHOD.

ENDCLASS.


CLASS lcL_demo_app_126 DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_selectedkey     TYPE string.
    DATA mv_selectedkey_TMP TYPE string.
    DATA mo_APP_SIMPLE_VIEW TYPE REF TO lcl_demo_app_125.


  PROTECTED SECTION.

    DATA client            TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .
    DATA mo_main_page      TYPE REF TO z2ui5_cl_xml_view.

    METHODS on_init.
    METHODS on_event.
    METHODS render_Main.

    METHODS get_count
      IMPORTING
        !tabname      TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.

ENDCLASS.



CLASS lcL_demo_app_126 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.



    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

         CREATE OBJECT mo_app_simple_view.


    ENDIF.


    on_event( ).


    CASE mv_selectedkey.

      WHEN space.

        render_Main( ).



      WHEN OTHERS.

        IF mv_selectedkey NE mv_selectedkey_tmp.

          CREATE OBJECT mo_app_simple_view.

        ENDIF.

        mo_app_simple_view->set_table( table = mv_selectedkey ).

        render_Main( ).

        mo_app_simple_view->mo_parent_view = mo_main_page.

        mo_app_simple_view->z2ui5_if_app~main( client = me->client ).

        mv_selectedkey_tmp = mv_selectedkey.

    ENDCASE.

    client->view_display( mo_main_page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'ONSELECTICONTABBAR'.

        CASE mv_selectedkey.

          WHEN space.


          WHEN OTHERS.

        ENDCASE.

      WHEN 'BACK'.
*        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

  ENDMETHOD.

  METHOD render_Main.

    DATA(view) = z2ui5_cl_xml_view=>factory( client )->shell( ).

    DATA(page) = view->page( id             = `page_main`
                             title          = 'Customizing'
                             navbuttonpress = client->_event( 'BACK' )
                             shownavbutton  = abap_true
                             class          = 'sapUiContentPadding' ).



    DATA(lo_items) = page->icon_tab_bar( class       = 'sapUiResponsiveContentPadding'
                                         selectedKey = client->_bind_edit( mv_selectedkey )
                                         select      = client->_event( val = 'ONSELECTICONTABBAR' )
                                                       )->items( ).



    lo_items->icon_tab_filter( icon      = 'sap-icon://along-stacked-chart'
                               iconcolor = 'Default'
                               count     = get_count( 'USR01' )
                               text      = 'User 01'
                               key       = 'USR01' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://popup-window'
                               iconcolor = 'Default'
                               count     = get_count( 'USR02' )
                               text      = 'User 02'
                               key       = 'USR02' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://filter-fields'
                               iconcolor = 'Default'
                               count     = get_count( 'USR03' )
                               text      = 'User 03'
                               key       = 'USR03' ).

    lo_items->icon_tab_filter( icon      = 'sap-icon://business-objects-mobile'
                               iconcolor = 'Default'
                               count     = get_count( 'USR04' )
                               text      = 'User 04'
                               key       = 'USR04' ).


    mo_main_page = lo_items.

  ENDMETHOD.

  METHOD get_count.

    DATA(o_type_desc) = cl_abap_typedescr=>describe_by_name( tabname ).
    DATA(o_struct_desc) = CAST cl_abap_structdescr( o_type_desc ).

    DATA(new_table_desc) = cl_abap_tabledescr=>create(
      p_line_type  = o_struct_desc
      p_table_kind = cl_abap_tabledescr=>tablekind_std ).

    DATA: o_table TYPE REF TO data.
    CREATE DATA o_table TYPE HANDLE new_table_desc.

    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    ASSIGN o_table->* TO <table>.

    SELECT * FROM (tabname) INTO CORRESPONDING FIELDS OF TABLE <table>.

    result = lines( <table> ).

  ENDMETHOD.

ENDCLASS.
