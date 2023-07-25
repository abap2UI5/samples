CLASS z2ui5_cl_app_demo_00 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_00 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN OTHERS.
        TRY.
            DATA(lv_classname) = to_upper( client->get( )-event ).
            DATA li_app TYPE REF TO z2ui5_if_app.
            CREATE OBJECT li_app TYPE (lv_classname).
            client->nav_app_call( li_app ).
            RETURN.
          CATCH cx_root.
        ENDTRY.
    ENDCASE.

    DATA(page) = z2ui5_cl_xml_view=>factory( client
        )->shell( )->page(
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

    panel->generictile(
        header    = 'Data Binding'
        subheader = 'Send values to the backend'
        press     = client->_event( 'z2ui5_cl_app_demo_01' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Controller'
        subheader = 'Handle events, change the view & errors'
        press     = client->_event( 'z2ui5_cl_app_demo_04' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Flow Logic'
        subheader = 'Call other apps & exchange data'
        press     = client->_event( 'z2ui5_cl_app_demo_24' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

*    panel->generictile(
*        header    = 'Scrolling & Cursor'
*        subheader = ''
*        press     = client->_event( 'z2ui5_cl_app_demo_22' )
*        mode      = 'LineMode'
*        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
*    ).

    panel->generictile(
        header    = 'Timer'
        subheader = 'Wait n MS and call again the server'
        press     = client->_event( 'z2ui5_cl_app_demo_28' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'New Tab'
        subheader = 'Open an URL in a new tab'
        press     = client->_event( 'z2ui5_cl_app_demo_73' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Expression Binding'
        subheader = 'Use calculations & more functions directly in views'
        press     = client->_event( 'z2ui5_cl_app_demo_27' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Data Types'
        subheader = 'Use of Integer, Decimals, Dates & Time'
        press     = client->_event( 'z2ui5_cl_app_demo_47' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Formatting'
        subheader = 'Currencies'
        press     = client->_event( 'z2ui5_cl_app_demo_67' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).


    panel = page->panel(
        expandable = abap_false
        expanded   = abap_true
        headertext = 'Selection Screen'
   ).

    panel->generictile(
        header    = 'Basic'
        subheader = 'Explore input controls'
        press     =  client->_event( 'z2ui5_cl_app_demo_02' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'More'
        subheader = 'Multi Input, Step Input, Text Are, Range Slider'
        press     =  client->_event( 'z2ui5_cl_app_demo_05' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'F4-Value-Help'
        subheader = 'Popup for value help'
        press     =  client->_event( 'Z2UI5_CL_APP_DEMO_09' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Formatted Text'
        subheader = 'Display HTML'
        press     =  client->_event( 'Z2UI5_CL_APP_DEMO_15' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
          header    = 'Search Field I'
          subheader = 'Filter with enter'
          press     =  client->_event( 'z2ui5_cl_app_demo_53' )
          mode      = 'LineMode'
          class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
      ).

    panel->generictile(
        header    = 'Search Field II'
        subheader = 'Filter with Live Change Event'
        press     =  client->_event( 'z2ui5_cl_app_demo_59' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
     header    = 'Input with Suggestion'
     subheader = 'Read Suggestion Table from the Server'
     press     =  client->_event( 'z2ui5_cl_app_demo_59' )
     mode      = 'LineMode'
     class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
 ).

    panel->generictile(
       header    = 'Select-Options'
       subheader = 'Use multi inputs to create range tables'
       press     =  client->_event( 'z2ui5_cl_app_demo_56' )
       mode      = 'LineMode'
       class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
   ).

    panel = page->panel(
           expandable = abap_false
           expanded   = abap_true
           headertext = `More Controls`
      ).

    panel->generictile(
  header    = 'List I'
  subheader = 'Basic'
  press     =  client->_event( 'z2ui5_cl_app_demo_03' )
  mode      = 'LineMode'
  class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel->generictile(
    header    = 'List II'
    subheader = 'Events & Visualization'
    press     =  client->_event( 'z2ui5_cl_app_demo_48' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).


    panel->generictile(
           header    = 'Tree Table I'
         subheader = 'Basic'
           press     =  client->_event( 'Z2UI5_CL_APP_DEMO_07' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).


    panel->generictile(
        header    = 'Tree Table II'
        subheader = 'Popup Select Entry'
        press     =  client->_event( 'z2ui5_cl_app_demo_68' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
      header    = 'Editor'
       subheader = 'Display files'
      press     =  client->_event( 'z2ui5_cl_app_demo_35' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generictile(
         header    = 'Message I'
      subheader = 'Toast, Box & Strip'
         press     =  client->_event( 'z2ui5_cl_app_demo_08' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generictile(
         header    = 'Message II'
        subheader = 'Illustrated Message'
        press     =  client->_event( 'z2ui5_cl_app_demo_33' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
      header    = 'Message III'
        subheader = 'Message Manager'
      press     =  client->_event( 'z2ui5_cl_app_demo_38' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel = page->panel(
          expandable = abap_false
          expanded   = abap_true
          headertext = `Table`
     ).


    panel->generictile(
        header    = 'Toolbar'
        subheader = 'Add a container & toolbar'
        press     =  client->_event( 'z2ui5_cl_app_demo_06' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Selection Modes'
        subheader = 'Single Select & Multi Select'
        press     =  client->_event( 'Z2UI5_CL_APP_DEMO_19' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Editable'
        subheader = 'Set columns editable'
        press     =  client->_event( 'Z2UI5_CL_APP_DEMO_11' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'Dynamic Types'
         subheader = 'Use RTTI to send tables to the frontend'
         press     =  client->_event( 'Z2UI5_CL_APP_DEMO_61' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generictile(
        header    = 'ui.Table'
        subheader = 'Simple example'
        press     =  client->_event( 'z2ui5_cl_app_demo_70' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).


    panel->generictile(
         header    = 'Object Number and State'
         subheader = 'sap.ui.Table'
         press     =  client->_event( 'z2ui5_cl_app_demo_72' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generictile(
        header    = 'Layout'
        subheader = 'Save your table layout'
        press     =  client->_event( 'z2ui5_cl_app_demo_58' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel = page->panel(
           expandable = abap_false
           expanded   = abap_true
           headertext = `File Import / Export`
      ).

    panel->generictile(
    header    = 'Download CSV'
    subheader = 'Export Table as CSV'
    press     =  client->_event( 'z2ui5_cl_app_demo_57' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel->generictile(
       header    = 'Upload CSV'
       subheader = 'Import CSV as internal Table'
       press     =  client->_event( 'z2ui5_cl_app_demo_74' )
       mode      = 'LineMode'
       class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
   ).

    panel->generictile(
        header    = 'Download XLSX'
        subheader = 'Export Table as XLSX'
        press     =  client->_event( 'z2ui5_cl_app_demo_77' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'File Uploader'
        subheader = 'Upload any file to the Backend'
        press     =  client->_event( 'z2ui5_cl_app_demo_75' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).


    panel = page->panel(
          expandable = abap_false
          expanded   = abap_true
          headertext = `Popup & Popover`
     ).

    panel->generictile(
           header    = 'Popup'
        subheader = 'Simple Example'
           press     =  client->_event( 'Z2UI5_CL_APP_DEMO_21' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).

    panel->generictile(
        header    = 'Flow Logic'
        subheader = 'Different ways of Popup handling'
        press     =  client->_event( 'z2ui5_cl_app_demo_12' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Popover'
        subheader = 'Simple Example'
        press     =  client->_event( 'z2ui5_cl_app_demo_26' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'Popover Item Level'
         subheader = 'Create a Popover for a specific entry of a table'
         press     =  client->_event( 'z2ui5_cl_app_demo_52' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel = page->panel(
          expandable = abap_false
          expanded   = abap_true
          headertext = `Visualization`
     ).

    panel->generictile(
           header    = 'Donut Chart'
*        subheader = 'Use RTTI to send tables to the frontend'
           press     =  client->_event( 'z2ui5_cl_app_demo_13' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).

    panel->generictile(
        header    = 'Line Chart'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_14' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Bar Chart'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_16' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'Radial Chart'
*subheader = 'sap.ui.Table'
         press     =  client->_event( 'z2ui5_cl_app_demo_29' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel->generictile(
            header    = 'Monitor'
*subheader = 'sap.ui.Table'
            press     =  client->_event( 'z2ui5_cl_app_demo_41' )
            mode      = 'LineMode'
            class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
        ).

    panel = page->panel(
       expandable = abap_false
       expanded   = abap_true
       headertext = `Layouts`
  ).

    panel->generictile(
        header    = 'Header, Footer, Grid'
      subheader = 'Split view in different areas'
      press     =  client->_event( 'z2ui5_cl_app_demo_10' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generictile(
        header    = 'Object Page'
         subheader = 'Display object details'
      press     =  client->_event( 'z2ui5_cl_app_demo_17' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generictile(
        header    = 'Dynamic Page'
          subheader = 'Display items'
      press     =  client->_event( 'z2ui5_cl_app_demo_30' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generictile(
        header    = 'Flexible Column Layout'
     subheader = 'Master details with tree'
      press     =  client->_event( 'z2ui5_cl_app_demo_69' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel = page->panel(
            expandable = abap_false
            expanded   = abap_true
            headertext = `Extension`
       ).

    panel->generictile(
           header    = 'Create Views'
           subheader = 'Compare the three ways normal, generic & xml'
           press     =  client->_event( 'z2ui5_cl_app_demo_23' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).


    panel->generictile(
        header    = 'Import View'
         subheader = 'Copy & paste views of the UI5 Documentation'
        press     =  client->_event( 'z2ui5_cl_app_demo_31' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Custom Control'
         subheader = 'Integrate your own JS Custom Control'
        press     =  client->_event( 'z2ui5_cl_app_demo_37' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'Change CSS'
         subheader = 'Send your own CSS to the frontend'
         press     =  client->_event( 'z2ui5_cl_app_demo_50' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generictile(
        header    = 'HTML, JS, CSS'
        subheader = 'Display normal HTML without UI5'
        press     =  client->_event( 'z2ui5_cl_app_demo_32' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Canvas & SVG'
         subheader = 'Integrate more HTML5 functionalities'
        press     =  client->_event( 'z2ui5_cl_app_demo_36' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'ext. Library'
         subheader = 'Load external JS libraries'
         press     =  client->_event( 'z2ui5_cl_app_demo_40' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

    panel = page->panel(
               expandable = abap_false
               expanded   = abap_true
               headertext = `More Features`
          ).

    panel->generictile(
      header    = 'Draft I'
      subheader = 'App remembers at startup values of past inputs'
      press     =  client->_event( 'z2ui5_cl_app_demo_62' )
      mode      = 'LineMode'
      class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
  ).

    panel->generictile(
         header    = 'Draft II'
         subheader = 'Call the same app with different users'
         press     =  client->_event( 'z2ui5_cl_app_demo_63' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generictile(
        header    = 'Nested Views I'
        subheader = 'Basic Example'
        press     =  client->_event( 'z2ui5_cl_app_demo_65' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Nested Views II'
        subheader = 'Master-Detail Page'
        press     =  client->_event( 'z2ui5_cl_app_demo_66' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
             header    = 'Update Model'
          subheader = 'Model only update vs. View rerendering'
           press     =  client->_event( 'z2ui5_cl_app_demo_69' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
