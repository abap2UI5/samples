CLASS z2ui5_cl_demo_app_113 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_feed,
        author    TYPE string,
        title     TYPE string,
        authorpic TYPE string,
        type      TYPE string,
        date      TYPE string,
        datetime  TYPE string,
        text      TYPE string,
      END OF ty_feed.

    DATA mt_feed TYPE TABLE OF ty_feed.
    DATA ms_feed TYPE ty_feed.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_set_data.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_113 IMPLEMENTATION.


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
    ENDCASE.
  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_feed = VALUE #(
              ( author = `Developer9` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.11.2023` text = `newest entry` )
              ( author = `Developer8` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.10.2023` text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor` )
              ( author = `Developer7` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.09.2023` text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor` )
              ( author = `Developer6` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.08.2023` text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor` )
              ( author = `Developer5` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.07.2023` text = `this is a text` )
              ( author = `Developer4` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.06.2023` text = `this is another entry Product D` )
              ( author = `Developer3` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.05.2023` text = `this is another entry Product C` )
              ( author = `Developer2` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.04.2023` text = `this is another entry Product B` )
              ( author = `Developer1` authorpic = `sap-icon://employee` type = `Reply`  datetime = `01.03.2023` text = `this is another entry Product A` )

                      ( author = `Developer` title = `this is a title` datetime = `01.02.2023` authorpic = `sap-icon://employee` type = `Request` date = `August 26 2023`
                        text =
`this is a long text Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                          `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna` &&
                          `aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` )

                      ( title = `first entry` author = `Developer` datetime = `01.01.2023`  authorpic = `sap-icon://employee` type = `Reply` date = `August 26 2023` text = `this is the beginning of a timeline` )
                    ).

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = lo_view->shell( )->page(
             title          = 'Timeline'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                    )->header_content(
                    )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    DATA(timeline) = page->timeline(
          content = client->_bind( mt_feed ) ).

    timeline->content( ns = `commons` )->timeline_item(
        datetime          = `{DATETIME}`
        title             = `{TITLE}`
        userpicture       = `{AUTHORPIC}`
        text              = `{TEXT}`
        username          = `{AUTHOR}` ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
