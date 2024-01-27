CLASS z2ui5_cl_demo_app_114 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

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
    DATA mv_value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_set_data.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_114 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_set_data( ).
      z2ui5_view_display( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'POST'.

        IF mv_value IS NOT INITIAL.
          CLEAR ms_feed.
          ms_feed-author = sy-uname.
          ms_feed-type = 'Respond'.
          ms_feed-text = mv_value.
          mv_value = ``.
          INSERT ms_feed INTO mt_feed INDEX 1.
          client->view_model_update( ).

        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD z2ui5_set_data.

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


  METHOD z2ui5_view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = lo_view->shell( )->page(
             title          = 'Feed Input'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                    )->header_content(
                    )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    page->flex_box(
            justifycontent = `Start`
            class          = `sapUiSmallMarginEnd`
            alignitems     = `Center`
            )->avatar(
                    class           = `sapUiSmallMarginEnd`
            )->text_area(
                    value           = client->_bind_edit( mv_value )
                    rows            = `4`
                    cols            = `120`
                    class           = `sapUiSmallMarginEnd`
                    placeholder     = `Post something here...`
                    editable        = abap_true
                    enabled         = abap_true
            )->button(
                    icon            = `sap-icon://paper-plane`
                    press           = client->_event( val = 'POST' )
                    iconfirst       = abap_true ).

    page->list(
      items = client->_bind_edit( mt_feed )
      showseparators = `Inner`
        )->feed_list_item(
          sender = `{AUTHOR}`
          senderpress   = client->_event( 'SENDER_PRESS' )
          iconpress   = client->_event( 'ICON_PRESS' )
          icondensityaware   = abap_false
          showicon = abap_false
          info = `Reply`
          text = `{TEXT}`
          convertlinkstoanchortags = `All` ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
