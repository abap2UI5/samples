CLASS z2ui5_cl_demo_app_103 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_103 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
           )->page(
              title           = `abap2UI5 - Side Panel Example`
              navbuttonpress  = client->_event_nav_app_leave( )
                shownavbutton = abap_true ).

    page->header_content(
         )->link( ).

    page->responsive_splitter( defaultpane = `default`
       )->pane_container(
         )->split_pane( requiredparentwidth = `400`
                        id                  = `default`
           )->layout_data( `layout`
             )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
           )->panel( headertext = `first pane` )->get_parent( )->get_parent(
         )->pane_container( orientation = `Vertical`
           )->split_pane( requiredparentwidth = `600`
             )->layout_data( `layout`
               )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
             )->panel( headertext = `second pane` )->get_parent( )->get_parent(
           )->split_pane( requiredparentwidth = `800`
             )->layout_data( `layout`
               )->splitter_layout_data( size = `auto` )->get_parent( )->get_parent(
             )->panel( headertext = `second pane` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
