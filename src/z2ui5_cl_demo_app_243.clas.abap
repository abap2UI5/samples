CLASS z2ui5_cl_demo_app_243 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

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


CLASS z2ui5_cl_demo_app_243 IMPLEMENTATION.

  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( title          = 'abap2UI5 - Sample: Negative Margins'
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )

         )->page( showheader = `false`
                  class      = `sapUiContentPadding`
             )->sub_header( )->toolbar( design = `Info`
                 )->icon( src = `sap-icon://begin`
                     )->text(
                         text = `This sample demonstrates classes which let you to add negative margin at two opposite sides (begin/end).` )->get_parent( )->get_parent( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(layout) = page->panel( class = `sapUiTinyNegativeMarginBeginEnd`
                             )->content(
                                 )->text(
                                     text  = `This panel uses margin class 'sapUiTinyNegativeMarginBeginEnd' to add a -0.5rem space at the panel's left and right sides.`
                                     class = `sapMH4FontSize` )->get_parent( )->get_parent(
                         )->panel( class = `sapUiSmallNegativeMarginBeginEnd`
                             )->content(
                                 )->text(
                                     text  = `This panel uses margin class 'sapUiSmallNegativeMarginBeginEnd' to add a -1rem space at the panel's left and right sides.`
                                     class = `sapMH4FontSize` )->get_parent( )->get_parent(
                         )->panel( class = `sapUiMediumNegativeMarginBeginEnd`
                             )->content(
                                 )->text(
                                     text  = `This panel uses margin class 'sapUiMediumNegativeMarginBeginEnd' to add a -2rem space at the panel's left and right sides.`
                                     class = `sapMH4FontSize` )->get_parent( )->get_parent(
                         )->panel( class = `sapUiLargeNegativeMarginBeginEnd`
                             )->content(
                                 )->text(
                                     text  = `This panel uses margin class 'sapUiLargeNegativeMarginBeginEnd' to add a -3rem space at the panel's left and right sides.`
                                     class = `sapMH4FontSize`
               ).

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
