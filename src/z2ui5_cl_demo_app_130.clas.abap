CLASS z2ui5_cl_demo_app_130 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_s_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ty_s_token .
    TYPES:
      ty_t_token TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY .
    TYPES:
      ty_t_range    TYPE RANGE OF string .
    TYPES:
      ty_s_range    TYPE LINE OF ty_t_range .
    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop .
    TYPES:
      ty_t_filter_pop TYPE STANDARD TABLE OF ty_s_filter_pop WITH EMPTY KEY .
    TYPES:
      BEGIN OF ty_s_fieldsdb,
        screen_name TYPE char10,
        field       TYPE char10,
        field_doma  TYPE char10,
      END OF ty_s_fieldsdb .
    TYPES:
      ty_t_fieldsdb TYPE STANDARD TABLE OF ty_s_fieldsdb WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_fields.
        INCLUDE TYPE ty_s_fieldsdb.
        TYPES: t_token  TYPE ty_t_token,
        t_filter TYPE ty_t_filter_pop,
      END OF ty_s_fields .
    TYPES:
      BEGIN OF ty_s_var_val,
        screen_name TYPE char10,
        var         TYPE     char10,
        field       TYPE     char10,
        guid        TYPE     string,
        sign        TYPE char1,
        opt         TYPE char2,
        low         TYPE char255,
        high        TYPE char255,
      END OF ty_s_var_val .
    TYPES:
      ty_t_var_val TYPE STANDARD TABLE OF ty_s_var_val WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_variants,
        screen_name TYPE char10,
        var         TYPE char10,
        descr       TYPE string,
      END OF ty_s_variants .
    TYPES:
      ty_t_variants TYPE STANDARD TABLE OF ty_s_variants WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_var_pop.
        INCLUDE TYPE ty_s_variants.
        TYPES: selkz TYPE xfeld,
      END OF ty_s_var_pop .
    TYPES:
      BEGIN OF ty_s_screens,
        screen_name TYPE char10,
        descr       TYPE string,
      END OF ty_s_screens .

    DATA:
      mt_filter       TYPE STANDARD TABLE OF ty_s_filter_pop WITH EMPTY KEY .
    DATA mt_mapping TYPE z2ui5_if_types=>ty_t_name_value .
    DATA:
      mt_screens      TYPE STANDARD TABLE OF ty_s_screens WITH EMPTY KEY .
    DATA:
      mt_variants     TYPE STANDARD TABLE OF ty_s_variants WITH EMPTY KEY .
    DATA:
      mt_variants_pop TYPE STANDARD TABLE OF ty_s_var_pop WITH EMPTY KEY .
    DATA mv_activ_elemnt TYPE string .
    DATA mv_screen TYPE string .
    DATA mv_button_active TYPE abap_bool .
    DATA mv_description TYPE string .
    DATA mv_screen_descr TYPE string .
    DATA mv_variant TYPE string .
    DATA mv_description_copy TYPE string .
    DATA mv_variant_copy TYPE string .
    DATA mo_parent_view TYPE REF TO z2ui5_cl_xml_view .
  PROTECTED SECTION.

    METHODS on_init.

    METHODS on_event.

    METHODS render_main.

    METHODS render_popup_filter.

    METHODS get_fields.

    METHODS get_values.

    METHODS popup_filter_ok.

    METHODS render_pop_copy.

    METHODS get_variants.

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



