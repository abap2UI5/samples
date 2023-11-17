class Z2UI5_CL_DEMO_APP_999 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ty_s_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ty_S_token .
  types:
    ty_t_token TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY .
  types:
    ty_t_range    TYPE RANGE OF string .
  types:
    ty_s_range    TYPE LINE OF ty_T_range .
  types:
    BEGIN OF ty_S_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_S_filter_pop .
  types:
    ty_t_filter_pop TYPE STANDARD TABLE OF ty_s_filter_pop WITH EMPTY KEY .
  types:
    BEGIN OF ty_s_fieldsdb,
SCREEN_NAME type char10,
FIELD   type char10,
FIELD_DOMA  type char10,
END OF ty_s_fieldsdb .
  types:
    ty_t_fieldsdb type STANDARD TABLE OF ty_s_fieldsdb with DEFAULT KEY .
  types:
    BEGIN OF ty_s_fields.
        INCLUDE TYPE ty_s_fieldsdb.
    TYPES: t_token  TYPE ty_t_token,
        t_filter TYPE ty_t_filter_pop,
      END OF ty_S_fields .
  types:
    begin of ty_s_var_val,
SCREEN_NAME type char10,
VAR     type     char10,
FIELD   type     char10,
GUID    type     string,
SIGN    type char1,
OPT     type char2,
LOW     type char255,
HIGH    type char255,
end of ty_s_var_val .
  types:
    ty_t_var_val type STANDARD TABLE OF ty_s_var_val with DEFAULT KEY .
  types:
    BEGIN OF ty_s_variants,
  screen_name type char10,
  var       type char10,
  descr     type string,
END OF ty_s_variants .
  types:
    ty_t_variants type STANDARD TABLE OF ty_s_variants with DEFAULT KEY .
  types:
    BEGIN OF ty_s_var_pop.
        INCLUDE TYPE ty_s_variants.
    TYPES: selkz TYPE xfeld,
      END OF ty_S_var_pop .
  types:
    BEGIN OF ty_s_screens,
  screen_name type char10,
  descr       type string,
END OF ty_s_screens .

  data:
    mt_filter       TYPE STANDARD TABLE OF ty_S_filter_pop WITH EMPTY KEY .
  data MT_MAPPING type Z2UI5_IF_CLIENT=>TY_T_NAME_VALUE .
  data:
    mt_screens      TYPE STANDARD TABLE OF ty_s_screens WITH EMPTY KEY .
  data:
    mt_variants     TYPE STANDARD TABLE OF ty_s_variants WITH EMPTY KEY .
  data:
    mt_variants_POP TYPE STANDARD TABLE OF ty_s_var_pop WITH EMPTY KEY .
  data MV_ACTIV_ELEMNT type STRING .
  data MV_SCREEN type STRING .
  data MV_BUTTON_ACTIVE type ABAP_BOOL .
  data MV_DESCRIPTION type STRING .
  data MV_SCREEN_DESCR type STRING .
  data MV_VARIANT type STRING .
  data MV_DESCRIPTION_COPY type STRING .
  data MV_VARIANT_COPY type STRING .
  data MO_PARENT_VIEW type ref to Z2UI5_CL_XML_VIEW .
  PROTECTED SECTION.





    METHODS on_init.

    METHODS on_event.

    METHODS render_main.

    METHODS render_POPUP_FILTER.

    METHODS get_fields.

    METHODS get_values.

    METHODS popup_filter_ok.

    METHODS render_pop_copy.

    METHODS get_variants.

    CLASS-METHODS hlp_get_range_by_value
      IMPORTING
        VALUE(value)  TYPE string
      RETURNING
        VALUE(result) TYPE ty_S_range.

    CLASS-METHODS hlp_get_uuid
      RETURNING
        VALUE(result) TYPE string.

    METHODS render_popup_varaint
      IMPORTING
        client TYPE REF TO z2ui5_if_client.





    METHODS popup_copy_save.

    METHODS set_token
      CHANGING
        field TYPE REF TO ty_s_fields.

    METHODS get_txt
      IMPORTING
                roll          TYPE string
                type          TYPE char1 OPTIONAL
      RETURNING VALUE(result) TYPE string.

    METHODS get_txt_l
      IMPORTING
                roll          TYPE string
      RETURNING VALUE(result) TYPE string.

    METHODS varaint_page.

  PRIVATE SECTION.

    DATA client            TYPE REF TO z2ui5_if_client.
    DATA mt_fields         TYPE STANDARD TABLE OF ty_s_fields WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_999 IMPLEMENTATION.


  METHOD GET_FIELDS.


