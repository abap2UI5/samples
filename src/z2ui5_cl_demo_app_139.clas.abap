CLASS z2ui5_cl_demo_app_139 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_search  TYPE string.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_view.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_139 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      mv_search = mo_client->get( )-s_config-search && `my_search_string`.
      display_view( ).

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `SET_VIEW`.
        display_view( ).
        mo_client->message_toast_display( |{ mv_search } - title changed| ).
      WHEN `BACK`.
        mo_client->nav_app_leave( ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_tmp) = lo_view->_z2ui5( )->history( mo_client->_bind_edit( mv_search )
         )->shell(
         )->page(
                 title          = `abap2UI5 - Change URL History`
                 navbuttonpress = mo_client->_event( `BACK` )
                 shownavbutton  = mo_client->check_app_prev_stack( )
             )->simple_form( title    = `Form Title`
                             editable = abap_true
                 )->content( `form`
                     )->title( `Input`
                     )->label( `search`
                     )->input( mo_client->_bind_edit( mv_search ) ).

    mo_client->view_display( lo_tmp->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
