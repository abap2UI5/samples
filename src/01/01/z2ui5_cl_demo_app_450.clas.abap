CLASS z2ui5_cl_demo_app_450 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA dats         TYPE string.
    DATA tims         TYPE string.
    DATA dats_initial TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_450 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " the 8/6-character forms an ABAP DATS/TIMS value has when it travels
      " as a string (a CHAR(8) key, a legacy structure field). A field typed
      " d or t is serialized as ISO by the framework and needs
      " Formatter.DateCreateObject instead - see sample 457
      dats         = `20260720`.
      tims         = `134501`.
      dats_initial = `00000000`.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " require the framework's curated formatter module into the view, like an
    " original UI5 app requires its model/formatter. DateAbapDateToDateObject
    " and DateAbapDateTimeToDateObject turn the ABAP date strings into the
    " real JS Date that an object-typed property (dateValue) demands - JSON
    " has no date type, so this is the one conversion the backend cannot do.
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter: 'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Formatter - ABAP date strings`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The model carries the plain ABAP strings 20260720 / 134501; the curated formatter ` &&
                   `converts them at the binding. An initial DATS (00000000) yields null, so the field ` &&
                   `stays empty instead of rendering a wrong 1899 date.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the paths must come from a bind call - a hardcoded path is never
    " registered in the model and the frontend receives no data for it
    page->simple_form(
            title    = `DATS / TIMS strings as date objects`
            editable = abap_true
            )->content( `form`
            )->label( `DATS 20260720`
            )->date_picker(
                displayformat = `long`
                editable      = abap_false
                datevalue     = |\{ path: '{ client->_bind( val = dats path = abap_true ) }', | &&
                                |formatter: 'Formatter.DateAbapDateToDateObject' \}|
            )->label( `DATS 00000000 (initial)`
            )->date_picker(
                displayformat = `long`
                editable      = abap_false
                placeholder   = `no date`
                datevalue     = |\{ path: '{ client->_bind( val = dats_initial path = abap_true ) }', | &&
                                |formatter: 'Formatter.DateAbapDateToDateObject' \}|
            )->label( `DATS 20260720 + TIMS 134501`
            )->_generic(
                name   = `DateTimePicker`
                t_prop = VALUE #(
                    ( n = `editable`  v = `false` )
                    ( n = `dateValue` v = |\{ parts: [\{path: '{ client->_bind( val = dats path = abap_true ) }'\}, | &&
                                          |\{path: '{ client->_bind( val = tims path = abap_true ) }'\}], | &&
                                          |formatter: 'Formatter.DateAbapDateTimeToDateObject' \}| ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
