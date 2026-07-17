CLASS z2ui5_cl_demo_app_065 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_input_main  TYPE string.
    DATA mv_input_nest  TYPE string.
    DATA mv_count       TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_065 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = lo_view->shell(
        )->page(
                title          = `Main View`
                id             = `test`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( )
            )->header_content(
                )->link(
      )->get_parent( ).

    page->content(
      )->button( text  = `Rerender all`
                 press = client->_event( `ALL` )
      )->button( text  = `Rerender Main without nest`
                 press = client->_event( `MAIN` )
      )->button( text  = `Rerender only nested view`
                 press = client->_event( `NEST` )
      )->button( text  = `Update only nested MODEL (nest_view_model_update)`
                 press = client->_event( `NEST_MODEL` )
      )->input( client->_bind_edit( mv_input_main ) ).

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory(
          )->page( `Nested View`
              )->button( text  = `event`
                         press = client->_event( `TEST` )
              )->input( client->_bind_edit( mv_input_nest ) ).

    IF client->check_on_init( ).
      client->view_display( lo_view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `TEST`.
        client->message_box_display( |input { mv_input_nest }| ).

      WHEN `ALL`.
        client->view_display( lo_view->stringify( ) ).
        client->nest_view_display( val           = lo_view_nested->stringify( )
                                   id            = `test`
                                   method_insert = `addContent` ).

      WHEN `MAIN`.
        client->view_display( lo_view->stringify( ) ).

      WHEN `NEST`.
        client->nest_view_display( val           = lo_view_nested->stringify( )
                                   id            = `test`
                                   method_insert = `addContent` ).

      WHEN `NEST_MODEL`.
        " change only a nest-bound field and refresh the nested view's model
        " copy (no re-render of the nested XML) - this isolates the effect of
        " nest_view_model_update. Press "Rerender only nested view" first so
        " the nested view exists.
        mv_count      = mv_count + 1.
        mv_input_nest = |nest model updated #{ mv_count }|.
        client->nest_view_model_update( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
