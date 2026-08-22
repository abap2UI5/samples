" @keywords dats tims conversion initial date 00000000 sy-datum
" @summary ABAP DATS and TIMS strings in the view: the conversion in both directions, including what an initial 00000000 has to become.
" @docs https://abap2ui5.github.io/docs/cookbook/model/formatter
CLASS z2ui5_cl_smp_app_450 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_450 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      " the 8/6-character forms an ABAP DATS/TIMS value has when it travels
      " as a string (a CHAR(8) key, a legacy structure field). A field typed
      " d or t is serialized as ISO by the framework and needs
      " Formatter.DateCreateObject instead - see sample 457
      dats         = `20260720`.
      tims         = `134501`.
      dats_initial = `00000000`.
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
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    " require the framework's curated formatter module into the view, like an
    " original UI5 app requires its model/formatter. DateAbapDateToDateObject
    " and DateAbapDateTimeToDateObject turn the ABAP date strings into the
    " real JS Date that an object-typed property (dateValue) demands - JSON
    " has no date type, so this is the one conversion the backend cannot do.
    view->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Formatter - ABAP Date and Time Strings (DATS/TIMS)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The model carries the plain ABAP strings 20260720 / 134501; the curated formatter ` &&
                   `converts them at the binding. An initial DATS (00000000) yields null, so the field ` &&
                   `stays empty instead of rendering a wrong 1899 date.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the paths must come from a bind call - a hardcoded path is never
    " registered in the model and the frontend receives no data for it
    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `DATS / TIMS strings as date objects`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `DATS 20260720`
            )->tag( `DatePicker`
                )->a( n = `displayFormat` v = `long`
                )->a( n = `dateValue`     v = |\{ path: '{ client->_bind( val = dats path = abap_true ) }', | &&
                                |formatter: 'Formatter.DateAbapDateToDateObject' \}|
                )->a( n = `editable`      b = abap_false
            )->tag( `Label`
                )->a( n = `text` v = `DATS 00000000 (initial)`
            )->tag( `DatePicker`
                )->a( n = `displayFormat` v = `long`
                )->a( n = `placeholder`   v = `no date`
                )->a( n = `dateValue`     v = |\{ path: '{ client->_bind( val = dats_initial path = abap_true ) }', | &&
                                |formatter: 'Formatter.DateAbapDateToDateObject' \}|
                )->a( n = `editable`      b = abap_false
            )->tag( `Label`
                )->a( n = `text` v = `DATS 20260720 + TIMS 134501`
            )->ele( `DateTimePicker`
                )->a( n = `editable`  v = `false`
                )->a( n = `dateValue` v = |\{ parts: [\{path: '{ client->_bind( val = dats path = abap_true ) }'\}, | &&
                                          |\{path: '{ client->_bind( val = tims path = abap_true ) }'\}], | &&
                                          |formatter: 'Formatter.DateAbapDateTimeToDateObject' \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
