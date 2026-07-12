CLASS z2ui5_cl_sample_app_001 DEFINITION PUBLIC.

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
    METHODS class_exists
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS header_base
      IMPORTING
        header        TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_sample_app_001 IMPLEMENTATION.

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
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    IF class_exists( `Z2UI5_CL_SAMPLE_APP_000` ) = abap_true.
      DATA(url_restricted) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_sample_app_000|.
      page->header_content( )->button(
          text  = `Extended Samples`
          icon  = `sap-icon://action`
          press = client->_event_client( val   = client->cs_event-open_new_tab
                                         t_arg = VALUE #( ( url_restricted ) ) ) ).
    ENDIF.

    IF class_exists( `Z2UI5_CL_DEMO_APP_000` ) = abap_true.
      DATA(url) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_demo_app_000|.
      page->message_strip(
          type                = `Warning`
          showicon            = abap_true
          enableformattedtext = abap_true
          class               = `sapUiSmallMarginBottom`
          text                = |This overview is still under construction. Click <a href="{ url }" target="_blank">here</a> to open the classic launchpad overview.| ).
    ENDIF.

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


  METHOD class_exists.

    TRY.
        DATA li_app TYPE REF TO z2ui5_if_app.
        CREATE OBJECT li_app TYPE (name).
        result = xsdbool( li_app IS BOUND ).
      CATCH cx_root.
        result = abap_false.
    ENDTRY.

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( group = `framework - basics` header = `Binding` sub = `Display dynamic created table RTTI` app = `z2ui5_cl_demo_app_061` )
      ( group = `framework - basics` header = `Binding I` sub = `Simple - Send values to the backend` app = `z2ui5_cl_demo_app_001` )
      ( group = `framework - basics` header = `Binding II` sub = `Structure Component Level` app = `z2ui5_cl_demo_app_166` )
      ( group = `framework - basics` header = `Binding III` sub = `Table Cell Level` app = `z2ui5_cl_demo_app_144` )
      ( group = `framework - basics` header = `Binding IV` sub = `Expression Binding` app = `z2ui5_cl_demo_app_027` )
      ( group = `framework - basics` header = `Binding V` sub = `Use of Integer, Decimals, Dates & Time` app = `z2ui5_cl_demo_app_047` )
      ( group = `framework - basics` header = `Binding VII` sub = `Formatting Currencies` app = `z2ui5_cl_demo_app_067` )
      ( group = `framework - basics` header = `Binding VIII` sub = `SetSizeLimit` app = `z2ui5_cl_demo_app_071` )
      ( group = `framework - basics` header = `Event I` sub = `Handle events & change the view` app = `z2ui5_cl_demo_app_004` )
      ( group = `framework - basics` header = `Event III` sub = `Additional Infos with t_args` app = `z2ui5_cl_demo_app_167` )
      ( group = `framework - basics` header = `Event IV` sub = `Facet Filter - T_arg with Objects` app = `z2ui5_cl_demo_app_197` )
      ( group = `framework - basics` header = `Message` sub = `Message Box` app = `z2ui5_cl_demo_app_008` )
      ( group = `framework - basics` header = `Message` sub = `Message Toast` app = `z2ui5_cl_demo_app_187` )
      ( group = `framework - basics` header = `More` sub = `Call and leave to apps` app = `z2ui5_cl_demo_app_024` )
      ( group = `framework - basics` header = `More` sub = `Read Frontend Infos` app = `z2ui5_cl_demo_app_122` )
      ( group = `framework - basics` header = `Nested Views I` sub = `Basic Example` app = `z2ui5_cl_demo_app_065` )
      ( group = `framework - basics` header = `Nested Views II` sub = `Head & Item Table` app = `z2ui5_cl_demo_app_097` )
      ( group = `framework - basics` header = `Nested Views III` sub = `Head & Item Table & Detail` app = `z2ui5_cl_demo_app_098` )
      ( group = `framework - basics` header = `Nested Views IV` sub = `Sub-App` app = `z2ui5_cl_demo_app_104` )
      ( group = `framework - basics` header = `Popover` sub = `Display with Menu` app = `z2ui5_cl_demo_app_163` )
      ( group = `framework - basics` header = `Popover I` sub = `Simple Example` app = `z2ui5_cl_demo_app_026` )
      ( group = `framework - basics` header = `Popover II` sub = `Item Level of Table` app = `z2ui5_cl_demo_app_052` )
      ( group = `framework - basics` header = `Popover III` sub = `List to select in Popover` app = `z2ui5_cl_demo_app_081` )
      ( group = `framework - basics` header = `Popover IV` sub = `with Quick View` app = `z2ui5_cl_demo_app_109` )
      ( group = `framework - basics` header = `Popup I` sub = `Different ways of calling Popups` app = `z2ui5_cl_demo_app_012` )
      ( group = `framework - basics` header = `Popup II` sub = `Create Popup for Value Help` app = `z2ui5_cl_demo_app_009` )
      ( group = `framework - basics` header = `Popup III` sub = `Popup in Popup - Backend Stack Handling` app = `z2ui5_cl_demo_app_161` )
      ( group = `framework - basics` header = `Templating I` sub = `Basic Example` app = `z2ui5_cl_demo_app_173` )
      ( group = `framework - basics` header = `Templating II` sub = `Nested Views` app = `z2ui5_cl_demo_app_176` )
      ( group = `framework - action` header = `Clipboard` sub = `Copy & Paste Text` app = `z2ui5_cl_demo_app_325` )
      ( group = `framework - action` header = `Focus I` sub = `Set Focus in Textfield` app = `z2ui5_cl_demo_app_133` )
      ( group = `framework - action` header = `Focus II` sub = `Jump with the focus` app = `z2ui5_cl_demo_app_189` )
      ( group = `framework - action` header = `Keyboard` sub = `Hide/show Soft Keyboard` app = `z2ui5_cl_demo_app_352` )
      ( group = `framework - action` header = `Scroll I` sub = `Scroll to position` app = `z2ui5_cl_demo_app_362` )
      ( group = `framework - action` header = `Scroll II` sub = `Scroll into view` app = `z2ui5_cl_demo_app_363` )
      ( group = `framework - action` header = `Timer I` sub = `Wait n MS and call again the server` app = `z2ui5_cl_demo_app_028` )
      ( group = `framework - action` header = `Timer II` sub = `Set Loading Indicator while Server Request` app = `z2ui5_cl_demo_app_064` )
      ( group = `framework - action` header = `Title` sub = `Set Title` app = `z2ui5_cl_demo_app_125` )
      ( group = `framework - action` header = `URL I` sub = `New Tab Open an URL in a new tab` app = `z2ui5_cl_demo_app_073` )
      ( group = `framework - action` header = `URL II` sub = `Open Telephon, Email usw` app = `z2ui5_cl_demo_app_316` )
      ( group = `controls - extended` header = `CameraSelector` sub = `` app = `z2ui5_cl_demo_app_306` )
      ( group = `controls - extended` header = `Data loss protection` sub = `` app = `z2ui5_cl_demo_app_279` )
      ( group = `controls - extended` header = `File Uploader I` sub = `` app = `z2ui5_cl_demo_app_074` )
      ( group = `controls - extended` header = `File Uploader II` sub = `` app = `z2ui5_cl_demo_app_075` )
      ( group = `controls - extended` header = `File Uploader III` sub = `` app = `z2ui5_cl_demo_app_136` )
      ( group = `controls - extended` header = `Multi Input` sub = `` app = `z2ui5_cl_demo_app_078` )
      ( group = `controls - extended` header = `Nav Container I` sub = `` app = `z2ui5_cl_demo_app_088` )
      ( group = `controls - extended` header = `Wizard Control I` sub = `` app = `z2ui5_cl_demo_app_175` )
      ( group = `controls - extended` header = `Wizard Control II` sub = `Next step & SubSequentStep` app = `z2ui5_cl_demo_app_202` )
      ( group = `controls` header = `Action List Item` sub = `` app = `z2ui5_cl_demo_app_216` )
      ( group = `controls` header = `Action Sheet` sub = `Choose an Action` app = `z2ui5_cl_demo_app_373` )
      ( group = `controls` header = `Bar` sub = `Page, Toolbar & Bar` app = `z2ui5_cl_demo_app_227` )
      ( group = `controls` header = `Bar` sub = `Toolbar vs Bar vs OverflowToolbar` app = `z2ui5_cl_demo_app_235` )
      ( group = `controls` header = `Breadcrumbs` sub = `sample with current page link` app = `z2ui5_cl_demo_app_292` )
      ( group = `controls` header = `Busy Indicator` sub = `` app = `z2ui5_cl_demo_app_215` )
      ( group = `controls` header = `Button` sub = `` app = `z2ui5_cl_demo_app_259` )
      ( group = `controls` header = `Card` sub = `with Header & Content` app = `z2ui5_cl_demo_app_181` )
      ( group = `controls` header = `Carousel` sub = `Browse through Pages` app = `z2ui5_cl_demo_app_371` )
      ( group = `controls` header = `Checkbox` sub = `` app = `z2ui5_cl_demo_app_239` )
      ( group = `controls` header = `Code Editor` sub = `` app = `z2ui5_cl_demo_app_035` )
      ( group = `controls` header = `Code Editor` sub = `` app = `z2ui5_cl_demo_app_265` )
      ( group = `controls` header = `Color Picker` sub = `` app = `z2ui5_cl_demo_app_270` )
      ( group = `controls` header = `ComboBox` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_229` )
      ( group = `controls` header = `Date Picker` sub = `Value States` app = `z2ui5_cl_demo_app_294` )
      ( group = `controls` header = `Date Range Selection` sub = `` app = `z2ui5_cl_demo_app_231` )
      ( group = `controls` header = `Date Range Selection` sub = `Value States` app = `z2ui5_cl_demo_app_295` )
      ( group = `controls` header = `Date Time Picker` sub = `Value States` app = `z2ui5_cl_demo_app_377` )
      ( group = `controls` header = `Dynamic Page` sub = `Display items` app = `z2ui5_cl_demo_app_030` )
      ( group = `controls` header = `Feed Input` sub = `` app = `z2ui5_cl_demo_app_101` )
      ( group = `controls` header = `Feed Input` sub = `Icon Variants` app = `z2ui5_cl_demo_app_283` )
      ( group = `controls` header = `Flex Box` sub = `Basic Alignment` app = `z2ui5_cl_demo_app_205` )
      ( group = `controls` header = `Flex Box` sub = `Direction & Order` app = `z2ui5_cl_demo_app_245` )
      ( group = `controls` header = `Flex Box` sub = `Opposing Alignment` app = `z2ui5_cl_demo_app_218` )
      ( group = `controls` header = `Flex Box` sub = `Render Type` app = `z2ui5_cl_demo_app_252` )
      ( group = `controls` header = `Flexible Column Layout` sub = `Master details with tree` app = `z2ui5_cl_demo_app_069` )
      ( group = `controls` header = `Formatted Text` sub = `Display HTML` app = `z2ui5_cl_demo_app_015` )
      ( group = `controls` header = `Generic Tag` sub = `Since 1.70` app = `z2ui5_cl_demo_app_062` )
      ( group = `controls` header = `Generic Tag` sub = `with Different Configurations` app = `z2ui5_cl_demo_app_257` )
      ( group = `controls` header = `Grid` sub = `Split View in different Areas` app = `z2ui5_cl_demo_app_367` )
      ( group = `controls` header = `Grid List` sub = `with Drag&Drop` app = `z2ui5_cl_demo_app_307` )
      ( group = `controls` header = `Header Container` sub = `Vertical Mode` app = `z2ui5_cl_demo_app_280` )
      ( group = `controls` header = `HTML` sub = `` app = `z2ui5_cl_demo_app_242` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Filter Table with Counts` app = `z2ui5_cl_demo_app_368` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Icons Only` app = `z2ui5_cl_demo_app_221` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Inline Mode` app = `z2ui5_cl_demo_app_223` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Separator` app = `z2ui5_cl_demo_app_225` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Sub tabs` app = `z2ui5_cl_demo_app_226` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Text and Count` app = `z2ui5_cl_demo_app_222` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Text Only` app = `z2ui5_cl_demo_app_224` )
      ( group = `controls` header = `Icon Tab Header` sub = `Standalone Icon Tab Header` app = `z2ui5_cl_demo_app_214` )
      ( group = `controls` header = `Image` sub = `Sizing & Press Event` app = `z2ui5_cl_demo_app_379` )
      ( group = `controls` header = `InfoLabel` sub = `` app = `z2ui5_cl_demo_app_209` )
      ( group = `controls` header = `Input` sub = `Description` app = `z2ui5_cl_demo_app_251` )
      ( group = `controls` header = `Input` sub = `Password` app = `z2ui5_cl_demo_app_213` )
      ( group = `controls` header = `Input` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_246` )
      ( group = `controls` header = `Input` sub = `Types` app = `z2ui5_cl_demo_app_210` )
      ( group = `controls` header = `Input List Item` sub = `` app = `z2ui5_cl_demo_app_219` )
      ( group = `controls` header = `InvisibleText` sub = `` app = `z2ui5_cl_demo_app_282` )
      ( group = `controls` header = `Label` sub = `` app = `z2ui5_cl_demo_app_051` )
      ( group = `controls` header = `LightBox` sub = `` app = `z2ui5_cl_demo_app_273` )
      ( group = `controls` header = `Link` sub = `` app = `z2ui5_cl_demo_app_293` )
      ( group = `controls` header = `List I` sub = `Basic` app = `z2ui5_cl_demo_app_003` )
      ( group = `controls` header = `List II` sub = `Events & Visualization` app = `z2ui5_cl_demo_app_048` )
      ( group = `controls` header = `Mask Input` sub = `` app = `z2ui5_cl_demo_app_110` )
      ( group = `controls` header = `Menu Button` sub = `Regular & Split Mode` app = `z2ui5_cl_demo_app_372` )
      ( group = `controls` header = `Message Strip` sub = `` app = `z2ui5_cl_demo_app_238` )
      ( group = `controls` header = `Message Strip` sub = `with enableFormattedText` app = `z2ui5_cl_demo_app_291` )
      ( group = `controls` header = `Message View` sub = `Custom Popup, Popover & Output` app = `z2ui5_cl_demo_app_038` )
      ( group = `controls` header = `Multi Combo Box` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_233` )
      ( group = `controls` header = `Multi Input` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_232` )
      ( group = `controls` header = `Multi Input` sub = `Value States` app = `z2ui5_cl_demo_app_267` )
      ( group = `controls` header = `Notification List Item` sub = `Priority & Close Button` app = `z2ui5_cl_demo_app_375` )
      ( group = `controls` header = `Object Attribute` sub = `inside a Table` app = `z2ui5_cl_demo_app_302` )
      ( group = `controls` header = `Object Header` sub = `with Circle-shaped Image` app = `z2ui5_cl_demo_app_272` )
      ( group = `controls` header = `Object Identifier` sub = `inside a Table` app = `z2ui5_cl_demo_app_370` )
      ( group = `controls` header = `Object List Item` sub = `markers aggregation` app = `z2ui5_cl_demo_app_290` )
      ( group = `controls` header = `Object Marker` sub = `inside a Table` app = `z2ui5_cl_demo_app_289` )
      ( group = `controls` header = `Object Number` sub = `inside a Table` app = `z2ui5_cl_demo_app_369` )
      ( group = `controls` header = `Object Page` sub = `with Avatar (since 1.73)` app = `z2ui5_cl_demo_app_017` )
      ( group = `controls` header = `Object Page` sub = `with Hidden Section Titles` app = `z2ui5_cl_demo_app_330` )
      ( group = `controls` header = `Object Page Header` sub = `with Header Container` app = `z2ui5_cl_demo_app_303` )
      ( group = `controls` header = `Object Status` sub = `` app = `z2ui5_cl_demo_app_300` )
      ( group = `controls` header = `Overflow Toolbar` sub = `` app = `z2ui5_cl_demo_app_217` )
      ( group = `controls` header = `Overflow Toolbar` sub = `Alignment` app = `z2ui5_cl_demo_app_250` )
      ( group = `controls` header = `Page` sub = `Header, Sub-Header & Footer` app = `z2ui5_cl_demo_app_366` )
      ( group = `controls` header = `Panel` sub = `Expandable & Header Toolbar` app = `z2ui5_cl_demo_app_378` )
      ( group = `controls` header = `Planning Calendar` sub = `` app = `z2ui5_cl_demo_app_080` )
      ( group = `controls` header = `Progress Indicator` sub = `` app = `z2ui5_cl_demo_app_022` )
      ( group = `controls` header = `Radio Button` sub = `` app = `z2ui5_cl_demo_app_207` )
      ( group = `controls` header = `Radio Button Group` sub = `` app = `z2ui5_cl_demo_app_208` )
      ( group = `controls` header = `Range Slider` sub = `` app = `z2ui5_cl_demo_app_005` )
      ( group = `controls` header = `Rating Indicator` sub = `` app = `z2ui5_cl_demo_app_220` )
      ( group = `controls` header = `Rich Text Editor` sub = `` app = `z2ui5_cl_demo_app_106` )
      ( group = `controls` header = `Search Field` sub = `` app = `z2ui5_cl_demo_app_296` )
      ( group = `controls` header = `Search Field I` sub = `Filter with enter` app = `z2ui5_cl_demo_app_053` )
      ( group = `controls` header = `Search Field II` sub = `Filter with Live Change Event` app = `z2ui5_cl_demo_app_059` )
      ( group = `controls` header = `Segmented Button` sub = `in Input List Item` app = `z2ui5_cl_demo_app_230` )
      ( group = `controls` header = `Select` sub = `` app = `z2ui5_cl_demo_app_288` )
      ( group = `controls` header = `Select` sub = `Validation states` app = `z2ui5_cl_demo_app_298` )
      ( group = `controls` header = `Select` sub = `with icons` app = `z2ui5_cl_demo_app_297` )
      ( group = `controls` header = `Select` sub = `Wrapping text` app = `z2ui5_cl_demo_app_299` )
      ( group = `controls` header = `Slide Tile` sub = `` app = `z2ui5_cl_demo_app_274` )
      ( group = `controls` header = `Slider` sub = `` app = `z2ui5_cl_demo_app_237` )
      ( group = `controls` header = `Split Container` sub = `Master & Detail Pages` app = `z2ui5_cl_demo_app_374` )
      ( group = `controls` header = `Splitter Layout` sub = `2 areas` app = `z2ui5_cl_demo_app_247` )
      ( group = `controls` header = `Splitter Layout` sub = `2 non-resizable areas` app = `z2ui5_cl_demo_app_248` )
      ( group = `controls` header = `Splitter Layout` sub = `3 areas` app = `z2ui5_cl_demo_app_249` )
      ( group = `controls` header = `Splitter Layout` sub = `Nested with 7 Areas` app = `z2ui5_cl_demo_app_260` )
      ( group = `controls` header = `Splitter Layout` sub = `Side Panel` app = `z2ui5_cl_demo_app_103` )
      ( group = `controls` header = `Standard List Item` sub = `Wrapping` app = `z2ui5_cl_demo_app_287` )
      ( group = `controls` header = `Step Input` sub = `` app = `z2ui5_cl_demo_app_041` )
      ( group = `controls` header = `Step Input` sub = `Value States` app = `z2ui5_cl_demo_app_264` )
      ( group = `controls` header = `Switch` sub = `` app = `z2ui5_cl_demo_app_240` )
      ( group = `controls` header = `Tab Container` sub = `Multiple Items` app = `z2ui5_cl_demo_app_380` )
      ( group = `controls` header = `Table` sub = `Selection Modes: Single Select & Multi Select` app = `z2ui5_cl_demo_app_019` )
      ( group = `controls` header = `Table` sub = `Set Columns Editable` app = `z2ui5_cl_demo_app_011` )
      ( group = `controls` header = `Text` sub = `Max Lines` app = `z2ui5_cl_demo_app_206` )
      ( group = `controls` header = `Text Area` sub = `` app = `z2ui5_cl_demo_app_021` )
      ( group = `controls` header = `Text Area` sub = `Growing` app = `z2ui5_cl_demo_app_236` )
      ( group = `controls` header = `Text Area` sub = `Value States` app = `z2ui5_cl_demo_app_234` )
      ( group = `controls` header = `Tile` sub = `Feed and News Tile` app = `z2ui5_cl_demo_app_278` )
      ( group = `controls` header = `Tile` sub = `Feed Content` app = `z2ui5_cl_demo_app_275` )
      ( group = `controls` header = `Tile` sub = `Image Content` app = `z2ui5_cl_demo_app_271` )
      ( group = `controls` header = `Tile` sub = `Monitor Tile` app = `z2ui5_cl_demo_app_276` )
      ( group = `controls` header = `Tile` sub = `News Content` app = `z2ui5_cl_demo_app_261` )
      ( group = `controls` header = `Tile` sub = `Numeric Content of Different Colors` app = `z2ui5_cl_demo_app_262` )
      ( group = `controls` header = `Tile` sub = `Numeric Content with Icon` app = `z2ui5_cl_demo_app_263` )
      ( group = `controls` header = `Tile` sub = `Numeric Content Without Margins` app = `z2ui5_cl_demo_app_228` )
      ( group = `controls` header = `Tile` sub = `Statuses` app = `z2ui5_cl_demo_app_281` )
      ( group = `controls` header = `Tile` sub = `Tile Content` app = `z2ui5_cl_demo_app_241` )
      ( group = `controls` header = `Time Picker` sub = `Formats & Steps` app = `z2ui5_cl_demo_app_376` )
      ( group = `controls` header = `Toggle Button` sub = `` app = `z2ui5_cl_demo_app_266` )
      ( group = `controls` header = `Toolbar` sub = `Add a container & toolbar` app = `z2ui5_cl_demo_app_006` )
      ( group = `controls` header = `Tree Table I` sub = `Popup Select Entry` app = `z2ui5_cl_demo_app_068` )
      ( group = `controls` header = `Tree Table II` sub = `Checkbox Binding per Node` app = `z2ui5_cl_demo_app_364` )
      ( group = `controls` header = `ui.Table I` sub = `Simple example` app = `z2ui5_cl_demo_app_070` )
      ( group = `controls` header = `ui.Table II` sub = `Events on Cell Level` app = `z2ui5_cl_demo_app_160` ) ).

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
