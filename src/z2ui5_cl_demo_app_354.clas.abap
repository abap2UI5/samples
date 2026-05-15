CLASS z2ui5_cl_demo_app_354 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_file,
        filename  TYPE string,
        mediatype TYPE string,
        size      TYPE string,
        data      TYPE string,
      END OF ty_s_file.
    DATA t_files TYPE STANDARD TABLE OF ty_s_file WITH EMPTY KEY.

    DATA filedata        TYPE string.
    DATA filename        TYPE string.
    DATA mediatype       TYPE string.
    DATA filesize        TYPE string.
    DATA removedfilename TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_354 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell( )->page(
          title          = `abap2UI5 - UploadSet Custom Control`
          navbuttonpress = client->_event_nav_app_leave( )
          shownavbutton  = client->check_app_prev_stack( )
          class          = `sapUiContentPadding` ).

      page->_z2ui5( )->uploadset_ext(
          uploadsetid     = `myUploadSet`
          filedata        = client->_bind_edit( filedata )
          filename        = client->_bind_edit( filename )
          mediatype       = client->_bind_edit( mediatype )
          filesize        = client->_bind_edit( filesize )
          removedfilename = client->_bind_edit( removedfilename )
          change          = client->_event( `FILE_ADDED` )
          remove          = client->_event( `FILE_REMOVED` ) ).

      page->upload_set(
              id            = `myUploadSet`
              instantupload = abap_true
              showicons     = abap_true
              uploadenabled = abap_true
              mode          = `MultiSelect`
              items         = client->_bind_edit( t_files )
          )->items( `upload`
              )->upload_set_item(
                  filename  = `{FILENAME}`
                  mediatype = `{MEDIATYPE}` ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `FILE_ADDED` ).

      INSERT VALUE #( filename  = filename
                      mediatype = mediatype
                      size      = filesize
                      data      = filedata ) INTO TABLE t_files.

      filedata  = ``.
      filename  = ``.
      mediatype = ``.
      filesize  = ``.

      client->view_model_update( ).

    ELSEIF client->check_on_event( `FILE_REMOVED` ).

      DELETE t_files WHERE filename = removedfilename.
      removedfilename = ``.

      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
