CLASS z2ui5_cl_smp_app_000 DEFINITION PUBLIC.

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

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = VALUE #( ( s_scroll-id )
                         ( |{ s_scroll-y }| )
                         ( |{ s_scroll-x }| ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(t_catalog) = get_catalog( ).
    DATA(t_blocks) = block_widths( t_catalog ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        id             = `page`
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(prev_group) = ``.
    DATA(prev_base) = ``.

    LOOP AT t_catalog INTO DATA(tile).

      DATA(base) = block_base( group  = tile-group
                               header = tile-header ).
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

      " widest header of the block plus roughly one space, in 1/100 em
      DATA(tenths) = ( t_blocks[ group = tile-group base = base ]-width + 45 ) DIV 10.
      DATA(width) = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      DATA(row) = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = COND #( WHEN new_block = abap_true
                               THEN `sapUiTinyMarginBegin sapUiSmallMarginTop`
                               ELSE `sapUiTinyMarginBegin` ) ).

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

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( group = `Basic` header = `Binding` sub = `Expression Binding` app = `z2ui5_cl_smp_app_027` )
      ( group = `Basic` header = `Binding` sub = `Formatting Currencies` app = `z2ui5_cl_smp_app_067` )
      ( group = `Basic` header = `Binding` sub = `Formatting Integers, Decimals, Dates & Time` app = `z2ui5_cl_smp_app_047` )
      ( group = `Basic` header = `Binding` sub = `Level Structure/Component` app = `z2ui5_cl_smp_app_166` )
      ( group = `Basic` header = `Binding` sub = `Level Table/Cell` app = `z2ui5_cl_smp_app_144` )
      ( group = `Basic` header = `Browser` sub = `Clipboard (A)` app = `z2ui5_cl_smp_app_325` )
      ( group = `Basic` header = `Browser` sub = `Hide/show Soft Keyboard (A)` app = `z2ui5_cl_smp_app_352` )
      ( group = `Basic` header = `Browser` sub = `Logout (A)` app = `z2ui5_cl_smp_app_361` )
      ( group = `Basic` header = `Browser` sub = `Open an URL in a new tab (A)` app = `z2ui5_cl_smp_app_073` )
      ( group = `Basic` header = `Browser` sub = `Open Telephon, Email usw (A)` app = `z2ui5_cl_smp_app_316` )
      ( group = `Basic` header = `Browser` sub = `Title (A)` app = `z2ui5_cl_smp_app_125` )
      ( group = `Basic` header = `CSS` sub = `Cell Coloring` app = `z2ui5_cl_smp_app_305` )
      ( group = `Basic` header = `CSS` sub = `Flex Box with Navigation Examples` app = `z2ui5_cl_smp_app_255` )
      ( group = `Basic` header = `CSS` sub = `Send your own CSS to the frontend` app = `z2ui5_cl_smp_app_050` )
      ( group = `Basic` header = `Event` sub = `Additional Infos with t_args` app = `z2ui5_cl_smp_app_167` )
      ( group = `Basic` header = `Event` sub = `Facet Filter T_arg with Objects` app = `z2ui5_cl_smp_app_197` )
      ( group = `Basic` header = `Event` sub = `Handle events & change the view` app = `z2ui5_cl_smp_app_004` )
      ( group = `Basic` header = `Focus` sub = `Focus Aggregations (A)` app = `z2ui5_cl_smp_app_421` )
      ( group = `Basic` header = `Focus` sub = `Jump with the focus (A)` app = `z2ui5_cl_smp_app_189` )
      ( group = `Basic` header = `Focus` sub = `Set Focus in Textfield (A)` app = `z2ui5_cl_smp_app_133` )
      ( group = `Basic` header = `Formatter` sub = `ABAP date strings (DATS/TIMS)` app = `z2ui5_cl_smp_app_450` )
      ( group = `Basic` header = `Formatter` sub = `Date Object for DatePicker` app = `z2ui5_cl_smp_app_457` )
      ( group = `Basic` header = `Formatter` sub = `Date Objects for PlanningCalendar` app = `z2ui5_cl_smp_app_456` )
      ( group = `Basic` header = `Formatter` sub = `Inline Icons` app = `z2ui5_cl_smp_app_466` )
      ( group = `Basic` header = `Formatter` sub = `Thin frontend, computed in ABAP` app = `z2ui5_cl_smp_app_453` )
      ( group = `Basic` header = `List` sub = `Events & Visualization` app = `z2ui5_cl_smp_app_048` )
      ( group = `Basic` header = `List` sub = `Frontend Filter/Sort via Backend Event (A)` app = `z2ui5_cl_smp_app_454` )
      ( group = `Basic` header = `List` sub = `Frontend Live Filter without Backend (A)` app = `z2ui5_cl_smp_app_455` )
      ( group = `Basic` header = `Message` sub = `Backend Processing` app = `z2ui5_cl_smp_app_008` )
      ( group = `Basic` header = `Message` sub = `Message Model & Manager (C)` app = `z2ui5_cl_smp_app_467` )
      ( group = `Basic` header = `Message` sub = `MessageBox` app = `z2ui5_cl_smp_app_382` )
      ( group = `Basic` header = `Message` sub = `MessageToast` app = `z2ui5_cl_smp_app_381` )
      ( group = `Basic` header = `Message` sub = `MessageView (A)` app = `z2ui5_cl_smp_app_452` )
      ( group = `Basic` header = `Model` sub = `Device Model (A)` app = `z2ui5_cl_smp_app_445` )
      ( group = `Basic` header = `Model` sub = `Set Size Limit (A)` app = `z2ui5_cl_smp_app_071` )
      ( group = `Basic` header = `More` sub = `CameraSelector (C)` app = `z2ui5_cl_smp_app_306` )
      ( group = `Basic` header = `More` sub = `Data Loss Protection (A,C)` app = `z2ui5_cl_smp_app_279` )
      ( group = `Basic` header = `More` sub = `Error Handling` app = `z2ui5_cl_smp_app_464` )
      ( group = `Basic` header = `More` sub = `File Download to the Frontend (A)` app = `z2ui5_cl_smp_app_186` )
      ( group = `Basic` header = `More` sub = `File Uploader (C)` app = `z2ui5_cl_smp_app_074` )
      ( group = `Basic` header = `More` sub = `Generic Data Reference` app = `z2ui5_cl_smp_app_061` )
      ( group = `Basic` header = `More` sub = `Geoloaction (C)` app = `z2ui5_cl_smp_app_120` )
      ( group = `Basic` header = `More` sub = `Keyboard Shortcuts (A)` app = `z2ui5_cl_smp_app_471` )
      ( group = `Basic` header = `More` sub = `Link with preventDefault (A)` app = `z2ui5_cl_smp_app_472` )
      ( group = `Basic` header = `More` sub = `Menu Item Path (A)` app = `z2ui5_cl_smp_app_473` )
      ( group = `Basic` header = `More` sub = `MessagePopover URL Policy (A)` app = `z2ui5_cl_smp_app_474` )
      ( group = `Basic` header = `More` sub = `Multi Input (C)` app = `z2ui5_cl_smp_app_078` )
      ( group = `Basic` header = `More` sub = `Panel, setExpanded (A)` app = `z2ui5_cl_smp_app_448` )
      ( group = `Basic` header = `More` sub = `PDF Viewer Display (A)` app = `z2ui5_cl_smp_app_449` )
      ( group = `Basic` header = `More` sub = `Read Frontend Infos` app = `z2ui5_cl_smp_app_122` )
      ( group = `Basic` header = `More` sub = `Require Object in XML View` app = `z2ui5_cl_smp_app_163` )
      ( group = `Basic` header = `More` sub = `Storage Local/Session (A,C)` app = `z2ui5_cl_smp_app_327` )
      ( group = `Basic` header = `More` sub = `Wizard Control (A)` app = `z2ui5_cl_smp_app_202` )
      ( group = `Basic` header = `NavContainer` sub = `Popup (A)` app = `z2ui5_cl_smp_app_170` )
      ( group = `Basic` header = `NavContainer` sub = `Simple (A)` app = `z2ui5_cl_smp_app_088` )
      ( group = `Basic` header = `Navigation` sub = `Call and leave to apps` app = `z2ui5_cl_smp_app_024` )
      ( group = `Basic` header = `Navigation` sub = `Exchange Data and Event` app = `z2ui5_cl_smp_app_488` )
      ( group = `Basic` header = `Nested Views` sub = `Basic Example` app = `z2ui5_cl_smp_app_065` )
      ( group = `Basic` header = `Nested Views` sub = `Head & Item Table` app = `z2ui5_cl_smp_app_097` )
      ( group = `Basic` header = `Nested Views` sub = `Head & Item Table & Detail` app = `z2ui5_cl_smp_app_098` )
      ( group = `Basic` header = `Nested Views` sub = `Sub-App` app = `z2ui5_cl_smp_app_104` )
      ( group = `Basic` header = `Popover` sub = `Display Quick View` app = `z2ui5_cl_smp_app_109` )
      ( group = `Basic` header = `Popover` sub = `Display Toggle (A)` app = `z2ui5_cl_smp_app_465` )
      ( group = `Basic` header = `Popover` sub = `Item Level of Table` app = `z2ui5_cl_smp_app_052` )
      ( group = `Basic` header = `Popover` sub = `List to select in Popover` app = `z2ui5_cl_smp_app_081` )
      ( group = `Basic` header = `Popover` sub = `Opened with the View Build` app = `z2ui5_cl_smp_app_490` )
      ( group = `Basic` header = `Popover` sub = `Simple Example` app = `z2ui5_cl_smp_app_026` )
      ( group = `Basic` header = `Popup` sub = `Aggregation binding to the selected row (A)` app = `z2ui5_cl_smp_app_470` )
      ( group = `Basic` header = `Popup` sub = `Different ways of calling Popups (A)` app = `z2ui5_cl_smp_app_012` )
      ( group = `Basic` header = `Popup` sub = `Popup in Popup - Backend Stack Handling` app = `z2ui5_cl_smp_app_161` )
      ( group = `Basic` header = `Popup` sub = `Value Help with Popups` app = `z2ui5_cl_smp_app_009` )
      ( group = `Basic` header = `Scroll` sub = `Scroll into view (A)` app = `z2ui5_cl_smp_app_363` )
      ( group = `Basic` header = `Scroll` sub = `Scroll to position (A)` app = `z2ui5_cl_smp_app_362` )
      ( group = `Basic` header = `Table` sub = `Backend Filter` app = `z2ui5_cl_smp_app_045` )
      ( group = `Basic` header = `Table` sub = `Drag and Drop (A)` app = `z2ui5_cl_smp_app_459` )
      ( group = `Basic` header = `Table` sub = `Editable` app = `z2ui5_cl_smp_app_011` )
      ( group = `Basic` header = `Table` sub = `Live Search via Backend` app = `z2ui5_cl_smp_app_059` )
      ( group = `Basic` header = `Table` sub = `Search via Backend` app = `z2ui5_cl_smp_app_053` )
      ( group = `Basic` header = `Table` sub = `Selection Modes: Single Select & Multi Select` app = `z2ui5_cl_smp_app_019` )
      ( group = `Basic` header = `Table` sub = `Table with ScrollContainer` app = `z2ui5_cl_smp_app_006` )
      ( group = `Basic` header = `Templating` sub = `Basic Example` app = `z2ui5_cl_smp_app_173` )
      ( group = `Basic` header = `Templating` sub = `Nested Views` app = `z2ui5_cl_smp_app_176` )
      ( group = `Basic` header = `Timer` sub = `Loading Indicator with WAIT UP Backend (A)` app = `z2ui5_cl_smp_app_064` )
      ( group = `Basic` header = `Timer` sub = `Wait n MS and call again the server (A)` app = `z2ui5_cl_smp_app_028` )
      ( group = `Basic` header = `Tree` sub = `Drag and Drop (A,C)` app = `z2ui5_cl_smp_app_461` )
      ( group = `Basic` header = `Tree` sub = `Editable with Custom Item (C)` app = `z2ui5_cl_smp_app_463` )
      ( group = `Basic` header = `Tree` sub = `Inside Popup (C)` app = `z2ui5_cl_smp_app_462` )
      ( group = `Basic` header = `Tree` sub = `Simple` app = `z2ui5_cl_smp_app_460` )
      ( group = `Basic` header = `ui.Table` sub = `Default Filtering (C)` app = `z2ui5_cl_smp_app_143` )
      ( group = `Basic` header = `ui.Table` sub = `Events on Cell Level` app = `z2ui5_cl_smp_app_160` )
      ( group = `Basic` header = `ui.Table` sub = `Full Example` app = `z2ui5_cl_smp_app_070` ) ).

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

ENDCLASS.
