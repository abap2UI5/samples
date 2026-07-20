CLASS z2ui5_cl_demo_app_005 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value1 TYPE int4.
    DATA value2 TYPE int4.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_005 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA grid TYPE REF TO z2ui5_cl_xml_view.

    IF client->check_on_init( ) IS NOT INITIAL.

      value1 = 10.
      value2 = 90.

    ELSEIF client->check_on_event( `SLIDER_CHANGE` ) IS NOT INITIAL.
      client->message_toast_display( |Range Slider { cl_abap_char_utilities=>newline }value1 { value1 } { cl_abap_char_utilities=>newline }value2 { value2 }| ).
    ENDIF.

    
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Range Slider Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    
    grid = page->grid( `L12 M12 S12`
        )->content( `layout` ).

    grid->simple_form(
        title    = `More Controls`
        editable = abap_true
        )->content( `form`
        )->label( `Range Slider`
        )->range_slider(
            max           = `100`
            min           = `0`
            step          = `10`
            startvalue    = `10`
            endvalue      = `20`
            showtickmarks = abap_true
            labelinterval = `2`
            width         = `80%`
            class         = `sapUiTinyMargin`
            value         = client->_bind( value1 )
            value2        = client->_bind( value2 )
            change        = client->_event( `SLIDER_CHANGE` ) ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
