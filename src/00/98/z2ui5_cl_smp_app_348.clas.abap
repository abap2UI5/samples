CLASS z2ui5_cl_smp_app_348 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc      TYPE z2ui5_t_01.
    DATA mo_layout_obj TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS get_data.
    METHODS get_data2.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    METHODS xml_form
      IMPORTING
        i_data   TYPE REF TO data
        i_page   TYPE REF TO z2ui5_cl_ui5_view_builder
        i_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_348 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <row> TYPE z2ui5_t_01.

    IF client->check_on_init( ).

      get_data( ).

      mo_layout_obj = z2ui5_cl_smp_app_333=>factory( i_data   = REF #( ms_struc )
                                                      vis_cols = 5 ).

      view_display( client ).

    ELSEIF client->check_on_navigated( ).
      view_display( client ).

    ELSEIF client->check_on_event( ).

      CASE client->get_event( ).
        WHEN `GO`.
          DATA(app) = z2ui5_cl_smp_app_336=>factory( ).
          client->nav_app_call( app ).

        WHEN `GET_DATA`.

          get_data2( ).

      ENDCASE.

    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.

    IF ms_struc IS INITIAL.
      client->message_toast_display( `ERROR - ms_struc is initial!` ).
    ENDIF.

    ASSIGN mo_layout_obj->mr_data->* TO <row>.

    IF <row> <> ms_struc.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data->*  <> ms_struc!` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `RTTI IV`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( `GO` )
        )->a( n = `text`  v = `CALL Next App`
        )->a( n = `type`  v = `Accept` ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( `GET_DATA` )
        )->a( n = `text`  v = `Read from DB`
        )->a( n = `type`  v = `Accept` ).

    xml_form( i_data   = REF #( ms_struc )
              i_page   = page
              i_client = client ).

    xml_form( i_data   = mo_layout_obj->mr_data
              i_page   = page
              i_client = client ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_data.

    " no inline DATA(lt_data) here: an inline declaration together with
    " INTO CORRESPONDING FIELDS is 7.55 syntax and a syntax error below that
    DATA lt_data TYPE STANDARD TABLE OF z2ui5_t_01 WITH EMPTY KEY.

    " any single row will do here, but it has to be the SAME one on every
    " roundtrip - SELECT SINGLE without a full key leaves that to the database
    SELECT id,
           id_prev,
           id_prev_app,
           id_prev_app_stack,
           timestampl
      FROM z2ui5_t_01
      ORDER BY PRIMARY KEY
      INTO CORRESPONDING FIELDS OF TABLE @lt_data
      UP TO 1 ROWS.

    ms_struc = VALUE #( lt_data[ 1 ] OPTIONAL ).

  ENDMETHOD.


  METHOD get_data2.

    DATA lt_data2 TYPE STANDARD TABLE OF z2ui5_t_01 WITH EMPTY KEY.

    SELECT id,
           id_prev,
           id_prev_app,
           id_prev_app_stack,
           timestampl
      FROM z2ui5_t_01
      WHERE id <> @ms_struc-id
      ORDER BY PRIMARY KEY
      INTO CORRESPONDING FIELDS OF TABLE @lt_data2
      UP TO 1 ROWS.

    ms_struc = VALUE #( lt_data2[ 1 ] OPTIONAL ).

  ENDMETHOD.


  METHOD xml_form.

    FIELD-SYMBOLS <layout> TYPE z2ui5_cl_smp_app_333=>ty_s_layout.
    FIELD-SYMBOLS <data>   TYPE any.
    FIELD-SYMBOLS <value>  TYPE any.

    DATA(form) = i_page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `layout`          v = `ResponsiveGridLayout`
        )->a( n = `adjustLabelSpan` b = abap_true
        )->a( n = `editable`        b = abap_true
        )->ele( n = `content` ns = `form` ).

    DATA(index) = 0.

    LOOP AT mo_layout_obj->ms_data-t_layout ASSIGNING <layout>.

      index = index + 1.

      ASSIGN i_data->* TO <data>.

      ASSIGN COMPONENT <layout>-name OF STRUCTURE <data> TO <value>.

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DATA(line) = form->tag( `Label`
          )->a( n = `text`     v = <layout>-name
          )->a( n = `wrapping` b = abap_false ).

      line->tag( `Input`
          )->a( n = `enabled` b = abap_false
          )->a( n = `visible` v = i_client->_bind( val       = <layout>-visible
                                              tab       = mo_layout_obj->ms_data-t_layout
                                              tab_index = index )
          )->a( n = `value`   v = i_client->_bind( <value> ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
