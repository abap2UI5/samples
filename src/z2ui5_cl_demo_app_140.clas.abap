CLASS z2ui5_cl_demo_app_140 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.
    TYPES
      ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA gt_multi TYPE ty_t_combo.
    DATA gt_sel_multi TYPE ty_t_combo.
    DATA gt_sel_multi2 TYPE string_table.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_140 IMPLEMENTATION.

  METHOD on_event.

    TRY.
        IF client->check_on_event( `FILTERBAR` ).
          client->view_model_update( ).
        ENDIF.
      CATCH cx_root INTO DATA(x).
        client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD on_init.

    gt_multi = VALUE ty_t_combo(
      ( key = `A01` text = `T1` )
      ( key = `A02` text = `T2` )
      ( key = `A03` text = `T3` )
      ( key = `A04` text = `T4` )
      ( key = `A05` text = `T5` ) ).

    gt_sel_multi2 = VALUE #( ( `A01` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell(
            )->page(
                    title          = `abap2UI5 - Multi Combo Box`
                    navbuttonpress = client->_event( `BACK` )
                    shownavbutton  = client->check_app_prev_stack( )
               )->simple_form( title    = `Form Title`
                               editable = abap_true
                    )->content( `form`
                  )->multi_combobox(
*                            name = 'Multi'
                           name          = `MultiComboBox`
                    selectedkeys         = client->_bind_edit( gt_sel_multi2 )
*                            selecteditems = client->_bind_edit( gt_sel_multi )
                                   items = client->_bind_edit( val = gt_multi )
                                   )->item(
                                      key  = `{KEY}`
                                      text = `{TEXT}`
                                  )->get_parent(
                  )->button(
                            text  = `post`
                            press = client->_event( `BUTTON_POST` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

    view_display( ).
    on_event( ).

  ENDMETHOD.

ENDCLASS.
