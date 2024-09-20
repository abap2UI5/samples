CLASS z2ui5_cl_demo_app_192 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    TYPES: BEGIN OF ty_s_key_value,
             fname   TYPE char30,
             value   TYPE string,
             tabname TYPE char30,
             comp    TYPE abap_componentdescr,
           END OF ty_s_key_value,
           ty_t_key_values TYPE STANDARD TABLE OF ty_s_key_value WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_merged_data,
             t_kopf  TYPE REF TO data,
             t_pos   TYPE REF TO data,
             t_keyva TYPE ty_t_key_values,
           END OF ty_s_merged_data,
           ty_t_merged_data TYPE STANDARD TABLE OF ty_s_merged_data WITH EMPTY KEY.

*    DATA mt_new_data TYPE ty_t_merged_data.

    DATA mt_new_data2 TYPE STANDARD TABLE OF REF TO z2ui5_cl_demo_app_193 WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_out,
        aa TYPE string,
        bb TYPE string,
        cc TYPE string,
      END OF ty_s_out,
      ty_t_out TYPE STANDARD TABLE OF ty_s_out WITH EMPTY KEY.

    DATA mt_out TYPE ty_t_out.

    METHODS ui5_display.
    METHODS ui5_event.

  PROTECTED SECTION.
    METHODS get_data.
    METHODS xml_parse.
    METHODS xml_stringify.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_192 IMPLEMENTATION.

  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page( title          = 'xxx'
                 navbuttonpress = client->_event( val = 'BACK' )
                 shownavbutton  = abap_true
            )->header_content( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    xml_parse( ).

    me->client = client.
    get_data( ).
    ui5_display( ).

    xml_stringify( ).
  ENDMETHOD.

  METHOD get_data.

    mt_out = VALUE #( ( aa = 'aa' bb = 'bb' cc = 'cc'  )
                      ( aa = 'a1' bb = 'b1' cc = 'c1'  ) ).

    DATA(kopf) = REF #( mt_out ).

    DATA lr_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lr_tabdescr    TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS <fs_s_head>     TYPE any.
    FIELD-SYMBOLS <fs_t_head_new> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_s_head_new> TYPE any.

    LOOP AT kopf->* ASSIGNING <fs_s_head>.

      DATA(lo_new_data) = NEW z2ui5_cl_demo_app_193( ).
      INSERT lo_new_data INTO TABLE mt_new_data2.

      lr_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_s_head> ).
      lr_tabdescr ?= cl_abap_tabledescr=>create( p_line_type = lr_structdescr ).

      CREATE DATA lo_new_data->mt_kopf TYPE HANDLE lr_tabdescr.
      ASSIGN lo_new_data->mt_kopf->* TO <fs_t_head_new>.

      APPEND INITIAL LINE TO <fs_t_head_new> ASSIGNING <fs_s_head_new>.
      <fs_s_head_new> = CORRESPONDING #( <fs_s_head> ).

    ENDLOOP.

  ENDMETHOD.


  METHOD xml_parse.

    LOOP AT mt_new_data2 INTO DATA(lo_data).
      lo_data->xml_parse( ).
    ENDLOOP.

  ENDMETHOD.


  METHOD xml_stringify.

    LOOP AT mt_new_data2 INTO DATA(lo_data).
      lo_data->xml_stringify( ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
