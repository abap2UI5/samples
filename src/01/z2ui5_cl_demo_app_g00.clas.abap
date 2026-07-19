CLASS z2ui5_cl_demo_app_g00 DEFINITION PUBLIC.

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
    METHODS block_base
      IMPORTING
        group         TYPE string
        header        TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_g00 IMPLEMENTATION.

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

    IF class_exists( `Z2UI5_CL_SAMPLE_APP_G01` ) = abap_true.
      DATA(url_restricted) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_sample_app_g01|.
      page->header_content( )->button(
          text  = `Extended Samples`
          icon  = `sap-icon://action`
          press = client->_event_client( val   = client->cs_event-open_new_tab
                                         t_arg = VALUE #( ( url_restricted ) ) ) ).
    ENDIF.

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
      ( group = `Basic I` header = `Action` sub = `Call Method of Object` app = `z2ui5_cl_demo_app_446` )
      ( group = `Basic I` header = `Action` sub = `Call Method of Object by ID` app = `z2ui5_cl_demo_app_447` )
      ( group = `Basic I` header = `Binding` sub = `Expression Binding` app = `z2ui5_cl_demo_app_027` )
      ( group = `Basic I` header = `Binding` sub = `Formatting Currencies` app = `z2ui5_cl_demo_app_067` )
      ( group = `Basic I` header = `Binding` sub = `Formatting Integers, Decimals, Dates & Time` app = `z2ui5_cl_demo_app_047` )
      ( group = `Basic I` header = `Binding` sub = `Level Structure/Component` app = `z2ui5_cl_demo_app_166` )
      ( group = `Basic I` header = `Binding` sub = `Level Table/Cell` app = `z2ui5_cl_demo_app_144` )
      ( group = `Basic I` header = `Event` sub = `Additional Infos with t_args` app = `z2ui5_cl_demo_app_167` )
      ( group = `Basic I` header = `Event` sub = `Facet Filter T_arg with Objects` app = `z2ui5_cl_demo_app_197` )
      ( group = `Basic I` header = `Event` sub = `Handle events & change the view` app = `z2ui5_cl_demo_app_004` )
      ( group = `Basic I` header = `Formatter` sub = `Date Object for DatePicker` app = `z2ui5_cl_demo_app_457` )
      ( group = `Basic I` header = `Formatter` sub = `Date Objects for PlanningCalendar` app = `z2ui5_cl_demo_app_456` )
      ( group = `Basic I` header = `Formatter` sub = `Simple` app = `z2ui5_cl_demo_app_453` )
      ( group = `Basic I` header = `Formatter` sub = `Use via core:require` app = `z2ui5_cl_demo_app_450` )
      ( group = `Basic I` header = `Message` sub = `Backend Processing` app = `z2ui5_cl_demo_app_008` )
      ( group = `Basic I` header = `Message` sub = `MessageBox` app = `z2ui5_cl_demo_app_382` )
      ( group = `Basic I` header = `Message` sub = `MessageToast` app = `z2ui5_cl_demo_app_381` )
      ( group = `Basic I` header = `Message` sub = `MessageView` app = `z2ui5_cl_demo_app_452` )
      ( group = `Basic I` header = `Model` sub = `Device Model` app = `z2ui5_cl_demo_app_445` )
      ( group = `Basic I` header = `Model` sub = `Message Model` app = `z2ui5_cl_demo_app_458` )
      ( group = `Basic I` header = `Model` sub = `Set Size Limit` app = `z2ui5_cl_demo_app_071` )
      ( group = `Basic I` header = `More` sub = `Call and leave to apps` app = `z2ui5_cl_demo_app_024` )
      ( group = `Basic I` header = `More` sub = `Error Handling` app = `z2ui5_cl_demo_app_464` )
      ( group = `Basic I` header = `More` sub = `Generic Data Reference` app = `z2ui5_cl_demo_app_061` )
      ( group = `Basic I` header = `More` sub = `Read Frontend Infos` app = `z2ui5_cl_demo_app_122` )
      ( group = `Basic I` header = `More` sub = `Require Object in XML View` app = `z2ui5_cl_demo_app_163` )
      ( group = `Basic I` header = `Nested Views` sub = `Basic Example` app = `z2ui5_cl_demo_app_065` )
      ( group = `Basic I` header = `Nested Views` sub = `Head & Item Table` app = `z2ui5_cl_demo_app_097` )
      ( group = `Basic I` header = `Nested Views` sub = `Head & Item Table & Detail` app = `z2ui5_cl_demo_app_098` )
      ( group = `Basic I` header = `Nested Views` sub = `Sub-App` app = `z2ui5_cl_demo_app_104` )
      ( group = `Basic I` header = `Popover` sub = `Display Quick View` app = `z2ui5_cl_demo_app_109` )
      ( group = `Basic I` header = `Popover` sub = `Item Level of Table` app = `z2ui5_cl_demo_app_052` )
      ( group = `Basic I` header = `Popover` sub = `List to select in Popover` app = `z2ui5_cl_demo_app_081` )
      ( group = `Basic I` header = `Popover` sub = `Simple Example` app = `z2ui5_cl_demo_app_026` )
      ( group = `Basic I` header = `Popup` sub = `Different ways of calling Popups` app = `z2ui5_cl_demo_app_012` )
      ( group = `Basic I` header = `Popup` sub = `Popup in Popup - Backend Stack Handling` app = `z2ui5_cl_demo_app_161` )
      ( group = `Basic I` header = `Popup` sub = `Value Help with Popups` app = `z2ui5_cl_demo_app_009` )
      ( group = `Basic I` header = `Templating` sub = `Basic Example` app = `z2ui5_cl_demo_app_173` )
      ( group = `Basic I` header = `Templating` sub = `Nested Views` app = `z2ui5_cl_demo_app_176` )
      ( group = `Basic II` header = `Browser` sub = `Logout (A)` app = `z2ui5_cl_demo_app_361` )
      ( group = `Basic II` header = `Browser` sub = `Open an URL in a new tab (A)` app = `z2ui5_cl_demo_app_073` )
      ( group = `Basic II` header = `Browser` sub = `Open Telephon, Email usw (A)` app = `z2ui5_cl_demo_app_316` )
      ( group = `Basic II` header = `Browser` sub = `Title (A)` app = `z2ui5_cl_demo_app_125` )
      ( group = `Basic II` header = `Focus` sub = `Jump with the focus (A)` app = `z2ui5_cl_demo_app_189` )
      ( group = `Basic II` header = `Focus` sub = `Set Focus in Textfield (A)` app = `z2ui5_cl_demo_app_133` )
      ( group = `Basic II` header = `Input` sub = `Clipboard (A)` app = `z2ui5_cl_demo_app_325` )
      ( group = `Basic II` header = `Input` sub = `Hide/show Soft Keyboard (A)` app = `z2ui5_cl_demo_app_352` )
      ( group = `Basic II` header = `List` sub = `Events & Visualization` app = `z2ui5_cl_demo_app_048` )
      ( group = `Basic II` header = `List` sub = `Frontend Filter/Sort via Backend Event (A)` app = `z2ui5_cl_demo_app_454` )
      ( group = `Basic II` header = `List` sub = `Frontend Live Filter without Backend (A)` app = `z2ui5_cl_demo_app_455` )
      ( group = `Basic II` header = `More` sub = `CameraSelector (C)` app = `z2ui5_cl_demo_app_306` )
      ( group = `Basic II` header = `More` sub = `Data Loss Protection (C)` app = `z2ui5_cl_demo_app_279` )
      ( group = `Basic II` header = `More` sub = `File Uploader (C)` app = `z2ui5_cl_demo_app_074` )
      ( group = `Basic II` header = `More` sub = `Geoloaction (C)` app = `z2ui5_cl_demo_app_120` )
      ( group = `Basic II` header = `More` sub = `Multi Input (C)` app = `z2ui5_cl_demo_app_078` )
      ( group = `Basic II` header = `More` sub = `Panel, setExpanded (A)` app = `z2ui5_cl_demo_app_448` )
      ( group = `Basic II` header = `More` sub = `PDF Viewer Display (A)` app = `z2ui5_cl_demo_app_449` )
      ( group = `Basic II` header = `More` sub = `Wizard Control (A)` app = `z2ui5_cl_demo_app_202` )
      ( group = `Basic II` header = `NavContainer` sub = `Popup (A)` app = `z2ui5_cl_demo_app_170` )
      ( group = `Basic II` header = `NavContainer` sub = `Simple (A)` app = `z2ui5_cl_demo_app_088` )
      ( group = `Basic II` header = `Scroll` sub = `Scroll into view (A)` app = `z2ui5_cl_demo_app_363` )
      ( group = `Basic II` header = `Scroll` sub = `Scroll to position (A)` app = `z2ui5_cl_demo_app_362` )
      ( group = `Basic II` header = `Table` sub = `Backend Filter` app = `z2ui5_cl_demo_app_045` )
      ( group = `Basic II` header = `Table` sub = `Drag and Drop (A)` app = `z2ui5_cl_demo_app_459` )
      ( group = `Basic II` header = `Table` sub = `Editable` app = `z2ui5_cl_demo_app_011` )
      ( group = `Basic II` header = `Table` sub = `Live Search via Backend` app = `z2ui5_cl_demo_app_059` )
      ( group = `Basic II` header = `Table` sub = `Search via Backend` app = `z2ui5_cl_demo_app_053` )
      ( group = `Basic II` header = `Table` sub = `Selection Modes: Single Select & Multi Select` app = `z2ui5_cl_demo_app_019` )
      ( group = `Basic II` header = `Table` sub = `Table with ScrollContainer` app = `z2ui5_cl_demo_app_006` )
      ( group = `Basic II` header = `Timer` sub = `Loading Indicator with WAIT UP Backend (A)` app = `z2ui5_cl_demo_app_064` )
      ( group = `Basic II` header = `Timer` sub = `Wait n MS and call again the server (A)` app = `z2ui5_cl_demo_app_028` )
      ( group = `Basic II` header = `Tree` sub = `Drag and Drop (A,C)` app = `z2ui5_cl_demo_app_461` )
      ( group = `Basic II` header = `Tree` sub = `Editable with Custom Item (C)` app = `z2ui5_cl_demo_app_463` )
      ( group = `Basic II` header = `Tree` sub = `Inside Popup (C)` app = `z2ui5_cl_demo_app_462` )
      ( group = `Basic II` header = `Tree` sub = `Simple` app = `z2ui5_cl_demo_app_460` )
      ( group = `Basic II` header = `ui.Table` sub = `Default Filtering (C)` app = `z2ui5_cl_demo_app_143` )
      ( group = `Basic II` header = `ui.Table` sub = `Events on Cell Level` app = `z2ui5_cl_demo_app_160` )
      ( group = `Basic II` header = `ui.Table` sub = `Full Example` app = `z2ui5_cl_demo_app_070` )
      ( group = `controls - sap.m` header = `ActionListItem` sub = `Use the Action List Item to trigger an action directly from a list` app = `z2ui5_cl_demo_app_216` )
      ( group = `controls - sap.m` header = `Breadcrumbs` sub = `Breadcrumbs sample with current page set as aggregation, resulting in a link` app = `z2ui5_cl_demo_app_292` )
      ( group = `controls - sap.m` header = `BusyIndicator` sub = `The Busy Indicator signals that some operation is going on and that the user must wait ...` app = `z2ui5_cl_demo_app_215` )
      ( group = `controls - sap.m` header = `Button` sub = `Buttons trigger user actions and come in a variety of shapes and colors. Placing a button ...` app = `z2ui5_cl_demo_app_259` )
      ( group = `controls - sap.m` header = `Carousel` sub = `A sample of a Carousel that contains images.` app = `z2ui5_cl_demo_app_371` )
      ( group = `controls - sap.m` header = `CheckBox` sub = `Checkboxes allow users to select a subset of options. If you want to offer an off/on ...` app = `z2ui5_cl_demo_app_239` )
      ( group = `controls - sap.m` header = `ComboBox` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_229` )
      ( group = `controls - sap.m` header = `DatePicker` sub = `This example shows different DatePicker value states.` app = `z2ui5_cl_demo_app_294` )
      ( group = `controls - sap.m` header = `DateRangeSelection` sub = `This example shows different DateRangeSelection value states.` app = `z2ui5_cl_demo_app_295` )
      ( group = `controls - sap.m` header = `DateTimePicker` sub = `Value States` app = `z2ui5_cl_demo_app_377` )
      ( group = `controls - sap.m` header = `FeedContent` sub = `Shows the tile containing the text of the feed, a subheader, and a numeric value.` app = `z2ui5_cl_demo_app_275` )
      ( group = `controls - sap.m` header = `FeedInput` sub = `` app = `z2ui5_cl_demo_app_114` )
      ( group = `controls - sap.m` header = `FeedInput` sub = `This sample shows a standalone feed input with different settings.` app = `z2ui5_cl_demo_app_283` )
      ( group = `controls - sap.m` header = `FeedListItem` sub = `This sample shows you how to build a complete feed user interface by combining a ...` app = `z2ui5_cl_demo_app_101` )
      ( group = `controls - sap.m` header = `FlexBox` sub = `Flex Box items can be placed in different areas using the justifyContent and alignItem ...` app = `z2ui5_cl_demo_app_205` )
      ( group = `controls - sap.m` header = `FlexBox` sub = `Flex items can be rendered differently. By default, they are wrapped in a div element ...` app = `z2ui5_cl_demo_app_252` )
      ( group = `controls - sap.m` header = `FlexBox` sub = `In this Flex Box the items are aligned at opposing ends of the container with ...` app = `z2ui5_cl_demo_app_218` )
      ( group = `controls - sap.m` header = `FlexBox` sub = `You can influence the direction and order of elements in horizontal and vertical Flex Box ...` app = `z2ui5_cl_demo_app_245` )
      ( group = `controls - sap.m` header = `FormattedText` sub = `The control can be used for embedding formatted HTML text into your application.` app = `z2ui5_cl_demo_app_015` )
      ( group = `controls - sap.m` header = `GenericTag` sub = `Previews of the GenericTag control based on combinations of different sets of properties.` app = `z2ui5_cl_demo_app_257` )
      ( group = `controls - sap.m` header = `GenericTile` sub = `Shows Feed Tile and News Tile samples that can contain feed content, news content, and a ...` app = `z2ui5_cl_demo_app_278` )
      ( group = `controls - sap.m` header = `GenericTile` sub = `Shows Monitor Tile samples that can contain header, subheader, icon, key value, unit, and ...` app = `z2ui5_cl_demo_app_276` )
      ( group = `controls - sap.m` header = `GenericTile` sub = `Shows the GenericTile while it is loading, if loading fails, and in disabled status.` app = `z2ui5_cl_demo_app_281` )
      ( group = `controls - sap.m` header = `HeaderContainer` sub = `The Header Container with a vertical layout and with divider lines.` app = `z2ui5_cl_demo_app_280` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `In this example, the Icon Tab Bar is used to apply filters on a table and display the ...` app = `z2ui5_cl_demo_app_368` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `In this example, the Icon Tab Bar tabs display icons only.` app = `z2ui5_cl_demo_app_221` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `In this example, the Icon Tab Bar tabs display text and corresponding count.` app = `z2ui5_cl_demo_app_222` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `In this example, the Icon Tab Bar tabs display text only.` app = `z2ui5_cl_demo_app_224` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `In this example, the Icon Tab Bar tabs display the text and the count in one line.` app = `z2ui5_cl_demo_app_223` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `This is an example how to use separators in the Icon Tab Bar. You can choose an icon as a ...` app = `z2ui5_cl_demo_app_225` )
      ( group = `controls - sap.m` header = `IconTabBar` sub = `This sample illustrates nested tabs with or without own content in their root-level tab.` app = `z2ui5_cl_demo_app_226` )
      ( group = `controls - sap.m` header = `IconTabHeader` sub = `Icon Tab Header used standalone, outside of Icon Tab Bar.` app = `z2ui5_cl_demo_app_214` )
      ( group = `controls - sap.m` header = `Image` sub = `Images are faster than words and attract people's attention. Images can also have an ...` app = `z2ui5_cl_demo_app_379` )
      ( group = `controls - sap.m` header = `ImageContent` sub = `Shows ImageContent that can include an icon, a profile image, or a logo with a tooltip.` app = `z2ui5_cl_demo_app_271` )
      ( group = `controls - sap.m` header = `Input` sub = `Input type corresponds to the type attribute of the HTML input tag. On touch devices, it ...` app = `z2ui5_cl_demo_app_210` )
      ( group = `controls - sap.m` header = `Input` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_246` )
      ( group = `controls - sap.m` header = `Input` sub = `This sample illustrates the usage of the description with input fields, e.g. description ...` app = `z2ui5_cl_demo_app_251` )
      ( group = `controls - sap.m` header = `Input` sub = `To make sure the password is not shown as clear text you set the 'type' of an input ...` app = `z2ui5_cl_demo_app_213` )
      ( group = `controls - sap.m` header = `InputListItem` sub = `Use the Input List Item on phones to build form like user interfaces.` app = `z2ui5_cl_demo_app_219` )
      ( group = `controls - sap.m` header = `Label` sub = `Labels are helpful when you need to describe some other UI control.` app = `z2ui5_cl_demo_app_051` )
      ( group = `controls - sap.m` header = `LightBox` sub = `Displays several image thumbnails. Clicking on each of them will open a LightBox.` app = `z2ui5_cl_demo_app_273` )
      ( group = `controls - sap.m` header = `Link` sub = `Here are some links. Typically links are used in user interfaces to trigger navigation to ...` app = `z2ui5_cl_demo_app_293` )
      ( group = `controls - sap.m` header = `MaskInput` sub = `The sap.m.MaskInput control allows users to easily enter data in a certain format and in ...` app = `z2ui5_cl_demo_app_110` )
      ( group = `controls - sap.m` header = `MenuButton` sub = `This control is used to open a menu in both desktop and mobile.` app = `z2ui5_cl_demo_app_372` )
      ( group = `controls - sap.m` header = `MessageStrip` sub = `A sample MessageStrip that shows status messages with additional formatting.` app = `z2ui5_cl_demo_app_291` )
      ( group = `controls - sap.m` header = `MessageStrip` sub = `MessageStrip for showing status messages.` app = `z2ui5_cl_demo_app_238` )
      ( group = `controls - sap.m` header = `MessageView` sub = `A sample with Message View and inside a Dialog and grouping of items` app = `z2ui5_cl_demo_app_038` )
      ( group = `controls - sap.m` header = `MultiComboBox` sub = `` app = `z2ui5_cl_demo_app_140` )
      ( group = `controls - sap.m` header = `MultiComboBox` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_233` )
      ( group = `controls - sap.m` header = `MultiInput` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_232` )
      ( group = `controls - sap.m` header = `MultiInput` sub = `This sample illustrates the different value states of the sap.m.MultiInput control.` app = `z2ui5_cl_demo_app_267` )
      ( group = `controls - sap.m` header = `NewsContent` sub = `This control is used to display the news content text and subheader in a tile.` app = `z2ui5_cl_demo_app_261` )
      ( group = `controls - sap.m` header = `NotificationListItem` sub = `A list item suitable for showing notifications to the user.` app = `z2ui5_cl_demo_app_375` )
      ( group = `controls - sap.m` header = `NumericContent` sub = `Shows NumericContent including an icon.` app = `z2ui5_cl_demo_app_263` )
      ( group = `controls - sap.m` header = `NumericContent` sub = `Shows NumericContent including numbers, units of measurement, and status arrows ...` app = `z2ui5_cl_demo_app_262` )
      ( group = `controls - sap.m` header = `NumericContent` sub = `This is an example of the NumericContent that contains no margins, so the control is ...` app = `z2ui5_cl_demo_app_228` )
      ( group = `controls - sap.m` header = `ObjectAttribute` sub = `This is an example of Object Attribute used inside Table.` app = `z2ui5_cl_demo_app_302` )
      ( group = `controls - sap.m` header = `ObjectHeader` sub = `An Object Header can set shape of the image by using 'imageShape' property. The shapes ...` app = `z2ui5_cl_demo_app_272` )
      ( group = `controls - sap.m` header = `ObjectListItem` sub = `This sample shows the different states of an Object List Item, which can be set using the ...` app = `z2ui5_cl_demo_app_290` )
      ( group = `controls - sap.m` header = `ObjectMarker` sub = `The ObjectMarker is a small building block representing an object by an icon or text and ...` app = `z2ui5_cl_demo_app_289` )
      ( group = `controls - sap.m` header = `ObjectNumber` sub = `inside a Table` app = `z2ui5_cl_demo_app_369` )
      ( group = `controls - sap.m` header = `ObjectStatus` sub = `The object status is a small building block representing a status with a semantic color.` app = `z2ui5_cl_demo_app_300` )
      ( group = `controls - sap.m` header = `OverflowToolbar` sub = `OverflowToolbar and Toolbar are often used for left/right alignment. This is easily ...` app = `z2ui5_cl_demo_app_250` )
      ( group = `controls - sap.m` header = `OverflowToolbar` sub = `The sap.m.Title control can be used to place a title inside an OverflowToolbar/Toolbar.` app = `z2ui5_cl_demo_app_217` )
      ( group = `controls - sap.m` header = `Page` sub = `Each screen of a mobile application is typically represented by a 'Page' consisting of a ...` app = `z2ui5_cl_demo_app_227` )
      ( group = `controls - sap.m` header = `Page` sub = `Header, Sub-Header & Footer` app = `z2ui5_cl_demo_app_366` )
      ( group = `controls - sap.m` header = `Panel` sub = `Panels are helpful to group custom content. They can be decorated with header and info ...` app = `z2ui5_cl_demo_app_378` )
      ( group = `controls - sap.m` header = `ProgressIndicator` sub = `Shows the progress of a process in a graphical way. To indicate the progress, the inside ...` app = `z2ui5_cl_demo_app_022` )
      ( group = `controls - sap.m` header = `RadioButton` sub = `Typically the Radio Button is used by other controls. E.g. the List uses it for the ...` app = `z2ui5_cl_demo_app_207` )
      ( group = `controls - sap.m` header = `RadioButtonGroup` sub = `A wrapper for a group of radio buttons.` app = `z2ui5_cl_demo_app_208` )
      ( group = `controls - sap.m` header = `RangeSlider` sub = `` app = `z2ui5_cl_demo_app_005` )
      ( group = `controls - sap.m` header = `RatingIndicator` sub = `A Rating Indicator can be used to both indicate and/or rate content.` app = `z2ui5_cl_demo_app_220` )
      ( group = `controls - sap.m` header = `SearchField` sub = `Use the Search Field to let the user enter a search string and trigger the search process.` app = `z2ui5_cl_demo_app_296` )
      ( group = `controls - sap.m` header = `SegmentedButton` sub = `Segmented Button used in Input List Item component` app = `z2ui5_cl_demo_app_230` )
      ( group = `controls - sap.m` header = `Select` sub = `Illustrates how the text in items wrap.` app = `z2ui5_cl_demo_app_299` )
      ( group = `controls - sap.m` header = `Select` sub = `Illustrates the usage of a Select in header, footer and content of a page. Note the ...` app = `z2ui5_cl_demo_app_288` )
      ( group = `controls - sap.m` header = `Select` sub = `Illustrates the usage of a Select with icons` app = `z2ui5_cl_demo_app_297` )
      ( group = `controls - sap.m` header = `Select` sub = `Visualizes the validation state of the control, for example, Error, Warning and Success.` app = `z2ui5_cl_demo_app_298` )
      ( group = `controls - sap.m` header = `Slider` sub = `With the Slider a user can choose a value from a numerical range.` app = `z2ui5_cl_demo_app_237` )
      ( group = `controls - sap.m` header = `SlideTile` sub = `Shows Generic Tile with the 2x1 frame type displayed as sliding tiles.` app = `z2ui5_cl_demo_app_274` )
      ( group = `controls - sap.m` header = `SplitContainer` sub = `Master & Detail Pages` app = `z2ui5_cl_demo_app_374` )
      ( group = `controls - sap.m` header = `StandardListItem` sub = `This sample demonstrates the wrapping behavior of the title text and the description ...` app = `z2ui5_cl_demo_app_287` )
      ( group = `controls - sap.m` header = `StepInput` sub = `This example shows different StepInput value states.` app = `z2ui5_cl_demo_app_264` )
      ( group = `controls - sap.m` header = `Switch` sub = `"Some say it is only a switch, I say it is one of the most stylish controls in the ...` app = `z2ui5_cl_demo_app_240` )
      ( group = `controls - sap.m` header = `Text` sub = `The Text control has a property to limit the number of lines for wrapping texts.` app = `z2ui5_cl_demo_app_206` )
      ( group = `controls - sap.m` header = `Text` sub = `with class -Standard Margins - Negative Margins` app = `z2ui5_cl_demo_app_243` )
      ( group = `controls - sap.m` header = `TextArea` sub = `Since 1.38 the growing property of sap.m.TextArea gives the ability of a control to ...` app = `z2ui5_cl_demo_app_236` )
      ( group = `controls - sap.m` header = `TextArea` sub = `This sample illustrates the different value states of the sap.m.TextArea control.` app = `z2ui5_cl_demo_app_234` )
      ( group = `controls - sap.m` header = `TileContent` sub = `Shows the universal container for different content types and context information in the ...` app = `z2ui5_cl_demo_app_241` )
      ( group = `controls - sap.m` header = `TimePicker` sub = `Formats & Steps` app = `z2ui5_cl_demo_app_376` )
      ( group = `controls - sap.m` header = `ToggleButton` sub = `Toggle Buttons can be toggled between pressed and normal state.` app = `z2ui5_cl_demo_app_266` )
      ( group = `controls - sap.m` header = `Toolbar` sub = `Toolbar handles overflow by shrinking items. OverflowToolbar provides an overflow menu ...` app = `z2ui5_cl_demo_app_235` )
      ( group = `controls - sap.uxap` header = `ObjectPageLayout` sub = `Object Page sample showing a layout with subsection titles on top. This is the default ...` app = `z2ui5_cl_demo_app_017` )
      ( group = `controls - sap.uxap` header = `ObjectPageLayout` sub = `ObjectPage sample that demonstrates the combination of header facets and showTitle ...` app = `z2ui5_cl_demo_app_330` )
      ( group = `controls - sap.uxap` header = `ObjectPageLayout` sub = `ObjectPage sample with Header Container` app = `z2ui5_cl_demo_app_303` )
      ( group = `controls - sap.f` header = `Card` sub = `This sample illustrates how to specify the predefined header and the content of the Card ...` app = `z2ui5_cl_demo_app_181` )
      ( group = `controls - sap.f` header = `DynamicPage` sub = `Dynamic Page freestyle example with a responsive sap.m.Table in the content area, showing ...` app = `z2ui5_cl_demo_app_030` )
      ( group = `controls - sap.f` header = `GridList` sub = `This sample represents GridList with enabled Drag and Drop functionality.` app = `z2ui5_cl_demo_app_307` )
      ( group = `controls - sap.ui.core` header = `HTML` sub = `With the HTML controls you can easily embed any kind of HTML content into your UI5 mobile ...` app = `z2ui5_cl_demo_app_242` )
      ( group = `controls - sap.ui.core` header = `InvisibleText` sub = `Many controls provide the associations ariaLabelledBy and ariaDescribedBy for ...` app = `z2ui5_cl_demo_app_282` )
      ( group = `controls - sap.ui.layout` header = `Grid` sub = `Split View in different Areas` app = `z2ui5_cl_demo_app_367` )
      ( group = `controls - sap.ui.layout` header = `ResponsiveSplitter` sub = `ResponsiveSplitter is used to visually divide the content of its parent. It consists of ...` app = `z2ui5_cl_demo_app_103` )
      ( group = `controls - sap.ui.layout` header = `Splitter` sub = `Nested Splitter example with 7 content areas` app = `z2ui5_cl_demo_app_260` )
      ( group = `controls - sap.ui.layout` header = `Splitter` sub = `Simple splitter example with three content areas` app = `z2ui5_cl_demo_app_249` )
      ( group = `controls - sap.ui.layout` header = `Splitter` sub = `Simple splitter example with two content areas` app = `z2ui5_cl_demo_app_247` )
      ( group = `controls - sap.ui.layout` header = `Splitter` sub = `Simple splitter example with two content areas that cannot be resized` app = `z2ui5_cl_demo_app_248` )
      ( group = `controls - sap.tnt` header = `InfoLabel` sub = `InfoLabel with all available color schemes` app = `z2ui5_cl_demo_app_209` )
      ( group = `controls - sap.tnt` header = `NavigationList` sub = `simple` app = `z2ui5_cl_demo_app_258` )
      ( group = `controls - sap.ui.codeeditor` header = `CodeEditor` sub = `` app = `z2ui5_cl_demo_app_265` )
      ( group = `controls - sap.ui.unified` header = `ColorPicker` sub = `` app = `z2ui5_cl_demo_app_270` ) ).

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
