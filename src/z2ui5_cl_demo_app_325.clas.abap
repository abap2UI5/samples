CLASS z2ui5_cl_demo_app_325 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA input TYPE string.
    DATA text TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_325 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.

      DATA view TYPE REF TO z2ui5_cl_xml_view.
      view = z2ui5_cl_xml_view=>factory( ).
      DATA page TYPE REF TO z2ui5_cl_xml_view.
      page = view->object_page_layout(
            showtitleinheadercontent = abap_true
            showeditheaderbutton     = abap_true
            uppercaseanchorbar       = abap_false ).

      DATA header_title TYPE REF TO z2ui5_cl_xml_view.
      header_title = page->header_title(
         )->object_page_dyn_header_title( ).

      header_title->expanded_heading( )->hbox( )->title( text     = 'Test'
                                                         wrapping = abap_true ).
      header_title->snapped_heading( )->flex_box( alignitems = `Center` )->title( text     = 'Test'
                                                                                  wrapping = abap_true ).

      DATA sections TYPE REF TO z2ui5_cl_xml_view.
      sections = page->sections( ).

      sections->object_page_section( titleuppercase = abap_false
                                     id             = 'id_sec1'
                                     title          = '...' )->heading( ns = `uxap`
        )->get_parent( )->sub_sections( )->object_page_sub_section( id    = 'id_input'
                                                                    title = 'Input field'
        )->blocks( )->vbox(
        )->input( value = client->_bind_edit( input )
                  width = `50%`
        )->button( text  = 'Copy input'
                   type  = 'Emphasized'
                   press = client->_event( 'COPY_INPUT' ) ).

      sections->object_page_section( titleuppercase = abap_false
                                     id             = 'id_sec2'
                                     title          = '...' )->heading( ns = `uxap`
        )->get_parent( )->sub_sections( )->object_page_sub_section( id    = 'id_text_area'
                                                                    title = 'Text area'
        )->blocks( )->vbox(
        )->button( text  = 'Copy text area'
                   type  = 'Emphasized'
                   press = client->_event( 'COPY_TEXT_AREA' )
        )->text_area( valueliveupdate = abap_true
                      editable        = abap_true
                      value           = client->_bind_edit( text )
                      growing         = abap_true
        growingmaxlines               = '50'
                      width           = '100%'
                      rows            = '15'
                      id              = 'text_id' ).

      client->view_display( page->stringify( ) ).

    ENDIF.


    CASE client->get( )-event.
      WHEN 'COPY_INPUT'.
        DATA temp1 TYPE string_table.
        CLEAR temp1.
        INSERT input INTO TABLE temp1.
        client->follow_up_action( client->_event_client(
            val   = z2ui5_if_client=>cs_event-clipboard_copy
            t_arg = temp1 ) ).
        client->message_toast_display( `input field copied` && input ).

      WHEN 'COPY_TEXT_AREA'.
        DATA temp3 TYPE string_table.
        CLEAR temp3.
        INSERT text INTO TABLE temp3.
        client->follow_up_action( client->_event_client(
             val   = z2ui5_if_client=>cs_event-clipboard_copy
             t_arg = temp3 ) ).
        client->message_toast_display( `text area copied: ` && text ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
