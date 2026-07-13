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
      ( group = `controls - sap.m` header = `sap.m.ActionListItem` sub = `Use the Action List Item to trigger an action directly from a list` app = `z2ui5_cl_demo_app_216` )
      ( group = `controls - sap.m` header = `sap.m.ActionSheet`
        sub = `Action Sheet provides an easier way of showing a list of actions and allowing the user to select one. Title and Cancel button can be shown or hidden. Without an icon the entry will be left-aligned (see the last action in the list).`
        app = `z2ui5_cl_demo_app_373` )
      ( group = `controls - sap.m` header = `sap.m.Breadcrumbs` sub = `Breadcrumbs sample with current page set as aggregation, resulting in a link` app = `z2ui5_cl_demo_app_292` )
      ( group = `controls - sap.m` header = `sap.m.BusyIndicator`
        sub = `The Busy Indicator signals that some operation is going on and that the user must wait. It does not block the current UI screen so other operations could be triggered in parallel.`
        app = `z2ui5_cl_demo_app_215` )
      ( group = `controls - sap.m` header = `sap.m.Button` sub = `Buttons trigger user actions and come in a variety of shapes and colors. Placing a button on a page header or footer changes its appearance.` app = `z2ui5_cl_demo_app_259` )
      ( group = `controls - sap.m` header = `sap.m.Carousel` sub = `A sample of a Carousel that contains images.` app = `z2ui5_cl_demo_app_371` )
      ( group = `controls - sap.m` header = `sap.m.CheckBox` sub = `Checkboxes allow users to select a subset of options. If you want to offer an off/on setting you should use the Switch control instead.` app = `z2ui5_cl_demo_app_239` )
      ( group = `controls - sap.m` header = `sap.m.ComboBox` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_229` )
      ( group = `controls - sap.m` header = `sap.m.DatePicker` sub = `This example shows different DatePicker value states.` app = `z2ui5_cl_demo_app_294` )
      ( group = `controls - sap.m` header = `sap.m.DateRangeSelection` sub = `The Date Range Selection is an extension of the Date Picker Control and enables the user to select range of dates.` app = `z2ui5_cl_demo_app_231` )
      ( group = `controls - sap.m` header = `sap.m.DateRangeSelection` sub = `This example shows different DateRangeSelection value states.` app = `z2ui5_cl_demo_app_295` )
      ( group = `controls - sap.m` header = `sap.m.FeedContent` sub = `Shows the tile containing the text of the feed, a subheader, and a numeric value.` app = `z2ui5_cl_demo_app_275` )
      ( group = `controls - sap.m` header = `sap.m.FeedInput` sub = `This sample shows a standalone feed input with different settings.` app = `z2ui5_cl_demo_app_283` )
      ( group = `controls - sap.m` header = `sap.m.FeedListItem` sub = `This sample shows you how to build a complete feed user interface by combining a FeedInput with a list of FeedListItems.` app = `z2ui5_cl_demo_app_101` )
      ( group = `controls - sap.m` header = `sap.m.FlexBox` sub = `Flex Box items can be placed in different areas using the justifyContent and alignItem properties.` app = `z2ui5_cl_demo_app_205` )
      ( group = `controls - sap.m` header = `sap.m.FlexBox`
        sub = `Flex items can be rendered differently. By default, they are wrapped in a div element. Optionally, the bare controls can be rendered directly. This can affect the resulting layout.`
        app = `z2ui5_cl_demo_app_252` )
      ( group = `controls - sap.m` header = `sap.m.FlexBox` sub = `In this Flex Box the items are aligned at opposing ends of the container with justifyContent set to 'SpaceBetween'.` app = `z2ui5_cl_demo_app_218` )
      ( group = `controls - sap.m` header = `sap.m.FlexBox` sub = `You can influence the direction and order of elements in horizontal and vertical Flex Box controls with the direction property.` app = `z2ui5_cl_demo_app_245` )
      ( group = `controls - sap.m` header = `sap.m.FormattedText` sub = `The control can be used for embedding formatted HTML text into your application.` app = `z2ui5_cl_demo_app_015` )
      ( group = `controls - sap.m` header = `sap.m.GenericTag` sub = `Previews of the GenericTag control based on combinations of different sets of properties.` app = `z2ui5_cl_demo_app_257` )
      ( group = `controls - sap.m` header = `sap.m.GenericTile` sub = `Shows Feed Tile and News Tile samples that can contain feed content, news content, and a footer.` app = `z2ui5_cl_demo_app_278` )
      ( group = `controls - sap.m` header = `sap.m.GenericTile` sub = `Shows Monitor Tile samples that can contain header, subheader, icon, key value, unit, and a footer.` app = `z2ui5_cl_demo_app_276` )
      ( group = `controls - sap.m` header = `sap.m.GenericTile` sub = `Shows the GenericTile while it is loading, if loading fails, and in disabled status.` app = `z2ui5_cl_demo_app_281` )
      ( group = `controls - sap.m` header = `sap.m.HeaderContainer` sub = `The Header Container with a vertical layout and with divider lines.` app = `z2ui5_cl_demo_app_280` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `In this example, the Icon Tab Bar is used to apply filters on a table and display the count of the items for each view.` app = `z2ui5_cl_demo_app_368` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `In this example, the Icon Tab Bar tabs display icons only.` app = `z2ui5_cl_demo_app_221` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `In this example, the Icon Tab Bar tabs display text and corresponding count.` app = `z2ui5_cl_demo_app_222` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `In this example, the Icon Tab Bar tabs display text only.` app = `z2ui5_cl_demo_app_224` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `In this example, the Icon Tab Bar tabs display the text and the count in one line.` app = `z2ui5_cl_demo_app_223` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `This is an example how to use separators in the Icon Tab Bar. You can choose an icon as a separator or use the default vertical line.` app = `z2ui5_cl_demo_app_225` )
      ( group = `controls - sap.m` header = `sap.m.IconTabBar` sub = `This sample illustrates nested tabs with or without own content in their root-level tab.` app = `z2ui5_cl_demo_app_226` )
      ( group = `controls - sap.m` header = `sap.m.IconTabHeader` sub = `Icon Tab Header used standalone, outside of Icon Tab Bar.` app = `z2ui5_cl_demo_app_214` )
      ( group = `controls - sap.m` header = `sap.m.Image` sub = `Images are faster than words and attract people's attention. Images can also have an active state or be used in SVG format.` app = `z2ui5_cl_demo_app_379` )
      ( group = `controls - sap.m` header = `sap.m.ImageContent` sub = `Shows ImageContent that can include an icon, a profile image, or a logo with a tooltip.` app = `z2ui5_cl_demo_app_271` )
      ( group = `controls - sap.m` header = `sap.m.Input`
        sub = `Input type corresponds to the type attribute of the HTML input tag. On touch devices, it controls the keyboard layout. On desktop, the effect of this setting is browser dependent.`
        app = `z2ui5_cl_demo_app_210` )
      ( group = `controls - sap.m` header = `sap.m.Input` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_246` )
      ( group = `controls - sap.m` header = `sap.m.Input` sub = `This sample illustrates the usage of the description with input fields, e.g. description for units of measurements and currencies.` app = `z2ui5_cl_demo_app_251` )
      ( group = `controls - sap.m` header = `sap.m.Input` sub = `To make sure the password is not shown as clear text you set the 'type' of an input control to 'Password'.` app = `z2ui5_cl_demo_app_213` )
      ( group = `controls - sap.m` header = `sap.m.InputListItem` sub = `Use the Input List Item on phones to build form like user interfaces.` app = `z2ui5_cl_demo_app_219` )
      ( group = `controls - sap.m` header = `sap.m.Label` sub = `Labels are helpful when you need to describe some other UI control.` app = `z2ui5_cl_demo_app_051` )
      ( group = `controls - sap.m` header = `sap.m.LightBox` sub = `Displays several image thumbnails. Clicking on each of them will open a LightBox.` app = `z2ui5_cl_demo_app_273` )
      ( group = `controls - sap.m` header = `sap.m.Link` sub = `Here are some links. Typically links are used in user interfaces to trigger navigation to related content inside or outside of the current application.` app = `z2ui5_cl_demo_app_293` )
      ( group = `controls - sap.m` header = `sap.m.MaskInput`
        sub = `The sap.m.MaskInput control allows users to easily enter data in a certain format and in a fixed- width input (for example: date, time, credit card number, and others).`
        app = `z2ui5_cl_demo_app_110` )
      ( group = `controls - sap.m` header = `sap.m.MenuButton` sub = `This control is used to open a menu in both desktop and mobile.` app = `z2ui5_cl_demo_app_372` )
      ( group = `controls - sap.m` header = `sap.m.MessageStrip` sub = `A sample MessageStrip that shows status messages with additional formatting.` app = `z2ui5_cl_demo_app_291` )
      ( group = `controls - sap.m` header = `sap.m.MessageStrip` sub = `MessageStrip for showing status messages.` app = `z2ui5_cl_demo_app_238` )
      ( group = `controls - sap.m` header = `sap.m.MessageView` sub = `A sample with Message View and inside a Dialog and grouping of items` app = `z2ui5_cl_demo_app_038` )
      ( group = `controls - sap.m` header = `sap.m.MultiComboBox` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_233` )
      ( group = `controls - sap.m` header = `sap.m.MultiInput` sub = `Suggestions wrap automatically when longer then the dropdown width` app = `z2ui5_cl_demo_app_232` )
      ( group = `controls - sap.m` header = `sap.m.MultiInput` sub = `This sample illustrates the different value states of the sap.m.MultiInput control.` app = `z2ui5_cl_demo_app_267` )
      ( group = `controls - sap.m` header = `sap.m.NewsContent` sub = `This control is used to display the news content text and subheader in a tile.` app = `z2ui5_cl_demo_app_261` )
      ( group = `controls - sap.m` header = `sap.m.NotificationListItem` sub = `A list item suitable for showing notifications to the user.` app = `z2ui5_cl_demo_app_375` )
      ( group = `controls - sap.m` header = `sap.m.NumericContent` sub = `Shows NumericContent including an icon.` app = `z2ui5_cl_demo_app_263` )
      ( group = `controls - sap.m` header = `sap.m.NumericContent`
        sub = `Shows NumericContent including numbers, units of measurement, and status arrows indicating a trend. The numbers can be colored according to their meaning.`
        app = `z2ui5_cl_demo_app_262` )
      ( group = `controls - sap.m` header = `sap.m.NumericContent` sub = `This is an example of the NumericContent that contains no margins, so the control is aligned to the left and to the top without any margins.` app = `z2ui5_cl_demo_app_228` )
      ( group = `controls - sap.m` header = `sap.m.ObjectAttribute` sub = `This is an example of Object Attribute used inside Table.` app = `z2ui5_cl_demo_app_302` )
      ( group = `controls - sap.m` header = `sap.m.ObjectHeader`
        sub = `An Object Header can set shape of the image by using 'imageShape' property. The shapes could be Square (by default) and Circle. Note: This example shows the image inside ObjectHeader with the responsive property set to true. On phone i` &&
              `n portrait mode, the image is hidden.`
        app = `z2ui5_cl_demo_app_272` )
      ( group = `controls - sap.m` header = `sap.m.ObjectListItem` sub = `This sample shows the different states of an Object List Item, which can be set using the markers aggregation.` app = `z2ui5_cl_demo_app_290` )
      ( group = `controls - sap.m` header = `sap.m.ObjectMarker` sub = `The ObjectMarker is a small building block representing an object by an icon or text and icon. Often it is used in a table.` app = `z2ui5_cl_demo_app_289` )
      ( group = `controls - sap.m` header = `sap.m.ObjectStatus` sub = `The object status is a small building block representing a status with a semantic color.` app = `z2ui5_cl_demo_app_300` )
      ( group = `controls - sap.m` header = `sap.m.OverflowToolbar` sub = `OverflowToolbar and Toolbar are often used for left/right alignment. This is easily achieved with ToolbarSpacer.` app = `z2ui5_cl_demo_app_250` )
      ( group = `controls - sap.m` header = `sap.m.OverflowToolbar` sub = `The sap.m.Title control can be used to place a title inside an OverflowToolbar/Toolbar.` app = `z2ui5_cl_demo_app_217` )
      ( group = `controls - sap.m` header = `sap.m.Page`
        sub = `Each screen of a mobile application is typically represented by a 'Page' consisting of a header, a scrollable content area and optionally a footer. The standard header offers a navigation button and a title. Alternatively you can provi` &&
              `de a customer header. Gernerally you should use Toolbars in the Page. If you need a centered title you may use a Bar.`
        app = `z2ui5_cl_demo_app_227` )
      ( group = `controls - sap.m` header = `sap.m.Panel` sub = `Panels are helpful to group custom content. They can be decorated with header and info toolbars.` app = `z2ui5_cl_demo_app_378` )
      ( group = `controls - sap.m` header = `sap.m.PlanningCalendar` sub = `PlanningCalendar with single row selection that illustrates the built-in views.` app = `z2ui5_cl_demo_app_080` )
      ( group = `controls - sap.m` header = `sap.m.ProgressIndicator` sub = `Shows the progress of a process in a graphical way. To indicate the progress, the inside of the ProgressIndicator is filled with a color.` app = `z2ui5_cl_demo_app_022` )
      ( group = `controls - sap.m` header = `sap.m.RadioButton`
        sub = `Typically the Radio Button is used by other controls. E.g. the List uses it for the single selection. But you can also use the Radio Buttons control directly, to allow selection of exactly one of multiple options.`
        app = `z2ui5_cl_demo_app_207` )
      ( group = `controls - sap.m` header = `sap.m.RadioButtonGroup` sub = `A wrapper for a group of radio buttons.` app = `z2ui5_cl_demo_app_208` )
      ( group = `controls - sap.m` header = `sap.m.RatingIndicator` sub = `A Rating Indicator can be used to both indicate and/or rate content.` app = `z2ui5_cl_demo_app_220` )
      ( group = `controls - sap.m` header = `sap.m.SearchField` sub = `Use the Search Field to let the user enter a search string and trigger the search process.` app = `z2ui5_cl_demo_app_296` )
      ( group = `controls - sap.m` header = `sap.m.SegmentedButton` sub = `Segmented Button used in Input List Item component` app = `z2ui5_cl_demo_app_230` )
      ( group = `controls - sap.m` header = `sap.m.Select` sub = `Illustrates how the text in items wrap.` app = `z2ui5_cl_demo_app_299` )
      ( group = `controls - sap.m` header = `sap.m.Select` sub = `Illustrates the usage of a Select in header, footer and content of a page. Note the different display options.` app = `z2ui5_cl_demo_app_288` )
      ( group = `controls - sap.m` header = `sap.m.Select` sub = `Illustrates the usage of a Select with icons` app = `z2ui5_cl_demo_app_297` )
      ( group = `controls - sap.m` header = `sap.m.Select` sub = `Visualizes the validation state of the control, for example, Error, Warning and Success.` app = `z2ui5_cl_demo_app_298` )
      ( group = `controls - sap.m` header = `sap.m.Slider` sub = `With the Slider a user can choose a value from a numerical range.` app = `z2ui5_cl_demo_app_237` )
      ( group = `controls - sap.m` header = `sap.m.SlideTile` sub = `Shows Generic Tile with the 2x1 frame type displayed as sliding tiles.` app = `z2ui5_cl_demo_app_274` )
      ( group = `controls - sap.m` header = `sap.m.StandardListItem`
        sub = `This sample demonstrates the wrapping behavior of the title text and the description text. In desktop mode, the character limit is set to 300 characters, whereas in the phone mode, the character limit is set to 100 characters.`
        app = `z2ui5_cl_demo_app_287` )
      ( group = `controls - sap.m` header = `sap.m.StepInput` sub = `This example shows different StepInput value states.` app = `z2ui5_cl_demo_app_264` )
      ( group = `controls - sap.m` header = `sap.m.Switch` sub = `"Some say it is only a switch, I say it is one of the most stylish controls in the universe of mobile UI controls." (unknown developer)` app = `z2ui5_cl_demo_app_240` )
      ( group = `controls - sap.m` header = `sap.m.Text` sub = `The Text control has a property to limit the number of lines for wrapping texts.` app = `z2ui5_cl_demo_app_206` )
      ( group = `controls - sap.m` header = `sap.m.TextArea` sub = `Since 1.38 the growing property of sap.m.TextArea gives the ability of a control to automatically grow and shrink dynamically with its content.` app = `z2ui5_cl_demo_app_236` )
      ( group = `controls - sap.m` header = `sap.m.TextArea` sub = `This sample illustrates the different value states of the sap.m.TextArea control.` app = `z2ui5_cl_demo_app_234` )
      ( group = `controls - sap.m` header = `sap.m.TileContent` sub = `Shows the universal container for different content types and context information in the footer area.` app = `z2ui5_cl_demo_app_241` )
      ( group = `controls - sap.m` header = `sap.m.ToggleButton` sub = `Toggle Buttons can be toggled between pressed and normal state.` app = `z2ui5_cl_demo_app_266` )
      ( group = `controls - sap.m` header = `sap.m.Toolbar` sub = `Toolbar handles overflow by shrinking items. OverflowToolbar provides an overflow menu. Bar is able to perfectly center a text if nothing overflows.` app = `z2ui5_cl_demo_app_235` )
      ( group = `controls - sap.uxap` header = `sap.uxap.ObjectPageLayout`
        sub = `Object Page sample showing a layout with subsection titles on top. This is the default layout. The sample also shows the 'Edit header' button in the Header Content area.`
        app = `z2ui5_cl_demo_app_017` )
      ( group = `controls - sap.uxap` header = `sap.uxap.ObjectPageLayout` sub = `ObjectPage sample that demonstrates the combination of header facets and showTitle properties of sections and subsections.` app = `z2ui5_cl_demo_app_330` )
      ( group = `controls - sap.uxap` header = `sap.uxap.ObjectPageLayout` sub = `ObjectPage sample with Header Container` app = `z2ui5_cl_demo_app_303` )
      ( group = `controls - sap.f` header = `sap.f.Card` sub = `This sample illustrates how to specify the predefined header and the content of the Card control.` app = `z2ui5_cl_demo_app_181` )
      ( group = `controls - sap.f` header = `sap.f.DynamicPage`
        sub = `Dynamic Page freestyle example with a responsive sap.m.Table in the content area, showing that each control can be placed in the title and the header content areas.`
        app = `z2ui5_cl_demo_app_030` )
      ( group = `controls - sap.f` header = `sap.f.GridList` sub = `This sample represents GridList with enabled Drag and Drop functionality.` app = `z2ui5_cl_demo_app_307` )
      ( group = `controls - sap.ui.core` header = `sap.ui.core.HTML` sub = `With the HTML controls you can easily embed any kind of HTML content into your UI5 mobile application.` app = `z2ui5_cl_demo_app_242` )
      ( group = `controls - sap.ui.core` header = `sap.ui.core.InvisibleText`
        sub = `Many controls provide the associations ariaLabelledBy and ariaDescribedBy for accessibility purposes. The InvisibleText control can be used by application to provide hidden texts on the UI which can be referenced via these associations` &&
              `.`
        app = `z2ui5_cl_demo_app_282` )
      ( group = `controls - sap.ui.layout` header = `sap.ui.layout.ResponsiveSplitter`
        sub = `ResponsiveSplitter is used to visually divide the content of its parent. It consists of PaneContainers that further agregate other PaneContainers and SplitPanes. SplitPanes can be moved to the pagination when a minimum width of their p` &&
              `arent is reached.`
        app = `z2ui5_cl_demo_app_103` )
      ( group = `controls - sap.ui.layout` header = `sap.ui.layout.Splitter` sub = `Nested Splitter example with 7 content areas` app = `z2ui5_cl_demo_app_260` )
      ( group = `controls - sap.ui.layout` header = `sap.ui.layout.Splitter` sub = `Simple splitter example with three content areas` app = `z2ui5_cl_demo_app_249` )
      ( group = `controls - sap.ui.layout` header = `sap.ui.layout.Splitter` sub = `Simple splitter example with two content areas` app = `z2ui5_cl_demo_app_247` )
      ( group = `controls - sap.ui.layout` header = `sap.ui.layout.Splitter` sub = `Simple splitter example with two content areas that cannot be resized` app = `z2ui5_cl_demo_app_248` )
      ( group = `controls - sap.tnt` header = `sap.tnt.InfoLabel` sub = `InfoLabel with all available color schemes` app = `z2ui5_cl_demo_app_209` )
      ( group = `controls - sap.ui.codeeditor` header = `sap.ui.codeeditor.CodeEditor` sub = `` app = `z2ui5_cl_demo_app_265` )
      ( group = `controls - generated` header = `sap.f.GridList` sub = `` app = `z2ui5_cl_demo_app_416` )
      ( group = `controls - generated` header = `sap.f.GridList` sub = `This layout allows to display same height grid items with configurable width.` app = `z2ui5_cl_demo_app_417` )
      ( group = `controls - generated` header = `sap.f.GridList` sub = `This sample illustrates subgroups with headers, custom header and lazy loading of GridList items.` app = `z2ui5_cl_demo_app_418` )
      ( group = `controls - generated` header = `sap.f.ShellBar` sub = `Shell Bar example showing the control title as part of a mega menu, configurable by the app developer.` app = `z2ui5_cl_demo_app_419` )
      ( group = `controls - generated` header = `sap.m.Carousel` sub = `With the Carousel a user can browse through multi-page content by swiping left or right.` app = `z2ui5_cl_demo_app_420` )
      ( group = `controls - generated` header = `sap.m.CheckBox` sub = `In this sample, the CheckBox reflects the selection states of its dependent input fields - selected, not selected, and partially selected.` app = `z2ui5_cl_demo_app_421` )
      ( group = `controls - generated` header = `sap.m.ColorPalette` sub = `The standalone ColorPalette in a container (sap.ui.layout.SimpleForm).` app = `z2ui5_cl_demo_app_422` )
      ( group = `controls - generated` header = `sap.m.ComboBox` sub = `Items in the ComboBox could be grouped by a property` app = `z2ui5_cl_demo_app_428` )
      ( group = `controls - generated` header = `sap.m.ComboBox`
        sub = `The combo box control provides a list box with items and a text field allowing the user to either type a value directly into the control or choose from the list of existing items.`
        app = `z2ui5_cl_demo_app_423` )
      ( group = `controls - generated` header = `sap.m.ComboBox`
        sub = `The default filtering is 'starts with per term', which filters by the beginning of every word in every column. Autocomplete (type-ahead) works only for the first column, the leading value.`
        app = `z2ui5_cl_demo_app_425` )
      ( group = `controls - generated` header = `sap.m.ComboBox`
        sub = `Use the combo box dropdown list with two columns layout if you need to display additional information to your options, like e.g. currencies to countries or abbreviations to systems.`
        app = `z2ui5_cl_demo_app_424` )
      ( group = `controls - generated` header = `sap.m.CustomTreeItem` sub = `With the Custom Tree Item you can add any kind of content to Tree.` app = `z2ui5_cl_demo_app_429` )
      ( group = `controls - generated` header = `sap.m.DisplayListItem` sub = `Use the Display List Item for showing name/value pairs.` app = `z2ui5_cl_demo_app_430` )
      ( group = `controls - generated` header = `sap.m.FacetFilter`
        sub = `This is a 'Light' version of the Facet Filter. It is for small displays where only a selectable summary bar is shown, and a dialog is shown for setting the facet values.`
        app = `z2ui5_cl_demo_app_401` )
      ( group = `controls - generated` header = `sap.m.FlexBox` sub = `Automatic size adjustments can be achieved for Flex Items with the use of Flex Item Data settings on the contained controls.` app = `z2ui5_cl_demo_app_405` )
      ( group = `controls - generated` header = `sap.m.FlexBox` sub = `Flex Boxes can be nested. Remember also that HBox and VBox are 'convenience' controls based on the Flex Box control.` app = `z2ui5_cl_demo_app_404` )
      ( group = `controls - generated` header = `sap.m.FlexBox` sub = `Here is an example of how you can use navigation items as unordered list items in a Flex Box.` app = `z2ui5_cl_demo_app_403` )
      ( group = `controls - generated` header = `sap.m.FlexBox` sub = `You can create balanced areas with Flex Box, such as these columns with equal height regardless of content.` app = `z2ui5_cl_demo_app_402` )
      ( group = `controls - generated` header = `sap.m.GenericTag` sub = `This example demonstrates ObjectPage with ObjectPageHeaderActionButtons and a GenericTag in the header.` app = `z2ui5_cl_demo_app_411` )
      ( group = `controls - generated` header = `sap.m.GenericTile` sub = `Shows KPI Tile samples that can contain header, subheader, key value, trend, scale, unit, and a footer.` app = `z2ui5_cl_demo_app_431` )
      ( group = `controls - generated` header = `sap.m.IconTabBar`
        sub = `In this example when there is not enough space for all tab items to fit on the screen, the rest are displayed in an overflow select list for easier selection.`
        app = `z2ui5_cl_demo_app_432` )
      ( group = `controls - generated` header = `sap.m.IconTabBar`
        sub = `In this example, the IconTabBar height is stretched to the maximum height of the page content. Note: The height of the parent container must be defined as a fixed value. Also, applyContentPadding property is set to false and background` &&
              `Design property is set to Transparent.`
        app = `z2ui5_cl_demo_app_433` )
      ( group = `controls - generated` header = `sap.m.Image` sub = `Visualizes the state of the control when the mode property is set to ImageMode.Background.` app = `z2ui5_cl_demo_app_434` )
      ( group = `controls - generated` header = `sap.m.Input` sub = `In this example assisted input is provided with table-like suggestions where several columns can display more details.` app = `z2ui5_cl_demo_app_435` )
      ( group = `controls - generated` header = `sap.m.Input` sub = `Items in the Input could be grouped by a property` app = `z2ui5_cl_demo_app_437` )
      ( group = `controls - generated` header = `sap.m.Input`
        sub = `The default filtering for the suggestionItems aggregation uses a 'begins with' style operator. You can override this with your own custom filter function using the Input control's setFilterFunction method.`
        app = `z2ui5_cl_demo_app_438` )
      ( group = `controls - generated` header = `sap.m.Input` sub = `This example shows different input value states.` app = `z2ui5_cl_demo_app_439` )
      ( group = `controls - generated` header = `sap.m.Input` sub = `This example shows how to easily implement an assisted input with two-value suggestions.` app = `z2ui5_cl_demo_app_436` )
      ( group = `controls - generated` header = `sap.m.Link` sub = `Usually you use an Object Identifier in the first column of a table. But if you need an active identifier you should use an 'emphasized' link instead.` app = `z2ui5_cl_demo_app_440` )
      ( group = `controls - generated` header = `sap.m.List`
        sub = `'Single selection' forces the user to choose exactly one out of many items. With the 'multi' selection the user can pick multiple items at the same time. This is helpful for e.g. batch processing. With 'includeItem' the selection is al` &&
              `so changed when pressing the item.`
        app = `z2ui5_cl_demo_app_446` )
      ( group = `controls - generated` header = `sap.m.List`
        sub = `If only a subset of the list items are navigable you should indicate those by setting their 'type' to 'Navigation'. This displays an navigation arrow. Do not show arrows if all items are navigable. This achieved by setting the 'type' t` &&
              `o 'Active'.`
        app = `z2ui5_cl_demo_app_444` )
      ( group = `controls - generated` header = `sap.m.List` sub = `If the list is empty it indicates this state by displaying a message text.` app = `z2ui5_cl_demo_app_445` )
      ( group = `controls - generated` header = `sap.m.List` sub = `The counter of an item quickly shows how many detail entries are related, without having to navigate to the detail page.` app = `z2ui5_cl_demo_app_441` )
      ( group = `controls - generated` header = `sap.m.List`
        sub = `The Growing feature helps if your content is too big to be loaded/shown at once. It paginates the content into smaller chunks - aka pages - which are loaded/shown one after another. Random access to pages (e.g jumping to the end) is no` &&
              `t possible. Depending on the model the content is loaded on demand (OData) or shown on demand (JSON).`
        app = `z2ui5_cl_demo_app_443` )
      ( group = `controls - generated` header = `sap.m.List` sub = `With the 'footerText' property you can set a message that is shown at the very end of the list.` app = `z2ui5_cl_demo_app_442` )
      ( group = `controls - generated` header = `sap.m.MessageBox` sub = `Shows how to set initial focus to MessageBox button.` app = `z2ui5_cl_demo_app_447` )
      ( group = `controls - generated` header = `sap.m.MessageToast`
        sub = `The Message Toast displays the message text as an overlay to the current screen. It closes automatically after some time without requiring further user interaction.`
        app = `z2ui5_cl_demo_app_448` )
      ( group = `controls - generated` header = `sap.m.MessageView` sub = `A sample showing how you can connect the MessageView with MessageManager.` app = `z2ui5_cl_demo_app_449` )
      ( group = `controls - generated` header = `sap.m.MultiComboBox` sub = `Items in the MultiComboBox could be grouped by a property` app = `z2ui5_cl_demo_app_452` )
      ( group = `controls - generated` header = `sap.m.MultiComboBox` sub = `The default filtering is 'starts with per term', which filters by the beginning of every word in every column.` app = `z2ui5_cl_demo_app_451` )
      ( group = `controls - generated` header = `sap.m.MultiComboBox`
        sub = `Use the dropdown list with two columns layout if you need to display additional information to your options, like e.g. currencies to countries or abbreviations to systems.`
        app = `z2ui5_cl_demo_app_453` )
      ( group = `controls - generated` header = `sap.m.MultiInput` sub = `Items in the MultiInput could be grouped by a property` app = `z2ui5_cl_demo_app_457` )
      ( group = `controls - generated` header = `sap.m.MultiInput` sub = `MultiInput data binding allows data to be bound to tokens in MultiInput.` app = `z2ui5_cl_demo_app_456` )
      ( group = `controls - generated` header = `sap.m.MultiInput` sub = `MultiInput provides functionality to add / remove / enter tokens.` app = `z2ui5_cl_demo_app_454` )
      ( group = `controls - generated` header = `sap.m.MultiInput` sub = `Number of Tokens in MultiInput cannot exceed the maxToken number.` app = `z2ui5_cl_demo_app_458` )
      ( group = `controls - generated` header = `sap.m.ObjectAttribute`
        sub = `This is a responsive Object Header with a Title, 2 Statuses/Attributes rendered next to the title in a fullScreenOptimized mode (fullScreenOptimized = true).`
        app = `z2ui5_cl_demo_app_459` )
      ( group = `controls - generated` header = `sap.m.ObjectHeader`
        sub = `An Object Header will also make space for an image if one is specified, via a URL for the 'icon' property. Note: This example shows the image inside ObjectHeader with the responsive property set to false. On phone in portrait mode, the` &&
              ` image remains visible.`
        app = `z2ui5_cl_demo_app_462` )
      ( group = `controls - generated` header = `sap.m.ObjectHeader` sub = `The Object Header is shown in condensed mode with title, number, number unit and one attribute.` app = `z2ui5_cl_demo_app_461` )
      ( group = `controls - generated` header = `sap.m.ObjectHeader`
        sub = `This is a Object Header which displays the basic information about objects similar to the Object List Item. Besides a title and number you can show multiple attributes (on the left) and statuses (on the right).`
        app = `z2ui5_cl_demo_app_460` )
      ( group = `controls - generated` header = `sap.m.ObjectHeader`
        sub = `This is a responsive Object Header with a Title, 2 Statuses/Attributes rendered below the title in a Master/Detail mode (fullScreenOptimized = false).`
        app = `z2ui5_cl_demo_app_464` )
      ( group = `controls - generated` header = `sap.m.ObjectHeader` sub = `This is a responsive Object Header without a number and with a Title, 3 Statuses/Attributes.` app = `z2ui5_cl_demo_app_465` )
      ( group = `controls - generated` header = `sap.m.ObjectHeader` sub = `This sample shows the different states of an Object Header, which can be set using the markers.` app = `z2ui5_cl_demo_app_463` )
      ( group = `controls - generated` header = `sap.m.ObjectIdentifier`
        sub = `The object identifier is a small building block representing an object by a title and short description. Often it is used in the first column of a table.`
        app = `z2ui5_cl_demo_app_466` )
      ( group = `controls - generated` header = `sap.m.ObjectNumber`
        sub = `The object number is a small building block representing an important, numerical attribute of an object together with it's unit. Often it is used in the last column of a table.`
        app = `z2ui5_cl_demo_app_467` )
      ( group = `controls - generated` header = `sap.m.OverflowToolbar` sub = `The Enabled property can be used to enable or disable all the controls inside the OverflowToolbar/Toolbar.` app = `z2ui5_cl_demo_app_468` )
      ( group = `controls - generated` header = `sap.m.Page`
        sub = `This page implements the same sample as in 'Fiori Sample Page - sapUiFioriObjectPage' using standard margin classes. In contrast to using 'sapUiFioriObjectPage', the margins used for form, list, table and panel are responsive: they ada` &&
              `pt to the available screen width. For more information, please search for 'Standard Margins' and take a look at our samples.`
        app = `z2ui5_cl_demo_app_470` )
      ( group = `controls - generated` header = `sap.m.Page`
        sub = `This page shows flexible sizing with a Toolbar. The upper part extends with its content, but doesn't react to viewport changes. The lower part reacts to the viewport size. The table inside takes the available space. If the minimum size` &&
              ` of the table is reached, the page begins to scroll.`
        app = `z2ui5_cl_demo_app_407` )
      ( group = `controls - generated` header = `sap.m.Page`
        sub = `This page shows flexible sizing with an Icon Tab Bar: The upper part extends with its content, but doesn't react to viewport changes. The Icon Tab Bar reacts to the viewport size. The table inside takes the available space. If the mini` &&
              `mum size of the table is reached, the page begins to scroll.`
        app = `z2ui5_cl_demo_app_406` )
      ( group = `controls - generated` header = `sap.m.Panel` sub = `Panels also have the possibility to expand/collapse their content (including the infoToolbar if available). [since rel. 1.22]` app = `z2ui5_cl_demo_app_471` )
      ( group = `controls - generated` header = `sap.m.PDFViewer` sub = `A PDF viewer opening as a popup dialog.` app = `z2ui5_cl_demo_app_469` )
      ( group = `controls - generated` header = `sap.m.RangeSlider` sub = `With the RangeSlider a user can specify range from a numerical interval.` app = `z2ui5_cl_demo_app_472` )
      ( group = `controls - generated` header = `sap.m.ScrollContainer`
        sub = `The Scroll Container is a control that can display arbitrary content within a limited screen area and provides touch scrolling to make all content accessible.`
        app = `z2ui5_cl_demo_app_473` )
      ( group = `controls - generated` header = `sap.m.SegmentedButton`
        sub = `The Segmented Button allows the user to pick one out of many options for displaying the content of the current page. It is a UI pattern from iOS, now also available for other platforms. Putting the Segmented Button to a Bar control on ` &&
              `non-iOS platforms will result in something very close to a tab.`
        app = `z2ui5_cl_demo_app_474` )
      ( group = `controls - generated` header = `sap.m.SelectList` sub = `A SelectList allows the user to select one item from a list of choices.` app = `z2ui5_cl_demo_app_475` )
      ( group = `controls - generated` header = `sap.m.SelectList` sub = `A SelectList with icons.` app = `z2ui5_cl_demo_app_476` )
      ( group = `controls - generated` header = `sap.m.StandardListItem`
        sub = `By default the title size adapts to the available space and gets bigger if the description is empty. List items with and without descriptions results in titles with different sizes. In this cases it is better to switch the size adaptio` &&
              `n off.`
        app = `z2ui5_cl_demo_app_480` )
      ( group = `controls - generated` header = `sap.m.StandardListItem` sub = `This list item offers a standardized user interface for list content with only title.` app = `z2ui5_cl_demo_app_477` )
      ( group = `controls - generated` header = `sap.m.StandardListItem` sub = `This list item offers a standardized user interface for list content with title and description.` app = `z2ui5_cl_demo_app_478` )
      ( group = `controls - generated` header = `sap.m.StandardListItem` sub = `This list item offers a standardized user interface for list content with title, description and icon.` app = `z2ui5_cl_demo_app_479` )
      ( group = `controls - generated` header = `sap.m.StepInput`
        sub = `The StepInput allows the user to change stepwise a value by a predefined step and also to set additional description, such as units of measurement and currencies after the input field.`
        app = `z2ui5_cl_demo_app_481` )
      ( group = `controls - generated` header = `sap.m.Table` sub = `Table with alternating light and dark background colors. Note: The effect of this feature is only visible in some themes (e.g. SAP Belize or SAP Quartz).` app = `z2ui5_cl_demo_app_482` )
      ( group = `controls - generated` header = `sap.m.Table` sub = `This example shows the container-based pop-in behavior. The container has static width.` app = `z2ui5_cl_demo_app_483` )
      ( group = `controls - generated` header = `sap.m.Text` sub = `The text control can be used for embedding longer paragraphs of text into your application, that need text wrapping.` app = `z2ui5_cl_demo_app_408` )
      ( group = `controls - generated` header = `sap.m.TextArea`
        sub = `Since 1.30 the value property of sap.m.TextArea is not updated on every keystroke, but first when the user presses Enter or leaves the input. The change was necessary to fully support the standard UI5 data binding with formatters and t` &&
              `ypes. If you still need immediate update you have 2 options: Handle liveChange events or enable the boolean property valueLiveUpdate.`
        app = `z2ui5_cl_demo_app_484` )
      ( group = `controls - generated` header = `sap.m.TextArea`
        sub = `The Text Area allows to enter multi-line text and automatically breaks to a new line for overflow text. If the text gets too big to be displayed at once the user can scroll up and down.`
        app = `z2ui5_cl_demo_app_409` )
      ( group = `controls - generated` header = `sap.m.Title`
        sub = `The Title control is a simple one line text with additional semantic information about the level of the following section in the page structure for accessibility purposes.`
        app = `z2ui5_cl_demo_app_485` )
      ( group = `controls - generated` header = `sap.m.Toolbar`
        sub = `Toolbar items can shrink/expand when the toolbar is resized. This behavior is enabled/disabled via the ToolbarLayoutData layout. It is also possible to set min/max width for shrinkable items.`
        app = `z2ui5_cl_demo_app_486` )
      ( group = `controls - generated` header = `sap.m.Tree` sub = `Tree displays data in hierarchical structure.` app = `z2ui5_cl_demo_app_487` )
      ( group = `controls - generated` header = `sap.tnt.NavigationList` sub = `Navigation List in a Page` app = `z2ui5_cl_demo_app_498` )
      ( group = `controls - generated` header = `sap.tnt.SideNavigation` sub = `SideNavigation in container with fixed width.` app = `z2ui5_cl_demo_app_499` )
      ( group = `controls - generated` header = `sap.tnt.ToolHeader` sub = `ToolHeader can contain IconTabHeader. When both controls are combined, the IconTabHeader supports only inline text. No icons can be used.` app = `z2ui5_cl_demo_app_500` )
      ( group = `controls - generated` header = `sap.ui.core.ContainerPadding`
        sub = `Apply the CSS class 'sapUiResponsiveContentPadding' on a UI5 container control to add a responsive padding based on the screen size around the container content area.`
        app = `z2ui5_cl_demo_app_490` )
      ( group = `controls - generated` header = `sap.ui.core.ContainerPadding`
        sub = `By combining the margin and padding concepts you can flexibly design your application layout without having to write any custom CSS. This example shows a HorizontalLayout that is layouted with the standard margin and padding classes pr` &&
              `ovided by UI5.`
        app = `z2ui5_cl_demo_app_489` )
      ( group = `controls - generated` header = `sap.ui.core.ContainerPadding`
        sub = `Many UI5 containers support the standard container content padding CSS classes. Apply the CSS class 'sapUiNoContentPadding' on a UI5 container control to remove the default padding around the container content area.`
        app = `z2ui5_cl_demo_app_488` )
      ( group = `controls - generated` header = `sap.ui.core.Icon` sub = `Built with an embedded font, icons scale well, and can be altered with CSS. They can also fire a press event. See the Icon Explorer for more icons.` app = `z2ui5_cl_demo_app_501` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins` sub = `Clear the space around your control, where the margin depends on the device your are using.` app = `z2ui5_cl_demo_app_494` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins`
        sub = `Clear the space to the left and right, top and bottom of your control. Choose a size ('Tiny', 'Small', 'Medium' or 'Large', which stands for 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px (3rem) respectively) and an orientation ('Begin` &&
              `End', 'TopBottom'). If you would like to clear a 32px space to the left and right, you would add class 'sapUiMediumMarginBeginEnd'.`
        app = `z2ui5_cl_demo_app_496` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins`
        sub = `Clear the space to the left, right, top or bottom of your control. Choose a size ('Tiny', 'Small', 'Medium' or 'Large', which stands for 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px (3rem) respectively) and a direction ('Begin', 'End` &&
              `', 'Top' or 'Bottom', where 'Begin' is left and 'End' is right and vice versa in right-to-left mode). If you would like to clear a 32px space to the left (resp. right in rtl mode), you would add class 'sapUiMediumMarginBegin'. You may ` &&
              `also add several classes which have to point to different directions though, for example you would add classes 'sapUiLargeMarginEnd sapUiLargeMarginBottom' to clear a 48px space to the bottom and to the right (resp. to the left in rtl ` &&
              `mode).`
        app = `z2ui5_cl_demo_app_495` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins` sub = `See how adjacent margins collapse to a single margin.` app = `z2ui5_cl_demo_app_492` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins`
        sub = `Some controls (for example the IconTabBar) do not have a 'width' property but still have a default width of 100%. We provide css class 'sapUiForceWidthAuto' to overwrite the control's width in such a case.`
        app = `z2ui5_cl_demo_app_493` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins`
        sub = `Use our standard 'No-Margins' classes to remove existing margins from your control. You can either remove all margins at once or remove the margin on one or more sides.`
        app = `z2ui5_cl_demo_app_497` )
      ( group = `controls - generated` header = `sap.ui.core.StandardMargins`
        sub = `Use standard margin classes 'sapUiTinyMargin', 'sapUiSmallMargin', 'sapUiMediumMargin' or 'sapUiLargeMargin' to add a 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px (3rem) margin to your control. This will clear the area all around you` &&
              `r control (outside its border).`
        app = `z2ui5_cl_demo_app_491` )
      ( group = `controls - generated` header = `sap.ui.core.theming` sub = `Sample provides a link to the Theme Parameter Toolbox. There you can easily search, preview, and filter semantic theme parameters.` app = `z2ui5_cl_demo_app_502` )
      ( group = `controls - generated` header = `sap.ui.integration.widgets.Card` sub = `Card Explorer is the application where you can learn more about integration cards.` app = `z2ui5_cl_demo_app_510` )
      ( group = `controls - generated` header = `sap.ui.layout.BlockLayout` sub = `Block Layout in which all cells use the same background color set and different color shade.` app = `z2ui5_cl_demo_app_511` )
      ( group = `controls - generated` header = `sap.ui.layout.BlockLayout` sub = `The BlockLayout Cells can have links as titles. The link text overwrites the title text.` app = `z2ui5_cl_demo_app_513` )
      ( group = `controls - generated` header = `sap.ui.layout.BlockLayout`
        sub = `The BlockLayout is intended to be used with rows and cells. The cells have predefined width, the rows have predefined rendering modes - scrollable/vertical/horizontal.`
        app = `z2ui5_cl_demo_app_512` )
      ( group = `controls - generated` header = `sap.ui.layout.cssgrid.CSSGrid` sub = `CSSGrid example for page layout.` app = `z2ui5_cl_demo_app_521` )
      ( group = `controls - generated` header = `sap.ui.layout.cssgrid.CSSGrid` sub = `CSSGrid example nested grids.` app = `z2ui5_cl_demo_app_522` )
      ( group = `controls - generated` header = `sap.ui.layout.FixFlex` sub = `Shows a FixFlex control where fixContentSize is set to a specific value(200px) and sap.m.scrollContainer is enabling vertical scrolling.` app = `z2ui5_cl_demo_app_410` )
      ( group = `controls - generated` header = `sap.ui.layout.FixFlex` sub = `Shows a FixFlex control where the minFlexSize is set to 400px.` app = `z2ui5_cl_demo_app_515` )
      ( group = `controls - generated` header = `sap.ui.layout.FixFlex` sub = `Shows a FixFlex control with a horizontal layout.` app = `z2ui5_cl_demo_app_514` )
      ( group = `controls - generated` header = `sap.ui.layout.FixFlex` sub = `Shows a FixFlex control with a vertical layout.` app = `z2ui5_cl_demo_app_516` )
      ( group = `controls - generated` header = `sap.ui.layout.form.Form` sub = `A form that uses Toolbars as Form header and FormContainer headers.` app = `z2ui5_cl_demo_app_523` )
      ( group = `controls - generated` header = `sap.ui.layout.form.SimpleForm` sub = `A SimpleForm that uses Toolbars as Form header and FormContainer headers.` app = `z2ui5_cl_demo_app_524` )
      ( group = `controls - generated` header = `sap.ui.layout.Grid`
        sub = `The major layout features of the Grid control are shown in this example. Features like indentation, making content visible/invisible based on the screen size, moving content forward and backwards are demonstrated.`
        app = `z2ui5_cl_demo_app_518` )
      ( group = `controls - generated` header = `sap.ui.layout.Grid`
        sub = `You can use the Grid control to make responsive table-free layouts; here we are using a default indent and span, and specifying the Small settings such that the image and text will stack on a small display.`
        app = `z2ui5_cl_demo_app_517` )
      ( group = `controls - generated` header = `sap.ui.layout.HorizontalLayout`
        sub = `The Horizontal Layout control is a simple way to align multiple controls horizontally. By default the contained controls are not wrapped. If you want more sophisticated layout options, consider Grid or Flex Box based layouts.`
        app = `z2ui5_cl_demo_app_519` )
      ( group = `controls - generated` header = `sap.ui.layout.VerticalLayout`
        sub = `The Vertical Layout control is a simple way to align multiple controls vertically. If you want more sophisticated layout options, consider Grid or Flex Box based layouts.`
        app = `z2ui5_cl_demo_app_520` )
      ( group = `controls - generated` header = `sap.ui.model.type.Currency`
        sub = `Formats the number by using the parameters defined for the given currency code. Either currency symbol, currency code or none of them can be included in the final formatted string. It parses the given string into an array which contain` &&
              `s both the currency number and currency code.`
        app = `z2ui5_cl_demo_app_503` )
      ( group = `controls - generated` header = `sap.ui.model.type.Date` sub = `This sample explains the formatting options of the Date type with the date being available as date object.` app = `z2ui5_cl_demo_app_504` )
      ( group = `controls - generated` header = `sap.ui.model.type.Date` sub = `This sample explains the formatting options of the Date type with the date being available as string.` app = `z2ui5_cl_demo_app_505` )
      ( group = `controls - generated` header = `sap.ui.model.type.FileSize` sub = `This sample explains the formatting options of the FileSize type.` app = `z2ui5_cl_demo_app_506` )
      ( group = `controls - generated` header = `sap.ui.model.type.Float` sub = `Formats and parses both integer and decimal digits.` app = `z2ui5_cl_demo_app_507` )
      ( group = `controls - generated` header = `sap.ui.model.type.Integer` sub = `Formats and parses only the integer digits. The decimal digits are ignored.` app = `z2ui5_cl_demo_app_508` )
      ( group = `controls - generated` header = `sap.ui.model.type.Time` sub = `This sample explains the formatting options of the Time type.` app = `z2ui5_cl_demo_app_509` )
      ( group = `controls - generated` header = `sap.ui.table.Table` sub = `Example for multi-header of table` app = `z2ui5_cl_demo_app_525` )
      ( group = `controls - generated` header = `sap.ui.unified.Currency` sub = `Display Currencies in Table` app = `z2ui5_cl_demo_app_527` )
      ( group = `controls - generated` header = `sap.ui.unified.Currency` sub = `Display Currencies with proper Alignment` app = `z2ui5_cl_demo_app_526` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageHeader` sub = `This is an example of an ObjectPageHeader containing mainly KPIs.` app = `z2ui5_cl_demo_app_529` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageHeader` sub = `This is an example of ObjectPageHeader using the showPlaceholder property.` app = `z2ui5_cl_demo_app_530` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageHeaderContent` sub = `The sample shows how to set priorities of the ObjectPageHeader content items by using the ObjectPageHeaderContentLayoutData element` app = `z2ui5_cl_demo_app_412` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageHeaderContent` sub = `This is an example of an ObjectPageHeaderContent.` app = `z2ui5_cl_demo_app_531` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout`
        sub = `Object Page sample showing a layout where the navigation is Tab based (one Tab per section) rather than having all of the sections visible at the same time.`
        app = `z2ui5_cl_demo_app_537` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout` sub = `Object Page sample showing a layout where the selected section is defined by the user.` app = `z2ui5_cl_demo_app_536` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout` sub = `Object Page with LazyLoading` app = `z2ui5_cl_demo_app_535` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout`
        sub = `This example shows how to change the default behavior in order to be able to navigate to sections instead of subsections, using the Anchor Bar`
        app = `z2ui5_cl_demo_app_413` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout` sub = `This example shows how to visualize numbers in parenthesis after the corresponding section titles in the AnchorBar` app = `z2ui5_cl_demo_app_532` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout`
        sub = `This is an example of an ObjectPage with property alwaysShowContentHeader set to true. In this case the HeaderContent won't snap on a desktop.`
        app = `z2ui5_cl_demo_app_533` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageLayout`
        sub = `This sample showcases the lazy loading using the stashed property of the ObjectPageLazyLoader. It enables usage of lazy loading without the need to have Blocks`
        app = `z2ui5_cl_demo_app_534` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageSection` sub = `This example explains the rules for the rendering of sections` app = `z2ui5_cl_demo_app_414` )
      ( group = `controls - generated` header = `sap.uxap.ObjectPageSubSection` sub = `Example of a subsection displaying action buttons.` app = `z2ui5_cl_demo_app_415` ) ).

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
