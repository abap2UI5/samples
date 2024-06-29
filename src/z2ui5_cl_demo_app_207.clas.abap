class Z2UI5_CL_DEMO_APP_207 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
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



CLASS Z2UI5_CL_DEMO_APP_207 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Radio Button`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vbox( class = `sapUiSmallMargin`
                          )->label( text = `Default RadioButton use` labelfor = `GroupA`
                              )->radio_button_group( id = `GroupA`
                                  )->radio_button( text = `Option 1` selected = abap_true )->get_parent(
                                  )->radio_button( text = `Option 2` )->get_parent(
                                  )->radio_button( text = `Option 3` )->get_parent(
                                  )->radio_button( text = `Option 4` )->get_parent(
                                  )->radio_button( text = `Option 5` )->get_parent( )->get_parent( )->get_parent(
                      )->vbox( class = `sapUiSmallMargin`
                          )->label( text = `RadioButton in various ValueState variants`
                              )->hbox( class = `sapUiTinyMarginTopBottom`
                                  )->vbox( class = `sapUiMediumMarginEnd`
                                      )->label( text = `Success` labelfor = `GroupB`
                                          )->radio_button_group( id = `GroupB` valueState = `Success`
                                              )->radio_button( text = `Option 1` selected = abap_true )->get_parent(
                                              )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                                  )->vbox( class = `sapUiMediumMarginEnd`
                                      )->label( text = `Error` labelfor = `GroupC`
                                          )->radio_button_group( id = `GroupC` valueState = `Error`
                                              )->radio_button( text = `Option 1` selected = abap_true )->get_parent(
                                              )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                                  )->vbox( class = `sapUiMediumMarginEnd`
                                      )->label( text = `Warning` labelfor = `GroupD`
                                          )->radio_button_group( id = `GroupD` valueState = `Warning`
                                              )->radio_button( text = `Option 1` selected = abap_true )->get_parent(
                                              )->radio_button( text = `Option 2` )->get_parent( )->get_parent( )->get_parent(
                                  )->vbox( class = `sapUiMediumMarginEnd`
                                      )->label( text = `Information` labelfor = `GroupE`
                                          )->radio_button_group( id = `GroupE` valueState = `Information`
                                              )->radio_button( text = `Option 1` selected = abap_true )->get_parent(
                                              )->radio_button( text = `Option 2` )->get_parent(
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
