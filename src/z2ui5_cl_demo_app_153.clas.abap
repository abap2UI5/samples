CLASS z2ui5_cl_demo_app_153 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    TYPES:
      BEGIN OF ty_dataset2,
        label                TYPE string,
        data                 TYPE string_table,
        border_width         TYPE i,
        border_radius        TYPE i,
        border_skipped       TYPE abap_bool,
        border_skipped_xfeld TYPE abap_bool,
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

    DATA ms_struc TYPE ty_chart.
    DATA ms_struc2 TYPE ty_chart.

    METHODS ui5_display.
    METHODS ui5_event.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_153 IMPLEMENTATION.


  METHOD ui5_display.

    client->_bind_edit(
        val                = ms_struc
        custom_mapper      = z2ui5_cl_ajson_mapping=>create_camel_case( iv_first_json_upper = abap_false )
        custom_mapper_back = z2ui5_cl_ajson_mapping=>create_to_snake_case( ) ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Binding'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = client->check_app_prev_stack( )
           )->button(
            text  = 'Rountrip...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        IF ms_struc <> ms_struc2.
          client->message_box_display( `structure changed error` ).
          RETURN.
        ENDIF.
        client->message_toast_display( `everything works as expected` ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_navigated( ).

      ms_struc-data-labels = VALUE #( ( `Jan` ) ( `Feb` ) ( `Mar` ) ( `Apr` ) ( `May` ) ( `Jun` ) ).

      DATA ls_dataset TYPE ty_dataset.
      CLEAR ls_dataset.
      ls_dataset-label = 'Fully Rounded'.
      ls_dataset-border_width = 2.
      ls_dataset-border_radius = 200.

      ls_dataset-data = VALUE #( ( `1` ) ( `-12` ) ( `19` ) ( `3` ) ( `5` ) ( `-2` ) ( `3` ) ).

      APPEND ls_dataset TO ms_struc-data-datasets.
      ms_struc2 = ms_struc.

      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

ENDCLASS.
