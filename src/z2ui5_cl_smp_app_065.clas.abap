" @keywords nest_view_display rerender model refresh sub view
" @summary A nested view: nest_view_display renders a second view inside the first, and shows which model refresh reaches it.
" @docs https://abap2ui5.github.io/docs/cookbook/view/nested_views
CLASS z2ui5_cl_smp_app_065 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_input_main  TYPE string.
    DATA mv_input_nest  TYPE string.
    DATA mv_count       TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS nest_view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_065 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `TEST`.
        client->message_box_display( |input { mv_input_nest }| ).
      WHEN `ALL`.
        view_display( ).
        nest_view_display( ).
      WHEN `MAIN`.
        view_display( ).
      WHEN `NEST`.
        nest_view_display( ).
      WHEN `NEST_MODEL`.
        " change only a nest-bound field, without re-rendering the nested XML.
        " The main and nested views share one model and that model is pushed
        " with every response, so the nested view picks the change up too.
        " Press "Rerender only nested view" first so the nested view exists.
        mv_count      = mv_count + 1.
        mv_input_nest = |nest model updated #{ mv_count }|.
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = lo_view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Nested View - Basic Example (nest_view_display)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `test` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A main view with a nested view inside: the buttons re-render everything, only the ` &&
                   `main view, only the nested view, or refresh just the nested view's model.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `content`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `ALL` )
            )->a( n = `text`  v = `Rerender all`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `MAIN` )
            )->a( n = `text`  v = `Rerender Main without nest`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `NEST` )
            )->a( n = `text`  v = `Rerender only nested view`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `NEST_MODEL` )
            )->a( n = `text`  v = `Update only nested MODEL (no re-render)`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( mv_input_main ) ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.


  METHOD nest_view_display.

    DATA(lo_view_nested) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Page`
                )->a( n = `title` v = `Nested View`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `TEST` )
                    )->a( n = `text`  v = `event`
                )->tag( `Input`
                    )->a( n = `value` v = client->_bind( mv_input_nest ) ).

    client->nest_view_display( val = lo_view_nested->stringify( ) id = `test` method_insert = `addContent` ).

  ENDMETHOD.

ENDCLASS.
