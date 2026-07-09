CLASS z2ui5_cl_sample_000 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tile,
        group   TYPE string,
        section TYPE string,
        header  TYPE string,
        sub     TYPE string,
        app     TYPE string,
      END OF ty_s_tile.
    TYPES ty_t_tile TYPE STANDARD TABLE OF ty_s_tile WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_tile.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_sample_000 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_event( ).

      TRY.
          DATA(classname) = to_upper( client->get( )-event ).
          DATA li_app TYPE REF TO z2ui5_if_app.
          CREATE OBJECT li_app TYPE (classname).
          client->nav_app_call( li_app ).
        CATCH cx_root ##NO_HANDLER.
      ENDTRY.

    ELSE.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->formatted_text( `<p><strong>Explore and copy code samples!</strong> This overview lists only the plain, universally-runnable ` &&
                          `samples from the <em>root</em> package, grouped into framework capabilities and pure control demos.</p>` ).

    DATA(prev_group)   = ``.
    DATA(prev_section) = ``.
    DATA group_panel   TYPE REF TO z2ui5_cl_xml_view.
    DATA section_panel TYPE REF TO z2ui5_cl_xml_view.
    DATA target        TYPE REF TO z2ui5_cl_xml_view.

    LOOP AT get_catalog( ) INTO DATA(tile).

      IF tile-group <> prev_group.

        group_panel = page->panel(
            expandable = abap_true
            expanded   = abap_true
            headertext = tile-group ).
        prev_group   = tile-group.
        prev_section = ``.

      ENDIF.

      IF tile-section IS INITIAL.
        target = group_panel.

      ELSE.

        IF tile-section <> prev_section.

          section_panel = group_panel->panel(
              expandable = abap_false
              expanded   = abap_true
              headertext = tile-section ).
          prev_section = tile-section.

        ENDIF.
        target = section_panel.

      ENDIF.

      target->generic_tile(
          header    = tile-header
          subheader = tile-sub
          press     = client->_event( tile-app )
          mode      = `LineMode`
          class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( group = `Framework` section = `Data Binding Logic` header = `Binding I` sub = `Simple - Send values to the backend` app = `z2ui5_cl_demo_app_001` )
      ( group = `Framework` section = `Data Binding Logic` header = `Expression Binding` sub = `Use calculations & more functions directly in views` app = `z2ui5_cl_demo_app_027` )
      ( group = `Framework` section = `Data Binding Logic` header = `Data Types` sub = `Use of Integer, Decimals, Dates & Time` app = `z2ui5_cl_demo_app_047` )
      ( group = `Framework` section = `Data Binding Logic` header = `Dynamic Types` sub = `Use S-RTTI to send tables to the frontend` app = `z2ui5_cl_demo_app_061` )
      ( group = `Framework` section = `Data Binding Logic` header = `Formatting` sub = `Currencies` app = `z2ui5_cl_demo_app_067` )
      ( group = `Framework` section = `Data Binding Logic` header = `setSizeLimit` sub = `` app = `z2ui5_cl_demo_app_071` )
      ( group = `Framework` section = `Data Binding Logic` header = `Dynamic Objects II` sub = `User Generic Data Refs in Subapps` app = `z2ui5_cl_demo_app_117` )
      ( group = `Framework` section = `Data Binding Logic` header = `Dynamic Objects I` sub = `Use S-RTTI to render different Subapps` app = `z2ui5_cl_demo_app_131` )
      ( group = `Framework` section = `Data Binding Logic` header = `Binding III` sub = `Table Cell Level` app = `z2ui5_cl_demo_app_144` )
      ( group = `Framework` section = `Data Binding Logic` header = `Binding II` sub = `Structure Component Level` app = `z2ui5_cl_demo_app_166` )
      ( group = `Framework` section = `Data Binding Logic` header = `Dynamic Objects III` sub = `User Generic Data Refs in Subapps` app = `z2ui5_cl_demo_app_185` )
      ( group = `Framework` section = `Events` header = `Event I` sub = `Handle events & change the view` app = `z2ui5_cl_demo_app_004` )
      ( group = `Framework` section = `Events` header = `Event II` sub = `Call other apps & exchange data` app = `z2ui5_cl_demo_app_024` )
      ( group = `Framework` section = `Events` header = `Event III` sub = `Additional Infos with t_args` app = `z2ui5_cl_demo_app_167` )
      ( group = `Framework` section = `Events` header = `Event IV` sub = `Facet Filter - T_arg with Objects` app = `z2ui5_cl_demo_app_197` )
      ( group = `Framework` section = `Popups Logic` header = `F4-Value-Help` sub = `Popup for value help` app = `z2ui5_cl_demo_app_009` )
      ( group = `Framework` section = `Popups Logic` header = `Flow Logic` sub = `Different ways of calling Popups` app = `z2ui5_cl_demo_app_012` )
      ( group = `Framework` section = `Popups Logic` header = `Popover` sub = `Simple Example` app = `z2ui5_cl_demo_app_026` )
      ( group = `Framework` section = `Popups Logic` header = `Message View` sub = `Custom Popup, Popover & Output` app = `z2ui5_cl_demo_app_038` )
      ( group = `Framework` section = `Popups Logic` header = `Popover Item Level` sub = `Create a Popover for a specific entry of a table` app = `z2ui5_cl_demo_app_052` )
      ( group = `Framework` section = `Popups Logic` header = `Popover with List` sub = `List to select in Popover` app = `z2ui5_cl_demo_app_081` )
      ( group = `Framework` section = `Popups Logic` header = `Popover with Quick View` sub = `` app = `z2ui5_cl_demo_app_109` )
      ( group = `Framework` section = `Popups Logic` header = `Call Popup in Popup` sub = `Backend Popup Stack Handling` app = `z2ui5_cl_demo_app_161` )
      ( group = `Framework` section = `Popups Logic` header = `Popover with Menu` sub = `` app = `z2ui5_cl_demo_app_163` )
      ( group = `Framework` section = `Popups Logic` header = `Message Box` sub = `sy, bapiret, cx_root` app = `z2ui5_cl_demo_app_187` )
      ( group = `Framework` section = `Messages` header = `Basic` sub = `Toast, Box & Strip` app = `z2ui5_cl_demo_app_008` )
      ( group = `Framework` section = `Messages` header = `Messages with Styles I` sub = `` app = `z2ui5_cl_demo_app_310` )
      ( group = `Framework` section = `Messages` header = `Messages with Styles II` sub = `` app = `z2ui5_cl_demo_app_311` )
      ( group = `Framework` section = `Frontend Action` header = `Timer I` sub = `Wait n MS and call again the server` app = `z2ui5_cl_demo_app_028` )
      ( group = `Framework` section = `Frontend Action` header = `Change CSS` sub = `Send your own CSS to the frontend` app = `z2ui5_cl_demo_app_050` )
      ( group = `Framework` section = `Frontend Action` header = `Download CSV` sub = `Export Table as CSV` app = `z2ui5_cl_demo_app_057` )
      ( group = `Framework` section = `Frontend Action` header = `Timer II` sub = `Set Loading Indicator while Server Request` app = `z2ui5_cl_demo_app_064` )
      ( group = `Framework` section = `Frontend Action` header = `New Tab` sub = `Open an URL in a new tab` app = `z2ui5_cl_demo_app_073` )
      ( group = `Framework` section = `Frontend Action` header = `PDF Viewer` sub = `Display PDFs via iframe` app = `z2ui5_cl_demo_app_079` )
      ( group = `Framework` section = `Frontend Action` header = `Frontend Infos` sub = `` app = `z2ui5_cl_demo_app_122` )
      ( group = `Framework` section = `Frontend Action` header = `Tab Title` sub = `` app = `z2ui5_cl_demo_app_125` )
      ( group = `Framework` section = `Frontend Action` header = `Focus I` sub = `` app = `z2ui5_cl_demo_app_133` )
      ( group = `Framework` section = `Frontend Action` header = `File Download` sub = `Download files to the Frontend` app = `z2ui5_cl_demo_app_186` )
      ( group = `Framework` section = `Frontend Action` header = `Focus II` sub = `` app = `z2ui5_cl_demo_app_189` )
      ( group = `Framework` section = `Frontend Action` header = `URL Helper` sub = `Trigger a phone's native apps like Email, Telephone and SMS` app = `z2ui5_cl_demo_app_316` )
      ( group = `Framework` section = `Frontend Action` header = `Clipboard` sub = `Copy & Paste Text` app = `z2ui5_cl_demo_app_325` )
      ( group = `Framework` section = `Frontend Action` header = `Hide/show Soft Keyboard` sub = `` app = `z2ui5_cl_demo_app_352` )
      ( group = `Framework` section = `Frontend Action` header = `Scroll to position` sub = `client->action->gen( SCROLL_TO )` app = `z2ui5_cl_demo_app_362` )
      ( group = `Framework` section = `Frontend Action` header = `Scroll into view` sub = `client->action->gen( SCROLL_INTO_VIEW )` app = `z2ui5_cl_demo_app_363` )
      ( group = `Controls` section = `` header = `Action List Item` sub = `` app = `z2ui5_cl_demo_app_216` )
      ( group = `Controls` section = `` header = `Bar` sub = `Page, Toolbar & Bar` app = `z2ui5_cl_demo_app_227` )
      ( group = `Controls` section = `` header = `Bar` sub = `Toolbar vs Bar vs OverflowToolbar` app = `z2ui5_cl_demo_app_235` )
      ( group = `Controls` section = `` header = `Breadcrumbs` sub = `sample with current page link` app = `z2ui5_cl_demo_app_292` )
      ( group = `Controls` section = `` header = `Busy Indicator` sub = `` app = `z2ui5_cl_demo_app_215` )
      ( group = `Controls` section = `` header = `Button` sub = `` app = `z2ui5_cl_demo_app_259` )
      ( group = `Controls` section = `` header = `Cards` sub = `` app = `z2ui5_cl_demo_app_181` )
      ( group = `Controls` section = `` header = `Cell Coloring` sub = `` app = `z2ui5_cl_demo_app_305` )
      ( group = `Controls` section = `` header = `Checkbox` sub = `` app = `z2ui5_cl_demo_app_239` )
      ( group = `Controls` section = `` header = `Code Editor` sub = `` app = `z2ui5_cl_demo_app_035` )
      ( group = `Controls` section = `` header = `Code Editor` sub = `` app = `z2ui5_cl_demo_app_265` )
      ( group = `Controls` section = `` header = `Color Picker` sub = `` app = `z2ui5_cl_demo_app_270` )
      ( group = `Controls` section = `` header = `ComboBox` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_229` )
      ( group = `Controls` section = `` header = `Date Picker` sub = `Value States` app = `z2ui5_cl_demo_app_294` )
      ( group = `Controls` section = `` header = `Date Range Selection` sub = `` app = `z2ui5_cl_demo_app_231` )
      ( group = `Controls` section = `` header = `Date Range Selection` sub = `Value States` app = `z2ui5_cl_demo_app_295` )
      ( group = `Controls` section = `` header = `Dynamic Page` sub = `Display items` app = `z2ui5_cl_demo_app_030` )
      ( group = `Controls` section = `` header = `Editable` sub = `Set columns editable` app = `z2ui5_cl_demo_app_011` )
      ( group = `Controls` section = `` header = `Feed Input` sub = `` app = `z2ui5_cl_demo_app_101` )
      ( group = `Controls` section = `` header = `Feed Input 2` sub = `` app = `z2ui5_cl_demo_app_283` )
      ( group = `Controls` section = `` header = `Fix Flex` sub = `Fix container size` app = `z2ui5_cl_demo_app_256` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Basic Alignment` app = `z2ui5_cl_demo_app_205` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Opposing Alignment` app = `z2ui5_cl_demo_app_218` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Size Adjustments` app = `z2ui5_cl_demo_app_244` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Direction & Order` app = `z2ui5_cl_demo_app_245` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Render Type` app = `z2ui5_cl_demo_app_252` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Equal Height Cols` app = `z2ui5_cl_demo_app_253` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Nested` app = `z2ui5_cl_demo_app_254` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Navigation Examples` app = `z2ui5_cl_demo_app_255` )
      ( group = `Controls` section = `` header = `Flexible Column Layout` sub = `Master details with tree` app = `z2ui5_cl_demo_app_069` )
      ( group = `Controls` section = `` header = `Formatted Text` sub = `Display HTML` app = `z2ui5_cl_demo_app_015` )
      ( group = `Controls` section = `` header = `Generic Tag` sub = `Since 1.70` app = `z2ui5_cl_demo_app_062` )
      ( group = `Controls` section = `` header = `Generic Tag with Different Configurations` sub = `` app = `z2ui5_cl_demo_app_257` )
      ( group = `Controls` section = `` header = `Grid List` sub = `with Drag&Drop` app = `z2ui5_cl_demo_app_307` )
      ( group = `Controls` section = `` header = `Header Container` sub = `Vertical Mode` app = `z2ui5_cl_demo_app_280` )
      ( group = `Controls` section = `` header = `Header, Footer, Grid` sub = `Split view in different areas` app = `z2ui5_cl_demo_app_010` )
      ( group = `Controls` section = `` header = `HTML` sub = `` app = `z2ui5_cl_demo_app_242` )
      ( group = `Controls` section = `` header = `Icon` sub = `` app = `z2ui5_cl_demo_app_268` )
      ( group = `Controls` section = `` header = `Icon Tab Bar` sub = `Icons Only` app = `z2ui5_cl_demo_app_221` )
      ( group = `Controls` section = `` header = `Icon Tab Bar` sub = `Text and Count` app = `z2ui5_cl_demo_app_222` )
      ( group = `Controls` section = `` header = `Icon Tab Bar` sub = `Inline Mode` app = `z2ui5_cl_demo_app_223` )
      ( group = `Controls` section = `` header = `Icon Tab Bar` sub = `Text Only` app = `z2ui5_cl_demo_app_224` )
      ( group = `Controls` section = `` header = `Icon Tab Bar` sub = `Separator` app = `z2ui5_cl_demo_app_225` )
      ( group = `Controls` section = `` header = `Icon Tab Bar` sub = `Sub tabs` app = `z2ui5_cl_demo_app_226` )
      ( group = `Controls` section = `` header = `Icon Tab Header` sub = `Standalone Icon Tab Header` app = `z2ui5_cl_demo_app_214` )
      ( group = `Controls` section = `` header = `Import View` sub = `Copy & paste views of the UI5 Documentation` app = `z2ui5_cl_demo_app_031` )
      ( group = `Controls` section = `` header = `InfoLabel` sub = `` app = `z2ui5_cl_demo_app_209` )
      ( group = `Controls` section = `` header = `Input` sub = `Types` app = `z2ui5_cl_demo_app_210` )
      ( group = `Controls` section = `` header = `Input` sub = `Password` app = `z2ui5_cl_demo_app_213` )
      ( group = `Controls` section = `` header = `Input` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_246` )
      ( group = `Controls` section = `` header = `Input` sub = `Description` app = `z2ui5_cl_demo_app_251` )
      ( group = `Controls` section = `` header = `Input List Item` sub = `` app = `z2ui5_cl_demo_app_219` )
      ( group = `Controls` section = `` header = `InvisibleText` sub = `` app = `z2ui5_cl_demo_app_282` )
      ( group = `Controls` section = `` header = `Label` sub = `` app = `z2ui5_cl_demo_app_051` )
      ( group = `Controls` section = `` header = `LightBox` sub = `` app = `z2ui5_cl_demo_app_273` )
      ( group = `Controls` section = `` header = `Link` sub = `` app = `z2ui5_cl_demo_app_293` )
      ( group = `Controls` section = `` header = `List I` sub = `Basic` app = `z2ui5_cl_demo_app_003` )
      ( group = `Controls` section = `` header = `List II` sub = `Events & Visualization` app = `z2ui5_cl_demo_app_048` )
      ( group = `Controls` section = `` header = `Mask Input` sub = `` app = `z2ui5_cl_demo_app_110` )
      ( group = `Controls` section = `` header = `Message Strip` sub = `` app = `z2ui5_cl_demo_app_238` )
      ( group = `Controls` section = `` header = `Message Strip` sub = `with enableFormattedText` app = `z2ui5_cl_demo_app_291` )
      ( group = `Controls` section = `` header = `Multi Combo Box` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_233` )
      ( group = `Controls` section = `` header = `Multi Input` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_232` )
      ( group = `Controls` section = `` header = `Multi Input` sub = `Value States` app = `z2ui5_cl_demo_app_267` )
      ( group = `Controls` section = `` header = `Nav Container I` sub = `` app = `z2ui5_cl_demo_app_088` )
      ( group = `Controls` section = `` header = `Nested Splitter Layouts` sub = `7 Areas` app = `z2ui5_cl_demo_app_260` )
      ( group = `Controls` section = `` header = `Nested Views I` sub = `Basic Example` app = `z2ui5_cl_demo_app_065` )
      ( group = `Controls` section = `` header = `Nested Views II` sub = `Head & Item Table` app = `z2ui5_cl_demo_app_097` )
      ( group = `Controls` section = `` header = `Nested Views III` sub = `Head & Item Table & Detail` app = `z2ui5_cl_demo_app_098` )
      ( group = `Controls` section = `` header = `Nested Views IV` sub = `Sub-App` app = `z2ui5_cl_demo_app_104` )
      ( group = `Controls` section = `` header = `Object Attribute inside Table` sub = `` app = `z2ui5_cl_demo_app_302` )
      ( group = `Controls` section = `` header = `Object Header` sub = `with Circle-shaped Image` app = `z2ui5_cl_demo_app_272` )
      ( group = `Controls` section = `` header = `Object List Item` sub = `markers aggregation` app = `z2ui5_cl_demo_app_290` )
      ( group = `Controls` section = `` header = `Object Marker in a table` sub = `` app = `z2ui5_cl_demo_app_289` )
      ( group = `Controls` section = `` header = `Object Page Header` sub = `with Header Container` app = `z2ui5_cl_demo_app_303` )
      ( group = `Controls` section = `` header = `Object Page with Avatar` sub = `Since 1.73` app = `z2ui5_cl_demo_app_017` )
      ( group = `Controls` section = `` header = `Object Status` sub = `` app = `z2ui5_cl_demo_app_300` )
      ( group = `Controls` section = `` header = `ObjectPage` sub = `with Hidden Section Titles` app = `z2ui5_cl_demo_app_330` )
      ( group = `Controls` section = `` header = `Overflow Toolbar` sub = `Placing a Title in OverflowToolbar/Toolbar` app = `z2ui5_cl_demo_app_217` )
      ( group = `Controls` section = `` header = `OverflowToolbar` sub = `Alignment` app = `z2ui5_cl_demo_app_250` )
      ( group = `Controls` section = `` header = `Planning Calendar` sub = `` app = `z2ui5_cl_demo_app_080` )
      ( group = `Controls` section = `` header = `Progress Indicator` sub = `` app = `z2ui5_cl_demo_app_022` )
      ( group = `Controls` section = `` header = `Radio Button` sub = `` app = `z2ui5_cl_demo_app_207` )
      ( group = `Controls` section = `` header = `Radio Button Group` sub = `` app = `z2ui5_cl_demo_app_208` )
      ( group = `Controls` section = `` header = `Range Slider` sub = `` app = `z2ui5_cl_demo_app_005` )
      ( group = `Controls` section = `` header = `Rating Indicator` sub = `` app = `z2ui5_cl_demo_app_220` )
      ( group = `Controls` section = `` header = `Rich Text Editor` sub = `` app = `z2ui5_cl_demo_app_106` )
      ( group = `Controls` section = `` header = `Search Field` sub = `` app = `z2ui5_cl_demo_app_296` )
      ( group = `Controls` section = `` header = `Search Field I` sub = `Filter with enter` app = `z2ui5_cl_demo_app_053` )
      ( group = `Controls` section = `` header = `Search Field II` sub = `Filter with Live Change Event` app = `z2ui5_cl_demo_app_059` )
      ( group = `Controls` section = `` header = `Segmented Button in Input List Item` sub = `` app = `z2ui5_cl_demo_app_230` )
      ( group = `Controls` section = `` header = `Select` sub = `` app = `z2ui5_cl_demo_app_288` )
      ( group = `Controls` section = `` header = `Select` sub = `with icons` app = `z2ui5_cl_demo_app_297` )
      ( group = `Controls` section = `` header = `Select` sub = `Validation states` app = `z2ui5_cl_demo_app_298` )
      ( group = `Controls` section = `` header = `Select` sub = `Wrapping text` app = `z2ui5_cl_demo_app_299` )
      ( group = `Controls` section = `` header = `Selection Modes` sub = `Single Select & Multi Select` app = `z2ui5_cl_demo_app_019` )
      ( group = `Controls` section = `` header = `Slide Tile` sub = `` app = `z2ui5_cl_demo_app_274` )
      ( group = `Controls` section = `` header = `Slider` sub = `` app = `z2ui5_cl_demo_app_237` )
      ( group = `Controls` section = `` header = `Splitter Layout` sub = `2 areas` app = `z2ui5_cl_demo_app_247` )
      ( group = `Controls` section = `` header = `Splitter Layout` sub = `2 non-resizable areas` app = `z2ui5_cl_demo_app_248` )
      ( group = `Controls` section = `` header = `Splitter Layout` sub = `3 areas` app = `z2ui5_cl_demo_app_249` )
      ( group = `Controls` section = `` header = `Splitting Container` sub = `` app = `z2ui5_cl_demo_app_103` )
      ( group = `Controls` section = `` header = `Standard List Item` sub = `Wrapping` app = `z2ui5_cl_demo_app_287` )
      ( group = `Controls` section = `` header = `Standard Margins` sub = `Negative Margins` app = `z2ui5_cl_demo_app_243` )
      ( group = `Controls` section = `` header = `Step Input` sub = `` app = `z2ui5_cl_demo_app_041` )
      ( group = `Controls` section = `` header = `Step Input` sub = `Value States` app = `z2ui5_cl_demo_app_264` )
      ( group = `Controls` section = `` header = `Switch` sub = `` app = `z2ui5_cl_demo_app_240` )
      ( group = `Controls` section = `` header = `Templating I` sub = `Basic Example` app = `z2ui5_cl_demo_app_173` )
      ( group = `Controls` section = `` header = `Templating II` sub = `Nested Views` app = `z2ui5_cl_demo_app_176` )
      ( group = `Controls` section = `` header = `Text` sub = `Max Lines` app = `z2ui5_cl_demo_app_206` )
      ( group = `Controls` section = `` header = `Text Area` sub = `` app = `z2ui5_cl_demo_app_021` )
      ( group = `Controls` section = `` header = `Text Area` sub = `Value States` app = `z2ui5_cl_demo_app_234` )
      ( group = `Controls` section = `` header = `Text Area` sub = `Growing` app = `z2ui5_cl_demo_app_236` )
      ( group = `Controls` section = `` header = `Tile` sub = `Numeric Content Without Margins` app = `z2ui5_cl_demo_app_228` )
      ( group = `Controls` section = `` header = `Tile` sub = `Tile Content` app = `z2ui5_cl_demo_app_241` )
      ( group = `Controls` section = `` header = `Tile` sub = `News Content` app = `z2ui5_cl_demo_app_261` )
      ( group = `Controls` section = `` header = `Tile` sub = `Numeric Content of Different Colors` app = `z2ui5_cl_demo_app_262` )
      ( group = `Controls` section = `` header = `Tile` sub = `Numeric Content with Icon` app = `z2ui5_cl_demo_app_263` )
      ( group = `Controls` section = `` header = `Tile` sub = `Image Content` app = `z2ui5_cl_demo_app_271` )
      ( group = `Controls` section = `` header = `Tile` sub = `Feed Content` app = `z2ui5_cl_demo_app_275` )
      ( group = `Controls` section = `` header = `Tile` sub = `Monitor Tile` app = `z2ui5_cl_demo_app_276` )
      ( group = `Controls` section = `` header = `Tile` sub = `KPI Tile` app = `z2ui5_cl_demo_app_277` )
      ( group = `Controls` section = `` header = `Tile` sub = `Feed and News Tile` app = `z2ui5_cl_demo_app_278` )
      ( group = `Controls` section = `` header = `Tile` sub = `Statuses` app = `z2ui5_cl_demo_app_281` )
      ( group = `Controls` section = `` header = `Toggle Button` sub = `` app = `z2ui5_cl_demo_app_266` )
      ( group = `Controls` section = `` header = `Toolbar` sub = `Add a container & toolbar` app = `z2ui5_cl_demo_app_006` )
      ( group = `Controls` section = `` header = `Tree Table I` sub = `Popup Select Entry` app = `z2ui5_cl_demo_app_068` )
      ( group = `Controls` section = `` header = `Tree Table II` sub = `Checkbox Binding per Node` app = `z2ui5_cl_demo_app_364` )
      ( group = `Controls` section = `` header = `ui.Table I` sub = `Simple example` app = `z2ui5_cl_demo_app_070` )
      ( group = `Controls` section = `` header = `ui.Table II` sub = `Events on Cell Level` app = `z2ui5_cl_demo_app_160` )
      ( group = `Controls` section = `` header = `Visualization` sub = `Object Number, Object States & Tab Filter` app = `z2ui5_cl_demo_app_072` )
      ( group = `Controls` section = `` header = `Wizard Control I` sub = `` app = `z2ui5_cl_demo_app_175` )
      ( group = `Controls` section = `` header = `Wizard Control II` sub = `Next step & SubSequentStep` app = `z2ui5_cl_demo_app_202` ) ).

  ENDMETHOD.

ENDCLASS.
