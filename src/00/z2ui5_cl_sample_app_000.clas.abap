CLASS z2ui5_cl_sample_app_000 DEFINITION PUBLIC.

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
    METHODS header_base
      IMPORTING
        header        TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_sample_app_000 IMPLEMENTATION.

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

    DATA(url_standard) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_sample_app_001|.
    page->header_content( )->button(
        text  = `Basic Samples`
        icon  = `sap-icon://action`
        press = client->_event_client( val   = client->cs_event-open_new_tab
                                       t_arg = VALUE #( ( url_standard ) ) ) ).

    DATA(prev_group) = ``.
    DATA(prev_base) = ``.

    LOOP AT get_catalog( ) INTO DATA(tile).

      DATA(base) = header_base( tile-header ).
      DATA(new_block) = abap_false.

      IF tile-group <> prev_group.
        page->title(
            text  = tile-group
            level = `H3`
            class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
        prev_group = tile-group.

      ELSEIF base <> prev_base.
        new_block = abap_true.
      ENDIF.

      prev_base = base.

      DATA(row) = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = COND #( WHEN new_block = abap_true
                               THEN `sapUiTinyMarginBegin sapUiSmallMarginTop`
                               ELSE `sapUiTinyMarginBegin` ) ).

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
      ( group = `only non-abap-cloud` header = `Conversion Exits` sub = `` app = `z2ui5_cl_demo_app_s_04` )
      ( group = `only non-abap-cloud` header = `Generated APC WebSocket protocol impementation class` sub = `` app = `z2ui5_cl_demo_app_s_05_ws` )
      ( group = `only non-abap-cloud` header = `Navigation with app state change v2` sub = `` app = `z2ui5_cl_demo_app_s_06` )
      ( group = `only non-abap-cloud` header = `News Feed over Websocket` sub = `` app = `z2ui5_cl_demo_app_s_05` )
      ( group = `only non-abap-cloud` header = `Play Sound` sub = `` app = `z2ui5_cl_demo_app_s_03` )
      ( group = `only non-abap-cloud` header = `stateful session` sub = `` app = `z2ui5_cl_demo_app_s_02` )
      ( group = `only non-abap-cloud` header = `Sticky session with locking` sub = `` app = `z2ui5_cl_demo_app_s_01` )
      ( group = `only non-openui5` header = `gantt` sub = `test` app = `z2ui5_cl_demo_app_076` )
      ( group = `only non-openui5` header = `Harvey Chart` sub = `` app = `z2ui5_cl_demo_app_308` )
      ( group = `only non-openui5` header = `more` sub = `map container` app = `z2ui5_cl_demo_app_123` )
      ( group = `only non-openui5` header = `more` sub = `timeline` app = `z2ui5_cl_demo_app_113` )
      ( group = `only non-openui5` header = `networkgraph` sub = `org tree` app = `z2ui5_cl_demo_app_182` )
      ( group = `only non-openui5` header = `odata, smartmultiinput` sub = `` app = `z2ui5_cl_demo_app_319` )
      ( group = `only non-openui5` header = `status indicator` sub = `` app = `z2ui5_cl_demo_app_196` )
      ( group = `only non-openui5` header = `tab` sub = `smart controls` app = `z2ui5_cl_demo_app_313` )
      ( group = `only non-openui5` header = `tab` sub = `toolbar container sort` app = `z2ui5_cl_demo_app_177` )
      ( group = `only non-openui5` header = `ui table` sub = `` app = `z2ui5_cl_demo_app_100` )
      ( group = `only non-openui5` header = `visualization` sub = `bar chart` app = `z2ui5_cl_demo_app_016` )
      ( group = `only non-openui5` header = `visualization` sub = `donut chart` app = `z2ui5_cl_demo_app_013` )
      ( group = `only non-openui5` header = `visualization` sub = `line chart` app = `z2ui5_cl_demo_app_014` )
      ( group = `only non-openui5` header = `visualization` sub = `process flow` app = `z2ui5_cl_demo_app_091` )
      ( group = `only non-openui5` header = `visualization` sub = `radial chart` app = `z2ui5_cl_demo_app_029` )
      ( group = `only non-openui5` header = `VizFrame Charts` sub = `` app = `z2ui5_cl_demo_app_312` )
      ( group = `only with launchpad` header = `launchpad I` sub = `Startup Parameters` app = `z2ui5_cl_demo_app_lp_01` )
      ( group = `only with launchpad` header = `launchpad II` sub = `Set Title` app = `z2ui5_cl_demo_app_lp_02` )
      ( group = `only with launchpad` header = `Launchpad III` sub = `cross app navigation I` app = `z2ui5_cl_demo_app_lp_03` )
      ( group = `only with launchpad` header = `Launchpad IV` sub = `cross app navigation II` app = `z2ui5_cl_demo_app_lp_04` )
      ( group = `only higher UI5 1.71` header = `Avatar Group (since 1.73)` sub = `` app = `z2ui5_cl_demo_app_320` )
      ( group = `only higher UI5 1.71` header = `control` sub = `Badge (since 1.80)` app = `z2ui5_cl_demo_app_063` )
      ( group = `only higher UI5 1.71` header = `Expandable Text (since 1.87)` sub = `` app = `z2ui5_cl_demo_app_301` )
      ( group = `only higher UI5 1.71` header = `messages` sub = `illustrated (since 1.98)` app = `z2ui5_cl_demo_app_033` )
      ( group = `only higher UI5 1.71` header = `more` sub = `ndc scanner (since 1.102)` app = `z2ui5_cl_demo_app_124` )
      ( group = `only higher UI5 1.71` header = `Side Panel (since 1.107)` sub = `` app = `z2ui5_cl_demo_app_108` )
      ( group = `only higher UI5 1.71` header = `Standard List Item` sub = `Info State Inverted (since 1.74)` app = `z2ui5_cl_demo_app_286` )
      ( group = `only higher UI5 1.71` header = `table columnmenu (since 1.110)` sub = `` app = `z2ui5_cl_demo_app_183` )
      ( group = `only with javascript and css and html` header = `Cell Coloring` sub = `` app = `z2ui5_cl_demo_app_305` )
      ( group = `only with javascript and css and html` header = `Change CSS` sub = `Send your own CSS to the frontend` app = `z2ui5_cl_demo_app_050` )
      ( group = `only with javascript and css and html` header = `custom function in popup` sub = `` app = `z2ui5_cl_demo_app_141` )
      ( group = `only with javascript and css and html` header = `Download CSV` sub = `Export Table as CSV` app = `z2ui5_cl_demo_app_057` )
      ( group = `only with javascript and css and html` header = `ext` sub = `call custom function` app = `z2ui5_cl_demo_app_093` )
      ( group = `only with javascript and css and html` header = `extension` sub = `canvas and svg` app = `z2ui5_cl_demo_app_036` )
      ( group = `only with javascript and css and html` header = `extension` sub = `custom control` app = `z2ui5_cl_demo_app_037` )
      ( group = `only with javascript and css and html` header = `extension` sub = `ext library` app = `z2ui5_cl_demo_app_040` )
      ( group = `only with javascript and css and html` header = `extension` sub = `html css js` app = `z2ui5_cl_demo_app_032` )
      ( group = `only with javascript and css and html` header = `File Download` sub = `Download files to the Frontend` app = `z2ui5_cl_demo_app_186` )
      ( group = `only with javascript and css and html` header = `Fix Flex` sub = `Fix container size` app = `z2ui5_cl_demo_app_256` )
      ( group = `only with javascript and css and html` header = `Flex Box` sub = `Equal Height Cols` app = `z2ui5_cl_demo_app_253` )
      ( group = `only with javascript and css and html` header = `Flex Box` sub = `Navigation Examples` app = `z2ui5_cl_demo_app_255` )
      ( group = `only with javascript and css and html` header = `Flex Box` sub = `Nested` app = `z2ui5_cl_demo_app_254` )
      ( group = `only with javascript and css and html` header = `Flex Box` sub = `Size Adjustments` app = `z2ui5_cl_demo_app_244` )
      ( group = `only with javascript and css and html` header = `follow_up_action with JS` sub = `` app = `z2ui5_cl_demo_app_309` )
      ( group = `only with javascript and css and html` header = `follow_up_action with JS` sub = `` app = `z2ui5_cl_demo_app_309_0` )
      ( group = `only with javascript and css and html` header = `Icon` sub = `` app = `z2ui5_cl_demo_app_268` )
      ( group = `only with javascript and css and html` header = `Message Box & Input Functions` sub = `` app = `z2ui5_cl_demo_app_084` )
      ( group = `only with javascript and css and html` header = `Messages with Styles I` sub = `` app = `z2ui5_cl_demo_app_310` )
      ( group = `only with javascript and css and html` header = `Messages with Styles II` sub = `` app = `z2ui5_cl_demo_app_311` )
      ( group = `only with javascript and css and html` header = `PDF Viewer` sub = `Display PDFs via iframe` app = `z2ui5_cl_demo_app_079` )
      ( group = `only with javascript and css and html` header = `popups` sub = `p13n Dialog` app = `z2ui5_cl_demo_app_090` )
      ( group = `only with javascript and css and html` header = `selscreen` sub = `filter bar with variant managment WIP` app = `z2ui5_cl_demo_app_111` )
      ( group = `only with javascript and css and html` header = `Softkeyboard on/off` sub = `` app = `z2ui5_cl_demo_app_352_0` )
      ( group = `only with javascript and css and html` header = `tab` sub = `focus edit controls` app = `z2ui5_cl_demo_app_346` )
      ( group = `only with javascript and css and html` header = `Tile` sub = `KPI Tile` app = `z2ui5_cl_demo_app_277` )
      ( group = `only with javascript and css and html` header = `tree` sub = `drag & drop` app = `z2ui5_cl_demo_app_317` )
      ( group = `only with javascript and css and html` header = `tree` sub = `popup select - state` app = `z2ui5_cl_demo_app_178` )
      ( group = `only with javascript and css and html` header = `tree table` sub = `save expand state` app = `z2ui5_cl_demo_app_116` )
      ( group = `only with javascript and css and html` header = `ui` sub = `suggestion` app = `z2ui5_cl_demo_app_060` )
      ( group = `only with javascript and css and html` header = `ui` sub = `suggestion with CC filtering` app = `z2ui5_cl_demo_app_201` )
      ( group = `only with javascript and css and html` header = `ui table` sub = `focus handling` app = `z2ui5_cl_demo_app_172` )
      ( group = `only with javascript and css and html` header = `wizard` sub = `nextStep & subsequentSteps` app = `z2ui5_cl_demo_app_202_0` )
      ( group = `only testing` header = `App in App` sub = `Main App` app = `z2ui5_cl_demo_app_338` )
      ( group = `only testing` header = `basic` sub = `popups and flow` app = `z2ui5_cl_demo_app_341` )
      ( group = `only testing` header = `basic` sub = `popups with ref from prev App` app = `z2ui5_cl_demo_app_328` )
      ( group = `only testing` header = `Catch exceptions and display popup` sub = `` app = `z2ui5_cl_demo_app_324` )
      ( group = `only testing` header = `Check throw error when ref used for binding` sub = `` app = `z2ui5_cl_demo_app_343` )
      ( group = `only testing` header = `data binding tables with invalid date and time` sub = `` app = `z2ui5_cl_demo_app_118` )
      ( group = `only testing` header = `Deep Structure Main App` sub = `` app = `z2ui5_cl_demo_app_195` )
      ( group = `only testing` header = `Deep Structure Sub App` sub = `` app = `z2ui5_cl_demo_app_191` )
      ( group = `only testing` header = `RTTI` sub = `Struc` app = `z2ui5_cl_demo_app_331` )
      ( group = `only testing` header = `RTTI` sub = `Struc with Cell Binding` app = `z2ui5_cl_demo_app_332` )
      ( group = `only testing` header = `RTTI` sub = `Struc with Class Data` app = `z2ui5_cl_demo_app_334` )
      ( group = `only testing` header = `RTTI` sub = `Struc with Class Data and Popup` app = `z2ui5_cl_demo_app_335` )
      ( group = `only testing` header = `RTTI` sub = `Struc with Ref in Object` app = `z2ui5_cl_demo_app_348` )
      ( group = `only testing` header = `RTTI` sub = `Table with Class Data and Popup` app = `z2ui5_cl_demo_app_337` )
      ( group = `only testing` header = `RTTI` sub = `Table with Class Data and Popup` app = `z2ui5_cl_demo_app_349` )
      ( group = `only testing` header = `RTTI` sub = `Table with Ref in Object` app = `z2ui5_cl_demo_app_347` )
      ( group = `only testing` header = `RTTI` sub = `with many Layouts` app = `z2ui5_cl_demo_app_344` )
      ( group = `only testing` header = `RTTI` sub = `with many Layouts` app = `z2ui5_cl_demo_app_345` )
      ( group = `only testing` header = `test` sub = `documentation` app = `z2ui5_cl_demo_app_043` )
      ( group = `only testing` header = `test` sub = `speed` app = `z2ui5_cl_demo_app_082` )
      ( group = `only testing` header = `Type Ref to Data Table with refresh` sub = `` app = `z2ui5_cl_demo_app_199` )
      ( group = `only testing` header = `unit test` sub = `long variable` app = `z2ui5_cl_demo_app_138` )
      ( group = `experimental` header = `gantt II` sub = `` app = `z2ui5_cl_demo_app_179` )
      ( group = `experimental` header = `History` sub = `` app = `z2ui5_cl_demo_app_139` )
      ( group = `experimental` header = `Multiple Timers` sub = `` app = `z2ui5_cl_demo_app_353` )
      ( group = `experimental` header = `Navigation` sub = `app state` app = `z2ui5_cl_demo_app_321` )
      ( group = `experimental` header = `Navigation` sub = `app state share` app = `z2ui5_cl_demo_app_323` )
      ( group = `experimental` header = `Navigation` sub = `push state` app = `z2ui5_cl_demo_app_322` )
      ( group = `experimental` header = `Storage` sub = `Store data inside localStorage or sessionStorage` app = `z2ui5_cl_demo_app_327` )
      ( group = `experimental` header = `tab` sub = `different odata models` app = `z2ui5_cl_demo_app_315` )
      ( group = `experimental` header = `tab` sub = `odata, device, http` app = `z2ui5_cl_demo_app_314` )
      ( group = `experimental` header = `UploadSet` sub = `` app = `z2ui5_cl_demo_app_354` )
      ( group = `demos` header = `Sample App` sub = `` app = `z2ui5_cl_demo_app_085` )
      ( group = `demos` header = `Selection Screen` sub = `Explore Input Controls` app = `z2ui5_cl_demo_app_002` )
      ( group = `generic xml view` header = `more` sub = `InputListItem Sample` app = `z2ui5_cl_demo_app_355` )
      ( group = `only non-openui5-with-cc` header = `cc` sub = `geoloaction` app = `z2ui5_cl_demo_app_120` )
      ( group = `uncategorized` header = `App Calling App with REF` sub = `` app = `z2ui5_cl_demo_app_192` )
      ( group = `uncategorized` header = `App in App` sub = `Popup` app = `z2ui5_cl_demo_app_340` )
      ( group = `uncategorized` header = `App in App` sub = `Subapp` app = `z2ui5_cl_demo_app_339` )
      ( group = `uncategorized` header = `App in App` sub = `Subapp` app = `z2ui5_cl_demo_app_342` )
      ( group = `uncategorized` header = `App in App I` sub = `` app = `z2ui5_cl_demo_app_211` )
      ( group = `uncategorized` header = `App in App II` sub = `` app = `z2ui5_cl_demo_app_212` )
      ( group = `uncategorized` header = `basic` sub = `multi combo box` app = `z2ui5_cl_demo_app_140` )
      ( group = `uncategorized` header = `binding` sub = `` app = `z2ui5_cl_demo_app_153` )
      ( group = `uncategorized` header = `binding` sub = `normal, deep, refs` app = `z2ui5_cl_demo_app_094` )
      ( group = `uncategorized` header = `binding` sub = `subapp main` app = `z2ui5_cl_demo_app_095` )
      ( group = `uncategorized` header = `binding` sub = `subapp sub` app = `z2ui5_cl_demo_app_096` )
      ( group = `uncategorized` header = `cc` sub = `timer` app = `z2ui5_cl_demo_app_121` )
      ( group = `uncategorized` header = `data container` sub = `` app = `z2ui5_cl_demo_app_193` )
      ( group = `uncategorized` header = `Data Object for Sample 328` sub = `` app = `z2ui5_cl_demo_app_329` )
      ( group = `uncategorized` header = `Data Object with Data Ref` sub = `` app = `z2ui5_cl_demo_app_333` )
      ( group = `uncategorized` header = `Deep Structure` sub = `` app = `z2ui5_cl_demo_app_190` )
      ( group = `uncategorized` header = `Deep Structure Sub App` sub = `` app = `z2ui5_cl_demo_app_194` )
      ( group = `uncategorized` header = `demo` sub = `object page` app = `z2ui5_cl_demo_app_042` )
      ( group = `uncategorized` header = `demo` sub = `smallest app` app = `z2ui5_cl_demo_app_044` )
      ( group = `uncategorized` header = `demo` sub = `template` app = `z2ui5_cl_demo_app_018` )
      ( group = `uncategorized` header = `demo 02` sub = `` app = `z2ui5_cl_demo_app_105` )
      ( group = `uncategorized` header = `demo 03` sub = `` app = `z2ui5_cl_demo_app_112` )
      ( group = `uncategorized` header = `extension` sub = `import xml view 2` app = `z2ui5_cl_demo_app_039` )
      ( group = `uncategorized` header = `Import View` sub = `Copy & paste views of the UI5 Documentation` app = `z2ui5_cl_demo_app_031` )
      ( group = `uncategorized` header = `list report` sub = `filter` app = `z2ui5_cl_demo_app_083` )
      ( group = `uncategorized` header = `list report` sub = `layout` app = `z2ui5_cl_demo_app_058` )
      ( group = `uncategorized` header = `list report` sub = `navigation` app = `z2ui5_cl_demo_app_054` )
      ( group = `uncategorized` header = `messages` sub = `t100 bapiret` app = `z2ui5_cl_demo_app_034` )
      ( group = `uncategorized` header = `more` sub = `feed input` app = `z2ui5_cl_demo_app_114` )
      ( group = `uncategorized` header = `more` sub = `html pdf` app = `z2ui5_cl_demo_app_318` )
      ( group = `uncategorized` header = `Navigation with app state change v1` sub = `` app = `z2ui5_cl_demo_app_350` )
      ( group = `uncategorized` header = `popup` sub = `nav container in popup` app = `z2ui5_cl_demo_app_170` )
      ( group = `uncategorized` header = `popup` sub = `popup_to_confirm2` app = `z2ui5_cl_demo_app_171` )
      ( group = `uncategorized` header = `RTTI` sub = `With Data Ref´s` app = `z2ui5_cl_demo_app_336` )
      ( group = `uncategorized` header = `Selectoptions` sub = `` app = `z2ui5_cl_demo_app_130` )
      ( group = `uncategorized` header = `Side Navigation Demo` sub = `` app = `z2ui5_cl_demo_app_258` )
      ( group = `uncategorized` header = `Standard Margins` sub = `Negative Margins` app = `z2ui5_cl_demo_app_243` )
      ( group = `uncategorized` header = `tab` sub = `cell copy` app = `z2ui5_cl_demo_app_087` )
      ( group = `uncategorized` header = `tab` sub = `filter columns` app = `z2ui5_cl_demo_app_045` )
      ( group = `uncategorized` header = `tab` sub = `layout` app = `z2ui5_cl_demo_app_055` )
      ( group = `uncategorized` header = `tab and list change` sub = `` app = `z2ui5_cl_demo_app_046` )
      ( group = `uncategorized` header = `timer and popover` sub = `` app = `z2ui5_cl_demo_app_129` )
      ( group = `uncategorized` header = `tree` sub = `tree and nested views` app = `z2ui5_cl_demo_app_086` )
      ( group = `uncategorized` header = `ui` sub = `model update` app = `z2ui5_cl_demo_app_049` )
      ( group = `uncategorized` header = `ui table with filter` sub = `` app = `z2ui5_cl_demo_app_143` )
      ( group = `uncategorized` header = `view setting dialog` sub = `` app = `z2ui5_cl_demo_app_099` )
      ( group = `framework popups` header = `popup` sub = `cl_demo_output html` app = `z2ui5_cl_demo_app_365` )
      ( group = `framework popups` header = `popup` sub = `popop_get_range_multi` app = `z2ui5_cl_demo_app_162` )
      ( group = `framework popups` header = `popup` sub = `popup table` app = `z2ui5_cl_demo_app_164` )
      ( group = `framework popups` header = `popup` sub = `popup_file_download` app = `z2ui5_cl_demo_app_168` )
      ( group = `framework popups` header = `popup` sub = `popup_file_upload` app = `z2ui5_cl_demo_app_157` )
      ( group = `framework popups` header = `popup` sub = `popup_html` app = `z2ui5_cl_demo_app_149` )
      ( group = `framework popups` header = `popup` sub = `popup_input_value` app = `z2ui5_cl_demo_app_156` )
      ( group = `framework popups` header = `popup` sub = `popup_messages` app = `z2ui5_cl_demo_app_154` )
      ( group = `framework popups` header = `popup` sub = `popup_pdf` app = `z2ui5_cl_demo_app_158` )
      ( group = `framework popups` header = `popup` sub = `popup_pdf` app = `z2ui5_cl_demo_app_159` )
      ( group = `framework popups` header = `popup` sub = `popup_textedit` app = `z2ui5_cl_demo_app_155` )
      ( group = `framework popups` header = `popup` sub = `popup_to_confirm` app = `z2ui5_cl_demo_app_150` )
      ( group = `framework popups` header = `popup` sub = `popup_to_inform` app = `z2ui5_cl_demo_app_151` )
      ( group = `framework popups` header = `popup` sub = `popup_to_select` app = `z2ui5_cl_demo_app_152` )
      ( group = `framework popups` header = `popup` sub = `popup_to_select2` app = `z2ui5_cl_demo_app_174` )
      ( group = `obsolete` header = `landing page` sub = `` app = `z2ui5_cl_demo_app_000` )
      ( group = `obsolete` header = `obsolete` sub = `old focus demo, use Focus custom control` app = `z2ui5_cl_demo_app_133_0` )
      ( group = `obsolete` header = `obsolete` sub = `old focus demo, use Focus custom control` app = `z2ui5_cl_demo_app_189_0` )
      ( group = `obsolete` header = `obsolete` sub = `old scroll demo, use Scrolling custom control` app = `z2ui5_cl_demo_app_134_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded browser-title demo` app = `z2ui5_cl_demo_app_125_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded follow_up_action demo` app = `z2ui5_cl_demo_app_180` )
      ( group = `obsolete` header = `obsolete` sub = `superseded frontend-info demo` app = `z2ui5_cl_demo_app_122_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded launchpad set-title demo` app = `z2ui5_cl_demo_app_lp_02_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded multiple-timers demo` app = `z2ui5_cl_demo_app_353_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded play-sound demo` app = `z2ui5_cl_demo_app_s_03_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded timer demo` app = `z2ui5_cl_demo_app_121_0` )
      ( group = `obsolete` header = `obsolete` sub = `superseded timer/popover demo` app = `z2ui5_cl_demo_app_129_0` )
      ( group = `obsolete` header = `obsolete` sub = `uses CL_GUI_TIMER, use Timer custom control` app = `z2ui5_cl_demo_app_028_0` )
      ( group = `obsolete` header = `obsolete` sub = `uses deprecated sap.f.Avatar, use sap.m.Avatar` app = `z2ui5_cl_demo_app_269` )
      ( group = `obsolete` header = `obsolete` sub = `uses deprecated sap.ui.table.AnalyticalTable` app = `z2ui5_cl_demo_app_284` )
      ( group = `obsolete` header = `obsolete` sub = `uses deprecated sap.ui.table.AnalyticalTable` app = `z2ui5_cl_demo_app_285` ) ).

  ENDMETHOD.


  METHOD header_base.

    result = header.
    SPLIT header AT ` ` INTO TABLE DATA(words).
    DATA(n) = lines( words ).

    IF n > 1 AND words[ n ] IS NOT INITIAL AND words[ n ] CO `IVXLCDM`.

      DELETE words INDEX n.
      result = concat_lines_of(
          table = words
          sep   = ` ` ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.

