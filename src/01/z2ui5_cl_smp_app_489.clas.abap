"! Input page called by z2ui5_cl_smp_app_488. It returns to its caller with
"! client->nav_app_leave( event = ... r_data = ... ) - handing back an event
"! name and the entered data without knowing which app called it (no
"! get_app_prev( ), no cast to the caller's class). This app is a hidden
"! helper (never listed on its own in the overview).
CLASS z2ui5_cl_smp_app_489 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_result,
             product  TYPE string,
             quantity TYPE string,
           END OF ty_s_result.
    DATA s_result TYPE ty_s_result.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_489 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      CLEAR s_result.
      s_result-product = `Notebook Basic 15`.
      s_result-quantity = `2`.

      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `CONFIRM` ) IS NOT INITIAL.
      client->nav_app_leave( event  = `DATA_CONFIRMED`
                             r_data = s_result ).

    ELSEIF client->check_on_event( `CANCEL` ) IS NOT INITIAL.
      client->nav_app_leave( event = `DATA_CANCELLED` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Navigation - Data Input App`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Change the data and return: 'confirm' leaves with event DATA_CONFIRMED plus the ` &&
                   `entered data as r_data, 'cancel' leaves with event DATA_CANCELLED and no data. ` &&
                   `The nav-back button of the page leaves without an event.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title`    v = `Data returned to the caller`
                )->a( n = `editable` b = abap_true
                )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `Product` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( s_result-product ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Quantity` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( s_result-quantity ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Return to the caller` ).
    form->tag( `Button`
        )->a( n = `press` v = client->_event( `CONFIRM` )
        )->a( n = `text`  v = `confirm (event + r_data)`
        )->a( n = `type`  v = `Emphasized` ).
    form->tag( `Button`
        )->a( n = `press` v = client->_event( `CANCEL` )
        )->a( n = `text`  v = `cancel (event only)` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
