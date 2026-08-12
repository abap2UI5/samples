CLASS z2ui5_cl_smp_app_000 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA search TYPE string.

    TYPES:
      BEGIN OF ty_s_tile,
        group  TYPE string,
        header TYPE string,
        sub    TYPE string,
        app    TYPE string,
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

    ELSEIF client->check_on_navigated( ).

      scroll_restore( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `SEARCH`.

        view_display( ).
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( `search` )
                             ( |{ strlen( search ) }| )
                             ( |{ strlen( search ) }| ) ) ).

      WHEN OTHERS.

        TRY.
            DATA(classname) = to_upper( client->get_event( ) ).
            DATA li_app TYPE REF TO z2ui5_if_app.
            CREATE OBJECT li_app TYPE (classname).
            s_scroll = CORRESPONDING #( client->get( )-s_scroll-main ).
            client->nav_app_call( li_app ).
          CATCH cx_root ##NO_HANDLER.
        ENDTRY.

    ENDCASE.

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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        id             = `page`
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `GitHub`
           target = `_blank`
           href   = `https://github.com/abap2UI5/samples` ).

    page->message_strip(
        text     = |All { lines( t_catalog_all ) } abap2UI5 samples - bindings, events, popups, tables, trees | &&
                   `and framework actions. Filter with the search field, select a link to open a sample, the back ` &&
                   `button returns here. Markers: (A) frontend action, (C) custom control.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->search_field(
        id          = `search`
        value       = client->_bind( search )
        search      = client->_event( `SEARCH` )
        width       = `17.5rem`
        placeholder = `Filter samples`
        class       = `sapUiSmallMarginBegin sapUiSmallMarginBottom` ).

    DATA(show_groups) = group_titles_needed( t_catalog ).
    DATA(prev_group) = ``.
    DATA(prev_base) = ``.

    LOOP AT t_catalog INTO DATA(tile).

      DATA(base) = block_base( group  = tile-group
                               header = tile-header ).
      DATA(new_block) = abap_false.

      IF tile-group <> prev_group.

        IF show_groups = abap_true.
          page->title(
              text  = tile-group
              level = `H3`
              class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
        ENDIF.
        prev_group = tile-group.

      ELSEIF base <> prev_base.
        new_block = abap_true.
      ENDIF.

      prev_base = base.

      " widest header of the block plus roughly one space, in 1/100 em
      DATA(tenths) = ( t_blocks[ group = tile-group base = base ]-width + 45 ) DIV 10.
      DATA(width) = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      DATA(row) = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = COND #( WHEN new_block = abap_true
                               THEN `sapUiSmallMarginBegin sapUiSmallMarginTop`
                               ELSE `sapUiSmallMarginBegin` ) ).

      IF tile-sub IS INITIAL.
        row->link(
            text  = tile-header
            width = width
            press = client->_event( tile-app ) ).

      ELSE.
        row->link(
            text  = tile-header
            width = width
            press = client->_event( tile-app )
            )->text( tile-sub ).
      ENDIF.

    ENDLOOP.

    IF t_catalog IS INITIAL.
      page->text(
          text  = `No sample matches the filter.`
          class = `sapUiSmallMarginBegin` ).
    ENDIF.

    " a few blank lines so the last tiles do not end glued to the page bottom
    page->vbox( height = `4rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( group = `samples` header = `Binding` sub = `Expression Binding` app = `z2ui5_cl_smp_app_027` )
      ( group = `samples` header = `Binding` sub = `Formatting Currencies` app = `z2ui5_cl_smp_app_067` )
      ( group = `samples` header = `Binding` sub = `Formatting Integers, Decimals, Dates & Time` app = `z2ui5_cl_smp_app_047` )
      ( group = `samples` header = `Binding` sub = `Level Structure/Component` app = `z2ui5_cl_smp_app_166` )
      ( group = `samples` header = `Binding` sub = `Level Table/Cell` app = `z2ui5_cl_smp_app_144` )
      ( group = `samples` header = `Browser` sub = `Clipboard (A)` app = `z2ui5_cl_smp_app_325` )
      ( group = `samples` header = `Browser` sub = `Favicon (A)` app = `z2ui5_cl_smp_app_491` )
      ( group = `samples` header = `Browser` sub = `Geolocation (C)` app = `z2ui5_cl_smp_app_120` )
      ( group = `samples` header = `Browser` sub = `Hide/Show Soft Keyboard (A)` app = `z2ui5_cl_smp_app_352` )
      ( group = `samples` header = `Browser` sub = `Logout (A)` app = `z2ui5_cl_smp_app_361` )
      ( group = `samples` header = `Browser` sub = `Open an URL in a new tab (A)` app = `z2ui5_cl_smp_app_073` )
      ( group = `samples` header = `Browser` sub = `Open Telephone, Email etc. (A)` app = `z2ui5_cl_smp_app_316` )
      ( group = `samples` header = `Browser` sub = `Reload Page (A)` app = `z2ui5_cl_smp_app_492` )
      ( group = `samples` header = `Browser` sub = `Storage Local/Session (A,C)` app = `z2ui5_cl_smp_app_327` )
      ( group = `samples` header = `Browser` sub = `Title (A)` app = `z2ui5_cl_smp_app_125` )
      ( group = `samples` header = `Control` sub = `CameraSelector (C)` app = `z2ui5_cl_smp_app_306` )
      ( group = `samples` header = `Control` sub = `File Uploader (C)` app = `z2ui5_cl_smp_app_074` )
      ( group = `samples` header = `Control` sub = `Multi Input (C)` app = `z2ui5_cl_smp_app_078` )
      ( group = `samples` header = `Control` sub = `NavContainer (A)` app = `z2ui5_cl_smp_app_088` )
      ( group = `samples` header = `Control` sub = `NavContainer in Popup (A)` app = `z2ui5_cl_smp_app_170` )
      ( group = `samples` header = `Control` sub = `Panel, setExpanded (A)` app = `z2ui5_cl_smp_app_448` )
      ( group = `samples` header = `Control` sub = `PDF Viewer Display (A)` app = `z2ui5_cl_smp_app_449` )
      ( group = `samples` header = `Control` sub = `Wizard Control (A)` app = `z2ui5_cl_smp_app_202` )
      ( group = `samples` header = `CSS` sub = `Cell Coloring` app = `z2ui5_cl_smp_app_305` )
      ( group = `samples` header = `CSS` sub = `Flex Box with Navigation Examples` app = `z2ui5_cl_smp_app_255` )
      ( group = `samples` header = `CSS` sub = `Send your own CSS to the frontend` app = `z2ui5_cl_smp_app_050` )
      ( group = `samples` header = `Event` sub = `Additional Info with t_arg` app = `z2ui5_cl_smp_app_167` )
      ( group = `samples` header = `Event` sub = `Facet Filter t_arg with Objects` app = `z2ui5_cl_smp_app_197` )
      ( group = `samples` header = `Event` sub = `Handle events & change the view` app = `z2ui5_cl_smp_app_004` )
      ( group = `samples` header = `Focus` sub = `Focus Aggregations (A)` app = `z2ui5_cl_smp_app_421` )
      ( group = `samples` header = `Focus` sub = `Jump with the focus (A)` app = `z2ui5_cl_smp_app_189` )
      ( group = `samples` header = `Focus` sub = `Set Focus in Textfield (A)` app = `z2ui5_cl_smp_app_133` )
      ( group = `samples` header = `Formatter` sub = `ABAP date strings (DATS/TIMS)` app = `z2ui5_cl_smp_app_450` )
      ( group = `samples` header = `Formatter` sub = `Date Object for DatePicker` app = `z2ui5_cl_smp_app_457` )
      ( group = `samples` header = `Formatter` sub = `Date Objects for PlanningCalendar` app = `z2ui5_cl_smp_app_456` )
      ( group = `samples` header = `Formatter` sub = `Inline Icons` app = `z2ui5_cl_smp_app_466` )
      ( group = `samples` header = `Formatter` sub = `Thin frontend, computed in ABAP` app = `z2ui5_cl_smp_app_453` )
      ( group = `samples` header = `Function` sub = `Data Loss Protection (A,C)` app = `z2ui5_cl_smp_app_279` )
      ( group = `samples` header = `Function` sub = `File Download to the Frontend (A)` app = `z2ui5_cl_smp_app_186` )
      ( group = `samples` header = `Function` sub = `Keyboard Shortcuts (A)` app = `z2ui5_cl_smp_app_471` )
      ( group = `samples` header = `Function` sub = `Link with preventDefault (A)` app = `z2ui5_cl_smp_app_472` )
      ( group = `samples` header = `Function` sub = `Menu Item Path (A)` app = `z2ui5_cl_smp_app_473` )
      ( group = `samples` header = `Function` sub = `MessagePopover URL Policy (A)` app = `z2ui5_cl_smp_app_474` )
      ( group = `samples` header = `Function` sub = `Read Frontend Info` app = `z2ui5_cl_smp_app_122` )
      ( group = `samples` header = `List` sub = `Events & Visualization` app = `z2ui5_cl_smp_app_048` )
      ( group = `samples` header = `List` sub = `Frontend Filter/Sort via Backend Event (A)` app = `z2ui5_cl_smp_app_454` )
      ( group = `samples` header = `List` sub = `Frontend Live Filter without Backend (A)` app = `z2ui5_cl_smp_app_455` )
      ( group = `samples` header = `Message` sub = `Backend Processing` app = `z2ui5_cl_smp_app_008` )
      ( group = `samples` header = `Message` sub = `Message Model & Manager (C)` app = `z2ui5_cl_smp_app_467` )
      ( group = `samples` header = `Message` sub = `MessageBox` app = `z2ui5_cl_smp_app_382` )
      ( group = `samples` header = `Message` sub = `MessageToast` app = `z2ui5_cl_smp_app_381` )
      ( group = `samples` header = `Message` sub = `MessageView (A)` app = `z2ui5_cl_smp_app_452` )
      ( group = `samples` header = `Model` sub = `Device Model (A)` app = `z2ui5_cl_smp_app_445` )
      ( group = `samples` header = `Model` sub = `Set Size Limit (A)` app = `z2ui5_cl_smp_app_071` )
      ( group = `samples` header = `More` sub = `Generic Data Reference` app = `z2ui5_cl_smp_app_061` )
      ( group = `samples` header = `More` sub = `Require Object in XML View` app = `z2ui5_cl_smp_app_163` )
      ( group = `samples` header = `Navigation` sub = `Call and Leave Apps` app = `z2ui5_cl_smp_app_024` )
      ( group = `samples` header = `Navigation` sub = `Exchange Data and Event between Apps` app = `z2ui5_cl_smp_app_488` )
      ( group = `samples` header = `Navigation` sub = `Uncaught Error` app = `z2ui5_cl_smp_app_464` )
      ( group = `samples` header = `Nested Views` sub = `Basic Example` app = `z2ui5_cl_smp_app_065` )
      ( group = `samples` header = `Nested Views` sub = `Head & Item Table` app = `z2ui5_cl_smp_app_097` )
      ( group = `samples` header = `Nested Views` sub = `Head & Item Table & Detail` app = `z2ui5_cl_smp_app_098` )
      ( group = `samples` header = `Nested Views` sub = `Sub-App` app = `z2ui5_cl_smp_app_104` )
      ( group = `samples` header = `Popover` sub = `Display Quick View` app = `z2ui5_cl_smp_app_109` )
      ( group = `samples` header = `Popover` sub = `Display Toggle (A)` app = `z2ui5_cl_smp_app_465` )
      ( group = `samples` header = `Popover` sub = `Item Level of Table` app = `z2ui5_cl_smp_app_052` )
      ( group = `samples` header = `Popover` sub = `List to select in Popover` app = `z2ui5_cl_smp_app_081` )
      ( group = `samples` header = `Popover` sub = `Opened with the View Build` app = `z2ui5_cl_smp_app_490` )
      ( group = `samples` header = `Popover` sub = `Simple Example` app = `z2ui5_cl_smp_app_026` )
      ( group = `samples` header = `Popup` sub = `Aggregation binding to the selected row (A)` app = `z2ui5_cl_smp_app_470` )
      ( group = `samples` header = `Popup` sub = `Different ways of calling Popups (A)` app = `z2ui5_cl_smp_app_012` )
      ( group = `samples` header = `Popup` sub = `Popup in Popup - Backend Stack Handling` app = `z2ui5_cl_smp_app_161` )
      ( group = `samples` header = `Popup` sub = `Value Help with Popups` app = `z2ui5_cl_smp_app_009` )
      ( group = `samples` header = `Scroll` sub = `Scroll into view (A)` app = `z2ui5_cl_smp_app_363` )
      ( group = `samples` header = `Scroll` sub = `Scroll to position (A)` app = `z2ui5_cl_smp_app_362` )
      ( group = `samples` header = `Table` sub = `Backend Filter` app = `z2ui5_cl_smp_app_045` )
      ( group = `samples` header = `Table` sub = `Drag and Drop (A)` app = `z2ui5_cl_smp_app_459` )
      ( group = `samples` header = `Table` sub = `Editable` app = `z2ui5_cl_smp_app_011` )
      ( group = `samples` header = `Table` sub = `Live Search via Backend` app = `z2ui5_cl_smp_app_059` )
      ( group = `samples` header = `Table` sub = `Search via Backend` app = `z2ui5_cl_smp_app_053` )
      ( group = `samples` header = `Table` sub = `Selection Modes: Single Select & Multi Select` app = `z2ui5_cl_smp_app_019` )
      ( group = `samples` header = `Table` sub = `Table with ScrollContainer` app = `z2ui5_cl_smp_app_006` )
      ( group = `samples` header = `Templating` sub = `Basic Example` app = `z2ui5_cl_smp_app_173` )
      ( group = `samples` header = `Templating` sub = `Nested Views` app = `z2ui5_cl_smp_app_176` )
      ( group = `samples` header = `Timer` sub = `Loading Indicator during Backend WAIT (A)` app = `z2ui5_cl_smp_app_064` )
      ( group = `samples` header = `Timer` sub = `Wait n ms and call the server again (A)` app = `z2ui5_cl_smp_app_028` )
      ( group = `samples` header = `Tree` sub = `Drag and Drop (A,C)` app = `z2ui5_cl_smp_app_461` )
      ( group = `samples` header = `Tree` sub = `Editable with Custom Item (C)` app = `z2ui5_cl_smp_app_463` )
      ( group = `samples` header = `Tree` sub = `Inside Popup (C)` app = `z2ui5_cl_smp_app_462` )
      ( group = `samples` header = `Tree` sub = `Simple` app = `z2ui5_cl_smp_app_460` )
      ( group = `samples` header = `ui.Table` sub = `Default Filtering (C)` app = `z2ui5_cl_smp_app_143` )
      ( group = `samples` header = `ui.Table` sub = `Events on Cell Level` app = `z2ui5_cl_smp_app_160` )
      ( group = `samples` header = `ui.Table` sub = `Full Example` app = `z2ui5_cl_smp_app_070` ) ).

  ENDMETHOD.


  METHOD catalog_filter.

    IF search IS INITIAL.
      result = t_catalog.
      RETURN.
    ENDIF.

    DATA(pattern) = to_upper( search ).
    LOOP AT t_catalog INTO DATA(tile).

      IF to_upper( |{ tile-header } { tile-sub } { tile-app }| ) CS pattern.
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
