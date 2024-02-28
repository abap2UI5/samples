CLASS z2ui5_cl_demo_app_173 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        DATE type string,
        AGE  type string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        FNAME      type string,
        merge      TYPE string,
        visible    TYPE string,
        binding    type string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_173 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    client->_bind( mt_layout ).

    mt_data = VALUE #( ( name = 'Theo' date = '01.01.2000' age = '5' )
                       ( name = 'Lore' date = '01.01.2000' age = '1' ) ).

    mt_layout = VALUE #( ( fname = 'NAME' merge = 'false' visible = 'true'  binding = '{NAME}' )
                         ( fname = 'DATE' merge = 'false' visible = 'true'  binding = '{DATE}' )
                         ( fname = 'AGE'  merge = 'false' visible = 'false' binding = '{AGE}' ) ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell( )->page(
    )->table( items = client->_bind( mt_data )
      )->columns(
        )->template_repeat( list = `{template>/MT_LAYOUT}` var = `LO`
          )->column( mergeduplicates = `{LO>MERGE}` visible = `{LO>VISIBLE}` )->get_parent(
        )->get_parent( )->get_parent(
        )->items(
          )->column_list_item(
            )->cells(
              )->template_repeat( list = `{template>/MT_LAYOUT}` var = `LO2`
                )->object_identifier( text = `{LO2>BINDING}` ).

     client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
