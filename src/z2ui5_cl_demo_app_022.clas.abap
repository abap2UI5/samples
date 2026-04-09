CLASS z2ui5_cl_demo_app_022 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA progress_value TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_022 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      progress_value = `3`.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->shell(
          )->page(
              title          = `abap2UI5 - Progress Indicator Example`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( )
          )->vertical_layout(
              class = `sapUiContentPadding`
              width = `100%`
          )->label( `ProgressIndicator`
          )->progress_indicator(
              percentvalue = client->_bind( progress_value )
              displayvalue = `0,44GB of 32GB used`
              showvalue    = abap_true
              state        = `Success` ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
