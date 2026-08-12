CLASS z2ui5_cl_smp_app_481 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_481 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      IF client->get( )-check_launchpad_active = abap_false.
        client->message_box_display( `No Launchpad Active, Sample not working!` ).
      ENDIF.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell( )->page( showheader = abap_false ).
      page->message_strip(
          text     = `Reads the startup parameters the Fiori Launchpad passed to this app ` &&
                     `tile (the ComponentData) via client->get( )-t_comp_params - start the ` &&
                     `tile with URL parameters to see them. Only works inside a launchpad.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).
      page->simple_form( title    = `Launchpad - Read Startup Parameters`
                         editable = abap_true
          )->content( `form`
              )->label( ``
              )->button( text  = `Read Parameters`
                         press = client->_event( `READ_PARAMS` )
              )->label( ``
              )->button( text  = `Go Back`
                         press = client->_event_nav_app_leave( ) ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `READ_PARAMS` ).

      DATA(text) = `Start Parameter: `.
      DATA(t_params) = client->get( )-t_comp_params.
      LOOP AT t_params INTO DATA(s_param).
        text = |{ text } / { s_param-n } = { s_param-v }|.
      ENDLOOP.
      client->message_box_display( text ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
