CLASS z2ui5_cl_demo_app_129 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF s_suggestion_items,
        value TYPE string,
        descr TYPE string,
      END OF s_suggestion_items .
    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox .
    TYPES
      ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY .
    DATA lv_text TYPE string.
    DATA:
      BEGIN OF screen,
        check_is_active TYPE abap_bool,
        colour          TYPE string,
        combo_key       TYPE string,
        combo_key2      TYPE string,
        segment_key     TYPE string,
        date            TYPE string,
        date_time       TYPE string,
        time_start      TYPE string,
        time_end        TYPE string,
        check_switch_01 TYPE abap_bool VALUE abap_false,
        check_switch_02 TYPE abap_bool VALUE abap_false,
      END OF screen .
    DATA
      mt_suggestion TYPE STANDARD TABLE OF s_suggestion_items WITH EMPTY KEY .
  PROTECTED SECTION.

    METHODS on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_init.
    METHODS on_rendering_popup
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_rendering_popover
      IMPORTING
        id     TYPE string
        client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_129 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      lv_text = 10.
      on_init( ).
      on_rendering( client ).

    ENDIF.

    on_event( client ).
  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN `REFRESH`.
        lv_text = lv_text + 10.

        client->view_model_update( ).
      WHEN `BUTTON_SEND`.

        on_rendering_popup( client ).
      WHEN `BUTTON_POPOVER`.
        on_rendering_popover( client = client
                                    id     = `ppvr` ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    screen = VALUE #(
        check_is_active = abap_true
        colour          = `BLUE`
        combo_key       = `GRAY`
        segment_key     = `GREEN`
        date            = `07.12.22`
        date_time       = `23.12.2022, 19:27:20`
        time_start      = `05:24:00`
        time_end        = `17:23:57`).

    mt_suggestion = VALUE #(
        ( descr = `Green`  value = `GREEN` )
        ( descr = `Blue`   value = `BLUE` )
        ( descr = `Black`  value = `BLACK` )
        ( descr = `Grey`   value = `GREY` )
        ( descr = `Blue2`  value = `BLUE2` )
        ( descr = `Blue3`  value = `BLUE3` ) ).
  ENDMETHOD.

  METHOD on_rendering.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->_z2ui5( )->timer( finished    = client->_event( `REFRESH` )
                            checkrepeat = abap_true
                            delayms     = `3000` ).

    DATA(lo_page) = lo_view->shell(
         )->page(
            title           = `abap2UI5 - Selection-Screen Example`
            navbuttonpress  = client->_event_nav_app_leave( )
              shownavbutton = abap_true ).

    DATA(lo_grid) = lo_page->grid( `L6 M12 S12`
        )->content( `layout` ).

    lo_grid = lo_grid->text( text = client->_bind_edit( val = lv_text view = client->cs_view-main
      ) ).

    lo_page->footer( )->overflow_toolbar(
         )->toolbar_spacer(
         )->button(
             id    = `ppvr`
             text  = `Open Popover`
             press = client->_event( val = `BUTTON_POPOVER` t_arg = VALUE #( ( `${$source>/sId}` ) ) )
             type  = `Ghost`
         )->button(
             text  = `Open Popup`
             press = client->_event( `BUTTON_SEND` )
             type  = `Success` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_rendering_popover.

    DATA(lo_popover) = z2ui5_cl_xml_view=>factory_popup( )->popover( placement = `Top` ).

    lo_popover->text( text = `this is popover in middle with timer auto refresh` ).
    client->popover_display( xml   = lo_popover->stringify( )
                             by_id = id ).
  ENDMETHOD.

  METHOD on_rendering_popup.

    DATA(lo_dialog) = z2ui5_cl_xml_view=>factory_popup( )->dialog( ).

    lo_dialog->text( text = `this is popup in middle with timer auto refresh` ).
    lo_dialog->button( text  = `close`
                    press = client->_event_client( client->cs_event-popup_close ) ).
    client->popup_display( lo_dialog->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
