CLASS z2ui5_cl_demo_app_035 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_type           TYPE string.
    DATA mv_path           TYPE string.
    DATA mv_editor         TYPE string.
    DATA mv_check_editable TYPE abap_bool.

    DATA mo_client            TYPE REF TO z2ui5_if_client.
    DATA lt_types TYPE z2ui5_if_types=>ty_t_name_value.
    METHODS view_display.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_035 IMPLEMENTATION.
  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page( title          = `abap2UI5 - File Editor`
                                       navbuttonpress = mo_client->_event_nav_app_leave( )
                                       shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_temp) = lo_page->simple_form( title    = `File`
                                    editable = abap_true )->content( `form`
         )->label( `path`
         )->input( mo_client->_bind_edit( mv_path )
         )->label( `Option` ).

    lt_types = VALUE z2ui5_if_types=>ty_t_name_value( ).
    lt_types = VALUE #( FOR row IN z2ui5_cl_util=>source_get_file_types( )  (
            n = shift_right( shift_left( row ) )
            v = shift_right( shift_left( row ) ) ) ).

    DATA(lo_temp3) = lo_temp->input( value = mo_client->_bind_edit( mv_type )
                   suggestionitems   = mo_client->_bind( lt_types )
                    )->get( ).

    lo_temp3->suggestion_items(
                )->list_item( text           = `{N}`
                              additionaltext = `{V}` ).

    lo_temp->label( `` )->button( text = `Download`
                    press           = mo_client->_event( `DB_LOAD` )
                    icon            = `sap-icon://download-from-cloud` ).

    lo_page->code_editor( type     = mo_client->_bind_edit( mv_type )
                       editable = mo_client->_bind( mv_check_editable )
                       value    = mo_client->_bind( mv_editor ) ).

    lo_page->footer( )->overflow_toolbar(
        )->button( text  = `Clear`
                   press = mo_client->_event( `CLEAR` )
                   icon  = `sap-icon://delete`
        )->toolbar_spacer(
        )->button( text  = `Edit`
                   press = mo_client->_event( `EDIT` )
                   icon  = `sap-icon://edit`
        )->button( text    = `Upload`
                   press   = mo_client->_event( `DB_SAVE` )
                   type    = `Emphasized`
                   icon    = `sap-icon://upload-to-cloud`
                   enabled = xsdbool( mv_editor IS NOT INITIAL ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      mv_path = `../../demo/text`.
      mv_type = `plain_text`.
      view_display( ).
    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `DB_LOAD`.

        mv_editor = COND #(
            WHEN mv_path CS `abap` THEN lcl_file_api=>read_abap( )
            WHEN mv_path CS `json` THEN lcl_file_api=>read_json( )
            WHEN mv_path CS `yaml` THEN lcl_file_api=>read_yaml( )
            WHEN mv_path CS `text` THEN lcl_file_api=>read_text( )
            WHEN mv_path CS `js`   THEN lcl_file_api=>read_js( ) ).

        mo_client->message_toast_display( `Download successfull` ).

        mo_client->view_model_update( ).
      WHEN `DB_SAVE`.
        mo_client->message_box_display( text = `Upload successfull. File saved!`
                                     type = `success` ).
      WHEN `EDIT`.
        mv_check_editable = xsdbool( mv_check_editable = abap_false ).
        mo_client->view_model_update( ).
      WHEN `CLEAR`.
        mv_editor = ``.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
