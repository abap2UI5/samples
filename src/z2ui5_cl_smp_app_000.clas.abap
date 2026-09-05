" @keywords overview launchpad catalogue index all samples search start tiles
" @summary Every sample in this repository as a searchable tile, grouped the way the folders are - the app the other 149 are reached from.
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
      DATA tenths TYPE i.
      DATA temp6 LIKE LINE OF t_blocks.
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

      
      base = block_base( group  = tile-group
                               header = tile-header ).
      
      new_block = abap_false.

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
      
      
      
      temp7 = sy-tabix.
      READ TABLE t_blocks WITH KEY group = tile-group base = base INTO temp6.
      sy-tabix = temp7.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      tenths = ( temp6-width + 45 ) DIV 10.
      
      width = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      
      IF new_block = abap_true.
        temp5 = `sapUiSmallMarginBegin sapUiSmallMarginTop`.
      ELSE.
        temp5 = `sapUiSmallMarginBegin`.
      ENDIF.
      
      row = page->ele( `HBox`
          )->a( n = `class`      v = temp5
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
        DATA temp8 TYPE string_table.
    DATA temp10 TYPE string.
    DATA css_class LIKE temp10.
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
        
        CLEAR temp6.
        INSERT target INTO TABLE temp6.
        press = client->_event( val   = cs_event-nav
                                t_arg = temp6 ).

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
        
        CLEAR temp8.
        INSERT class INTO TABLE temp8.
        INSERT href INTO TABLE temp8.
        INSERT name INTO TABLE temp8.
        press = client->_event( val   = cs_event-install
                                t_arg = temp8 ).

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
      temp10 = `sapUiMediumMarginBegin sapUiTinyMarginEnd`.
    ELSE.
      temp10 = `sapUiTinyMarginBeginEnd`.
    ENDIF.
    
    css_class = temp10.

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

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
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
    DATA temp11 TYPE string_table.
    DATA temp8 LIKE LINE OF temp11.
    CLEAR temp11.
    INSERT `REDIRECT` INTO TABLE temp11.
    
    temp8 = |\{ URL: '{ href }', NEW_WINDOW: true \}|.
    INSERT temp8 INTO TABLE temp11.
    result = client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-urlhelper
        t_arg = temp11 ).

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

    DATA temp13 TYPE z2ui5_cl_smp_app_000=>ty_t_tile.
    DATA temp14 LIKE LINE OF temp13.
    CLEAR temp13.
    
    temp14-group = `samples`.
    temp14-header = `Basics I`.
    temp14-sub = `Hello World, the Smallest App`.
    temp14-keywords = `hello world smallest first app minimal start here template`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_493`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Basics II`.
    temp14-sub = `Data Binding: Input and Button`.
    temp14-keywords = `binding _bind model attribute value input button roundtrip messagebox serialize`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_494`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Basics III`.
    temp14-sub = `Lifecycle: Init, Event, Navigated`.
    temp14-keywords = `lifecycle roundtrip main dispatcher state serialize check_on_init check_on_event check_on_navigated`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_495`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Basics IV`.
    temp14-sub = `Events, Views and Roundtrips`.
    temp14-keywords = `roundtrip restart second view uncaught error controller basics`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_004`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Basics V`.
    temp14-sub = `The Developer Tools (Ctrl+F12)`.
    temp14-keywords = `developer tools devtools ctrl f12 debug inspect payload previous request response view xml view model source code log error adt export`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_496`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Basics VI`.
    temp14-sub = `Unit Tests for the App Logic`.
    temp14-keywords = `unit test abapunit testclasses assert testable logic method`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_503`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `A View Built From RTTI, No Field Named`.
    temp14-keywords = `rtti generic view runtime columns get_components describe_by_data no field name itab structure column cell binding`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_497`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Currency Amounts (sap.ui.model.type.Currency)`.
    temp14-keywords = `amount decimals leading zeros number format`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_067`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Dynamic Table Typed at Runtime (RTTI)`.
    temp14-keywords = `generic data reference create data ddic dynamic itab`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_061`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Expression Binding, Types and Composite Parts`.
    temp14-keywords = `formatter parts conditional regexp visible enabled syntax`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_027`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Model setSizeLimit for Large Tables (A)`.
    temp14-keywords = `combobox jsonmodel size limit large itab 100 entries`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_071`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Single Table Cell (tab_index)`.
    temp14-keywords = `cell input internal table row field level`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_144`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Structure Fields and INCLUDEs`.
    temp14-keywords = `structure component include flat form level`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_166`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Binding`.
    temp14-sub = `Types for Integer, Decimal, Date and Time`.
    temp14-keywords = `type conversion sum amount number field`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_047`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Copy to Clipboard (A)`.
    temp14-keywords = `clipboard paste copy text area`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_325`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Local and Session Storage (A,C)`.
    temp14-keywords = `localstorage sessionstorage persist store_data offline`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_327`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Logout from the Client (A)`.
    temp14-keywords = `logoff signout icf session end fiori launchpad`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_361`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Open a URL in a New Tab (A)`.
    temp14-keywords = `url window open_new_tab link target`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_073`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Open Mail, Phone and SMS Links (A)`.
    temp14-keywords = `mailto tel sms urlhelper redirect native link`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_316`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Reload the Page (A)`.
    temp14-keywords = `reload refresh restart location_reload url`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_492`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Set the Tab Favicon (A)`.
    temp14-keywords = `favicon icon tab image data uri`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_491`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Set the Tab Title (A)`.
    temp14-keywords = `document.title tab caption headline set_title`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_125`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Browser`.
    temp14-sub = `Soft Keyboard Mode on Mobile (A)`.
    temp14-keywords = `mobile numeric keypad keyboard_set_mode phone input`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_352`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Control Behaviour`.
    temp14-sub = `Expand a Panel by ID (setExpanded) (A)`.
    temp14-keywords = `panel collapse expand setexpanded control_by_id whitelisted`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_448`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Control Behaviour`.
    temp14-sub = `MultiInput with Tokens (C)`.
    temp14-keywords = `multiinput token tokens suggestion custom control`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_078`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Control Behaviour`.
    temp14-sub = `Open the PDF Viewer by ID (A)`.
    temp14-keywords = `pdfviewer pdf document viewer popup control_by_id whitelisted`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_449`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Control Behaviour`.
    temp14-sub = `Switch NavContainer Page by ID (A)`.
    temp14-keywords = `navcontainer icontabbar icontabheader page switch control_by_id whitelisted`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_088`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Control Behaviour`.
    temp14-sub = `Wizard with Steps (A)`.
    temp14-keywords = `wizard step branching discardprogress setnextstep control_by_id`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_202`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `CSS`.
    temp14-sub = `Color Table Cells from the Backend`.
    temp14-keywords = `color background conditional formatting style data attribute`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_305`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `CSS`.
    temp14-sub = `FlexBox Layouts with Custom Classes`.
    temp14-keywords = `flexbox layout responsive navigation tile panel`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_255`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `CSS`.
    temp14-sub = `Ship Your Own CSS with the View`.
    temp14-keywords = `style stylesheet inline html class own design`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_050`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Device`.
    temp14-sub = `Camera, Take Photos (C)`.
    temp14-keywords = `camera photo picture webcam capture facing mode`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_306`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Device`.
    temp14-sub = `Device Model: Phone, Tablet, Desktop (A)`.
    temp14-keywords = `sap.ui.device responsive orientation resize media model`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_445`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Device`.
    temp14-sub = `Frontend Info: UI5 Version, Theme, OS, Browser`.
    temp14-keywords = `client info ui5 version theme os user agent device`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_122`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Device`.
    temp14-sub = `Geolocation from the Browser (C)`.
    temp14-keywords = `gps position latitude longitude altitude location`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_120`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Event`.
    temp14-sub = `Control Objects in t_arg (FacetFilter)`.
    temp14-keywords = `facetfilter filter object marshalling selected items`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_197`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Event`.
    temp14-sub = `Extra Arguments with t_arg`.
    temp14-keywords = `argument parameter payload event data fixed value`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_167`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Event`.
    temp14-sub = `Keyboard Shortcuts, Ctrl+S (A)`.
    temp14-keywords = `shortcut hotkey ctrl key combination keyboard_shortcut`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_471`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Event`.
    temp14-sub = `Link with preventDefault (A)`.
    temp14-keywords = `link href default action check_prevent_default`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_472`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `File`.
    temp14-sub = `Download to the Browser (A)`.
    temp14-keywords = `export save base64 attachment xstring document`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_186`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `File`.
    temp14-sub = `Upload to the Backend (C)`.
    temp14-keywords = `fileuploader base64 attachment import picture document`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_074`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Focus`.
    temp14-sub = `Focus a Table Cell by Column and Row (A)`.
    temp14-keywords = `table cell column row aggregation set_focus`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_421`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Focus`.
    temp14-sub = `Jump to the Next Input on Enter (A)`.
    temp14-keywords = `cursor enter tab next field form set_focus`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_189`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Focus`.
    temp14-sub = `Set Focus and Select Text in an Input (A)`.
    temp14-keywords = `cursor set_focus selection position textfield`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_133`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Formatter`.
    temp14-sub = `ABAP Date and Time Strings (DATS/TIMS)`.
    temp14-keywords = `dats tims conversion initial date 00000000 sy-datum`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_450`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Formatter`.
    temp14-sub = `Date Object for the DatePicker`.
    temp14-keywords = `datepicker datevalue javascript date object iso`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_457`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Formatter`.
    temp14-sub = `Date Objects for the PlanningCalendar`.
    temp14-keywords = `planningcalendar appointment javascript date object iso`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_456`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Formatter`.
    temp14-sub = `Inline Icons in a Text`.
    temp14-keywords = `icon glyph placeholder text status expandinlineicons`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_466`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Formatter`.
    temp14-sub = `When Not to Use One: Compute in ABAP`.
    temp14-keywords = `no formatter computed backend thin frontend prepare`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_453`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Grid Table`.
    temp14-sub = `Events on Cell Level`.
    temp14-keywords = `cell enter row index event grid alv`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_160`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Grid Table`.
    temp14-sub = `Full Example with sap.ui.table`.
    temp14-keywords = `grid alv dynamicpage column row action currency search sort filter`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_070`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Grid Table`.
    temp14-sub = `Keep Column Filters on Refresh (C)`.
    temp14-keywords = `column filter reset refresh uitableext grid alv`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_143`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Hash`.
    temp14-sub = `App State, Bookmark and Share`.
    temp14-keywords = `app state url bookmark share clipboard copy link restore deep link reload app_state_set_active app_state_get_href sap-iapp-state sap-xapp-state`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_498`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Hash`.
    temp14-sub = `App-Owned Routing (#/detail)`.
    temp14-keywords = `routing hash url page browser back forward history deep link reload hash_set hash_replace hash_back hash_attach_changed navcontainer router onnavback`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_499`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Hash`.
    temp14-sub = `Routing mode fresh`.
    temp14-keywords = `routing mode fresh navigation restart new instance nav_app_call`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_468`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Hash`.
    temp14-sub = `Routing mode keep`.
    temp14-keywords = `routing mode keep navigation state preserved back nav_app_call`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_480`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `List`.
    temp14-sub = `Filter and Sort the Binding from ABAP (A)`.
    temp14-keywords = `binding_call getbinding sorter filter follow_up_action`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_454`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `List`.
    temp14-sub = `Live Filter on the Client, No Roundtrip (A)`.
    temp14-keywords = `binding_call live search client side no roundtrip filter`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_455`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `List`.
    temp14-sub = `StandardListItem, Highlight and Events`.
    temp14-keywords = `sap.m.list standardlistitem highlight infostate press selection`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_048`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Menu`.
    temp14-sub = `Full Path of the Selected Item (A)`.
    temp14-keywords = `menuitem nested submenu textpath controller path`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_473`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Menu`.
    temp14-sub = `Menu Button with core:require`.
    temp14-keywords = `menubutton menuitem popover messagetoast require module`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_163`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `Message Model and MessageManager (C)`.
    temp14-keywords = `messagemanager validation target field state central model`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_467`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `MessageBox for Any Data`.
    temp14-keywords = `messagebox details table structure tree object reference escape limit action onclose`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_502`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `MessageBox from SY, BAPIRET2 or Exception`.
    temp14-keywords = `t100 message class number exception cx_root error abend`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_008`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `MessageBox, Types and Custom Actions`.
    temp14-keywords = `confirm warning error success information dialog action`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_382`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `MessagePopover URL Policy (A)`.
    temp14-keywords = `url policy link security validator relative allow deny`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_474`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `MessageToast, Text and Duration`.
    temp14-keywords = `toast notification duration position animation`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_381`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Message`.
    temp14-sub = `MessageView and MessagePopover (A)`.
    temp14-keywords = `messagepopover messageitem dialog grouped message list`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_452`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Navigation`.
    temp14-sub = `Call and Leave Apps (nav_app_call)`.
    temp14-keywords = `nav_app_call nav_app_leave sub app stack call back`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_024`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Navigation`.
    temp14-sub = `Data Loss Protection on Leaving (A,C)`.
    temp14-keywords = `dirty unsaved changes leave confirmation warning`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_279`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Navigation`.
    temp14-sub = `Return Data and Events to the Caller`.
    temp14-keywords = `r_data result get_app_prev return event payload`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_488`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Navigation`.
    temp14-sub = `Uncaught Error and Error Popup`.
    temp14-keywords = `exception dump error handling debugtool restart retry`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_464`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Nested View`.
    temp14-sub = `Basic Example (nest_view_display)`.
    temp14-keywords = `nest_view_display rerender model refresh sub view`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_065`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Nested View`.
    temp14-sub = `Embed Another App's View`.
    temp14-keywords = `sub app class embed instantiate another app rtti`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_104`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Nested View`.
    temp14-sub = `Master-Detail with FlexibleColumnLayout`.
    temp14-keywords = `fcl master detail list report two column split`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_097`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Nested View`.
    temp14-sub = `Three Columns with FlexibleColumnLayout`.
    temp14-keywords = `fcl three column detail detail deep navigation`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_098`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popover`.
    temp14-sub = `Basic Example with Placement`.
    temp14-keywords = `placement anchor button confirm cancel popover_display`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_026`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popover`.
    temp14-sub = `Open from a Table Row`.
    temp14-keywords = `list report dynamicpage row link details table`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_052`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popover`.
    temp14-sub = `Open Together with the View Build`.
    temp14-keywords = `initial render one roundtrip anchor button`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_490`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popover`.
    temp14-sub = `QuickView Contact Card`.
    temp14-keywords = `quickview contact card links grouped fields`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_109`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popover`.
    temp14-sub = `Select from a List`.
    temp14-keywords = `list selection placement anchor`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_081`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popover`.
    temp14-sub = `Toggle by ID (toggleBy) (A)`.
    temp14-keywords = `toggleby open close control_by_id whitelisted`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_465`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popup`.
    temp14-sub = `Dialog inside a Dialog`.
    temp14-keywords = `nested stack popup in popup second dialog`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_161`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popup`.
    temp14-sub = `Element Binding to the Selected Row (A)`.
    temp14-keywords = `element binding relative path aggregation dialog row`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_470`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popup`.
    temp14-sub = `Navigate between Dialogs (NavContainer) (A)`.
    temp14-keywords = `navcontainer dialog pages back forward`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_170`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popup`.
    temp14-sub = `Value Help: Suggestions and F4 Dialog`.
    temp14-keywords = `f4 search help suggestion input dialog select`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_009`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Popup`.
    temp14-sub = `Ways to Open a Dialog (A)`.
    temp14-keywords = `dialog sub app destroy rerender background view`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_012`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Scroll`.
    temp14-sub = `Scroll a Control into View (A)`.
    temp14-keywords = `scroll_into_view control id validation jump`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_363`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Scroll`.
    temp14-sub = `Scroll to a Pixel Position (A)`.
    temp14-keywords = `position pixel scroll_to restore refresh toolbar`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_362`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Drag and Drop Rows (A)`.
    temp14-keywords = `dnd dragdropinfo reorder rows move`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_459`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Editable Cells, Add and Delete Rows`.
    temp14-keywords = `edit input add row delete multiselect toolbar`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_011`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Filter Rows in the Backend`.
    temp14-keywords = `filter server side form growing where`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_045`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Large Table with Growing and ScrollContainer`.
    temp14-keywords = `growing 10000 rows sticky toolbar sort performance`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_006`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Live Search with Parallel Requests`.
    temp14-keywords = `live search parallel requests busy queue typing`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_059`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Search in the Backend (SearchField)`.
    temp14-keywords = `search go enter server side where`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_053`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Table`.
    temp14-sub = `Selection Modes: Single and Multi Select`.
    temp14-keywords = `selectionmode none single multi segmentedbutton checkbox`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_019`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Templating`.
    temp14-sub = `Build Columns Dynamically (template:repeat)`.
    temp14-keywords = `template repeat runtime generated columns if then else`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_173`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Templating`.
    temp14-sub = `Dynamic Content in a Nested View`.
    temp14-keywords = `template repeat runtime generated nested nest_view_display`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_176`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Timer`.
    temp14-sub = `Progress Indicator during a Backend Call (A)`.
    temp14-keywords = `progressindicator busy wait long running backend`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_064`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Timer`.
    temp14-sub = `Refresh the View Every n Seconds (A)`.
    temp14-keywords = `interval polling auto refresh follow_up_action seconds`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_028`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Tree`.
    temp14-sub = `Drag and Drop Nodes (A,C)`.
    temp14-keywords = `dnd move node hierarchy binding context`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_461`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Tree`.
    temp14-sub = `Editable Nodes with CustomTreeItem (C)`.
    temp14-keywords = `customtreeitem rename input binding write back`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_463`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Tree`.
    temp14-sub = `Inside a Dialog (C)`.
    temp14-keywords = `popup expand state hierarchy nodes`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_462`.
    INSERT temp14 INTO TABLE temp13.
    temp14-group = `samples`.
    temp14-header = `Tree`.
    temp14-sub = `Nested ABAP Table in a sap.m.Tree`.
    temp14-keywords = `hierarchy nodes nested json items`.
    temp14-path = `src/01`.
    temp14-app = `z2ui5_cl_smp_app_460`.
    INSERT temp14 INTO TABLE temp13.
    result = temp13.

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
        DATA temp15 TYPE z2ui5_cl_smp_app_000=>ty_s_block.
      DATA width TYPE i.
    LOOP AT t_catalog INTO tile.

      
      base = block_base( group  = tile-group
                               header = tile-header ).
      
      READ TABLE result ASSIGNING <block>
        WITH KEY group = tile-group
                 base  = base.

      IF sy-subrc <> 0.
        
        CLEAR temp15.
        temp15-group = tile-group.
        temp15-base = base.
        INSERT temp15 INTO TABLE result ASSIGNING <block>.
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
      DATA temp16 TYPE i.
    off = 0.
    WHILE strlen( header ) > off.

      
      char = substring( val = header
                              off = off
                              len = 1 ).
      
      IF char CA `MW`.
        temp16 = 95.
      ELSEIF char CA `mw`.
        temp16 = 80.
      ELSEIF char CA `ijltfrI. -`.
        temp16 = 35.
      ELSEIF char CA `ABCDEFGHJKLNOPQRSTUVXYZ`.
        temp16 = 75.
      ELSE.
        temp16 = 55.
      ENDIF.
      result = result + temp16.
      off = off + 1.

    ENDWHILE.

  ENDMETHOD.


  METHOD header_base.
    DATA words TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA n TYPE i.
    DATA temp17 LIKE LINE OF words.
    DATA temp18 LIKE sy-tabix.
    DATA temp9 LIKE LINE OF words.
    DATA temp10 LIKE sy-tabix.

    result = header.
    
    SPLIT header AT ` ` INTO TABLE words.
    
    n = lines( words ).

    
    
    temp18 = sy-tabix.
    READ TABLE words INDEX n INTO temp17.
    sy-tabix = temp18.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp10 = sy-tabix.
    READ TABLE words INDEX n INTO temp9.
    sy-tabix = temp10.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    IF n > 1 AND temp17 IS NOT INITIAL AND temp9 CO `IVXLCDM`.

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
