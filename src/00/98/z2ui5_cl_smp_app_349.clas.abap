CLASS z2ui5_cl_smp_app_349 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data         TYPE STANDARD TABLE OF z2ui5_t_01 WITH EMPTY KEY.
    DATA ms_data         TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_smp_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    METHODS xml_table
      IMPORTING
        i_page   TYPE REF TO z2ui5_cl_ui5_view_builder
        i_client TYPE REF TO z2ui5_if_client.

    METHODS xml_form
      IMPORTING
        i_page   TYPE REF TO z2ui5_cl_ui5_view_builder
        i_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_349 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).

      mo_layout_obj = z2ui5_cl_smp_app_333=>factory( i_data   = REF #( mt_data )
                                                      vis_cols = 5 ).
      mo_layout_obj_2 = z2ui5_cl_smp_app_333=>factory( i_data   = REF #( ms_data )
                                                        vis_cols = 3 ).
      view_display( client ).

    ELSEIF client->check_on_navigated( ).
      view_display( client ).

    ELSEIF client->check_on_event( ).

      IF client->get_event( ) = `GO`.
        DATA(app) = z2ui5_cl_smp_app_336=>factory( ).
        client->nav_app_call( app ).
      ENDIF.

    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.

    IF mo_layout_obj_2->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  is not bound!` ).
    ENDIF.

    IF mt_data IS INITIAL.
      client->message_toast_display( `ERROR - mt_data is INITIAL!` ).
    ENDIF.

    IF ms_data IS INITIAL.
      client->message_toast_display( `ERROR - ms_data is INITIAL!` ).
    ENDIF.

    ASSIGN mo_layout_obj->mr_data->* TO FIELD-SYMBOL(<val>).

    IF <val> <> mt_data.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> mt_data!` ).
    ENDIF.
    ASSIGN mo_layout_obj_2->mr_data->* TO FIELD-SYMBOL(<val2>).

    IF <val2> <> ms_data.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> ms_data!` ).
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

    xml_table( i_page   = page
               i_client = client ).

    xml_form( i_page   = page
              i_client = client ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD xml_table.

    DATA(table) = i_page->ele( `Table`
        )->a( n = `items` v = i_client->_bind( val = mt_data )
        )->a( n = `width` v = `auto` ).

    DATA(columns) = table->ele( `columns` ).

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->ele( `Column`
          )->a( n = `visible` v = i_client->_bind( val       = layout->visible
                                                  tab       = mo_layout_obj->ms_data-t_layout
                                                  tab_index = lv_index )
          )->tag( `Text`
              )->a( n = `text` v = layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->a( n = `vAlign` v = `Middle`
                )->a( n = `type`   v = `Inactive` ).

    DATA(cells) = column_list_item->ele( `cells` ).

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->ele( `ObjectIdentifier`
          )->a( n = `text` v = |\{{ layout->name }\}| ).

    ENDLOOP.

  ENDMETHOD.


  METHOD get_data.

    SELECT id,
           id_prev,
           id_prev_app,
           id_prev_app_stack,
           timestampl
      FROM z2ui5_t_01
      ORDER BY PRIMARY KEY
      INTO CORRESPONDING FIELDS OF TABLE @mt_data
      UP TO 10 ROWS.

    ms_data = VALUE #( mt_data[ 1 ] OPTIONAL ).

  ENDMETHOD.


  METHOD xml_form.

    DATA(form) = i_page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `layout`          v = `ResponsiveGridLayout`
        )->a( n = `adjustLabelSpan` b = abap_true
        )->a( n = `editable`        b = abap_true
        )->ele( n = `content` ns = `form` ).

    DATA(index) = 0.

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      index = index + 1.

      ASSIGN COMPONENT layout->name OF STRUCTURE ms_data TO FIELD-SYMBOL(<value>).

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DATA(line) = form->tag( `Label`
          )->a( n = `text`     v = layout->name
          )->a( n = `wrapping` b = abap_false ).

      line->tag( `Input`
          )->a( n = `enabled` b = abap_false
          )->a( n = `visible` v = i_client->_bind( val       = layout->visible
                                              tab       = mo_layout_obj->ms_data-t_layout
                                              tab_index = index )
          )->a( n = `value`   v = i_client->_bind( <value> ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