CLASS z2ui5_cl_demo_app_130 IMPLEMENTATION.


  METHOD get_fields.

    DATA(db_fields) = VALUE ty_t_fieldsdb(
    ( screen_name = 'INV'        field =  'LGNUM'   field_doma = '/SCWM/LGNUM'      )
    ( screen_name = 'LAGP'       field =  'LGNUM'   field_doma = '/SCWM/LGNUM'      )
    ( screen_name = 'LAGP'       field =  'LGPLA'   field_doma = '/SCWM/DE_LGPLA'   )
    ( screen_name = 'LAGP'       field =  'LGTYP'   field_doma = '/SCWM/DE_LGTYP'   )
    ( screen_name = 'QUAN'       field =  'LGNUM'   field_doma = '/SCWM/LGNUM'      )
    ( screen_name = 'QUAN'       field =  'LGPLA'   field_doma = '/SCWM/DE_LGPLA'   )
    ( screen_name = 'QUAN'       field =  'MATNR'   field_doma = '/SCWM/DE_MATNR'   )
    ( screen_name = 'QUAN'       field =  'OWNER'   field_doma = '/SCWM/DE_OWNER'   )
    ( screen_name = 'TO'         field =  'LGNUM'   field_doma = '/SCWM/LGNUM'      )
    ( screen_name = 'TO'         field =  'MATNR'   field_doma = '/SCWM/DE_MATNR'   )
    ( screen_name = 'TO'         field =  'PROCTY'  field_doma = '/SCWM/DE_PROCTY'  )
    ( screen_name = 'TO'         field =  'TOSTAT'  field_doma = '/SCWM/DE_TOSTAT'  )
    ( screen_name = 'TO'         field =  'VLPLA'   field_doma = '/SCWM/LTAP_VLPLA' )
    ).

    CLEAR: mt_fields.
    LOOP AT db_fields REFERENCE INTO DATA(lr_fields) WHERE screen_name = mv_screen.

      APPEND INITIAL LINE TO mt_fields REFERENCE INTO DATA(field).
      field->* = CORRESPONDING #( lr_fields->* ).

    ENDLOOP.

  ENDMETHOD.


  METHOD get_txt.

    result = 'Text'.

  ENDMETHOD.


  METHOD get_txt_l.

    result = 'Text'.

  ENDMETHOD.


  METHOD get_values.

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

    DATA(var_vall_all) = VALUE ty_t_var_val(
    ( screen_name = 'LTAP'         var = 'E001 - All' field = 'LGNUM'      guid = '663192E9D70C1EEE8CC06B0F98CD81A3' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'LTAP'         var = 'E001 - All' field = 'MATNR'      guid = '663192E9D70C1EEE8CD4E9389CB11403' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'LTAP'         var = 'E001 - All' field = 'TOSTAT'     guid = '663192E9D70C1EEE8CC06BC66AD581A3' sign = 'I'   opt = 'NE' )
    ( screen_name = 'LTAP'         var = 'E002 - All' field = 'LGNUM'      guid = '663192E9D70C1EEE8CC06B0F98CD81A3' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'LTAP'         var = 'E002 - All' field = 'MATNR'      guid = '663192E9D70C1EEE8CD4E9389CB11403' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'LTAP'         var = 'E002 - All' field = 'TOSTAT'     guid = '663192E9D70C1EEE8CC06BC66AD581A3' sign = 'I'   opt = 'NE' )
    ( screen_name = 'QUAN'         var = 'E001 - ALL' field = 'LGNUM'      guid = '663192E9D70C1EEE90CEE2FA658C51EE' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'QUAN'         var = 'E001 - ALL' field = 'LGPLA'      guid = '663192E9D70C1EEE90CEEF4750FD91EE' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'TO'           var = 'E001      ' field = 'LGNUM'      guid = '663192E9D70C1EEE8E87DE5FF8CC512A' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'TO'           var = 'E001      ' field = 'PROCTY'     guid = '663192E9D70C1EEE8E87DD8D1EB8C7F5' sign = 'I'   opt = 'EQ' )
    ( screen_name = 'TO'           var = 'E001 - All' field = 'LGNUM'      guid = '663192E9D70C1EEE8E86552847635198' sign = 'I'   opt = 'EQ' )

    ).

    DATA var_val TYPE ty_t_var_val.


    LOOP AT var_vall_all INTO DATA(b) WHERE screen_name = mv_screen
        AND   var         = mv_variant.

      APPEND b TO var_val.
    ENDLOOP.

    LOOP AT mt_fields REFERENCE INTO DATA(field).

      CLEAR: field->t_filter.
      CLEAR: field->t_token.

      LOOP AT  var_val REFERENCE INTO DATA(val)
      WHERE field = field->field.

        DATA(filter) = VALUE ty_s_filter_pop( key    = val->guid
                                              option = val->opt
                                              low    = val->low
                                              high   = val->high ).

        APPEND filter TO field->t_filter.

        set_token( CHANGING field = field ).

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_variants.

    mt_variants = VALUE #(
    ( screen_name = 'QUAN'        var = 'E001 - ALL' descr = '123'  )
    ( screen_name = 'TO'          var = 'E001'       descr = '123'  )
    ( screen_name = 'TO'          var = 'E001 - All' descr = '123'  )
     ).

  ENDMETHOD.

  METHOD on_event.

    varaint_page(  ).

  ENDMETHOD.


  METHOD on_init.

    mt_screens = VALUE #(
