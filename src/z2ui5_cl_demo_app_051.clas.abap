CLASS z2ui5_cl_demo_app_051 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF screen,
        input1 TYPE string,
        input2 TYPE string,
        input3 TYPE string,
      END OF screen.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_051 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Label Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).
    layout->label( text     = `Input mandatory`
                   labelfor = `input1` ).
    layout->input( id       = `input1`
                   required = abap_true ).

    layout->label( text     = `Input bold`
                   labelfor = `input2`
                   design   = `Bold` ).
    layout->input( id    = `input2`
                   value = client->_bind_edit( screen-input2 ) ).

    layout->label( text     = `Input normal`
                   labelfor = `input3` ).
    layout->input( id    = `input3`
                   value = client->_bind_edit( screen-input3 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