DATA(db_fields) = value ty_t_fieldsdb(

( SCreen_name = 'INV'        FIELD =  'LGNUM'   FIELD_DOMA = '/SCWM/LGNUM'      )
( SCreen_name = 'LAGP'       FIELD =  'LGNUM'   FIELD_DOMA = '/SCWM/LGNUM'      )
( SCreen_name = 'LAGP'       FIELD =  'LGPLA'   FIELD_DOMA = '/SCWM/DE_LGPLA'   )
( SCreen_name = 'LAGP'       FIELD =  'LGTYP'   FIELD_DOMA = '/SCWM/DE_LGTYP'   )
( SCreen_name = 'QUAN'       FIELD =  'LGNUM'   FIELD_DOMA = '/SCWM/LGNUM'      )
( SCreen_name = 'QUAN'       FIELD =  'LGPLA'   FIELD_DOMA = '/SCWM/DE_LGPLA'   )
( SCreen_name = 'QUAN'       FIELD =  'MATNR'   FIELD_DOMA = '/SCWM/DE_MATNR'   )
( SCreen_name = 'QUAN'       FIELD =  'OWNER'   FIELD_DOMA = '/SCWM/DE_OWNER'   )
( SCreen_name = 'TO'         FIELD =  'LGNUM'   FIELD_DOMA = '/SCWM/LGNUM'      )
( SCreen_name = 'TO'         FIELD =  'MATNR'   FIELD_DOMA = '/SCWM/DE_MATNR'   )
( SCreen_name = 'TO'         FIELD =  'PROCTY'  FIELD_DOMA = '/SCWM/DE_PROCTY'  )
( SCreen_name = 'TO'         FIELD =  'TOSTAT'  FIELD_DOMA = '/SCWM/DE_TOSTAT'  )
( SCreen_name = 'TO'         FIELD =  'VLPLA'   FIELD_DOMA = '/SCWM/LTAP_VLPLA' )
).


    CLEAR: mt_fields.

    LOOP AT db_fields REFERENCE INTO DATA(lr_fields) WHERE screen_name = mv_screen.

      APPEND INITIAL LINE TO mt_fields REFERENCE INTO DATA(field).
     field->* = CORRESPONDING #( lr_fields->* ).

    ENDLOOP.


  ENDMETHOD.


  METHOD GET_TXT.

   result = 'Text'.

  ENDMETHOD.


  METHOD GET_TXT_L.

   result = 'Text'.

  ENDMETHOD.


  METHOD GET_VALUES.


    DATA(l_variants) = VALUE ty_t_variants(
    ( screen_name = 'QUAN'        var = 'E001 - ALL' descr = '123'                     )
    ( screen_name = 'TO'          var = 'E001'       descr = '123'                    )
    ( screen_name = 'TO'          var = 'E001 - All' descr = '123'  )
     ).


    DATA var TYPE ty_t_variants.

    LOOP AT l_variants INTO DATA(a)  WHERE screen_name = mv_screen
                                     AND   var         = mv_variant.

      APPEND a TO var.
      mv_description = a-descr.
    ENDLOOP.


