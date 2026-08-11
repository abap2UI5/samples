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

    IF client->check_on_init( ).

      s_result = VALUE #( product  = `Notebook Basic 15`
                          quantity = `2` ).

      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( `CONFIRM` ).
      client->nav_app_leave( event  = `DATA_CONFIRMED`
                             r_data = s_result ).

    ELSEIF client->check_on_event( `CANCEL` ).
      client->nav_app_leave( event = `DATA_CANCELLED` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Navigation - Data Input App`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Change the data and return: 'confirm' leaves with event DATA_CONFIRMED plus the ` &&
                   `entered data as r_data, 'cancel' leaves with event DATA_CANCELLED and no data. ` &&
                   `The nav-back button of the page leaves without an event.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(form) = page->grid( `L6 M12 S12`
        )->content( `layout`
        )->simple_form(
            title    = `Data returned to the caller`
            editable = abap_true
        )->content( `form` ).

    form->label( `Product` ).
    form->input( client->_bind( s_result-product ) ).

    form->label( `Quantity` ).
    form->input( client->_bind( s_result-quantity ) ).

    form->label( `Return to the caller` ).
    form->button(
        text  = `confirm (event + r_data)`
        type  = `Emphasized`
        press = client->_event( `CONFIRM` ) ).
    form->button(
        text  = `cancel (event only)`
        press = client->_event( `CANCEL` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
