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
      ( group = `controls - sap.ui.codeeditor` header = `sap.ui.codeeditor.CodeEditor` sub = `` app = `z2ui5_cl_demo_app_265` ) ).

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
