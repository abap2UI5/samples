class Z2UI5_CL_DEMO_APP_243 definition
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



CLASS Z2UI5_CL_DEMO_APP_243 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Negative Margins'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )

         )->page( showheader = `false` class = `sapUiContentPadding`
             )->sub_header( )->toolbar( design = `Info`
                 )->icon( src = `sap-icon://begin`
                     )->text( text = `This sample demonstrates classes which let you to add negative margin at two opposite sides (begin/end).` )->get_parent( )->get_parent( ).

 DATA(layout) = page->panel( class = `sapUiTinyNegativeMarginBeginEnd`
                          )->content(
                              )->text( text = `This panel uses margin class 'sapUiTinyNegativeMarginBeginEnd' to add a -0.5rem space at the panel's left and right sides.`
                                       class = `sapMH4FontSize` )->get_parent( )->get_parent(
                      )->panel( class = `sapUiSmallNegativeMarginBeginEnd`
                          )->content(
                              )->text( text = `This panel uses margin class 'sapUiSmallNegativeMarginBeginEnd' to add a -1rem space at the panel's left and right sides.`
                                       class = `sapMH4FontSize` )->get_parent( )->get_parent(
                      )->panel( class = `sapUiMediumNegativeMarginBeginEnd`
                          )->content(
                              )->text( text = `This panel uses margin class 'sapUiMediumNegativeMarginBeginEnd' to add a -2rem space at the panel's left and right sides.`
                                       class = `sapMH4FontSize` )->get_parent( )->get_parent(
                      )->panel( class = `sapUiLargeNegativeMarginBeginEnd`
                          )->content(
                              )->text( text = `This panel uses margin class 'sapUiLargeNegativeMarginBeginEnd' to add a -3rem space at the panel's left and right sides.`
                                       class = `sapMH4FontSize`
            ).

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
