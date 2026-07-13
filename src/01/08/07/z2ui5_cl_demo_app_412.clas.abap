"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeaderContent/sample/sap.uxap.sample.ObjectPageHeaderContentPriorities
"! The sample shows how to set priorities of the ObjectPageHeader content items by using the
"! ObjectPageHeaderContentLayoutData element
CLASS z2ui5_cl_demo_app_412 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS block_display
      IMPORTING
        blocks TYPE REF TO z2ui5_cl_xml_view.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_412 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Page Header Content Priorities`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageHeaderContent/sample/sap.uxap.sample.ObjectPageHeaderContentPriorities` ).

    DATA(object_page) = page->object_page_layout( showtitleinheadercontent = abap_true
                                                  uppercaseanchorbar       = abap_false ).

    DATA(header_title) = object_page->header_title( )->object_page_dyn_header_title( ).

    header_title->expanded_heading(
        )->title( text     = `Denise Smith`
                  wrapping = abap_true ).

    " sap.m.Avatar of the original snapped heading omitted - the control was only introduced with UI5 1.73
    header_title->snapped_heading(
        )->flex_box( fitcontainer = abap_true
                     alignitems   = `Center`
            )->title( text     = `Denise Smith`
                      wrapping = abap_true ).

    header_title->expanded_content( `uxap` )->text( `Senior Developer` ).
    header_title->snapped_content( `uxap` )->text( `Senior Developer` ).
    header_title->snapped_title_on_mobile( )->title( `Senior Developer` ).

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

    " sap.m.Avatar of the original header content omitted - the control was only introduced with UI5 1.73
    DATA(header_content) = object_page->header_content( `uxap`
        )->flex_box( wrap = `Wrap` ).

    header_content->vertical_layout( class = `sapUiSmallMarginBeginEnd`
        )->object_status( title = `User ID`
                          text  = `12345678` )->get_parent(
        )->object_status( title = `Language`
                          text  = `English` )->get_parent(
        )->object_status( title = `Country`
                          text  = `USA` )->get_parent(
        )->object_status( title = `Phone Number`
                          text  = `1-844-726-7733` ).

    header_content->vertical_layout( class = `sapUiSmallMarginBeginEnd`
        )->object_status( title = `Functional Area`
                          text  = `Developement` )->get_parent(
        )->object_status( title = `Cost Center`
                          text  = `PI DFA GD Programs and Product` )->get_parent(
        )->object_status( title = `Email`
                          text  = `email@address.com` ).

    DATA(layout) = header_content->vertical_layout( class = `sapUiSmallMarginBeginEnd` ).

    layout->layout_data( `layout`
        )->_generic( name   = `ObjectPageHeaderLayoutData`
                     ns     = `uxap`
                     t_prop = VALUE #( ( n = `visibleS` v = `false` )
                                       ( n = `visibleM` v = `false` ) ) ).

    layout->object_status( text  = `Senior UI Developer`
                           state = `Success` ).
    layout->rating_indicator( maxvalue = `6`
                              value    = `5`
                              tooltip  = `Rating Tooltip` ).

    DATA(subsections) = object_page->sections(
        )->object_page_section( titleuppercase = abap_false
                                title          = `2014 Goals Plan`
            )->sub_sections( ).

    DO 4 TIMES.
      block_display( subsections->object_page_sub_section( title          = `Goal summary`
                                                           titleuppercase = abap_false
                         )->blocks( ) ).
    ENDDO.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD block_display.

    blocks->simple_form( editable = abap_false
                         layout   = `ColumnLayout`
        )->label( `Evangelize the UI framework across the company`
        )->text( `4 days overdue Cascaded`
        )->label( `Get trained in development management direction`
        )->text( `Due Nov 21`
        )->label( `Mentor junior developers`
        )->text( `Due Dec 31 Cascaded` ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
