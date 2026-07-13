"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.KPIObjectPageHeader
"! This is an example of an ObjectPageHeader containing mainly KPIs.
CLASS z2ui5_cl_demo_app_529 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_529 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Standard Fiori ObjectPageHeader`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeader/sample/sap.uxap.sample.KPIObjectPageHeader` ).

    DATA(object_page_layout) = page->object_page_layout( uppercaseanchorbar = abap_false ).

    " the tooltips of the original action buttons are not exposed by the wrapper method and left out
    object_page_layout->header_title(
        )->object_page_header( objecttitle    = `Generic T-Shirt Fa, SIZE AS, Colour blau`
                               objectsubtitle = `AAUFSA000100003002` )->get(
            )->actions( `uxap`
                )->object_page_header_action_btn( icon = `sap-icon://action`
                                                  text = `Open in...`
                )->object_page_header_action_btn( icon = `sap-icon://refresh`
                                                  text = `change design` ).

    DATA(header_content) = object_page_layout->header_content( `uxap` ).

    header_content->vertical_layout(
        )->label( `PC, Unrestricted-Use Stock`
        )->object_number( class  = `sapMObjectNumberLarge`
                          number = `219`
                          unit   = `K` ).

    header_content->vertical_layout(
        )->label( `Article Category`
        )->object_attribute( text = `Single Material` ).

    header_content->vertical_layout(
        )->label( `Article Type`
        )->object_attribute( text = `Trading Goods` ).

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
            )->object_page_sub_section( title          = ` `
                                        titleuppercase = abap_false
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
