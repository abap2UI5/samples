CLASS z2ui5_cl_demo_app_035 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_type           TYPE string.
    DATA mv_path           TYPE string.
    DATA mv_editor         TYPE string.
    DATA mv_check_editable TYPE abap_bool.

    DATA lt_types TYPE z2ui5_if_types=>ty_t_name_value.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS read_abap
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS read_json
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS read_js
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS read_yaml
      RETURNING
        VALUE(r_result) TYPE string.
    METHODS read_text
      RETURNING
        VALUE(r_result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_035 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title          = `abap2UI5 - File Editor`
                                       navbuttonpress = client->_event_nav_app_leave( )
                                       shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(temp) = page->simple_form( title    = `File`
                                    editable = abap_true )->content( `form`
         )->label( `path`
         )->input( client->_bind_edit( mv_path )
         )->label( `Option` ).

    lt_types = VALUE z2ui5_if_types=>ty_t_name_value( ).
  "  lt_types = VALUE #( FOR row IN z2ui5_cl_sample_context=>source_get_file_types( )  (
  "          n = shift_right( shift_left( row ) )
  "          v = shift_right( shift_left( row ) ) ) ).

    DATA(temp3) = temp->input( value = client->_bind_edit( mv_type )
                   suggestionitems   = client->_bind( lt_types )
                    )->get( ).

    temp3->suggestion_items(
                )->list_item( text           = `{N}`
                              additionaltext = `{V}` ).

    temp->label( `` )->button( text = `Download`
                    press           = client->_event( `DB_LOAD` )
                    icon            = `sap-icon://download-from-cloud` ).

    page->code_editor( type     = client->_bind_edit( mv_type )
                       editable = client->_bind( mv_check_editable )
                       value    = client->_bind_edit( mv_editor ) ).

    page->footer( )->overflow_toolbar(
        )->button( text  = `Clear`
                   press = client->_event( `CLEAR` )
                   icon  = `sap-icon://delete`
        )->toolbar_spacer(
        )->button( text  = `Edit`
                   press = client->_event( `EDIT` )
                   icon  = `sap-icon://edit`
        )->button( text    = `Upload`
                   press   = client->_event( `DB_SAVE` )
                   type    = `Emphasized`
                   icon    = `sap-icon://upload-to-cloud`
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

      WHEN `DB_LOAD`.

        mv_editor = COND #(
            WHEN mv_path CS `abap` THEN read_abap( )
            WHEN mv_path CS `json` THEN read_json( )
            WHEN mv_path CS `yaml` THEN read_yaml( )
            WHEN mv_path CS `text` THEN read_text( )
            WHEN mv_path CS `js`   THEN read_js( ) ).

        client->message_toast_display( `Download successful` ).

        client->view_model_update( ).

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


  METHOD read_abap.

    r_result = `METHOD SELECT_FILES.` && |\n| &&
           |\n| &&
           `    DATA: LV_RET_CODE TYPE I,` && |\n| &&
           `          LV_USR_AXN  TYPE I.` && |\n| &&
           |\n| &&
           `    CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG(` && |\n| &&
           `      EXPORTING` && |\n| &&
           `        WINDOW_TITLE            = 'Select file'` && |\n| &&
           `        MULTISELECTION          = 'X'` && |\n| &&
           `      CHANGING` && |\n| &&
           `        FILE_TABLE              = ME->PT_FILETAB` && |\n| &&
           `        RC                      = LV_RET_CODE` && |\n| &&
           `        USER_ACTION             = LV_USR_AXN` && |\n| &&
           `      EXCEPTIONS` && |\n| &&
           `        FILE_OPEN_DIALOG_FAILED = 1` && |\n| &&
           `        CNTL_ERROR              = 2` && |\n| &&
           `        ERROR_NO_GUI            = 3` && |\n| &&
           `        NOT_SUPPORTED_BY_GUI    = 4` && |\n| &&
           `        OTHERS                  = 5` && |\n| &&
           `           ).` && |\n| &&
           `    IF SY-SUBRC <> 0 OR` && |\n| &&
           `       LV_USR_AXN = CL_GUI_FRONTEND_SERVICES=>ACTION_CANCEL.` && |\n| &&
           `      RAISE EX_FILE_SEL_ERR.` && |\n| &&
           `    ENDIF.` && |\n| &&
           |\n| &&
           `  ENDMETHOD.   `.

  ENDMETHOD.


  METHOD read_json.

    r_result = `{` && |\n| &&
               `    "quiz": {` && |\n| &&
               `        "sport": {` && |\n| &&
               `            "q1": {` && |\n| &&
               `                "test" : false,` && |\n| &&
               `                "question": "Which one is correct team name in NBA?",` && |\n| &&
               `                "options": [` && |\n| &&
               `                    "New York Bulls",` && |\n| &&
               `                    "Los Angeles Kings",` && |\n| &&
               `                    "Golden State Warriros",` && |\n| &&
               `                    "Huston Rocket"` && |\n| &&
               `                ],` && |\n| &&
               `                "answer": "Huston Rocket"` && |\n| &&
               `            }` && |\n| &&
               `        },` && |\n| &&
               `        "maths": {` && |\n| &&
               `            "q1": {` && |\n| &&
               `                "question": "5 + 7 = ?",` && |\n| &&
               `                "options": [` && |\n| &&
               `                    "10",` && |\n| &&
               `                    "11",` && |\n| &&
               `                    "12",` && |\n| &&
               `                    "13"` && |\n| &&
               `                ],` && |\n| &&
               `                "answer": "12"` && |\n| &&
               `            },` && |\n| &&
               `            "q2": {` && |\n| &&
               `                "question": true,` && |\n| &&
               `                "options": [` && |\n| &&
               `                    "1",` && |\n| &&
               `                    "2",` && |\n| &&
               `                    "3",` && |\n| &&
               `                    "4"` && |\n| &&
               `                ],` && |\n| &&
               `                "answer": 487829` && |\n| &&
               `            }` && |\n| &&
               `        }` && |\n| &&
               `    }` && |\n| &&
               `}`.

  ENDMETHOD.


  METHOD read_js.

    r_result = `function showAlert() {` && |\n| &&
               `    alert("Alert from JS file");` && |\n| &&
               `}` && |\n| &&
               |\n| &&
               `function updateHeading() {` && |\n| &&
               `    document.getElementById('heading').innerHTML = 'Heading changed with JS';` && |\n| &&
               `}`.

  ENDMETHOD.


  METHOD read_yaml.

    r_result = `# Employee records` && |\n| &&
               `- martin:` && |\n| &&
               `    name: Martin Developer` && |\n| &&
               `    job: Developer` && |\n| &&
               `    skills:` && |\n| &&
               `      - python` && |\n| &&
               `      - perl` && |\n| &&
               `      - pascal` && |\n| &&
               `- tabitha:` && |\n| &&
               `    name: Tabitha Bitumen` && |\n| &&
               `    job: Developer` && |\n| &&
               `    skills:` && |\n| &&
               `      - lisp` && |\n| &&
               `      - fortran` && |\n| &&
               `      - erlang`.

  ENDMETHOD.


  METHOD read_text.

    r_result = `TXT test file` && |\n| &&
               `Purpose: Provide example of this file type` && |\n| &&
               `Document file type: TXT` && |\n| &&
               `Version: 1.0` && |\n| &&
               `Remark:` && |\n| &&
               |\n| &&
               `Example content:` && |\n| &&
               `The names "John Doe" for males, "Jane Doe" or "Jane Roe" for females, or "Jonnie Doe" and "Janie Doe" for children, or just ` &&
               ` "Doe" non-gender-specifically are used as placeholder names for a party whose true identity is unknown or must ` &&
               `be withheld in a legal action, case, or discussion. The names are also used to refer to a corpse or hospital patient whose ` &&
               `identity is unknown. This practice is widely used in the United States and Canada, but is rarely used in other ` &&
               `English-speaking countries including the United Kingdom itself, from where the use of "John Doe" in a legal context ` &&
               `originates. The names Joe Bloggs or John Smith are used in the UK instead, as well as in Australia and New Zealand.` &&
               |\n| &&
               |\n| &&
               `John Doe is sometimes used to refer to a typical male in other contexts as well, in a similar manner to John Q. Public,` &&
               ` known in Great Britain as Joe Public, John Smith or Joe Bloggs. For example, the first name listed on a form is often ` &&
               `John Doe, along with a fictional address or other fictional information to provide an example of how to fill in the form` &&
               `. The name is also used frequently in popular culture, for example in the Frank Capra film Meet John Doe. John Doe was ` &&
               `also the name of a 2002 American television series.`.

  ENDMETHOD.

ENDCLASS.
