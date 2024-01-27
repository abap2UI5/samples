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

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_123 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.


    IF check_initialized = abap_false.
      check_initialized = abap_true.

      mt_spot = VALUE #(
        ( pos = `9.98336;53.55024;0`         contentoffset = `0;-6` scale = `1;1;1` key = `Hamburg`     tooltip = `Hamburg`     type = `Default` icon = `factory`  )
        ( pos = `11.5820;48.1351;0`          contentoffset = `0;-5` scale = `1;1;1` key = `Munich`      tooltip = `Munich`      type = `Default` icon = `factory`  )
        ( pos = `8.683340000;50.112000000;0` contentoffset = `0;-6` scale = `1;1;1` key = `Frankfurt`   tooltip = `Frankfurt`   type = `Default` icon = `factory`  )
       ).

    ENDIF.


    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.

    ENDCASE.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - Map Container'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                      target = '_blank'
              )->get_parent(
            )->map_container(  autoadjustheight = abap_true
                )->content( ns = `vk`
                    )->container_content(
                      title = `Analytic Map`
                      icon  = `sap-icon://geographic-bubble-chart`
                        )->content( ns = `vk`
                            )->analytic_map(
                              initialposition = `9.933573;50;0`
                              initialzoom = `6`
                            )->vos(
                                )->spots( client->_bind( mt_spot )
                                )->spot(
                                  position      = `{POS}`
                                  contentoffset = `{CONTENTOFFSET}`
                                  type          =  `{TYPE}`
                                  scale         =  `{SCALE}`
                                  tooltip       =  `{TOOLTIP}`
           )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
