CLASS z2ui5_cl_demo_app_116 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_classname TYPE string.
    DATA mv_output    TYPE string.
    DATA mv_time      TYPE string.
    DATA mv_check_init TYPE abap_bool.

    METHODS display_demo_output
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    METHODS run_class.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_116 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF mv_check_init = abap_false.
      mv_check_init = abap_true.
      mv_classname = `LCL_DEMO_APP_117`.
      mv_time = `10000`.
      display_demo_output( client ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.
        run_class( ).
        display_demo_output( client ).

      WHEN 'BUTTON_CLEAR'.
        mv_output = ``.
        display_demo_output( client ).

      WHEN `BUTTON_TIMER`.
*        client->timer_set(
*         interval_ms    = mv_time
*         event_finished = client->_event( 'BUTTON_TIMER' ) ).
*
*        run_class( ).
*        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD display_demo_output.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - if_oo_adt_classrun - TODO uncomment the code first'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                      target = '_blank'
                 )->get_parent(
              )->sub_header(
                 )->overflow_toolbar(
                        )->label( 'Classname'
                        )->input( value = client->_bind_edit( mv_classname )
                                  width = `20%`
                                  submit = client->_event( val = 'BUTTON_POST' )
                        )->button(
                            text  = 'Run'
                            press = client->_event( val = 'BUTTON_POST' )
                        )->toolbar_spacer(
                        )->input(
                                value = client->_bind_edit( mv_time ) width = `5%`

                        )->button(
                            text  = 'Timer Run (MS)'
                            press = client->_event( val = 'BUTTON_TIMER' )
                        )->toolbar_spacer(
                        )->button(
                            text  = 'Clear'
                            press = client->_event( val = 'BUTTON_CLEAR' )
              )->get_parent( )->get_parent(
            )->_z2ui5( )->demo_output( client->_bind( mv_output )
            )->stringify( ) ).

  ENDMETHOD.


  METHOD run_class.

*    data(writer) = new lcl_adt_writer( ).
*    DATA li_classrun TYPE REF TO if_oo_adt_classrun.
*    CREATE OBJECT li_classrun TYPE (mv_classname).
*    li_classrun->main( out = writer ).
*    mv_output = writer->get_output( ).

  ENDMETHOD.

ENDCLASS.
