class Z2UI5_CL_DEMO_APP_228 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_228 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Numeric Content Without Margins'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->label( text = `Numeric content with margins` ).
    layout->numeric_content( value = `65.5` scale = `MM` class = `sapUiSmallMargin`
                             withmargin = abap_true ).
    layout->numeric_content( value = `65.5` scale = `MM`
                             valueColor = `Good` indicator = `Up` class = `sapUiSmallMargin`
                             withmargin = abap_true ).
    layout->numeric_content( value = `6666` scale = `MM`
                             valueColor = `Critical` indicator = `Up` class = `sapUiSmallMargin`
                             withmargin = abap_true ).
    layout->numeric_content( value = `65.5` scale = `MM`
                             valueColor = `Error` indicator = `Down` class = `sapUiSmallMargin`
                             withmargin = abap_true ).

    layout->label( text = `Numeric content without margins` ).
    layout->numeric_content( value = `65.5` scale = `MM` class = `sapUiSmallMargin`
                             withmargin = abap_false ).
    layout->numeric_content( value = `65.5` scale = `MM`
                             valueColor = `Good` indicator = `Up` class = `sapUiSmallMargin`
                             withmargin = abap_false ).
    layout->numeric_content( value = `6666` scale = `MM`
                             valueColor = `Critical` indicator = `Up` class = `sapUiSmallMargin`
                             withmargin = abap_false ).
    layout->numeric_content( value = `65.5` scale = `MM`
                             valueColor = `Error` indicator = `Down` class = `sapUiSmallMargin`
                             withmargin = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
