CLASS z2ui5_cl_demo_app_207 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_207 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Radio Button`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vbox( `sapUiSmallMargin`
                          )->label( text     = `Default RadioButton use`
                                    labelfor = `GroupA`
                          )->radio_button_group( id = `GroupA`
                              )->radio_button( text     = `Option 1`
                                               selected = abap_true )->get_parent(
                              )->radio_button( text = `Option 2` )->get_parent(
                              )->radio_button( text = `Option 3` )->get_parent(
                              )->radio_button( text = `Option 4` )->get_parent(
                              )->radio_button( text = `Option 5` )->get_parent( )->get_parent( )->get_parent(
                      )->vbox( `sapUiSmallMargin`
                          )->label( `RadioButton in various ValueState variants`
                          )->hbox( class = `sapUiTinyMarginTopBottom`
                              )->vbox( `sapUiMediumMarginEnd`
                                  )->label( text     = `Success`
                                            labelfor = `GroupB`
                                  )->radio_button_group( id         = `GroupB`
                                                         valuestate = `Success`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                              )->vbox( `sapUiMediumMarginEnd`
                                  )->label( text     = `Error`
                                            labelfor = `GroupC`
                                  )->radio_button_group( id         = `GroupC`
                                                         valuestate = `Error`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                              )->vbox( `sapUiMediumMarginEnd`
                                  )->label( text     = `Warning`
                                            labelfor = `GroupD`
                                  )->radio_button_group( id         = `GroupD`
                                                         valuestate = `Warning`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                              )->vbox( `sapUiMediumMarginEnd`
                                  )->label( text     = `Information`
                                            labelfor = `GroupE`
                                  )->radio_button_group( id         = `GroupE`
                                                         valuestate = `Information`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
