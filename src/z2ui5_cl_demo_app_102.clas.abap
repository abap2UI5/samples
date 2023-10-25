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

    DATA mt_barcode TYPE z2ui5_cl_fw_cc_bwipjs=>ty_t_barcode.
    DATA ms_barcode TYPE z2ui5_cl_fw_cc_bwipjs=>ty_s_barcode.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_102 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF mv_check_init = abap_false.
      mv_check_init = abap_true.
      mv_scale_x = `1`.
      mv_scale_y = `1`.

      mt_barcode = NEW z2ui5_cl_fw_cc_bwipjs( )->get_t_barcode_types( ).
      ms_barcode = mt_barcode[ 1 ].

    data(view) = z2ui5_cl_xml_view=>factory( client ).
      client->view_display( view->shell(
        )->page( title          = 'abap2UI5 - Barcode Library'
                 navbuttonpress = client->_event( 'BACK' )
                 shownavbutton  = abap_true
                )->header_content(
                    )->link( text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url(  )
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
                    )->_cc( )->bwip_js( )->load_lib(
                    )->_cc( )->bwip_js( )->load_cc(
                    )->stringify( ) ).

    ENDIF.


    CASE client->get( )-event.

      WHEN `BUTTON_CHANGE`.

      ms_barcode = mt_barcode[ sym = ms_barcode-sym ].
      client->view_model_update( ).

      WHEN `BUTTON_POST`.

       data(view2) = z2ui5_cl_xml_view=>factory( client ).
      client->view_display( view2->shell(
        )->page( title          = 'abap2UI5 - Barcode Library'
                 navbuttonpress = client->_event( 'BACK' )
                 shownavbutton  = abap_true
                )->header_content(
                    )->link( text = 'Source_Code' target = '_blank' href = view2->hlp_get_source_code_url(  )
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
                    )->_cc( )->bwip_js( )->control(
                                          bcid = ms_barcode-sym
                                          text = ms_barcode-text
                    )->stringify( ) ).


      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).


    ENDCASE.



  ENDMETHOD.

ENDCLASS.
