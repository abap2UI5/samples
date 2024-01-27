CLASS z2ui5_cl_demo_app_152 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
      END OF ty_row.
    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_check_initialized TYPE abap_bool.
    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_152 IMPLEMENTATION.


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.

        mt_tab = VALUE #( descr = 'this is a description'
             (  title = 'title_01'  value = 'value_01' )
             (  title = 'title_02'  value = 'value_02' )
             (  title = 'title_03'  value = 'value_03' )
             (  title = 'title_04'  value = 'value_04' )
             (  title = 'title_05'  value = 'value_05' ) ).

        DATA(lo_app) = z2ui5_cl_popup_to_select=>factory( mt_tab ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup To Select'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                    )->get_parent(
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      IF mv_check_initialized = abap_false.
        mv_check_initialized = abap_true.
        ui5_display( ).
      ELSE.
        ui5_callback( ).
      ENDIF.
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

  METHOD ui5_callback.

    TRY.
        DATA(lo_prev) = client->get_app( client->get(  )-s_draft-id_prev_app ).
        DATA(ls_result) = CAST z2ui5_cl_popup_to_select( lo_prev )->result( ).
        FIELD-SYMBOLS <row> TYPE ty_row.
        ASSIGN ls_result-row->* TO <row>.
        client->message_box_display( `callback after popup to select: ` && <row>-title ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
