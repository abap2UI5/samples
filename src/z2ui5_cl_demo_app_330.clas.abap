CLASS z2ui5_cl_demo_app_330 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app.

    DATA mv_check_initialized TYPE abap_bool .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_330 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_object_page_layout) = lo_view->object_page_layout( uppercaseanchorbar = abap_false ).

    DATA(lo_header_title) = lo_object_page_layout->header_title(
        )->object_page_dyn_header_title( ).

    lo_header_title->expanded_heading(
                  )->title( text = `Robot Arm Series 9` ).

    lo_header_title->snapped_heading(
                  )->hbox(
                     )->avatar( src     = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/robot.png`
                           class        = `sapUiMediumMarginEnd`
                           displayshape = `Square`
                     )->vbox(
                        )->title( text = `Robot Arm Series 9`
                        )->label( text = `PO-48865` ).

    lo_header_title->expanded_content( ns = `uxap`
                  )->label( text = `PO-48865` ).

    lo_header_title->snapped_title_on_mobile(
                  )->title( text = `Robot Arm Series 9` ).

    lo_header_title->actions( `uxap`
                  )->button( text = `Edit`
                             type = `Emphasized`
                  )->button( text = `Delete`
                  )->button( text = `Simulate Assembly` ).

    DATA(lo_header_content) = lo_object_page_layout->header_content( ns = `uxap`
                                               )->flex_box( wrap         = `Wrap`
                                                            fitcontainer = abap_true ).

    lo_header_content->avatar( src          = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/robot.png`
                            class        = `sapUiMediumMarginEnd`
                            displayshape = `Square`
                            displaysize  = `L`

                 )->vbox( class = `sapUiLargeMarginEnd sapUiSmallMarginBottom`
                    )->hbox( class      = `sapUiTinyMarginBottom`
                             rendertype = `Bare`
                       )->label( text  = `Manufacturer:`
                                 class = `sapUiTinyMarginEnd`
                       )->text( text = `Robotech`
                    )->get_parent(

                    )->hbox( class      = `sapUiTinyMarginBottom`
                             rendertype = `Bare`
                       )->label( text  = `Factory:`
                                 class = `sapUiTinyMarginEnd`
                       )->text( text = `Orlando, Florida`
                    )->get_parent(

                    )->hbox(
                       )->label( text  = `Supplier:`
                                 class = `sapUiTinyMarginEnd`
                       )->link( text = `Robotech (234242343)`
                    )->get_parent(
                 )->get_parent(

                 )->vbox( class = `sapUiLargeMarginEnd sapUiSmallMarginBottom`
                    )->title( text  = `Status`
                              class = `sapUiTinyMarginBottom`
                    )->object_status( text  = `Delivery`
                                      state = `Success`
                                      class = `sapMObjectStatusLarge`
                    )->get_parent(
                 )->get_parent(

                 )->vbox( class = `sapUiSmallMarginEnd sapUiSmallMarginBottom`
                    )->title( text  = `Delivery Time`
                              class = `sapUiTinyMarginBottom`
                    )->object_status( text  = `12 Days`
                                      icon  = `sap-icon://shipping-status`
                                      class = `sapMObjectStatusLarge`
                    )->get_parent(
                 )->get_parent(

                 )->vbox( class = `sapUiSmallMarginEnd sapUiSmallMarginBottom`
                    )->title( text  = `Assembly Option`
                              class = `sapUiTinyMarginBottom`
                    )->object_status( text  = `To Be Selected`
                                      state = `Error`
                                      class = `sapMObjectStatusLarge`
                    )->get_parent(
                 )->get_parent(

                 )->vbox( class = `sapUiLargeMarginEnd`
                    )->title( text  = `Monthly Leasing Instalment`
                              class = `sapUiTinyMarginBottom`
                    )->object_number( number     = `379.99`
                                      unit       = `USD`
                                      emphasized = abap_false
                                      class      = `sapMObjectNumberLarge`
                    )->get_parent(
                 )->get_parent( ).

    DATA(lo_section) = lo_object_page_layout->sections( ).

    lo_section->object_page_section( titleuppercase = abap_false
                                  title          = `General Information`
             )->sub_sections(
                )->object_page_sub_section( title     = `Order Details`
                                            showtitle = abap_false
                   )->blocks(
                      )->simple_form( class     = `sapUxAPObjectPageSubSectionAlignContent`
                                      layout    = `ColumnLayout`
                                      columnsm  = `2`
                                      columnsl  = `3`
                                      columnsxl = `4`
                                      )->title( ns   = `core`
                                                text = `Order Details`

                                      )->label( text = `Order ID`
                                      )->text( text = `589946637`

                                      )->label( text = `Contract`
                                      )->link( text = `10045876`

                                      )->label( text = `Transaction Date`
                                      )->text( text = `May 6, 2018`

                                      )->label( text = `Expected Delivery Date`
                                      )->text( text = `June 23, 2018`

                                      )->label( text = `Factory`
                                      )->text( text = `Orlando, FL`

                                      )->label( text = `Supplier`
                                      )->text( text = `Robotech`

                                      )->title( ns   = `core`
                                                text = `Configuration Accounts`

                                      )->label( text = `Model`
                                      )->text( text = `Robot Arm Series 9`

                                      )->label( text = `Color`
                                      )->text( text = `White (default)`

                                      )->label( text = `Socket`
                                      )->text( text = `Default Socket 10`

                                      )->label( text = `Leasing Instalment`
                                      )->text( text = `379.99 USD per month`

                                      )->label( text = `Axis`
                                      )->text( text = `6 Axis`
                      )->get_parent(
                   )->get_parent(
                )->get_parent(

                )->object_page_sub_section( title     = `Products`
                                            showtitle = abap_false
                   )->blocks(
                      )->table( class = `sapUxAPObjectPageSubSectionAlignContent`
                                width = `auto`
                         )->header_toolbar(
                            )->overflow_toolbar(
                               )->title( text  = `Products`
                                         level = `H2`
                               )->toolbar_spacer(
                               )->search_field( width = `17.5rem`
                               )->overflow_toolbar_button( tooltip = `Sort`
                                                           text    = `Sort`
                                                           icon    = `sap-icon://sort`
                               )->overflow_toolbar_button( tooltip = `Filter`
                                                           text    = `Filter`
                                                           icon    = `sap-icon://filter`
                               )->overflow_toolbar_button( tooltip = `Group`
                                                           text    = `Group`
                                                           icon    = `sap-icon://group-2`
                               )->overflow_toolbar_button( tooltip = `Settings`
                                                           text    = `Settings`
                                                           icon    = `sap-icon://action-settings`
                            )->get_parent(
                         )->get_parent(

                         )->columns(
                            )->column(
                               )->text( text = `Document Number`
                            )->get_parent(
                            )->column( minscreenwidth = `Tablet`
                                       demandpopin    = abap_true
                               )->text( text = `Company`
                            )->get_parent(
                            )->column( minscreenwidth = `Tablet`
                                       demandpopin    = abap_true
                               )->text( text = `Contact Person`
                            )->get_parent(
                            )->column( minscreenwidth = `Tablet`
                                       demandpopin    = abap_true
                               )->text( text = `Posting Date`
                            )->get_parent(
                            )->column( halign = `End`
                               )->text( text = `Amount (Local Currency)`
                            )->get_parent(
                         )->get_parent(

                         )->items(
                            )->column_list_item(
                               )->link( text = `10223882001820`
                               )->text( text = `Jologa`
                               )->text( text = `Denise Smith`
                               )->text( text = `11/15/19`
                               )->text( text = `12,897.00 EUR`
                            )->get_parent(
                            )->column_list_item(
                               )->link( text = `10223882001820`
                               )->text( text = `Jologa`
                               )->text( text = `Denise Smith`
                               )->text( text = `11/15/19`
                               )->text( text = `12,897.00 EUR`
                            )->get_parent(
                            )->column_list_item(
                               )->link( text = `10223882001820`
                               )->text( text = `Jologa`
                               )->text( text = `Denise Smith`
                               )->text( text = `11/15/19`
                               )->text( text = `12,897.00 EUR`
                            )->get_parent(
                            )->column_list_item(
                               )->link( text = `10223882001820`
                               )->text( text = `Jologa`
                               )->text( text = `Denise Smith`
                               )->text( text = `11/15/19`
                               )->text( text = `12,897.00 EUR`
                            )->get_parent(
                            )->column_list_item(
                               )->link( text = `10223882001820`
                               )->text( text = `Jologa`
                               )->text( text = `Denise Smith`
                               )->text( text = `11/15/19`
                               )->text( text = `12,897.00 EUR`
                            )->get_parent(
                         )->get_parent(
                      )->get_parent(
                   )->get_parent(
                )->get_parent(
             )->get_parent( ).

    lo_section->object_page_section( titleuppercase = abap_false
                                  title          = `Contact Information`
             )->sub_sections(
                )->object_page_sub_section( title = `Contact information`
                   )->blocks(
                      )->simple_form( layout    = `ColumnLayout`
                                      columnsm  = `2`
                                      columnsl  = `3`
                                      columnsxl = `4`
                                      )->title( ns   = `core`
                                                text = `Phone Numbers`

                                      )->label( text = `Home`
                                      )->text( text = `+ 1 415-321-1234`

                                      )->label( text = `Office phone`
                                      )->text( text = `+ 1 415-321-5555`

                                      )->title( ns   = `core`
                                                text = `Social Accounts`

                                      )->label( text = `LinkedIn`
                                      )->text( text = `/DeniseSmith`

                                      )->label( text = `Twitter`
                                      )->text( text = `@DeniseSmith`

                                      )->title( ns   = `core`
                                                text = `Addresses`

                                      )->label( text = `Home Address`
                                      )->text( text = `2096 Mission Street`

                                      )->label( text = `Mailing Address`
                                      )->text( text = `PO Box 32114`

                                      )->title( ns   = `core`
                                                text = `Mailing Address`

                                      )->label( text = `Work`
                                      )->text( text = `DeniseSmith@sap.com`

                      )->get_parent(
                   )->get_parent(
                )->get_parent(
             )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `CLICK_HINT_ICON` ).
      display_popover( `button_hint_id` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `ObjectPage sample that demonstrates the combination of header facets and showTitle properties of sections and subsections.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.
      display_view( mo_client ).

    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
