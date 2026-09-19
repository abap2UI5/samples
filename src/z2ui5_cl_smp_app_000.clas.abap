" @keywords overview launchpad catalogue index all samples search start tiles
" @summary Every sample in this repository as a searchable list, grouped along the learning path - the app the other 120 are reached from.
CLASS z2ui5_cl_smp_app_000 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA search TYPE string.

    TYPES:
      BEGIN OF ty_s_tile,
        group    TYPE string,
        header   TYPE string,
        sub      TYPE string,
        " never rendered - only fed into the search, so a sample is found by
        " words that do not fit into the 60 characters of its DESCRIPT
        " (synonyms, control names, the abap2UI5 API it uses)
        keywords TYPE string,
        " the blurb of the learning-path stage the tile opens, on the FIRST
        " tile of its group only - rendered once under the group title, so
        " the app can say what a stage is for the way the catalogue page does
        intro    TYPE string,
        " the class's folder relative to the repository root - the class name
        " does not encode it (FOLDER_LOGIC=PREFIX), so the generator supplies
        " it and source_url( ) builds the GitHub link from it
        path     TYPE string,
        app      TYPE string,
      END OF ty_s_tile.
    TYPES ty_t_tile TYPE STANDARD TABLE OF ty_s_tile WITH DEFAULT KEY.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_s_block,
        group TYPE string,
        base  TYPE string,
        width TYPE i,
      END OF ty_s_block.
    TYPES ty_t_block TYPE STANDARD TABLE OF ty_s_block WITH DEFAULT KEY.

    " sap.ui.core.IconColor knows no blue - Positive, Critical, Negative and
    " Neutral are the semantic four - so the interactive icons of the header
    " carry the accent of the sap_horizon theme as a plain CSS colour, and the
    " one that leads nowhere keeps the semantic grey
    CONSTANTS:
      BEGIN OF cs_color,
        active   TYPE string VALUE `#0064D9`,
        inactive TYPE string VALUE `Neutral`,
      END OF cs_color.

    " what a marker at the end of a title means - (A), (C), (A,C). Written by
    " the generator from scripts/lib/markers.mjs, the one legend SAMPLES.md
    " and catalogue.json render too, so the three cannot drift
    CONSTANTS c_legend TYPE string VALUE `Markers on a title: (A) performs a frontend action (client->follow_up_action( ) or a client-side interaction such as drag and drop); (C) uses an abap2UI5 custom control (the z2ui5.cc namespace); (A,C) both`.

    CONSTANTS:
      BEGIN OF cs_event,
        search  TYPE string VALUE `SEARCH`,
        nav     TYPE string VALUE `NAV_APP`,
        install TYPE string VALUE `INSTALL`,
      END OF cs_event.

    " the three sample repositories, in the order the header renders them -
    " each one is installed on its own, so the header asks per entry whether
    " its overview app is on THIS system
    CONSTANTS:
      BEGIN OF cs_class,
        samples      TYPE string VALUE `z2ui5_cl_smp_app_000`,
        controls     TYPE string VALUE `z2ui5_cl_smpc_app_000`,
        " the overview app of samples-controls before its 2026-08 rename to
        " the three-digit number scheme - an installation that predates it
        " still answers to this name (the dmo-era name is older still and no
        " longer tried)
        controls_old TYPE string VALUE `z2ui5_cl_smpc_app_overview`,
        stack        TYPE string VALUE `z2ui5_cl_smps_app_000`,
        " the overview app of samples-stack before its 2026-08 rename to
        " three-digit app numbers - an installation that predates it still
        " answers to this name
        stack_old    TYPE string VALUE `z2ui5_cl_smps_app_00`,
      END OF cs_class.

    CONSTANTS:
      BEGIN OF cs_url,
        docs      TYPE string VALUE `https://abap2UI5.org`,
        samples   TYPE string VALUE `https://github.com/abap2UI5/samples`,
        controls  TYPE string VALUE `https://github.com/abap2UI5/samples-controls`,
        stack     TYPE string VALUE `https://github.com/abap2UI5/samples-stack`,
      END OF cs_url.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF s_scroll,
        id TYPE string,
        x  TYPE i,
        y  TYPE i,
      END OF s_scroll.

    METHODS on_event.
    METHODS app_call
      IMPORTING
        classname TYPE string.
    METHODS scroll_restore.
    "! The page opens with the cursor in the filter, so the first key you press
    "! searches - and it is replayed after every filter roundtrip, with the
    "! cursor at the end of what is already typed, so typing can continue.
    METHODS focus_search.
    METHODS view_display.
    "! The first header row, a Bar in the page's CUSTOM HEADER. Left the app
    "! title and, inside a call stack, the back button the stock page header
    "! would render on its own. Right one icon per sample
    "! repository of the abap2UI5 family - it jumps into that repository's
    "! overview app when the app is on this system and says how to install it
    "! when it is not - then a wider gap and what leaves the system: the
    "! documentation and GitHub. Exactly one entry of the row is inactive: the
    "! repository you are looking at, there is nowhere to go from it.
    METHODS render_header
      IMPORTING
        page TYPE REF TO z2ui5_cl_ui5_view_builder.
    "! The second header row: the filter over the tile list.
    METHODS render_sub_header
      IMPORTING
        page TYPE REF TO z2ui5_cl_ui5_view_builder.
    "! A repository that is not on this system stays clickable and says what is
    "! missing - a popover on the icon that was pressed, with the GitHub link
    "! to install it from.
    METHODS install_display
      IMPORTING
        anchor TYPE string
        href   TYPE string
        name   TYPE string.
    "! @parameter name      | the entry's name - the tooltip opens with it and the
    "!                        popover of an uninstalled repository is titled after it
    "! @parameter class_old | the overview app's PREVIOUS name, tried when CLASS is
    "!                        not on the system: a repository that renamed its
    "!                        overview app is installed under both names in the wild
    "!                        for a while
    "! @parameter group_start | this entry opens the second group of the header
    "!                          row, so it carries the wider margin that sets the
    "!                          two groups apart - see render_header( )
    METHODS header_button
      IMPORTING
        toolbar     TYPE REF TO z2ui5_cl_ui5_view_builder
        icon        TYPE string
        name        TYPE string
        descr       TYPE string
        href        TYPE string
        class       TYPE string OPTIONAL
        class_old   TYPE string OPTIONAL
        here        TYPE abap_bool DEFAULT abap_false
        group_start TYPE abap_bool DEFAULT abap_false.
    "! the press wire of a button whose target is EXTERNAL: a Button carries no
    "! href, and cs_event-open_new_tab is same-origin only, so the new tab is
    "! opened by the URLHELPER frontend action - client-side, inside the click
    "! handler, which is what keeps the popup blocker quiet
    METHODS open_url
      IMPORTING
        href          TYPE string
      RETURNING
        VALUE(result) TYPE string.
    "! the sample's ABAP source on GitHub - the file is named after the class,
    "! the folder comes from the tile because the class name does not encode it
    METHODS source_url
      IMPORTING
        tile          TYPE ty_s_tile
      RETURNING
        VALUE(result) TYPE string.
    METHODS class_installed
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS get_catalog
      RETURNING
        VALUE(result) TYPE ty_t_tile.
    METHODS catalog_filter
      IMPORTING
        t_catalog     TYPE ty_t_tile
      RETURNING
        VALUE(result) TYPE ty_t_tile.
    METHODS block_widths
      IMPORTING
        t_catalog     TYPE ty_t_tile
      RETURNING
        VALUE(result) TYPE ty_t_block.
    METHODS header_width
      IMPORTING
        header        TYPE string
      RETURNING
        VALUE(result) TYPE i.
    METHODS header_base
      IMPORTING
        header        TYPE string
      RETURNING
        VALUE(result) TYPE string.
    METHODS group_titles_needed
      IMPORTING
        t_catalog     TYPE ty_t_tile
      RETURNING
        VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_000 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      view_display( ).
      focus_search( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.

      " focus first, scroll second: focusing a control can scroll it into view,
      " and the restored scroll position is the one that must survive
      focus_search( ).
      scroll_restore( ).
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN cs_event-search.

        view_display( ).
        focus_search( ).

      WHEN cs_event-nav.

        " a header button - the app to jump to travels as the event argument
        app_call( client->get_event_arg( ) ).

      WHEN cs_event-install.

        " a header icon whose repository is not on this system - anchor class,
        " GitHub URL and repository name travel as the event arguments
        install_display( anchor = client->get_event_arg( )
                         href   = client->get_event_arg( 2 )
                         name   = client->get_event_arg( 3 ) ).

      WHEN OTHERS.

        " a tile - the event IS the class name of the sample
        app_call( client->get_event( ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD app_call.

    DATA li_app TYPE REF TO z2ui5_if_app.

    DATA name TYPE string.
        DATA error TYPE REF TO cx_root.
    name = to_upper( classname ).

    TRY.
        CREATE OBJECT li_app TYPE (name).
        MOVE-CORRESPONDING client->get( )-s_scroll-main TO s_scroll.
        client->nav_app_call( li_app ).

        
      CATCH cx_root INTO error.
        " a press that does nothing at all is the worst answer this page can
        " give, and it is what the silent catch here used to produce. The class
        " name is dynamic, so only the running system knows why it did not
        " start - the class was not installed with the rest, the release cannot
        " activate it, one of the classes it references is missing - and none
        " of that is guessable from the outside. Say it instead of swallowing it.
        client->message_box_display( text = |{ name }: { error->get_text( ) }|
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD focus_search.

    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE LINE OF temp1.
    CLEAR temp1.
    INSERT `search` INTO TABLE temp1.
    
    temp2 = |{ strlen( search ) }|.
    INSERT temp2 INTO TABLE temp1.
    
    temp3 = |{ strlen( search ) }|.
    INSERT temp3 INTO TABLE temp1.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_focus
        t_arg = temp1 ).

  ENDMETHOD.


  METHOD scroll_restore.
    DATA temp3 TYPE string_table.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE LINE OF temp3.

    IF s_scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    
    CLEAR temp3.
    INSERT s_scroll-id INTO TABLE temp3.
    
    temp4 = |{ s_scroll-y }|.
    INSERT temp4 INTO TABLE temp3.
    
    temp5 = |{ s_scroll-x }|.
    INSERT temp5 INTO TABLE temp3.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = temp3 ).

  ENDMETHOD.


  METHOD view_display.

    DATA t_catalog_all TYPE z2ui5_cl_smp_app_000=>ty_t_tile.
    DATA t_catalog TYPE z2ui5_cl_smp_app_000=>ty_t_tile.
    DATA t_blocks TYPE z2ui5_cl_smp_app_000=>ty_t_block.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA show_groups TYPE abap_bool.
    DATA prev_group TYPE string.
    DATA prev_base TYPE string.
    DATA tile LIKE LINE OF t_catalog.
      DATA base TYPE string.
      DATA new_block LIKE abap_false.
          DATA head TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA tenths TYPE i.
      FIELD-SYMBOLS <temp6> LIKE LINE OF t_blocks.
      DATA temp7 LIKE sy-tabix.
      DATA width TYPE string.
      DATA temp5 TYPE string.
      DATA row TYPE REF TO z2ui5_cl_ui5_view_builder.
    t_catalog_all = get_catalog( ).
    
    t_catalog = catalog_filter( t_catalog_all ).
    
    t_blocks = block_widths( t_catalog ).

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    " title and back button come with the custom header (render_header), not
    " with the page - a Page renders either its own header or a custom one
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `id` v = `page` ).

    render_header( page ).
    render_sub_header( page ).

    
    show_groups = group_titles_needed( t_catalog ).
    
    prev_group = ``.
    
    prev_base = ``.

    
    LOOP AT t_catalog INTO tile.

      " a block is the category - the header without its Roman numeral - so
      " Binding I, II and III stand together and a blank line follows them
      
      base = header_base( tile-header ).
      
      new_block = abap_false.

      IF tile-group <> prev_group.

        IF show_groups = abap_true.
          " both sap.m.Title and sap.m.Text are display: inline-block, so a
          " title and the paragraph belonging to it share one line whenever
          " the paragraph happens to fit beside it - which is why the long
          " blurb of "Start here" wrapped to its own line while the three
          " shorter ones sat next to their heading. The VBox is the block
          " that stacks the two, and it carries the margins the two used to
          " carry one by one - including the begin margin the Title never
          " had, which left every heading one rem to the left of the rows,
          " the paragraph and the legend
          
          head = page->ele( `VBox`
              )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginEnd sapUiSmallMarginTop sapUiTinyMarginBottom` ).

          head->tag( `Title`
              )->a( n = `text`  t = tile-group
              )->a( n = `level` v = `H3` ).

          " the stage's one paragraph, on the first tile of the group only -
          " a filtered list may start the group elsewhere, and then the
          " title alone has to do
          IF tile-intro IS NOT INITIAL.
            head->tag( `Text`
                )->a( n = `text`  t = tile-intro
                )->a( n = `class` v = `sapUiTinyMarginTop` ).
          ENDIF.

        ELSE.
          " no heading that could set the first block apart from the header
          " rows above it - the block margin does it instead
          new_block = abap_true.

        ENDIF.
        prev_group = tile-group.

      ELSEIF base <> prev_base.
        new_block = abap_true.
      ENDIF.

      prev_base = base.

      " widest header of the block plus roughly one space, in 1/100 em
      
      
      
      temp7 = sy-tabix.
      READ TABLE t_blocks WITH KEY group = tile-group base = base ASSIGNING <temp6>.
      sy-tabix = temp7.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      tenths = ( <temp6>-width + 45 ) DIV 10.
      
      width = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      
      IF new_block = abap_true.
        temp5 = `sapUiSmallMarginBegin sapUiSmallMarginTop`.
      ELSE.
        temp5 = `sapUiSmallMarginBegin`.
      ENDIF.
      
      row = page->ele( `HBox`
          )->a( n = `class`      t = temp5
          )->a( n = `alignItems` v = `Center`
          )->a( n = `wrap`       v = `Wrap` ).

      IF tile-sub IS INITIAL.
        row->tag( `Link`
            )->a( n = `text`  t = tile-header
            )->a( n = `press` v = client->_event( tile-app )
            )->a( n = `width` t = width ).

      ELSE.
        row->tag( `Link`
            )->a( n = `text`  t = tile-header
            )->a( n = `press` v = client->_event( tile-app )
            )->a( n = `width` t = width
            )->tag( `Text`
                )->a( n = `text` t = tile-sub ).
      ENDIF.

      " straight to the ABAP behind the sample - the tile shows what it does,
      " this shows how. External target, so the same client-side URLHELPER
      " wire as the header buttons (a Button carries no href).
      " A core:Icon, not a Button: a Button brings its own height (2rem even in
      " compact density) and would set the line height of every row - the icon
      " is as tall as the text next to it, which is what keeps the list tight
      row->ele( n = `Icon` ns = `core`
          )->a( n = `src`     v = `sap-icon://source-code`
          )->a( n = `size`    v = `0.875rem`
          )->a( n = `class`   v = `sapUiTinyMarginBegin`
          )->a( n = `tooltip` t = |{ tile-app } - show the ABAP source on GitHub|
          )->a( n = `press`   v = open_url( source_url( tile ) ) ).

    ENDLOOP.

    IF t_catalog IS INITIAL.
      page->tag( `Text`
          )->a( n = `text`  v = `No sample matches the filter.`
          )->a( n = `class` v = `sapUiSmallMarginBegin` ).

    ELSE.
      " the legend of the markers some titles end in, under the list where
      " a reader who met one looks for it
      page->tag( `Text`
          )->a( n = `text`  v = c_legend
          )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTop` ).
    ENDIF.

    " a few blank lines so the last tiles do not end glued to the page bottom
    page->ele( `VBox`
        )->a( n = `height` v = `4rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD render_header.

    " ONLY INLINE CONTROLS BELONG INTO A sap.m.Bar. Its content containers
    " became flex boxes only after 1.71: on the oldest release abap2UI5
    " supports, .sapMBarLeft/.sapMBarRight are plain absolutely positioned
    " blocks that lay their children out in normal flow, so a block-level
    " child - a ToolbarSpacer or a ToolbarSeparator, both of which render a
    " <div> - starts a new line, and everything from that line on is cut away
    " by the overflow:hidden the container carries at the bar's height of
    " 3rem. This row used to put a ToolbarSeparator between its two groups and
    " lost the documentation and GitHub icons on 1.71 because of it; the gap
    " now rides on the first icon of the second group (group_start).
    DATA bar TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA left TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA right TYPE REF TO z2ui5_cl_ui5_view_builder.
    bar = page->ele( `customHeader`
        )->ele( `Bar` ).

    " left: what the stock page header would render on its own
    
    left = bar->ele( `contentLeft` ).

    left->tag( `Button`
        )->a( n = `press`   v = client->_event_nav_app_leave( )
        )->a( n = `visible` b = client->check_app_prev_stack( )
        )->a( n = `icon`    v = `sap-icon://nav-back`
        )->a( n = `type`    v = `Transparent`
        )->a( n = `tooltip` v = `Back` ).

    left->tag( `Title`
        )->a( n = `text`  v = `abap2UI5 - Samples`
        )->a( n = `level` v = `H2` ).

    " right: the sample repositories of the abap2UI5 family, one icon each ...
    
    right = bar->ele( `contentRight` ).

    header_button( toolbar = right
                   icon    = `sap-icon://lightbulb`
                   name    = `Samples`
                   descr   = `binding, events, popups, tables and much more`
                   class   = cs_class-samples
                   href    = cs_url-samples
                   here    = abap_true ).

    header_button( toolbar   = right
                   icon      = `sap-icon://palette`
                   name      = `Control Samples`
                   descr     = `the UI5 Demo Kit, rebuilt with abap2UI5`
                   class     = cs_class-controls
                   class_old = cs_class-controls_old
                   href      = cs_url-controls ).

    header_button( toolbar   = right
                   icon      = `sap-icon://database`
                   name      = `Stack Samples`
                   descr     = `OData, RAP, WebSockets and the Fiori Launchpad`
                   class     = cs_class-stack
                   class_old = cs_class-stack_old
                   href      = cs_url-stack ).

    " ... and then, set apart by a wider gap, the two entries that leave the
    " system: the three icons above open an app, these open a site
    header_button( toolbar     = right
                   icon        = `sap-icon://learning-assistant`
                   name        = `Documentation`
                   descr       = `guides, tutorials and the API reference`
                   href        = cs_url-docs
                   group_start = abap_true ).

    " not source-code: that icon now belongs to the per-sample links in the list
    header_button( toolbar = right
                   icon    = `sap-icon://globe`
                   name    = `GitHub`
                   descr   = `the source code of this repository`
                   href    = cs_url-samples ).

  ENDMETHOD.


  METHOD render_sub_header.

    DATA toolbar TYPE REF TO z2ui5_cl_ui5_view_builder.
    toolbar = page->ele( `subHeader`
        )->ele( `OverflowToolbar` ).

    " the filter sits in the header, not above the list: it stays in place
    " while the list below it grows and shrinks
    toolbar->tag( `SearchField`
        )->a( n = `width`       v = `24rem`
        )->a( n = `search`      v = client->_event( cs_event-search )
        )->a( n = `value`       v = client->_bind( search )
        )->a( n = `id`          v = `search`
        )->a( n = `placeholder` v = `Filter samples` ).

  ENDMETHOD.


  METHOD header_button.

    DATA target TYPE string.
    DATA hint   TYPE string.
    DATA color  TYPE string.
    DATA press  TYPE string.

    DATA tooltip TYPE string.
        DATA temp6 TYPE string_table.
    DATA temp8 TYPE string.
    DATA css_class LIKE temp8.
    tooltip = |{ name } - { descr }|.

    IF here = abap_true.

      " where you are: the entry stays, so every overview shows the same row,
      " but there is nowhere to go - and no press
      hint  = |{ tooltip } - you are here|.
      color = cs_color-inactive.

    ELSE.

      color = cs_color-active.

      IF class IS NOT INITIAL AND class_installed( class ) = abap_true.
        target = class.

      ELSEIF class_old IS NOT INITIAL AND class_installed( class_old ) = abap_true.
        target = class_old.

      ENDIF.

      IF target IS NOT INITIAL.

        " installed on this system: jump right into it, the back button returns
        hint  = tooltip.
        press = client->_event( val = cs_event-nav arg = target ).

      ELSEIF class IS INITIAL.

        " no CLASS to look for: the documentation and GitHub entries are no
        " destination inside the system to begin with, they open their site
        hint  = tooltip.
        press = open_url( href ).

      ELSE.

        " a repository that is not on this system is a normal, active entry -
        " the press says what is missing and where to get it (install_display),
        " instead of dropping the user on GitHub without a word
        hint  = |{ tooltip } - not installed on this system|.
        
        CLEAR temp6.
        INSERT class INTO TABLE temp6.
        INSERT href INTO TABLE temp6.
        INSERT name INTO TABLE temp6.
        press = client->_event( val   = cs_event-install
                                t_arg = temp6 ).

      ENDIF.

    ENDIF.

    " a core:Icon, not a Button: on 1.71 a Button cannot carry a colour - the
    " coloured sap.m.ButtonType values (Critical, Neutral, ...) are 1.73+ - and
    " the colour is what separates the active entries from the ONE inactive
    " one, the overview you are already in. Everything else is active, whether
    " its repository is on this system or not. The class name doubles as the
    " icon id, so install_display( ) can anchor its popover to the icon pressed
    " the wider begin margin is what sets the second group of the row apart -
    " a margin rather than a separator control, see render_header( )
    
    IF group_start = abap_true.
      temp8 = `sapUiMediumMarginBegin sapUiTinyMarginEnd`.
    ELSE.
      temp8 = `sapUiTinyMarginBeginEnd`.
    ENDIF.
    
    css_class = temp8.

    toolbar->tag( n = `Icon` ns = `core`
        )->a( n = `src`     t = icon
        )->a( n = `size`    v = `1.125rem`
        )->a( n = `class`   t = css_class
        )->a( n = `tooltip` t = hint ).

    " a( ) writes on the element just added, and an EMPTY attribute would be
    " rendered as one - id="" is not a control id, color="" is not a valid
    " IconColor and press="" is not a handler, so the three optional ones are
    " added only when they carry something. The documentation and GitHub
    " entries have no class, and the entry you are standing on has no press.
    IF class IS NOT INITIAL.
      toolbar->a( n = `id` t = class ).
    ENDIF.

    IF color IS NOT INITIAL.
      toolbar->a( n = `color` t = color ).
    ENDIF.

    IF press IS NOT INITIAL.
      toolbar->a( n = `press` v = press ).
    ENDIF.

  ENDMETHOD.


  METHOD install_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    view->ele( `Popover`
        )->a( n = `title`        t = |{ name } - not installed|
        )->a( n = `placement`    v = `Bottom`
        )->a( n = `contentWidth` v = `26rem`
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Text`
                )->a( n = `text` t = |This system does not have { name } installed, so there is no app to jump to. | &&
                     |Install the repository with abapGit, then this icon opens it right here.|
            )->tag( `Link`
                )->a( n = `text`   v = href
                )->a( n = `target` v = `_blank`
                )->a( n = `href`   v = href
                )->a( n = `class`  v = `sapUiSmallMarginTop` ).

    client->popover_display( xml   = view->stringify( )
                             by_id = anchor ).

  ENDMETHOD.


  METHOD open_url.

    " REDIRECT takes a { URL, NEW_WINDOW } object literal - NEW_WINDOW true is
    " what target="_blank" does on a Link
    DATA temp9 TYPE string_table.
    DATA temp8 LIKE LINE OF temp9.
    CLEAR temp9.
    INSERT `REDIRECT` INTO TABLE temp9.
    
    temp8 = |\{ URL: '{ href }', NEW_WINDOW: true \}|.
    INSERT temp8 INTO TABLE temp9.
    result = client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-urlhelper
        t_arg = temp9 ).

  ENDMETHOD.


  METHOD source_url.

    result = |{ cs_url-samples }/blob/main/{ tile-path }/{ tile-app }.clas.abap|.

  ENDMETHOD.


  METHOD class_installed.

    " Is the class ON this system - the same question the framework's start
    " page asks (z2ui5_cl_ui5_util_context=>rtti_check_class_exists), and
    " deliberately NOT "can it be instantiated". CREATE OBJECT was the check
    " here, and it answers a far bigger question than the header has: it loads
    " the whole class pool of the OTHER repository's overview app together with
    " everything that pool statically references, and runs its constructor.
    " Every failure in there - a helper class of that repository the release
    " cannot activate, a repository that landed on the system only in part -
    " came back as "not installed on this system", so the icon offered the
    " abapGit link for a repository that is sitting right there and refused to
    " navigate into it.
    " Existence is what this row has to decide. Whether the app then starts is
    " app_call( )'s question, and since the silent catch there is gone, a jump
    " that cannot happen says why instead of doing nothing.
    " The name has to be upper case - the repository stores it that way, and
    " the class constants above follow the repository's lower-case spelling rule.
    DATA name TYPE string.
    name = to_upper( val ).

    TRY.
        cl_abap_classdescr=>describe_by_name( EXPORTING  p_name         = name
                                              EXCEPTIONS type_not_found = 1 ).
        IF sy-subrc = 0.
          result = abap_true.
        ENDIF.

      CATCH cx_root ##CATCH_ALL.
        result = abap_false.
    ENDTRY.

  ENDMETHOD.


  METHOD get_catalog.

    DATA temp11 TYPE z2ui5_cl_smp_app_000=>ty_t_tile.
    DATA temp12 LIKE LINE OF temp11.
    CLEAR temp11.
    
    temp12-group = `Start here`.
    temp12-header = `Basics I`.
    temp12-sub = `Hello World, the Smallest App`.
    temp12-keywords = `hello world smallest first app minimal start here template`.
    temp12-intro = `The ones to read first, in order. One class, one view, one roundtrip - the shape every other sample in this repository grows from, plus the developer tools you will open when something does not render.`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_493`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Start here`.
    temp12-header = `Basics II`.
    temp12-sub = `Data Binding: Input and Button`.
    temp12-keywords = `binding _bind model attribute value input button roundtrip messagebox serialize`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_494`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Start here`.
    temp12-header = `Basics III`.
    temp12-sub = `Lifecycle: Init, Event, Navigated`.
    temp12-keywords = `lifecycle roundtrip main dispatcher state serialize check_on_init check_on_event check_on_navigated`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_495`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Start here`.
    temp12-header = `Basics IV`.
    temp12-sub = `Events, Views and Roundtrips`.
    temp12-keywords = `roundtrip restart second view uncaught error controller basics check_on_navigated get`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_004`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Start here`.
    temp12-header = `Basics V`.
    temp12-sub = `The Developer Tools (Ctrl+F12)`.
    temp12-keywords = `developer tools devtools ctrl f12 debug inspect payload previous request response view xml view model source code log error adt export`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_496`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Start here`.
    temp12-header = `Basics VI`.
    temp12-sub = `Unit Tests for the App Logic`.
    temp12-keywords = `unit test abapunit testclasses assert testable logic method`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_503`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Start here`.
    temp12-header = `Basics VII`.
    temp12-sub = `Translatable Texts (Text Elements)`.
    temp12-keywords = `translation i18n text element text symbol textpool language message class multi language`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_519`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `A View Built From RTTI, No Field Named`.
    temp12-keywords = `rtti generic view runtime columns get_components describe_by_data no field name itab structure column cell binding`.
    temp12-intro = `How an ABAP field becomes something a user reads and edits: binding an attribute, the types that convert it, formatters, and views built from data rather than written out.`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_497`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Currency Amounts (sap.ui.model.type.Currency)`.
    temp12-keywords = `amount decimals leading zeros number format`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_067`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Dynamic Table Typed at Runtime (RTTI)`.
    temp12-keywords = `generic data reference create data ddic dynamic itab`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_061`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Expression Binding, Types and Composite Parts`.
    temp12-keywords = `formatter parts conditional regexp visible enabled syntax`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_027`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Model setSizeLimit for Large Tables (A)`.
    temp12-keywords = `combobox jsonmodel size limit large itab 100 entries`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_071`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Omit Initial Values`.
    temp12-keywords = `binding omit initial default property absent omit_initial omit_initial_paths ratingindicator maxvalue enabled boolean`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_507`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Path Only (_bind_path)`.
    temp12-keywords = `binding path only bare path _bind_path expression binding sorter binding info composed raw string`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_508`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Pre-serialized JSON (json)`.
    temp12-keywords = `binding json string spliced model node object array pre-serialized _bind json = abap_true no abap type`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_509`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Single Table Cell (tab_index)`.
    temp12-keywords = `cell input internal table row field level`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_144`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Structure Fields and INCLUDEs`.
    temp12-keywords = `structure component include flat form level`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_166`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Binding`.
    temp12-sub = `Types for Integer, Decimal, Date and Time`.
    temp12-keywords = `type conversion sum amount number field`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_047`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Formatter`.
    temp12-sub = `ABAP Date and Time Strings (DATS/TIMS)`.
    temp12-keywords = `dats tims conversion initial date 00000000 sy-datum`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_450`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Formatter`.
    temp12-sub = `Date Object for the DatePicker`.
    temp12-keywords = `datepicker datevalue javascript date object iso`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_457`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Formatter`.
    temp12-sub = `Date Objects for the PlanningCalendar`.
    temp12-keywords = `planningcalendar appointment javascript date object iso`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_456`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Formatter`.
    temp12-sub = `Inline Icons in a Text`.
    temp12-keywords = `icon glyph placeholder text status expandinlineicons`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_466`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Formatter`.
    temp12-sub = `When Not to Use One: Compute in ABAP`.
    temp12-keywords = `no formatter computed backend thin frontend prepare`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_453`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Templating`.
    temp12-sub = `Build Columns Dynamically (template:repeat)`.
    temp12-keywords = `template repeat runtime generated columns if then else`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_173`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Get your data on screen`.
    temp12-header = `Templating`.
    temp12-sub = `Dynamic Content in a Nested View`.
    temp12-keywords = `template repeat runtime generated nested nest_view_display`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_176`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Grid Table`.
    temp12-sub = `Events on Cell Level`.
    temp12-keywords = `cell enter row index event grid alv`.
    temp12-intro = `Internal tables on screen - the responsive table, the grid table for large sets, lists and trees - with growing, selection, editing and everything a row can carry.`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_160`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Grid Table`.
    temp12-sub = `Full Example with sap.ui.table`.
    temp12-keywords = `grid alv dynamicpage column row action currency search sort filter`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_070`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Grid Table`.
    temp12-sub = `Keep Column Filters on Refresh (C)`.
    temp12-keywords = `column filter reset refresh uitableext grid alv`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_143`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `List`.
    temp12-sub = `Filter and Sort the Binding from ABAP (A)`.
    temp12-keywords = `binding_call getbinding sorter filter follow_up_action`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_454`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `List`.
    temp12-sub = `Live Filter on the Client, No Roundtrip (A)`.
    temp12-keywords = `binding_call live search client side no roundtrip filter`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_455`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `List`.
    temp12-sub = `StandardListItem, Highlight and Events`.
    temp12-keywords = `sap.m.list standardlistitem highlight infostate press selection`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_048`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Drag and Drop Rows (A)`.
    temp12-keywords = `dnd dragdropinfo reorder rows move`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_459`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Editable Cells, Add and Delete Rows`.
    temp12-keywords = `edit input add row delete multiselect toolbar`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_011`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Filter Rows in the Backend`.
    temp12-keywords = `filter server side form growing where`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_045`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Large Table with Growing and ScrollContainer`.
    temp12-keywords = `growing 10000 rows sticky toolbar sort performance`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_006`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Live Search over a Large Table`.
    temp12-keywords = `live search table filter keystroke roundtrip busy indicator overlay check_queue_last check_no_busy typing`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_059`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Refused Cell Values (t_model_skipped)`.
    temp12-keywords = `table edit refused cell conversion error t_model_skipped valuestate packed price integer nested row_parent`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_504`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Search in the Backend (SearchField)`.
    temp12-keywords = `search go enter server side where`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_053`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Table`.
    temp12-sub = `Selection Modes: Single and Multi Select`.
    temp12-keywords = `selectionmode none single multi segmentedbutton checkbox`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_019`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Tree`.
    temp12-sub = `Drag and Drop Nodes (A,C)`.
    temp12-keywords = `dnd move node hierarchy binding context`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_461`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Tree`.
    temp12-sub = `Editable Nodes with CustomTreeItem (C)`.
    temp12-keywords = `customtreeitem rename input binding write back`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_463`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Tree`.
    temp12-sub = `Inside a Dialog (C)`.
    temp12-keywords = `popup expand state hierarchy nodes`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_462`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Show many rows`.
    temp12-header = `Tree`.
    temp12-sub = `Nested ABAP Table in a sap.m.Tree`.
    temp12-keywords = `hierarchy nodes nested json items`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_460`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Control Objects in t_arg (FacetFilter)`.
    temp12-keywords = `facetfilter filter object marshalling selected items`.
    temp12-intro = `The other direction: events arriving from the view, messages and message boxes going back, and the popups, popovers and menus that ask before something happens.`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_197`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Extra Arguments with t_arg`.
    temp12-keywords = `argument parameter payload event data fixed value`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_167`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Keep the Last Keystroke with check_queue_last`.
    temp12-keywords = `livechange keystroke queue busy roundtrip dropped event check_queue_last s_ctrl`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_511`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Keyboard Shortcuts, Ctrl+S (A)`.
    temp12-keywords = `shortcut hotkey ctrl key combination keyboard_shortcut`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_471`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Link with preventDefault (A)`.
    temp12-keywords = `link href default action check_prevent_default`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_472`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Literal Arguments (check_arg_literal)`.
    temp12-keywords = `event argument literal quoted expression evaluated check_arg_literal t_arg data binding syntax dollar brace`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_506`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Event`.
    temp12-sub = `Prevent Default per Column`.
    temp12-keywords = `grid table sort column prevent default expression prevent_default_expr backend sort client sort per column`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_505`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Menu`.
    temp12-sub = `Full Path of the Selected Item (A)`.
    temp12-keywords = `menuitem nested submenu textpath controller path`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_473`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Menu`.
    temp12-sub = `Menu Button with core:require`.
    temp12-keywords = `menubutton menuitem popover messagetoast require module`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_163`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `Message Model and MessageManager (C)`.
    temp12-keywords = `messagemanager validation target field state central model`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_467`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessageBox for Any Data`.
    temp12-keywords = `messagebox details table structure tree object reference escape limit action onclose`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_502`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessageBox from SY, BAPIRET2 or Exception`.
    temp12-keywords = `t100 message class number exception cx_root error abend`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_008`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessageBox via the Global Object`.
    temp12-keywords = `messagebox global object control_global follow_up_action options icon contentwidth textdirection closeonnavigation dependenton actions onclose`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_512`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessageBox, Types and Custom Actions`.
    temp12-keywords = `confirm warning error success information dialog action`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_382`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessagePopover URL Policy (A)`.
    temp12-keywords = `url policy link security validator relative allow deny`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_474`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessageToast via the Global Object`.
    temp12-keywords = `toast notification global object control_global follow_up_action options duration position animation anchor collision class css template`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_381`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Message`.
    temp12-sub = `MessageView and MessagePopover (A)`.
    temp12-keywords = `messagepopover messageitem dialog grouped message list`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_452`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popover`.
    temp12-sub = `Basic Example with Placement`.
    temp12-keywords = `placement anchor button confirm cancel popover_display`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_026`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popover`.
    temp12-sub = `Open from a Table Row (A)`.
    temp12-keywords = `list report dynamicpage row link details table popover slot cs_view focus control_by_id`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_052`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popover`.
    temp12-sub = `Open Together with the View Build`.
    temp12-keywords = `initial render one roundtrip anchor button`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_490`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popover`.
    temp12-sub = `QuickView Contact Card`.
    temp12-keywords = `quickview contact card links grouped fields`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_109`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popover`.
    temp12-sub = `Select from a List`.
    temp12-keywords = `list selection placement anchor`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_081`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popover`.
    temp12-sub = `Toggle by ID (toggleBy) (A)`.
    temp12-keywords = `toggleby open close control_by_id whitelisted`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_465`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popup`.
    temp12-sub = `Dialog inside a Dialog`.
    temp12-keywords = `nested stack popup in popup second dialog`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_161`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popup`.
    temp12-sub = `Element Binding to the Selected Row (A)`.
    temp12-keywords = `element binding relative path aggregation dialog row`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_470`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popup`.
    temp12-sub = `Navigate between Dialogs (NavContainer) (A)`.
    temp12-keywords = `navcontainer dialog pages back forward`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_170`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popup`.
    temp12-sub = `Value Help: Suggestions and F4 Dialog`.
    temp12-keywords = `f4 search help suggestion input dialog select`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_009`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Talk to the user`.
    temp12-header = `Popup`.
    temp12-sub = `Ways to Open a Dialog (A)`.
    temp12-keywords = `dialog sub app destroy rerender background view`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_012`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Focus`.
    temp12-sub = `Focus a Table Cell by Column and Row (A)`.
    temp12-keywords = `table cell column row aggregation set_focus`.
    temp12-intro = `More than one view and more than one app: navigation and app calls, views nested inside views, and the small things that decide where the user is looking - focus, scrolling, a timer.`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_421`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Focus`.
    temp12-sub = `Jump to the Next Input on Enter (A)`.
    temp12-keywords = `cursor enter tab next field form set_focus`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_189`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Focus`.
    temp12-sub = `Set Focus and Select Text in an Input (A)`.
    temp12-keywords = `cursor set_focus selection position textfield`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_133`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Hash`.
    temp12-sub = `App State, Bookmark and Share`.
    temp12-keywords = `app state url bookmark share clipboard copy link restore deep link reload app_state_set_active app_state_get_href sap-iapp-state sap-xapp-state switch off event form`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_498`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Hash`.
    temp12-sub = `App-Owned Routing (#/detail)`.
    temp12-keywords = `routing hash url page browser back forward history deep link reload hash_set hash_replace hash_back hash_attach_changed navcontainer router onnavback follow_up_action event form`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_499`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Hash`.
    temp12-sub = `Routing mode fresh`.
    temp12-keywords = `routing mode fresh default off navigation restart new instance nav_app_call`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_468`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Hash`.
    temp12-sub = `Routing mode keep`.
    temp12-keywords = `routing mode keep navigation state preserved back nav_app_call`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_480`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Navigation`.
    temp12-sub = `Call and Leave Apps (nav_app_call)`.
    temp12-keywords = `nav_app_call nav_app_leave sub app stack call back`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_024`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Navigation`.
    temp12-sub = `Data Loss Protection on Leaving (A,C)`.
    temp12-keywords = `dirty unsaved changes leave confirmation warning`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_279`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Navigation`.
    temp12-sub = `Return Data and Events to the Caller`.
    temp12-keywords = `r_data result get_app_prev return event payload`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_488`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Navigation`.
    temp12-sub = `Uncaught Error and Error Popup`.
    temp12-keywords = `exception dump error handling debugtool restart retry`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_464`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Nested View`.
    temp12-sub = `Basic Example (nest_view_display)`.
    temp12-keywords = `nest_view_display rerender model refresh sub view`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_065`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Nested View`.
    temp12-sub = `Destroy and Target a Slot (A)`.
    temp12-keywords = `nested view destroy nest_view_destroy nest2_view_destroy slot scope cs_view nested nested2 control_by_id focus`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_510`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Nested View`.
    temp12-sub = `Embed Another App's View`.
    temp12-keywords = `sub app class embed instantiate another app rtti`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_104`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Nested View`.
    temp12-sub = `Master-Detail with FlexibleColumnLayout`.
    temp12-keywords = `fcl master detail list report two column split`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_097`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Nested View`.
    temp12-sub = `Three Columns with FlexibleColumnLayout`.
    temp12-keywords = `fcl three column detail detail deep navigation`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_098`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Scroll`.
    temp12-sub = `Scroll a Control into View (A)`.
    temp12-keywords = `scroll_into_view control id validation jump`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_363`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Scroll`.
    temp12-sub = `Scroll to a Pixel Position (A)`.
    temp12-keywords = `position pixel scroll_to restore refresh toolbar`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_362`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Timer`.
    temp12-sub = `Progress Indicator during a Backend Call (A)`.
    temp12-keywords = `progressindicator busy wait long running backend`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_064`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Move through the app`.
    temp12-header = `Timer`.
    temp12-sub = `Refresh the View Every n Seconds (A)`.
    temp12-keywords = `interval polling auto refresh follow_up_action seconds`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_028`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Copy to Clipboard (A)`.
    temp12-keywords = `clipboard paste copy text area`.
    temp12-intro = `Where an app stops being only a view: the browser it runs in, the device it runs on, files in and out, custom CSS, and driving a control from the backend by its id.`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_325`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Keyboard Layout of an Input (inputmode) (C)`.
    temp12-keywords = `inputmode soft keyboard numeric keypad barcode scanner mobile inputext bound property`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_516`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Local and Session Storage (A,C)`.
    temp12-keywords = `localstorage sessionstorage persist store_data offline`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_327`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Logout from the Client (A)`.
    temp12-keywords = `logoff signout icf session end fiori launchpad`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_361`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Open a URL in a New Tab (A)`.
    temp12-keywords = `url window open_new_tab link target`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_073`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Open Mail, Phone and SMS Links (A)`.
    temp12-keywords = `mailto tel sms urlhelper redirect native link`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_316`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Reload the Page (A)`.
    temp12-keywords = `reload refresh restart location_reload url`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_492`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Set the Tab Favicon (A)`.
    temp12-keywords = `favicon icon tab image data uri`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_491`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Set the Tab Title (A)`.
    temp12-keywords = `document.title tab caption headline set_title`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_125`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Browser`.
    temp12-sub = `Soft Keyboard Mode on Mobile (A)`.
    temp12-keywords = `mobile numeric keypad keyboard_set_mode phone input`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_352`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Aggregation Item by Index (A)`.
    temp12-keywords = `carousel aggregation item index clone template setactivepage positional control_by_id`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_514`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Expand a Panel by ID (setExpanded) (A)`.
    temp12-keywords = `panel collapse expand setexpanded control_by_id whitelisted`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_448`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Inline CSS on a Control (css) (A)`.
    temp12-keywords = `css inline style background color opacity control_by_id dom node no property`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_513`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `MultiInput with Tokens (C)`.
    temp12-keywords = `multiinput token tokens suggestion custom control`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_078`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Open the PDF Viewer by ID (A)`.
    temp12-keywords = `pdfviewer pdf document viewer popup control_by_id whitelisted`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_449`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Register an Icon Font (A)`.
    temp12-keywords = `icon font registerfont iconpool tnt collection glyph missing control_global`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_518`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Switch NavContainer Page by ID (A)`.
    temp12-keywords = `navcontainer icontabbar icontabheader page switch control_by_id whitelisted`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_088`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `The Global Busy Indicator (A)`.
    temp12-keywords = `busy indicator global control_global show hide blocking wait spinner long running`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_515`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Control Behaviour`.
    temp12-sub = `Wizard with Steps (A)`.
    temp12-keywords = `wizard step branching discardprogress setnextstep control_by_id`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_202`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `CSS`.
    temp12-sub = `Color Table Cells from the Backend`.
    temp12-keywords = `color background conditional formatting style data attribute`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_305`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `CSS`.
    temp12-sub = `FlexBox Layouts with Custom Classes`.
    temp12-keywords = `flexbox layout responsive navigation tile panel`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_255`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `CSS`.
    temp12-sub = `Ship Your Own CSS with the View`.
    temp12-keywords = `style stylesheet inline html class own design`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_050`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Device`.
    temp12-sub = `Camera, Take Photos (C)`.
    temp12-keywords = `camera photo picture webcam capture facing mode`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_306`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Device`.
    temp12-sub = `Device Model: Phone, Tablet, Desktop (A)`.
    temp12-keywords = `sap.ui.device responsive orientation resize media model`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_445`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Device`.
    temp12-sub = `Frontend Info: UI5 Version, Theme, OS, Browser`.
    temp12-keywords = `client info ui5 version theme os user agent device cs_device browser orientation constants`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_122`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `Device`.
    temp12-sub = `Geolocation from the Browser (C)`.
    temp12-keywords = `gps position latitude longitude altitude location`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_120`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `File`.
    temp12-sub = `Download to the Browser (A)`.
    temp12-keywords = `export save base64 attachment xstring document`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_186`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `File`.
    temp12-sub = `Upload to the Backend (C)`.
    temp12-keywords = `fileuploader base64 attachment import picture document`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_074`.
    INSERT temp12 INTO TABLE temp11.
    temp12-group = `Reach outside the view`.
    temp12-header = `File`.
    temp12-sub = `Upload with an UploadSet (C)`.
    temp12-keywords = `uploadset upload drag drop multiple files base64 attachment uploadsetext companion`.
    temp12-path = `src/01`.
    temp12-app = `z2ui5_cl_smp_app_517`.
    INSERT temp12 INTO TABLE temp11.
    result = temp11.

  ENDMETHOD.


  METHOD catalog_filter.
    DATA pattern TYPE string.
    DATA tile LIKE LINE OF t_catalog.

    IF search IS INITIAL.
      result = t_catalog.
      RETURN.
    ENDIF.

    
    pattern = to_upper( search ).
    
    LOOP AT t_catalog INTO tile.

      IF to_upper( |{ tile-header } { tile-sub } { tile-keywords } { tile-app }| ) CS pattern.
        INSERT tile INTO TABLE result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD block_widths.

    DATA tile LIKE LINE OF t_catalog.
      DATA base TYPE string.
      FIELD-SYMBOLS <block> TYPE z2ui5_cl_smp_app_000=>ty_s_block.
        DATA temp13 TYPE z2ui5_cl_smp_app_000=>ty_s_block.
      DATA width TYPE i.
    LOOP AT t_catalog INTO tile.

      
      base = header_base( tile-header ).
      
      READ TABLE result ASSIGNING <block>
        WITH KEY group = tile-group
                 base  = base.

      IF sy-subrc <> 0.
        
        CLEAR temp13.
        temp13-group = tile-group.
        temp13-base = base.
        INSERT temp13 INTO TABLE result ASSIGNING <block>.
      ENDIF.

      
      width = header_width( tile-header ).

      IF width > <block>-width.
        <block>-width = width.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD header_width.

    " estimated render width in 1/100 em, weighted per character class
    DATA off TYPE i.
      DATA char TYPE string.
      DATA temp14 TYPE i.
    off = 0.
    WHILE strlen( header ) > off.

      
      char = substring( val = header
                              off = off
                              len = 1 ).
      
      IF char CA `MW`.
        temp14 = 95.
      ELSEIF char CA `mw`.
        temp14 = 80.
      ELSEIF char CA `ijltfrI. -`.
        temp14 = 35.
      ELSEIF char CA `ABCDEFGHJKLNOPQRSTUVXYZ`.
        temp14 = 75.
      ELSE.
        temp14 = 55.
      ENDIF.
      result = result + temp14.
      off = off + 1.

    ENDWHILE.

  ENDMETHOD.


  METHOD header_base.
    DATA words TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA n TYPE i.
    FIELD-SYMBOLS <temp15> LIKE LINE OF words.
    DATA temp16 LIKE sy-tabix.
    FIELD-SYMBOLS <temp9> LIKE LINE OF words.
    DATA temp10 LIKE sy-tabix.

    result = header.
    
    SPLIT header AT ` ` INTO TABLE words.
    
    n = lines( words ).

    
    
    temp16 = sy-tabix.
    READ TABLE words INDEX n ASSIGNING <temp15>.
    sy-tabix = temp16.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp10 = sy-tabix.
    READ TABLE words INDEX n ASSIGNING <temp9>.
    sy-tabix = temp10.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    IF n > 1 AND <temp15> IS NOT INITIAL AND <temp9> CO `IVXLCDM`.

      DELETE words INDEX n.
      result = concat_lines_of(
          table = words
          sep   = ` ` ).

    ENDIF.

  ENDMETHOD.


  METHOD group_titles_needed.

    " A group heading only tells the reader something when there is more than
    " one group to tell apart - a filter that leaves one stage, or a single
    " stage in the tree, would just repeat the page title, so it is left out.
    DATA first_group TYPE string.
    DATA tile LIKE LINE OF t_catalog.
    LOOP AT t_catalog INTO tile.

      IF sy-tabix = 1.
        first_group = tile-group.

      ELSEIF tile-group <> first_group.
        result = abap_true.
        RETURN.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
