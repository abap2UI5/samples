CLASS z2ui5_cl_demo_app_146 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_tab,
        text  TYPE string,
        class TYPE string,
      END OF ty_tab .

    DATA check_initialized TYPE abap_bool .
    DATA:
      t_tab TYPE TABLE OF ty_tab WITH EMPTY KEY .
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_146 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      z2ui5_on_rendering( client ).

    ENDIF.

    z2ui5_on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'RERUN'.
        z2ui5_on_rendering( client ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.
    t_tab = VALUE #(
                    ( text = `bounce` class = `animate__animated animate__bounce` )
                    ( text = `flash` class = `animate__animated animate__flash` )
                    ( text = `pulse` class = `animate__animated animate__pulse` )
                    ( text = `rubberBand` class = `animate__animated animate__rubberBand` )
                    ( text = `shakeX` class = `animate__animated animate__shakeX` )
                    ( text = `shakeY` class = `animate__animated animate__shakeY` )
                    ( text = `headShake` class = `animate__animated animate__headShake` )
                    ( text = `swing` class = `animate__animated animate__swing` )
                    ( text = `tada` class = `animate__animated animate__tada` )
                    ( text = `wobble` class = `animate__animated animate__wobble` )
                    ( text = `jello` class = `animate__animated animate__jello` )
                    ( text = `heartBeat` class = `animate__animated animate__heartBeat` )
                    ( text = `backInDown` class = `animate__animated animate__backInDown` )
                    ( text = `backInLeft` class = `animate__animated animate__backInLeft` )
                    ( text = `backInRight` class = `animate__animated animate__backInRight` )
                    ( text = `backInUp` class = `animate__animated animate__backInUp` )
                    ( text = `backOutDown` class = `animate__animated animate__backOutDown` )
                    ( text = `backOutLeft` class = `animate__animated animate__backOutLeft` )
                    ( text = `backOutRight` class = `animate__animated animate__backOutRight` )
                    ( text = `backOutUp` class = `animate__animated animate__backOutUp` )
                    ( text = `bounceIn` class = `animate__animated animate__bounceIn` )
                    ( text = `bounceInDown` class = `animate__animated animate__bounceInDown` )
                    ( text = `bounceInLeft` class = `animate__animated animate__bounceInLeft` )
                    ( text = `bounceInRight` class = `animate__animated animate__bounceInRight` )
                    ( text = `bounceInUp` class = `animate__animated animate__bounceInUp` )
                    ( text = `bounceOut` class = `animate__animated animate__bounceOut` )
                    ( text = `bounceOutDown` class = `animate__animated animate__bounceOutDown` )
                    ( text = `bounceOutLeft` class = `animate__animated animate__bounceOutLeft` )
                    ( text = `bounceOutRight` class = `animate__animated animate__bounceOutRight` )
                    ( text = `bounceOutUp` class = `animate__animated animate__bounceOutUp` )
                    ( text = `fadeIn` class = `animate__animated animate__fadeIn` )
                    ( text = `fadeInDown` class = `animate__animated animate__fadeInDown` )
                   ).
  ENDMETHOD.


  METHOD z2ui5_on_rendering.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_animatecss=>load_css( ) )->get_parent( ).

    DATA(page) = view->shell(
         )->page(
          showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title          = 'abap2UI5 - animate.css demo'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
             )->button( press = client->_event( 'RERUN' ) text = 'RERUN'
         )->get_parent( ).


    DATA(items) = page->table( mode = `None`
            )->columns(
                )->column( )->text( 'Text in label control' )->get_parent(
                )->column( )->text( 'Class Value' )->get_parent(
            )->get_parent(
            )->items( ).
    LOOP AT t_tab INTO DATA(ls_tab).
      items->column_list_item( )->cells( )->label( text = ls_tab-text class = ls_tab-class
        )->label( text = ls_tab-class ).
    ENDLOOP.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
