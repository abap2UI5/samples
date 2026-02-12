CLASS z2ui5_cl_demo_app_103 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_103 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
           )->page(
              title           = `abap2UI5 - Side Panel Example`
              navbuttonpress  = mo_client->_event_nav_app_leave( )
                shownavbutton = abap_true ).

    lo_page->header_content(
         )->link( ).

    lo_page->responsive_splitter( defaultpane = `default`
       )->pane_container(
         )->split_pane( requiredparentwidth = `400`
                        id                  = `default`
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

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
