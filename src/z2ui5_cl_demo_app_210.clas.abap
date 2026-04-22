CLASS z2ui5_cl_demo_app_210 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_210 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Types`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    layout->label( text     = `Text`
                   labelfor = `inputText` ).
    layout->input( id          = `inputText`
                   placeholder = `Enter text`
                   class       = `sapUiSmallMarginBottom` ).

    layout->label( text     = `Email`
                   labelfor = `inputEmail` ).
    layout->input( id          = `inputEmail`
                   type        = `Email`
                   placeholder = `Enter email`
                   class       = `sapUiSmallMarginBottom` ).

    layout->label( text     = `Telephone`
                   labelfor = `inputTel` ).
    layout->input( id          = `inputTel`
                   type        = `Tel`
                   placeholder = `Enter telephone number`
                   class       = `sapUiSmallMarginBottom` ).

    layout->label( text     = `Number`
                   labelfor = `inputNumber` ).
    layout->input( id          = `inputNumber`
                   type        = `Number`
                   placeholder = `Enter a number`
                   class       = `sapUiSmallMarginBottom` ).

    layout->label( text     = `URL`
                   labelfor = `inputUrl` ).
    layout->input( id          = `inputUrl`
                   type        = `Url`
                   placeholder = `Enter URL`
                   class       = `sapUiSmallMarginBottom` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
