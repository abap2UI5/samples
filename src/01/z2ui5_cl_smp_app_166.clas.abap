" @keywords structure component include flat form level
" @summary Binds a form to a structure with INCLUDEs, so the included components are reachable under their own names on one flat level.
" @docs https://abap2ui5.github.io/docs/cookbook/model/binding
CLASS z2ui5_cl_smp_app_166 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_struc_incl,
        incl_title  TYPE string,
        incl_value  TYPE string,
        incl_value2 TYPE string,
      END OF ty_s_struc_incl.

    TYPES:
      BEGIN OF ty_s_struc,
        title  TYPE string,
        value  TYPE string,
        value2 TYPE string,
      END OF ty_s_struc.
    DATA ms_struc TYPE ty_s_struc.

    DATA
      BEGIN OF ms_struc2.
        INCLUDE TYPE ty_s_struc.
        INCLUDE TYPE ty_s_struc_incl.
    DATA END OF ms_struc2.

    METHODS set_view.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_166 IMPLEMENTATION.

  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Structure Fields and INCLUDEs`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample demonstrates structure-level binding: each input is bound to a ` &&
                   `field of a flat structure, including fields pulled in via INCLUDE.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc-title ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc-value ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc-value2 ) ).

    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc2-title ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc2-value ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc2-value2 ) ).

    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc2-incl_title ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc2-incl_value ) ).
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = ms_struc2-incl_value2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      ms_struc-title  = `title`.
      ms_struc-value  = `val01`.
      ms_struc-value2 = `val02`.

      ms_struc2-title  = `title`.
      ms_struc2-value  = `val01`.
      ms_struc2-value2 = `val02`.
      ms_struc2-incl_title = `title_incl`.
      ms_struc2-incl_value = `val01_incl`.
      ms_struc2-incl_value2 = `val02_incl`.

      set_view( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      set_view( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
