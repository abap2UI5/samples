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
      ( group = `Controls` section = `` header = `Action List Item` sub = `` app = `z2ui5_cl_demo_app_216` )
      ( group = `Controls` section = `` header = `Bar` sub = `Page, Toolbar & Bar` app = `z2ui5_cl_demo_app_227` )
      ( group = `Controls` section = `` header = `Bar` sub = `Toolbar vs Bar vs OverflowToolbar` app = `z2ui5_cl_demo_app_235` )
      ( group = `Controls` section = `` header = `Breadcrumbs` sub = `sample with current page link` app = `z2ui5_cl_demo_app_292` )
      ( group = `Controls` section = `` header = `Busy Indicator` sub = `` app = `z2ui5_cl_demo_app_215` )
      ( group = `Controls` section = `` header = `Button` sub = `` app = `z2ui5_cl_demo_app_259` )
      ( group = `Controls` section = `` header = `Cards` sub = `` app = `z2ui5_cl_demo_app_181` )
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
      ( group = `Controls` section = `` header = `Flex Box` sub = `Basic Alignment` app = `z2ui5_cl_demo_app_205` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Opposing Alignment` app = `z2ui5_cl_demo_app_218` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Direction & Order` app = `z2ui5_cl_demo_app_245` )
      ( group = `Controls` section = `` header = `Flex Box` sub = `Render Type` app = `z2ui5_cl_demo_app_252` )
      ( group = `Controls` section = `` header = `Flexible Column Layout` sub = `Master details with tree` app = `z2ui5_cl_demo_app_069` )
      ( group = `Controls` section = `` header = `Formatted Text` sub = `Display HTML` app = `z2ui5_cl_demo_app_015` )
      ( group = `Controls` section = `` header = `Generic Tag` sub = `Since 1.70` app = `z2ui5_cl_demo_app_062` )
      ( group = `Controls` section = `` header = `Generic Tag with Different Configurations` sub = `` app = `z2ui5_cl_demo_app_257` )
      ( group = `Controls` section = `` header = `Grid List` sub = `with Drag&Drop` app = `z2ui5_cl_demo_app_307` )
      ( group = `Controls` section = `` header = `Header Container` sub = `Vertical Mode` app = `z2ui5_cl_demo_app_280` )
      ( group = `Controls` section = `` header = `Header, Footer, Grid` sub = `Split view in different areas` app = `z2ui5_cl_demo_app_010` )
      ( group = `Controls` section = `` header = `HTML` sub = `` app = `z2ui5_cl_demo_app_242` )
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
      ( group = `Controls` section = `` header = `Nested Splitter Layouts` sub = `7 Areas` app = `z2ui5_cl_demo_app_260` )
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
      ( group = `Controls` section = `` header = `Tile` sub = `Feed and News Tile` app = `z2ui5_cl_demo_app_278` )
      ( group = `Controls` section = `` header = `Tile` sub = `Statuses` app = `z2ui5_cl_demo_app_281` )
      ( group = `Controls` section = `` header = `Toggle Button` sub = `` app = `z2ui5_cl_demo_app_266` )
      ( group = `Controls` section = `` header = `Toolbar` sub = `Add a container & toolbar` app = `z2ui5_cl_demo_app_006` )
      ( group = `Controls` section = `` header = `Tree Table I` sub = `Popup Select Entry` app = `z2ui5_cl_demo_app_068` )
      ( group = `Controls` section = `` header = `Tree Table II` sub = `Checkbox Binding per Node` app = `z2ui5_cl_demo_app_364` )
      ( group = `Controls` section = `` header = `ui.Table I` sub = `Simple example` app = `z2ui5_cl_demo_app_070` )
      ( group = `Controls` section = `` header = `ui.Table II` sub = `Events on Cell Level` app = `z2ui5_cl_demo_app_160` )
      ( group = `Controls` section = `` header = `Visualization` sub = `Object Number, Object States & Tab Filter` app = `z2ui5_cl_demo_app_072` )
      ( group = `Controls` section = `` header = `Wizard Control I` sub = `` app = `z2ui5_cl_demo_app_175` ) ).

  ENDMETHOD.

ENDCLASS.
