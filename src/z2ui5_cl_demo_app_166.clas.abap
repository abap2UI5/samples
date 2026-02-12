CLASS z2ui5_cl_demo_app_166 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_struc_incl,
        incl_title  TYPE string,
        incl_value  TYPE string,
        incl_value2 TYPE string,
      END OF ty_struc_incl.

    TYPES:
      BEGIN OF ty_struc,
        title  TYPE string,
        value  TYPE string,
        value2 TYPE string,
      END OF ty_struc.
    DATA ms_struc TYPE ty_struc.

    DATA
      BEGIN OF ms_struc2.
        INCLUDE TYPE ty_struc.
        INCLUDE TYPE ty_struc_incl.
    DATA END OF ms_struc2.

    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_166 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title          = `abap2UI5 - Binding Structure Level`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->input( mo_client->_bind_edit( ms_struc-title ) ).
    lo_page->input( mo_client->_bind_edit( ms_struc-value ) ).
    lo_page->input( mo_client->_bind_edit( ms_struc-value2 ) ).

    lo_page->input( mo_client->_bind_edit( ms_struc2-title ) ).
    lo_page->input( mo_client->_bind_edit( ms_struc2-value ) ).
    lo_page->input( mo_client->_bind_edit( ms_struc2-value2 ) ).

    lo_page->input( mo_client->_bind_edit( ms_struc2-incl_title ) ).
    lo_page->input( mo_client->_bind_edit( ms_struc2-incl_value ) ).
    lo_page->input( mo_client->_bind_edit( ms_struc2-incl_value2 ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      ms_struc-title  = `title`.
      ms_struc-value  = `val01`.
      ms_struc-value2 = `val02`.

      ms_struc2-title  = `title`.
      ms_struc2-value  = `val01`.
      ms_struc2-value2 = `val02`.
      ms_struc2-incl_title = `title_incl`.
      ms_struc2-incl_value = `val01_incl`.
      ms_struc2-incl_value2 = `val02_incl`.

      set_view( ).
    ENDIF.
    mo_client->view_model_update( ).
  ENDMETHOD.
ENDCLASS.
