" @keywords datepicker datevalue javascript date object iso
" @summary The DatePicker's dateValue wants a JavaScript date object rather than a string - what that means for the binding of an ABAP date.
" @docs https://abap2ui5.github.io/docs/cookbook/model/formatter
CLASS z2ui5_cl_smp_app_457 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA date_iso TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_457 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      date_iso = `2026-07-20`.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    " the minimal date-object case: DatePicker.dateValue is typed "object"
    " and demands a real JS Date - a plain string binding crashes view
    " creation. Formatter.DateCreateObject converts the model's ISO string
    " at this one binding; the model itself keeps the plain string (the
    " Text below proves it).
    view->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Formatter - Date Object for the DatePicker`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `dateValue is an object-typed property: the ISO string from the model becomes a ` &&
                   `real JS Date via Formatter.DateCreateObject - only at this binding, the model ` &&
                   `stays a plain string.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the path must come from _bind - a hardcoded binding path is never
    " registered in the model and the frontend receives no data for it
    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `DatePicker`
            )->a( n = `displayFormat` v = `long`
            )->a( n = `dateValue`     v = |\{ path: '{ client->_bind( val = date_iso path = abap_true ) }', | &&
                                        |formatter: 'Formatter.DateCreateObject' \}|
        )->tag( `Text`
            )->a( n = `text`  v = |Model value (unchanged string): { client->_bind( date_iso ) }|
            )->a( n = `class` v = `sapUiTinyMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
