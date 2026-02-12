CLASS z2ui5_cl_demo_app_140 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox .
    TYPES
      ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY .

    DATA mo_client TYPE REF TO z2ui5_if_client .
    DATA mt_multi TYPE ty_t_combo.
    DATA mt_sel_multi TYPE ty_t_combo.
    DATA mv_sel_multi2 TYPE string_table.
    METHODS on_init .
    METHODS on_event .
    METHODS view_main_display .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_140 IMPLEMENTATION.

  METHOD on_event.

    TRY.
        DATA(lo_ok_code) = mo_client->get( )-event.
        CASE lo_ok_code.
          WHEN `FILTERBAR`.

            mo_client->view_model_update( ).
        ENDCASE.
      CATCH cx_root INTO DATA(x).
        mo_client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_init.

    mt_multi = VALUE ty_t_combo(
      ( key = `A01` text = `T1` )
      ( key = `A02` text = `T2` )
      ( key = `A03` text = `T3` )
      ( key = `A04` text = `T4` )
      ( key = `A05` text = `T5` ) ).

    mv_sel_multi2 = VALUE #( ( `A01` ) ).
  ENDMETHOD.

  METHOD view_main_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->shell(
            )->page(
                    title          = `abap2UI5 - Multi Combo Box`
                    navbuttonpress = mo_client->_event_nav_app_leave( )
                    shownavbutton  = mo_client->check_app_prev_stack( )
               )->simple_form( title    = `Form Title`
                               editable = abap_true
                    )->content( `form`
                  )->multi_combobox(
*                            name = 'Multi'
                           name          = `MultiComboBox`
                    selectedkeys         = mo_client->_bind_edit( mv_sel_multi2 )
*                            selecteditems = client->_bind_edit( gt_sel_multi )
                                   items = mo_client->_bind_edit( mt_multi )
                                   )->item(
                                      key  = `{KEY}`
                                      text = `{TEXT}`
                                  )->get_parent(
                  )->button(
                            text  = `post`
                            press = mo_client->_event( `BUTTON_POST` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
    ENDIF.

    view_main_display( ).
    on_event( ).
  ENDMETHOD.
ENDCLASS.
