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

    DATA(url_standard) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_sample_000|.
    page->header_content( )->button(
        text  = `Basic Samples`
        icon  = `sap-icon://action`
        press = client->_event_client( val   = client->cs_event-open_new_tab
                                       t_arg = VALUE #( ( url_standard ) ) ) ).

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
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_01` sub = `Sticky session with locking` app = `z2ui5_cl_demo_app_s_01` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_02` sub = `stateful session` app = `z2ui5_cl_demo_app_s_02` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_03` sub = `Play Sound` app = `z2ui5_cl_demo_app_s_03` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_04` sub = `Conversion Exits` app = `z2ui5_cl_demo_app_s_04` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_05` sub = `News Feed over Websocket` app = `z2ui5_cl_demo_app_s_05` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_05_ws` sub = `Generated APC WebSocket protocol impementation class` app = `z2ui5_cl_demo_app_s_05_ws` )
      ( group = `only non-abap-cloud` header = `z2ui5_cl_demo_app_s_06` sub = `Navigation with app state change v2` app = `z2ui5_cl_demo_app_s_06` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_013` sub = `visualization - donut chart` app = `z2ui5_cl_demo_app_013` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_014` sub = `visualization - line chart` app = `z2ui5_cl_demo_app_014` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_016` sub = `visualization - bar chart` app = `z2ui5_cl_demo_app_016` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_029` sub = `visualization - radial chart` app = `z2ui5_cl_demo_app_029` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_076` sub = `gantt - test` app = `z2ui5_cl_demo_app_076` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_091` sub = `visualization - process flow` app = `z2ui5_cl_demo_app_091` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_100` sub = `ui table` app = `z2ui5_cl_demo_app_100` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_113` sub = `more - timeline` app = `z2ui5_cl_demo_app_113` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_123` sub = `more - map container` app = `z2ui5_cl_demo_app_123` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_177` sub = `tab - toolbar container sort` app = `z2ui5_cl_demo_app_177` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_182` sub = `networkgraph - org tree` app = `z2ui5_cl_demo_app_182` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_196` sub = `status indicator` app = `z2ui5_cl_demo_app_196` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_308` sub = `Harvey Chart` app = `z2ui5_cl_demo_app_308` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_312` sub = `VizFrame Charts` app = `z2ui5_cl_demo_app_312` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_313` sub = `tab - smart controls` app = `z2ui5_cl_demo_app_313` )
      ( group = `only non-openui5` header = `z2ui5_cl_demo_app_319` sub = `odata, smartmultiinput` app = `z2ui5_cl_demo_app_319` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_01` sub = `launchpad I - Startup Parameters` app = `z2ui5_cl_demo_app_lp_01` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_02` sub = `launchpad II - Set Title` app = `z2ui5_cl_demo_app_lp_02` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_03` sub = `Launchpad III - cross app navigation I` app = `z2ui5_cl_demo_app_lp_03` )
      ( group = `only with launchpad` header = `z2ui5_cl_demo_app_lp_04` sub = `Launchpad IV - cross app navigation II` app = `z2ui5_cl_demo_app_lp_04` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_033` sub = `messages - illustrated (since 1.98)` app = `z2ui5_cl_demo_app_033` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_063` sub = `control - Badge (since 1.80)` app = `z2ui5_cl_demo_app_063` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_108` sub = `Side Panel (since 1.107)` app = `z2ui5_cl_demo_app_108` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_124` sub = `more - ndc scanner (since 1.102)` app = `z2ui5_cl_demo_app_124` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_183` sub = `table columnmenu (since 1.110)` app = `z2ui5_cl_demo_app_183` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_286` sub = `Standard List Item - Info State Inverted (since 1.74)` app = `z2ui5_cl_demo_app_286` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_301` sub = `Expandable Text (since 1.87)` app = `z2ui5_cl_demo_app_301` )
      ( group = `only higher UI5 1.71` header = `z2ui5_cl_demo_app_320` sub = `Avatar Group (since 1.73)` app = `z2ui5_cl_demo_app_320` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_032` sub = `extension - html css js` app = `z2ui5_cl_demo_app_032` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_036` sub = `extension - canvas and svg` app = `z2ui5_cl_demo_app_036` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_037` sub = `extension - custom control` app = `z2ui5_cl_demo_app_037` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_040` sub = `extension - ext library` app = `z2ui5_cl_demo_app_040` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_050` sub = `Change CSS - Send your own CSS to the frontend` app = `z2ui5_cl_demo_app_050` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_060` sub = `ui - suggestion` app = `z2ui5_cl_demo_app_060` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_084` sub = `Message Box & Input Functions` app = `z2ui5_cl_demo_app_084` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_090` sub = `popups - p13n Dialog` app = `z2ui5_cl_demo_app_090` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_093` sub = `ext - call custom function` app = `z2ui5_cl_demo_app_093` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_111` sub = `selscreen - filter bar with variant managment WIP` app = `z2ui5_cl_demo_app_111` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_116` sub = `tree table - save expand state` app = `z2ui5_cl_demo_app_116` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_141` sub = `custom function in popup` app = `z2ui5_cl_demo_app_141` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_172` sub = `ui table - focus handling` app = `z2ui5_cl_demo_app_172` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_178` sub = `tree - popup select - state` app = `z2ui5_cl_demo_app_178` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_201` sub = `ui - suggestion with CC filtering` app = `z2ui5_cl_demo_app_201` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_202_0` sub = `wizard - nextStep & subsequentSteps` app = `z2ui5_cl_demo_app_202_0` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_244` sub = `Flex Box - Size Adjustments` app = `z2ui5_cl_demo_app_244` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_253` sub = `Flex Box - Equal Height Cols` app = `z2ui5_cl_demo_app_253` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_254` sub = `Flex Box - Nested` app = `z2ui5_cl_demo_app_254` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_255` sub = `Flex Box - Navigation Examples` app = `z2ui5_cl_demo_app_255` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_256` sub = `Fix Flex - Fix container size` app = `z2ui5_cl_demo_app_256` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_268` sub = `Icon` app = `z2ui5_cl_demo_app_268` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_277` sub = `Tile - KPI Tile` app = `z2ui5_cl_demo_app_277` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_305` sub = `Cell Coloring` app = `z2ui5_cl_demo_app_305` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_309` sub = `follow_up_action with JS` app = `z2ui5_cl_demo_app_309` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_309_0` sub = `follow_up_action with JS` app = `z2ui5_cl_demo_app_309_0` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_310` sub = `Messages with Styles I` app = `z2ui5_cl_demo_app_310` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_311` sub = `Messages with Styles II` app = `z2ui5_cl_demo_app_311` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_317` sub = `tree - drag & drop` app = `z2ui5_cl_demo_app_317` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_346` sub = `tab - focus edit controls` app = `z2ui5_cl_demo_app_346` )
      ( group = `only with javascript and css` header = `z2ui5_cl_demo_app_352_0` sub = `Softkeyboard on/off` app = `z2ui5_cl_demo_app_352_0` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_043` sub = `test - documentation` app = `z2ui5_cl_demo_app_043` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_082` sub = `test - speed` app = `z2ui5_cl_demo_app_082` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_118` sub = `data binding tables with invalid date and time` app = `z2ui5_cl_demo_app_118` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_138` sub = `unit test - long variable` app = `z2ui5_cl_demo_app_138` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_191` sub = `Deep Structure Sub App` app = `z2ui5_cl_demo_app_191` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_195` sub = `Deep Structure Main App` app = `z2ui5_cl_demo_app_195` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_199` sub = `Type Ref to Data Table with refresh` app = `z2ui5_cl_demo_app_199` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_324` sub = `Catch exceptions and display popup` app = `z2ui5_cl_demo_app_324` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_328` sub = `basic - popups with ref from prev App` app = `z2ui5_cl_demo_app_328` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_331` sub = `RTTI - Struc` app = `z2ui5_cl_demo_app_331` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_332` sub = `RTTI - Struc with Cell Binding` app = `z2ui5_cl_demo_app_332` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_334` sub = `RTTI - Struc with Class Data` app = `z2ui5_cl_demo_app_334` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_335` sub = `RTTI - Struc with Class Data and Popup` app = `z2ui5_cl_demo_app_335` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_337` sub = `RTTI - Table with Class Data and Popup` app = `z2ui5_cl_demo_app_337` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_338` sub = `App in App - Main App` app = `z2ui5_cl_demo_app_338` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_341` sub = `basic - popups and flow` app = `z2ui5_cl_demo_app_341` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_343` sub = `Check throw error when ref used for binding` app = `z2ui5_cl_demo_app_343` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_344` sub = `RTTI - with many Layouts` app = `z2ui5_cl_demo_app_344` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_345` sub = `RTTI - with many Layouts` app = `z2ui5_cl_demo_app_345` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_347` sub = `RTTI - Table with Ref in Object` app = `z2ui5_cl_demo_app_347` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_348` sub = `RTTI - Struc with Ref in Object` app = `z2ui5_cl_demo_app_348` )
      ( group = `only testing` header = `z2ui5_cl_demo_app_349` sub = `RTTI - Table with Class Data and Popup` app = `z2ui5_cl_demo_app_349` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_179` sub = `gantt II` app = `z2ui5_cl_demo_app_179` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_314` sub = `tab - odata, device, http` app = `z2ui5_cl_demo_app_314` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_315` sub = `tab - different odata models` app = `z2ui5_cl_demo_app_315` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_321` sub = `Navigation - app state` app = `z2ui5_cl_demo_app_321` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_322` sub = `Navigation - push state` app = `z2ui5_cl_demo_app_322` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_323` sub = `Navigation - app state share` app = `z2ui5_cl_demo_app_323` )
      ( group = `experimental` header = `z2ui5_cl_demo_app_353` sub = `Multiple Timers` app = `z2ui5_cl_demo_app_353` )
      ( group = `demos` header = `z2ui5_cl_demo_app_002` sub = `Selection Screen - Explore Input Controls` app = `z2ui5_cl_demo_app_002` )
      ( group = `demos` header = `z2ui5_cl_demo_app_085` sub = `Sample App` app = `z2ui5_cl_demo_app_085` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_355` sub = `more - InputListItem Sample` app = `z2ui5_cl_demo_app_355` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_356` sub = `more - Label Sample` app = `z2ui5_cl_demo_app_356` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_357` sub = `more - Controls Overview` app = `z2ui5_cl_demo_app_357` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_358` sub = `more - Table` app = `z2ui5_cl_demo_app_358` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_359` sub = `more - Expression Binding` app = `z2ui5_cl_demo_app_359` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_360` sub = `more - Formatter` app = `z2ui5_cl_demo_app_360` )
      ( group = `generic xml view` header = `z2ui5_cl_demo_app_361` sub = `more - System Logout` app = `z2ui5_cl_demo_app_361` )
      ( group = `only non-openui5-with-cc` header = `z2ui5_cl_demo_app_120` sub = `cc - geoloaction` app = `z2ui5_cl_demo_app_120` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_000` sub = `landing page` app = `z2ui5_cl_demo_app_000` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_028_0` sub = `obsolete - uses CL_GUI_TIMER, use Timer custom control` app = `z2ui5_cl_demo_app_028_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_121_0` sub = `obsolete - superseded timer demo` app = `z2ui5_cl_demo_app_121_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_122_0` sub = `obsolete - superseded frontend-info demo` app = `z2ui5_cl_demo_app_122_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_125_0` sub = `obsolete - superseded browser-title demo` app = `z2ui5_cl_demo_app_125_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_129_0` sub = `obsolete - superseded timer/popover demo` app = `z2ui5_cl_demo_app_129_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_133_0` sub = `obsolete - old focus demo, use Focus custom control` app = `z2ui5_cl_demo_app_133_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_134_0` sub = `obsolete - old scroll demo, use Scrolling custom control` app = `z2ui5_cl_demo_app_134_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_180` sub = `obsolete - superseded follow_up_action demo` app = `z2ui5_cl_demo_app_180` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_189_0` sub = `obsolete - old focus demo, use Focus custom control` app = `z2ui5_cl_demo_app_189_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_269` sub = `obsolete - uses deprecated sap.f.Avatar, use sap.m.Avatar` app = `z2ui5_cl_demo_app_269` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_284` sub = `obsolete - uses deprecated sap.ui.table.AnalyticalTable` app = `z2ui5_cl_demo_app_284` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_285` sub = `obsolete - uses deprecated sap.ui.table.AnalyticalTable` app = `z2ui5_cl_demo_app_285` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_353_0` sub = `obsolete - superseded multiple-timers demo` app = `z2ui5_cl_demo_app_353_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_lp_02_0` sub = `obsolete - superseded launchpad set-title demo` app = `z2ui5_cl_demo_app_lp_02_0` )
      ( group = `obsolete` header = `z2ui5_cl_demo_app_s_03_0` sub = `obsolete - superseded play-sound demo` app = `z2ui5_cl_demo_app_s_03_0` ) ).

  ENDMETHOD.

ENDCLASS.

