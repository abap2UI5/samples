"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBoxContainer
"! This layout allows to display same height grid items with configurable width.
CLASS z2ui5_cl_demo_app_417 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        title    TYPE string,
        subtitle TYPE string,
      END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.
    DATA width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_417 IMPLEMENTATION.

  METHOD view_display.

    width = `100%`.

    t_items = VALUE #(
      ( title = `Grid item title 1` subtitle = `Subtitle 1` )
      ( title = `Grid item title 2` subtitle = `Subtitle 2` )
      ( title = `Grid item title 3` subtitle = `Subtitle 3` )
      ( title = `Grid item title 4` subtitle = `Subtitle 4` )
      ( title = `Grid item title 5` subtitle = `Subtitle 5` )
      ( title = `Grid item title 6 Grid item title Grid item title Grid item title Grid item title Grid item title` subtitle = `Subtitle 6` )
      ( title = `Very long Grid item title that should wrap 7` subtitle = `This is a long subtitle 7` )
      ( title = `Grid item title B 8` subtitle = `Subtitle 8` )
      ( title = `Grid item title B 9 Grid item title B  Grid item title B 9 Grid item title B 9Grid item title B 9title B 9 Grid item title B 9Grid item title B` subtitle = `Subtitle 9` )
      ( title = `Grid item title B 10` subtitle = `Subtitle 10` )
      ( title = `Grid item title B 11` subtitle = `Subtitle 11` )
      ( title = `Grid item title B 12` subtitle = `Subtitle 12` )
      ( title = `Grid item title 13` subtitle = `Subtitle 13` )
      ( title = `Grid item title 14` subtitle = `Subtitle 14` )
      ( title = `Grid item title 15` subtitle = `Subtitle 15` )
      ( title = `Grid item title 16` subtitle = `Subtitle 16` )
      ( title = `Grid item title 17` subtitle = `Subtitle 17` )
      ( title = `Grid item title 18` subtitle = `Subtitle 18` )
      ( title = `Very long Grid item title that should wrap 19` subtitle = `This is a long subtitle 19` )
      ( title = `Grid item title B 20` subtitle = `Subtitle 20` )
      ( title = `Grid item title B 21` subtitle = `Subtitle 21` )
      ( title = `Grid item title B 22` subtitle = `Subtitle 22` )
      ( title = `Grid item title B 23` subtitle = `Subtitle 23` )
      ( title = `Grid item title B 24` subtitle = `Subtitle 24` )
      ( title = `Grid item title B 21` subtitle = `Subtitle 21` )
      ( title = `Grid item title B 22` subtitle = `Subtitle 22` )
      ( title = `Grid item title B 23` subtitle = `Subtitle 23` ) ).

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Grid List with GridBoxLayout`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListBoxContainer` ).

    page->slider(
        value      = `100`
        livechange = client->_event( val = `SLIDER_MOVED` t_arg = VALUE #( ( `${$parameters>/value}` ) ) ) ).

    page->panel(
        id               = `panelForGridList`
        backgrounddesign = `Transparent`
        width            = client->_bind( width )
        )->header_toolbar(
            )->toolbar( height = `3rem`
                )->title( `Grid List with GridBoxLayout and minWidth 17rem`
            )->get_parent(
        )->get_parent(
        )->grid_list(
            id         = `gridList`
            headertext = `GridList header`
            items      = client->_bind( t_items )
            )->custom_layout( `f`
                )->grid_box_layout( boxminwidth = `17rem`
            )->get_parent(
            )->grid_list_item(
                )->vbox( `sapUiSmallMargin`
                    )->layout_data(
                        )->flex_item_data(
                            growfactor   = `1`
                            shrinkfactor = `0`
                    )->get_parent(
                    )->title(
                        text     = `{TITLE}`
                        wrapping = abap_true
                    )->label(
                        text     = `{SUBTITLE}`
                        wrapping = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `SLIDER_MOVED` ).

      width = |{ client->get_event_arg( 1 ) }%|.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
