CLASS z2ui5_cl_smp_app_132 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    "! the Page this app renders into when it is embedded in another app's
    "! view; left empty the app builds a view of its own and displays it
    DATA mo_parent_page  TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA mv_perc         TYPE string.

    METHODS set_app_data
      IMPORTING
        count TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_132 IMPLEMENTATION.

  METHOD view_display.

    IF mo_parent_page IS INITIAL.
      DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    ELSE.
      page = mo_parent_page.

    ENDIF.

    page->tag( `Label`
        )->a( n = `text` v = `ProgressIndicator`
        )->tag( `ProgressIndicator`
            )->a( n = `percentValue` v = mv_perc
            )->a( n = `displayValue` v = `0,44GB of 32GB used`
            )->a( n = `showValue`    b = abap_true
            )->a( n = `state`        v = `Success` ).

    IF mo_parent_page IS INITIAL.
      client->view_display( page->stringify( ) ).

    ELSE.
      mv_view_display = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD set_app_data.

    mv_perc = count.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