DATA(var_vall_all) = value ty_t_var_val(
( SCREEN_NAME = 'LTAP'         VAR = 'E001 - All' FIELD = 'LGNUM'      GUID = '663192E9D70C1EEE8CC06B0F98CD81A3' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'LTAP'         VAR = 'E001 - All' FIELD = 'MATNR'      GUID = '663192E9D70C1EEE8CD4E9389CB11403' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'LTAP'         VAR = 'E001 - All' FIELD = 'TOSTAT'     GUID = '663192E9D70C1EEE8CC06BC66AD581A3' SIGN = 'I'   OPT = 'NE' )
( SCREEN_NAME = 'LTAP'         VAR = 'E002 - All' FIELD = 'LGNUM'      GUID = '663192E9D70C1EEE8CC06B0F98CD81A3' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'LTAP'         VAR = 'E002 - All' FIELD = 'MATNR'      GUID = '663192E9D70C1EEE8CD4E9389CB11403' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'LTAP'         VAR = 'E002 - All' FIELD = 'TOSTAT'     GUID = '663192E9D70C1EEE8CC06BC66AD581A3' SIGN = 'I'   OPT = 'NE' )
( SCREEN_NAME = 'QUAN'         VAR = 'E001 - ALL' FIELD = 'LGNUM'      GUID = '663192E9D70C1EEE90CEE2FA658C51EE' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'QUAN'         VAR = 'E001 - ALL' FIELD = 'LGPLA'      GUID = '663192E9D70C1EEE90CEEF4750FD91EE' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'TO'           VAR = 'E001      ' FIELD = 'LGNUM'      GUID = '663192E9D70C1EEE8E87DE5FF8CC512A' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'TO'           VAR = 'E001      ' FIELD = 'PROCTY'     GUID = '663192E9D70C1EEE8E87DD8D1EB8C7F5' SIGN = 'I'   OPT = 'EQ' )
( SCREEN_NAME = 'TO'           VAR = 'E001 - All' FIELD = 'LGNUM'      GUID = '663192E9D70C1EEE8E86552847635198' SIGN = 'I'   OPT = 'EQ' )

).

DATA var_val type ty_t_var_val.


Loop at var_vall_all into data(b) WHERE screen_name = mv_screen
    AND   var         = mv_variant.

    append b to var_val.

    ENDLOOP.


    LOOP AT mt_fields REFERENCE INTO DATA(field).

      CLEAR: field->t_filter.
      CLEAR: field->t_token.

      LOOP AT  var_val REFERENCE INTO DATA(val)
      WHERE field = field->field.

        DATA(filter) = VALUE ty_S_filter_pop( key    = val->guid
                                              option = val->opt
                                              low    = val->low
                                              high   = val->high ).

        APPEND filter TO field->t_filter.

        set_token( CHANGING field = field ).

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD GET_VARIANTS.

mt_variants = value #(
( SCREEN_NAME = 'QUAN'        VAR = 'E001 - ALL' DESCR = '123'                     )
( SCREEN_NAME = 'TO'          VAR = 'E001'       DESCR = '123'                    )
( SCREEN_NAME = 'TO'          VAR = 'E001 - All' DESCR = '123'  )
 ).


  ENDMETHOD.


  METHOD HLP_GET_RANGE_BY_VALUE.

    DATA(lv_length) = strlen( value ) - 1.

    CASE value(1).

      WHEN `=`.
        result = VALUE #(  option = `EQ` low = value+1 ).

      WHEN `<`.
        IF value+1(1) = `=`.
          result = VALUE #(  option = `LE` low = value+2 ).
        ELSE.
          result = VALUE #(  option = `LT` low = value+1 ).
        ENDIF.

      WHEN `>`.
        IF value+1(1) = `=`.
          result = VALUE #(  option = `GE` low = value+2 ).
        ELSE.
          result = VALUE #(  option = `GT` low = value+1 ).
        ENDIF.

      WHEN `*`.

        IF value+lv_length(1) = `*`.
          SHIFT value RIGHT DELETING TRAILING `*`.
          SHIFT value LEFT DELETING LEADING `*`.
          result = VALUE #( sign = `I` option = `CP` low = value ).
        ENDIF.

      WHEN OTHERS.

        IF value CP `...`.
          SPLIT value AT `...` INTO result-low result-high.
          result-option = `BT`.
        ELSE.
          result = VALUE #( sign = `I` option = `EQ` low = value ).
        ENDIF.



    ENDCASE.



  ENDMETHOD.


  METHOD HLP_GET_UUID.

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


  METHOD ON_EVENT.



    varaint_page(  ).


  ENDMETHOD.


  METHOD ON_INIT.

    mt_screens = value #(
