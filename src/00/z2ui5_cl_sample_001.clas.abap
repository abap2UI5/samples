CLASS z2ui5_cl_sample_001 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tile,
        group  TYPE string,
        header TYPE string,
        sub    TYPE string,
        app    TYPE string,
      END OF ty_s_tile.
    TYPES ty_t_tile TYPE STANDARD TABLE OF ty_s_tile WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF s_scroll,
        id TYPE string,
        x  TYPE i,
        y  TYPE i,
      END OF s_scroll.

    METHODS on_event.
    METHODS scroll_restore.
    METHODS view_display.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_tile.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_sample_001 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).

      scroll_restore( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    TRY.
        DATA(classname) = to_upper( client->get( )-event ).
        DATA li_app TYPE REF TO z2ui5_if_app.
        CREATE OBJECT li_app TYPE (classname).
        s_scroll = CORRESPONDING #( client->get( )-s_scroll-main ).
        client->nav_app_call( li_app ).
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD scroll_restore.

    IF s_scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    client->action->gen(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = VALUE #( ( s_scroll-id )
                         ( |{ s_scroll-y }| )
                         ( |{ s_scroll-x }| ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        id             = `page`
        title          = `abap2UI5 - Samples (restricted)`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content( )->button(
        text  = `Standard Samples`
        icon  = `sap-icon://nav-back`
        press = client->_event( `Z2UI5_CL_SAMPLE_000` ) ).

    DATA(prev_group) = ``.

    LOOP AT get_catalog( ) INTO DATA(tile).

      IF tile-group <> prev_group.
        page->title(
            text  = tile-group
            level = `H3`
            class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
        prev_group = tile-group.
      ENDIF.

      DATA(row) = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = `sapUiTinyMarginBegin` ).

      IF tile-sub IS INITIAL.
        row->link(
            text  = tile-header
            press = client->_event( tile-app ) ).

      ELSE.
        row->link(
            text  = tile-header
            class = `sapUiTinyMarginEnd`
            press = client->_event( tile-app )
            )->text( tile-sub ).
      ENDIF.

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_01` sub = `` app = `z2ui5_cl_demo_app_s_01` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_02` sub = `` app = `z2ui5_cl_demo_app_s_02` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_03` sub = `` app = `z2ui5_cl_demo_app_s_03` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_04` sub = `` app = `z2ui5_cl_demo_app_s_04` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_05` sub = `` app = `z2ui5_cl_demo_app_s_05` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_05_ws` sub = `` app = `z2ui5_cl_demo_app_s_05_ws` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_06` sub = `` app = `z2ui5_cl_demo_app_s_06` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_013` sub = `` app = `z2ui5_cl_demo_app_013` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_014` sub = `` app = `z2ui5_cl_demo_app_014` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_016` sub = `` app = `z2ui5_cl_demo_app_016` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_029` sub = `` app = `z2ui5_cl_demo_app_029` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_076` sub = `` app = `z2ui5_cl_demo_app_076` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_091` sub = `` app = `z2ui5_cl_demo_app_091` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_100` sub = `` app = `z2ui5_cl_demo_app_100` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_113` sub = `` app = `z2ui5_cl_demo_app_113` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_123` sub = `` app = `z2ui5_cl_demo_app_123` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_177` sub = `` app = `z2ui5_cl_demo_app_177` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_182` sub = `` app = `z2ui5_cl_demo_app_182` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_196` sub = `` app = `z2ui5_cl_demo_app_196` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_308` sub = `` app = `z2ui5_cl_demo_app_308` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_312` sub = `` app = `z2ui5_cl_demo_app_312` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_313` sub = `` app = `z2ui5_cl_demo_app_313` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_319` sub = `` app = `z2ui5_cl_demo_app_319` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_01` sub = `` app = `z2ui5_cl_demo_app_lp_01` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_02` sub = `` app = `z2ui5_cl_demo_app_lp_02` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_03` sub = `` app = `z2ui5_cl_demo_app_lp_03` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_04` sub = `` app = `z2ui5_cl_demo_app_lp_04` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_033` sub = `` app = `z2ui5_cl_demo_app_033` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_063` sub = `` app = `z2ui5_cl_demo_app_063` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_108` sub = `` app = `z2ui5_cl_demo_app_108` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_124` sub = `` app = `z2ui5_cl_demo_app_124` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_183` sub = `` app = `z2ui5_cl_demo_app_183` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_286` sub = `` app = `z2ui5_cl_demo_app_286` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_301` sub = `` app = `z2ui5_cl_demo_app_301` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_320` sub = `` app = `z2ui5_cl_demo_app_320` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_032` sub = `` app = `z2ui5_cl_demo_app_032` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_036` sub = `` app = `z2ui5_cl_demo_app_036` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_037` sub = `` app = `z2ui5_cl_demo_app_037` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_040` sub = `` app = `z2ui5_cl_demo_app_040` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_050` sub = `` app = `z2ui5_cl_demo_app_050` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_060` sub = `` app = `z2ui5_cl_demo_app_060` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_084` sub = `` app = `z2ui5_cl_demo_app_084` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_090` sub = `` app = `z2ui5_cl_demo_app_090` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_093` sub = `` app = `z2ui5_cl_demo_app_093` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_111` sub = `` app = `z2ui5_cl_demo_app_111` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_116` sub = `` app = `z2ui5_cl_demo_app_116` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_141` sub = `` app = `z2ui5_cl_demo_app_141` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_172` sub = `` app = `z2ui5_cl_demo_app_172` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_178` sub = `` app = `z2ui5_cl_demo_app_178` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_201` sub = `` app = `z2ui5_cl_demo_app_201` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_202_0` sub = `` app = `z2ui5_cl_demo_app_202_0` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_244` sub = `` app = `z2ui5_cl_demo_app_244` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_253` sub = `` app = `z2ui5_cl_demo_app_253` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_254` sub = `` app = `z2ui5_cl_demo_app_254` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_255` sub = `` app = `z2ui5_cl_demo_app_255` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_256` sub = `` app = `z2ui5_cl_demo_app_256` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_268` sub = `` app = `z2ui5_cl_demo_app_268` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_277` sub = `` app = `z2ui5_cl_demo_app_277` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_305` sub = `` app = `z2ui5_cl_demo_app_305` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_309` sub = `` app = `z2ui5_cl_demo_app_309` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_309_0` sub = `` app = `z2ui5_cl_demo_app_309_0` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_310` sub = `` app = `z2ui5_cl_demo_app_310` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_311` sub = `` app = `z2ui5_cl_demo_app_311` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_317` sub = `` app = `z2ui5_cl_demo_app_317` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_346` sub = `` app = `z2ui5_cl_demo_app_346` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_352_0` sub = `` app = `z2ui5_cl_demo_app_352_0` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_043` sub = `` app = `z2ui5_cl_demo_app_043` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_082` sub = `` app = `z2ui5_cl_demo_app_082` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_118` sub = `` app = `z2ui5_cl_demo_app_118` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_138` sub = `` app = `z2ui5_cl_demo_app_138` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_191` sub = `` app = `z2ui5_cl_demo_app_191` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_195` sub = `` app = `z2ui5_cl_demo_app_195` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_199` sub = `` app = `z2ui5_cl_demo_app_199` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_324` sub = `` app = `z2ui5_cl_demo_app_324` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_328` sub = `` app = `z2ui5_cl_demo_app_328` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_331` sub = `` app = `z2ui5_cl_demo_app_331` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_332` sub = `` app = `z2ui5_cl_demo_app_332` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_334` sub = `` app = `z2ui5_cl_demo_app_334` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_335` sub = `` app = `z2ui5_cl_demo_app_335` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_337` sub = `` app = `z2ui5_cl_demo_app_337` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_338` sub = `` app = `z2ui5_cl_demo_app_338` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_341` sub = `` app = `z2ui5_cl_demo_app_341` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_343` sub = `` app = `z2ui5_cl_demo_app_343` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_344` sub = `` app = `z2ui5_cl_demo_app_344` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_345` sub = `` app = `z2ui5_cl_demo_app_345` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_347` sub = `` app = `z2ui5_cl_demo_app_347` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_348` sub = `` app = `z2ui5_cl_demo_app_348` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_349` sub = `` app = `z2ui5_cl_demo_app_349` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_179` sub = `` app = `z2ui5_cl_demo_app_179` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_314` sub = `` app = `z2ui5_cl_demo_app_314` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_315` sub = `` app = `z2ui5_cl_demo_app_315` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_321` sub = `` app = `z2ui5_cl_demo_app_321` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_322` sub = `` app = `z2ui5_cl_demo_app_322` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_323` sub = `` app = `z2ui5_cl_demo_app_323` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_353` sub = `` app = `z2ui5_cl_demo_app_353` )
      ( group = `demos` header = `z2ui5_cl_demo_app_002` sub = `` app = `z2ui5_cl_demo_app_002` )
      ( group = `demos` header = `z2ui5_cl_demo_app_085` sub = `` app = `z2ui5_cl_demo_app_085` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_355` sub = `` app = `z2ui5_cl_demo_app_355` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_356` sub = `` app = `z2ui5_cl_demo_app_356` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_357` sub = `` app = `z2ui5_cl_demo_app_357` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_358` sub = `` app = `z2ui5_cl_demo_app_358` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_359` sub = `` app = `z2ui5_cl_demo_app_359` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_360` sub = `` app = `z2ui5_cl_demo_app_360` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_361` sub = `` app = `z2ui5_cl_demo_app_361` )
      ( group = `only non-openui5-with-cc` header = `z2ui5_cl_demo_app_120` sub = `` app = `z2ui5_cl_demo_app_120` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_000` sub = `` app = `z2ui5_cl_demo_app_000` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_028_0` sub = `` app = `z2ui5_cl_demo_app_028_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_121_0` sub = `` app = `z2ui5_cl_demo_app_121_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_122_0` sub = `` app = `z2ui5_cl_demo_app_122_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_125_0` sub = `` app = `z2ui5_cl_demo_app_125_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_129_0` sub = `` app = `z2ui5_cl_demo_app_129_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_133_0` sub = `` app = `z2ui5_cl_demo_app_133_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_134_0` sub = `` app = `z2ui5_cl_demo_app_134_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_180` sub = `` app = `z2ui5_cl_demo_app_180` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_189_0` sub = `` app = `z2ui5_cl_demo_app_189_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_269` sub = `` app = `z2ui5_cl_demo_app_269` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_284` sub = `` app = `z2ui5_cl_demo_app_284` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_285` sub = `` app = `z2ui5_cl_demo_app_285` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_353_0` sub = `` app = `z2ui5_cl_demo_app_353_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_lp_02_0` sub = `` app = `z2ui5_cl_demo_app_lp_02_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_s_03_0` sub = `` app = `z2ui5_cl_demo_app_s_03_0` ) ).

  ENDMETHOD.

ENDCLASS.

