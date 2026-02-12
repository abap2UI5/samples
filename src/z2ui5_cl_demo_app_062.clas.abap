CLASS z2ui5_cl_demo_app_062 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_062 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Generic Tag Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(lo_layout) = lo_page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).
    lo_layout->generic_tag(
            arialabelledby = `genericTagLabel`
            text           = `Project Cost`
            design         = `StatusIconHidden`
            status         = `Error`
            class          = `sapUiSmallMarginBottom`
        )->object_number(
            state      = `Error`
            emphasized = `false`
            number     = `3.5M`
            unit       = `EUR` ).

    lo_layout->generic_tag(
        arialabelledby = `genericTagLabel`
        text           = `Project Cost`
        design         = `StatusIconHidden`
        status         = `Success`
        class          = `sapUiSmallMarginBottom`
        )->object_number(
            state      = `Success`
            emphasized = `false`
            number     = `3.5M`
            unit       = `EUR` ).

    lo_layout->generic_tag(
        arialabelledby = `genericTagLabel`
        text           = `Input`
        design         = `StatusIconHidden`
        class          = `sapUiSmallMarginBottom`
        )->object_number(
            emphasized = `true`
            number     = `3.5M`
            unit       = `EUR` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
