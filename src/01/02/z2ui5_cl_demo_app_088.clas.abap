CLASS z2ui5_cl_demo_app_088 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_selected_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    DATA mv_page TYPE string.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_088 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ).
      mv_page = `page1`.
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN OTHERS.
        mv_page = client->get( )-event.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page(
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( )
        title          = `abap2UI5 - Sample: Nav Container`
       )->content( ).

    page->message_strip(
        text     = `Selecting a tab in the IconTabHeader switches the NavContainer page on the client via the ` &&
                   `generic CONTROL_BY_ID front-end action (whitelisted method 'to'), without a backend roundtrip.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->icon_tab_header( selectedkey                   = client->_bind( mv_selected_key )
                                                  select = client->_event_client( val   = client->cs_event-control_by_id
                                                                                  t_arg = VALUE #( ( `NavCon` ) ( `to` ) ( `${$parameters>/selectedKey}` ) ) )
                                                  mode   = `Inline`
                                  )->items(
                                    )->icon_tab_filter( key  = `page1`
                                                        text = `Home` )->get_parent(
                                    )->icon_tab_filter( key  = `page2`
                                                        text = `Applications` )->get_parent(
                                    )->icon_tab_filter( key  = `page3`
                                                        text = `Users and Groups` ).

    page->nav_container( id                    = `NavCon`
                         initialpage           = `page1`
                         defaulttransitionname = `flip`
                                     )->pages(
                                     )->page(
                                       title = `first page`
                                       id    = `page1`
                                    )->get_parent(
                                     )->page(
                                       title = `second page`
                                       id    = `page2`
                                    )->get_parent(
                                     )->page(
                                       title = `third page`
                                       id    = `page3` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
