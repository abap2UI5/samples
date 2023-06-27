CLASS z2ui5_cl_app_demo_00 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS Z2UI5_CL_APP_DEMO_00 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

      WHEN OTHERS.
        TRY.

            DATA(lv_classname) = to_upper( client->get( )-event ).
            DATA li_app TYPE REF TO z2ui5_if_app.
            CREATE OBJECT li_app TYPE (lv_classname).
            client->nav_app_call( li_app ).
            return.
          CATCH cx_root.
        ENDTRY.
    ENDCASE.


    DATA(page) = Z2UI5_CL_XML_VIEW=>factory( client
        )->shell( )->page(
        title = 'abap2UI5 - Demo Section'
        class = 'sapUiContentPadding sapUiResponsivePadding--content '
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton = abap_true
        )->header_content(
            )->toolbar_spacer(
            )->link( text = 'SCN'     target = '_blank' href = 'https://blogs.sap.com/tag/abap2ui5/'
            )->link( text = 'Twitter' target = '_blank' href = 'https://twitter.com/abap2UI5'
            )->link( text = 'GitHub'  target = '_blank' href = 'https://github.com/oblomov-dev/abap2ui5'
        )->get_parent( ).

    DATA(grid) = page->grid( 'L3 M6 S12'
        )->content( 'layout' ).

    grid->simple_form( title = 'HowTo - Basic' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'Communication & Data Binding' press = client->_event( 'z2ui5_cl_app_demo_01' )
        )->button( text = 'Events, Error & Change View'  press = client->_event( 'z2ui5_cl_app_demo_04' )
        )->button( text = 'Flow Logic'                   press = client->_event( 'z2ui5_cl_app_demo_24' )

     ).

    grid->simple_form( title = 'HowTo - Basic II' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'Formatted Text'       press = client->_event( 'Z2UI5_CL_APP_DEMO_15' )
        )->button( text = 'Scrolling & Cursor'   press = client->_event( 'z2ui5_cl_app_demo_22' )
        )->button( text = 'Timer'                press = client->_event( 'z2ui5_cl_app_demo_28' )
    ).

    grid->simple_form( title = 'HowTo - Selection-Screen' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'Basic'           press = client->_event( 'z2ui5_cl_app_demo_02' )
        )->button( text = 'More Controls'   press = client->_event( 'z2ui5_cl_app_demo_05' )
        )->button( text = 'F4-Value-Help'   press = client->_event( 'Z2UI5_CL_APP_DEMO_09' ) ).

    grid->simple_form( title = 'HowTo - Tables I' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'List I'                    press = client->_event( 'z2ui5_cl_app_demo_03' )
        )->button( text = 'List II'                   press = client->_event( 'z2ui5_cl_app_demo_48' )
        )->button( text = 'Toolbar & Container'  press = client->_event( 'z2ui5_cl_app_demo_06' )
    ).

   grid->simple_form( title = 'HowTo - Tables II' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'Selection Modes'           press = client->_event( 'z2ui5_cl_app_demo_19' )
        )->button( text = 'Editable' press = client->_event( 'z2ui5_cl_app_demo_11' )
*        )->button( text = 'Filter'   press = client->_event( 'z2ui5_cl_app_demo_45' )
    ).

    grid->simple_form( title = 'HowTo - Popups' layout = 'ResponsiveGridLayout' )->content( 'form'
          )->button( text = 'Basic'                        press = client->_event( 'Z2UI5_CL_APP_DEMO_21' )
        )->button( text = 'Popups & Flow Logic'           press = client->_event( 'z2ui5_cl_app_demo_12' )

    ).

    grid->simple_form( title = 'HowTo - Popover' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'Basic'             press = client->_event( 'z2ui5_cl_app_demo_26' )
        )->button( text = 'Item Level' press = client->_event( 'z2ui5_cl_app_demo_52' )
    ).

    grid->simple_form( title = 'HowTo - Messages' layout = 'ResponsiveGridLayout' )->content( 'form'
        )->button( text = 'Toast, Box & Strip'   press = client->_event( 'z2ui5_cl_app_demo_08' )
        )->button( text = 'Illustrated Message'  press = client->_event( 'z2ui5_cl_app_demo_33' )
*        )->button( text = 'T100 & bapiret popup' press = client->_event( 'z2ui5_cl_app_demo_34' )
        )->button( text = 'Message Manager'      press = client->_event( 'z2ui5_cl_app_demo_38' )
    ).

    grid->simple_form( title = 'HowTo - Layouts' layout = 'ResponsiveGridLayout' )->content( 'form'
         )->button( text = 'Layout (Header, Footer, Grid)' press = client->_event( 'z2ui5_cl_app_demo_10' )
         )->button( text = 'Object Page' press = client->_event( 'z2ui5_cl_app_demo_17' )
         )->button( text = 'Dynamic Page' press = client->_event( 'z2ui5_cl_app_demo_30' )
*         )->button( text = 'Split App' press = client->_event( 'z2ui5_cl_app_demo_17' )
    ).

    grid->simple_form( title = 'HowTo - Extensions I' layout = 'ResponsiveGridLayout' )->content( 'form'
         )->button( text = 'Views - Normal, Generic, XML' press = client->_event( 'z2ui5_cl_app_demo_23' )
         )->button( text = 'Import UI5-XML-View' press = client->_event( 'z2ui5_cl_app_demo_31' )
         )->button( text = 'Custom Control' press = client->_event( 'z2ui5_cl_app_demo_37' )
         )->button( text = 'Change CSS'              press = client->_event( 'z2ui5_cl_app_demo_50' )
    ).

    grid->simple_form( title = 'HowTo - Extensions II' layout = 'ResponsiveGridLayout' )->content( 'form'
         )->button( text = 'HTML, JS, CSS' press = client->_event( 'z2ui5_cl_app_demo_32' )
         )->button( text = 'Canvas & SVG' press = client->_event( 'z2ui5_cl_app_demo_36' )
         )->button( text = 'ext. Library' press = client->_event( 'z2ui5_cl_app_demo_40' )
    ).

    grid->simple_form( title = 'HowTo - List Report'     layout = 'ResponsiveGridLayout' )->content( 'form'
         )->button( text = 'Search Field' press = client->_event( 'z2ui5_cl_app_demo_53' )
         )->button( text = 'Download CSV' press = client->_event( 'z2ui5_cl_app_demo_57' )
         )->button( text = 'Filter' press = client->_event( 'z2ui5_cl_app_demo_56' )
         )->button( text = 'Layout' press = client->_event( 'z2ui5_cl_app_demo_58' )
    ).

    grid->simple_form( title = 'HowTo - Tree Controls'     layout = 'ResponsiveGridLayout' )->content( 'form'
          )->button( text = 'Simple' press = client->_event( 'z2ui5_cl_app_demo_07' )
    ).

        grid->simple_form( title = 'HowTo - Visualization'     layout = 'ResponsiveGridLayout' )->content( 'form'
          )->button( text = 'Bar Chart' press = client->_event( 'z2ui5_cl_app_demo_16' )
          )->button( text = 'Donut Chart' press = client->_event( 'z2ui5_cl_app_demo_13' )
          )->button( text = 'Line Chart' press = client->_event( 'z2ui5_cl_app_demo_14' )
          )->button( text = 'Radial Chart' press = client->_event( 'z2ui5_cl_app_demo_29' )
    ).

    grid->simple_form( title = 'HowTo - More' layout = 'ResponsiveGridLayout' )->content( 'form'
         )->button( text = 'Side Effects'         press = client->_event( 'z2ui5_cl_app_demo_27' )
         )->button( text = 'Integer, Decimals, Dates, Time' press = client->_event( 'z2ui5_cl_app_demo_47' )
         )->button( text = 'Editor' press = client->_event( 'z2ui5_cl_app_demo_35' )
    ).

       grid->simple_form( title = 'HowTo - More II'     layout = 'ResponsiveGridLayout' )->content( 'form'
         )->button( text = 'App Template' press = client->_event( 'Z2UI5_CL_APP_DEMO_18' )
*         )->button( text = 'Smallest View' press = client->_event( 'Z2UI5_CL_APP_DEMO_44' )
*         )->button( text = 'Layout' press = client->_event( 'z2ui5_cl_app_demo_42' )
*         )->button( text = 'Visualization' press = client->_event( 'z2ui5_cl_app_demo_16' )
    ).






    client->view_display( page->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
