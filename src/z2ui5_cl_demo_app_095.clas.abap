CLASS z2ui5_cl_demo_app_095 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_01,
        input TYPE string,
        BEGIN OF ty_s_02,
          input TYPE string,
          BEGIN OF ty_s_03,
            input TYPE string,
            BEGIN OF ty_s_04,
              input TYPE string,
            END OF ty_s_04,
          END OF ty_s_03,
        END OF ty_s_02,
      END OF ty_s_01.
    DATA ms_screen TYPE ty_s_01.

    DATA mo_app_sub TYPE REF TO z2ui5_cl_demo_app_096.

    DATA mo_client      TYPE REF TO z2ui5_if_client.
    DATA mv_init     TYPE abap_bool.
    DATA mo_grid_sub TYPE REF TO z2ui5_cl_xml_view.

    METHODS on_init.
    METHODS on_event.
    METHODS view_build.
    METHODS on_init_sub.
    METHODS on_event_sub.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_page TYPE REF TO z2ui5_cl_xml_view.

ENDCLASS.

CLASS z2ui5_cl_demo_app_095 IMPLEMENTATION.

  METHOD on_event.

    IF mo_client->check_on_event( `BUTTON_SAVE` ).
      mo_client->message_box_display( `event main app` ).
    ENDIF.
  ENDMETHOD.

  METHOD on_event_sub.

    mo_app_sub->mo_view_parent = mo_grid_sub.
    mo_app_sub->z2ui5_if_app~main( client = mo_client ).
  ENDMETHOD.

  METHOD on_init.

    ms_screen-input = `app main`.
    view_build( ).
  ENDMETHOD.

  METHOD on_init_sub.

    mo_app_sub = NEW #( ).
    mo_app_sub->mo_view_parent = mo_grid_sub.
    mo_app_sub->z2ui5_if_app~main( client = mo_client ).

    mo_client->view_display( mo_page->stringify( ) ).
  ENDMETHOD.

  METHOD view_build.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    mo_page = lo_view->shell(
         )->page(
            title           = `abap2UI5 - Main App with Sub App`
            navbuttonpress  = mo_client->_event_nav_app_leave( )
              shownavbutton = abap_true ).

    DATA(lo_o_grid) = mo_page->grid( `L6 M12 S12`
        )->content( `layout` ).

    DATA(lo_content) = lo_o_grid->simple_form( title = `Input`
          )->content( `form` ).
    lo_content->label( `main app`
      )->input(
          value  = mo_client->_bind_edit( ms_screen-input )
          submit = mo_client->_event( `INPUT` ) ).

    mo_grid_sub = mo_page->grid( `L12 M12 S12`
        )->content( `layout` ).

    mo_page->footer( )->overflow_toolbar(
                   )->toolbar_spacer(
                   )->button(
                       text  = `Delete`
                       press = mo_client->_event( `BUTTON_DELETE` )
                       type  = `Reject`
                       icon  = `sap-icon://delete`
                   )->button(
                       text  = `Add`
                       press = mo_client->_event( `BUTTON_ADD` )
                       type  = `Default`
                       icon  = `sap-icon://add`
                   )->button(
                       text  = `Save`
                       press = mo_client->_event( `BUTTON_SAVE` )
                       type  = `Success` ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).
      on_init_sub( ).
      mo_client->view_display( mo_page->stringify( ) ).
      RETURN.
    ENDIF.

    on_event( ).
    on_event_sub( ).
  ENDMETHOD.
ENDCLASS.
