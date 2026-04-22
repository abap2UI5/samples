CLASS z2ui5_cl_demo_app_318 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_type           TYPE string.
    DATA mv_path           TYPE string.
    DATA mv_editor         TYPE string.
    DATA mv_check_editable TYPE abap_bool.

    DATA client            TYPE REF TO z2ui5_if_client.
    DATA lt_types TYPE z2ui5_if_types=>ty_t_name_value.

    DATA lt_types2 TYPE z2ui5_if_types=>ty_t_name_value.

    METHODS view_display.
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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title          = `abap2UI5 - File Editor`
                                       navbuttonpress = client->_event_nav_app_leave( )
                                       shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(temp) = page->simple_form( title    = `File`
                                    editable = abap_true )->content( `form`
         )->label( `path`
         )->input( client->_bind_edit( mv_path )
         )->label( `Option` ).

    lt_types2 = VALUE #( FOR row IN z2ui5_cl_util=>source_get_file_types( )  (
            n = shift_right( shift_left( row ) )
            v = shift_right( shift_left( row ) ) ) ).

    DATA(temp3) = temp->input( value = client->_bind_edit( mv_type )
                   suggestionitems   = client->_bind( lt_types )
                    )->get( ).

    temp3->suggestion_items(
                )->list_item( text           = `{N}`
                              additionaltext = `{V}` ).

    temp->label( `` )->button( text = `Download`
                    press           = client->_event( `DB_LOAD` )
                    icon            = `sap-icon://download-from-cloud` ).

    page->code_editor( type     = `html`
                       editable = abap_true
                       value    = client->_bind( mv_editor ) ).

    page->footer( )->overflow_toolbar(
        )->toolbar_spacer(
        )->button( text    = `PDF`
                   press   = client->_event( `PDF` )
                   type    = `Emphasized`
                   enabled = xsdbool( mv_editor IS NOT INITIAL ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      mv_path = `../../demo/text`.
      mv_type = `plain_text`.
      view_display( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN `PDF`.

      WHEN `DB_SAVE`.
        client->message_box_display( text = `Upload successful. File saved!`
                                     type = `success` ).
      WHEN `EDIT`.
        mv_check_editable = xsdbool( mv_check_editable = abap_false ).
        client->view_model_update( ).

      WHEN `CLEAR`.
        mv_editor = ``.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
