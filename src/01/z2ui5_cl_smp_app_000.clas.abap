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
      ( group = `Basic I` header = `Action` sub = `Call Method of Object` app = `z2ui5_cl_smp_app_446` )
      ( group = `Basic I` header = `Action` sub = `Call Method of Object by ID` app = `z2ui5_cl_smp_app_447` )
      ( group = `Basic I` header = `Binding` sub = `Expression Binding` app = `z2ui5_cl_smp_app_027` )
      ( group = `Basic I` header = `Binding` sub = `Formatting Currencies` app = `z2ui5_cl_smp_app_067` )
      ( group = `Basic I` header = `Binding` sub = `Formatting Integers, Decimals, Dates & Time` app = `z2ui5_cl_smp_app_047` )
      ( group = `Basic I` header = `Binding` sub = `Level Structure/Component` app = `z2ui5_cl_smp_app_166` )
      ( group = `Basic I` header = `Binding` sub = `Level Table/Cell` app = `z2ui5_cl_smp_app_144` )
      ( group = `Basic I` header = `Browser` sub = `Clipboard (A)` app = `z2ui5_cl_smp_app_325` )
      ( group = `Basic I` header = `Browser` sub = `Hide/show Soft Keyboard (A)` app = `z2ui5_cl_smp_app_352` )
      ( group = `Basic I` header = `Browser` sub = `Logout (A)` app = `z2ui5_cl_smp_app_361` )
      ( group = `Basic I` header = `Browser` sub = `Open an URL in a new tab (A)` app = `z2ui5_cl_smp_app_073` )
      ( group = `Basic I` header = `Browser` sub = `Open Telephon, Email usw (A)` app = `z2ui5_cl_smp_app_316` )
      ( group = `Basic I` header = `Browser` sub = `Title (A)` app = `z2ui5_cl_smp_app_125` )
      ( group = `Basic I` header = `CSS` sub = `Cell Coloring` app = `z2ui5_cl_smp_app_305` )
      ( group = `Basic I` header = `CSS` sub = `Flex Box with Navigation Examples` app = `z2ui5_cl_smp_app_255` )
      ( group = `Basic I` header = `CSS` sub = `Send your own CSS to the frontend` app = `z2ui5_cl_smp_app_050` )
      ( group = `Basic I` header = `Event` sub = `Additional Infos with t_args` app = `z2ui5_cl_smp_app_167` )
      ( group = `Basic I` header = `Event` sub = `Facet Filter T_arg with Objects` app = `z2ui5_cl_smp_app_197` )
      ( group = `Basic I` header = `Event` sub = `Handle events & change the view` app = `z2ui5_cl_smp_app_004` )
      ( group = `Basic I` header = `Focus` sub = `Focus Aggregations` app = `z2ui5_cl_smp_app_421` )
      ( group = `Basic I` header = `Focus` sub = `Jump with the focus (A)` app = `z2ui5_cl_smp_app_189` )
      ( group = `Basic I` header = `Focus` sub = `Set Focus in Textfield (A)` app = `z2ui5_cl_smp_app_133` )
      ( group = `Basic I` header = `Formatter` sub = `ABAP date strings (DATS/TIMS)` app = `z2ui5_cl_smp_app_450` )
      ( group = `Basic I` header = `Formatter` sub = `Date Object for DatePicker` app = `z2ui5_cl_smp_app_457` )
      ( group = `Basic I` header = `Formatter` sub = `Date Objects for PlanningCalendar` app = `z2ui5_cl_smp_app_456` )
      ( group = `Basic I` header = `Formatter` sub = `Inline Icons` app = `z2ui5_cl_smp_app_466` )
      ( group = `Basic I` header = `Formatter` sub = `Thin frontend, computed in ABAP` app = `z2ui5_cl_smp_app_453` )
      ( group = `Basic I` header = `Message` sub = `Backend Processing` app = `z2ui5_cl_smp_app_008` )
      ( group = `Basic I` header = `Message` sub = `Message Manager (C)` app = `z2ui5_cl_smp_app_467` )
      ( group = `Basic I` header = `Message` sub = `Message Model` app = `z2ui5_cl_smp_app_458` )
      ( group = `Basic I` header = `Message` sub = `MessageBox` app = `z2ui5_cl_smp_app_382` )
      ( group = `Basic I` header = `Message` sub = `MessageToast` app = `z2ui5_cl_smp_app_381` )
      ( group = `Basic I` header = `Message` sub = `MessageView` app = `z2ui5_cl_smp_app_452` )
      ( group = `Basic I` header = `Model` sub = `Device Model` app = `z2ui5_cl_smp_app_445` )
      ( group = `Basic I` header = `Model` sub = `Set Size Limit` app = `z2ui5_cl_smp_app_071` )
      ( group = `Basic I` header = `More` sub = `Error Handling` app = `z2ui5_cl_smp_app_464` )
      ( group = `Basic I` header = `More` sub = `File Download to the Frontend` app = `z2ui5_cl_smp_app_186` )
      ( group = `Basic I` header = `More` sub = `Generic Data Reference` app = `z2ui5_cl_smp_app_061` )
      ( group = `Basic I` header = `More` sub = `Link with preventDefault (A)` app = `z2ui5_cl_smp_app_472` )
      ( group = `Basic I` header = `More` sub = `Menu Item Path (A)` app = `z2ui5_cl_smp_app_473` )
      ( group = `Basic I` header = `More` sub = `Read Frontend Infos` app = `z2ui5_cl_smp_app_122` )
      ( group = `Basic I` header = `More` sub = `Require Object in XML View` app = `z2ui5_cl_smp_app_163` )
      ( group = `Basic I` header = `Navigation` sub = `Call and leave to apps` app = `z2ui5_cl_smp_app_024` )
      ( group = `Basic I` header = `Navigation` sub = `Exchange Data and Event` app = `z2ui5_cl_smp_app_488` )
      ( group = `Basic I` header = `Nested Views` sub = `Basic Example` app = `z2ui5_cl_smp_app_065` )
      ( group = `Basic I` header = `Nested Views` sub = `Head & Item Table` app = `z2ui5_cl_smp_app_097` )
      ( group = `Basic I` header = `Nested Views` sub = `Head & Item Table & Detail` app = `z2ui5_cl_smp_app_098` )
      ( group = `Basic I` header = `Nested Views` sub = `Sub-App` app = `z2ui5_cl_smp_app_104` )
      ( group = `Basic I` header = `Popover` sub = `Display Quick View` app = `z2ui5_cl_smp_app_109` )
      ( group = `Basic I` header = `Popover` sub = `Display Toggle (A)` app = `z2ui5_cl_smp_app_465` )
      ( group = `Basic I` header = `Popover` sub = `Item Level of Table` app = `z2ui5_cl_smp_app_052` )
      ( group = `Basic I` header = `Popover` sub = `List to select in Popover` app = `z2ui5_cl_smp_app_081` )
      ( group = `Basic I` header = `Popover` sub = `Simple Example` app = `z2ui5_cl_smp_app_026` )
      ( group = `Basic I` header = `Popup` sub = `Aggregation binding to the selected row` app = `z2ui5_cl_smp_app_470` )
      ( group = `Basic I` header = `Popup` sub = `Different ways of calling Popups` app = `z2ui5_cl_smp_app_012` )
      ( group = `Basic I` header = `Popup` sub = `Popup in Popup - Backend Stack Handling` app = `z2ui5_cl_smp_app_161` )
      ( group = `Basic I` header = `Popup` sub = `Value Help with Popups` app = `z2ui5_cl_smp_app_009` )
      ( group = `Basic I` header = `Scroll` sub = `Scroll into view (A)` app = `z2ui5_cl_smp_app_363` )
      ( group = `Basic I` header = `Scroll` sub = `Scroll to position (A)` app = `z2ui5_cl_smp_app_362` )
      ( group = `Basic I` header = `Templating` sub = `Basic Example` app = `z2ui5_cl_smp_app_173` )
      ( group = `Basic I` header = `Templating` sub = `Nested Views` app = `z2ui5_cl_smp_app_176` )
      ( group = `Basic I` header = `Timer` sub = `Loading Indicator with WAIT UP Backend (A)` app = `z2ui5_cl_smp_app_064` )
      ( group = `Basic I` header = `Timer` sub = `Wait n MS and call again the server (A)` app = `z2ui5_cl_smp_app_028` )
      ( group = `Basic II` header = `Launchpad` sub = `cross app navigation I` app = `z2ui5_cl_smp_app_483` )
      ( group = `Basic II` header = `Launchpad` sub = `cross app navigation II` app = `z2ui5_cl_smp_app_484` )
      ( group = `Basic II` header = `Launchpad` sub = `Set Title` app = `z2ui5_cl_smp_app_482` )
      ( group = `Basic II` header = `Launchpad` sub = `Startup Parameters` app = `z2ui5_cl_smp_app_481` )
      ( group = `Basic II` header = `List` sub = `Events & Visualization` app = `z2ui5_cl_smp_app_048` )
      ( group = `Basic II` header = `List` sub = `Frontend Filter/Sort via Backend Event (A)` app = `z2ui5_cl_smp_app_454` )
      ( group = `Basic II` header = `List` sub = `Frontend Live Filter without Backend (A)` app = `z2ui5_cl_smp_app_455` )
      ( group = `Basic II` header = `More` sub = `CameraSelector (C)` app = `z2ui5_cl_smp_app_306` )
      ( group = `Basic II` header = `More` sub = `Data Loss Protection (C)` app = `z2ui5_cl_smp_app_279` )
      ( group = `Basic II` header = `More` sub = `File Uploader (C)` app = `z2ui5_cl_smp_app_074` )
      ( group = `Basic II` header = `More` sub = `Geoloaction (C)` app = `z2ui5_cl_smp_app_120` )
      ( group = `Basic II` header = `More` sub = `Keyboard Shortcuts (A)` app = `z2ui5_cl_smp_app_471` )
      ( group = `Basic II` header = `More` sub = `MessagePopover URL Policy (A)` app = `z2ui5_cl_smp_app_474` )
      ( group = `Basic II` header = `More` sub = `Multi Input (C)` app = `z2ui5_cl_smp_app_078` )
      ( group = `Basic II` header = `More` sub = `Panel, setExpanded (A)` app = `z2ui5_cl_smp_app_448` )
      ( group = `Basic II` header = `More` sub = `PDF Viewer Display (A)` app = `z2ui5_cl_smp_app_449` )
      ( group = `Basic II` header = `More` sub = `Storage Local/Session (A)` app = `z2ui5_cl_smp_app_327` )
      ( group = `Basic II` header = `More` sub = `Wizard Control (A)` app = `z2ui5_cl_smp_app_202` )
      ( group = `Basic II` header = `NavContainer` sub = `Popup (A)` app = `z2ui5_cl_smp_app_170` )
      ( group = `Basic II` header = `NavContainer` sub = `Simple (A)` app = `z2ui5_cl_smp_app_088` )
      ( group = `Basic II` header = `Table` sub = `Backend Filter` app = `z2ui5_cl_smp_app_045` )
      ( group = `Basic II` header = `Table` sub = `Drag and Drop (A)` app = `z2ui5_cl_smp_app_459` )
      ( group = `Basic II` header = `Table` sub = `Editable` app = `z2ui5_cl_smp_app_011` )
      ( group = `Basic II` header = `Table` sub = `Live Search via Backend` app = `z2ui5_cl_smp_app_059` )
      ( group = `Basic II` header = `Table` sub = `Search via Backend` app = `z2ui5_cl_smp_app_053` )
      ( group = `Basic II` header = `Table` sub = `Selection Modes: Single Select & Multi Select` app = `z2ui5_cl_smp_app_019` )
      ( group = `Basic II` header = `Table` sub = `Table with ScrollContainer` app = `z2ui5_cl_smp_app_006` )
      ( group = `Basic II` header = `Tree` sub = `Drag and Drop (A,C)` app = `z2ui5_cl_smp_app_461` )
      ( group = `Basic II` header = `Tree` sub = `Editable with Custom Item (C)` app = `z2ui5_cl_smp_app_463` )
      ( group = `Basic II` header = `Tree` sub = `Inside Popup (C)` app = `z2ui5_cl_smp_app_462` )
      ( group = `Basic II` header = `Tree` sub = `Simple` app = `z2ui5_cl_smp_app_460` )
      ( group = `Basic II` header = `ui.Table` sub = `Default Filtering (C)` app = `z2ui5_cl_smp_app_143` )
      ( group = `Basic II` header = `ui.Table` sub = `Events on Cell Level` app = `z2ui5_cl_smp_app_160` )
      ( group = `Basic II` header = `ui.Table` sub = `Full Example` app = `z2ui5_cl_smp_app_070` )
      ( group = `controls - sap.m` header = `Breadcrumbs` sub = `Breadcrumbs sample with current page set as aggregation, resulting in a link` app = `z2ui5_cl_smp_app_292` )
      ( group = `controls - sap.m` header = `BusyIndicator` sub = `The Busy Indicator signals that some operation is going on and that the user must wait ...` app = `z2ui5_cl_smp_app_215` )
      ( group = `controls - sap.m` header = `CheckBox` sub = `Checkboxes allow users to select a subset of options. If you want to offer an off/on ...` app = `z2ui5_cl_smp_app_239` )
      ( group = `controls - sap.m` header = `DateTimePicker` sub = `Value States` app = `z2ui5_cl_smp_app_377` )
      ( group = `controls - sap.m` header = `FeedInput` sub = `` app = `z2ui5_cl_smp_app_114` )
      ( group = `controls - sap.m` header = `FeedInput` sub = `This sample shows a standalone feed input with different settings.` app = `z2ui5_cl_smp_app_283` )
      ( group = `controls - sap.m` header = `GenericTag` sub = `Previews of the GenericTag control based on combinations of different sets of properties.` app = `z2ui5_cl_smp_app_257` )
      ( group = `controls - sap.m` header = `Label` sub = `Labels are helpful when you need to describe some other UI control.` app = `z2ui5_cl_smp_app_051` )
      ( group = `controls - sap.m` header = `Link` sub = `Here are some links. Typically links are used in user interfaces to trigger navigation to ...` app = `z2ui5_cl_smp_app_293` )
      ( group = `controls - sap.m` header = `MaskInput` sub = `The sap.m.MaskInput control allows users to easily enter data in a certain format and in ...` app = `z2ui5_cl_smp_app_110` )
      ( group = `controls - sap.m` header = `MenuButton` sub = `This control is used to open a menu in both desktop and mobile.` app = `z2ui5_cl_smp_app_372` )
      ( group = `controls - sap.m` header = `MessageStrip` sub = `A sample MessageStrip that shows status messages with additional formatting.` app = `z2ui5_cl_smp_app_291` )
      ( group = `controls - sap.m` header = `MessageStrip` sub = `MessageStrip for showing status messages.` app = `z2ui5_cl_smp_app_238` )
      ( group = `controls - sap.m` header = `MultiComboBox` sub = `` app = `z2ui5_cl_smp_app_140` )
      ( group = `controls - sap.m` header = `NotificationListItem` sub = `A list item suitable for showing notifications to the user.` app = `z2ui5_cl_smp_app_375` )
      ( group = `controls - sap.m` header = `ObjectNumber` sub = `inside a Table` app = `z2ui5_cl_smp_app_369` )
      ( group = `controls - sap.m` header = `ObjectStatus` sub = `The object status is a small building block representing a status with a semantic color.` app = `z2ui5_cl_smp_app_300` )
      ( group = `controls - sap.m` header = `Page` sub = `Header, Sub-Header & Footer` app = `z2ui5_cl_smp_app_366` )
      ( group = `controls - sap.m` header = `ProgressIndicator` sub = `Shows the progress of a process in a graphical way. To indicate the progress, the inside ...` app = `z2ui5_cl_smp_app_022` )
      ( group = `controls - sap.m` header = `RadioButton` sub = `Typically the Radio Button is used by other controls. E.g. the List uses it for the ...` app = `z2ui5_cl_smp_app_207` )
      ( group = `controls - sap.m` header = `RadioButtonGroup` sub = `A wrapper for a group of radio buttons.` app = `z2ui5_cl_smp_app_208` )
      ( group = `controls - sap.m` header = `RangeSlider` sub = `` app = `z2ui5_cl_smp_app_005` )
      ( group = `controls - sap.m` header = `RatingIndicator` sub = `A Rating Indicator can be used to both indicate and/or rate content.` app = `z2ui5_cl_smp_app_220` )
      ( group = `controls - sap.m` header = `SearchField` sub = `Use the Search Field to let the user enter a search string and trigger the search process.` app = `z2ui5_cl_smp_app_296` )
      ( group = `controls - sap.m` header = `SplitContainer` sub = `Master & Detail Pages` app = `z2ui5_cl_smp_app_374` )
      ( group = `controls - sap.m` header = `Text` sub = `with class -Standard Margins - Negative Margins` app = `z2ui5_cl_smp_app_243` )
      ( group = `controls - sap.m` header = `TimePicker` sub = `Formats & Steps` app = `z2ui5_cl_smp_app_376` )
      ( group = `controls - sap.uxap` header = `ObjectPageLayout` sub = `ObjectPage sample that demonstrates the combination of header facets and showTitle ...` app = `z2ui5_cl_smp_app_330` )
      ( group = `controls - sap.ui.layout` header = `Grid` sub = `Split View in different Areas` app = `z2ui5_cl_smp_app_367` )
      ( group = `controls - sap.tnt` header = `InfoLabel` sub = `InfoLabel with all available color schemes` app = `z2ui5_cl_smp_app_209` )
      ( group = `controls - sap.tnt` header = `NavigationList` sub = `simple` app = `z2ui5_cl_smp_app_258` )
      ( group = `controls - sap.ui.unified` header = `ColorPicker` sub = `` app = `z2ui5_cl_smp_app_270` ) ).

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
    " ButtonGroup | Carousel). Elsewhere a block is the header without its
    " trailing Roman numeral (Binding, Binding II, ...).
    IF group CP `controls -*`.
      result = to_upper( substring( val = header
                                    off = 0
                                    len = 1 ) ).
    ELSE.
      result = header_base( header ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
