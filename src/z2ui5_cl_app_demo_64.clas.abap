CLASS z2ui5_cl_app_demo_64 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_user TYPE string.
    DATA mv_game TYPE string.

    DATA mt_tab TYPE string_table.
    DATA mv_message TYPE string.
    DATA check_db_load TYPE abap_bool.

*    DATA:
*      BEGIN OF screen,
*        check_is_active TYPE abap_bool,
*        colour          TYPE string,
*      END OF screen.

    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS call_newest_state
      IMPORTING
                i_client      TYPE REF TO z2ui5_if_client
      RETURNING VALUE(result) TYPE abap_bool.

  PROTECTED SECTION.

    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.


  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_64 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    CASE client->get( )-event.

      WHEN 'REFRESH' OR 'SEND'.

        IF check_db_load = abap_false.
          IF call_newest_state( client ).
            RETURN.
          ENDIF.
        ENDIF.

        check_db_load = abap_false.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.

    z2ui5_on_rendering( client ).

    MODIFY z2ui5_t_demo_01 FROM @( VALUE #( uuid = client->get( )-id name = 'TEST02' game = mv_game ) ).
    COMMIT WORK.

  ENDMETHOD.




  METHOD z2ui5_on_rendering.

    DATA(page) = z2ui5_cl_xml_view=>factory( client )->shell(
         )->page(
            title          = 'abap2UI5 - Game Example'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = page->hlp_get_source_code_url(  )
         )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA(lv_val) = ``.
    LOOP AT mt_tab INTO DATA(lv_text).
      lv_val = lv_val && lv_text.
    ENDLOOP.

    grid->simple_form( 'Input'
        )->content( 'form'
            )->button( text = 'refresh' press = client->_event( `REFRESH` )
            )->label( 'Input with value help'
            )->input( value = client->_bind_edit( mv_message )
             )->button( text = 'send' press = client->_event( `SEND` )
            )->text_area(
                    value  = lv_val
            ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD call_newest_state.

    SELECT SINGLE FROM z2ui5_t_demo_01
          FIELDS *
          WHERE name = 'TEST02' AND
                game = @mv_game
          INTO @DATA(ls_data).

    IF sy-subrc = 0 AND ls_data-uuid <> client->get( )-id.
      SELECT SINGLE FROM z2ui5_t_draft
       FIELDS *
      WHERE uuid = @ls_data-uuid
     INTO @DATA(ls_draft).

      IF sy-subrc = 0.
        DATA(app) = CAST z2ui5_cl_app_demo_64( i_client->get_app( ls_draft-uuid ) ).
        app->mv_user = mv_user.
        IF mv_message IS NOT INITIAL.
          INSERT mv_user && `:` && mv_message INTO TABLE app->mt_tab.
        ENDIF.
        app->check_db_load = abap_true.
        i_client->nav_app_leave(  app ).
        result = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
