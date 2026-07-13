"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageHeaderExpanded
"! This is an example of an ObjectPage with property alwaysShowContentHeader set to true. In this case
"! the HeaderContent won't snap on a desktop.
CLASS z2ui5_cl_demo_app_533 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS render_goals_section
      IMPORTING
        sections TYPE REF TO z2ui5_cl_xml_view.
    METHODS render_personal_section
      IMPORTING
        sections TYPE REF TO z2ui5_cl_xml_view.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_533 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: ObjectPage with HeaderContent always shown on desktop`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageHeaderExpanded` ).

    DATA(object_page_layout) = page->object_page_layout( preserveheaderstateonscroll = abap_true
                                                         uppercaseanchorbar          = abap_false ).

    DATA(header_title) = object_page_layout->header_title(
        )->object_page_dyn_header_title( ).

    header_title->heading( `uxap`
        )->title( `Denise Smith` ).

    header_title->expanded_content( `uxap`
        )->text( `Example of a ObjectPage with Header Content always shown on desktop` ).

    header_title->snapped_content( `uxap`
        )->text( `Example of a ObjectPage with Header Content always shown on desktop` ).

    header_title->snapped_title_on_mobile(
        )->title( `Example of a ObjectPage with Header Content always shown on desktop` ).

    header_title->actions( `uxap`
        )->button( text = `Edit`
                   type = `Emphasized`
        )->button( type = `Transparent`
                   text = `Delete`
        )->button( type = `Transparent`
                   text = `Copy`
        )->overflow_toolbar_button( icon    = `sap-icon://action`
                                    type    = `Transparent`
                                    text    = `Share`
                                    tooltip = `action` ).

    DATA(flex_box) = object_page_layout->header_content( `uxap`
        )->flex_box( wrap         = `Wrap`
                     fitcontainer = abap_true ).

    flex_box->vertical_layout( class = `sapUiSmallMarginEnd`
        )->object_status( title = `User ID`
                          text  = `12345678`
        )->get_parent(
        )->object_status( title = `Functional Area`
                          text  = `Developement`
        )->get_parent(
        )->object_status( title = `Cost Center`
                          text  = `PI DFA GD Programs and Product`
        )->get_parent(
        )->object_status( title = `Email`
                          text  = `email@address.com` ).

    flex_box->vertical_layout( class = `sapUiSmallMarginBeginEnd`
        )->text( width = `200px`
                 text  = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.` ).

    flex_box->horizontal_layout( class = `sapUiSmallMarginBeginEnd`
        )->object_status( text  = `In Stock`
                          state = `Error`
                          class = `sapUiMediumMarginEnd`
        )->get_parent(
        )->object_status( title = `Label`
                          text  = `In Stock`
                          state = `Warning` ).

    DATA(sections) = object_page_layout->sections( ).

    render_goals_section( sections ).
    render_personal_section( sections ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD render_goals_section.

    " shared block GoalsBlock rebuilt as static form content
    sections->object_page_section( titleuppercase = abap_false
                                   title          = `2014 Goals Plan`
        )->sub_sections(
            )->object_page_sub_section( titleuppercase = abap_false
                )->blocks(
                    )->simple_form( editable = abap_false
                                    layout   = `ColumnLayout`
                        )->label( `Evangelize the UI framework across the company`
                        )->text( `4 days overdue Cascaded`
                        )->label( `Get trained in development management direction`
                        )->text( `Due Nov 21`
                        )->label( `Mentor junior developers`
                        )->text( `Due Dec 31 Cascaded` ).

  ENDMETHOD.


  METHOD render_personal_section.

    DATA(sub_sections) = sections->object_page_section( titleuppercase = abap_false
                                                        title          = `Personal`
        )->sub_sections( ).

    " shared blocks BlockPhoneNumber, BlockSocial, BlockAdresses and BlockMailing rebuilt as static form content
    DATA(connect_blocks) = sub_sections->object_page_sub_section( title          = `Connect`
                                                                  titleuppercase = abap_false
        )->blocks( ).

    connect_blocks->simple_form( editable = abap_false
                                 layout   = `ColumnLayout`
                                 width    = `100%`
        )->title( ns   = `core`
                  text = `Phone Numbers`
        )->label( `Home`
        )->text( `+ 1 415-321-1234`
        )->label( `Office phone`
        )->text( `+ 1 415-321-5555` ).

    connect_blocks->simple_form( editable = abap_false
                                 layout   = `ColumnLayout`
                                 width    = `100%`
        )->title( ns   = `core`
                  text = `Social Accounts`
        )->label( `LinkedIn`
        )->text( `/DeniseSmith`
        )->label( `Twitter`
        )->text( `@DeniseSmith` ).

    connect_blocks->simple_form( editable = abap_false
                                 layout   = `ColumnLayout`
                                 width    = `100%`
        )->title( ns   = `core`
                  text = `Addresses`
        )->label( `Home Address`
        )->text( `2096 Mission Street`
        )->label( `Mailing Address`
        )->text( `PO Box 32114` ).

    connect_blocks->simple_form( editable = abap_false
                                 layout   = `ColumnLayout`
                                 width    = `100%`
        )->title( ns   = `core`
                  text = `Mailing Address`
        )->label( `Work`
        )->text( `DeniseSmith@sap.com` ).

    " shared blocks PersonalBlockPart1 and PersonalBlockPart2 rebuilt as static form content
    DATA(payment) = sub_sections->object_page_sub_section( id             = `paymentSubSection`
                                                           title          = `Payment information`
                                                           titleuppercase = abap_false ).

    payment->blocks(
        )->simple_form( editable = abap_false
                        layout   = `ColumnLayout`
            )->title( ns   = `core`
                      text = `Main Payment Method`
            )->label( `Bank Transfer`
            )->text( `Sparkasse Heimfeld, Germany` ).

    payment->more_blocks(
        )->simple_form( editable = abap_false
                        layout   = `ColumnLayout`
            )->title( ns   = `core`
                      text = `Payment method for Expenses`
            )->label( `Extra Travel Expenses`
            )->text( `Cash 100 USD` ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
