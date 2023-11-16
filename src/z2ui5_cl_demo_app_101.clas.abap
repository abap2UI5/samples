CLASS Z2UI5_CL_DEMO_APP_101 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

    TYPES:
      BEGIN OF ty_feed,
        author    TYPE string,
        authorpic TYPE string,
        type      TYPE string,
        date      TYPE string,
        text      TYPE string,
      END OF ty_feed.

    DATA mt_feed TYPE TABLE OF ty_feed.
    DATA ms_feed TYPE ty_feed.
    data mv_value type string.

  PROTECTED SECTION.
    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_on_event.
    METHODS Z2UI5_set_data.
    METHODS Z2UI5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_101 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_set_data( ).
      Z2UI5_view_display( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'POST'.
*        DATA(lt_arg) = client->get( )-t_event_arg.
*        READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.
*        IF ls_arg IS NOT INITIAL.
            if mv_value is not INITIAL.
          CLEAR ms_feed.
          ms_feed-author = sy-uname.
          ms_feed-type = 'Respond'.
*          ms_feed-text = ls_arg.
          ms_feed-text = mv_value.
          mv_value = ``.

          INSERT ms_feed INTO mt_feed INDEX 1.

          client->view_model_update( ).

        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD Z2UI5_set_data.

    mt_feed = VALUE #(
                      ( author = `choper725` authorpic = `employee` type = `Request` date = `August 26 2023`
                        text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna` &&
                          `aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` )

                      ( author = `choper725` authorpic = `sap-icon://employee` type = `Reply` date = `August 26 2023` text = `this is feed input` )
                    ).

  ENDMETHOD.


  METHOD Z2UI5_view_display.
    DATA(lo_view) = Z2UI5_cl_xml_view=>factory( client ).

    DATA(page) = lo_view->shell( )->page(
             title          = 'Feed Input'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton  = abap_true
                    )->header_content(
                    )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    DATA(fi) = page->vbox(
*      )->feed_input( post = client->_event( val = 'POST' t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
      )->feed_input( post = client->_event( val = 'POST' ) "t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
                             growing = abap_true
                             rows = `4`
                             icondensityaware = abap_false
                             value = client->_bind_edit( mv_value )
                             class = `sapUiSmallMarginTopBottom`
      )->get_parent( )->get_parent(
      )->list(
        items = client->_bind_edit( mt_feed )
        showSeparators = `Inner`
          )->feed_list_item(
            sender = `{AUTHOR}`
*            icon   = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
            senderpress   = client->_event( 'SENDER_PRESS' )
            iconpress   = client->_event( 'ICON_PRESS' )
            icondensityaware   = abap_false
            showicon = abap_false
            info = `Reply`
*            timestamp = `{DATE}`
            text = `{TEXT}`
            convertlinkstoanchortags = `All`
).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
