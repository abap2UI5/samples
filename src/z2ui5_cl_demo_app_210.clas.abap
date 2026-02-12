CLASS z2ui5_cl_demo_app_210 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_210 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Types`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(lo_layout) = lo_page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    lo_layout->label( text     = `Text`
                   labelfor = `inputText` ).
    lo_layout->input( id          = `inputText`
                   placeholder = `Enter text`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->label( text     = `Email`
                   labelfor = `inputEmail` ).
    lo_layout->input( id          = `inputEmail`
                   type        = `Email`
                   placeholder = `Enter email`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->label( text     = `Telephone`
                   labelfor = `inputTel` ).
    lo_layout->input( id          = `inputTel`
                   type        = `Tel`
                   placeholder = `Enter telephone number`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->label( text     = `Number`
                   labelfor = `inputNumber` ).
    lo_layout->input( id          = `inputNumber`
                   type        = `Number`
                   placeholder = `Enter a number`
                   class       = `sapUiSmallMarginBottom` ).

    lo_layout->label( text     = `URL`
                   labelfor = `inputUrl` ).
    lo_layout->input( id          = `inputUrl`
                   type        = `Url`
                   placeholder = `Enter URL`
                   class       = `sapUiSmallMarginBottom` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
