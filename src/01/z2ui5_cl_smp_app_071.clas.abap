CLASS z2ui5_cl_smp_app_071 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_combobox.

    DATA set_size_limit TYPE i VALUE 100.
    DATA combo_number   TYPE i VALUE 105.
    DATA t_combo        TYPE STANDARD TABLE OF ty_s_combobox WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS combo_fill.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_071 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      combo_fill( ).
      view_display( ).

    ELSEIF client->check_on_event( `UPDATE` ).

      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_size_limit
          t_arg = VALUE #( ( CONV #( set_size_limit ) ) ( client->cs_view-main ) ) ).
      client->message_toast_display( `SizeLimitUpdated` ).

    ELSEIF client->check_on_event( `UPDATE_MODEL` ).

      combo_fill( ).
      client->message_toast_display( `update number of entries` ).

    ENDIF.

  ENDMETHOD.


  METHOD combo_fill.

    t_combo = VALUE #( ).
    DO combo_number TIMES.
      INSERT VALUE #( key = sy-index text = sy-index ) INTO TABLE t_combo.
    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Model - Set Size Limit`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `A ComboBox bound to a large internal table: adjust the model's setSizeLimit to ` &&
                   `control how many of the entries the control actually renders.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form( title = `Set Size Limit` editable = abap_true
        )->content( `form`
            )->label( `setSizeLimit`
            )->input( client->_bind( set_size_limit )
            )->button(
                text  = `update size limit`
                press = client->_event( val = `UPDATE` )
            )->label( `Number of Entries`
            )->input( client->_bind( combo_number )
            )->button(
                text  = `update number entries`
                press = client->_event( val = `UPDATE_MODEL` )
            )->label( `demo`
            )->combobox( items = client->_bind( t_combo )
               )->item( key = `{KEY}` text = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
