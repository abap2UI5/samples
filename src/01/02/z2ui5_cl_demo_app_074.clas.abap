CLASS z2ui5_cl_demo_app_074 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA filepath TYPE string.
    DATA file     TYPE string.
    DATA table    TYPE REF TO data.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_074 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) OR client->check_on_navigated( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    TRY.

        CASE client->get( )-event.

          WHEN `START` OR `CHANGE`.
            view_display( ).

          WHEN `UPLOAD`.

            " the uploader delivers a data URL (data:<mime>;base64,<payload>);
            " drop the prefix, then base64-decode the payload into a string
            SPLIT file   AT `;` INTO DATA(header) DATA(base64).
            SPLIT base64 AT `,` INTO header base64.

            DATA(raw)     = z2ui5_cl_sample_context=>conv_decode_x_base64( base64 ).
            DATA(content) = z2ui5_cl_sample_context=>conv_get_string_by_xstring( raw ).

            client->message_box_display( content ).

            file     = VALUE #( ).
            filepath = VALUE #( ).

            view_display( ).

        ENDCASE.

      CATCH cx_root INTO DATA(error).
        client->message_box_display( text = error->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Upload a File`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    IF table IS NOT INITIAL.

      FIELD-SYMBOLS <table> TYPE table.
      ASSIGN table->* TO <table>.

      DATA(tab) = page->table( client->_bind_edit( <table> )
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( `CSV Content`
                  )->toolbar_spacer(
          )->get_parent( )->get_parent( ).

      DATA(fields)  = z2ui5_cl_sample_context=>rtti_get_t_attri_by_any( <table> ).
      DATA(columns) = tab->columns( ).
      DATA(cells)   = tab->items( )->column_list_item( )->cells( ).

      LOOP AT fields REFERENCE INTO DATA(field).
        columns->column( )->text( field->name ).
        cells->text( |\{{ field->name }\}| ).
      ENDLOOP.

    ENDIF.

    page->footer(
        )->overflow_toolbar(
            )->_z2ui5( )->file_uploader(
                value       = client->_bind_edit( file )
                path        = client->_bind_edit( filepath )
                placeholder = `filepath here...`
                upload      = client->_event( `UPLOAD` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
