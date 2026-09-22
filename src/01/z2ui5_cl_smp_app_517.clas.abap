" @keywords uploadset upload drag drop multiple files base64 attachment uploadsetext companion
" @summary Takes files from a sap.m.upload.UploadSet into the backend as base64 - the invisible UploadSetExt companion reads each one, so no upload endpoint is needed.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/upload_download
CLASS z2ui5_cl_smp_app_517 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_file,
        name  TYPE string,
        type  TYPE string,
        size  TYPE string,
        bytes TYPE i,
      END OF ty_s_file.

    " the companion writes into these four, one file at a time
    DATA file_name  TYPE string.
    DATA file_data  TYPE string.
    DATA file_type  TYPE string.
    DATA file_size  TYPE string.
    DATA removed    TYPE string.
    DATA t_received TYPE STANDARD TABLE OF ty_s_file WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_517 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `FILE_ADDED`.
        " The companion hands over ONE file per roundtrip - several files
        " picked at once arrive one after the other, each waiting for the
        " previous response. fileData is a base64 DATA URL, so the payload
        " starts after the comma.
        IF file_name IS NOT INITIAL.
          DATA(payload) = substring_after( val = file_data
                                           sub = `,` ).
          " the decoded length, so the sample shows the bytes ABAP actually
          " received rather than the base64 text: three bytes per four
          " characters, less the one or two `=` that pad the last group
          DATA(padding) = COND i( WHEN payload CP `*==` THEN 2
                                  WHEN payload CP `*=`  THEN 1
                                  ELSE 0 ).
          INSERT VALUE #( name  = file_name
                          type  = file_type
                          size  = file_size
                          bytes = strlen( payload ) * 3 / 4 - padding ) INTO TABLE t_received.
        ENDIF.

      WHEN `FILE_REMOVED`.
        DELETE t_received WHERE name = removed.

      WHEN `CLEAR`.
        t_received = VALUE #( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:upload` v = `sap.m.upload`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - File - Upload with an UploadSet`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `sap.m.upload.UploadSet posts to an upload endpoint, which an abap2UI5 app does not have. ` &&
                   `The invisible UploadSetExt companion reads every added file into bound properties instead, so the content ` &&
                   `arrives in the same roundtrip as the event - drag files onto the list or use its uploader button.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " The companion renders nothing and is wired to the UploadSet by id.
    page->tag( n = `UploadSetExt` ns = `z2ui5`
        )->a( n = `uploadSetId`     v = `demoUploadSet`
        )->a( n = `fileName`        v = client->_bind( file_name )
        )->a( n = `fileData`        v = client->_bind( file_data )
        )->a( n = `mediaType`       v = client->_bind( file_type )
        )->a( n = `fileSize`        v = client->_bind( file_size )
        )->a( n = `removedFileName` v = client->_bind( removed )
        )->a( n = `change`          v = client->_event( `FILE_ADDED` )
        " the companion fires a SEPARATE event when an item is removed - a
        " change wire alone never reaches FILE_REMOVED below
        )->a( n = `remove`          v = client->_event( `FILE_REMOVED` ) ).

    page->ele( n = `UploadSet` ns = `upload`
        )->a( n = `id`            v = `demoUploadSet`
        )->a( n = `instantUpload` b = abap_false
        )->a( n = `uploadEnabled` b = abap_false
        )->a( n = `class`         v = `sapUiSmallMargin` ).

    DATA(table) = page->ele( `Table`
        )->a( n = `items`      v = client->_bind( t_received )
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `noDataText` v = `No file has reached the backend yet.` ).

    table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Received in the backend`

            )->tag( `ToolbarSpacer`

            )->tag( `Button`
                )->a( n = `press` v = client->_event( `CLEAR` )
                )->a( n = `text`  v = `Clear`
                )->a( n = `icon`  v = `sap-icon://delete` ).

    table->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `File`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Media type`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Bytes` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`
                )->tag( `Text`
                    )->a( n = `text` v = `{TYPE}`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = `{BYTES}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
