CLASS z2ui5_cl_demo_app_010 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_010 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Demo Layout`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->button( text = `button` ).

    page->sub_header(
        )->overflow_toolbar(
            )->button( text = `button`
            )->text( `text`
            )->link( text = `link`
            )->toolbar_spacer(
            )->text( `subheader`
            )->toolbar_spacer(
            )->button( text = `button`
            )->text( `text`
            )->link( text = `link` ).

    DATA(grid) = page->grid( `L4 M4 S4` )->content( `layout` ).

    grid->simple_form( `Grid width 33%` )->content( `form`
        )->button( text = `button`
        )->text( `text`
        )->link( text = `link` ).

    grid->simple_form( `Grid width 33%` )->content( `form`
        )->button( text = `button`
        )->text( `text`
        )->link( text = `link` ).

    grid->simple_form( `Grid width 33%` )->content( `form`
        )->button( text = `button`
        )->text( `text`
        )->link( text = `link` ).

    grid = page->grid( `L12 M12 S12` )->content( `layout` ).

    grid->simple_form( `grid width 100%` )->content( `form`
        )->button( text = `button`
        )->text( `text`
        )->link( text = `link` ).

    page->footer(
        )->overflow_toolbar(
            )->button( text = `button`
            )->text( `text`
            )->link( text = `link`
            )->toolbar_spacer(
            )->text( `footer`
            )->toolbar_spacer(
            )->text( `text`
            )->link( text = `link`
            )->button(
                text = `reject`
                type = `Reject`
            )->button(
                text = `accept`
                type = `Success` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
