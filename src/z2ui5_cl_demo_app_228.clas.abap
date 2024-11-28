CLASS z2ui5_cl_demo_app_228 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_228 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Numeric Content Without Margins'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->label( text = `Numeric content with margins` ).
    layout->numeric_content( value      = `65.5`
                             scale      = `MM`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_true ).
    layout->numeric_content( value      = `65.5`
                             scale      = `MM`
                             valuecolor = `Good`
                             indicator  = `Up`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_true ).
    layout->numeric_content( value      = `6666`
                             scale      = `MM`
                             valuecolor = `Critical`
                             indicator  = `Up`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_true ).
    layout->numeric_content( value      = `65.5`
                             scale      = `MM`
                             valuecolor = `Error`
                             indicator  = `Down`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_true ).

    layout->label( text = `Numeric content without margins` ).
    layout->numeric_content( value      = `65.5`
                             scale      = `MM`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_false ).
    layout->numeric_content( value      = `65.5`
                             scale      = `MM`
                             valuecolor = `Good`
                             indicator  = `Up`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_false ).
    layout->numeric_content( value      = `6666`
                             scale      = `MM`
                             valuecolor = `Critical`
                             indicator  = `Up`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_false ).
    layout->numeric_content( value      = `65.5`
                             scale      = `MM`
                             valuecolor = `Error`
                             indicator  = `Down`
                             class      = `sapUiSmallMargin`
                             withmargin = abap_false ).

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
