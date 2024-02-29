CLASS Z2UI5_CL_DEMO_APP_005 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_005 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Range Slider Example'
                navbuttonpress = client->_event( 'BACK' )
                 shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
             ).

    DATA(grid) = page->grid( 'L12 M12 S12' )->content( 'layout' ).

    grid->simple_form( title = 'More Controls' editable = abap_true )->content( 'form'
        )->label( 'Range Slider'
        )->range_slider(
            max           = '100'
            min           = '0'
            step          = '10'
            startvalue    = '10'
            endvalue      = '20'
            showtickmarks = abap_true
            labelinterval = '2'
            width         = '80%'
            class         = 'sapUiTinyMargin'
    ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
