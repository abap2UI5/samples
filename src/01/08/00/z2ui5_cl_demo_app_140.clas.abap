CLASS z2ui5_cl_demo_app_140 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_combobox.
    TYPES
      ty_t_combo TYPE STANDARD TABLE OF ty_s_combobox WITH DEFAULT KEY.

    DATA gt_multi TYPE ty_t_combo.
    DATA gt_sel_multi TYPE ty_t_combo.
    DATA gt_sel_multi2 TYPE string_table.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_140 IMPLEMENTATION.


  METHOD on_event.
        DATA x TYPE REF TO cx_root.

    TRY.
        IF client->check_on_event( `FILTERBAR` ) IS NOT INITIAL.
          client->view_model_update( ).
        ENDIF.
        
      CATCH cx_root INTO x.
        client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE ty_t_combo.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE string_table.
    CLEAR temp1.
    
    temp2-key = `A01`.
    temp2-text = `T1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `A02`.
    temp2-text = `T2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `A03`.
    temp2-text = `T3`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `A04`.
    temp2-text = `T4`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `A05`.
    temp2-text = `T5`.
    INSERT temp2 INTO TABLE temp1.
    gt_multi = temp1.

    
    CLEAR temp3.
    INSERT `A01` INTO TABLE temp3.
    gt_sel_multi2 = temp3.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    view->shell(
            )->page(
                    title          = `abap2UI5 - Multi Combo Box`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( )
               )->simple_form( title    = `Form Title`
                               editable = abap_true
                    )->content( `form`
                  )->multi_combobox(
*                            name = 'Multi'
                           name          = `MultiComboBox`
                    selectedkeys         = client->_bind( gt_sel_multi2 )
*                            selecteditems = client->_bind( gt_sel_multi )
                                   items = client->_bind( val = gt_multi )
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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ENDIF.

    view_display( ).
    on_event( ).

  ENDMETHOD.
ENDCLASS.
