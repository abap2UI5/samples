"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.ResponsiveSplitter/sample/sap.ui.layout.sample.ResponsiveSplitter
"! ResponsiveSplitter is used to visually divide the content of its parent. It consists of
"! PaneContainers that further agregate other PaneContainers and SplitPanes. SplitPanes can be moved to
"! the pagination when a minimum width of their parent is reached.
CLASS z2ui5_cl_demo_app_103 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

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
              title          = `abap2UI5 - Side Panel Example`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

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
