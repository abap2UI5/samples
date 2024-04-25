CLASS z2ui5_cl_demo_app_051 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF screen,
        input1 TYPE string,
        input2 TYPE string,
        input3 TYPE string,
      END OF screen.

    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_051 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Label Example'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout( class  = `sapUiContentPadding` width = `100%` ).
    layout->label( text = 'Input mandantory' labelfor = `input1` ).
    layout->input( id = `input1` required = abap_true ).


    layout->label( text = 'Input bold' labelfor = `input2` design = `Bold` ).
    layout->input( id = `input2` value = client->_bind_edit( screen-input2 ) ).

    layout->label( text = 'Input normal' labelfor = `input3` ).
    layout->input( id = `input3` value = client->_bind_edit( screen-input2 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
