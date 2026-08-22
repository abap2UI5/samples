" @keywords combobox jsonmodel size limit large itab 100 entries
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
    DATA t_combo        TYPE STANDARD TABLE OF ty_s_combobox WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS combo_fill.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_071 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE string_table.
      DATA temp2 TYPE string.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      combo_fill( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `UPDATE` ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2 = set_size_limit.
      INSERT temp2 INTO TABLE temp1.
      INSERT client->cs_view-main INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_size_limit
          t_arg = temp1 ).
      client->message_toast_display( `SizeLimitUpdated` ).

    ELSEIF client->check_on_event( `UPDATE_MODEL` ) IS NOT INITIAL.

      combo_fill( ).
      client->message_toast_display( `update number of entries` ).

    ENDIF.

  ENDMETHOD.


  METHOD combo_fill.

    DATA temp3 LIKE t_combo.
      DATA temp4 TYPE z2ui5_cl_smp_app_071=>ty_s_combobox.
    CLEAR temp3.
    t_combo = temp3.
    DO combo_number TIMES.
      
      CLEAR temp4.
      temp4-key = sy-index.
      temp4-text = sy-index.
      INSERT temp4 INTO TABLE t_combo.
    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Model setSizeLimit for Large Tables`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A ComboBox bound to a large internal table: adjust the model's setSizeLimit to ` &&
                   `control how many of the entries the control actually renders.`
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
                )->a( n = `text` v = `demo`
            )->ele( `ComboBox`
                )->a( n = `items` v = client->_bind( t_combo )
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{KEY}`
                    )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
