" @keywords fileuploader base64 attachment import picture document
" @summary Takes a file from the FileUploader into the backend as base64 - a picture or a document, arriving as an xstring.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/upload_download
CLASS z2ui5_cl_smp_app_074 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA filepath TYPE string.
    DATA file     TYPE string.

    " what the last upload produced - public, so it survives the roundtrip
    " and the page can still show it after the next event
    DATA upload_name TYPE string.
    DATA upload_size TYPE i.
    DATA upload_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

    " Both wrap a pair of classes that do the same job under different names:
    " the first is the ABAP Cloud one, the second the classic on-premise one.
    " Called dynamically so the class that is missing on a system is a caught
    " runtime error instead of a syntax error at activation.
    METHODS base64_decode
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE xstring.

    METHODS xstring_to_string
      IMPORTING
        val           TYPE xstring
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_074 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
            DATA header TYPE string.
            DATA base64 TYPE string.
            DATA raw TYPE xstring.
            DATA temp1 TYPE string.
            DATA temp2 TYPE string.
        DATA error TYPE REF TO cx_root.

    TRY.

        CASE client->get_event( ).

          WHEN `START` OR `CHANGE`.
            view_display( ).

          WHEN `UPLOAD`.

            " the uploader delivers a data URL (data:<mime>;base64,<payload>);
            " drop the prefix, then base64-decode the payload into a string
            
            
            SPLIT file   AT `;` INTO header base64.
            SPLIT base64 AT `,` INTO header base64.

            
            raw = base64_decode( base64 ).

            " the proof that the file arrived: its name, its size in bytes as
            " the backend counts them, and the decoded content itself
            upload_name = filepath.
            upload_size = xstrlen( raw ).
            upload_text = xstring_to_string( raw ).

            client->message_toast_display( |{ upload_name } - { upload_size } bytes received| ).

            
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


  METHOD base64_decode.

    DATA lv_class TYPE string.

    TRY.
        lv_class = `CL_WEB_HTTP_UTILITY`.
        CALL METHOD (lv_class)=>(`DECODE_X_BASE64`)
          EXPORTING
            encoded = val
          RECEIVING
            decoded = result.

      CATCH cx_root.
        lv_class = `CL_HTTP_UTILITY`.
        CALL METHOD (lv_class)=>(`DECODE_X_BASE64`)
          EXPORTING
            encoded = val
          RECEIVING
            decoded = result.
    ENDTRY.

  ENDMETHOD.


  METHOD xstring_to_string.

    DATA lo_conv  TYPE REF TO object.
    DATA lv_class TYPE string.

    TRY.
        lv_class = `CL_ABAP_CONV_CODEPAGE`.
        CALL METHOD (lv_class)=>create_in
          RECEIVING
            instance = lo_conv.

        CALL METHOD lo_conv->(`IF_ABAP_CONV_IN~CONVERT`)
          EXPORTING
            source = val
          RECEIVING
            result = result.

      CATCH cx_root.
        lv_class = `CL_ABAP_CONV_IN_CE`.
        CALL METHOD (lv_class)=>create
          EXPORTING
            encoding = `UTF-8`
          RECEIVING
            conv     = lo_conv.

        CALL METHOD lo_conv->(`CONVERT`)
          EXPORTING
            input = val
          IMPORTING
            data  = result.
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - File - Upload to the Backend`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `The file_uploader custom control returns the picked file as a base64 data URL; the backend ` &&
                   `strips the prefix, decodes the payload and reports what arrived - name, size in bytes and content.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    IF upload_name IS NOT INITIAL.

      
      box = page->ele( `Panel`
          )->a( n = `headerText` v = `Received in the backend`
          )->a( n = `class`      v = `sapUiSmallMargin`
          )->ele( `VBox`
              )->a( n = `class` v = `sapUiSmallMargin` ).

      box->tag( `ObjectStatus`
          )->a( n = `title` v = `File`
          )->a( n = `text`  v = upload_name ).
      box->tag( `ObjectStatus`
          )->a( n = `title` v = `Size`
          )->a( n = `text`  v = |{ upload_size } bytes|
          )->a( n = `state` v = `Success` ).
      box->tag( `TextArea`
          )->a( n = `value`    v = upload_text
          )->a( n = `editable` b = abap_false
          )->a( n = `rows`     v = `8`
          )->a( n = `width`    v = `100%`
          )->a( n = `class`    v = `sapUiSmallMarginTop` ).

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
