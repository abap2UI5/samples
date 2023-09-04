CLASS z2ui5_cl_demo_app_000 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mt_scroll TYPE z2ui5_if_client=>ty_t_name_value_int.

ENDCLASS.



CLASS z2ui5_cl_demo_app_000 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->get( )-check_on_navigated = abap_true.
      IF mt_scroll IS INITIAL.
        mt_scroll = VALUE #( ( n = `page` ) ).
      ENDIF.
      client->scroll_position_set( mt_scroll ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN OTHERS.
        TRY.
            DATA(lv_classname) = to_upper( client->get( )-event ).
            DATA li_app TYPE REF TO z2ui5_if_app.
            CREATE OBJECT li_app TYPE (lv_classname).
            client->nav_app_call( li_app ).
            mt_scroll = client->get( )-t_scroll_pos.
            RETURN.
          CATCH cx_root.
        ENDTRY.
    ENDCASE.

    DATA(page) = z2ui5_cl_xml_view=>factory( client
        )->shell( )->page(
        id = `page`
        title = 'abap2UI5 - Samples'
        navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
        shownavbutton = abap_true
        )->header_content(
            )->toolbar_spacer(
            )->link( text = 'SCN'     target = '_blank' href = 'https://blogs.sap.com/tag/abap2ui5/'
            )->link( text = 'Twitter' target = '_blank' href = 'https://twitter.com/abap2UI5'
            )->link( text = 'GitHub'  target = '_blank' href = 'https://github.com/oblomov-dev/abap2ui5'
        )->get_parent( ).

    page = page->grid( 'L12 M12 S12'
         )->content( 'layout' ).

    page->formatted_text(
`<p><strong>Explore and copy code samples!</strong> All samples are abap2UI5 implementations of the <a href="https://sapui5.hana.ondemand.com/#/controls" style="color:blue; font-weight:600;">SAP UI5 sample page.</a> If you miss a control create an i` &&
`ssue or send a PR` &&
`.</p>` ).

    DATA(panel) = page->panel(
         expandable = abap_false
         expanded   = abap_true
         headertext = `General`
    ).

    panel->generic_tile(
        header    = 'Data Binding'
        subheader = 'Send values to the backend'
        press     = client->_event( 'z2ui5_cl_demo_app_001' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Controller'
        subheader = 'Handle events & change the view'
        press     = client->_event( 'z2ui5_cl_demo_app_004' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Flow Logic'
        subheader = 'Call other apps & exchange data'
        press     = client->_event( 'z2ui5_cl_demo_app_024' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

*    panel->generic_tile(
*        header    = 'Scrolling & Cursor'
*        subheader = ''
*        press     = client->_event( 'z2ui5_cl_demo_app_022' )
*        mode      = 'LineMode'
*        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
*    ).

    panel->generic_tile(
        header    = 'Timer'
        subheader = 'Wait n MS and call again the server'
        press     = client->_event( 'z2ui5_cl_demo_app_028' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'New Tab'
        subheader = 'Open an URL in a new tab'
        press     = client->_event( 'z2ui5_cl_demo_app_073' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Expression Binding'
        subheader = 'Use calculations & more functions directly in views'
        press     = client->_event( 'z2ui5_cl_demo_app_027' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Data Types'
        subheader = 'Use of Integer, Decimals, Dates & Time'
        press     = client->_event( 'z2ui5_cl_demo_app_047' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Formatting'
        subheader = 'Currencies'
        press     = client->_event( 'z2ui5_cl_demo_app_067' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Scrolling'
        press     = client->_event( 'z2ui5_cl_demo_app_022' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Input Validation'
        subheader = `Message Manager`
        press     = client->_event( 'z2ui5_cl_demo_app_084' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel = page->panel(
        expandable = abap_false
        expanded   = abap_true
        headertext = 'Selection Screen'
   ).

    panel->generic_tile(
        header    = 'Basic'
        subheader = 'Explore input controls'
        press     =  client->_event( 'z2ui5_cl_demo_app_002' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'More'
        subheader = 'Multi Input, Step Input, Text Are, Range Slider'
        press     =  client->_event( 'z2ui5_cl_demo_app_005' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
       header    = 'Label'
       press     =  client->_event( 'Z2UI5_cl_demo_app_051' )
       mode      = 'LineMode'
       class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
   ).

    panel->generic_tile(
        header    = 'F4-Value-Help'
        subheader = 'Popup for value help'
        press     =  client->_event( 'Z2UI5_cl_demo_app_009' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Formatted Text'
        subheader = 'Display HTML'
        press     =  client->_event( 'Z2UI5_cl_demo_app_015' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
          header    = 'Search Field I'
          subheader = 'Filter with enter'
          press     =  client->_event( 'z2ui5_cl_demo_app_053' )
          mode      = 'LineMode'
          class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
      ).

    panel->generic_tile(
        header    = 'Search Field II'
        subheader = 'Filter with Live Change Event'
        press     =  client->_event( 'z2ui5_cl_demo_app_059' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
     header    = 'Input with Filter'
     subheader = 'Filter Table on the Server'
     press     =  client->_event( 'z2ui5_cl_demo_app_059' )
     mode      = 'LineMode'
     class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
 ).

    panel->generic_tile(
     header    = 'Input with Suggestion'
     subheader = 'Create Suggestion Table on the Server'
     press     =  client->_event( 'z2ui5_cl_demo_app_060' )
     mode      = 'LineMode'
     class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
 ).

    panel->generic_tile(
      header    = 'Multi Input'
      subheader = ''
      press     =  client->_event( 'z2ui5_cl_demo_app_078' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).


    panel->generic_tile(
       header    = 'Select-Options'
       subheader = 'Use multi inputs to create range tables'
       press     =  client->_event( 'z2ui5_cl_demo_app_056' )
       mode      = 'LineMode'
       class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
   ).

    panel = page->panel(
           expandable = abap_false
           expanded   = abap_true
           headertext = `More Controls`
      ).

    panel->generic_tile(
  header    = 'List I'
  subheader = 'Basic'
  press     =  client->_event( 'z2ui5_cl_demo_app_003' )
  mode      = 'LineMode'
  class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel->generic_tile(
    header    = 'List II'
    subheader = 'Events & Visualization'
    press     =  client->_event( 'z2ui5_cl_demo_app_048' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).


    panel->generic_tile(
           header    = 'Tree Table I'
         subheader = 'Basic'
           press     =  client->_event( 'Z2UI5_cl_demo_app_007' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).


    panel->generic_tile(
        header    = 'Tree Table II'
        subheader = 'Popup Select Entry'
        press     =  client->_event( 'z2ui5_cl_demo_app_068' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
      header    = 'Editor'
       subheader = 'Display files'
      press     =  client->_event( 'z2ui5_cl_demo_app_035' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generic_tile(
         header    = 'Message I'
      subheader = 'Toast, Box & Strip'
         press     =  client->_event( 'z2ui5_cl_demo_app_008' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generic_tile(
         header    = 'Message II'
        subheader = 'Illustrated Message'
        press     =  client->_event( 'z2ui5_cl_demo_app_033' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
      header    = 'Message III'
        subheader = 'Message Manager'
      press     =  client->_event( 'z2ui5_cl_demo_app_038' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).


      panel->generic_tile(
      header    = 'Feed Input'
      press     =  client->_event( 'z2ui5_cl_demo_app_0101' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel = page->panel(
          expandable = abap_false
          expanded   = abap_true
          headertext = `Table`
     ).

    panel->generic_tile(
        header    = 'Toolbar'
        subheader = 'Add a container & toolbar'
        press     =  client->_event( 'z2ui5_cl_demo_app_006' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Selection Modes'
        subheader = 'Single Select & Multi Select'
        press     =  client->_event( 'Z2UI5_cl_demo_app_019' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Editable'
        subheader = 'Set columns editable'
        press     =  client->_event( 'Z2UI5_cl_demo_app_011' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
         header    = 'Dynamic Types'
         subheader = 'Use RTTI to send tables to the frontend'
         press     =  client->_event( 'Z2UI5_cl_demo_app_061' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generic_tile(
         header    = 'Visualization'
         subheader = 'Object Number, Object States & Tab Filter'
         press     =  client->_event( 'z2ui5_cl_demo_app_072' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generic_tile(
        header    = 'Layout'
        subheader = 'Save your table layout'
        press     =  client->_event( 'z2ui5_cl_demo_app_058' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'ui.Table'
        subheader = 'Simple example'
        press     =  client->_event( 'z2ui5_cl_demo_app_070' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel = page->panel(
           expandable = abap_false
           expanded   = abap_true
           headertext = `File Import / Export`
      ).

    panel->generic_tile(
    header    = 'Download CSV'
    subheader = 'Export Table as CSV'
    press     =  client->_event( 'z2ui5_cl_demo_app_057' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel->generic_tile(
       header    = 'Upload CSV'
       subheader = 'Import CSV as internal Table'
       press     =  client->_event( 'z2ui5_cl_demo_app_074' )
       mode      = 'LineMode'
       class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
   ).

    panel->generic_tile(
        header    = 'Download XLSX'
        subheader = 'Export Table as XLSX'
        press     =  client->_event( 'z2ui5_cl_demo_app_077' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'File Uploader'
        subheader = 'Upload any file to the Backend'
        press     =  client->_event( 'z2ui5_cl_demo_app_075' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).


    panel->generic_tile(
        header    = 'PDF Viewer'
        subheader = 'Display PDFs via iframe'
        press     =  client->_event( 'z2ui5_cl_demo_app_079' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel = page->panel(
          expandable = abap_false
          expanded   = abap_true
          headertext = `Popup & Popover`
     ).

    panel->generic_tile(
           header    = 'Popup'
        subheader = 'Simple Example'
           press     =  client->_event( 'Z2UI5_cl_demo_app_021' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).

    panel->generic_tile(
        header    = 'Flow Logic'
        subheader = 'Different ways of Popup handling'
        press     =  client->_event( 'z2ui5_cl_demo_app_012' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Popover'
        subheader = 'Simple Example'
        press     =  client->_event( 'z2ui5_cl_demo_app_026' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
         header    = 'Popover Item Level'
         subheader = 'Create a Popover for a specific entry of a table'
         press     =  client->_event( 'z2ui5_cl_demo_app_052' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generic_tile(
         header    = 'Popover with List'
         subheader = 'List to select in Popover'
         press     =  client->_event( 'z2ui5_cl_demo_app_081' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generic_tile(
         header    = 'Table Select Dialog'
         subheader = 'Popup for F4 Helps'
         press     =  client->_event( 'z2ui5_cl_demo_app_087' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generic_tile(
    header    = 'p13n Dialog'
    subheader = 'Popup for F4 Helps'
    press     =  client->_event( 'z2ui5_cl_demo_app_090' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel = page->panel(
          expandable = abap_false
          expanded   = abap_true
          headertext = `Visualization`
     ).

    panel->generic_tile(
           header    = 'Donut Chart'
*        subheader = 'Use RTTI to send tables to the frontend'
           press     =  client->_event( 'z2ui5_cl_demo_app_013' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).

    panel->generic_tile(
        header    = 'Line Chart'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_demo_app_014' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Bar Chart'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_demo_app_016' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
         header    = 'Radial Chart'
*subheader = 'sap.ui.Table'
         press     =  client->_event( 'z2ui5_cl_demo_app_029' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generic_tile(
            header    = 'Monitor'
*subheader = 'sap.ui.Table'
            press     =  client->_event( 'z2ui5_cl_demo_app_041' )
            mode      = 'LineMode'
            class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
        ).

    panel->generic_tile(
        header    = 'Gantt Chart'
        press     =  client->_event( 'z2ui5_cl_demo_app_076' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Planning Calender'
        press     =  client->_event( 'z2ui5_cl_demo_app_080' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
    header    = 'Process Flow'
    press     =  client->_event( 'z2ui5_cl_demo_app_091' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel = page->panel(
       expandable = abap_false
       expanded   = abap_true
       headertext = `Layouts`
  ).

    panel->generic_tile(
        header    = 'Header, Footer, Grid'
      subheader = 'Split view in different areas'
      press     =  client->_event( 'z2ui5_cl_demo_app_010' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generic_tile(
        header    = 'Object Page'
         subheader = 'Display object details'
      press     =  client->_event( 'z2ui5_cl_demo_app_017' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generic_tile(
        header    = 'Dynamic Page'
        subheader = 'Display items'
        press     =  client->_event( 'z2ui5_cl_demo_app_030' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Flexible Column Layout'
        subheader = 'Master details with tree'
        press     =  client->_event( 'z2ui5_cl_demo_app_069' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generic_tile(
        header    = 'Splitting Container'
        press     =  client->_event( 'Z2UI5_cl_demo_app_0103' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).



    panel = page->panel(
            expandable = abap_false
            expanded   = abap_true
            headertext = `Extensions`
       ).

    panel->generic_tile(
           header    = 'Create Views'
           subheader = 'Compare the three ways normal, generic & xml'
           press     =  client->_event( 'z2ui5_cl_demo_app_023' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).


    panel->generic_tile(
        header    = 'Import View'
         subheader = 'Copy & paste views of the UI5 Documentation'
        press     =  client->_event( 'z2ui5_cl_demo_app_031' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Custom Control'
         subheader = 'Integrate your own JS Custom Control'
        press     =  client->_event( 'z2ui5_cl_demo_app_037' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
         header    = 'Change CSS'
         subheader = 'Send your own CSS to the frontend'
         press     =  client->_event( 'z2ui5_cl_demo_app_050' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generic_tile(
        header    = 'HTML, JS, CSS'
        subheader = 'Display normal HTML without UI5'
        press     =  client->_event( 'z2ui5_cl_demo_app_032' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Canvas & SVG'
         subheader = 'Integrate more HTML5 functionalities'
        press     =  client->_event( 'z2ui5_cl_demo_app_036' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
         header    = 'Ext. Library'
         subheader = 'Load external JS libraries'
         press     =  client->_event( 'z2ui5_cl_demo_app_040' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel = page->panel(
               expandable = abap_false
               expanded   = abap_true
               headertext = `Partial Rerendering`
          ).

    panel->generic_tile(
        header    = 'Nested Views I'
        subheader = 'Basic Example'
        press     =  client->_event( 'z2ui5_cl_demo_app_065' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Nested Views II'
        subheader = 'Master-Detail Page'
        press     =  client->_event( 'z2ui5_cl_demo_app_066' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

        panel->generic_tile(
        header    = 'Nested Views III'
        subheader = 'Head & Item Table'
        press     =  client->_event( 'z2ui5_cl_demo_app_097' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

        panel->generic_tile(
        header    = 'Nav Container I'
        press     =  client->_event( 'z2ui5_cl_demo_app_088' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generic_tile(
        header    = 'Nav Container II'
        press     =  client->_event( 'z2ui5_cl_demo_app_089' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel = page->panel(
               expandable = abap_false
               expanded   = abap_true
               headertext = `Features`
          ).

    panel->generic_tile(
      header    = 'Draft I'
      subheader = 'App remembers at startup values of past inputs'
      press     =  client->_event( 'z2ui5_cl_demo_app_062' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generic_tile(
         header    = 'Draft II'
         subheader = 'Call the same app with different users'
         press     =  client->_event( 'z2ui5_cl_demo_app_063' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generic_tile(
       header    = 'Smallest App'
    subheader = 'Demo'
     press     =  client->_event( 'z2ui5_cl_demo_app_044' )
     mode      = 'LineMode'
     class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
 ).

     panel->generic_tile(
       header    = 'Main App with Sub App'
     press     =  client->_event( 'z2ui5_cl_demo_app_095' )
     mode      = 'LineMode'
     class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
 ).

    panel = page->panel(
               expandable = abap_false
               expanded   = abap_true
               headertext = `Demos`
          ).

    panel->generic_tile(
        header    = 'Demo I'
        subheader = 'Nested View, Object Page, App Navigation, Tables, Lists, Images, Progress & Rating Indicator'
        press     =  client->_event( 'z2ui5_cl_demo_app_085' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
