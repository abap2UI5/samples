" @keywords fileuploader base64 attachment import picture document
" @summary Takes a file from the FileUploader into the backend as base64 - a picture or a document, arriving as an xstring.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/upload_download
CLASS z2ui5_cl_smp_app_074 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_074 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    TRY.

        CASE client->get_event( ).

          WHEN `START` OR `CHANGE`.
            view_display( ).

          WHEN `UPLOAD`.

            " the uploader delivers a data URL (data:<mime>;base64,<payload>);
            " drop the prefix, then base64-decode the payload into a string
            SPLIT file   AT `;` INTO DATA(header) DATA(base64).
            SPLIT base64 AT `,` INTO header base64.

            DATA(raw)     = z2ui5_cl_smp_context=>conv_decode_x_base64( base64 ).
            DATA(content) = z2ui5_cl_smp_context=>conv_get_string_by_xstring( raw ).

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

    FIELD-SYMBOLS <table> TYPE table.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - File - Upload to the Backend`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `The file_uploader custom control returns the picked file as a base64 data URL; the backend ` &&
                   `strips the prefix, decodes the payload and shows the file content in a message box.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    IF table IS NOT INITIAL.

      ASSIGN table->* TO <table>.

      DATA(tab) = page->ele( `Table`
          )->a( n = `items` v = client->_bind( <table> )
          )->ele( `headerToolbar`
              )->ele( `OverflowToolbar`
                  )->tag( `Title`
                      )->a( n = `text` v = `CSV Content`
                  )->tag( `ToolbarSpacer`
              )->end(
          )->end( ).

      DATA(fields)  = z2ui5_cl_smp_context=>rtti_get_t_attri_by_any( <table> ).
      DATA(columns) = tab->ele( `columns` ).
      DATA(cells)   = tab->ele( `items`
          )->ele( `ColumnListItem`
              )->ele( `cells` ).

      LOOP AT fields REFERENCE INTO DATA(field).
        columns->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = field->name ).
        cells->tag( `Text`
            )->a( n = `text` v = |\{{ field->name }\}| ).
      ENDLOOP.

    ENDIF.

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( n = `FileUploader` ns = `z2ui5`
                )->a( n = `placeholder` v = `filepath here...`
                )->a( n = `upload`      v = client->_event( `UPLOAD` )
                )->a( n = `path`        v = client->_bind( filepath )
                )->a( n = `value`       v = client->_bind( file ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
