class z2ui5_cl_demo_app_234 definition
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



CLASS z2ui5_cl_demo_app_234 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: TextArea - Value States'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout(
                         class  = `sapUiContentPadding`
                         width = `100%`
                          )->content( ns = `layout`
                              )->text_area( valueState = `Warning` placeholder = `ValueState : Warning` width = `100%`
                              )->text_area( valueState = `Error` placeholder = `ValueState : Error` width = `100%`
                              )->text_area( valueState = `Success` placeholder = `ValueState : Success` width = `100%`
                              )->text_area( valueState = `Information` placeholder = `ValueState : Information` width = `100%` ).

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
