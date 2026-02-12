CLASS z2ui5_cl_demo_app_318 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_type           TYPE string.
    DATA mv_path           TYPE string.
    DATA mv_editor         TYPE string.
    DATA mv_check_editable TYPE abap_bool.

    DATA mo_client            TYPE REF TO z2ui5_if_client.
    DATA: lt_types TYPE z2ui5_if_types=>ty_t_name_value.
    METHODS view_display.
    DATA: lt_types2 TYPE z2ui5_if_types=>ty_t_name_value.
  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_318 IMPLEMENTATION.
  METHOD view_display.

    mv_editor = `<html> ` && |\n| &&
                `    <body> ` && |\n| &&
                `        <h1> Hi there 👋</h1>` && |\n| &&
                `        <p>This example was rendered by providing HTML code to the API. You can also tell the API to convert from a URL. Just remove the html parameter and add the url paramter.</p>` && |\n| &&
                `    </body> ` && |\n| &&
                `</html>`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page( title          = `abap2UI5 - File Editor`
                                       navbuttonpress = mo_client->_event_nav_app_leave( )
                                       shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_temp) = lo_page->simple_form( title    = `File`
                                    editable = abap_true )->content( `form`
         )->label( `path`
         )->input( mo_client->_bind_edit( mv_path )
         )->label( `Option` ).

    lt_types2 = VALUE #( FOR row IN z2ui5_cl_util=>source_get_file_types( )  (
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

    lo_page->code_editor( type     = `html`
                       editable = abap_true
                       value    = mo_client->_bind( mv_editor ) ).

    lo_page->footer( )->overflow_toolbar(
        )->toolbar_spacer(
        )->button( text    = `PDF`
                   press   = mo_client->_event( `PDF` )
                   type    = `Emphasized`
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
      WHEN `PDF`.

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
