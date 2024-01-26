CLASS z2ui5_cl_demo_app_166 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_struc,
        title  TYPE string,
        value  TYPE string,
        value2 TYPE string,
        value3 TYPE string,
        value4 TYPE string,
      END OF ty_struc.
    DATA ms_struc TYPE ty_struc.

    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_166 IMPLEMENTATION.


  METHOD set_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Binding Structure Level'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code' target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).


    page->input( client->_bind_edit( val = ms_struc-title  struc = ms_struc ) ).
    page->input( client->_bind_edit( val = ms_struc-value2 struc = ms_struc ) ).
    page->input( client->_bind_edit( val = ms_struc-value3 struc = ms_struc ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      ms_struc-title  = `title`.
      ms_struc-value  = `val01`.
      ms_struc-value2 = `val01`.
      ms_struc-value3 = `val01`.
      ms_struc-value4 = `val01`.

      set_view(  ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.
ENDCLASS.
