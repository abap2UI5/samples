CLASS z2ui5_cl_smp_app_335 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc        TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_smp_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    METHODS get_data_2.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_335 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <row> TYPE z2ui5_t_01.

    IF client->check_on_init( ).

      get_data( ).

      mo_layout_obj = z2ui5_cl_smp_app_333=>factory( i_data = REF #( ms_struc ) vis_cols = 3 ).
      mo_layout_obj_2 = z2ui5_cl_smp_app_333=>factory( i_data = REF #( ms_struc ) vis_cols = 3 ).

      view_display( client ).

    ELSEIF client->check_on_navigated( ).
      view_display( client ).

    ELSEIF client->check_on_event( ).

      CASE client->get_event( ).
        WHEN `GO`.

          DATA(app) = z2ui5_cl_smp_app_336=>factory( ).
          client->nav_app_call( app ).

        WHEN `CHANGE`.

          get_data_2( ).

      ENDCASE.

    ENDIF.

    IF ms_struc IS INITIAL.
      client->message_toast_display( `ERROR - MS_STRUC is initial!` ).
    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.

    IF mo_layout_obj_2->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  is not bound!` ).
    ENDIF.

    ASSIGN mo_layout_obj_2->mr_data->* TO <row>.

    IF <row>-id <> ms_struc-id.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data->id  does not match ms_struc-id!` ).
    ENDIF.

    ASSIGN mo_layout_obj->mr_data->* TO <row>.

    IF <row>-id <> ms_struc-id.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data->id  does not match ms_struc-id!` ).
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
        )->a( n = `press` v = client->_event( `CHANGE` )
        )->a( n = `text`  v = `Change Data`
        )->a( n = `type`  v = `Accept` ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `layout`          v = `ResponsiveGridLayout`
        )->a( n = `adjustLabelSpan` b = abap_true
        )->a( n = `editable`        b = abap_true
        )->ele( n = `content` ns = `form` ).

    DATA(index) = 0.

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      index = index + 1.

      ASSIGN mo_layout_obj->mr_data->* TO FIELD-SYMBOL(<val>).
      ASSIGN COMPONENT layout->name OF STRUCTURE <val> TO FIELD-SYMBOL(<value>).

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DATA(line) = form->tag( `Label`
          )->a( n = `text`     v = layout->name
          )->a( n = `wrapping` b = abap_false ).

      line->tag( `Input`
          )->a( n = `enabled` b = abap_false
          )->a( n = `visible` v = client->_bind( val       = layout->visible
                                            tab       = mo_layout_obj->ms_data-t_layout
                                            tab_index = index )
          )->a( n = `value`   v = client->_bind( <value> ) ).
    ENDLOOP.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_data.

    " any single row will do here, but it has to be the SAME one on every
    " roundtrip - SELECT SINGLE without a full key leaves that to the database
    SELECT * FROM z2ui5_t_01
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(lt_data) UP TO 1 ROWS.

    ms_struc = VALUE #( lt_data[ 1 ] OPTIONAL ).

  ENDMETHOD.


  METHOD get_data_2.

    SELECT * FROM z2ui5_t_01
      WHERE id <> @ms_struc-id
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(lt_data) UP TO 1 ROWS.

    ms_struc = VALUE #( lt_data[ 1 ] OPTIONAL ).

  ENDMETHOD.

ENDCLASS.