( screen_name = 'INV'      descr = '123'            )
( screen_name = 'LAGP'     descr = '123'         )
( screen_name = 'PO'       descr = '123' )
( screen_name = 'QUAN'     descr = '123'            )
( screen_name = 'TO'       descr = '123'        )
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


  METHOD popup_copy_save.

    mv_variant     = mv_variant_copy.
    mv_description = mv_description_copy.



  ENDMETHOD.


  METHOD popup_filter_ok.

    READ TABLE mt_fields REFERENCE INTO DATA(lr_field)
    WITH KEY field = mv_activ_elemnt.

    IF sy-subrc = 0.

      DELETE mt_filter WHERE option IS INITIAL.

      lr_field->t_filter = mt_filter.

      CLEAR: lr_field->t_token.

      set_token( CHANGING field = lr_field ).

      client->popup_destroy( ).

      render_main( ).

    ENDIF.

  ENDMETHOD.


  METHOD render_main.


    IF mo_parent_view IS INITIAL.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
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
             selectedkey = client->_bind_edit( mv_screen )
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
                   valuehelprequest  = client->_event( val = 'CALL_POPUP_FILTER' t_arg = VALUE #( ( CONV #( lr_tab->field ) ) ) )
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
                     enabled = mv_button_active
                 )->button(
                     text    = get_txt( 'B_KOPIE' )
                     press   = client->_event( 'BUTTON_COPY' )
                     type    = 'Default'
                     enabled = mv_button_active
                  )->button(
                     text    =  get_txt( '/SCWM/DE_LM_LOGSAVE' )
                     press   = client->_event( 'BUTTON_SAVE' )
                     type    = 'Success'
                     enabled =  mv_button_active ).

    IF mo_parent_view IS INITIAL.

      client->view_display( page->get_root( )->xml_get( ) ).

    ENDIF.

  ENDMETHOD.


  METHOD render_popup_filter.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog(
      contentheight = `50%`
      contentwidth  = `50%`
      title         = get_txt_l( '/SCWM/DE_TW_COND_CHECK_COND' ) ).

    DATA(vbox) = lo_popup->vbox( height = `100%` justifycontent = 'SpaceBetween' ).

    DATA(item) = vbox->list(
      nodata          = get_txt( '/SCWM/DE_IND_BIN_EMPTY' )
      items           = client->_bind_edit( mt_filter )
      selectionchange = client->_event( 'SELCHANGE' )
                        )->custom_list_item( ).

    DATA(grid) = item->grid( ).

    grid->combobox(
                 selectedkey = `{OPTION}`
                 items       = client->_bind_edit( mt_mapping )
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


  METHOD render_popup_varaint.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

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


  METHOD render_pop_copy.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

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


  METHOD set_token.

    LOOP AT field->t_filter REFERENCE INTO DATA(lr_filter).

      DATA(lv_value) = mt_mapping[ n = lr_filter->option ]-v.
      REPLACE `{LOW}`  IN lv_value WITH lr_filter->low.
      REPLACE `{HIGH}` IN lv_value WITH lr_filter->high.

      INSERT VALUE #( key = lv_value text = lv_value visible = abap_true editable = abap_false ) INTO TABLE field->t_token.

    ENDLOOP.

  ENDMETHOD.


  METHOD varaint_page.


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

        INSERT VALUE #( key = z2ui5_cl_util=>uuid_get_c32( ) ) INTO TABLE mt_filter.

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

        render_popup_filter(  ).

      WHEN 'CALL_POPUP_VARIANT'.

        LOOP AT mt_variants REFERENCE INTO DATA(lr_fields).
          APPEND INITIAL LINE TO mt_variants_pop REFERENCE INTO DATA(field).
          field->* = CORRESPONDING #( lr_fields->* ).
        ENDLOOP.

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


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

      RETURN.

    ENDIF.

    on_event( ).

    mv_button_active = xsdbool( mv_screen IS NOT INITIAL AND mv_variant IS NOT INITIAL ).

    client->view_model_update(  ).

  ENDMETHOD.
ENDCLASS.
