CLASS z2ui5_cl_sample_000 DEFINITION PUBLIC.

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

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_sample_000 IMPLEMENTATION.

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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        id             = `page`
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    IF class_exists( `Z2UI5_CL_SAMPLE_001` ) = abap_true.
      DATA(url_restricted) = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_sample_001|.
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
          text                = |This overview is still under construction. Click <a href="{ url }" target="_blank">here</a> to open the classic launchpad overview.| ).
    ENDIF.

    DATA(prev_group) = ``.

    LOOP AT get_catalog( ) INTO DATA(tile).

      IF tile-group <> prev_group.
        page->title(
            text  = tile-group
            level = `H3`
            class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
        prev_group = tile-group.
      ENDIF.

      DATA(row) = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = `sapUiTinyMarginBegin` ).

      IF tile-sub IS INITIAL.
        row->link(
            text  = tile-header
            press = client->_event( tile-app ) ).

      ELSE.
        row->link(
            text  = tile-header
            class = `sapUiTinyMarginEnd`
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
      ( group = `framework` header = `Binding I` sub = `Simple - Send values to the backend` app = `z2ui5_cl_demo_app_001` )
      ( group = `framework` header = `Event I` sub = `Handle events & change the view` app = `z2ui5_cl_demo_app_004` )
      ( group = `framework` header = `F4-Value-Help` sub = `Popup for value help` app = `z2ui5_cl_demo_app_009` )
      ( group = `framework` header = `Flow Logic` sub = `Different ways of calling Popups` app = `z2ui5_cl_demo_app_012` )
      ( group = `framework` header = `Event II` sub = `Call other apps & exchange data` app = `z2ui5_cl_demo_app_024` )
      ( group = `framework` header = `Popover` sub = `Simple Example` app = `z2ui5_cl_demo_app_026` )
      ( group = `framework` header = `Expression Binding` sub = `Use calculations & more functions directly in views` app = `z2ui5_cl_demo_app_027` )
      ( group = `framework` header = `Timer I` sub = `Wait n MS and call again the server` app = `z2ui5_cl_demo_app_028` )
      ( group = `framework` header = `Message View` sub = `Custom Popup, Popover & Output` app = `z2ui5_cl_demo_app_038` )
      ( group = `framework` header = `Data Types` sub = `Use of Integer, Decimals, Dates & Time` app = `z2ui5_cl_demo_app_047` )
      ( group = `framework` header = `Popover Item Level` sub = `Create a Popover for a specific entry of a table` app = `z2ui5_cl_demo_app_052` )
      ( group = `framework` header = `Download CSV` sub = `Export Table as CSV` app = `z2ui5_cl_demo_app_057` )
      ( group = `framework` header = `Dynamic Types` sub = `Use S-RTTI to send tables to the frontend` app = `z2ui5_cl_demo_app_061` )
      ( group = `framework` header = `Timer II` sub = `Set Loading Indicator while Server Request` app = `z2ui5_cl_demo_app_064` )
      ( group = `framework` header = `Formatting` sub = `Currencies` app = `z2ui5_cl_demo_app_067` )
      ( group = `framework` header = `setSizeLimit` sub = `` app = `z2ui5_cl_demo_app_071` )
      ( group = `framework` header = `New Tab` sub = `Open an URL in a new tab` app = `z2ui5_cl_demo_app_073` )
      ( group = `framework` header = `PDF Viewer` sub = `Display PDFs via iframe` app = `z2ui5_cl_demo_app_079` )
      ( group = `framework` header = `Popover with List` sub = `List to select in Popover` app = `z2ui5_cl_demo_app_081` )
      ( group = `framework` header = `Popover with Quick View` sub = `` app = `z2ui5_cl_demo_app_109` )
      ( group = `framework` header = `Dynamic Objects II` sub = `User Generic Data Refs in Subapps` app = `z2ui5_cl_demo_app_117` )
      ( group = `framework` header = `Frontend Infos` sub = `` app = `z2ui5_cl_demo_app_122` )
      ( group = `framework` header = `Tab Title` sub = `` app = `z2ui5_cl_demo_app_125` )
      ( group = `framework` header = `Dynamic Objects I` sub = `Use S-RTTI to render different Subapps` app = `z2ui5_cl_demo_app_131` )
      ( group = `framework` header = `Binding III` sub = `Table Cell Level` app = `z2ui5_cl_demo_app_144` )
      ( group = `framework` header = `Call Popup in Popup` sub = `Backend Popup Stack Handling` app = `z2ui5_cl_demo_app_161` )
      ( group = `framework` header = `Popover with Menu` sub = `` app = `z2ui5_cl_demo_app_163` )
      ( group = `framework` header = `Binding II` sub = `Structure Component Level` app = `z2ui5_cl_demo_app_166` )
      ( group = `framework` header = `Event III` sub = `Additional Infos with t_args` app = `z2ui5_cl_demo_app_167` )
      ( group = `framework` header = `Dynamic Objects III` sub = `User Generic Data Refs in Subapps` app = `z2ui5_cl_demo_app_185` )
      ( group = `framework` header = `File Download` sub = `Download files to the Frontend` app = `z2ui5_cl_demo_app_186` )
      ( group = `framework` header = `Event IV` sub = `Facet Filter - T_arg with Objects` app = `z2ui5_cl_demo_app_197` )
      ( group = `framework` header = `URL Helper` sub = `Trigger a phone's native apps like Email, Telephone and SMS` app = `z2ui5_cl_demo_app_316` )
      ( group = `framework` header = `Clipboard` sub = `Copy & Paste Text` app = `z2ui5_cl_demo_app_325` )
      ( group = `framework with action` header = `Focus I` sub = `` app = `z2ui5_cl_demo_app_133` )
      ( group = `framework with action` header = `Focus II` sub = `` app = `z2ui5_cl_demo_app_189` )
      ( group = `framework with action` header = `Hide/show Soft Keyboard` sub = `` app = `z2ui5_cl_demo_app_352` )
      ( group = `framework with action` header = `Scroll to position` sub = `client->action->gen( SCROLL_TO )` app = `z2ui5_cl_demo_app_362` )
      ( group = `framework with action` header = `Scroll into view` sub = `client->action->gen( SCROLL_INTO_VIEW )` app = `z2ui5_cl_demo_app_363` )
      ( group = `framework popups` header = `HTML` sub = `z2ui5_cl_pop_html` app = `z2ui5_cl_demo_app_149` )
      ( group = `framework popups` header = `To Confirm` sub = `z2ui5_cl_pop_to_confirm` app = `z2ui5_cl_demo_app_150` )
      ( group = `framework popups` header = `To Inform` sub = `z2ui5_cl_pop_to_inform` app = `z2ui5_cl_demo_app_151` )
      ( group = `framework popups` header = `Table & To Select` sub = `z2ui5_cl_pop_table` app = `z2ui5_cl_demo_app_152` )
      ( group = `framework popups` header = `Messages` sub = `z2ui5_cl_pop_messages` app = `z2ui5_cl_demo_app_154` )
      ( group = `framework popups` header = `Text Edit` sub = `z2ui5_cl_pop_textedit` app = `z2ui5_cl_demo_app_155` )
      ( group = `framework popups` header = `Input Value` sub = `z2ui5_cl_pop_input_val` app = `z2ui5_cl_demo_app_156` )
      ( group = `framework popups` header = `File Upload` sub = `z2ui5_cl_pop_file_ul` app = `z2ui5_cl_demo_app_157` )
      ( group = `framework popups` header = `Display PDF I` sub = `z2ui5_cl_pop_pdf` app = `z2ui5_cl_demo_app_158` )
      ( group = `framework popups` header = `Display PDF II` sub = `z2ui5_cl_pop_pdf` app = `z2ui5_cl_demo_app_159` )
      ( group = `framework popups` header = `Select-Options` sub = `z2ui5_cl_pop_get_range_m` app = `z2ui5_cl_demo_app_162` )
      ( group = `framework popups` header = `Display Table` sub = `z2ui5_cl_pop_table` app = `z2ui5_cl_demo_app_164` )
      ( group = `framework popups` header = `File Download` sub = `z2ui5_cl_pop_file_dl` app = `z2ui5_cl_demo_app_168` )
      ( group = `framework popups` header = `To Select` sub = `z2ui5_cl_pop_to_select` app = `z2ui5_cl_demo_app_174` )
      ( group = `framework popups` header = `cl_demo_output` sub = `z2ui5_cl_pop_demo_output` app = `z2ui5_cl_demo_app_365` )
      ( group = `controls with action` header = `Basic` sub = `Toast, Box & Strip` app = `z2ui5_cl_demo_app_008` )
      ( group = `controls with action` header = `Nested Views I` sub = `Basic Example` app = `z2ui5_cl_demo_app_065` )
      ( group = `controls with action` header = `Nav Container I` sub = `` app = `z2ui5_cl_demo_app_088` )
      ( group = `controls with action` header = `Nested Views II` sub = `Head & Item Table` app = `z2ui5_cl_demo_app_097` )
      ( group = `controls with action` header = `Nested Views III` sub = `Head & Item Table & Detail` app = `z2ui5_cl_demo_app_098` )
      ( group = `controls with action` header = `Nested Views IV` sub = `Sub-App` app = `z2ui5_cl_demo_app_104` )
      ( group = `controls with action` header = `Message Box` sub = `sy, bapiret, cx_root` app = `z2ui5_cl_demo_app_187` )
      ( group = `controls with action` header = `Wizard Control II` sub = `Next step & SubSequentStep` app = `z2ui5_cl_demo_app_202` )
      ( group = `controls with cc` header = `Select-Options I` sub = `` app = `z2ui5_cl_demo_app_056` )
      ( group = `controls with cc` header = `CSV Import I` sub = `CSV to ABAP internal table` app = `z2ui5_cl_demo_app_074` )
      ( group = `controls with cc` header = `Upload Files` sub = `` app = `z2ui5_cl_demo_app_075` )
      ( group = `controls with cc` header = `Select-Options II` sub = `` app = `z2ui5_cl_demo_app_078` )
      ( group = `controls with cc` header = `CSV Import II` sub = `` app = `z2ui5_cl_demo_app_136` )
      ( group = `controls with cc` header = `Change URL History` sub = `` app = `z2ui5_cl_demo_app_139` )
      ( group = `controls with cc` header = `Data Loss Protection` sub = `` app = `z2ui5_cl_demo_app_279` )
      ( group = `controls with cc` header = `Device Camera Picture` sub = `` app = `z2ui5_cl_demo_app_306` )
      ( group = `controls with cc` header = `Storage` sub = `` app = `z2ui5_cl_demo_app_327` )
      ( group = `controls with cc` header = `UploadSet` sub = `Custom Control` app = `z2ui5_cl_demo_app_354` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_018` sub = `demo - template` app = `z2ui5_cl_demo_app_018` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_020` sub = `popup - decide` app = `z2ui5_cl_demo_app_020` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_025` sub = `basic - flow logic (called)` app = `z2ui5_cl_demo_app_025` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_034` sub = `messages - t100 bapiret` app = `z2ui5_cl_demo_app_034` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_039` sub = `extension - import xml view 2` app = `z2ui5_cl_demo_app_039` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_042` sub = `demo - object page` app = `z2ui5_cl_demo_app_042` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_044` sub = `demo - smallest app` app = `z2ui5_cl_demo_app_044` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_045` sub = `tab - filter columns` app = `z2ui5_cl_demo_app_045` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_046` sub = `tab and list change` app = `z2ui5_cl_demo_app_046` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_049` sub = `ui - model update` app = `z2ui5_cl_demo_app_049` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_054` sub = `list report - navigation` app = `z2ui5_cl_demo_app_054` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_055` sub = `tab - layout` app = `z2ui5_cl_demo_app_055` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_058` sub = `list report - layout` app = `z2ui5_cl_demo_app_058` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_083` sub = `list report - filter` app = `z2ui5_cl_demo_app_083` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_086` sub = `tree - tree and nested views` app = `z2ui5_cl_demo_app_086` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_087` sub = `tab - cell copy` app = `z2ui5_cl_demo_app_087` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_094` sub = `binding - normal, deep, refs` app = `z2ui5_cl_demo_app_094` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_095` sub = `binding - subapp main` app = `z2ui5_cl_demo_app_095` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_096` sub = `binding - subapp sub` app = `z2ui5_cl_demo_app_096` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_099` sub = `view setting dialog` app = `z2ui5_cl_demo_app_099` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_105` sub = `demo 02` app = `z2ui5_cl_demo_app_105` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_112` sub = `demo 03` app = `z2ui5_cl_demo_app_112` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_114` sub = `more - feed input` app = `z2ui5_cl_demo_app_114` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_121` sub = `cc - timer` app = `z2ui5_cl_demo_app_121` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_126` sub = `App in App II` app = `z2ui5_cl_demo_app_126` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_129` sub = `timer and popover` app = `z2ui5_cl_demo_app_129` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_130` sub = `Selectoptions` app = `z2ui5_cl_demo_app_130` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_132` sub = `App in App II` app = `z2ui5_cl_demo_app_132` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_140` sub = `basic - multi combo box` app = `z2ui5_cl_demo_app_140` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_143` sub = `ui table with filter` app = `z2ui5_cl_demo_app_143` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_153` sub = `binding` app = `z2ui5_cl_demo_app_153` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_170` sub = `popup - nav container in popup` app = `z2ui5_cl_demo_app_170` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_171` sub = `popup - popup_to_confirm2` app = `z2ui5_cl_demo_app_171` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_184` sub = `App in App II` app = `z2ui5_cl_demo_app_184` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_190` sub = `Deep Structure` app = `z2ui5_cl_demo_app_190` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_192` sub = `App Calling App with REF` app = `z2ui5_cl_demo_app_192` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_193` sub = `data container` app = `z2ui5_cl_demo_app_193` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_194` sub = `Deep Structure Sub App` app = `z2ui5_cl_demo_app_194` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_211` sub = `App in App I` app = `z2ui5_cl_demo_app_211` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_212` sub = `App in App II` app = `z2ui5_cl_demo_app_212` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_258` sub = `Side Navigation Demo` app = `z2ui5_cl_demo_app_258` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_318` sub = `more - html pdf` app = `z2ui5_cl_demo_app_318` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_329` sub = `Data Object for Sample 328` app = `z2ui5_cl_demo_app_329` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_333` sub = `Data Object with Data Ref` app = `z2ui5_cl_demo_app_333` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_336` sub = `RTTI - With Data Ref´s` app = `z2ui5_cl_demo_app_336` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_339` sub = `App in App - Subapp` app = `z2ui5_cl_demo_app_339` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_340` sub = `App in App - Popup` app = `z2ui5_cl_demo_app_340` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_342` sub = `App in App - Subapp` app = `z2ui5_cl_demo_app_342` )
      ( group = `uncategorized` header = `z2ui5_cl_demo_app_350` sub = `Navigation with app state change v1` app = `z2ui5_cl_demo_app_350` )
      ( group = `controls` header = `List I` sub = `Basic` app = `z2ui5_cl_demo_app_003` )
      ( group = `controls` header = `Range Slider` sub = `` app = `z2ui5_cl_demo_app_005` )
      ( group = `controls` header = `Toolbar` sub = `Add a container & toolbar` app = `z2ui5_cl_demo_app_006` )
      ( group = `controls` header = `Header, Footer, Grid` sub = `Split view in different areas` app = `z2ui5_cl_demo_app_010` )
      ( group = `controls` header = `Editable` sub = `Set columns editable` app = `z2ui5_cl_demo_app_011` )
      ( group = `controls` header = `Formatted Text` sub = `Display HTML` app = `z2ui5_cl_demo_app_015` )
      ( group = `controls` header = `Object Page with Avatar` sub = `Since 1.73` app = `z2ui5_cl_demo_app_017` )
      ( group = `controls` header = `Selection Modes` sub = `Single Select & Multi Select` app = `z2ui5_cl_demo_app_019` )
      ( group = `controls` header = `Text Area` sub = `` app = `z2ui5_cl_demo_app_021` )
      ( group = `controls` header = `Progress Indicator` sub = `` app = `z2ui5_cl_demo_app_022` )
      ( group = `controls` header = `Dynamic Page` sub = `Display items` app = `z2ui5_cl_demo_app_030` )
      ( group = `controls` header = `Import View` sub = `Copy & paste views of the UI5 Documentation` app = `z2ui5_cl_demo_app_031` )
      ( group = `controls` header = `Code Editor` sub = `` app = `z2ui5_cl_demo_app_035` )
      ( group = `controls` header = `Step Input` sub = `` app = `z2ui5_cl_demo_app_041` )
      ( group = `controls` header = `List II` sub = `Events & Visualization` app = `z2ui5_cl_demo_app_048` )
      ( group = `controls` header = `Label` sub = `` app = `z2ui5_cl_demo_app_051` )
      ( group = `controls` header = `Search Field I` sub = `Filter with enter` app = `z2ui5_cl_demo_app_053` )
      ( group = `controls` header = `Search Field II` sub = `Filter with Live Change Event` app = `z2ui5_cl_demo_app_059` )
      ( group = `controls` header = `Generic Tag` sub = `Since 1.70` app = `z2ui5_cl_demo_app_062` )
      ( group = `controls` header = `Tree Table I` sub = `Popup Select Entry` app = `z2ui5_cl_demo_app_068` )
      ( group = `controls` header = `Flexible Column Layout` sub = `Master details with tree` app = `z2ui5_cl_demo_app_069` )
      ( group = `controls` header = `ui.Table I` sub = `Simple example` app = `z2ui5_cl_demo_app_070` )
      ( group = `controls` header = `Visualization` sub = `Object Number, Object States & Tab Filter` app = `z2ui5_cl_demo_app_072` )
      ( group = `controls` header = `Planning Calendar` sub = `` app = `z2ui5_cl_demo_app_080` )
      ( group = `controls` header = `Feed Input` sub = `` app = `z2ui5_cl_demo_app_101` )
      ( group = `controls` header = `Splitting Container` sub = `` app = `z2ui5_cl_demo_app_103` )
      ( group = `controls` header = `Rich Text Editor` sub = `` app = `z2ui5_cl_demo_app_106` )
      ( group = `controls` header = `Mask Input` sub = `` app = `z2ui5_cl_demo_app_110` )
      ( group = `controls` header = `ui.Table II` sub = `Events on Cell Level` app = `z2ui5_cl_demo_app_160` )
      ( group = `controls` header = `Templating I` sub = `Basic Example` app = `z2ui5_cl_demo_app_173` )
      ( group = `controls` header = `Wizard Control I` sub = `` app = `z2ui5_cl_demo_app_175` )
      ( group = `controls` header = `Templating II` sub = `Nested Views` app = `z2ui5_cl_demo_app_176` )
      ( group = `controls` header = `Cards` sub = `` app = `z2ui5_cl_demo_app_181` )
      ( group = `controls` header = `Flex Box` sub = `Basic Alignment` app = `z2ui5_cl_demo_app_205` )
      ( group = `controls` header = `Text` sub = `Max Lines` app = `z2ui5_cl_demo_app_206` )
      ( group = `controls` header = `Radio Button` sub = `` app = `z2ui5_cl_demo_app_207` )
      ( group = `controls` header = `Radio Button Group` sub = `` app = `z2ui5_cl_demo_app_208` )
      ( group = `controls` header = `InfoLabel` sub = `` app = `z2ui5_cl_demo_app_209` )
      ( group = `controls` header = `Input` sub = `Types` app = `z2ui5_cl_demo_app_210` )
      ( group = `controls` header = `Input` sub = `Password` app = `z2ui5_cl_demo_app_213` )
      ( group = `controls` header = `Icon Tab Header` sub = `Standalone Icon Tab Header` app = `z2ui5_cl_demo_app_214` )
      ( group = `controls` header = `Busy Indicator` sub = `` app = `z2ui5_cl_demo_app_215` )
      ( group = `controls` header = `Action List Item` sub = `` app = `z2ui5_cl_demo_app_216` )
      ( group = `controls` header = `Overflow Toolbar` sub = `Placing a Title in OverflowToolbar/Toolbar` app = `z2ui5_cl_demo_app_217` )
      ( group = `controls` header = `Flex Box` sub = `Opposing Alignment` app = `z2ui5_cl_demo_app_218` )
      ( group = `controls` header = `Input List Item` sub = `` app = `z2ui5_cl_demo_app_219` )
      ( group = `controls` header = `Rating Indicator` sub = `` app = `z2ui5_cl_demo_app_220` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Icons Only` app = `z2ui5_cl_demo_app_221` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Text and Count` app = `z2ui5_cl_demo_app_222` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Inline Mode` app = `z2ui5_cl_demo_app_223` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Text Only` app = `z2ui5_cl_demo_app_224` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Separator` app = `z2ui5_cl_demo_app_225` )
      ( group = `controls` header = `Icon Tab Bar` sub = `Sub tabs` app = `z2ui5_cl_demo_app_226` )
      ( group = `controls` header = `Bar` sub = `Page, Toolbar & Bar` app = `z2ui5_cl_demo_app_227` )
      ( group = `controls` header = `Tile` sub = `Numeric Content Without Margins` app = `z2ui5_cl_demo_app_228` )
      ( group = `controls` header = `ComboBox` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_229` )
      ( group = `controls` header = `Segmented Button in Input List Item` sub = `` app = `z2ui5_cl_demo_app_230` )
      ( group = `controls` header = `Date Range Selection` sub = `` app = `z2ui5_cl_demo_app_231` )
      ( group = `controls` header = `Multi Input` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_232` )
      ( group = `controls` header = `Multi Combo Box` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_233` )
      ( group = `controls` header = `Text Area` sub = `Value States` app = `z2ui5_cl_demo_app_234` )
      ( group = `controls` header = `Bar` sub = `Toolbar vs Bar vs OverflowToolbar` app = `z2ui5_cl_demo_app_235` )
      ( group = `controls` header = `Text Area` sub = `Growing` app = `z2ui5_cl_demo_app_236` )
      ( group = `controls` header = `Slider` sub = `` app = `z2ui5_cl_demo_app_237` )
      ( group = `controls` header = `Message Strip` sub = `` app = `z2ui5_cl_demo_app_238` )
      ( group = `controls` header = `Checkbox` sub = `` app = `z2ui5_cl_demo_app_239` )
      ( group = `controls` header = `Switch` sub = `` app = `z2ui5_cl_demo_app_240` )
      ( group = `controls` header = `Tile` sub = `Tile Content` app = `z2ui5_cl_demo_app_241` )
      ( group = `controls` header = `HTML` sub = `` app = `z2ui5_cl_demo_app_242` )
      ( group = `controls` header = `Standard Margins` sub = `Negative Margins` app = `z2ui5_cl_demo_app_243` )
      ( group = `controls` header = `Flex Box` sub = `Direction & Order` app = `z2ui5_cl_demo_app_245` )
      ( group = `controls` header = `Input` sub = `Suggestions wrapping` app = `z2ui5_cl_demo_app_246` )
      ( group = `controls` header = `Splitter Layout` sub = `2 areas` app = `z2ui5_cl_demo_app_247` )
      ( group = `controls` header = `Splitter Layout` sub = `2 non-resizable areas` app = `z2ui5_cl_demo_app_248` )
      ( group = `controls` header = `Splitter Layout` sub = `3 areas` app = `z2ui5_cl_demo_app_249` )
      ( group = `controls` header = `OverflowToolbar` sub = `Alignment` app = `z2ui5_cl_demo_app_250` )
      ( group = `controls` header = `Input` sub = `Description` app = `z2ui5_cl_demo_app_251` )
      ( group = `controls` header = `Flex Box` sub = `Render Type` app = `z2ui5_cl_demo_app_252` )
      ( group = `controls` header = `Generic Tag with Different Configurations` sub = `` app = `z2ui5_cl_demo_app_257` )
      ( group = `controls` header = `Button` sub = `` app = `z2ui5_cl_demo_app_259` )
      ( group = `controls` header = `Nested Splitter Layouts` sub = `7 Areas` app = `z2ui5_cl_demo_app_260` )
      ( group = `controls` header = `Tile` sub = `News Content` app = `z2ui5_cl_demo_app_261` )
      ( group = `controls` header = `Tile` sub = `Numeric Content of Different Colors` app = `z2ui5_cl_demo_app_262` )
      ( group = `controls` header = `Tile` sub = `Numeric Content with Icon` app = `z2ui5_cl_demo_app_263` )
      ( group = `controls` header = `Step Input` sub = `Value States` app = `z2ui5_cl_demo_app_264` )
      ( group = `controls` header = `Code Editor` sub = `` app = `z2ui5_cl_demo_app_265` )
      ( group = `controls` header = `Toggle Button` sub = `` app = `z2ui5_cl_demo_app_266` )
      ( group = `controls` header = `Multi Input` sub = `Value States` app = `z2ui5_cl_demo_app_267` )
      ( group = `controls` header = `Color Picker` sub = `` app = `z2ui5_cl_demo_app_270` )
      ( group = `controls` header = `Tile` sub = `Image Content` app = `z2ui5_cl_demo_app_271` )
      ( group = `controls` header = `Object Header` sub = `with Circle-shaped Image` app = `z2ui5_cl_demo_app_272` )
      ( group = `controls` header = `LightBox` sub = `` app = `z2ui5_cl_demo_app_273` )
      ( group = `controls` header = `Slide Tile` sub = `` app = `z2ui5_cl_demo_app_274` )
      ( group = `controls` header = `Tile` sub = `Feed Content` app = `z2ui5_cl_demo_app_275` )
      ( group = `controls` header = `Tile` sub = `Monitor Tile` app = `z2ui5_cl_demo_app_276` )
      ( group = `controls` header = `Tile` sub = `Feed and News Tile` app = `z2ui5_cl_demo_app_278` )
      ( group = `controls` header = `Header Container` sub = `Vertical Mode` app = `z2ui5_cl_demo_app_280` )
      ( group = `controls` header = `Tile` sub = `Statuses` app = `z2ui5_cl_demo_app_281` )
      ( group = `controls` header = `InvisibleText` sub = `` app = `z2ui5_cl_demo_app_282` )
      ( group = `controls` header = `Feed Input 2` sub = `` app = `z2ui5_cl_demo_app_283` )
      ( group = `controls` header = `Standard List Item` sub = `Wrapping` app = `z2ui5_cl_demo_app_287` )
      ( group = `controls` header = `Select` sub = `` app = `z2ui5_cl_demo_app_288` )
      ( group = `controls` header = `Object Marker in a table` sub = `` app = `z2ui5_cl_demo_app_289` )
      ( group = `controls` header = `Object List Item` sub = `markers aggregation` app = `z2ui5_cl_demo_app_290` )
      ( group = `controls` header = `Message Strip` sub = `with enableFormattedText` app = `z2ui5_cl_demo_app_291` )
      ( group = `controls` header = `Breadcrumbs` sub = `sample with current page link` app = `z2ui5_cl_demo_app_292` )
      ( group = `controls` header = `Link` sub = `` app = `z2ui5_cl_demo_app_293` )
      ( group = `controls` header = `Date Picker` sub = `Value States` app = `z2ui5_cl_demo_app_294` )
      ( group = `controls` header = `Date Range Selection` sub = `Value States` app = `z2ui5_cl_demo_app_295` )
      ( group = `controls` header = `Search Field` sub = `` app = `z2ui5_cl_demo_app_296` )
      ( group = `controls` header = `Select` sub = `with icons` app = `z2ui5_cl_demo_app_297` )
      ( group = `controls` header = `Select` sub = `Validation states` app = `z2ui5_cl_demo_app_298` )
      ( group = `controls` header = `Select` sub = `Wrapping text` app = `z2ui5_cl_demo_app_299` )
      ( group = `controls` header = `Object Status` sub = `` app = `z2ui5_cl_demo_app_300` )
      ( group = `controls` header = `Object Attribute inside Table` sub = `` app = `z2ui5_cl_demo_app_302` )
      ( group = `controls` header = `Object Page Header` sub = `with Header Container` app = `z2ui5_cl_demo_app_303` )
      ( group = `controls` header = `Grid List` sub = `with Drag&Drop` app = `z2ui5_cl_demo_app_307` )
      ( group = `controls` header = `ObjectPage` sub = `with Hidden Section Titles` app = `z2ui5_cl_demo_app_330` )
      ( group = `controls` header = `Tree Table II` sub = `Checkbox Binding per Node` app = `z2ui5_cl_demo_app_364` ) ).

  ENDMETHOD.

ENDCLASS.
