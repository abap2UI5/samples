CLASS z2ui5_cl_demo_app_021 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA textarea TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_021 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      textarea = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magn` &&
                 `a aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd` &&
                 ` gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam n ` &&
                 `  onumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit am ` &&
                 `  et, consetetur sadipscing elitr, sed diam nonumy eirm sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam no ` &&
                 `numy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
           )->page(
               title          = `abap2UI5 - Text Area Example`
               navbuttonpress = client->_event_nav_app_leave( )
               shownavbutton  = client->check_app_prev_stack( ) ).

      DATA(layout) = page->vertical_layout(
          class = `sapUiContentPadding`
          width = `100%` ).

      layout->label( `text area`
          )->text_area(
              valueliveupdate = abap_true
              value           = client->_bind_edit( textarea )
              growing         = abap_true
              growingmaxlines = `7`
              width           = `100%`
          )->button(
              text  = `OK`
              press = client->_event( `POST` ) ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `POST` ).
      client->message_box_display( `success - values send to the server` ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
