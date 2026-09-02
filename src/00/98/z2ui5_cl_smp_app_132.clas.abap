CLASS z2ui5_cl_smp_app_132 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    DATA mv_init         TYPE abap_bool.
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
    " an init flag of this INSTANCE, not client->check_on_init( ): the host
    " creates a new instance of this class on every tab switch, in an event
    " roundtrip where the framework's init question - asked for the host's
    " draft - was answered long ago. Hung on check_on_init( ), the view was
    " never built after a switch and the tab stayed empty (sample 342 had it
    " right from the start)
    " abap2ui5lint-disable-next-line manual-init-flag -- check_on_init( ) answers for the host's draft, not for this instance
    IF mv_init = abap_false.
      mv_init = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
