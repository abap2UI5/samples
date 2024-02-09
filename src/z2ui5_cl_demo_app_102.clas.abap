CLASS z2ui5_cl_demo_app_102 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_barcode_type TYPE string.
    DATA mv_barcode_text TYPE string.
    DATA mv_alt_text TYPE string.
    DATA mv_options TYPE string.
    DATA mv_render_as TYPE string.
    DATA mv_scale_x TYPE string.
    DATA mv_scale_y TYPE string.

    DATA mv_check_init TYPE abap_bool.

    DATA mt_barcode TYPE z2ui5_cl_cc_bwipjs=>ty_t_barcode.
    DATA ms_barcode TYPE z2ui5_cl_cc_bwipjs=>ty_s_barcode.

  PROTECTED SECTION.

    METHODS view_display
      IMPORTING
*        check_init TYPE abap_bool
        client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_102 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF mv_check_init = abap_false.
      mv_check_init = abap_true.
      client->nav_app_call( z2ui5_cl_popup_js_loader=>factory( z2ui5_cl_cc_bwipjs=>get_js( ) ) ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN `BUTTON_CHANGE`.
        ms_barcode = mt_barcode[ sym = ms_barcode-sym ].
        client->view_model_update( ).

      WHEN `BUTTON_POST`.
        view_display( client = client ).
*        check_init = abap_true ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN OTHERS.
        mv_scale_x = `5`.
        mv_scale_y = `7`.

        mt_barcode = z2ui5_cl_cc_bwipjs=>get_t_barcode_types( ).
        ms_barcode = mt_barcode[ 1 ].

        view_display( client = client ). "check_init = abap_false ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(cont) = view->shell(
      )->page(  showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
                title          = 'abap2UI5 - Barcode Library'
               navbuttonpress = client->_event( 'BACK' )
               shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
          )->get_parent(
          )->simple_form( title    = 'bwip-js // Barcode Writer in Pure Javascript' editable = abap_true
              )->content( ns = `form`
                  )->label( 'Link'
                  )->link( text = `http://bwip-js.metafloor.com` href = `http://bwip-js.metafloor.com` target = '_blank'
                  )->label( 'Online Demo'
                  )->link( text = `http://bwip-js.metafloor.com/demo/demo.html` href = `http://bwip-js.metafloor.com/demo/demo.html` target = '_blank'
                  )->label( 'Barcode Type'
                  )->combobox(
                          selectedkey = client->_bind_edit( ms_barcode-sym )
                          items       = client->_bind( mt_barcode )
                          change      = client->_event( 'BUTTON_CHANGE' )
                       )->item( key = '{SYM}' text = '{DESC}'
                       )->get_parent( )->get_parent(
                  )->label( 'Bar Text'
                  )->input( client->_bind_edit( ms_barcode-text )
                  )->label( 'Alt Text'
                  )->input( client->_bind_edit( mv_alt_text )
                  )->label( 'Options'
                  )->input( client->_bind_edit( ms_barcode-opts )
                  )->label( 'Render As'
                  )->segmented_button( client->_bind_edit( mv_render_as )
                      )->items(
                          )->segmented_button_item( key  = 'CANVAS' text = 'CANVAS'
                          )->segmented_button_item( key  = 'SVG'    text = 'SVG'
                          )->get_parent( )->get_parent(
                  )->label( 'Scale X,Y'
                  )->step_input( value = client->_bind_edit( mv_scale_x ) step = '1' min = '1' max = '9'
                  )->step_input( value = client->_bind_edit( mv_scale_y ) step = '1' min = '1' max = '9'
                  )->label( 'Image Rotation'
                  )->segmented_button( client->_bind_edit( mv_render_as )
                      )->items(
                          )->segmented_button_item( key  = 'NORMAL' text = 'NORMAL'
                          )->segmented_button_item( key  = 'RIGHT'  text = 'RIGHT'
                          )->segmented_button_item( key  = 'LEFT'   text = 'LEFT'
                          )->segmented_button_item( key  = 'INVERT' text = 'INVERT'
                          )->get_parent( )->get_parent(
                  )->label(
                  )->button( text  = 'Show Barcode' press = client->_event( 'BUTTON_POST' )
                )->get_parent( ).

*    IF check_init = abap_false.
*      cont->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_bwipjs=>get_js( ) ).
*    ELSE.
    cont->simple_form( title    = 'Barcode' editable = abap_true
         )->_z2ui5( )->bwip_js(
            bcid = ms_barcode-sym
            text = ms_barcode-text
            scale = mv_scale_x
            height = CONV string( mv_scale_y + mv_scale_x )

            ).
*    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