( screen_name = 'INV'      DESCR = '123'            )
( screen_name = 'LAGP'     DESCR = '123'         )
( screen_name = 'PO'       DESCR = '123' )
( screen_name = 'QUAN'     DESCR = '123'            )
( screen_name = 'TO'       DESCR = '123'        )
     ).

    render_main( ).

    mt_mapping = VALUE #(
    (   n = `EQ`     v = `={LOW}`    )
    (   n = `LT`     v = `<{LOW}`   )
    (   n = `LE`     v = `<={LOW}`  )
    (   n = `GT`     v = `>{LOW}`   )
    (   n = `GE`     v = `>={LOW}`  )
    (   n = `CP`     v = `*{LOW}*`  )
    (   n = `BT`     v = `{LOW}...{HIGH}` )
    (   n = `NE`     v = `!(={LOW})`    )
    (   n = `<leer>` v = `<leer>`    )
    ).



  ENDMETHOD.


  METHOD POPUP_COPY_SAVE.

    mv_variant     = mv_variant_copy.
    mv_description = mv_description_copy.



  ENDMETHOD.


  METHOD POPUP_FILTER_OK.

    READ TABLE mt_fields REFERENCE INTO DATA(lr_field)
    WITH KEY field = mv_activ_elemnt.

    IF sy-subrc = 0.

    DELETE mt_filter WHERE option IS INITIAL.

    lr_field->t_filter = mt_filter.

    CLEAR: lr_field->t_token.

    set_token( CHANGING field = lr_field ).

    client->popup_destroy( ).

    render_main( ).

