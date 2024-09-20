CLASS z2ui5_cl_demo_app_176 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        date TYPE string,
        age  TYPE string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        fname   TYPE string,
        merge   TYPE string,
        visible TYPE string,
        binding TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

    METHODS main_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.
    METHODS nest_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_176 IMPLEMENTATION.


  METHOD main_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = lo_view->shell(
        )->page(
                title          = `Main View`
                id             = `test`
                navbuttonpress = i_client->_event( 'BACK' )
                shownavbutton = xsdbool( i_client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
      ).

    i_client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.


  METHOD nest_view.

    i_client->_bind( mt_layout ).

    mt_data = VALUE #( ( name = 'Theo' date = '01.01.2000' age = '5' )
                       ( name = 'Lore' date = '01.01.2000' age = '1' ) ).

    mt_layout = VALUE #( ( fname = 'NAME' merge = 'false' visible = 'true'  binding = '{NAME}' )
                         ( fname = 'DATE' merge = 'false' visible = 'true'  binding = '{DATE}' )
                         ( fname = 'AGE'  merge = 'false' visible = 'false' binding = '{AGE}' ) ).

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).

    lo_view_nested->shell( )->page( `Nested View`
    )->table( items = i_client->_bind( mt_data )
      )->columns(
        )->template_repeat( list = `{template>/MT_LAYOUT}` var = `LO`
          )->column( mergeduplicates = `{LO>MERGE}` visible = `{LO>VISIBLE}` )->get_parent(
        )->get_parent( )->get_parent(
        )->items(
          )->column_list_item(
            )->cells(
              )->template_repeat( list = `{template>/MT_LAYOUT}` var = `LO2`
                )->object_identifier( text = `{= '{' + ${LO2>FNAME} + '}' }` ).

    i_client->nest_view_display( val = lo_view_nested->stringify( ) id = `test` method_insert = 'addContent' ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
        RETURN.
    ENDCASE.

    main_view( client ).
    nest_view( client ).

  ENDMETHOD.
ENDCLASS.
