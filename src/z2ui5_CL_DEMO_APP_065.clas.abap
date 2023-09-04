CLASS z2ui5_cl_demo_app_065 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_input_main  TYPE string.
    DATA mv_input_nest  TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_cl_demo_app_065 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.


      data(lo_view) = Z2UI5_CL_XML_VIEW=>factory( client ).

        DATA(page) = lo_view->shell(
            )->page(
                    title = `Main View` id = `test`
                    navbuttonpress = client->_event( 'BACK' )
                      shownavbutton = abap_true
                )->header_content(
                    )->link(
                        text = 'Source_Code'  target = '_blank'
                        href = lo_view->hlp_get_source_code_url( )
                )->get_parent( ).

              page->content(
                )->button( text = 'Rerender all' press = client->_event( 'ALL' )
                )->button( text = 'Rerender Main without nest' press = client->_event( 'MAIN' )
                )->button( text = 'Rerender only nested view' press = client->_event( 'NEST' )
                )->input( value = client->_bind_edit( mv_input_main )  ).

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( client
          )->page( title = `Nested View`
              )->button( text = 'event' press = client->_event( 'TEST' )
              )->input( value = client->_bind_edit( mv_input_nest ) ).

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      client->view_display( lo_view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'ALL'.
        client->view_display( lo_view->stringify( ) ).
        client->nest_view_display( val = lo_view_nested->stringify( ) id = `test` method_insert = 'addContent'  ).

      WHEN 'MAIN'.
        client->view_display( lo_view->stringify( ) ).

      WHEN 'NEST'.
        client->nest_view_display( val = lo_view_nested->stringify( ) id = `test`  method_insert = 'addContent'  ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
