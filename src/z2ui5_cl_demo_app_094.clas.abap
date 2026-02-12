CLASS z2ui5_cl_demo_app_094 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_01,
        input TYPE string,
        BEGIN OF ty_s_02,
          input TYPE string,
          BEGIN OF ty_s_03,
            input TYPE string,
            BEGIN OF ty_s_04,
              input TYPE string,
            END OF ty_s_04,
          END OF ty_s_03,
        END OF ty_s_02,
      END OF ty_s_01.

    DATA ms_screen TYPE ty_s_01.
    DATA mr_input  TYPE REF TO data.
    DATA mr_screen TYPE REF TO data.
    DATA mo_app    TYPE REF TO z2ui5_cl_demo_app_094.
    DATA mv_val    TYPE string.

    DATA mo_client      TYPE REF TO z2ui5_if_client.
    DATA mv_init     TYPE abap_bool.

    METHODS on_init.
    METHODS view_build.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_page TYPE REF TO z2ui5_cl_xml_view.

ENDCLASS.

CLASS z2ui5_cl_demo_app_094 IMPLEMENTATION.

  METHOD on_init.

    FIELD-SYMBOLS <input> TYPE any.
    FIELD-SYMBOLS <screen> TYPE ty_s_01.

    ms_screen-input = `structure level 01 - working`.

    CREATE DATA mr_input TYPE string.
    ASSIGN mr_input->* TO <input>.

    <input> = `ref data - working`.

    CREATE DATA mr_screen TYPE ty_s_01.
    ASSIGN mr_screen->* TO <screen>.

    <screen>-input = `ref data struc - working`.

    ms_screen-ty_s_02-input = `struc deep dissolve - working`.

    ms_screen-ty_s_02-ty_s_03-ty_s_04-input = `struc deep switch guid name - working`.

    mo_app = NEW #( ).
    mo_app->mv_val = `instance attribute val - working`.
    mo_app->ms_screen-input = `instance attribute struc - working`.
  ENDMETHOD.

  METHOD view_build.

    FIELD-SYMBOLS <input> TYPE any.
    FIELD-SYMBOLS <screen> TYPE ty_s_01.
    ASSIGN mr_input->* TO <input>.

    ASSIGN mr_screen->* TO <screen>.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    mo_page = lo_view->shell(
          )->page( title = `test` ).

    DATA(lo_o_grid) = mo_page->grid( `L6 M12 S12`
        )->content( `layout` ).

    DATA(lo_content) = lo_o_grid->simple_form( title = `Input`
          )->content( `form` ).

    lo_content->label( `structure level 01`
      )->input( mo_client->_bind_edit( ms_screen-input )
      )->label( `ref data`
      )->input( mo_client->_bind_edit( <input> )
      )->label( `ref data struc field`
      )->input( mo_client->_bind_edit( <screen>-input )
      )->label( `struc deep dissolve`
      )->input( mo_client->_bind_edit( ms_screen-ty_s_02-input )
      )->label( `struc deep switch guid name`
      )->input( mo_client->_bind_edit( ms_screen-ty_s_02-ty_s_03-ty_s_04-input )
      )->label( `instance attribute val`
      )->input( mo_client->_bind_edit( mo_app->mv_val )
      )->label( `instance attribute struc`
      )->input( mo_client->_bind_edit( mo_app->ms_screen-input ) ).

    mo_page->footer( )->overflow_toolbar(
                   )->toolbar_spacer(
                   )->button(
                       text  = `Delete`
                       press = mo_client->_event( `BUTTON_DELETE` )
                       type  = `Reject`
                       icon  = `sap-icon://delete`
                   )->button(
                       text  = `Add`
                       press = mo_client->_event( `BUTTON_ADD` )
                       type  = `Default`
                       icon  = `sap-icon://add`
                   )->button(
                       text  = `Save`
                       press = mo_client->_event( `BUTTON_SAVE` )
                       type  = `Success` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).

    ENDIF.

    view_build( ).
    mo_client->message_toast_display( `server roundtrip` ).
  ENDMETHOD.
ENDCLASS.
