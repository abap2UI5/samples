CLASS z2ui5_cl_demo_app_147 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_input_main TYPE string .
    DATA mv_input_nest TYPE string .
    DATA check_initialized TYPE abap_bool .
    DATA mv_path TYPE string .
    DATA mv_value TYPE string .
    DATA mv_file TYPE string .

    METHODS on_rendering
      IMPORTING
        !client TYPE REF TO z2ui5_if_client .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_147 IMPLEMENTATION.


 METHOD on_rendering.
    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = lo_view->shell(
        )->page(
                title = `Popover on Nested View` id = `test`
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'  target = '_blank'
            )->get_parent(
             )->button( id = 'TEST_MAIN' text = 'SHOW POPOVER MAIN' press = client->_event( 'SHOW POPOVER_MAIN' ) ).

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory(
          )->page( title = `Nested View`
              )->button( id = 'TEST_NESTED' text = 'SHOW POPOVER NESTED' press = client->_event( 'SHOW POPOVER_NESTED' ) ).

    client->view_display( lo_view->stringify( ) ).
    client->nest_view_display( val = lo_view_nested->stringify( ) id = `test` method_insert = 'addContent'  ).

  ENDMETHOD.


 METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_rendering( client = client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'START'.
        on_rendering( client = client ).

      WHEN 'SHOW POPOVER_NESTED'.
* ---------- Create View --------------------------------------------------------------------------
        DATA(lr_view) = z2ui5_cl_xml_view=>factory_popup( ).

* ---------- Create popover window ----------------------------------------------------------------
        DATA(lr_popover) = lr_view->popover( placement = 'Right'
                                             showheader = abap_false
                                             class = `sapUiContentPadding` ).

* ---------- Create vertical box ------------------------------------------------------------------
        DATA(lr_vbox) = lr_popover->vbox(  ).

* ---------- Set text -----------------------------------------------------------------------------
        lr_vbox->text( text = 'Discard all changes?' ).

* ---------- Set button ---------------------------------------------------------------------------
        lr_vbox->button( text = 'Discard'
                         press = client->_event( 'DISCARD' )
                         width = `16rem` ).

* ---------- Return xml ---------------------------------------------------------------------------
        client->popover_display( xml = lr_view->stringify( ) by_id = 'TEST_NESTED' ).

      WHEN 'SHOW POPOVER_MAIN'.
* ---------- Create View --------------------------------------------------------------------------
        DATA(lr_view_main) = z2ui5_cl_xml_view=>factory_popup( ).

* ---------- Create popover window ----------------------------------------------------------------
        DATA(lr_popover_main) = lr_view_main->popover( placement = 'Right' ).

* ---------- Create vertical box ------------------------------------------------------------------
        DATA(lr_vbox_main) = lr_popover_main->vbox(  ).

* ---------- Set text -----------------------------------------------------------------------------
        lr_vbox_main->text( text = 'Discard all changes?' ).

* ---------- Set button ---------------------------------------------------------------------------
        lr_vbox_main->button( text = 'Discard' press = client->_event( 'DISCARD' ) ).

* ---------- Return xml ---------------------------------------------------------------------------
        client->popover_display( xml = lr_view_main->stringify( ) by_id = 'TEST_MAIN' ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
