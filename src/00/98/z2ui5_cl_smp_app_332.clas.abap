CLASS z2ui5_cl_smp_app_332 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc     TYPE z2ui5_t_01.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_332 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).

      mo_table_obj = z2ui5_cl_smp_app_333=>factory( i_data   = REF #( ms_struc )
                                                     vis_cols = 3 ).

      view_display( client ).

    ENDIF.

    IF ms_struc IS INITIAL.
      client->message_toast_display( `ERROR - MS_STRUC is initial!` ).
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
        )->a( n = `text`  v = `GO`
        )->a( n = `type`  v = `Success` ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `layout`          v = `ResponsiveGridLayout`
        )->a( n = `adjustLabelSpan` b = abap_true
        )->a( n = `editable`        b = abap_true
        )->ele( n = `content` ns = `form` ).

    DATA(index) = 0.

    LOOP AT mo_table_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      index = index + 1.

      ASSIGN mo_table_obj->mr_data->* TO FIELD-SYMBOL(<val>).
      ASSIGN COMPONENT layout->name OF STRUCTURE <val> TO FIELD-SYMBOL(<value>).
      " assign component layout->name of structure ms_struc to field-symbol(<value>).

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DATA(line) = form->tag( `Label`
          )->a( n = `text`     v = layout->name
          )->a( n = `wrapping` b = abap_false ).

      line->tag( `Input`
          )->a( n = `enabled` b = abap_false
          )->a( n = `visible` v = client->_bind( val       = layout->visible
                                            tab       = mo_table_obj->ms_data-t_layout
                                            tab_index = index )
          )->a( n = `value`   v = client->_bind( <value> ) ).
    ENDLOOP.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_data.

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF @ms_struc.

  ENDMETHOD.

ENDCLASS.
