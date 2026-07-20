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
    IF client->check_on_init( ) IS NOT INITIAL OR client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
            DATA header TYPE string.
            DATA base64 TYPE string.
            DATA raw TYPE xstring.
            DATA content TYPE string.
            DATA temp1 TYPE string.
            DATA temp2 TYPE string.
        DATA error TYPE REF TO cx_root.

    TRY.

        CASE client->get( )-event.

          WHEN `START` OR `CHANGE`.
            view_display( ).

          WHEN `UPLOAD`.

            " the uploader delivers a data URL (data:<mime>;base64,<payload>);
            " drop the prefix, then base64-decode the payload into a string
            
            
            SPLIT file   AT `;` INTO header base64.
            SPLIT base64 AT `,` INTO header base64.

            
            raw     = z2ui5_cl_sample_context=>conv_decode_x_base64( base64 ).
            
            content = z2ui5_cl_sample_context=>conv_get_string_by_xstring( raw ).

            client->message_box_display( content ).

            
            CLEAR temp1.
            file     = temp1.
            
            CLEAR temp2.
            filepath = temp2.

            view_display( ).

        ENDCASE.

        
      CATCH cx_root INTO error.
        client->message_box_display( text = error->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
      FIELD-SYMBOLS <table> TYPE table.
      DATA tab TYPE REF TO z2ui5_cl_xml_view.
      DATA fields TYPE abap_component_tab.
      DATA columns TYPE REF TO z2ui5_cl_xml_view.
      DATA cells TYPE REF TO z2ui5_cl_xml_view.
      DATA temp3 LIKE LINE OF fields.
      DATA field LIKE REF TO temp3.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell( )->page(
        title          = `abap2UI5 - Upload a File`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The file_uploader custom control returns the picked file as a base64 data URL; the backend ` &&
                   `strips the prefix, decodes the payload and shows the file content in a message box.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    IF table IS NOT INITIAL.

      
      ASSIGN table->* TO <table>.

      
      tab = page->table( client->_bind( <table> )
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( `CSV Content`
                  )->toolbar_spacer(
          )->get_parent( )->get_parent( ).

      
      fields  = z2ui5_cl_sample_context=>rtti_get_t_attri_by_any( <table> ).
      
      columns = tab->columns( ).
      
      cells   = tab->items( )->column_list_item( )->cells( ).

      
      
      LOOP AT fields REFERENCE INTO field.
        columns->column( )->text( field->name ).
        cells->text( |\{{ field->name }\}| ).
      ENDLOOP.

    ENDIF.

    page->footer(
        )->overflow_toolbar(
            )->_z2ui5( )->file_uploader(
                value       = client->_bind( file )
                path        = client->_bind( filepath )
                placeholder = `filepath here...`
                upload      = client->_event( `UPLOAD` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
