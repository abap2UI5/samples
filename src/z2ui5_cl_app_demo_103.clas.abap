class Z2UI5_CL_APP_DEMO_103 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_set_data.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_103 IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_view_display( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_ON_EVENT.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.
  ENDMETHOD.


  METHOD Z2UI5_SET_DATA.


  ENDMETHOD.


  METHOD Z2UI5_VIEW_DISPLAY.
    DATA(lo_view) = z2ui5_cl_xml_view=>factory( client ).

    lo_view = lo_view->responsive_splitter( defaultpane = `default`
      )->pane_container(
        )->split_pane( requiredparentwidth = `400` id = `default`
          )->layout_data( ns = `layout`
            )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
          )->panel( headertext = `first pane` )->get_parent( )->get_parent(
        )->pane_container( orientation = `Vertical`
          )->split_pane( requiredparentwidth = `600`
            )->layout_data( ns = `layout`
              )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
            )->panel( headertext = `second pane` )->get_parent( )->get_parent(
          )->split_pane( requiredparentwidth = `800`
            )->layout_data( ns = `layout`
              )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
            )->panel( headertext = `second pane` ).


    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
