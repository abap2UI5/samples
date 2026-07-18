CLASS z2ui5_cl_demo_app_457 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA date_iso TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_457 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      date_iso = `2026-07-20`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " the minimal date-object case: DatePicker.dateValue is typed "object"
    " and demands a real JS Date - a plain string binding crashes view
    " creation. Formatter.DateCreateObject converts the model's ISO string
    " at this one binding; the model itself keeps the plain string (the
    " Text below proves it).
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter: 'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Formatter - Date object minimal`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `dateValue is an object-typed property: the ISO string from the model becomes a ` &&
                   `real JS Date via Formatter.DateCreateObject - only at this binding, the model ` &&
                   `stays a plain string.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the path must come from _bind_edit - a hardcoded binding path is never
    " registered in the model and the frontend receives no data for it
    page->vbox( `sapUiSmallMargin`
        )->date_picker( displayformat = `long`
                        datevalue     = |\{ path: '{ client->_bind_edit( val = date_iso path = abap_true ) }', | &&
                                        |formatter: 'Formatter.DateCreateObject' \}|
        )->text( text  = |Model value (unchanged string): { client->_bind_edit( date_iso ) }|
                 class = `sapUiTinyMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
