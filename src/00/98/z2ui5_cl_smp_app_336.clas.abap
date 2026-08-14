CLASS z2ui5_cl_smp_app_336 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc        TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_smp_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    CLASS-METHODS factory
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_smp_app_336.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_336 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mo_layout_obj = z2ui5_cl_smp_app_333=>factory( i_data   = REF #( ms_struc )
                                                      vis_cols = 3 ).
      mo_layout_obj_2 = z2ui5_cl_smp_app_333=>factory( i_data   = REF #( ms_struc )
                                                        vis_cols = 3 ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory( )->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core` )->ele( `Shell` )->ele( `Page`
        )->a( n = `title`          v = `RTTI IV`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event_nav_app_leave( )
        )->a( n = `text`  v = `BACK`
        )->a( n = `type`  v = `Success` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD factory.

    result = NEW #( ).

  ENDMETHOD.

ENDCLASS.
