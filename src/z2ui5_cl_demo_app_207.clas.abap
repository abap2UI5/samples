CLASS z2ui5_cl_demo_app_207 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA check_initialized TYPE abap_bool .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_207 IMPLEMENTATION.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Radio Button`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vbox( class = `sapUiSmallMargin`
                          )->label( text     = `Default RadioButton use`
                                    labelfor = `GroupA`
                          )->radio_button_group( id = `GroupA`
                              )->radio_button( text     = `Option 1`
                                               selected = abap_true )->get_parent(
                              )->radio_button( text = `Option 2` )->get_parent(
                              )->radio_button( text = `Option 3` )->get_parent(
                              )->radio_button( text = `Option 4` )->get_parent(
                              )->radio_button( text = `Option 5` )->get_parent( )->get_parent( )->get_parent(
                      )->vbox( class = `sapUiSmallMargin`
                          )->label( text = `RadioButton in various ValueState variants`
                          )->hbox( class = `sapUiTinyMarginTopBottom`
                              )->vbox( class = `sapUiMediumMarginEnd`
                                  )->label( text     = `Success`
                                            labelfor = `GroupB`
                                  )->radio_button_group( id         = `GroupB`
                                                         valuestate = `Success`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                              )->vbox( class = `sapUiMediumMarginEnd`
                                  )->label( text     = `Error`
                                            labelfor = `GroupC`
                                  )->radio_button_group( id         = `GroupC`
                                                         valuestate = `Error`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                              )->vbox( class = `sapUiMediumMarginEnd`
                                  )->label( text     = `Warning`
                                            labelfor = `GroupD`
                                  )->radio_button_group( id         = `GroupD`
                                                         valuestate = `Warning`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                              )->vbox( class = `sapUiMediumMarginEnd`
                                  )->label( text     = `Information`
                                            labelfor = `GroupE`
                                  )->radio_button_group( id         = `GroupE`
                                                         valuestate = `Information`
                                      )->radio_button( text     = `Option 1`
                                                       selected = abap_true )->get_parent(
                                      )->radio_button( text = `Option 2` )->get_parent( ).

    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
