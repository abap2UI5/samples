"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInput
"! The StepInput allows the user to change stepwise a value by a predefined step and also to set
"! additional description, such as units of measurement and currencies after the input field.
CLASS z2ui5_cl_demo_app_481 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS render_item
      IMPORTING
        list          TYPE REF TO z2ui5_cl_xml_view
        label         TYPE string
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_xml_view.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_481 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( `CHANGE` ).
      client->message_toast_display( |Value changed to '{ client->get_event_arg( 1 ) }'| ).
    ENDIF.

  ENDMETHOD.


  METHOD render_item.

    result = list->custom_list_item(
        )->hbox( class          = `sapUiTinyMargin`
                 justifycontent = `SpaceBetween`
                 alignitems     = `Center`
            )->vbox( `sapUiSmallMarginEnd`
                )->label( text     = label
                          wrapping = abap_true
            )->get_parent(
            )->vbox( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: StepInput`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StepInput/sample/sap.m.sample.StepInput` ).

    DATA(change) = client->_event( val   = `CHANGE`
                                   t_arg = VALUE #( ( `${$parameters>/value}` ) ) ).

    " the original binds the rows from a JSON model - the items are rendered statically here
    " because every row sets a different subset of the StepInput properties
    DATA(list) = page->list( id = `idTable` ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px`
        )->step_input(
            value  = `6`
            min    = `5`
            max    = `15`
            width  = `120px`
            change = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 120px, with validation on LiveChange`
        )->step_input(
            value          = `6`
            min            = `5`
            max            = `15`
            width          = `120px`
            validationmode = `LiveChange`
            change         = change ).

    render_item( list  = list
                 label = `Step = 5, no value, no min, no max, width = 120px`
        )->step_input(
            step   = `5`
            width  = `120px`
            change = change ).

    render_item( list  = list
                 label = `Step = 5, no value, no min, no max, width = 120px, largerStep = 3`
        )->step_input(
            step       = `5`
            width      = `120px`
            largerstep = `3`
            change     = change ).

    render_item( list  = list
                 label = `Step = 1.1, no value, displayValuePrecision = 1, min = -6, max = 23.5, width = 120px`
        )->step_input(
            step                  = `1.1`
            min                   = `-6`
            max                   = `23.5`
            width                 = `120px`
            displayvalueprecision = `1`
            change                = change ).

    render_item( list  = list
                 label = `Disabled, value = 12.3, displayValuePrecision = 1, width = 120px`
        )->step_input(
            value                 = `12.3`
            enabled               = abap_false
            width                 = `120px`
            displayvalueprecision = `1`
            change                = change ).

    render_item( list  = list
                 label = `Read only, value = 123, default width of 100%`
        )->step_input(
            value    = `123`
            editable = abap_false
            change   = change ).

    render_item( list  = list
                 label = `Step = 0.05; value = 1.32, displayValuePrecision = 3, min = -5, max = 15`
        )->step_input(
            value                 = `1.32`
            step                  = `0.05`
            min                   = `-5`
            max                   = `15`
            displayvalueprecision = `3`
            change                = change ).

    render_item( list  = list
                 label = `Step = 1.05; value = 1.5675, displayValuePrecision = 2, no Min and Max`
        )->step_input(
            value                 = `1.5675`
            step                  = `1.05`
            displayvalueprecision = `2`
            change                = change ).

    render_item( list  = list
                 label = `Step = -1 (which becomes 1), value = 20, width = 120px`
        )->step_input(
            value  = `20`
            step   = `-1`
            width  = `120px`
            change = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 6, min = 5, max = 15, width = 240px, with added description and default fieldWidth 50%`
        )->step_input(
            value       = `6`
            min         = `5`
            max         = `15`
            width       = `240px`
            description = `EUR`
            change      = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 160, with added description and fieldWidth set to 70%`
        )->step_input(
            value       = `160`
            fieldwidth  = `70%`
            description = `EUR`
            change      = change ).

    render_item( list  = list
                 label = `Step = 1 (default); value = 160, align:Center`
        )->step_input(
            value     = `160`
            textalign = `Center`
            change    = change ).

    render_item( list  = list
                 label = `Step = 5, stepMode = Multiple, min = -40, max = 100, value = 10,`
        )->step_input(
            value    = `10`
            step     = `5`
            max      = `100`
            min      = `-40`
            stepmode = `Multiple`
            change   = change ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
