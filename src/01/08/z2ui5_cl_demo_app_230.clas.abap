CLASS z2ui5_cl_demo_app_230 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_230 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Segmented Button in Input List Item`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->list(
                          headertext = `Input List Item`
                          )->input_list_item( `Battery Saving`
                              )->segmented_button( `SBYes`
                                  )->items(
                                      )->segmented_button_item( text = `High`
                                                                key  = `SBYes`
                                      )->segmented_button_item( text = `Low`
                                      )->segmented_button_item( text = `Off` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
