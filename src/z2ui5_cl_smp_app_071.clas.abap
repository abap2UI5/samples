" @keywords combobox jsonmodel size limit large itab 100 entries set_size_limit
" @summary A JSON model shows only the first 100 entries until setSizeLimit is raised, which is why a ComboBox over a large table quietly stops at a hundred rows.
" @docs https://abap2ui5.github.io/docs/cookbook/model/size_limit
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
    DATA combo_key      TYPE string.
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

    " text typed into an Input bound to TYPE i does not dump: the framework
    " keeps the old number and names the field in t_model_skipped - so the
    " update would silently use a value the screen no longer shows
    DATA(t_skipped) = client->get( )-t_model_skipped.
    IF t_skipped IS NOT INITIAL.
      client->message_box_display( text = |'{ t_skipped[ 1 ]-value }' is no number this field can hold - it keeps its old value.|
                                   type = `error` ).
      RETURN.
    ENDIF.

    IF client->check_on_init( ).

      combo_fill( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( `UPDATE` ).

      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_size_limit
          t_arg = VALUE #( ( CONV #( set_size_limit ) ) ( client->cs_view-main ) ) ).
      client->message_toast_display( |Size limit set to { set_size_limit } - open the ComboBox again| ).

    ELSEIF client->check_on_event( `UPDATE_MODEL` ).

      combo_fill( ).
      client->message_toast_display( |The ComboBox now holds { combo_number } entries| ).

    ENDIF.

  ENDMETHOD.


  METHOD combo_fill.

    t_combo = VALUE #( ).
    DO combo_number TIMES.
      INSERT VALUE #( key = sy-index text = sy-index ) INTO TABLE t_combo.
    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Model setSizeLimit for Large Tables`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The ComboBox below is bound to 105 entries, but a JSON model hands a list binding ` &&
                   `only its first 100: open it and scroll to the end - it stops at 100. Raise setSizeLimit to 200 and ` &&
                   `press update size limit, and all 105 appear. Number of Entries refills the table with as many rows.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Set Size Limit`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `setSizeLimit`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( set_size_limit )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( val = `UPDATE` )
                )->a( n = `text`  v = `update size limit`
            )->tag( `Label`
                )->a( n = `text` v = `Number of Entries`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( combo_number )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( val = `UPDATE_MODEL` )
                )->a( n = `text`  v = `update number entries`
            )->tag( `Label`
                )->a( n = `text` v = `ComboBox`
            )->ele( `ComboBox`
                )->a( n = `selectedKey` v = client->_bind( combo_key )
                )->a( n = `items`       v = client->_bind( t_combo )
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
