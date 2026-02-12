CLASS z2ui5_cl_demo_app_021 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    DATA mv_textarea TYPE string.

  PROTECTED SECTION.

    DATA mo_client            TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_021 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Text Area Example`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_layout) = lo_page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).
    lo_layout->label( `text area`
        )->text_area(
            valueliveupdate = abap_true
            value           = mo_client->_bind_edit( mv_textarea )
            growing         = abap_true
            growingmaxlines = `7`
            width           = `100%`
        )->button( text  = `OK`
                   press = mo_client->_event( `POST` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `POST` ).
      mo_client->message_box_display( `success - values send to the server` ).
    ENDIF.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
      set_data( ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.

  METHOD set_data.

    mv_textarea = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magn` &&
              `a aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd` &&
          ` gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam n ` &&
            `  onumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit am ` &&
            `  et, consetetur sadipscing elitr, sed diam nonumy eirm sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam no ` &&
                  `numy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.
  ENDMETHOD.
ENDCLASS.
