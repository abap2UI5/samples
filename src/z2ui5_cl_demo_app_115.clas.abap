CLASS z2ui5_cl_demo_app_115 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    data mv_output type string.

    METHODS display_demo_output
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS Z2UI5_CL_DEMO_APP_115 IMPLEMENTATION.


  METHOD display_demo_output.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - CL_DEMO_OUTPUT - TODO uncomment the source code'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                      target = '_blank'
                 )->get_parent(
            )->_z2ui5( )->demo_output( mv_output
            )->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
*
** Abschnitt 1
*    cl_demo_output=>begin_section( '1. Überschrift' ).
*    cl_demo_output=>begin_section( '1.1 Überschrift' ).
** Text
*    cl_demo_output=>write_text( 'Text 1.1' ).
*    cl_demo_output=>write( 'Text 1.1 non proportional' ).
*    cl_demo_output=>end_section( ).
*    cl_demo_output=>end_section( ).
** Abschnitt 2
*    cl_demo_output=>begin_section( '2. Überschrift' ).
*    cl_demo_output=>begin_section( '2.1 Überschrift' ).
** Text
*    cl_demo_output=>write_text( 'Text 2.1' ).
*    cl_demo_output=>write( 'Text 2.1 non proportional' ).
*    cl_demo_output=>end_section( ).
*    cl_demo_output=>end_section( ).
*
*    TYPES: BEGIN OF ty_struct,
*             f1 TYPE string,
*             f2 TYPE i,
*           END OF ty_struct.
*
*    TYPES: ty_it_tab TYPE STANDARD TABLE OF ty_struct WITH DEFAULT KEY.
*
*    DATA(lv_struct) = VALUE ty_struct( f1 = 'Field1' f2 = 1 ).
*    DATA(it_tab) = VALUE ty_it_tab( ( f1 = 'T1' f2 = 1 )
*                                    ( f1 = 'T2' f2 = 2 )
*                                    ( f1 = 'T3' f2 = 3 ) ).
*
*    cl_demo_output=>write_data( value = -100         name = 'Zahl' ).
*    cl_demo_output=>write_data( value = 'ein String' name = 'Text' ).
*    cl_demo_output=>write_data( value = lv_struct    name = 'Struct' ).
*    cl_demo_output=>write_data( value = it_tab       name = 'Tab' ).
*
*    cl_demo_output=>write_text( 'Oben' ).
*    cl_demo_output=>line( ).
*    cl_demo_output=>write_text( 'Unten' ).
*
** alles anzeigen
*    SELECT * FROM t100 INTO TABLE @DATA(it_mara)
*    up to 50 rows.
*
*    cl_demo_output=>write_data( it_mara ).
*
** add HTML
*    cl_demo_output=>write_html( '<b>Text bold</b>' ).
*
** add HTML
*    cl_demo_output=>write_html( '<i>Text italic</i>' ).
*
*    cl_demo_output=>write_text( |blah blah blah \n| &&
*                                |blah blah blah| ).
*
*    TYPES:
*      BEGIN OF spfli_line,
*        carrid   TYPE spfli-carrid,
*        connid   TYPE spfli-connid,
*        cityfrom TYPE spfli-cityfrom,
*        cityto   TYPE spfli-cityto,
*      END OF spfli_line,
*      spfli_tab TYPE HASHED TABLE OF spfli_line
*                     WITH UNIQUE KEY carrid connid,
*      BEGIN OF struct,
*        carrname TYPE scarr-carrname,
*        spfli    TYPE REF TO spfli_tab,
*      END OF struct.
*
*    SELECT s~carrname, p~carrid, p~connid, p~cityfrom, p~cityto
*           FROM scarr AS s
*             INNER JOIN spfli AS p
*               ON s~carrid = p~carrid
*           ORDER BY s~carrname
*           INTO TABLE @DATA(itab).
*
*    cl_demo_output=>write_data( itab ).
*
*    DATA itab2 TYPE TABLE OF i WITH EMPTY KEY.
*
*    itab2 = VALUE #( ( 1 ) ( 2 ) ( 3 ) ).
*
*    DATA(json_writer) = cl_sxml_string_writer=>create(
*                          type = if_sxml=>co_xt_json ).
*    CALL TRANSFORMATION id SOURCE itab = itab2
*                           RESULT XML json_writer.
*    DATA(json) = json_writer->get_output( ).
*    mv_output = cl_demo_output=>get( ).
*    display_demo_output( client ).

  ENDMETHOD.
ENDCLASS.
