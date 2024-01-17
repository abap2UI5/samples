CLASS z2ui5_cl_demo_app_153 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    DATA mt_string_table TYPE string_table.
    DATA mt_string_table2 TYPE string_table.

    TYPES:
      BEGIN OF ty_struct_tab,
        selkz    TYPE abap_bool,
        counter  TYPE i,
        descr    TYPE string,
        new_type TYPE string,
      END OF ty_struct_tab.

    TYPES:
      BEGIN OF ty_struct,
        selkz   TYPE abap_bool,
        counter TYPE i,
        descr   TYPE string,
        t_tab   TYPE STANDARD TABLE OF ty_struct_tab WITH EMPTY KEY,
      END OF ty_struct.

    DATA mv_value TYPE string.
    DATA mv_value2 TYPE string.
    DATA ms_struc TYPE ty_struct.
    DATA ms_struc2 TYPE ty_struct.
    data mv_long_long_long_long_value type string.

    METHODS ui5_display.
    METHODS ui5_event.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_153 IMPLEMENTATION.


  METHOD ui5_display.

    client->_bind_edit( val = mv_value pretty_name = 'X' ).
    client->_bind_edit( val = ms_struc pretty_name = 'X' ).
    client->_bind_edit( mt_string_table ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Binding'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
               )->get_parent(
           )->button(
            text  = 'Rountrip...'
            press = client->_event( 'POPUP' )
           )->input( value = client->_bind_edit( mv_long_long_long_long_value ) width = `10%`
           )->input( value = client->_bind_edit( mv_long_long_long_long_value ) width = `10%`
             ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        IF mv_value <> mv_value2.
          client->message_box_display( `pretty name in binidng not working` ).
          RETURN.
        ENDIF.

        IF ms_struc <> ms_struc2.
          client->message_box_display( `structure changed error` ).
          RETURN.
        ENDIF.

        IF mt_string_table2 <> mt_string_table2.
          client->message_box_display( `string table changed error` ).
          RETURN.
        ENDIF.

        client->message_toast_display( `everything works as expected` ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.

      ms_struc = VALUE #(
       descr = 'this is a description'
       counter = 3
       selkz = abap_true
       t_tab = VALUE #( (
          descr = 'this is a description'
          counter = 3
          selkz = abap_true
          new_type = `ABC`
       ) )
       ).

      mv_value = `test`.
      mv_value2 = `test`.

      ms_struc2 = ms_struc.

      mt_string_table = VALUE #( ( `row_01` ) ( `row_02` ) ).
      mt_string_table2 = mt_string_table.

      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.
ENDCLASS.
