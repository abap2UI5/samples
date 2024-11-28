CLASS z2ui5_cl_demo_app_123 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_spot,
        tooltip       TYPE string,
        type          TYPE string,
        pos           TYPE string,
        scale         TYPE string,
        contentoffset TYPE string,
        key           TYPE string,
        icon          TYPE string,
      END OF ty_spot.
    DATA mt_spot TYPE TABLE OF ty_spot.

    DATA check_initialized TYPE abap_bool.

    TYPES:
      BEGIN OF ty_route,
        position    TYPE string,
        routetype   TYPE string,
        linedash    TYPE string,
        color       TYPE string,
        colorborder TYPE string,
        linewidth   TYPE string,
      END OF ty_route .

    DATA
      mt_route TYPE TABLE OF ty_route .

    TYPES: BEGIN OF ty_s_legend,
             text  TYPE string,
             color TYPE string,
           END OF ty_s_legend.
    DATA mt_legend TYPE TABLE OF ty_s_legend.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_123 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.


    IF check_initialized = abap_false.
      check_initialized = abap_true.

      mt_spot = VALUE #(
        ( pos = `9.98336;53.55024;0`         contentoffset = `0;-6` scale = `1;1;1` key = `Hamburg`     tooltip = `Hamburg`     type = `Default` icon = `factory` )
        ( pos = `11.5820;48.1351;0`          contentoffset = `0;-5` scale = `1;1;1` key = `Munich`      tooltip = `Munich`      type = `Default` icon = `factory` )
        ( pos = `8.683340000;50.112000000;0` contentoffset = `0;-6` scale = `1;1;1` key = `Frankfurt`   tooltip = `Frankfurt`   type = `Default` icon = `factory` ) ).

      mt_route = VALUE #(
        (  position = '2.3522219;48.856614;0; -74.0059731;40.7143528;0'   routetype = 'Geodesic' linedash = '10;5' color = '92,186,230' colorborder = 'rgb(255,255,255)' linewidth = '25' ) ).


      mt_legend = VALUE #(
        (   text = 'Dashed flight route' color = 'rgb(92,186,230)' )
        (   text = 'Flight route' color = 'rgb(92,186,35)' ) ).
    ENDIF.


    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
        RETURN.

    ENDCASE.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
            )->page(
                    title          = 'abap2UI5 - Map Container'
                    navbuttonpress = client->_event( val = 'BACK' )
                    shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(map) = page->map_container( autoadjustheight = abap_true
         )->content( ns = `vk`
             )->container_content(
               title = `Analytic Map`
               icon  = `sap-icon://geographic-bubble-chart`
                 )->content( ns = `vk`
                     )->analytic_map(
                       initialposition = `9.933573;50;0`
                       initialzoom     = `6` ).



    map->vos(
      )->spots( client->_bind( mt_spot )
      )->spot(
        position      = `{POS}`
        contentoffset = `{CONTENTOFFSET}`
        type          = `{TYPE}`
        scale         = `{SCALE}`
        tooltip       = `{TOOLTIP}` ).


    map->routes( client->_bind( mt_route ) )->route(
      position      = `{POSITION}`
        routetype   = `{ROUTETYPE}`
        linedash    = '{LINEDASH}'
        color       = '{COLOR}'
        colorborder = '{COLORBORDER}'
      linewidth     = '{LINEWIDTH}'
*      RECEIVING
*        result    =
      ).


    map->legend_area( )->legend(
*      EXPORTING
*        id      =
        items   = client->_bind( mt_legend )
        caption = 'Legend'
*      RECEIVING
*        result  =
      )->legenditem(
      text    = '{TEXT}'
        color = '{COLOR}'
*      RECEIVING
*        result =
      ).
    client->view_display( page->stringify( ) ).


  ENDMETHOD.
ENDCLASS.
