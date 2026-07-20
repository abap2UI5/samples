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
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.

      scroll_restore( ).
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA classname TYPE string.
        DATA li_app TYPE REF TO z2ui5_if_app.

    TRY.
        
        classname = to_upper( client->get( )-event ).
        
        CREATE OBJECT li_app TYPE (classname).
        MOVE-CORRESPONDING client->get( )-s_scroll-main TO s_scroll.
        client->nav_app_call( li_app ).
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD scroll_restore.
    DATA temp1 TYPE string_table.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE LINE OF temp1.

    IF s_scroll-id IS INITIAL.
      RETURN.
    ENDIF.

    
    CLEAR temp1.
    INSERT s_scroll-id INTO TABLE temp1.
    
    temp2 = |{ s_scroll-y }|.
    INSERT temp2 INTO TABLE temp1.
    
    temp3 = |{ s_scroll-x }|.
    INSERT temp3 INTO TABLE temp1.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_to
        t_arg = temp1 ).

  ENDMETHOD.


  METHOD view_display.

    DATA t_catalog TYPE z2ui5_cl_demo_app_g00=>ty_t_tile.
    DATA t_blocks TYPE z2ui5_cl_demo_app_g00=>ty_t_block.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
      DATA url_restricted TYPE string.
      DATA temp3 TYPE string_table.
    DATA prev_group TYPE string.
    DATA prev_base TYPE string.
    DATA tile LIKE LINE OF t_catalog.
      DATA base TYPE string.
      DATA new_block LIKE abap_false.
      DATA tenths TYPE i.
      DATA temp4 LIKE LINE OF t_blocks.
      DATA temp6 LIKE sy-tabix.
      DATA width TYPE string.
      DATA temp5 TYPE string.
      DATA row TYPE REF TO z2ui5_cl_xml_view.
    t_catalog = get_catalog( ).
    
    t_blocks = block_widths( t_catalog ).

    
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell( )->page(
        id             = `page`
        title          = `abap2UI5 - Samples`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    IF class_exists( `Z2UI5_CL_SAMPLE_APP_G01` ) = abap_true.
      
      url_restricted = |{ client->get( )-s_config-origin }{ client->get( )-s_config-pathname }?app_start=z2ui5_cl_sample_app_g01|.
      
      CLEAR temp3.
      INSERT url_restricted INTO TABLE temp3.
      page->header_content( )->button(
          text  = `Extended Samples`
          icon  = `sap-icon://action`
          press = client->_event_client( val   = client->cs_event-open_new_tab
                                         t_arg = temp3 ) ).
    ENDIF.

    
    prev_group = ``.
    
    prev_base = ``.

    
    LOOP AT t_catalog INTO tile.

      
      base = block_base( group  = tile-group
                               header = tile-header ).
      
      new_block = abap_false.

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
      
      
      
      temp6 = sy-tabix.
      READ TABLE t_blocks WITH KEY group = tile-group base = base INTO temp4.
      sy-tabix = temp6.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      tenths = ( temp4-width + 45 ) DIV 10.
      
      width = |{ tenths DIV 10 }.{ tenths MOD 10 }em|.
      
      IF new_block = abap_true.
        temp5 = `sapUiTinyMarginBegin sapUiSmallMarginTop`.
      ELSE.
        temp5 = `sapUiTinyMarginBegin`.
      ENDIF.
      
      row = page->hbox(
          alignitems = `Center`
          wrap       = `Wrap`
          class      = temp5 ).

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
        DATA li_app TYPE REF TO z2ui5_if_app.
        DATA temp1 TYPE xsdboolean.

    TRY.
        
        CREATE OBJECT li_app TYPE (name).
        
        temp1 = boolc( li_app IS BOUND ).
        result = temp1.
      CATCH cx_root.
        result = abap_false.
    ENDTRY.

  ENDMETHOD.


  METHOD get_catalog.

    DATA temp6 TYPE z2ui5_cl_demo_app_g00=>ty_t_tile.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp6.
    
    temp7-group = `Basic I`.
    temp7-header = `Action`.
    temp7-sub = `Call Method of Object`.
    temp7-app = `z2ui5_cl_demo_app_446`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Action`.
    temp7-sub = `Call Method of Object by ID`.
    temp7-app = `z2ui5_cl_demo_app_447`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Binding`.
    temp7-sub = `Expression Binding`.
    temp7-app = `z2ui5_cl_demo_app_027`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Binding`.
    temp7-sub = `Formatting Currencies`.
    temp7-app = `z2ui5_cl_demo_app_067`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Binding`.
    temp7-sub = `Formatting Integers, Decimals, Dates & Time`.
    temp7-app = `z2ui5_cl_demo_app_047`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Binding`.
    temp7-sub = `Level Structure/Component`.
    temp7-app = `z2ui5_cl_demo_app_166`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Binding`.
    temp7-sub = `Level Table/Cell`.
    temp7-app = `z2ui5_cl_demo_app_144`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Event`.
    temp7-sub = `Additional Infos with t_args`.
    temp7-app = `z2ui5_cl_demo_app_167`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Event`.
    temp7-sub = `Facet Filter T_arg with Objects`.
    temp7-app = `z2ui5_cl_demo_app_197`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Event`.
    temp7-sub = `Handle events & change the view`.
    temp7-app = `z2ui5_cl_demo_app_004`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Formatter`.
    temp7-sub = `Date Object for DatePicker`.
    temp7-app = `z2ui5_cl_demo_app_457`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Formatter`.
    temp7-sub = `Date Objects for PlanningCalendar`.
    temp7-app = `z2ui5_cl_demo_app_456`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Formatter`.
    temp7-sub = `Simple`.
    temp7-app = `z2ui5_cl_demo_app_453`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Formatter`.
    temp7-sub = `Use via core:require`.
    temp7-app = `z2ui5_cl_demo_app_450`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Message`.
    temp7-sub = `Backend Processing`.
    temp7-app = `z2ui5_cl_demo_app_008`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Message`.
    temp7-sub = `MessageBox`.
    temp7-app = `z2ui5_cl_demo_app_382`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Message`.
    temp7-sub = `MessageToast`.
    temp7-app = `z2ui5_cl_demo_app_381`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Message`.
    temp7-sub = `MessageView`.
    temp7-app = `z2ui5_cl_demo_app_452`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Model`.
    temp7-sub = `Device Model`.
    temp7-app = `z2ui5_cl_demo_app_445`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Model`.
    temp7-sub = `Message Model`.
    temp7-app = `z2ui5_cl_demo_app_458`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Model`.
    temp7-sub = `Set Size Limit`.
    temp7-app = `z2ui5_cl_demo_app_071`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `More`.
    temp7-sub = `Call and leave to apps`.
    temp7-app = `z2ui5_cl_demo_app_024`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `More`.
    temp7-sub = `Error Handling`.
    temp7-app = `z2ui5_cl_demo_app_464`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `More`.
    temp7-sub = `Generic Data Reference`.
    temp7-app = `z2ui5_cl_demo_app_061`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `More`.
    temp7-sub = `Read Frontend Infos`.
    temp7-app = `z2ui5_cl_demo_app_122`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `More`.
    temp7-sub = `Require Object in XML View`.
    temp7-app = `z2ui5_cl_demo_app_163`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Nested Views`.
    temp7-sub = `Basic Example`.
    temp7-app = `z2ui5_cl_demo_app_065`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Nested Views`.
    temp7-sub = `Head & Item Table`.
    temp7-app = `z2ui5_cl_demo_app_097`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Nested Views`.
    temp7-sub = `Head & Item Table & Detail`.
    temp7-app = `z2ui5_cl_demo_app_098`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Nested Views`.
    temp7-sub = `Sub-App`.
    temp7-app = `z2ui5_cl_demo_app_104`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popover`.
    temp7-sub = `Display Quick View`.
    temp7-app = `z2ui5_cl_demo_app_109`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popover`.
    temp7-sub = `Item Level of Table`.
    temp7-app = `z2ui5_cl_demo_app_052`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popover`.
    temp7-sub = `List to select in Popover`.
    temp7-app = `z2ui5_cl_demo_app_081`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popover`.
    temp7-sub = `Simple Example`.
    temp7-app = `z2ui5_cl_demo_app_026`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popup`.
    temp7-sub = `Different ways of calling Popups`.
    temp7-app = `z2ui5_cl_demo_app_012`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popup`.
    temp7-sub = `Popup in Popup - Backend Stack Handling`.
    temp7-app = `z2ui5_cl_demo_app_161`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Popup`.
    temp7-sub = `Value Help with Popups`.
    temp7-app = `z2ui5_cl_demo_app_009`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Templating`.
    temp7-sub = `Basic Example`.
    temp7-app = `z2ui5_cl_demo_app_173`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic I`.
    temp7-header = `Templating`.
    temp7-sub = `Nested Views`.
    temp7-app = `z2ui5_cl_demo_app_176`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Browser`.
    temp7-sub = `Logout (A)`.
    temp7-app = `z2ui5_cl_demo_app_361`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Browser`.
    temp7-sub = `Open an URL in a new tab (A)`.
    temp7-app = `z2ui5_cl_demo_app_073`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Browser`.
    temp7-sub = `Open Telephon, Email usw (A)`.
    temp7-app = `z2ui5_cl_demo_app_316`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Browser`.
    temp7-sub = `Title (A)`.
    temp7-app = `z2ui5_cl_demo_app_125`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Focus`.
    temp7-sub = `Jump with the focus (A)`.
    temp7-app = `z2ui5_cl_demo_app_189`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Focus`.
    temp7-sub = `Set Focus in Textfield (A)`.
    temp7-app = `z2ui5_cl_demo_app_133`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Input`.
    temp7-sub = `Clipboard (A)`.
    temp7-app = `z2ui5_cl_demo_app_325`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Input`.
    temp7-sub = `Hide/show Soft Keyboard (A)`.
    temp7-app = `z2ui5_cl_demo_app_352`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `List`.
    temp7-sub = `Events & Visualization`.
    temp7-app = `z2ui5_cl_demo_app_048`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `List`.
    temp7-sub = `Frontend Filter/Sort via Backend Event (A)`.
    temp7-app = `z2ui5_cl_demo_app_454`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `List`.
    temp7-sub = `Frontend Live Filter without Backend (A)`.
    temp7-app = `z2ui5_cl_demo_app_455`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `CameraSelector (C)`.
    temp7-app = `z2ui5_cl_demo_app_306`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Data Loss Protection (C)`.
    temp7-app = `z2ui5_cl_demo_app_279`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `File Uploader (C)`.
    temp7-app = `z2ui5_cl_demo_app_074`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Geoloaction (C)`.
    temp7-app = `z2ui5_cl_demo_app_120`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Message Manager (C)`.
    temp7-app = `z2ui5_cl_demo_app_467`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `MessageStrip Inline Icons`.
    temp7-app = `z2ui5_cl_demo_app_466`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Multi Input (C)`.
    temp7-app = `z2ui5_cl_demo_app_078`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Panel, setExpanded (A)`.
    temp7-app = `z2ui5_cl_demo_app_448`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `PDF Viewer Display (A)`.
    temp7-app = `z2ui5_cl_demo_app_449`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Popover Toggle (A)`.
    temp7-app = `z2ui5_cl_demo_app_465`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `More`.
    temp7-sub = `Wizard Control (A)`.
    temp7-app = `z2ui5_cl_demo_app_202`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `NavContainer`.
    temp7-sub = `Popup (A)`.
    temp7-app = `z2ui5_cl_demo_app_170`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `NavContainer`.
    temp7-sub = `Simple (A)`.
    temp7-app = `z2ui5_cl_demo_app_088`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Scroll`.
    temp7-sub = `Scroll into view (A)`.
    temp7-app = `z2ui5_cl_demo_app_363`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Scroll`.
    temp7-sub = `Scroll to position (A)`.
    temp7-app = `z2ui5_cl_demo_app_362`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Backend Filter`.
    temp7-app = `z2ui5_cl_demo_app_045`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Drag and Drop (A)`.
    temp7-app = `z2ui5_cl_demo_app_459`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Editable`.
    temp7-app = `z2ui5_cl_demo_app_011`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Live Search via Backend`.
    temp7-app = `z2ui5_cl_demo_app_059`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Search via Backend`.
    temp7-app = `z2ui5_cl_demo_app_053`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Selection Modes: Single Select & Multi Select`.
    temp7-app = `z2ui5_cl_demo_app_019`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Table`.
    temp7-sub = `Table with ScrollContainer`.
    temp7-app = `z2ui5_cl_demo_app_006`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Timer`.
    temp7-sub = `Loading Indicator with WAIT UP Backend (A)`.
    temp7-app = `z2ui5_cl_demo_app_064`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Timer`.
    temp7-sub = `Wait n MS and call again the server (A)`.
    temp7-app = `z2ui5_cl_demo_app_028`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Tree`.
    temp7-sub = `Drag and Drop (A,C)`.
    temp7-app = `z2ui5_cl_demo_app_461`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Tree`.
    temp7-sub = `Editable with Custom Item (C)`.
    temp7-app = `z2ui5_cl_demo_app_463`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Tree`.
    temp7-sub = `Inside Popup (C)`.
    temp7-app = `z2ui5_cl_demo_app_462`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `Tree`.
    temp7-sub = `Simple`.
    temp7-app = `z2ui5_cl_demo_app_460`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `ui.Table`.
    temp7-sub = `Default Filtering (C)`.
    temp7-app = `z2ui5_cl_demo_app_143`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `ui.Table`.
    temp7-sub = `Events on Cell Level`.
    temp7-app = `z2ui5_cl_demo_app_160`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `Basic II`.
    temp7-header = `ui.Table`.
    temp7-sub = `Full Example`.
    temp7-app = `z2ui5_cl_demo_app_070`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ActionListItem`.
    temp7-sub = `Use the Action List Item to trigger an action directly from a list`.
    temp7-app = `z2ui5_cl_demo_app_216`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Breadcrumbs`.
    temp7-sub = `Breadcrumbs sample with current page set as aggregation, resulting in a link`.
    temp7-app = `z2ui5_cl_demo_app_292`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `BusyIndicator`.
    temp7-sub = `The Busy Indicator signals that some operation is going on and that the user must wait ...`.
    temp7-app = `z2ui5_cl_demo_app_215`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Button`.
    temp7-sub = `Buttons trigger user actions and come in a variety of shapes and colors. Placing a button ...`.
    temp7-app = `z2ui5_cl_demo_app_259`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Carousel`.
    temp7-sub = `A sample of a Carousel that contains images.`.
    temp7-app = `z2ui5_cl_demo_app_371`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `CheckBox`.
    temp7-sub = `Checkboxes allow users to select a subset of options. If you want to offer an off/on ...`.
    temp7-app = `z2ui5_cl_demo_app_239`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ComboBox`.
    temp7-sub = `Suggestions wrap automatically when longer then the dropdown width`.
    temp7-app = `z2ui5_cl_demo_app_229`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `DatePicker`.
    temp7-sub = `This example shows different DatePicker value states.`.
    temp7-app = `z2ui5_cl_demo_app_294`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `DateRangeSelection`.
    temp7-sub = `This example shows different DateRangeSelection value states.`.
    temp7-app = `z2ui5_cl_demo_app_295`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `DateTimePicker`.
    temp7-sub = `Value States`.
    temp7-app = `z2ui5_cl_demo_app_377`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FeedContent`.
    temp7-sub = `Shows the tile containing the text of the feed, a subheader, and a numeric value.`.
    temp7-app = `z2ui5_cl_demo_app_275`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FeedInput`.
    temp7-sub = ``.
    temp7-app = `z2ui5_cl_demo_app_114`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FeedInput`.
    temp7-sub = `This sample shows a standalone feed input with different settings.`.
    temp7-app = `z2ui5_cl_demo_app_283`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FeedListItem`.
    temp7-sub = `This sample shows you how to build a complete feed user interface by combining a ...`.
    temp7-app = `z2ui5_cl_demo_app_101`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FlexBox`.
    temp7-sub = `Flex Box items can be placed in different areas using the justifyContent and alignItem ...`.
    temp7-app = `z2ui5_cl_demo_app_205`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FlexBox`.
    temp7-sub = `Flex items can be rendered differently. By default, they are wrapped in a div element ...`.
    temp7-app = `z2ui5_cl_demo_app_252`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FlexBox`.
    temp7-sub = `In this Flex Box the items are aligned at opposing ends of the container with ...`.
    temp7-app = `z2ui5_cl_demo_app_218`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FlexBox`.
    temp7-sub = `You can influence the direction and order of elements in horizontal and vertical Flex Box ...`.
    temp7-app = `z2ui5_cl_demo_app_245`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `FormattedText`.
    temp7-sub = `The control can be used for embedding formatted HTML text into your application.`.
    temp7-app = `z2ui5_cl_demo_app_015`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `GenericTag`.
    temp7-sub = `Previews of the GenericTag control based on combinations of different sets of properties.`.
    temp7-app = `z2ui5_cl_demo_app_257`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `GenericTile`.
    temp7-sub = `Shows Feed Tile and News Tile samples that can contain feed content, news content, and a ...`.
    temp7-app = `z2ui5_cl_demo_app_278`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `GenericTile`.
    temp7-sub = `Shows Monitor Tile samples that can contain header, subheader, icon, key value, unit, and ...`.
    temp7-app = `z2ui5_cl_demo_app_276`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `GenericTile`.
    temp7-sub = `Shows the GenericTile while it is loading, if loading fails, and in disabled status.`.
    temp7-app = `z2ui5_cl_demo_app_281`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `HeaderContainer`.
    temp7-sub = `The Header Container with a vertical layout and with divider lines.`.
    temp7-app = `z2ui5_cl_demo_app_280`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `In this example, the Icon Tab Bar is used to apply filters on a table and display the ...`.
    temp7-app = `z2ui5_cl_demo_app_368`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `In this example, the Icon Tab Bar tabs display icons only.`.
    temp7-app = `z2ui5_cl_demo_app_221`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `In this example, the Icon Tab Bar tabs display text and corresponding count.`.
    temp7-app = `z2ui5_cl_demo_app_222`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `In this example, the Icon Tab Bar tabs display text only.`.
    temp7-app = `z2ui5_cl_demo_app_224`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `In this example, the Icon Tab Bar tabs display the text and the count in one line.`.
    temp7-app = `z2ui5_cl_demo_app_223`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `This is an example how to use separators in the Icon Tab Bar. You can choose an icon as a ...`.
    temp7-app = `z2ui5_cl_demo_app_225`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabBar`.
    temp7-sub = `This sample illustrates nested tabs with or without own content in their root-level tab.`.
    temp7-app = `z2ui5_cl_demo_app_226`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `IconTabHeader`.
    temp7-sub = `Icon Tab Header used standalone, outside of Icon Tab Bar.`.
    temp7-app = `z2ui5_cl_demo_app_214`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Image`.
    temp7-sub = `Images are faster than words and attract people's attention. Images can also have an ...`.
    temp7-app = `z2ui5_cl_demo_app_379`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ImageContent`.
    temp7-sub = `Shows ImageContent that can include an icon, a profile image, or a logo with a tooltip.`.
    temp7-app = `z2ui5_cl_demo_app_271`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Input`.
    temp7-sub = `Input type corresponds to the type attribute of the HTML input tag. On touch devices, it ...`.
    temp7-app = `z2ui5_cl_demo_app_210`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Input`.
    temp7-sub = `Suggestions wrap automatically when longer then the dropdown width`.
    temp7-app = `z2ui5_cl_demo_app_246`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Input`.
    temp7-sub = `This sample illustrates the usage of the description with input fields, e.g. description ...`.
    temp7-app = `z2ui5_cl_demo_app_251`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Input`.
    temp7-sub = `To make sure the password is not shown as clear text you set the 'type' of an input ...`.
    temp7-app = `z2ui5_cl_demo_app_213`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `InputListItem`.
    temp7-sub = `Use the Input List Item on phones to build form like user interfaces.`.
    temp7-app = `z2ui5_cl_demo_app_219`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Label`.
    temp7-sub = `Labels are helpful when you need to describe some other UI control.`.
    temp7-app = `z2ui5_cl_demo_app_051`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `LightBox`.
    temp7-sub = `Displays several image thumbnails. Clicking on each of them will open a LightBox.`.
    temp7-app = `z2ui5_cl_demo_app_273`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Link`.
    temp7-sub = `Here are some links. Typically links are used in user interfaces to trigger navigation to ...`.
    temp7-app = `z2ui5_cl_demo_app_293`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MaskInput`.
    temp7-sub = `The sap.m.MaskInput control allows users to easily enter data in a certain format and in ...`.
    temp7-app = `z2ui5_cl_demo_app_110`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MenuButton`.
    temp7-sub = `This control is used to open a menu in both desktop and mobile.`.
    temp7-app = `z2ui5_cl_demo_app_372`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MessageStrip`.
    temp7-sub = `A sample MessageStrip that shows status messages with additional formatting.`.
    temp7-app = `z2ui5_cl_demo_app_291`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MessageStrip`.
    temp7-sub = `MessageStrip for showing status messages.`.
    temp7-app = `z2ui5_cl_demo_app_238`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MessageView`.
    temp7-sub = `A sample with Message View and inside a Dialog and grouping of items`.
    temp7-app = `z2ui5_cl_demo_app_038`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MultiComboBox`.
    temp7-sub = ``.
    temp7-app = `z2ui5_cl_demo_app_140`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MultiComboBox`.
    temp7-sub = `Suggestions wrap automatically when longer then the dropdown width`.
    temp7-app = `z2ui5_cl_demo_app_233`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MultiInput`.
    temp7-sub = `Suggestions wrap automatically when longer then the dropdown width`.
    temp7-app = `z2ui5_cl_demo_app_232`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `MultiInput`.
    temp7-sub = `This sample illustrates the different value states of the sap.m.MultiInput control.`.
    temp7-app = `z2ui5_cl_demo_app_267`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `NewsContent`.
    temp7-sub = `This control is used to display the news content text and subheader in a tile.`.
    temp7-app = `z2ui5_cl_demo_app_261`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `NotificationListItem`.
    temp7-sub = `A list item suitable for showing notifications to the user.`.
    temp7-app = `z2ui5_cl_demo_app_375`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `NumericContent`.
    temp7-sub = `Shows NumericContent including an icon.`.
    temp7-app = `z2ui5_cl_demo_app_263`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `NumericContent`.
    temp7-sub = `Shows NumericContent including numbers, units of measurement, and status arrows ...`.
    temp7-app = `z2ui5_cl_demo_app_262`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `NumericContent`.
    temp7-sub = `This is an example of the NumericContent that contains no margins, so the control is ...`.
    temp7-app = `z2ui5_cl_demo_app_228`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ObjectAttribute`.
    temp7-sub = `This is an example of Object Attribute used inside Table.`.
    temp7-app = `z2ui5_cl_demo_app_302`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ObjectHeader`.
    temp7-sub = `An Object Header can set shape of the image by using 'imageShape' property. The shapes ...`.
    temp7-app = `z2ui5_cl_demo_app_272`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ObjectListItem`.
    temp7-sub = `This sample shows the different states of an Object List Item, which can be set using the ...`.
    temp7-app = `z2ui5_cl_demo_app_290`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ObjectMarker`.
    temp7-sub = `The ObjectMarker is a small building block representing an object by an icon or text and ...`.
    temp7-app = `z2ui5_cl_demo_app_289`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ObjectNumber`.
    temp7-sub = `inside a Table`.
    temp7-app = `z2ui5_cl_demo_app_369`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ObjectStatus`.
    temp7-sub = `The object status is a small building block representing a status with a semantic color.`.
    temp7-app = `z2ui5_cl_demo_app_300`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `OverflowToolbar`.
    temp7-sub = `OverflowToolbar and Toolbar are often used for left/right alignment. This is easily ...`.
    temp7-app = `z2ui5_cl_demo_app_250`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `OverflowToolbar`.
    temp7-sub = `The sap.m.Title control can be used to place a title inside an OverflowToolbar/Toolbar.`.
    temp7-app = `z2ui5_cl_demo_app_217`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Page`.
    temp7-sub = `Each screen of a mobile application is typically represented by a 'Page' consisting of a ...`.
    temp7-app = `z2ui5_cl_demo_app_227`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Page`.
    temp7-sub = `Header, Sub-Header & Footer`.
    temp7-app = `z2ui5_cl_demo_app_366`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Panel`.
    temp7-sub = `Panels are helpful to group custom content. They can be decorated with header and info ...`.
    temp7-app = `z2ui5_cl_demo_app_378`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ProgressIndicator`.
    temp7-sub = `Shows the progress of a process in a graphical way. To indicate the progress, the inside ...`.
    temp7-app = `z2ui5_cl_demo_app_022`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `RadioButton`.
    temp7-sub = `Typically the Radio Button is used by other controls. E.g. the List uses it for the ...`.
    temp7-app = `z2ui5_cl_demo_app_207`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `RadioButtonGroup`.
    temp7-sub = `A wrapper for a group of radio buttons.`.
    temp7-app = `z2ui5_cl_demo_app_208`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `RangeSlider`.
    temp7-sub = ``.
    temp7-app = `z2ui5_cl_demo_app_005`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `RatingIndicator`.
    temp7-sub = `A Rating Indicator can be used to both indicate and/or rate content.`.
    temp7-app = `z2ui5_cl_demo_app_220`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `SearchField`.
    temp7-sub = `Use the Search Field to let the user enter a search string and trigger the search process.`.
    temp7-app = `z2ui5_cl_demo_app_296`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `SegmentedButton`.
    temp7-sub = `Segmented Button used in Input List Item component`.
    temp7-app = `z2ui5_cl_demo_app_230`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Select`.
    temp7-sub = `Illustrates how the text in items wrap.`.
    temp7-app = `z2ui5_cl_demo_app_299`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Select`.
    temp7-sub = `Illustrates the usage of a Select in header, footer and content of a page. Note the ...`.
    temp7-app = `z2ui5_cl_demo_app_288`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Select`.
    temp7-sub = `Illustrates the usage of a Select with icons`.
    temp7-app = `z2ui5_cl_demo_app_297`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Select`.
    temp7-sub = `Visualizes the validation state of the control, for example, Error, Warning and Success.`.
    temp7-app = `z2ui5_cl_demo_app_298`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Slider`.
    temp7-sub = `With the Slider a user can choose a value from a numerical range.`.
    temp7-app = `z2ui5_cl_demo_app_237`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `SlideTile`.
    temp7-sub = `Shows Generic Tile with the 2x1 frame type displayed as sliding tiles.`.
    temp7-app = `z2ui5_cl_demo_app_274`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `SplitContainer`.
    temp7-sub = `Master & Detail Pages`.
    temp7-app = `z2ui5_cl_demo_app_374`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `StandardListItem`.
    temp7-sub = `This sample demonstrates the wrapping behavior of the title text and the description ...`.
    temp7-app = `z2ui5_cl_demo_app_287`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `StepInput`.
    temp7-sub = `This example shows different StepInput value states.`.
    temp7-app = `z2ui5_cl_demo_app_264`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Switch`.
    temp7-sub = `"Some say it is only a switch, I say it is one of the most stylish controls in the ...`.
    temp7-app = `z2ui5_cl_demo_app_240`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Text`.
    temp7-sub = `The Text control has a property to limit the number of lines for wrapping texts.`.
    temp7-app = `z2ui5_cl_demo_app_206`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Text`.
    temp7-sub = `with class -Standard Margins - Negative Margins`.
    temp7-app = `z2ui5_cl_demo_app_243`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `TextArea`.
    temp7-sub = `Since 1.38 the growing property of sap.m.TextArea gives the ability of a control to ...`.
    temp7-app = `z2ui5_cl_demo_app_236`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `TextArea`.
    temp7-sub = `This sample illustrates the different value states of the sap.m.TextArea control.`.
    temp7-app = `z2ui5_cl_demo_app_234`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `TileContent`.
    temp7-sub = `Shows the universal container for different content types and context information in the ...`.
    temp7-app = `z2ui5_cl_demo_app_241`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `TimePicker`.
    temp7-sub = `Formats & Steps`.
    temp7-app = `z2ui5_cl_demo_app_376`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `ToggleButton`.
    temp7-sub = `Toggle Buttons can be toggled between pressed and normal state.`.
    temp7-app = `z2ui5_cl_demo_app_266`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.m`.
    temp7-header = `Toolbar`.
    temp7-sub = `Toolbar handles overflow by shrinking items. OverflowToolbar provides an overflow menu ...`.
    temp7-app = `z2ui5_cl_demo_app_235`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.uxap`.
    temp7-header = `ObjectPageLayout`.
    temp7-sub = `Object Page sample showing a layout with subsection titles on top. This is the default ...`.
    temp7-app = `z2ui5_cl_demo_app_017`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.uxap`.
    temp7-header = `ObjectPageLayout`.
    temp7-sub = `ObjectPage sample that demonstrates the combination of header facets and showTitle ...`.
    temp7-app = `z2ui5_cl_demo_app_330`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.uxap`.
    temp7-header = `ObjectPageLayout`.
    temp7-sub = `ObjectPage sample with Header Container`.
    temp7-app = `z2ui5_cl_demo_app_303`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.f`.
    temp7-header = `Card`.
    temp7-sub = `This sample illustrates how to specify the predefined header and the content of the Card ...`.
    temp7-app = `z2ui5_cl_demo_app_181`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.f`.
    temp7-header = `DynamicPage`.
    temp7-sub = `Dynamic Page freestyle example with a responsive sap.m.Table in the content area, showing ...`.
    temp7-app = `z2ui5_cl_demo_app_030`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.f`.
    temp7-header = `GridList`.
    temp7-sub = `This sample represents GridList with enabled Drag and Drop functionality.`.
    temp7-app = `z2ui5_cl_demo_app_307`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.core`.
    temp7-header = `HTML`.
    temp7-sub = `With the HTML controls you can easily embed any kind of HTML content into your UI5 mobile ...`.
    temp7-app = `z2ui5_cl_demo_app_242`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.core`.
    temp7-header = `InvisibleText`.
    temp7-sub = `Many controls provide the associations ariaLabelledBy and ariaDescribedBy for ...`.
    temp7-app = `z2ui5_cl_demo_app_282`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.layout`.
    temp7-header = `Grid`.
    temp7-sub = `Split View in different Areas`.
    temp7-app = `z2ui5_cl_demo_app_367`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.layout`.
    temp7-header = `ResponsiveSplitter`.
    temp7-sub = `ResponsiveSplitter is used to visually divide the content of its parent. It consists of ...`.
    temp7-app = `z2ui5_cl_demo_app_103`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.layout`.
    temp7-header = `Splitter`.
    temp7-sub = `Nested Splitter example with 7 content areas`.
    temp7-app = `z2ui5_cl_demo_app_260`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.layout`.
    temp7-header = `Splitter`.
    temp7-sub = `Simple splitter example with three content areas`.
    temp7-app = `z2ui5_cl_demo_app_249`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.layout`.
    temp7-header = `Splitter`.
    temp7-sub = `Simple splitter example with two content areas`.
    temp7-app = `z2ui5_cl_demo_app_247`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.layout`.
    temp7-header = `Splitter`.
    temp7-sub = `Simple splitter example with two content areas that cannot be resized`.
    temp7-app = `z2ui5_cl_demo_app_248`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.tnt`.
    temp7-header = `InfoLabel`.
    temp7-sub = `InfoLabel with all available color schemes`.
    temp7-app = `z2ui5_cl_demo_app_209`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.tnt`.
    temp7-header = `NavigationList`.
    temp7-sub = `simple`.
    temp7-app = `z2ui5_cl_demo_app_258`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.codeeditor`.
    temp7-header = `CodeEditor`.
    temp7-sub = ``.
    temp7-app = `z2ui5_cl_demo_app_265`.
    INSERT temp7 INTO TABLE temp6.
    temp7-group = `controls - sap.ui.unified`.
    temp7-header = `ColorPicker`.
    temp7-sub = ``.
    temp7-app = `z2ui5_cl_demo_app_270`.
    INSERT temp7 INTO TABLE temp6.
    result = temp6.

  ENDMETHOD.


  METHOD block_widths.

    DATA tile LIKE LINE OF t_catalog.
      DATA base TYPE string.
      FIELD-SYMBOLS <block> TYPE z2ui5_cl_demo_app_g00=>ty_s_block.
        DATA temp8 TYPE z2ui5_cl_demo_app_g00=>ty_s_block.
      DATA width TYPE i.
    LOOP AT t_catalog INTO tile.

      
      base = block_base( group  = tile-group
                               header = tile-header ).
      
      READ TABLE result ASSIGNING <block>
        WITH KEY group = tile-group
                 base  = base.

      IF sy-subrc <> 0.
        
        CLEAR temp8.
        temp8-group = tile-group.
        temp8-base = base.
        INSERT temp8 INTO TABLE result ASSIGNING <block>.
      ENDIF.

      
      width = header_width( tile-header ).

      IF width > <block>-width.
        <block>-width = width.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD header_width.

    " estimated render width in 1/100 em, weighted per character class
    DATA off TYPE i.
      DATA char TYPE string.
      DATA temp9 TYPE i.
    off = 0.
    WHILE off < strlen( header ).

      
      char = substring( val = header
                              off = off
                              len = 1 ).
      
      IF char CA `MW`.
        temp9 = 95.
      ELSEIF char CA `mw`.
        temp9 = 80.
      ELSEIF char CA `ijltfrI. -`.
        temp9 = 35.
      ELSEIF char CA `ABCDEFGHJKLNOPQRSTUVXYZ`.
        temp9 = 75.
      ELSE.
        temp9 = 55.
      ENDIF.
      result = result + temp9.
      off = off + 1.

    ENDWHILE.

  ENDMETHOD.


  METHOD header_base.
    TYPES temp1 TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
DATA words TYPE temp1.
    DATA n TYPE i.
    DATA temp10 LIKE LINE OF words.
    DATA temp11 LIKE sy-tabix.
    DATA temp7 LIKE LINE OF words.
    DATA temp8 LIKE sy-tabix.

    result = header.
    

    SPLIT header AT ` ` INTO TABLE words.
    
    n = lines( words ).

    
    
    temp11 = sy-tabix.
    READ TABLE words INDEX n INTO temp10.
    sy-tabix = temp11.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    
    
    temp8 = sy-tabix.
    READ TABLE words INDEX n INTO temp7.
    sy-tabix = temp8.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    IF n > 1 AND temp10 IS NOT INITIAL AND temp7 CO `IVXLCDM`.

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
