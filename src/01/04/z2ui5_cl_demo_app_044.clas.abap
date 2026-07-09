CLASS z2ui5_cl_demo_app_044 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_044 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page( title          = `Smallest App`
                 navbuttonpress = client->_event_nav_app_leave( )
                 shownavbutton  = client->check_app_prev_stack( )
            )->label( `Hello World!` ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
