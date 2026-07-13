"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageLazyLoadingWithoutBlocks
"! This sample showcases the lazy loading using the stashed property of the ObjectPageLazyLoader.
"! It enables usage of lazy loading without the need to have Blocks
CLASS z2ui5_cl_demo_app_534 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS render_section
      IMPORTING
        sections TYPE REF TO z2ui5_cl_xml_view
        index    TYPE i.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_534 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Page with LazyLoading without blocks`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageLazyLoadingWithoutBlocks` ).

    DATA(object_page_layout) = page->object_page_layout( enablelazyloading  = abap_true
                                                         uppercaseanchorbar = abap_false ).

    DATA(header_title) = object_page_layout->header_title(
        )->object_page_dyn_header_title( ).

    header_title->heading( `uxap`
        )->title( `ObjectPage with LazyLoading without the use of Blocks` ).

    header_title->snapped_title_on_mobile(
        )->title( `ObjectPage with LazyLoading without the use of Blocks` ).

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

    DATA(sections) = object_page_layout->sections( ).

    DO 21 TIMES.
      render_section( sections = sections
                      index    = sy-index ).
    ENDDO.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD render_section.

    " the original binds the form against the demo kit mock model - here the supplier data is hardcoded
    sections->object_page_section( titleuppercase = abap_false
                                   title          = `my section`
        )->sub_sections(
            )->object_page_sub_section( id             = |Section{ index }|
                                        title          = |Section { index }|
                                        mode           = `Expanded`
                                        titleuppercase = abap_false
                )->blocks(
                    )->_generic( name   = `ObjectPageLazyLoader`
                                 ns     = `uxap`
                                 t_prop = VALUE #( ( n = `id`      v = |Section{ index }stashed| )
                                                   ( n = `stashed` v = `true` ) )
                        )->vbox( `sapUiSmallMargin`
                            )->simple_form( title            = `Address`
                                            editable         = abap_false
                                            layout           = `ResponsiveGridLayout`
                                            labelspanl       = `3`
                                            labelspanm       = `3`
                                            emptyspanl       = `4`
                                            emptyspanm       = `4`
                                            columnsl         = `1`
                                            columnsm         = `1`
                                            maxcontainercols = `2`
                                            width            = `auto`
                                            class            = `sapUxAPObjectPageSubSectionAlignContent`
                                )->label( `Name`
                                )->text( `Red Point Stores`
                                )->label( `Street/No.`
                                )->text( `Main St 1618`
                                )->label( `ZIP Code/City`
                                )->text( `31415 Maintown`
                                )->label( `Country`
                                )->text( `Germany` ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
