CLASS z2ui5_cl_demo_app_010 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_010 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = 'abap2UI5 - Demo Layout'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
      )->button( text = 'button' ).

    page->sub_header(
        )->overflow_toolbar(
            )->button( text = 'button'
            )->text( 'text'
            )->link( text = 'link'
            )->toolbar_spacer(
            )->text( 'subheader'
            )->toolbar_spacer(
            )->button( text = 'button'
            )->text( 'text'
            )->link( text = 'link' ).

    DATA(grid) = page->grid( 'L4 M4 S4' )->content( 'layout' ).

    grid->simple_form( 'Grid width 33%' )->content( 'form'
       )->button( text = 'button'
       )->text( 'text'
       )->link( text = 'link' ).

    grid->simple_form( 'Grid width 33%' )->content( 'form'
      )->button( text = 'button'
      )->text( 'text'
      )->link( text = 'link' ).

    grid->simple_form( 'Grid width 33%' )->content( 'form'
      )->button( text = 'button'
      )->text( 'text'
      )->link( text = 'link' ).

    grid = page->grid( 'L12 M12 S12' )->content( 'layout' ).

    grid->simple_form( 'grid width 100%' )->content( 'form'
      )->button( text = 'button'
      )->text( 'text'
      )->link( text = 'link' ).

    page->footer(
        )->overflow_toolbar(
            )->button( text = 'button'
            )->text( 'text'
            )->link( text = 'link'
            )->toolbar_spacer(
            )->text( 'footer'
            )->toolbar_spacer(
            )->text( 'text'
            )->link( text = 'link'
            )->button( text = 'reject'
                       type = 'Reject'
            )->button( text = 'accept'
                       type = 'Success' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
