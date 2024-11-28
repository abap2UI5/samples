CLASS z2ui5_cl_demo_app_306 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_picture,
        time     TYPE string,
        id       TYPE string,
        name     TYPE string,
        data     TYPE string,
        selected TYPE abap_bool,
      END OF ty_picture.

    DATA mt_picture TYPE STANDARD TABLE OF ty_picture WITH EMPTY KEY.
    DATA mt_picture_out TYPE STANDARD TABLE OF ty_picture WITH EMPTY KEY.
    DATA mv_pic_display TYPE string.
    DATA mv_check_init TYPE abap_bool.
    DATA mv_picture_base TYPE string.

  PROTECTED SECTION.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_306 IMPLEMENTATION.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(cont) = view->shell( ).
    DATA(page) = cont->page( title = 'abap2UI5 - Device Camera Picture'
               navbuttonpress      = client->_event( 'BACK' )
               shownavbutton       = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link( text   = 'Source_Code'
                           target = '_blank'
          )->get_parent( ).

    page->_z2ui5( )->camera_picture(
                      value   = client->_bind_edit( mv_picture_base )
                      onphoto = client->_event( 'CAPTURE' ) ).

    page->list(
        headertext      = 'List Ouput'
        items           = client->_bind_edit( mt_picture_out )
        mode            = `SingleSelectMaster`
        selectionchange = client->_event( 'DISPLAY' )
        )->standard_list_item(
            title       = '{NAME}'
            description = '{NAME}'
            icon        = '{ICON}'
            info        = '{INFO}'
            selected    = `{SELECTED}` ).

    IF mv_pic_display IS NOT INITIAL.
      page->_generic( ns   = 'html'
                      name = 'center'
        )->_generic( ns     = 'html'
                     name   = 'img'
                     t_prop = VALUE #(
        (  n = 'src'  v = mv_pic_display )
        ) ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF mv_check_init = abap_false.
      mv_check_init = abap_true.

      view_display( client ).


    ENDIF.

    CASE client->get( )-event.

      WHEN 'CAPTURE'.
        INSERT VALUE #( data = mv_picture_base time = sy-uzeit ) INTO TABLE mt_picture.
        CLEAR mv_picture_base.
        client->view_model_update( ).

      WHEN 'START'.


      WHEN 'DISPLAY'.
        DATA(lt_sel) = mt_picture_out.
        DELETE lt_sel WHERE selected = abap_false.
        DATA(ls_sel) = lt_sel[ 1 ].
        mv_pic_display = mt_picture[ ls_sel-id ]-data.
        view_display( client ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    mt_picture_out = VALUE #( ).
    LOOP AT mt_picture INTO DATA(ls_pic).
      INSERT VALUE #( name = `picture ` && sy-tabix id = sy-tabix ) INTO TABLE mt_picture_out.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
