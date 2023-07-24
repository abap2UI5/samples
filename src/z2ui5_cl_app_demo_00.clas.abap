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
*        class = 'sapUiContentPadding sapUiResponsivePadding--content '
        navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
        shownavbutton = abap_true
        )->header_content(
            )->toolbar_spacer(
*            )->button( text = 'TEST'  press = `MessageToast.show('Selected action is test')`
*            )->button( text = 'TEST2'  press = `URLHelper.triggerTel('01763578')`
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
        header    = 'Communication & Data Binding'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_01' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Events, Error & Change View'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_04' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Flow Logic'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_24' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Scrolling & Cursor'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_22' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Timer'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_28' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Open new tab'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_73' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Expression Binding'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_27' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Integer, Decimals, Dates, Time'
        subheader = ''
        press     = client->_event( 'z2ui5_cl_app_demo_47' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Currency Format'
        subheader = ''
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
        subheader = ''
        press     =  client->_event( 'z2ui5_cl_app_demo_02' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'More Controls'
        subheader = ''
        press     =  client->_event( 'z2ui5_cl_app_demo_05' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'F4-Value-Help'
        subheader = ''
        press     =  client->_event( 'Z2UI5_CL_APP_DEMO_09' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Formatted Text'
        subheader = ''
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
  subheader = ''
  press     =  client->_event( 'z2ui5_cl_app_demo_03' )
  mode      = 'LineMode'
  class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).

    panel->generictile(
    header    = 'List II'
    subheader = ''
    press     =  client->_event( 'z2ui5_cl_app_demo_48' )
    mode      = 'LineMode'
    class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
).


    panel->generictile(
           header    = 'Tree - Simple'
*        subheader = 'Use RTTI to send tables to the frontend'
           press     =  client->_event( 'Z2UI5_CL_APP_DEMO_07' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).


    panel->generictile(
        header    = 'Tree - Popup Select Entry'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_68' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
      header    = 'Editor'
*        subheader = 'sap.ui.Table'
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
        header    = 'Toolbar & Container'
        subheader = ''
        press     =  client->_event( 'z2ui5_cl_app_demo_06' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Selection Modes'
        subheader = ''
        press     =  client->_event( 'Z2UI5_CL_APP_DEMO_19' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Editable'
        subheader = ''
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
        header    = 'Simple'
        subheader = 'sap.ui.Table'
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
        subheader = 'Save table output similiar Fcat'
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
        press     =  client->_event( 'z2ui5_cl_app_demo_71' )
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
         press     =  client->_event( 'z2ui5_cl_app_demo_10' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

       panel->generictile(
           header    = 'Object Page'
         press     =  client->_event( 'z2ui5_cl_app_demo_17' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

       panel->generictile(
           header    = 'Dynamic Page'
         press     =  client->_event( 'z2ui5_cl_app_demo_30' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).

       panel->generictile(
           header    = 'Flexible Column Layout'
        subheader = 'Master Detail with Tree'
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
           header    = 'Views - Normal, Generic, XML'
*        subheader = 'Use RTTI to send tables to the frontend'
           press     =  client->_event( 'z2ui5_cl_app_demo_23' )
           mode      = 'LineMode'
           class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
       ).


    panel->generictile(
        header    = 'Import UI5-XML-View'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_31' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Custom Control'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_37' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'Change CSS'
*subheader = 'sap.ui.Table'
         press     =  client->_event( 'z2ui5_cl_app_demo_50' )
         mode      = 'LineMode'
         class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
     ).


    panel->generictile(
        header    = 'HTML, JS, CSS'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_32' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
        header    = 'Canvas & SVG'
*        subheader = 'sap.ui.Table'
        press     =  client->_event( 'z2ui5_cl_app_demo_36' )
        mode      = 'LineMode'
        class     = 'sapUiTinyMarginEnd sapUiTinyMarginBottom'
    ).

    panel->generictile(
         header    = 'ext. Library'
*subheader = 'sap.ui.Table'
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
