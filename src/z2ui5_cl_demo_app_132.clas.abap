CLASS z2ui5_cl_demo_app_132 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_boolean.
    DATA mo_parent_view  TYPE REF TO z2ui5_cl_xml_view.

DATA mv_perc type string.

  methods set_app_data
    importing
      !DATA type STRING .

  PROTECTED SECTION.


    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.

    METHODS Render_main.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_132 IMPLEMENTATION.

  METHOD on_event.
    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.
    Render_main( ).
  ENDMETHOD.

  METHOD render_main.

    IF mo_parent_view IS INITIAL.

      DATA(page) = z2ui5_cl_xml_view=>factory( ).

    ELSE.

      page = mo_parent_view->get( `Page` ).

    ENDIF.

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding` width = `100%` ).
    layout->label( 'ProgressIndicator'
        )->progress_indicator(
            percentvalue    = mv_perc
            displayvalue    = '0,44GB of 32GB used'
            showvalue       = abap_true
            state           = 'Success' ).


    IF mo_parent_view IS INITIAL.

      client->view_display( page->get_root( )->xml_get( ) ).

    ELSE.

      mv_view_display = abap_true.

    ENDIF.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD set_app_data.

mv_perc = data.

  ENDMETHOD.

ENDCLASS.