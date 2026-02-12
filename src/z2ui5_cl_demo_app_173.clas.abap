CLASS z2ui5_cl_demo_app_173 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        date TYPE string,
        age  TYPE string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        fname   TYPE string,
        merge   TYPE string,
        visible TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    DATA mv_flag TYPE abap_bool. " VALUE abap_true.
    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

    METHODS view_display.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_173 IMPLEMENTATION.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view = lo_view->shell( )->page( id    = `page_main`
                                 class = `sapUiContentPadding`
             title                     = `abap2UI5 - Sample Templating I`
             navbuttonpress            = mo_client->_event_nav_app_leave( )
             shownavbutton             = mo_client->check_app_prev_stack( ) ).

    lo_view->table( items = mo_client->_bind( mt_data )
      )->columns(
        )->template_repeat( list = `{template>/MT_LAYOUT}`
                            var  = `L0`
          )->column( mergeduplicates = `{L0>MERGE}`
                     visible         = `{L0>VISIBLE}` )->text( text = `{L0>FNAME}` )->get_parent(
        )->get_parent( )->get_parent(
        )->items(
          )->column_list_item(
            )->cells(
              )->template_repeat( list = `{template>/MT_LAYOUT}`
                                  var  = `L1`
                )->object_identifier( text = `{= '{' + ${L1>FNAME} + '}' }` ).

    lo_view->label( text = `IF Template (with re-rendering)` ).
    lo_view->switch( state  = mo_client->_bind_edit( mv_flag )
                  change = mo_client->_event( `CHANGE_FLAG` ) ).
    lo_view = lo_view->vbox( ).

    lo_view->template_if( test = `{template>/XX/MV_FLAG}`
      )->template_then(
        )->icon( src   = `sap-icon://accept`
                 color = `green` )->get_parent(
      )->template_else(
        )->icon( src   = `sap-icon://decline`
                 color = `red` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      mo_client->_bind( mt_layout ).

      mt_data = VALUE #( ( name = `Theo` date = `01.01.2000` age = `5` )
                         ( name = `Lore` date = `01.01.2000` age = `1` ) ).

      mt_layout = VALUE #( ( fname = `NAME` merge = `false` visible = `true` )
                           ( fname = `DATE` merge = `false` visible = `true` )
                           ( fname = `AGE`  merge = `false` visible = `false` ) ).

      view_display( ).

    ENDIF.

    IF mo_client->check_on_event( `CHANGE_FLAG` ).

      view_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