endif.

  ENDMETHOD.


  METHOD RENDER_MAIN.


    IF mo_parent_view IS INITIAL.

      DATA(view) = z2ui5_cl_xml_view=>factory( client ).

      DATA(page) = z2ui5_cl_xml_view=>factory( client )->shell(
               )->page(
                  title          = get_txt( '/SCWM/DE_TW_COND_CHECK_SELECT' )
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true ).

    ELSE.

      page = mo_parent_view->get( `Page` ).

    ENDIF.



    page->header_content(
       )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    grid->simple_form(  get_txt( 'BU_DYNID' )
        )->content( 'form'
            )->label( text     =  get_txt( 'BU_DYNID' )
             )->combobox(
             change = client->_event( val = 'INPUT_SCREEN_CHANGE'  )
             items  = client->_bind_edit( mt_screens )
             selectedkey = client->_bind_edit( Mv_SCREEN )
                 )->item(
                     key = '{SCREEN_NAME}'
                     text = '{SCREEN_NAME} - {DESCR}'
         )->get_parent(  )->label( text     =  get_txt( 'DESCR_40'  )
            )->input(
            value            = client->_bind_edit( mv_screen_descr )
            showvaluehelp    = abap_false
*            editable         = abap_false
            enabled          = abap_false ) .


    grid->simple_form(  get_txt( '/SCWM/WB_VARIANT' )
            )->content( 'form'
                )->label( text =  get_txt( '/SCWM/WB_VARIANT'  )
            )->input(
            value            = client->_bind_edit( mv_variant )
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( 'CALL_POPUP_VARIANT' )
            submit           = client->_event( 'INPUT_VARIANT_CHANGE' )
            )->label( text   =  get_txt( 'DESCR_40' )
            )->input(
            value            = client->_bind_edit( mv_description )
            showvaluehelp    = abap_false ) .

    DATA(content) = grid->simple_form(  get_txt( 'CLASSFEL' )
         )->content( 'form'
             ).

    IF mt_fields IS NOT INITIAL.

      LOOP AT mt_fields REFERENCE INTO DATA(lr_tab).

        DATA(scrtext) = get_txt( CONV #( lr_tab->field_doma ) ).

        content->label( text = scrtext
         )->multi_input(
                   tokens            = client->_bind_local( lr_tab->t_token )
                   showclearicon     = abap_true
                   id                = lr_tab->field
                   valueHelpRequest  = client->_event( val = 'CALL_POPUP_FILTER' t_arg = VALUE #( ( CONV #( lr_tab->field ) ) ) )
               )->item(
                       key  = `{KEY}`
                       text = `{TEXT}`
               )->tokens(
                   )->token(
                       key      = `{KEY}`
                       text     = `{TEXT}`
                       visible  = `{VISIBLE}`
                       selected = `{SELKZ}`
                       editable = `{EDITABLE}`
           ).

      ENDLOOP.

    ENDIF.

    page->footer( )->overflow_toolbar(
                 )->toolbar_spacer(
                 )->button(
                     text    =  get_txt( '/SCWM/DE_HUDEL'  )
                     press   = client->_event( 'BUTTON_DELETE' )
                     type    = 'Reject'
                     icon    = 'sap-icon://delete'
                     enabled = mv_Button_active
                 )->button(
                     text    = get_txt( 'B_KOPIE' )
                     press   = client->_event( 'BUTTON_COPY' )
                     type    = 'Default'
                     enabled = mv_Button_active
                  )->button(
                     text    =  get_txt( '/SCWM/DE_LM_LOGSAVE' )
                     press   = client->_event( 'BUTTON_SAVE' )
                     type    = 'Success'
                     enabled =  mv_Button_active ).

    IF mo_parent_view IS INITIAL.

      client->view_display( page->get_root( )->xml_get( ) ).

    ENDIF.

  ENDMETHOD.


  METHOD RENDER_POPUP_FILTER.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    lo_popup = lo_popup->dialog(
      contentheight = `50%`
      contentwidth  = `50%`
      title         = get_txt_l( '/SCWM/DE_TW_COND_CHECK_COND' ) ).

    DATA(vbox) = lo_popup->vbox( height = `100%` justifyContent = 'SpaceBetween' ).

    DATA(item) = vbox->list(
      noData          = get_txt( '/SCWM/DE_IND_BIN_EMPTY' )
      items           = client->_bind_edit( mt_filter )
      selectionchange = client->_event( 'SELCHANGE' )
                        )->custom_list_item( ).

    DATA(grid) = item->grid( ).

    grid->combobox(
                 selectedkey = `{OPTION}`
                 items       = client->_bind_Edit( mt_mapping )
             )->item(
                     key = '{N}'
                     text = '{N}'
             )->get_parent(
             )->input( value = `{LOW}`
             )->input( value = `{HIGH}`  visible = `{= ${OPTION} === 'BT' }`
             )->button( icon = 'sap-icon://decline'
             type = `Transparent`
             press = client->_event( val = `POPUP_FILTER_DELETE`
             t_arg = VALUE #( ( `${KEY}` ) ) )
             ).

    lo_popup->footer( )->overflow_toolbar(
        )->button( text = get_txt( 'FC_DELALL' )
                  icon = 'sap-icon://delete'
                  type = `Transparent`
                  press = client->_event( val = `POPUP_FILTER_DELETE_ALL` )
        )->button( text = get_txt( 'RSLPO_GUI_ADDPART' )
                   icon = `sap-icon://add`
                   press = client->_event( val = `POPUP_FILTER_ADD` )
        )->toolbar_spacer(
        )->button(
            text  = get_txt( 'MSSRCF_ACTION' )
            press = client->_event( 'POPUP_FILTER_OK' )
            type  = 'Emphasized'
       ).

    client->popup_display( lo_popup->stringify( ) ).

  ENDMETHOD.


  METHOD RENDER_POPUP_VARAINT.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    popup->dialog( title = get_txt( '/SCWM/WB_VARIANT' ) contentwidth = '30%'
    )->table(
            mode  = 'SingleSelectLeft'
            items = client->_bind_edit( mt_variants_pop )
        )->columns(
            )->column( '20rem'
                )->text( get_txt( '/SCWM/WB_VARIANT' ) )->get_parent(
            )->column(
                )->text( get_txt( 'DESCR_40' )
        )->get_parent( )->get_parent(
        )->items(
            )->column_list_item( selected = '{SELKZ}'
                )->cells(
                    )->text( '{VAR}'
                    )->text( '{DESCR}'
    )->get_parent( )->get_parent( )->get_parent( )->get_parent(
    )->footer(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text  = get_txt( 'MSSRCF_ACTION' )
                press = client->_event( 'POPUP_VARIANT_CLOSE' )
                type  = 'Emphasized' ).
    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD RENDER_POP_COPY.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    lo_popup = lo_popup->dialog(
      contentheight = `50%`
      contentwidth  = `50%`
      title         = get_txt( '/SCWM/DE_COPY_NUMBER' ) ).

    lo_popup->simple_form(  get_txt( '/SCWM/WB_VARIANT'  )
               )->content( 'form'
                   )->label( text = get_txt( '/SCWM/WB_VARIANT' )
               )->input(
               value            = client->_bind_edit( mv_variant_copy )
               showvaluehelp    = abap_false
               )->label( text     = get_txt( 'DESCR_40' )
               )->input(
               value            = client->_bind_edit( mv_description_copy )
               showvaluehelp    = abap_false ) .

    lo_popup->footer( )->overflow_toolbar(
        )->toolbar_spacer(
        )->button(
            text  = get_txt( 'XEXIT' )
            press = client->_event( 'POPUP_COPY_EXIT' )
            type    = 'Reject'
       )->button(
            text  = get_txt( '/SCWM/DE_LM_LOGSAVE' )
            press = client->_event( 'POPUP_COPY_SAVE' )
            type  = 'Emphasized'
            enabled = `{= ${MV_VARIANT_COPY} !== "" }`
       ).

    client->popup_display( lo_popup->stringify( ) ).

  ENDMETHOD.


  METHOD SET_TOKEN.

    LOOP AT field->t_filter REFERENCE INTO DATA(lr_filter).

      DATA(lv_value) = mt_mapping[ n = lr_filter->option ]-v.
      REPLACE `{LOW}`  IN lv_value WITH lr_filter->low.
      REPLACE `{HIGH}` IN lv_value WITH lr_filter->high.

      INSERT VALUE #( key = lv_value text = lv_value visible = abap_true editable = abap_false ) INTO TABLE field->t_token.

    ENDLOOP.

  ENDMETHOD.


  METHOD VARAINT_PAGE.


    CASE client->get( )-event.

      WHEN `INPUT_SCREEN_CHANGE`.

        mv_screen_descr = VALUE #( mt_screens[ screen_name = mv_screen ]-descr OPTIONAL ).

        get_fields( ).

        CLEAR: mv_variant.
        CLEAR: mv_description.

        get_variants( ).

        render_main( ).

      WHEN `INPUT_VARIANT_CHANGE`.

        get_values(  ).

        render_main( ).

      WHEN `POPUP_FILTER_OK`.

        popup_filter_ok(  ).

      WHEN `POPUP_FILTER_ADD`.

        INSERT VALUE #( key = hlp_get_uuid( ) ) INTO TABLE mt_filter.

        client->popup_model_update( ).

      WHEN `POPUP_FILTER_DELETE`.

        DATA(lt_item) = client->get( )-t_event_arg.

        DELETE mt_filter WHERE key = lt_item[ 1 ].

        client->popup_model_update( ).

      WHEN `POPUP_FILTER_DELETE_ALL`.

        mt_filter = VALUE #( ).

        client->popup_model_update( ).

      WHEN `CALL_POPUP_FILTER`.

        DATA(arg) = client->get( )-t_event_arg.
        mv_activ_elemnt = VALUE #( arg[ 1 ] OPTIONAL ).

        READ TABLE mt_fields REFERENCE INTO DATA(lr_field)
        WITH KEY field = mv_activ_elemnt.

        " vorhanden werte übertragen
        mt_filter = lr_field->t_filter.

        render_POPUP_FILTER(  ).

      WHEN 'CALL_POPUP_VARIANT'.

        mt_variants_pop = CORRESPONDING #( mt_variants ).

        render_popup_varaint( client ).

      WHEN 'POPUP_VARIANT_CLOSE'.

        mv_variant = VALUE #( mt_variants_pop[ selkz = abap_true ]-var OPTIONAL ).

        client->popup_destroy( ).

        get_values(  ).

        render_main( ).

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'BUTTON_SAVE'.


      WHEN 'BUTTON_DELETE'.

        render_main( ).

      WHEN 'BUTTON_COPY'.

        render_pop_copy(  ).

        render_main( ).

      WHEN 'POPUP_COPY_EXIT'.

        client->popup_destroy( ).

      WHEN 'POPUP_COPY_SAVE'.

        popup_copy_save(  ).

        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

      RETURN.

    ENDIF.

    on_event( ).



    IF mv_screen IS NOT INITIAL AND mv_variant IS NOT INITIAL.
      mv_Button_active = abap_true.
    ELSE.
      mv_Button_active = abap_false.
    ENDIF.

    client->view_model_update(  ).

  ENDMETHOD.
ENDCLASS.