CLASS z2ui5_cl_demo_app_228 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_228 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Numeric Content Without Margins`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->label( `Numeric content with margins` ).
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

    layout->label( `Numeric content without margins` ).
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


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
