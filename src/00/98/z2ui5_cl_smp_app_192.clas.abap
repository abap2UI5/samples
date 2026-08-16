CLASS z2ui5_cl_smp_app_192 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_out,
        aa TYPE string,
        bb TYPE string,
        cc TYPE string,
      END OF ty_s_out,
      ty_t_out TYPE STANDARD TABLE OF ty_s_out WITH EMPTY KEY.

    DATA mt_new_data2 TYPE STANDARD TABLE OF REF TO z2ui5_cl_smp_app_193 WITH EMPTY KEY.

    DATA mt_out TYPE ty_t_out.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS get_data.
    METHODS xml_parse.
    METHODS xml_stringify.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_192 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `xxx`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->ele( `headerContent` ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    xml_parse( ).
    me->client = client.
    get_data( ).
    view_display( ).
    xml_stringify( ).

  ENDMETHOD.


  METHOD get_data.

    DATA lr_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lr_tabdescr TYPE REF TO cl_abap_tabledescr.
    FIELD-SYMBOLS <fs_s_head> TYPE any.
    FIELD-SYMBOLS <fs_t_head_new> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_s_head_new> TYPE any.

    mt_out = VALUE #( ( aa = `aa` bb = `bb` cc = `cc` )
                      ( aa = `a1` bb = `b1` cc = `c1` ) ).

    DATA(kopf) = REF #( mt_out ).

    LOOP AT kopf->* ASSIGNING <fs_s_head>.

      DATA(lo_new_data) = NEW z2ui5_cl_smp_app_193( ).
      INSERT lo_new_data INTO TABLE mt_new_data2.

      lr_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_s_head> ).
      lr_tabdescr ?= cl_abap_tabledescr=>create( lr_structdescr ).

      CREATE DATA lo_new_data->mt_kopf TYPE HANDLE lr_tabdescr.
      ASSIGN lo_new_data->mt_kopf->* TO <fs_t_head_new>.

      APPEND INITIAL LINE TO <fs_t_head_new> ASSIGNING <fs_s_head_new>.
      <fs_s_head_new> = <fs_s_head>.

    ENDLOOP.

  ENDMETHOD.


  METHOD xml_parse.

    LOOP AT mt_new_data2 INTO DATA(lo_data).
      lo_data->xml_parse( ).
    ENDLOOP.

  ENDMETHOD.


  METHOD xml_stringify.

    LOOP AT mt_new_data2 INTO DATA(lo_data).
      lo_data->xml_stringify( ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
