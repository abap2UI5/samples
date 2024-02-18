CLASS z2ui5_cl_demo_app_153 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    TYPES:
      BEGIN OF ty_dataset2,
        label                TYPE string,
*        type               TYPE string,
        data                 TYPE string_table,
        border_width         TYPE i,
*        border_color       TYPE string,
        border_radius        TYPE i,
        border_skipped       TYPE abap_bool,
        border_skipped_xfeld TYPE xfeld,
      END OF ty_dataset2.

    TYPES:
      BEGIN OF ty_dataset,
        label          TYPE string,
        type           TYPE string,
        data           TYPE string_table,
        border_width   TYPE i,
        border_color   TYPE string,
        border_radius  TYPE i,
        border_skipped TYPE abap_bool,
        show_line      TYPE abap_bool,
        lvl2           TYPE ty_dataset2,
      END OF ty_dataset.

    TYPES ty_datasets TYPE STANDARD TABLE OF ty_dataset WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_data,
        labels   TYPE string_table,
        datasets TYPE ty_datasets,
      END OF ty_data .

    TYPES:
      BEGIN OF ty_chart,
        data TYPE ty_data,
      END OF ty_chart .

*    DATA mt_string_table TYPE string_table.
*    DATA mt_string_table2 TYPE string_table.
*    DATA mv_value TYPE string.
*    DATA mv_value2 TYPE string.
    DATA ms_struc TYPE ty_chart.
    DATA ms_struc2 TYPE ty_chart.
*    DATA mv_long_long_long_long_value TYPE string.

    METHODS ui5_display.
    METHODS ui5_event.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_153 IMPLEMENTATION.


  METHOD ui5_display.

    client->_bind_edit(
        val = ms_struc
        custom_mapper = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
        custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case(  )
     ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Binding'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
               )->get_parent(
           )->button(
            text  = 'Rountrip...'
            press = client->_event( 'POPUP' )
*           )->input( value = client->_bind_edit( mv_long_long_long_long_value ) width = `10%`
*           )->input( value = client->_bind_edit( mv_long_long_long_long_value ) width = `10%`
             ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        IF ms_struc <> ms_struc2.
          client->message_box_display( `structure changed error` ).
          RETURN.
        ENDIF.

*        IF mv_value <> mv_value2.
*          client->message_box_display( `pretty name in binding not working` ).
*          RETURN.
*        ENDIF.

*        IF mt_string_table2 <> mt_string_table2.
*          client->message_box_display( `string table changed error` ).
*          RETURN.
*        ENDIF.

        client->message_toast_display( `everything works as expected` ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    DATA ls_dataset TYPE ty_dataset.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.

      ms_struc-data-labels = VALUE #( ( `Jan` ) ( `Feb` ) ( `Mar` ) ( `Apr` ) ( `May` ) ( `Jun` ) ).

      CLEAR ls_dataset.
      ls_dataset-label = 'Fully Rounded'.
      ls_dataset-border_width = 2.
      ls_dataset-border_radius = 200.
*      ls_dataset-border_skipped = abap_true.
      ls_dataset-data = VALUE #( ( `1` ) ( `-12` ) ( `19` ) ( `3` ) ( `5` ) ( `-2` ) ( `3` ) ).


      "new value in lvl2
*      ls_dataset-lvl2-border_skipped = '-'.

      APPEND ls_dataset TO ms_struc-data-datasets.

*      CLEAR ls_dataset.
*      ls_dataset-label = 'Small Radius'.
*      ls_dataset-border_width = 2.
*      ls_dataset-border_radius = 5.
*      ls_dataset-border_skipped = abap_false.
*      ls_dataset-data = VALUE #( ( `11` ) ( `2` ) ( `-3` ) ( `13` ) ( `-9` ) ( `7` ) ( `-4` ) ).
*      APPEND ls_dataset TO ms_struc-data-datasets.

      ms_struc2 = ms_struc.

*      mv_value = `test`.
*      mv_value2 = `test`.

*      mt_string_table = VALUE #( ( `row_01` ) ( `row_02` ) ).
*      mt_string_table2 = mt_string_table.

      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.
ENDCLASS.
