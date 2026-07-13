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
    METHODS class_exists
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(result) TYPE abap_bool.
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

    DATA(t_catalog) = get_catalog( ).
    DATA(t_blocks) = block_widths( t_catalog ).

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
          text                = |This overview is still under construction. Click <a href="{ url }" target="_blank">here</a> to open the classic overview.| ).
    ENDIF.

    DATA(prev_group) = ``.
    DATA(prev_base) = ``.

    LOOP AT t_catalog INTO DATA(tile).

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
      ( group = `framework - basics` header = `Binding I` sub = `Level Simple` app = `z2ui5_cl_demo_app_001` )
      ( group = `framework - basics` header = `Binding II` sub = `Level Structure/Component` app = `z2ui5_cl_demo_app_166` )
      ( group = `framework - basics` header = `Binding III` sub = `Level Table/Cell` app = `z2ui5_cl_demo_app_144` )
      ( group = `framework - basics` header = `Binding IV` sub = `Expression Binding` app = `z2ui5_cl_demo_app_027` )
      ( group = `framework - basics` header = `Binding V` sub = `Formatting Integers, Decimals, Dates & Time` app = `z2ui5_cl_demo_app_047` )
      ( group = `framework - basics` header = `Binding VII` sub = `Formatting Currencies` app = `z2ui5_cl_demo_app_067` )
      ( group = `framework - basics` header = `Event I` sub = `Handle events & change the view` app = `z2ui5_cl_demo_app_004` )
      ( group = `framework - basics` header = `Event II` sub = `Additional Infos with t_args` app = `z2ui5_cl_demo_app_167` )
      ( group = `framework - basics` header = `Event III` sub = `Facet Filter - T_arg with Objects` app = `z2ui5_cl_demo_app_197` )
      ( group = `framework - basics` header = `Message` sub = `Message Box` app = `z2ui5_cl_demo_app_008` )
      ( group = `framework - basics` header = `Message` sub = `Message Toast` app = `z2ui5_cl_demo_app_187` )
      ( group = `framework - basics` header = `More` sub = `Call and leave to apps` app = `z2ui5_cl_demo_app_024` )
      ( group = `framework - basics` header = `More` sub = `Model Size Limit` app = `z2ui5_cl_demo_app_071` )
      ( group = `framework - basics` header = `More` sub = `Read Frontend Infos` app = `z2ui5_cl_demo_app_122` )
      ( group = `framework - basics` header = `More` sub = `Work with RTTI` app = `z2ui5_cl_demo_app_061` )
      ( group = `framework - basics` header = `Nested Views I` sub = `Basic Example` app = `z2ui5_cl_demo_app_065` )
      ( group = `framework - basics` header = `Nested Views II` sub = `Head & Item Table` app = `z2ui5_cl_demo_app_097` )
      ( group = `framework - basics` header = `Nested Views III` sub = `Head & Item Table & Detail` app = `z2ui5_cl_demo_app_098` )
      ( group = `framework - basics` header = `Nested Views IV` sub = `Sub-App` app = `z2ui5_cl_demo_app_104` )
      ( group = `framework - basics` header = `Popover I` sub = `Simple Example` app = `z2ui5_cl_demo_app_026` )
      ( group = `framework - basics` header = `Popover II` sub = `Item Level of Table` app = `z2ui5_cl_demo_app_052` )
      ( group = `framework - basics` header = `Popover III` sub = `List to select in Popover` app = `z2ui5_cl_demo_app_081` )
      ( group = `framework - basics` header = `Popover IV` sub = `with Quick View` app = `z2ui5_cl_demo_app_109` )
      ( group = `framework - basics` header = `Popover V` sub = `Display with Menu` app = `z2ui5_cl_demo_app_163` )
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
      ( group = `controls` header = `sap.m.Breadcrumbs` sub = `Breadcrumbs sample with current page set as aggregation, resulting in a link` app = `z2ui5_cl_demo_app_292` )
      ( group = `controls` header = `sap.m.Button` sub = `Buttons trigger user actions and come in a variety of shapes and colors. Placing a button on a page header or footer changes its appearance.` app = `z2ui5_cl_demo_app_259` )
      ( group = `controls` header = `sap.m.CheckBox` sub = `Checkboxes allow users to select a subset of options. If you want to offer an off/on setting you should use the Switch control instead.` app = `z2ui5_cl_demo_app_239` )
      ( group = `controls` header = `sap.m.DatePicker` sub = `This example shows different DatePicker value states.` app = `z2ui5_cl_demo_app_294` )
      ( group = `controls` header = `sap.m.DateRangeSelection` sub = `The Date Range Selection is an extension of the Date Picker Control and enables the user to select range of dates.` app = `z2ui5_cl_demo_app_231` )
      ( group = `controls` header = `sap.m.DateRangeSelection` sub = `This example shows different DateRangeSelection value states.` app = `z2ui5_cl_demo_app_295` )
      ( group = `controls` header = `sap.m.FeedContent` sub = `Shows the tile containing the text of the feed, a subheader, and a numeric value.` app = `z2ui5_cl_demo_app_275` )
      ( group = `controls` header = `sap.m.FlexBox` sub = `Flex items can be rendered differently. By default, they are wrapped in a div element. Optionally, the bare controls can be rendered directly. This can affect the resulting layout.` app = `z2ui5_cl_demo_app_252` )
      ( group = `controls` header = `sap.m.FlexBox` sub = `You can influence the direction and order of elements in horizontal and vertical Flex Box controls with the direction property.` app = `z2ui5_cl_demo_app_245` )
      ( group = `controls` header = `sap.m.GenericTag` sub = `Previews of the GenericTag control based on combinations of different sets of properties.` app = `z2ui5_cl_demo_app_257` )
      ( group = `controls` header = `sap.m.GenericTile` sub = `Shows Monitor Tile samples that can contain header, subheader, icon, key value, unit, and a footer.` app = `z2ui5_cl_demo_app_276` )
      ( group = `controls` header = `sap.m.HeaderContainer` sub = `The Header Container with a vertical layout and with divider lines.` app = `z2ui5_cl_demo_app_280` )
      ( group = `controls` header = `sap.m.Input` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_246` )
      ( group = `controls` header = `sap.m.Input` sub = `This sample illustrates the usage of the description with input fields, e.g. description for units of measurements and currencies.` app = `z2ui5_cl_demo_app_251` )
      ( group = `controls` header = `sap.m.Link` sub = `Here are some links. Typically links are used in user interfaces to trigger navigation to related content inside or outside of the current application.` app = `z2ui5_cl_demo_app_293` )
      ( group = `controls` header = `sap.m.MessageStrip` sub = `A sample MessageStrip that shows status messages with additional formatting.` app = `z2ui5_cl_demo_app_291` )
      ( group = `controls` header = `sap.m.MessageStrip` sub = `MessageStrip for showing status messages.` app = `z2ui5_cl_demo_app_238` )
      ( group = `controls` header = `sap.m.MultiInput` sub = `This sample illustrates the different value states of the sap.m.MultiInput control.` app = `z2ui5_cl_demo_app_267` )
      ( group = `controls` header = `sap.m.NumericContent` sub = `Shows NumericContent including an icon.` app = `z2ui5_cl_demo_app_263` )
      ( group = `controls` header = `sap.m.NumericContent` sub = `Shows NumericContent including numbers, units of measurement, and status arrows indicating a trend. The numbers can be colored according to their meaning.` app = `z2ui5_cl_demo_app_262` )
      ( group = `controls` header = `sap.m.ObjectAttribute` sub = `This is an example of Object Attribute used inside Table.` app = `z2ui5_cl_demo_app_302` )
      ( group = `controls` header = `sap.m.ObjectListItem` sub = `This sample shows the different states of an Object List Item, which can be set using the markers aggregation.` app = `z2ui5_cl_demo_app_290` )
      ( group = `controls` header = `sap.m.ObjectMarker` sub = `The ObjectMarker is a small building block representing an object by an icon or text and icon. Often it is used in a table.` app = `z2ui5_cl_demo_app_289` )
      ( group = `controls` header = `sap.m.ObjectStatus` sub = `The object status is a small building block representing a status with a semantic color.` app = `z2ui5_cl_demo_app_300` )
      ( group = `controls` header = `sap.m.OverflowToolbar` sub = `OverflowToolbar and Toolbar are often used for left/right alignment. This is easily achieved with ToolbarSpacer.` app = `z2ui5_cl_demo_app_250` )
      ( group = `controls` header = `sap.m.SearchField` sub = `Use the Search Field to let the user enter a search string and trigger the search process.` app = `z2ui5_cl_demo_app_296` )
      ( group = `controls` header = `sap.m.Select` sub = `Illustrates how the text in items wrap.` app = `z2ui5_cl_demo_app_299` )
      ( group = `controls` header = `sap.m.Select` sub = `Illustrates the usage of a Select in header, footer and content of a page. Note the different display options.` app = `z2ui5_cl_demo_app_288` )
      ( group = `controls` header = `sap.m.Select` sub = `Illustrates the usage of a Select with icons` app = `z2ui5_cl_demo_app_297` )
      ( group = `controls` header = `sap.m.Select` sub = `Visualizes the validation state of the control, for example, Error, Warning and Success.` app = `z2ui5_cl_demo_app_298` )
      ( group = `controls` header = `sap.m.StandardListItem` sub = `This sample demonstrates the wrapping behavior of the title text and the description text. In desktop mode, the character limit is set to 300 characters, whereas in the phone mode, the character limit is set to 100 characters.` app = `z2ui5_cl_demo_app_287` )
      ( group = `controls` header = `sap.m.StepInput` sub = `This example shows different StepInput value states.` app = `z2ui5_cl_demo_app_264` )
      ( group = `controls` header = `sap.m.Switch` sub = `"Some say it is only a switch, I say it is one of the most stylish controls in the universe of mobile UI controls." (unknown developer)` app = `z2ui5_cl_demo_app_240` )
      ( group = `controls` header = `sap.m.TileContent` sub = `Shows the universal container for different content types and context information in the footer area.` app = `z2ui5_cl_demo_app_241` )
      ( group = `controls` header = `sap.ui.core.HTML` sub = `With the HTML controls you can easily embed any kind of HTML content into your UI5 mobile application.` app = `z2ui5_cl_demo_app_242` )
      ( group = `controls` header = `sap.ui.core.InvisibleText` sub = `Many controls provide the associations ariaLabelledBy and ariaDescribedBy for accessibility purposes. The InvisibleText control can be used by application to provide hidden texts on the UI which can be referenced via these associations.` app = `z2ui5_cl_demo_app_282` )
      ( group = `controls` header = `sap.ui.layout.Splitter` sub = `Nested Splitter example with 7 content areas` app = `z2ui5_cl_demo_app_260` )
      ( group = `controls` header = `sap.ui.layout.Splitter` sub = `Simple splitter example with three content areas` app = `z2ui5_cl_demo_app_249` )
      ( group = `controls` header = `sap.ui.layout.Splitter` sub = `Simple splitter example with two content areas` app = `z2ui5_cl_demo_app_247` )
      ( group = `controls` header = `sap.ui.layout.Splitter` sub = `Simple splitter example with two content areas that cannot be resized` app = `z2ui5_cl_demo_app_248` ) ).

  ENDMETHOD.


  METHOD block_widths.

    LOOP AT t_catalog INTO DATA(tile).

      DATA(base) = header_base( tile-header ).
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

ENDCLASS.
