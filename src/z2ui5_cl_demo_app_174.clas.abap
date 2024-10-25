CLASS z2ui5_cl_demo_app_174 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        zzselkz TYPE abap_bool,
        title   TYPE string,
        value   TYPE string,
        descr   TYPE string,
      END OF ty_row.
    TYPES ty_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mt_tab TYPE ty_tab.
    DATA mv_multiselect TYPE abap_bool.
    DATA mv_preselect TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_174 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      client->view_display(
        z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = 'abap2UI5 - Popup To Select'
            navbuttonpress = client->_event( val = 'BACK' )
            shownavbutton  = client->check_app_prev_stack( )
       )->hbox(
       )->text( text = 'Multiselect: ' class = 'sapUiTinyMargin'
       )->switch( state = client->_bind_edit( mv_multiselect ) change = client->_event( `MULTISELECT_TOGGLE` )
       )->get_parent(
       )->hbox(
       )->text( text = 'Preselect all entries: ' class = 'sapUiTinyMargin'
       )->switch( state = client->_bind_edit( mv_preselect ) enabled = client->_bind_edit( mv_multiselect )
       )->get_parent(
       )->button(
        text  = 'Open Popup...'
        press = client->_event( 'POPUP' ) )->stringify( )
        ).

      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN 'POPUP'.
        mt_tab = VALUE #( descr = 'this is a description'
             ( zzselkz = mv_preselect title = 'title_01'  value = 'value_01' )
             ( zzselkz = mv_preselect title = 'title_02'  value = 'value_02' )
             ( zzselkz = mv_preselect title = 'title_03'  value = 'value_03' )
             ( zzselkz = mv_preselect title = 'title_04'  value = 'value_04' )
             ( zzselkz = mv_preselect title = 'title_05'  value = 'value_05' ) ).

        client->nav_app_call( z2ui5_cl_pop_to_select=>factory(
                           i_tab             = mt_tab
                           i_multiselect     = mv_multiselect
                           i_event_confirmed = 'POPUP_CONFIRMED'
                           i_event_canceled  = 'POPUP_CANCEL'
        ) ).

      WHEN 'POPUP_CANCELED'.
        client->message_box_display( `Popup was cancelled` ).

      WHEN 'POPUP_CONFIRMED'.
        DATA(lr) = client->get( )-r_event_data.
        DATA(lt3) = CONV ty_tab( lr->* ).
        IF mv_multiselect = abap_false.
          client->message_box_display( `callback after popup to select: ` && lt3[ 1 ]-title ).
        ELSE.
          client->nav_app_call( z2ui5_cl_pop_table=>factory( i_tab = lt3 i_title = 'Selected rows' ) ).
        ENDIF.

      WHEN 'MULTISELECT_TOGGLE'.
        mv_preselect = COND #( WHEN mv_multiselect = abap_false
                               THEN abap_false
                               ELSE mv_preselect ).
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
