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
        controls     TYPE string VALUE `z2ui5_cl_smpc_app_overview`,
        " the overview app of samples-controls before its 2026-08 rename - an
        " installation that predates it still answers to this name
        controls_old TYPE string VALUE `z2ui5_cl_dmo_app_overview`,
        stack        TYPE string VALUE `z2ui5_cl_smps_app_00`,
        " samples-stack moved every object from the SMPE token to SMPS in
        " 2026-08; an installation that predates it still answers to this name
        stack_old    TYPE string VALUE `z2ui5_cl_smpe_app_00`,
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
    METHODS block_base
      IMPORTING
        group         TYPE string
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
    IF client->check_on_init( ).

      view_display( ).
      focus_search( ).

    ELSEIF client->check_on_navigated( ).

      " focus first, scroll second: focusing a control can scroll it into view,
      " and the restored scroll position is the one that must survive
      focus_search( ).
      scroll_restore( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
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

    DATA(name) = to_upper( classname ).

    TRY.
        DATA li_app TYPE REF TO z2ui5_if_app.
        CREATE OBJECT li_app TYPE (name).
        s_scroll = CORRESPONDING #( client->get( )-s_scroll-main ).
        client->nav_app_call( li_app ).

      CATCH cx_root INTO DATA(error) ##CATCH_ALL.
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

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_focus
        t_arg = VALUE #( ( `search` )
                         ( |{ strlen( search ) }| )
                         ( |{ strlen( search ) }| ) ) ).

  ENDMETHOD.


  METHOD scroll_restore.

    IF s_scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = VALUE #( ( s_scroll-id )
                         ( |{ s_scroll-y }| )
                         ( |{ s_scroll-x }| ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(t_catalog_all) = get_catalog( ).
    DATA(t_catalog) = catalog_filter( t_catalog_all ).
    DATA(t_blocks) = block_widths( t_catalog ).

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    " title and back button come with the custom header (render_header), not
    " with the page - a Page renders either its own header or a custom one
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `id` v = `page` ).

    render_header( page ).
    render_sub_header( page ).

    DATA(show_groups) = group_titles_needed( t_catalog ).
    DATA(prev_group) = ``.
    DATA(prev_base) = ``.

    LOOP AT t_catalog INTO DATA(tile).

      DATA(base) = block_base( group  = tile-group
                               header = tile-header ).
      DATA(new_block) = abap_false.

      IF tile-group <> prev_group.

        IF show_groups = abap_true.
          page->tag( `Title`
              )->a( n = `text`  v = tile-group
              )->a( n = `class` v = `sapUiSmallMarginTop sapUiTinyMarginBottom`
              )->a( n = `level` v = `H3` ).

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
      DATA(tenths) = ( t_blocks[ group = tile-group base = base ]-width + 45 ) DIV 10.
      DATA(width) = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      DATA(row) = page->ele( `HBox`
          )->a( n = `class`      v = COND #( WHEN new_block = abap_true
                               THEN `sapUiSmallMarginBegin sapUiSmallMarginTop`
                               ELSE `sapUiSmallMarginBegin` )
          )->a( n = `alignItems` v = `Center`
          )->a( n = `wrap`       v = `Wrap` ).

      IF tile-sub IS INITIAL.
        row->tag( `Link`
            )->a( n = `text`  v = tile-header
            )->a( n = `press` v = client->_event( tile-app )
            )->a( n = `width` v = width ).

      ELSE.
        row->tag( `Link`
            )->a( n = `text`  v = tile-header
            )->a( n = `press` v = client->_event( tile-app )
            )->a( n = `width` v = width
            )->tag( `Text`
                )->a( n = `text` v = tile-sub ).
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
          )->a( n = `tooltip` v = |{ tile-app } - show the ABAP source on GitHub|
          )->a( n = `press`   v = open_url( source_url( tile ) ) ).

    ENDLOOP.

    IF t_catalog IS INITIAL.
      page->tag( `Text`
          )->a( n = `text`  v = `No sample matches the filter.`
          )->a( n = `class` v = `sapUiSmallMarginBegin` ).
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
    DATA(bar) = page->ele( `customHeader`
        )->ele( `Bar` ).

    " left: what the stock page header would render on its own
    DATA(left) = bar->ele( `contentLeft` ).

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
    DATA(right) = bar->ele( `contentRight` ).

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

    DATA(toolbar) = page->ele( `subHeader`
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

    DATA(tooltip) = |{ name } - { descr }|.

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
        press = client->_event( val   = cs_event-nav
                                t_arg = VALUE #( ( target ) ) ).

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
        press = client->_event( val   = cs_event-install
                                t_arg = VALUE #( ( class )
                                                 ( href )
                                                 ( name ) ) ).

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
    DATA(css_class) = COND string( WHEN group_start = abap_true
                                   THEN `sapUiMediumMarginBegin sapUiTinyMarginEnd`
                                   ELSE `sapUiTinyMarginBeginEnd` ).

    toolbar->tag( n = `Icon` ns = `core`
        )->a( n = `src`     v = icon
        )->a( n = `size`    v = `1.125rem`
        )->a( n = `class`   v = css_class
        )->a( n = `tooltip` v = hint ).

    " a( ) writes on the element just added, and an EMPTY attribute would be
    " rendered as one - id="" is not a control id, color="" is not a valid
    " IconColor and press="" is not a handler, so the three optional ones are
    " added only when they carry something. The documentation and GitHub
    " entries have no class, and the entry you are standing on has no press.
    IF class IS NOT INITIAL.
      toolbar->a( n = `id` v = class ).
    ENDIF.

    IF color IS NOT INITIAL.
      toolbar->a( n = `color` v = color ).
    ENDIF.

    IF press IS NOT INITIAL.
      toolbar->a( n = `press` v = press ).
    ENDIF.

  ENDMETHOD.


  METHOD install_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    view->ele( `Popover`
        )->a( n = `title`        v = |{ name } - not installed|
        )->a( n = `placement`    v = `Bottom`
        )->a( n = `contentWidth` v = `26rem`
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Text`
                )->a( n = `text` v = |This system does not have { name } installed, so there is no app to jump to. | &&
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
    result = client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-urlhelper
        t_arg = VALUE #( ( `REDIRECT` )
                         ( |\{ URL: '{ href }', NEW_WINDOW: true \}| ) ) ).

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
    DATA(name) = to_upper( val ).

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

    result = VALUE #(
      ( group = `samples` header = `Basics I` sub = `Hello World, the Smallest App` keywords = `hello world smallest first app minimal start here template` path = `src/01` app = `z2ui5_cl_smp_app_493` )
      ( group = `samples` header = `Basics II` sub = `Data Binding: Input and Button` keywords = `binding _bind model attribute value input button serialize` path = `src/01` app = `z2ui5_cl_smp_app_494` )
      ( group = `samples` header = `Basics III` sub = `Lifecycle: Init, Event, Navigated` keywords = `lifecycle roundtrip main dispatcher state serialize check_on_init check_on_event check_on_navigated` path = `src/01` app = `z2ui5_cl_smp_app_495` )
      ( group = `samples` header = `Basics IV` sub = `Events, Views and Roundtrips` keywords = `roundtrip restart second view uncaught error controller basics` path = `src/01` app = `z2ui5_cl_smp_app_004` )
      ( group = `samples` header = `Basics V`
        sub = `The Developer Tools (Ctrl+F12)`
        keywords = `developer tools devtools ctrl f12 debug inspect payload previous request response view xml view model source code log error adt export`
        path = `src/01` app = `z2ui5_cl_smp_app_496` )
      ( group = `samples` header = `Binding` sub = `Currency Amounts (sap.ui.model.type.Currency)` keywords = `amount decimals leading zeros number format` path = `src/01` app = `z2ui5_cl_smp_app_067` )
      ( group = `samples` header = `Binding` sub = `Dynamic Table Typed at Runtime (RTTI)` keywords = `generic data reference create data ddic dynamic itab` path = `src/01` app = `z2ui5_cl_smp_app_061` )
      ( group = `samples` header = `Binding` sub = `Expression Binding, Types and Composite Parts` keywords = `formatter parts conditional regexp visible enabled syntax` path = `src/01` app = `z2ui5_cl_smp_app_027` )
      ( group = `samples` header = `Binding` sub = `Model setSizeLimit for Large Tables (A)` keywords = `combobox jsonmodel size limit large itab 100 entries` path = `src/01` app = `z2ui5_cl_smp_app_071` )
      ( group = `samples` header = `Binding` sub = `Single Table Cell (tab_index)` keywords = `cell input internal table row field level` path = `src/01` app = `z2ui5_cl_smp_app_144` )
      ( group = `samples` header = `Binding` sub = `Structure Fields and INCLUDEs` keywords = `structure component include flat form level` path = `src/01` app = `z2ui5_cl_smp_app_166` )
      ( group = `samples` header = `Binding` sub = `Types for Integer, Decimal, Date and Time` keywords = `type conversion sum amount number field` path = `src/01` app = `z2ui5_cl_smp_app_047` )
      ( group = `samples` header = `Browser` sub = `Copy to Clipboard (A)` keywords = `clipboard paste copy text area` path = `src/01` app = `z2ui5_cl_smp_app_325` )
      ( group = `samples` header = `Browser` sub = `Local and Session Storage (A,C)` keywords = `localstorage sessionstorage persist store_data offline` path = `src/01` app = `z2ui5_cl_smp_app_327` )
      ( group = `samples` header = `Browser` sub = `Logout from the Client (A)` keywords = `logoff signout icf session end fiori launchpad` path = `src/01` app = `z2ui5_cl_smp_app_361` )
      ( group = `samples` header = `Browser` sub = `Open a URL in a New Tab (A)` keywords = `url window open_new_tab link target` path = `src/01` app = `z2ui5_cl_smp_app_073` )
      ( group = `samples` header = `Browser` sub = `Open Mail, Phone and SMS Links (A)` keywords = `mailto tel sms urlhelper redirect native link` path = `src/01` app = `z2ui5_cl_smp_app_316` )
      ( group = `samples` header = `Browser` sub = `Reload the Page (A)` keywords = `reload refresh restart location_reload url` path = `src/01` app = `z2ui5_cl_smp_app_492` )
      ( group = `samples` header = `Browser` sub = `Set the Tab Favicon (A)` keywords = `favicon icon tab image data uri` path = `src/01` app = `z2ui5_cl_smp_app_491` )
      ( group = `samples` header = `Browser` sub = `Set the Tab Title (A)` keywords = `document.title tab caption headline set_title` path = `src/01` app = `z2ui5_cl_smp_app_125` )
      ( group = `samples` header = `Browser` sub = `Soft Keyboard Mode on Mobile (A)` keywords = `mobile numeric keypad keyboard_set_mode phone input` path = `src/01` app = `z2ui5_cl_smp_app_352` )
      ( group = `samples` header = `Control` sub = `Expand a Panel by ID (setExpanded) (A)` keywords = `panel collapse expand setexpanded control_by_id whitelisted` path = `src/01` app = `z2ui5_cl_smp_app_448` )
      ( group = `samples` header = `Control` sub = `MultiInput with Tokens (C)` keywords = `multiinput token tokens suggestion custom control` path = `src/01` app = `z2ui5_cl_smp_app_078` )
      ( group = `samples` header = `Control` sub = `Open the PDF Viewer by ID (A)` keywords = `pdfviewer pdf document viewer popup control_by_id whitelisted` path = `src/01` app = `z2ui5_cl_smp_app_449` )
      ( group = `samples` header = `Control` sub = `Switch NavContainer Page by ID (A)` keywords = `navcontainer icontabbar icontabheader page switch control_by_id whitelisted` path = `src/01` app = `z2ui5_cl_smp_app_088` )
      ( group = `samples` header = `Control` sub = `Wizard with Steps (A)` keywords = `wizard step branching discardprogress setnextstep control_by_id` path = `src/01` app = `z2ui5_cl_smp_app_202` )
      ( group = `samples` header = `CSS` sub = `Color Table Cells from the Backend` keywords = `color background conditional formatting style data attribute` path = `src/01` app = `z2ui5_cl_smp_app_305` )
      ( group = `samples` header = `CSS` sub = `FlexBox Layouts with Custom Classes` keywords = `flexbox layout responsive navigation tile panel` path = `src/01` app = `z2ui5_cl_smp_app_255` )
      ( group = `samples` header = `CSS` sub = `Ship Your Own CSS with the View` keywords = `style stylesheet inline html class own design` path = `src/01` app = `z2ui5_cl_smp_app_050` )
      ( group = `samples` header = `Device` sub = `Camera, Take Photos (C)` keywords = `camera photo picture webcam capture facing mode` path = `src/01` app = `z2ui5_cl_smp_app_306` )
      ( group = `samples` header = `Device` sub = `Device Model: Phone, Tablet, Desktop (A)` keywords = `sap.ui.device responsive orientation resize media model` path = `src/01` app = `z2ui5_cl_smp_app_445` )
      ( group = `samples` header = `Device` sub = `Frontend Info: UI5 Version, Theme, OS, Browser` keywords = `client info ui5 version theme os user agent device` path = `src/01` app = `z2ui5_cl_smp_app_122` )
      ( group = `samples` header = `Device` sub = `Geolocation from the Browser (C)` keywords = `gps position latitude longitude altitude location` path = `src/01` app = `z2ui5_cl_smp_app_120` )
      ( group = `samples` header = `Event` sub = `Control Objects in t_arg (FacetFilter)` keywords = `facetfilter filter object marshalling selected items` path = `src/01` app = `z2ui5_cl_smp_app_197` )
      ( group = `samples` header = `Event` sub = `Extra Arguments with t_arg` keywords = `argument parameter payload event data fixed value` path = `src/01` app = `z2ui5_cl_smp_app_167` )
      ( group = `samples` header = `Event` sub = `Keyboard Shortcuts, Ctrl+S (A)` keywords = `shortcut hotkey ctrl key combination keyboard_shortcut` path = `src/01` app = `z2ui5_cl_smp_app_471` )
      ( group = `samples` header = `Event` sub = `Link with preventDefault (A)` keywords = `link href default action check_prevent_default` path = `src/01` app = `z2ui5_cl_smp_app_472` )
      ( group = `samples` header = `File` sub = `Download to the Browser (A)` keywords = `export save base64 attachment xstring document` path = `src/01` app = `z2ui5_cl_smp_app_186` )
      ( group = `samples` header = `File` sub = `Upload to the Backend (C)` keywords = `fileuploader base64 attachment import picture document` path = `src/01` app = `z2ui5_cl_smp_app_074` )
      ( group = `samples` header = `Focus` sub = `Focus a Table Cell by Column and Row (A)` keywords = `table cell column row aggregation set_focus` path = `src/01` app = `z2ui5_cl_smp_app_421` )
      ( group = `samples` header = `Focus` sub = `Jump to the Next Input on Enter (A)` keywords = `cursor enter tab next field form set_focus` path = `src/01` app = `z2ui5_cl_smp_app_189` )
      ( group = `samples` header = `Focus` sub = `Set Focus and Select Text in an Input (A)` keywords = `cursor set_focus selection position textfield` path = `src/01` app = `z2ui5_cl_smp_app_133` )
      ( group = `samples` header = `Formatter` sub = `ABAP Date and Time Strings (DATS/TIMS)` keywords = `dats tims conversion initial date 00000000 sy-datum` path = `src/01` app = `z2ui5_cl_smp_app_450` )
      ( group = `samples` header = `Formatter` sub = `Date Object for the DatePicker` keywords = `datepicker datevalue javascript date object iso` path = `src/01` app = `z2ui5_cl_smp_app_457` )
      ( group = `samples` header = `Formatter` sub = `Date Objects for the PlanningCalendar` keywords = `planningcalendar appointment javascript date object iso` path = `src/01` app = `z2ui5_cl_smp_app_456` )
      ( group = `samples` header = `Formatter` sub = `Inline Icons in a Text` keywords = `icon glyph placeholder text status expandinlineicons` path = `src/01` app = `z2ui5_cl_smp_app_466` )
      ( group = `samples` header = `Formatter` sub = `When Not to Use One: Compute in ABAP` keywords = `no formatter computed backend thin frontend prepare` path = `src/01` app = `z2ui5_cl_smp_app_453` )
      ( group = `samples` header = `Grid Table` sub = `Events on Cell Level` keywords = `cell enter row index event grid alv` path = `src/01` app = `z2ui5_cl_smp_app_160` )
      ( group = `samples` header = `Grid Table` sub = `Full Example with sap.ui.table` keywords = `grid alv dynamicpage column row action currency search sort filter` path = `src/01` app = `z2ui5_cl_smp_app_070` )
      ( group = `samples` header = `Grid Table` sub = `Keep Column Filters on Refresh (C)` keywords = `column filter reset refresh uitableext grid alv` path = `src/01` app = `z2ui5_cl_smp_app_143` )
      ( group = `samples` header = `List` sub = `Filter and Sort the Binding from ABAP (A)` keywords = `binding_call getbinding sorter filter follow_up_action` path = `src/01` app = `z2ui5_cl_smp_app_454` )
      ( group = `samples` header = `List` sub = `Live Filter on the Client, No Roundtrip (A)` keywords = `binding_call live search client side no roundtrip filter` path = `src/01` app = `z2ui5_cl_smp_app_455` )
      ( group = `samples` header = `List` sub = `StandardListItem, Highlight and Events` keywords = `sap.m.list standardlistitem highlight infostate press selection` path = `src/01` app = `z2ui5_cl_smp_app_048` )
      ( group = `samples` header = `Menu` sub = `Full Path of the Selected Item (A)` keywords = `menuitem nested submenu textpath controller path` path = `src/01` app = `z2ui5_cl_smp_app_473` )
      ( group = `samples` header = `Menu` sub = `Menu Button with core:require` keywords = `menubutton menuitem popover messagetoast require module` path = `src/01` app = `z2ui5_cl_smp_app_163` )
      ( group = `samples` header = `Message` sub = `Message Model and MessageManager (C)` keywords = `messagemanager validation target field state central model` path = `src/01` app = `z2ui5_cl_smp_app_467` )
      ( group = `samples` header = `Message` sub = `MessageBox from SY, BAPIRET2 or Exception` keywords = `t100 message class number exception cx_root error abend` path = `src/01` app = `z2ui5_cl_smp_app_008` )
      ( group = `samples` header = `Message` sub = `MessageBox, Types and Custom Actions` keywords = `confirm warning error success information dialog action` path = `src/01` app = `z2ui5_cl_smp_app_382` )
      ( group = `samples` header = `Message` sub = `MessagePopover URL Policy (A)` keywords = `url policy link security validator relative allow deny` path = `src/01` app = `z2ui5_cl_smp_app_474` )
      ( group = `samples` header = `Message` sub = `MessageToast, Text and Duration` keywords = `toast notification duration position animation` path = `src/01` app = `z2ui5_cl_smp_app_381` )
      ( group = `samples` header = `Message` sub = `MessageView and MessagePopover (A)` keywords = `messagepopover messageitem dialog grouped message list` path = `src/01` app = `z2ui5_cl_smp_app_452` )
      ( group = `samples` header = `Navigation` sub = `Call and Leave Apps (nav_app_call)` keywords = `nav_app_call nav_app_leave sub app stack call back` path = `src/01` app = `z2ui5_cl_smp_app_024` )
      ( group = `samples` header = `Navigation` sub = `Data Loss Protection on Leaving (A,C)` keywords = `dirty unsaved changes leave confirmation warning` path = `src/01` app = `z2ui5_cl_smp_app_279` )
      ( group = `samples` header = `Navigation` sub = `Return Data and Events to the Caller` keywords = `r_data result get_app_prev return event payload` path = `src/01` app = `z2ui5_cl_smp_app_488` )
      ( group = `samples` header = `Navigation` sub = `Uncaught Error and Error Popup` keywords = `exception dump error handling debugtool restart retry` path = `src/01` app = `z2ui5_cl_smp_app_464` )
      ( group = `samples` header = `Nested View` sub = `Basic Example (nest_view_display)` keywords = `nest_view_display rerender model refresh sub view` path = `src/01` app = `z2ui5_cl_smp_app_065` )
      ( group = `samples` header = `Nested View` sub = `Embed Another App's View` keywords = `sub app class embed instantiate another app rtti` path = `src/01` app = `z2ui5_cl_smp_app_104` )
      ( group = `samples` header = `Nested View` sub = `Master-Detail with FlexibleColumnLayout` keywords = `fcl master detail list report two column split` path = `src/01` app = `z2ui5_cl_smp_app_097` )
      ( group = `samples` header = `Nested View` sub = `Three Columns with FlexibleColumnLayout` keywords = `fcl three column detail detail deep navigation` path = `src/01` app = `z2ui5_cl_smp_app_098` )
      ( group = `samples` header = `Popover` sub = `Basic Example with Placement` keywords = `placement anchor button confirm cancel popover_display` path = `src/01` app = `z2ui5_cl_smp_app_026` )
      ( group = `samples` header = `Popover` sub = `Open from a Table Row` keywords = `list report dynamicpage row link details table` path = `src/01` app = `z2ui5_cl_smp_app_052` )
      ( group = `samples` header = `Popover` sub = `Open Together with the View Build` keywords = `initial render one roundtrip anchor button` path = `src/01` app = `z2ui5_cl_smp_app_490` )
      ( group = `samples` header = `Popover` sub = `QuickView Contact Card` keywords = `quickview contact card links grouped fields` path = `src/01` app = `z2ui5_cl_smp_app_109` )
      ( group = `samples` header = `Popover` sub = `Select from a List` keywords = `list selection placement anchor` path = `src/01` app = `z2ui5_cl_smp_app_081` )
      ( group = `samples` header = `Popover` sub = `Toggle by ID (toggleBy) (A)` keywords = `toggleby open close control_by_id whitelisted` path = `src/01` app = `z2ui5_cl_smp_app_465` )
      ( group = `samples` header = `Popup` sub = `Dialog inside a Dialog` keywords = `nested stack popup in popup second dialog` path = `src/01` app = `z2ui5_cl_smp_app_161` )
      ( group = `samples` header = `Popup` sub = `Element Binding to the Selected Row (A)` keywords = `element binding relative path aggregation dialog row` path = `src/01` app = `z2ui5_cl_smp_app_470` )
      ( group = `samples` header = `Popup` sub = `Navigate between Dialogs (NavContainer) (A)` keywords = `navcontainer dialog pages back forward` path = `src/01` app = `z2ui5_cl_smp_app_170` )
      ( group = `samples` header = `Popup` sub = `Value Help: Suggestions and F4 Dialog` keywords = `f4 search help suggestion input dialog select` path = `src/01` app = `z2ui5_cl_smp_app_009` )
      ( group = `samples` header = `Popup` sub = `Ways to Open a Dialog (A)` keywords = `dialog sub app destroy rerender background view` path = `src/01` app = `z2ui5_cl_smp_app_012` )
      ( group = `samples` header = `Scroll` sub = `Scroll a Control into View (A)` keywords = `scroll_into_view control id validation jump` path = `src/01` app = `z2ui5_cl_smp_app_363` )
      ( group = `samples` header = `Scroll` sub = `Scroll to a Pixel Position (A)` keywords = `position pixel scroll_to restore refresh toolbar` path = `src/01` app = `z2ui5_cl_smp_app_362` )
      ( group = `samples` header = `Table` sub = `Drag and Drop Rows (A)` keywords = `dnd dragdropinfo reorder rows move` path = `src/01` app = `z2ui5_cl_smp_app_459` )
      ( group = `samples` header = `Table` sub = `Editable Cells, Add and Delete Rows` keywords = `edit input add row delete multiselect toolbar` path = `src/01` app = `z2ui5_cl_smp_app_011` )
      ( group = `samples` header = `Table` sub = `Filter Rows in the Backend` keywords = `filter server side form growing where` path = `src/01` app = `z2ui5_cl_smp_app_045` )
      ( group = `samples` header = `Table` sub = `Large Table with Growing and ScrollContainer` keywords = `growing 10000 rows sticky toolbar sort performance` path = `src/01` app = `z2ui5_cl_smp_app_006` )
      ( group = `samples` header = `Table` sub = `Live Search with Parallel Requests` keywords = `live search parallel requests busy queue typing` path = `src/01` app = `z2ui5_cl_smp_app_059` )
      ( group = `samples` header = `Table` sub = `Search in the Backend (SearchField)` keywords = `search go enter server side where` path = `src/01` app = `z2ui5_cl_smp_app_053` )
      ( group = `samples` header = `Table` sub = `Selection Modes: Single and Multi Select` keywords = `selectionmode none single multi segmentedbutton checkbox` path = `src/01` app = `z2ui5_cl_smp_app_019` )
      ( group = `samples` header = `Templating` sub = `Build Columns Dynamically (template:repeat)` keywords = `template repeat runtime generated columns if then else` path = `src/01` app = `z2ui5_cl_smp_app_173` )
      ( group = `samples` header = `Templating` sub = `Dynamic Content in a Nested View` keywords = `template repeat runtime generated nested nest_view_display` path = `src/01` app = `z2ui5_cl_smp_app_176` )
      ( group = `samples` header = `Timer` sub = `Progress Indicator during a Backend Call (A)` keywords = `progressindicator busy wait long running backend` path = `src/01` app = `z2ui5_cl_smp_app_064` )
      ( group = `samples` header = `Timer` sub = `Refresh the View Every n Seconds (A)` keywords = `interval polling auto refresh follow_up_action seconds` path = `src/01` app = `z2ui5_cl_smp_app_028` )
      ( group = `samples` header = `Tree` sub = `Drag and Drop Nodes (A,C)` keywords = `dnd move node hierarchy binding context` path = `src/01` app = `z2ui5_cl_smp_app_461` )
      ( group = `samples` header = `Tree` sub = `Editable Nodes with CustomTreeItem (C)` keywords = `customtreeitem rename input binding write back` path = `src/01` app = `z2ui5_cl_smp_app_463` )
      ( group = `samples` header = `Tree` sub = `Inside a Dialog (C)` keywords = `popup expand state hierarchy nodes` path = `src/01` app = `z2ui5_cl_smp_app_462` )
      ( group = `samples` header = `Tree` sub = `Nested ABAP Table in a sap.m.Tree` keywords = `hierarchy nodes nested json items` path = `src/01` app = `z2ui5_cl_smp_app_460` ) ).

  ENDMETHOD.


  METHOD catalog_filter.

    IF search IS INITIAL.
      result = t_catalog.
      RETURN.
    ENDIF.

    DATA(pattern) = to_upper( search ).
    LOOP AT t_catalog INTO DATA(tile).

      IF to_upper( |{ tile-header } { tile-sub } { tile-keywords } { tile-app }| ) CS pattern.
        INSERT tile INTO TABLE result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD block_widths.

    LOOP AT t_catalog INTO DATA(tile).

      DATA(base) = block_base( group  = tile-group
                               header = tile-header ).
      READ TABLE result ASSIGNING FIELD-SYMBOL(<block>)
        WITH KEY group = tile-group
                 base  = base.

      IF sy-subrc <> 0.
        INSERT VALUE #( group = tile-group
                        base  = base ) INTO TABLE result ASSIGNING <block>.
      ENDIF.

      DATA(width) = header_width( tile-header ).

      IF width > <block>-width.
        <block>-width = width.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD header_width.

    " estimated render width in 1/100 em, weighted per character class
    DATA(off) = 0.
    WHILE off < strlen( header ).

      DATA(char) = substring( val = header
                              off = off
                              len = 1 ).
      result = result + COND i( WHEN char CA `MW` THEN 95
                                WHEN char CA `mw` THEN 80
                                WHEN char CA `ijltfrI. -` THEN 35
                                WHEN char CA `ABCDEFGHJKLNOPQRSTUVXYZ` THEN 75
                                ELSE 55 ).
      off = off + 1.

    ENDWHILE.

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


  METHOD block_base.

    " In the controls section a block groups all controls that share the same
    " first letter, so a blank line separates letter groups only (Button,
    " ButtonGroup | Carousel). Elsewhere a block is the header without a
    " trailing Roman numeral, if a header ever carries one - today every
    " Basic header is its own block.
    IF group CP `controls -*`.
      result = to_upper( substring( val = header
                                    off = 0
                                    len = 1 ) ).
    ELSE.
      result = header_base( header ).
    ENDIF.

  ENDMETHOD.


  METHOD group_titles_needed.

    " A group heading only tells the reader something when there is more than
    " one group to tell apart. With every sample in a single package it would
    " just repeat the page title, so it is left out.
    DATA first_group TYPE string.
    LOOP AT t_catalog INTO DATA(tile).

      IF sy-tabix = 1.
        first_group = tile-group.

      ELSEIF tile-group <> first_group.
        result = abap_true.
        RETURN.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
