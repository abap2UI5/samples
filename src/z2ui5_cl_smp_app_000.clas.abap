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

    CONSTANTS:
      BEGIN OF cs_event,
        search TYPE string VALUE `SEARCH`,
        nav    TYPE string VALUE `NAV_APP`,
      END OF cs_event.

    " the three sample repositories and the framework, in the order the shared
    " overview header renders them - each one is installed on its own, so the
    " header asks per entry whether its overview app is on THIS system
    CONSTANTS:
      BEGIN OF cs_class,
        startup      TYPE string VALUE `z2ui5_cl_app_startup`,
        samples      TYPE string VALUE `z2ui5_cl_smp_app_000`,
        controls     TYPE string VALUE `z2ui5_cl_smpc_app_overview`,
        " the overview app of samples-controls before its 2026-08 rename - an
        " installation that predates it still answers to this name
        controls_old TYPE string VALUE `z2ui5_cl_dmo_app_overview`,
        stack        TYPE string VALUE `z2ui5_cl_smpe_app_00`,
      END OF cs_class.

    CONSTANTS:
      BEGIN OF cs_url,
        docs      TYPE string VALUE `https://abap2UI5.org`,
        framework TYPE string VALUE `https://github.com/abap2UI5/abap2UI5`,
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
    METHODS view_display.
    "! The header every abap2UI5 overview app shares: one icon button per
    "! sibling repository - it jumps into that repository's overview app when
    "! the app is on this system and opens the repository on GitHub when it is
    "! not - followed by the documentation and this repository. The entry of
    "! the repository you are looking at stays visible but disabled, so the
    "! header reads the same everywhere.
    METHODS render_header
      IMPORTING
        page TYPE REF TO z2ui5_cl_xml_view.
    METHODS header_button
      IMPORTING
        toolbar   TYPE REF TO z2ui5_cl_xml_view
        icon      TYPE string
        tooltip   TYPE string
        href      TYPE string
        class     TYPE string OPTIONAL
        "! the overview app's PREVIOUS name, tried when CLASS is not on the
        "! system: a repository that renamed its overview app is installed
        "! under both names in the wild for a while
        class_old TYPE string OPTIONAL
        here      TYPE abap_bool DEFAULT abap_false.
    "! the press wire of a button whose target is EXTERNAL: a Button carries no
    "! href, and cs_event-open_new_tab is same-origin only, so the new tab is
    "! opened by the URLHELPER frontend action - client-side, inside the click
    "! handler, which is what keeps the popup blocker quiet
    METHODS open_url
      IMPORTING
        href          TYPE string
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

    ELSEIF client->check_on_navigated( ).

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
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( `search` )
                             ( |{ strlen( search ) }| )
                             ( |{ strlen( search ) }| ) ) ).

      WHEN cs_event-nav.

        " a header button - the app to jump to travels as the event argument
        app_call( client->get_event_arg( ) ).

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

    DATA(t_catalog_all) = get_catalog( ).
    DATA(t_catalog) = catalog_filter( t_catalog_all ).
    DATA(t_blocks) = block_widths( t_catalog ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        id             = `page`
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    render_header( page ).

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
        search      = client->_event( cs_event-search )
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


  METHOD render_header.

    DATA(toolbar) = page->header_content( ).

    header_button( toolbar = toolbar
                   icon    = `sap-icon://home`
                   tooltip = `abap2UI5 - the start page of the framework`
                   class   = cs_class-startup
                   href    = cs_url-framework ).

    header_button( toolbar = toolbar
                   icon    = `sap-icon://lightbulb`
                   tooltip = `Samples - binding, events, popups, tables and much more`
                   class   = cs_class-samples
                   href    = cs_url-samples
                   here    = abap_true ).

    header_button( toolbar   = toolbar
                   icon      = `sap-icon://palette`
                   tooltip   = `Controls - the UI5 Demo Kit, rebuilt with abap2UI5`
                   class     = cs_class-controls
                   class_old = cs_class-controls_old
                   href      = cs_url-controls ).

    header_button( toolbar = toolbar
                   icon    = `sap-icon://database`
                   tooltip = `Stack - OData, RAP, WebSockets and the Fiori Launchpad`
                   class   = cs_class-stack
                   href    = cs_url-stack ).

    header_button( toolbar = toolbar
                   icon    = `sap-icon://learning-assistant`
                   tooltip = `Documentation - guides, tutorials and the API reference`
                   href    = cs_url-docs ).

    header_button( toolbar = toolbar
                   icon    = `sap-icon://source-code`
                   tooltip = `GitHub - the source code of this repository`
                   href    = cs_url-samples ).

  ENDMETHOD.


  METHOD header_button.

    IF here = abap_true.

      " where you are: the button stays, so every overview shows the same row,
      " but there is nowhere to go
      toolbar->button( icon    = icon
                       type    = `Transparent`
                       enabled = abap_false
                       tooltip = |{ tooltip } - you are here| ).
      RETURN.

    ENDIF.

    DATA target TYPE string.

    IF class IS NOT INITIAL AND class_installed( class ) = abap_true.
      target = class.

    ELSEIF class_old IS NOT INITIAL AND class_installed( class_old ) = abap_true.
      target = class_old.

    ENDIF.

    IF target IS NOT INITIAL.

      " installed on this system: jump right into it, the back button returns
      toolbar->button( icon    = icon
                       type    = `Transparent`
                       tooltip = tooltip
                       press   = client->_event( val   = cs_event-nav
                                                 t_arg = VALUE #( ( target ) ) ) ).
      RETURN.

    ENDIF.

    toolbar->button(
        icon    = icon
        type    = `Transparent`
        tooltip = COND #( WHEN class IS INITIAL
                          THEN tooltip
                          ELSE |{ tooltip } - not installed, opens GitHub| )
        press   = open_url( href ) ).

  ENDMETHOD.


  METHOD open_url.

    " REDIRECT takes a { URL, NEW_WINDOW } object literal - NEW_WINDOW true is
    " what target="_blank" does on a Link
    result = client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-urlhelper
        t_arg = VALUE #( ( `REDIRECT` )
                         ( |\{ URL: '{ href }', NEW_WINDOW: true \}| ) ) ).

  ENDMETHOD.


  METHOD class_installed.

    " the same question the framework's start page asks: an absent, inactive
    " or not-activatable class raises here, it does not return a flag. The name
    " has to be upper case - the repository stores it that way, and the class
    " constants above follow the repository's lower-case spelling rule.
    DATA(name) = to_upper( val ).

    TRY.
        DATA obj TYPE REF TO object ##NEEDED.
        CREATE OBJECT obj TYPE (name).
        result = abap_true.
      CATCH cx_root ##CATCH_ALL.
        result = abap_false.
    ENDTRY.

  ENDMETHOD.


  METHOD get_catalog.

    result = VALUE #(
      ( group = `samples` header = `Basics` sub = `First App: Events, Views and Roundtrips` keywords = `hello world getting started first app roundtrip lifecycle check_on_event` app = `z2ui5_cl_smp_app_004` )
      ( group = `samples` header = `Binding` sub = `Currency Amounts (sap.ui.model.type.Currency)` keywords = `amount decimals leading zeros number format` app = `z2ui5_cl_smp_app_067` )
      ( group = `samples` header = `Binding` sub = `Dynamic Table Typed at Runtime (RTTI)` keywords = `generic data reference create data ddic dynamic itab` app = `z2ui5_cl_smp_app_061` )
      ( group = `samples` header = `Binding` sub = `Expression Binding, Types and Composite Parts` keywords = `formatter parts conditional regexp visible enabled syntax` app = `z2ui5_cl_smp_app_027` )
      ( group = `samples` header = `Binding` sub = `Model setSizeLimit for Large Tables (A)` keywords = `combobox jsonmodel size limit large itab 100 entries` app = `z2ui5_cl_smp_app_071` )
      ( group = `samples` header = `Binding` sub = `Single Table Cell (tab_index)` keywords = `cell input internal table row field level` app = `z2ui5_cl_smp_app_144` )
      ( group = `samples` header = `Binding` sub = `Structure Fields and INCLUDEs` keywords = `structure component include flat form level` app = `z2ui5_cl_smp_app_166` )
      ( group = `samples` header = `Binding` sub = `Types for Integer, Decimal, Date and Time` keywords = `type conversion sum amount number field` app = `z2ui5_cl_smp_app_047` )
      ( group = `samples` header = `Browser` sub = `Copy to Clipboard (A)` keywords = `clipboard paste copy text area` app = `z2ui5_cl_smp_app_325` )
      ( group = `samples` header = `Browser` sub = `Local and Session Storage (A,C)` keywords = `localstorage sessionstorage persist store_data offline` app = `z2ui5_cl_smp_app_327` )
      ( group = `samples` header = `Browser` sub = `Logout from the Client (A)` keywords = `logoff signout icf session end fiori launchpad` app = `z2ui5_cl_smp_app_361` )
      ( group = `samples` header = `Browser` sub = `Open a URL in a New Tab (A)` keywords = `url window open_new_tab link target` app = `z2ui5_cl_smp_app_073` )
      ( group = `samples` header = `Browser` sub = `Open Mail, Phone and SMS Links (A)` keywords = `mailto tel sms urlhelper redirect native link` app = `z2ui5_cl_smp_app_316` )
      ( group = `samples` header = `Browser` sub = `Reload the Page (A)` keywords = `reload refresh restart location_reload url` app = `z2ui5_cl_smp_app_492` )
      ( group = `samples` header = `Browser` sub = `Set the Tab Favicon (A)` keywords = `favicon icon tab image data uri` app = `z2ui5_cl_smp_app_491` )
      ( group = `samples` header = `Browser` sub = `Set the Tab Title (A)` keywords = `document.title tab caption headline set_title` app = `z2ui5_cl_smp_app_125` )
      ( group = `samples` header = `Browser` sub = `Soft Keyboard Mode on Mobile (A)` keywords = `mobile numeric keypad keyboard_set_mode phone input` app = `z2ui5_cl_smp_app_352` )
      ( group = `samples` header = `Control` sub = `Expand a Panel by ID (setExpanded) (A)` keywords = `panel collapse expand setexpanded control_by_id whitelisted` app = `z2ui5_cl_smp_app_448` )
      ( group = `samples` header = `Control` sub = `MultiInput with Tokens (C)` keywords = `multiinput token tokens suggestion custom control` app = `z2ui5_cl_smp_app_078` )
      ( group = `samples` header = `Control` sub = `Open the PDF Viewer by ID (A)` keywords = `pdfviewer pdf document viewer popup control_by_id whitelisted` app = `z2ui5_cl_smp_app_449` )
      ( group = `samples` header = `Control` sub = `Switch NavContainer Page by ID (A)` keywords = `navcontainer icontabbar icontabheader page switch control_by_id whitelisted` app = `z2ui5_cl_smp_app_088` )
      ( group = `samples` header = `Control` sub = `Wizard with Steps (A)` keywords = `wizard step branching discardprogress setnextstep control_by_id` app = `z2ui5_cl_smp_app_202` )
      ( group = `samples` header = `CSS` sub = `Color Table Cells from the Backend` keywords = `color background conditional formatting style data attribute` app = `z2ui5_cl_smp_app_305` )
      ( group = `samples` header = `CSS` sub = `FlexBox Layouts with Custom Classes` keywords = `flexbox layout responsive navigation tile panel` app = `z2ui5_cl_smp_app_255` )
      ( group = `samples` header = `CSS` sub = `Ship Your Own CSS with the View` keywords = `style stylesheet inline html class own design` app = `z2ui5_cl_smp_app_050` )
      ( group = `samples` header = `Device` sub = `Camera, Take Photos (C)` keywords = `camera photo picture webcam capture facing mode` app = `z2ui5_cl_smp_app_306` )
      ( group = `samples` header = `Device` sub = `Device Model: Phone, Tablet, Desktop (A)` keywords = `sap.ui.device responsive orientation resize media model` app = `z2ui5_cl_smp_app_445` )
      ( group = `samples` header = `Device` sub = `Frontend Info: UI5 Version, Theme, OS, Browser` keywords = `client info ui5 version theme os user agent device` app = `z2ui5_cl_smp_app_122` )
      ( group = `samples` header = `Device` sub = `Geolocation from the Browser (C)` keywords = `gps position latitude longitude altitude location` app = `z2ui5_cl_smp_app_120` )
      ( group = `samples` header = `Event` sub = `Control Objects in t_arg (FacetFilter)` keywords = `facetfilter filter object marshalling selected items` app = `z2ui5_cl_smp_app_197` )
      ( group = `samples` header = `Event` sub = `Extra Arguments with t_arg` keywords = `argument parameter payload event data fixed value` app = `z2ui5_cl_smp_app_167` )
      ( group = `samples` header = `Event` sub = `Keyboard Shortcuts, Ctrl+S (A)` keywords = `shortcut hotkey ctrl key combination keyboard_shortcut` app = `z2ui5_cl_smp_app_471` )
      ( group = `samples` header = `Event` sub = `Link with preventDefault (A)` keywords = `link href default action check_prevent_default` app = `z2ui5_cl_smp_app_472` )
      ( group = `samples` header = `File` sub = `Download to the Browser (A)` keywords = `export save base64 attachment xstring document` app = `z2ui5_cl_smp_app_186` )
      ( group = `samples` header = `File` sub = `Upload to the Backend (C)` keywords = `fileuploader base64 attachment import picture document` app = `z2ui5_cl_smp_app_074` )
      ( group = `samples` header = `Focus` sub = `Focus a Table Cell by Column and Row (A)` keywords = `table cell column row aggregation set_focus` app = `z2ui5_cl_smp_app_421` )
      ( group = `samples` header = `Focus` sub = `Jump to the Next Input on Enter (A)` keywords = `cursor enter tab next field form set_focus` app = `z2ui5_cl_smp_app_189` )
      ( group = `samples` header = `Focus` sub = `Set Focus and Select Text in an Input (A)` keywords = `cursor set_focus selection position textfield` app = `z2ui5_cl_smp_app_133` )
      ( group = `samples` header = `Formatter` sub = `ABAP Date and Time Strings (DATS/TIMS)` keywords = `dats tims conversion initial date 00000000 sy-datum` app = `z2ui5_cl_smp_app_450` )
      ( group = `samples` header = `Formatter` sub = `Date Object for the DatePicker` keywords = `datepicker datevalue javascript date object iso` app = `z2ui5_cl_smp_app_457` )
      ( group = `samples` header = `Formatter` sub = `Date Objects for the PlanningCalendar` keywords = `planningcalendar appointment javascript date object iso` app = `z2ui5_cl_smp_app_456` )
      ( group = `samples` header = `Formatter` sub = `Inline Icons in a Text` keywords = `icon glyph placeholder text status expandinlineicons` app = `z2ui5_cl_smp_app_466` )
      ( group = `samples` header = `Formatter` sub = `When Not to Use One: Compute in ABAP` keywords = `no formatter computed backend thin frontend prepare` app = `z2ui5_cl_smp_app_453` )
      ( group = `samples` header = `Grid Table` sub = `Events on Cell Level` keywords = `cell enter row index event grid alv` app = `z2ui5_cl_smp_app_160` )
      ( group = `samples` header = `Grid Table` sub = `Full Example with sap.ui.table` keywords = `grid alv dynamicpage column row action currency search sort filter` app = `z2ui5_cl_smp_app_070` )
      ( group = `samples` header = `Grid Table` sub = `Keep Column Filters on Refresh (C)` keywords = `column filter reset refresh uitableext grid alv` app = `z2ui5_cl_smp_app_143` )
      ( group = `samples` header = `List` sub = `Filter and Sort the Binding from ABAP (A)` keywords = `binding_call getbinding sorter filter follow_up_action` app = `z2ui5_cl_smp_app_454` )
      ( group = `samples` header = `List` sub = `Live Filter on the Client, No Roundtrip (A)` keywords = `binding_call live search client side no roundtrip filter` app = `z2ui5_cl_smp_app_455` )
      ( group = `samples` header = `List` sub = `StandardListItem, Highlight and Events` keywords = `sap.m.list standardlistitem highlight infostate press selection` app = `z2ui5_cl_smp_app_048` )
      ( group = `samples` header = `Menu` sub = `Full Path of the Selected Item (A)` keywords = `menuitem nested submenu textpath controller path` app = `z2ui5_cl_smp_app_473` )
      ( group = `samples` header = `Menu` sub = `Menu Button with core:require` keywords = `menubutton menuitem popover messagetoast require module` app = `z2ui5_cl_smp_app_163` )
      ( group = `samples` header = `Message` sub = `Message Model and MessageManager (C)` keywords = `messagemanager validation target field state central model` app = `z2ui5_cl_smp_app_467` )
      ( group = `samples` header = `Message` sub = `MessageBox from SY, BAPIRET2 or Exception` keywords = `t100 message class number exception cx_root error abend` app = `z2ui5_cl_smp_app_008` )
      ( group = `samples` header = `Message` sub = `MessageBox, Types and Custom Actions` keywords = `confirm warning error success information dialog action` app = `z2ui5_cl_smp_app_382` )
      ( group = `samples` header = `Message` sub = `MessagePopover URL Policy (A)` keywords = `url policy link security validator relative allow deny` app = `z2ui5_cl_smp_app_474` )
      ( group = `samples` header = `Message` sub = `MessageToast, Text and Duration` keywords = `toast notification duration position animation` app = `z2ui5_cl_smp_app_381` )
      ( group = `samples` header = `Message` sub = `MessageView and MessagePopover (A)` keywords = `messagepopover messageitem dialog grouped message list` app = `z2ui5_cl_smp_app_452` )
      ( group = `samples` header = `Navigation` sub = `Call and Leave Apps (nav_app_call)` keywords = `nav_app_call nav_app_leave sub app stack call back` app = `z2ui5_cl_smp_app_024` )
      ( group = `samples` header = `Navigation` sub = `Data Loss Protection on Leaving (A,C)` keywords = `dirty unsaved changes leave confirmation warning` app = `z2ui5_cl_smp_app_279` )
      ( group = `samples` header = `Navigation` sub = `Return Data and Events to the Caller` keywords = `r_data result get_app_prev return event payload` app = `z2ui5_cl_smp_app_488` )
      ( group = `samples` header = `Navigation` sub = `Uncaught Error and Error Popup` keywords = `exception dump error handling debugtool restart retry` app = `z2ui5_cl_smp_app_464` )
      ( group = `samples` header = `Nested View` sub = `Basic Example (nest_view_display)` keywords = `nest_view_display rerender model refresh sub view` app = `z2ui5_cl_smp_app_065` )
      ( group = `samples` header = `Nested View` sub = `Embed Another App's View` keywords = `sub app class embed instantiate another app rtti` app = `z2ui5_cl_smp_app_104` )
      ( group = `samples` header = `Nested View` sub = `Master-Detail with FlexibleColumnLayout` keywords = `fcl master detail list report two column split` app = `z2ui5_cl_smp_app_097` )
      ( group = `samples` header = `Nested View` sub = `Three Columns with FlexibleColumnLayout` keywords = `fcl three column detail detail deep navigation` app = `z2ui5_cl_smp_app_098` )
      ( group = `samples` header = `Popover` sub = `Basic Example with Placement` keywords = `placement anchor button confirm cancel popover_display` app = `z2ui5_cl_smp_app_026` )
      ( group = `samples` header = `Popover` sub = `Open from a Table Row` keywords = `list report dynamicpage row link details table` app = `z2ui5_cl_smp_app_052` )
      ( group = `samples` header = `Popover` sub = `Open Together with the View Build` keywords = `initial render one roundtrip anchor button` app = `z2ui5_cl_smp_app_490` )
      ( group = `samples` header = `Popover` sub = `QuickView Contact Card` keywords = `quickview contact card links grouped fields` app = `z2ui5_cl_smp_app_109` )
      ( group = `samples` header = `Popover` sub = `Select from a List` keywords = `list selection placement anchor` app = `z2ui5_cl_smp_app_081` )
      ( group = `samples` header = `Popover` sub = `Toggle by ID (toggleBy) (A)` keywords = `toggleby open close control_by_id whitelisted` app = `z2ui5_cl_smp_app_465` )
      ( group = `samples` header = `Popup` sub = `Dialog inside a Dialog` keywords = `nested stack popup in popup second dialog` app = `z2ui5_cl_smp_app_161` )
      ( group = `samples` header = `Popup` sub = `Element Binding to the Selected Row (A)` keywords = `element binding relative path aggregation dialog row` app = `z2ui5_cl_smp_app_470` )
      ( group = `samples` header = `Popup` sub = `Navigate between Dialogs (NavContainer) (A)` keywords = `navcontainer dialog pages back forward` app = `z2ui5_cl_smp_app_170` )
      ( group = `samples` header = `Popup` sub = `Value Help: Suggestions and F4 Dialog` keywords = `f4 search help suggestion input dialog select` app = `z2ui5_cl_smp_app_009` )
      ( group = `samples` header = `Popup` sub = `Ways to Open a Dialog (A)` keywords = `dialog sub app destroy rerender background view` app = `z2ui5_cl_smp_app_012` )
      ( group = `samples` header = `Scroll` sub = `Scroll a Control into View (A)` keywords = `scroll_into_view control id validation jump` app = `z2ui5_cl_smp_app_363` )
      ( group = `samples` header = `Scroll` sub = `Scroll to a Pixel Position (A)` keywords = `position pixel scroll_to restore refresh toolbar` app = `z2ui5_cl_smp_app_362` )
      ( group = `samples` header = `Table` sub = `Drag and Drop Rows (A)` keywords = `dnd dragdropinfo reorder rows move` app = `z2ui5_cl_smp_app_459` )
      ( group = `samples` header = `Table` sub = `Editable Cells, Add and Delete Rows` keywords = `edit input add row delete multiselect toolbar` app = `z2ui5_cl_smp_app_011` )
      ( group = `samples` header = `Table` sub = `Filter Rows in the Backend` keywords = `filter server side form growing where` app = `z2ui5_cl_smp_app_045` )
      ( group = `samples` header = `Table` sub = `Large Table with Growing and ScrollContainer` keywords = `growing 10000 rows sticky toolbar sort performance` app = `z2ui5_cl_smp_app_006` )
      ( group = `samples` header = `Table` sub = `Live Search with Parallel Requests` keywords = `live search parallel requests busy queue typing` app = `z2ui5_cl_smp_app_059` )
      ( group = `samples` header = `Table` sub = `Search in the Backend (SearchField)` keywords = `search go enter server side where` app = `z2ui5_cl_smp_app_053` )
      ( group = `samples` header = `Table` sub = `Selection Modes: Single and Multi Select` keywords = `selectionmode none single multi segmentedbutton checkbox` app = `z2ui5_cl_smp_app_019` )
      ( group = `samples` header = `Templating` sub = `Build Columns Dynamically (template:repeat)` keywords = `template repeat runtime generated columns if then else` app = `z2ui5_cl_smp_app_173` )
      ( group = `samples` header = `Templating` sub = `Dynamic Content in a Nested View` keywords = `template repeat runtime generated nested nest_view_display` app = `z2ui5_cl_smp_app_176` )
      ( group = `samples` header = `Timer` sub = `Progress Indicator during a Backend Call (A)` keywords = `progressindicator busy wait long running backend` app = `z2ui5_cl_smp_app_064` )
      ( group = `samples` header = `Timer` sub = `Refresh the View Every n Seconds (A)` keywords = `interval polling auto refresh follow_up_action seconds` app = `z2ui5_cl_smp_app_028` )
      ( group = `samples` header = `Tree` sub = `Drag and Drop Nodes (A,C)` keywords = `dnd move node hierarchy binding context` app = `z2ui5_cl_smp_app_461` )
      ( group = `samples` header = `Tree` sub = `Editable Nodes with CustomTreeItem (C)` keywords = `customtreeitem rename input two way write back` app = `z2ui5_cl_smp_app_463` )
      ( group = `samples` header = `Tree` sub = `Inside a Dialog (C)` keywords = `popup expand state hierarchy nodes` app = `z2ui5_cl_smp_app_462` )
      ( group = `samples` header = `Tree` sub = `Nested ABAP Table in a sap.m.Tree` keywords = `hierarchy nodes nested json items` app = `z2ui5_cl_smp_app_460` ) ).

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
