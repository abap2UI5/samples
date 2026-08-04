CLASS z2ui5_cl_sample_app_g01 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_sample_app_g01 IMPLEMENTATION.

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
        title          = `abap2UI5 - Samples (restricted)`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(url_standard) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_demo_app_g00|.
    page->header_content( )->button(
        text  = `Basic Samples`
        icon  = `sap-icon://action`
        press = client->_event_client( val   = client->cs_event-open_new_tab
                                       t_arg = VALUE #( ( url_standard ) ) ) ).

    DATA(info) = |The basic samples are written for maximum compatibility - | &&
                 |plain OpenUI5, every UI5 release since 1.71 and both ABAP Cloud and 7.02. | &&
                 |The extended samples here can need a specific system, so check per sample | &&
                 |which ABAP stack (ABAP Cloud / on-premise), UI5 release and other prerequisites it requires.|.

    IF class_exists( `Z2UI5_CL_DEMO_APP_000` ) = abap_true.
      DATA(url) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_demo_app_000|.
      info = |{ info } Click <a href="{ url }" target="_blank">here</a> for the classic overview.|.
    ENDIF.

    page->message_strip(
        type                = `Information`
        showicon            = abap_true
        enableformattedtext = abap_true
        class               = `sapUiSmallMarginBottom`
        text                = info ).

    DATA(prev_group) = ``.

    LOOP AT t_catalog INTO DATA(tile).

      DATA(base) = block_base( group  = tile-group
                               header = tile-header ).

      IF tile-group <> prev_group.
        page->title(
            text  = tile-group
            level = `H3`
            class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
        prev_group = tile-group.
      ENDIF.

      " widest header of the block plus roughly one space, in 1/100 em
      DATA(tenths) = ( t_blocks[ group = tile-group base = base ]-width + 45 ) DIV 10.
      DATA(width) = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      " extended overview: every sample directly under the previous one, no
      " blank line between blocks
      DATA(row) = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = `sapUiTinyMarginBegin` ).

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
      ( group = `restricted - release - version` header = `Launchpad` sub = `cross app navigation I` app = `z2ui5_cl_demo_app_lp_03` )
      ( group = `restricted - release - version` header = `Launchpad` sub = `cross app navigation II` app = `z2ui5_cl_demo_app_lp_04` )
      ( group = `restricted - release - version` header = `Launchpad` sub = `Set Title` app = `z2ui5_cl_demo_app_lp_02` )
      ( group = `restricted - release - version` header = `Launchpad` sub = `Startup Parameters` app = `z2ui5_cl_demo_app_lp_01` )
      ( group = `restricted - release - version` header = `more` sub = `map container` app = `z2ui5_cl_demo_app_123` )
      ( group = `restricted - release - version` header = `more` sub = `ndc scanner (since 1.102)` app = `z2ui5_cl_demo_app_124` )
      ( group = `restricted - release - version` header = `more` sub = `networkgraph org tree` app = `z2ui5_cl_demo_app_182` )
      ( group = `restricted - release - version` header = `more` sub = `status indicator` app = `z2ui5_cl_demo_app_196` )
      ( group = `restricted - release - version` header = `more` sub = `timeline` app = `z2ui5_cl_demo_app_113` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `Page Variant Management` app = `z2ui5_cl_demo_app_478` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `Smart Multi Input` app = `z2ui5_cl_demo_app_319` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `Smart Table and Variants` app = `z2ui5_cl_demo_app_313` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `SmartChart with NavPopover` app = `z2ui5_cl_demo_app_479` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `SmartField in a SmartForm` app = `z2ui5_cl_demo_app_475` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `SmartFilterBar and SmartTable` app = `z2ui5_cl_demo_app_477` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `SmartForm, editable toggle` app = `z2ui5_cl_demo_app_476` )
      ( group = `restricted - release - version` header = `Smart Controls` sub = `Switch Default Model` app = `z2ui5_cl_demo_app_314` )
      ( group = `restricted - release - version` header = `visualization` sub = `bar chart` app = `z2ui5_cl_demo_app_016` )
      ( group = `restricted - release - version` header = `visualization` sub = `donut chart` app = `z2ui5_cl_demo_app_013` )
      ( group = `restricted - release - version` header = `visualization` sub = `Harvey Chart` app = `z2ui5_cl_demo_app_308` )
      ( group = `restricted - release - version` header = `visualization` sub = `line chart` app = `z2ui5_cl_demo_app_014` )
      ( group = `restricted - release - version` header = `visualization` sub = `process flow` app = `z2ui5_cl_demo_app_091` )
      ( group = `restricted - release - version` header = `visualization` sub = `radial chart` app = `z2ui5_cl_demo_app_029` )
      ( group = `restricted - release - version` header = `visualization` sub = `VizFrame Charts` app = `z2ui5_cl_demo_app_312` )
      ( group = `restricted - abap standard` header = `Conversion Exits` sub = `` app = `z2ui5_cl_demo_app_s_04` )
      ( group = `restricted - abap standard` header = `Generated APC WebSocket protocol impementation class` sub = `` app = `z2ui5_cl_demo_app_s_05_ws` )
      ( group = `restricted - abap standard` header = `News Feed over Websocket` sub = `` app = `z2ui5_cl_demo_app_s_05` )
      ( group = `restricted - abap standard` header = `Play Sound` sub = `` app = `z2ui5_cl_demo_app_s_03` )
      ( group = `restricted - abap standard` header = `Stateful Sessions` sub = `` app = `z2ui5_cl_demo_app_s_02` )
      ( group = `restricted - abap standard` header = `Sticky Session with Locks` sub = `` app = `z2ui5_cl_demo_app_s_01` )
      ( group = `restricted - testing` header = `App Calling App with REF` sub = `` app = `z2ui5_cl_demo_app_192` )
      ( group = `restricted - testing` header = `App in App` sub = `Main App` app = `z2ui5_cl_demo_app_338` )
      ( group = `restricted - testing` header = `App in App` sub = `Popup` app = `z2ui5_cl_demo_app_340` )
      ( group = `restricted - testing` header = `App in App` sub = `Subapp` app = `z2ui5_cl_demo_app_339` )
      ( group = `restricted - testing` header = `App in App` sub = `Subapp` app = `z2ui5_cl_demo_app_342` )
      ( group = `restricted - testing` header = `App in App I` sub = `` app = `z2ui5_cl_demo_app_211` )
      ( group = `restricted - testing` header = `App in App II` sub = `` app = `z2ui5_cl_demo_app_212` )
      ( group = `restricted - testing` header = `basic` sub = `popups with ref from prev App` app = `z2ui5_cl_demo_app_328` )
      ( group = `restricted - testing` header = `binding` sub = `` app = `z2ui5_cl_demo_app_153` )
      ( group = `restricted - testing` header = `binding` sub = `normal, deep, refs` app = `z2ui5_cl_demo_app_094` )
      ( group = `restricted - testing` header = `Catch exceptions and display popup` sub = `` app = `z2ui5_cl_demo_app_324` )
      ( group = `restricted - testing` header = `Check throw error when ref used for binding` sub = `` app = `z2ui5_cl_demo_app_343` )
      ( group = `restricted - testing` header = `data binding tables with invalid date and time` sub = `` app = `z2ui5_cl_demo_app_118` )
      ( group = `restricted - testing` header = `data container` sub = `` app = `z2ui5_cl_demo_app_193` )
      ( group = `restricted - testing` header = `Deep Structure` sub = `` app = `z2ui5_cl_demo_app_190` )
      ( group = `restricted - testing` header = `Deep Structure Main App` sub = `` app = `z2ui5_cl_demo_app_195` )
      ( group = `restricted - testing` header = `Deep Structure Sub App` sub = `` app = `z2ui5_cl_demo_app_191` )
      ( group = `restricted - testing` header = `Deep Structure Sub App` sub = `` app = `z2ui5_cl_demo_app_194` )
      ( group = `restricted - testing` header = `Multiple Timers` sub = `` app = `z2ui5_cl_demo_app_353` )
      ( group = `restricted - testing` header = `Nested Apps I` sub = `Calling another app for rendering` app = `z2ui5_cl_demo_app_117` )
      ( group = `restricted - testing` header = `Nested Apps II` sub = `Use RTTI to render different Subapps` app = `z2ui5_cl_demo_app_131` )
      ( group = `restricted - testing` header = `Nested Apps III` sub = `User Generic Data Refs in Subapps` app = `z2ui5_cl_demo_app_185` )
      ( group = `restricted - testing` header = `RTTI` sub = `Struc` app = `z2ui5_cl_demo_app_331` )
      ( group = `restricted - testing` header = `RTTI` sub = `Struc with Cell Binding` app = `z2ui5_cl_demo_app_332` )
      ( group = `restricted - testing` header = `RTTI` sub = `Struc with Class Data` app = `z2ui5_cl_demo_app_334` )
      ( group = `restricted - testing` header = `RTTI` sub = `Struc with Class Data and Popup` app = `z2ui5_cl_demo_app_335` )
      ( group = `restricted - testing` header = `RTTI` sub = `Struc with Ref in Object` app = `z2ui5_cl_demo_app_348` )
      ( group = `restricted - testing` header = `RTTI` sub = `Table with Class Data and Popup` app = `z2ui5_cl_demo_app_337` )
      ( group = `restricted - testing` header = `RTTI` sub = `Table with Class Data and Popup` app = `z2ui5_cl_demo_app_349` )
      ( group = `restricted - testing` header = `RTTI` sub = `Table with Ref in Object` app = `z2ui5_cl_demo_app_347` )
      ( group = `restricted - testing` header = `RTTI` sub = `with many Layouts` app = `z2ui5_cl_demo_app_344` )
      ( group = `restricted - testing` header = `RTTI` sub = `with many Layouts` app = `z2ui5_cl_demo_app_345` )
      ( group = `restricted - testing` header = `Sample App` sub = `Full View` app = `z2ui5_cl_demo_app_085` )
      ( group = `restricted - testing` header = `Sample App` sub = `Selection Screen` app = `z2ui5_cl_demo_app_002` )
      ( group = `restricted - testing` header = `Type Ref to Data Table with refresh` sub = `` app = `z2ui5_cl_demo_app_199` )
      ( group = `restricted - testing` header = `unit test` sub = `long variable` app = `z2ui5_cl_demo_app_138` )
      ( group = `restricted - testing` header = `ZZZ Data Object for Sample 328` sub = `` app = `z2ui5_cl_demo_app_329` )
      ( group = `restricted - experimental` header = `custom function in popup` sub = `` app = `z2ui5_cl_demo_app_141` )
      ( group = `restricted - experimental` header = `extension` sub = `ext library` app = `z2ui5_cl_demo_app_040` )
      ( group = `restricted - experimental` header = `gantt` sub = `test` app = `z2ui5_cl_demo_app_076` )
      ( group = `restricted - experimental` header = `gantt II` sub = `` app = `z2ui5_cl_demo_app_179` )
      ( group = `restricted - experimental` header = `Navigation` sub = `app state` app = `z2ui5_cl_demo_app_321` )
      ( group = `restricted - experimental` header = `Navigation` sub = `app state share` app = `z2ui5_cl_demo_app_323` )
      ( group = `restricted - experimental` header = `Navigation` sub = `push state` app = `z2ui5_cl_demo_app_322` )
      ( group = `restricted - experimental` header = `Navigation with app state change v1 and locking` sub = `` app = `z2ui5_cl_demo_app_350` )
      ( group = `restricted - experimental` header = `popups` sub = `p13n Dialog` app = `z2ui5_cl_demo_app_090` )
      ( group = `restricted - experimental` header = `Storage` sub = `Store data inside localStorage or sessionStorage` app = `z2ui5_cl_demo_app_327` )
      ( group = `restricted - experimental` header = `ViewSettingsDialog` sub = `` app = `z2ui5_cl_demo_app_099` )
      ( group = `obsolet` header = `Download CSV` sub = `Export Table as CSV` app = `z2ui5_cl_demo_app_057` )
      ( group = `obsolet` header = `ext` sub = `call custom function` app = `z2ui5_cl_demo_app_093` )
      ( group = `obsolet` header = `extension` sub = `canvas and svg` app = `z2ui5_cl_demo_app_036` )
      ( group = `obsolet` header = `extension` sub = `custom control` app = `z2ui5_cl_demo_app_037` )
      ( group = `obsolet` header = `extension` sub = `html css js` app = `z2ui5_cl_demo_app_032` )
      ( group = `obsolet` header = `follow_up_action with JS` sub = `` app = `z2ui5_cl_demo_app_309` )
      ( group = `obsolet` header = `follow_up_action with JS` sub = `` app = `z2ui5_cl_demo_app_309_0` )
      ( group = `obsolet` header = `History` sub = `` app = `z2ui5_cl_demo_app_139` )
      ( group = `obsolet` header = `landing page` sub = `` app = `z2ui5_cl_demo_app_000` )
      ( group = `obsolet` header = `Message Box & Input Functions` sub = `` app = `z2ui5_cl_demo_app_084` )
      ( group = `obsolet` header = `obsolete` sub = `custom control UploadSet` app = `z2ui5_cl_demo_app_354` )
      ( group = `obsolet` header = `obsolete` sub = `filter bar with variants, replaced by 478` app = `z2ui5_cl_demo_app_111` )
      ( group = `obsolet` header = `obsolete` sub = `old focus demo, use Focus custom control` app = `z2ui5_cl_demo_app_133_0` )
      ( group = `obsolet` header = `obsolete` sub = `old focus demo, use Focus custom control` app = `z2ui5_cl_demo_app_189_0` )
      ( group = `obsolet` header = `obsolete` sub = `old scroll demo, use Scrolling custom control` app = `z2ui5_cl_demo_app_134_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded browser-title demo` app = `z2ui5_cl_demo_app_125_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded follow_up_action demo` app = `z2ui5_cl_demo_app_180` )
      ( group = `obsolet` header = `obsolete` sub = `superseded frontend-info demo` app = `z2ui5_cl_demo_app_122_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded launchpad set-title demo` app = `z2ui5_cl_demo_app_lp_02_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded multiple-timers demo` app = `z2ui5_cl_demo_app_353_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded play-sound demo` app = `z2ui5_cl_demo_app_s_03_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded timer demo` app = `z2ui5_cl_demo_app_121_0` )
      ( group = `obsolet` header = `obsolete` sub = `superseded timer/popover demo` app = `z2ui5_cl_demo_app_129_0` )
      ( group = `obsolet` header = `obsolete` sub = `uses CL_GUI_TIMER, use Timer custom control` app = `z2ui5_cl_demo_app_028_0` )
      ( group = `obsolet` header = `obsolete` sub = `uses deprecated sap.f.Avatar, use sap.m.Avatar` app = `z2ui5_cl_demo_app_269` )
      ( group = `obsolet` header = `obsolete` sub = `uses deprecated sap.ui.table.AnalyticalTable` app = `z2ui5_cl_demo_app_284` )
      ( group = `obsolet` header = `obsolete` sub = `uses deprecated sap.ui.table.AnalyticalTable` app = `z2ui5_cl_demo_app_285` )
      ( group = `obsolet` header = `obsolete tab` sub = `focus edit controls, replaced by 421` app = `z2ui5_cl_demo_app_346` )
      ( group = `obsolet` header = `PDF Viewer` sub = `Display PDFs via iframe` app = `z2ui5_cl_demo_app_079` )
      ( group = `obsolet` header = `sap.m.ActionSheet`
        sub = `Action Sheet provides an easier way of showing a list of actions and allowing the user to select one. Title and Cancel button can be shown or hidden. Without an icon the entry will be left-aligned (see the last action in the list).`
        app = `z2ui5_cl_demo_app_373` )
      ( group = `obsolet` header = `sap.m.DateRangeSelection` sub = `The Date Range Selection is an extension of the Date Picker Control and enables the user to select range of dates.` app = `z2ui5_cl_demo_app_231` )
      ( group = `obsolet` header = `sap.m.PlanningCalendar` sub = `PlanningCalendar with single row selection that illustrates the built-in views.` app = `z2ui5_cl_demo_app_080` )
      ( group = `obsolet` header = `Softkeyboard on/off` sub = `` app = `z2ui5_cl_demo_app_352_0` )
      ( group = `obsolet` header = `tab` sub = `cell copy` app = `z2ui5_cl_demo_app_087` )
      ( group = `obsolet` header = `tab` sub = `toolbar container sort` app = `z2ui5_cl_demo_app_177` )
      ( group = `obsolet` header = `tree` sub = `drag & drop` app = `z2ui5_cl_demo_app_317` )
      ( group = `obsolet` header = `tree` sub = `popup select - state` app = `z2ui5_cl_demo_app_178` )
      ( group = `obsolet` header = `tree table` sub = `save expand state` app = `z2ui5_cl_demo_app_116` )
      ( group = `obsolet` header = `Tree Table I` sub = `Popup Select Entry` app = `z2ui5_cl_demo_app_068` )
      ( group = `obsolet` header = `Tree Table II` sub = `` app = `z2ui5_cl_demo_app_069` )
      ( group = `obsolet` header = `Tree Table III` sub = `Checkbox Binding per Node` app = `z2ui5_cl_demo_app_364` )
      ( group = `obsolet` header = `ui` sub = `suggestion` app = `z2ui5_cl_demo_app_060` )
      ( group = `obsolet` header = `ui` sub = `suggestion with CC filtering` app = `z2ui5_cl_demo_app_201` )
      ( group = `obsolet` header = `ui table` sub = `focus handling` app = `z2ui5_cl_demo_app_172` )
      ( group = `obsolet` header = `wizard` sub = `nextStep & subsequentSteps` app = `z2ui5_cl_demo_app_202_0` ) ).

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

