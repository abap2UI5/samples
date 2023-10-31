CLASS z2ui5_cl_demo_app_123 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_spot,
        tooltip    TYPE string,
        type TYPE string,
        pos      TYPE string,
        scale      TYPE string,
        contentoffset      TYPE string,
        key      TYPE string,
        icon      TYPE string,
      END OF ty_spot.

    DATA mt_spot TYPE TABLE OF ty_spot.

    DATA device_browser TYPE string.
    DATA device_os TYPE string.
    DATA check_initialized TYPE abap_bool.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_123 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.


    "on init
    IF check_initialized = abap_false.
      check_initialized = abap_true.

    mt_spot = VALUE #(
      ( pos = `9.98336;53.55024;0` contentoffset = `0;-6` scale = `1;1;1` key = `Hamburg` tooltip = `Hamburg` type = `Default` icon = `factory`  )
      ( pos = `11.5820;48.1351;0` contentoffset = `0;-5` scale = `1;1;1` key = `Munich` tooltip = `Munich` type = `Default` icon = `factory`  )

                 ).

    ENDIF.


    "user command
    CASE client->get( )-event.

      WHEN 'INFO_FINISHED'.
        client->message_box_display( `Info loaded!`).
        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.

    ENDCASE.


    "render view
    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton  = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = view->hlp_get_source_code_url(  )
                      target = '_blank'
              )->get_parent(
              )->simple_form( title = 'Information' editable = abap_true
                  )->content( 'form'
                      )->label( 'device_browser'
                      )->input( client->_bind_edit( device_browser )
                      )->label( `device_os`
                      )->input( client->_bind_edit( device_os )
                )->get_parent( )->get_parent(
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
                                )->spots(
*                                  id    =
                                   items = client->_bind( mt_spot )
                                )->spot(
                                  position      = `{POS}`
                                  contentoffset = `{CONTENTOFFSET}`
                                  type          =  `{TYPE}`
                                  scale         =  `{SCALE}`
                                  tooltip       =  `{TOOLTIP}`
           )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
