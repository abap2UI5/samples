CLASS z2ui5_cl_demo_app_999 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF ms_check_expanded,
        getting_started TYPE abap_bool,
        binding         TYPE abap_bool,
        events          TYPE abap_bool,
        input           TYPE abap_bool,
        display         TYPE abap_bool,
        layouts         TYPE abap_bool,
        popups          TYPE abap_bool,
        files           TYPE abap_bool,
        advanced        TYPE abap_bool,
        experimental    TYPE abap_bool,
      END OF ms_check_expanded.

    METHODS expand_all.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_999 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    CONSTANTS c_title TYPE string VALUE `abap2UI5 - Samples (new structure)`.

    CASE client->get( )-event.
      WHEN `expand-all`.
        expand_all( ).
      WHEN `collapse-all`.
        ms_check_expanded = VALUE #( ).
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

    DATA(page) = z2ui5_cl_xml_view=>factory(
        )->shell( )->page( id             = `page`
                           title          = c_title
                           navbuttonpress = client->_event_nav_app_leave( )
                           shownavbutton  = client->check_app_prev_stack( )
        )->header_content(
            )->toolbar_spacer(
            )->link( text   = `Install with abapGit from GitHub`
                     target = `_blank`
                     href   = `https://github.com/abap2UI5/samples`
        )->get_parent( ).

    page->formatted_text(
        `<p><strong>Reorganized launchpad — try this new structure.</strong> Samples are grouped by purpose ` &&
        `(getting started → binding → events → controls → ...). ` &&
        `Click any tile to open the sample. The original launchpad remains available at z2ui5_cl_demo_app_000.</p>` ).

    page->hbox(
       )->button( press = client->_event( `expand-all` )
                  icon  = `sap-icon://expand-all`
       )->button( press = client->_event( `collapse-all` )
                  icon  = `sap-icon://collapse-all` ).

    DATA(page2) = page.
    DATA panel TYPE REF TO z2ui5_cl_xml_view.

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-getting_started )
                         headertext = `1. Getting Started` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Hello World / Basics` ).

    panel->generic_tile( header    = `basic example`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_001` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - controller`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_004` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - layout`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_010` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `demo - template`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_018` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - flow logic`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_024` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `demo - smallest app`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_044` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Lifecycle` ).

    panel->generic_tile( header    = `basic - flow logic (called)`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_025` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Demos & Templates` ).

    panel->generic_tile( header    = `demo 01`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_104` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-binding )
                         headertext = `2. Data Binding` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Binding` ).

    panel->generic_tile( header    = `more - expression binding`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_027` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `binding - normal, deep, refs`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_094` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `binding - subapp main`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_095` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `binding - subapp sub`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_096` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `data binding tables with invalid date and time`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_118` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `binding - table cell level`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_144` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `binding`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_153` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `binding - struc component level`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_166` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Struc with Cell Binding`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_332` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Check throw error when ref used for binding`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_343` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Refs / Deep Structures` ).

    panel->generic_tile( header    = `Deep Structure Sub App`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_191` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Deep Structure Main App`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_195` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Type Ref to Data Table with refresh`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_199` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - With Data Refs`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_336` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-events )
                         headertext = `3. Events & Navigation` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Events` ).

    panel->generic_tile( header    = `ui table - event handling cell level`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_160` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `event - add info with t_arg`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_167` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Model Update` ).

    panel->generic_tile( header    = `ui - model update`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_049` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Navigation` ).

    panel->generic_tile( header    = `basic - history`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_139` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Navigation Examples`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_255` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Side Navigation Demo`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_258` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Data loss protection`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_279` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Navigation - app state`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_321` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Navigation - push state`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_322` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Navigation - app state share`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_323` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Navigation with app state change v1`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_350` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Browser Actions` ).

    panel->generic_tile( header    = `basic - timer`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_028` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `setSizeLimit`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_071` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `functions - open new tab`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_073` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `cc - timer`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_121` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - set title`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_125` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `timer and popover`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_129` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic focus`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_133` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic scroll`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_134` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `focus`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_189` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `URL Helper`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_316` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `clipboard feature`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_325` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Store data inside localStorage or sessionStorage`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_327` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Softkeyboard on/off`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_352` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Multiple Timers`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_353` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-input )
                         headertext = `4. Input Controls` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Text & Numbers` ).

    panel->generic_tile( header    = `control - Text Area`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_021` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - feed input`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_101` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `mask input`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_110` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - feed input`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_114` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_input_value`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_156` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Input - Types`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_210` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Input - Password`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_213` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Input List Item`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_219` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Segmented Button in Input List Item`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_230` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `TextArea - Value States`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_234` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Text Area - Growing`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_236` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Input Suggestions Wrapping`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_246` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Input - Description`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_251` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Feed Input`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_283` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Date & Time` ).

    panel->generic_tile( header    = `Demo for DateRangeSelection`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_231` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Date Picker - Value States`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_294` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Date Range Selection - Value States`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_295` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Selection` ).

    panel->generic_tile( header    = `Selectoptions`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_130` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - multi combo box`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_140` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ComboBox - Suggestions wrapping`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_229` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `MultiInput - Suggestions wrapping`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_232` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `MultiComboBox - Suggestions wrapping`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_233` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `MultiInput - Value States`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_267` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Select`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_288` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Select - Validation states`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_298` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Select - Wrapping text`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_299` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Selection / F4 Help` ).

    panel->generic_tile( header    = `selscreen - basic`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_002` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `selscreen - value help`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_009` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `selscreen - formatted text`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_015` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `selscreen - filter live update`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_059` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `selscreen - select options`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_078` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popups - p13n Dialog`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_090` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `facet filteer`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_197` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Search` ).

    panel->generic_tile( header    = `Search Field`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_296` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Other Input` ).

    panel->generic_tile( header    = `control - range slider`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_005` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `control - Step Input`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_041` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Radio Button`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_207` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Radio Button Group`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_208` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Rating Indicator`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_220` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Slider`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_237` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Check Box`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_239` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Switch`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_240` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Step Input - Value States`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_264` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Toggle Button`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_266` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `color picker`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_270` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Editor` ).

    panel->generic_tile( header    = `more - editor`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_035` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `rich text editor`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_106` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Code Editor`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_265` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Formatting & Conversion` ).

    panel->generic_tile( header    = `more - type conversion`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_047` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - currency format`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_067` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-display )
                         headertext = `5. Display & Data` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Text & Status` ).

    panel->generic_tile( header    = `control - Progress Indicator`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_022` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `control - label`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_051` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `control - Generic Tag`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_062` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `control - Badge`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_063` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `progress indicator while request`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_064` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Text - Max Lines`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_206` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `InfoLabel`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_209` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Busy Indicator`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_215` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Generic Tag with Different Configurations`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_257` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Object Status`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_300` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Expandable Text`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_301` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Tables` ).

    panel->generic_tile( header    = `tab - list`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_003` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - toolbar container sort`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_006` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - editable`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_011` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - selection modes`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_019` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - filter columns`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_045` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab and list change`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_046` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - list2`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_048` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `table - object number`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_072` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `table - import csv`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_074` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - cell copy`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_087` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ui table`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_100` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ui table with filter`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_143` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - toolbar container sort`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_177` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `table columnmenu`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_183` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Object Marker in a table`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_289` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Object Attribute inside Table`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_302` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `table - cell coloring`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_305` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - odata, device, http`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_314` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab -different odata models`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_315` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `List Report` ).

    panel->generic_tile( header    = `list report - cell with popover`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_052` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `list report - search field`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_053` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `list report - download csv`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_057` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `list report - layout`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_058` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `list report - search field`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_070` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `list report - filter`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_083` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Lists` ).

    panel->generic_tile( header    = `popover - list`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_081` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Action List Item`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_216` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Standard List Item - Info State Inverted`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_286` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Standard List Item - Wrapping`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_287` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Object List Item - markers aggregation`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_290` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Grid List with Drag and Drop`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_307` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Trees` ).

    panel->generic_tile( header    = `tree - popup select`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_068` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tree - tree and nested views`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_069` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tree - tree and nested views`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_085` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tree - tree and nested views`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_086` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `networkgraph - org tree`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_182` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Tiles & Cards` ).

    panel->generic_tile( header    = `cards demo`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_181` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Numeric Content Without Margins`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_228` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Tile Content`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_241` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `News Content`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_261` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Numeric Content of Different Colors`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_262` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Numeric Content with Icon`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_263` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Slide Tile`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_274` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Feed Content`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_275` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Monitor Tile`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_276` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `KPI Tile`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_277` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Feed and News Tile`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_278` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Tile Statuses`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_281` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Charts & Visualization` ).

    panel->generic_tile( header    = `visualization - donut chart`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_013` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `visualization - line chart`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_014` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `visualization - bar chart`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_016` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `visualization - radial chart`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_029` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `gantt - test`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_076` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `visualization - process flow`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_091` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `gantt II`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_179` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Harvey Chart`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_308` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `VizFrame Charts`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_312` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Icons` ).

    panel->generic_tile( header    = `Standalone Icon Tab Header`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_214` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon Tab Bar - Icons Only`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_221` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon Tab Bar - Text and Count`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_222` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon Tab Bar - Inline Mode`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_223` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon Tab Bar - Text Only`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_224` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon Tab Bar - Separator`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_225` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon Tab Bar - Sub tabs`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_226` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Icon`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_268` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flexible sizing - Icon Tab Bar`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_285` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Select - with icons`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_297` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Maps` ).

    panel->generic_tile( header    = `more - map container`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_123` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Other Controls` ).

    panel->generic_tile( header    = `more - timeline`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_113` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `status indicator`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_196` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `HTML`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_242` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Button`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_259` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `LightBox`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_273` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `InvisibleText`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_282` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Link`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_293` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Avatar Group`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_320` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-layouts )
                         headertext = `6. Layouts` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Object Page` ).

    panel->generic_tile( header    = `layout - object page`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_017` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `demo - object page`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_042` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Object Page Header with Header Container`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_303` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Dynamic Page` ).

    panel->generic_tile( header    = `layout - dynamic page`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_030` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Flex / Grid` ).

    panel->generic_tile( header    = `Flex Box - Basic Alignment`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_205` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Opposing Alignment`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_218` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Size Adjustments`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_244` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Direction & Order`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_245` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Render Type`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_252` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Equal Height Cols`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_253` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flex Box - Nested`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_254` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Fix Flex - Fix container size`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_256` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Flexible sizing - Toolbar`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_284` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Toolbars` ).

    panel->generic_tile( header    = `Placing a Title in OverflowToolbar/Toolbar`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_217` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Page, Toolbar & Bar`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_227` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Toolbar vs Bar vs OverflowToolbar`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_235` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `OverflowToolbar - Alignment`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_250` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Navigation Layout` ).

    panel->generic_tile( header    = `Side Panel`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_108` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Shell Bar`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_269` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Breadcrumbs sample with current page link`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_292` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `NavContainer` ).

    panel->generic_tile( header    = `more - nav container`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_088` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - nav container in popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_170` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Nested Views` ).

    panel->generic_tile( header    = `nested view - simple`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_065` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `nested view - tables`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_097` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `nested view - level 2`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_098` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App I`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_117` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App I`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_131` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `templating II - nested views`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_176` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App I`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_185` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App Calling App with REF`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_192` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App I`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_211` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Nested Splitter Layouts - 7 Areas`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_260` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App - Main App`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_338` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App - Subapp`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_339` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App - Popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_340` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `App in App - Subapp`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_342` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Templating` ).

    panel->generic_tile( header    = `templating I - basic example`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_173` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Wizard` ).

    panel->generic_tile( header    = `control - wizard`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_175` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `wizard - nextStep & subsequentSteps`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_202` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Other Layouts` ).

    panel->generic_tile( header    = `layout - planing calender`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_080` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - splitting container`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_103` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Negative Margins`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_243` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Splitter Layout - 2 areas`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_247` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Splitter Layout - 2 non-resizable areas`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_248` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Splitter Layout - 3 areas`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_249` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Header Container - Vertical Mode`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_280` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - with many Layouts`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_344` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - with many Layouts`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_345` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-popups )
                         headertext = `7. Popups, Dialogs & Messages` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Popups` ).

    panel->generic_tile( header    = `basic - popups and flow`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_012` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - decide`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_020` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popop_get_range`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_056` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_html`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_149` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_to_confirm`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_150` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_to_inform`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_151` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_to_select`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_152` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_messages`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_154` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_textedit`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_155` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_file_upload`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_157` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_pdf`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_158` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_pdf`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_159` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup to popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_161` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popop_get_range_multi`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_162` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup table`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_164` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_file_download`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_168` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - popup_to_select2`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_174` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popup - messages`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_187` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Catch exceptions and display popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_324` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - popups with ref from prev App`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_328` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Struc with Class Data and Popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_335` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Table with Class Data and Popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_337` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `basic - popups and flow`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_341` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Table with Class Data and Popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_349` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Popovers` ).

    panel->generic_tile( header    = `popups - popover`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_026` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popups - popover Quick Vew`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_109` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `popover - action sheet`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_163` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Built-in Popups` ).

    panel->generic_tile( header    = `view setting dialog`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_099` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Messages` ).

    panel->generic_tile( header    = `messages - basic`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_008` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `messages - illustrated`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_033` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `messages - t100 bapiret`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_034` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `messages - message manager`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_038` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Message Strip`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_238` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Message Strip with enableFormattedText`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_291` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `messages with styles`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_310` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `messages - message manager with style`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_311` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-files )
                         headertext = `8. Files & I/O` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Files & I/O` ).

    panel->generic_tile( header    = `file - upload`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_075` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `file - pdf viewer`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_079` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `download b64`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_186` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ImageContent`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_271` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Object Header - with Circle-shaped Image`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_272` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - html pdf`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_318` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `UploadSet Custom Control Demo`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_354` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-advanced )
                         headertext = `9. Advanced & Extensions` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Dynamic Typing (S-RTTI)` ).

    panel->generic_tile( header    = `more - rtti table`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_061` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI with Struc`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_330` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Struc`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_331` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Struc with Class Data`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_334` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Table with Ref in Object`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_347` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `RTTI - Struc with Ref in Object`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_348` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Device & Browser` ).

    panel->generic_tile( header    = `cc - geoloaction`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_120` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `get - frontend info`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_122` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - ndc scanner`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_124` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ndc - camera`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_306` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    page = page2->panel( expandable = abap_true
                         expanded   = client->_bind_edit( ms_check_expanded-experimental )
                         headertext = `10. Compatibility & Experimental` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Smart Controls & Variants` ).

    panel->generic_tile( header    = `tab -smart controls`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_313` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `odata, smartmultiinput`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_319` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Custom CSS` ).

    panel->generic_tile( header    = `more - css`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_050` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Internal / Testing` ).

    panel->generic_tile( header    = `extension - import xml view`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_031` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `extension - import xml view 2`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_039` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `test - speed`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_082` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `view - new parser with cc`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_136` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `unit test - long variable`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_138` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Generic XML Builder (pkg 02)` ).

    panel->generic_tile( header    = `more - InputListItem Sample`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_355` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - Label Sample`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_356` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - Controls Overview`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_357` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - Table`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_358` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - Expression Binding`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_359` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - Formatter`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_360` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `more - System Logout`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_361` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Launchpad — Learning Path (pkg 01)` ).

    panel->generic_tile( header    = `launchpad I - Startup Parameters`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_LP_01` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `launchpad II - Set Title`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_LP_02` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Launchpad III - cross app navigation I`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_LP_03` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Launchpad IV - cross app navigation II`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_LP_04` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Non-Cloud only (pkg 00)` ).

    panel->generic_tile( header    = `Sticky session with locking`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_S_01` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `stateful session`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_S_02` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Play Sound`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_S_03` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Conversion Exits`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_S_04` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `News Feed over Websocket`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_S_05` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Navigation with app state change v2`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_S_06` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel = page->panel( expandable = abap_false
                         expanded   = abap_true
                         headertext = `Native JS — experimental (pkg 03)` ).

    panel->generic_tile( header    = `extension - html css js`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_032` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `extension - canvas and svg`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_036` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `extension - custom control`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_037` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `extension - ext library`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_040` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ui - suggestion`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_060` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `Message Box & Input Functions`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_084` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ext - call custom function`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_093` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `selscreen - filter bar with variant managment WIP`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_111` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tree table - save expand state`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_116` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `custom function in popup`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_141` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ui table - focus handling`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_172` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tree - popup select - state`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_178` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `ui - suggestion with CC filtering`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_201` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `follow_up_action with JS`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_309` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tree - drag & drop`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_317` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    panel->generic_tile( header    = `tab - focus edit controls`
                         subheader = ``
                         press     = client->_event( `Z2UI5_CL_DEMO_APP_346` )
                         mode      = `LineMode`
                         class     = `sapUiTinyMarginEnd sapUiTinyMarginBottom` ).

    client->view_display( page2->stringify( ) ).

  ENDMETHOD.


  METHOD expand_all.

    ms_check_expanded = VALUE #(
        getting_started = abap_true
        binding         = abap_true
        events          = abap_true
        input           = abap_true
        display         = abap_true
        layouts         = abap_true
        popups          = abap_true
        files           = abap_true
        advanced        = abap_true
        experimental    = abap_true ).

  ENDMETHOD.

ENDCLASS.
