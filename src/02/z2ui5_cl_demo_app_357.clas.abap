CLASS z2ui5_cl_demo_app_357 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
    METHODS add_cell
      IMPORTING
        io_row   TYPE REF TO z2ui5_cl_util_xml
        iv_icon  TYPE string
        iv_title TYPE string
        iv_href  TYPE string
        iv_descr TYPE string
        iv_shade TYPE string.
ENDCLASS.

CLASS z2ui5_cl_demo_app_357 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->__( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:core`   v = `sap.ui.core` )
                     ( n = `xmlns:l`      v = `sap.ui.layout` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->__( `Shell` )->__( n = `Page`
        p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                     ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                     ( n = `title`          v = `abap2UI5 - Controls` ) ) ).

    page->__( `headerContent`
       )->_( n = `Link`
              p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/controls` )
                           ( n = `target` v = `_blank` )
                           ( n = `text`   v = `UI5 Demo Kit` ) ) ).

    DATA(panel) = page->__( n = `Panel`
        p = VALUE #( ( n = `accessibleRole`   v = `Region` )
                     ( n = `backgroundDesign` v = `Transparent` )
                     ( n = `class`            v = `sapUiNoContentPadding` ) ) ).

    panel->__( `headerToolbar` )->__( `Toolbar`
       )->_( n = `Title`
              p = VALUE #( ( n = `level`      v = `H1` )
                           ( n = `text`       v = `Featured Controls` )
                           ( n = `titleStyle` v = `H1` )
                           ( n = `width`      v = `100%` ) ) ).

    DATA(bl)  = panel->__( n = `BlockLayout` ns = `l` ).
    DATA(row) = bl->__( n = `BlockLayoutRow` ns = `l` ).
    add_cell( io_row = row iv_shade = `ShadeA` iv_icon = `sap-icon://edit`         iv_title = `Input`   iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Input`   iv_descr = `User interaction` ).
    add_cell( io_row = row iv_shade = `ShadeB` iv_icon = `sap-icon://list`         iv_title = `Lists`   iv_href = `https://ui5.sap.com/sdk/#/controls/filter/List`    iv_descr = `Various list structures` ).
    add_cell( io_row = row iv_shade = `ShadeC` iv_icon = `sap-icon://table-view`   iv_title = `Tables`  iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Table`   iv_descr = `Simple or more powerful tables` ).
    add_cell( io_row = row iv_shade = `ShadeA` iv_icon = `sap-icon://popup-window` iv_title = `Pop-Ups` iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Popup`   iv_descr = `Dialogs and popovers` ).

    row = bl->__( n = `BlockLayoutRow` ns = `l` ).
    add_cell( io_row = row iv_shade = `ShadeB` iv_icon = `sap-icon://grid`          iv_title = `Tiles`    iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Tile`    iv_descr = `Tiles for e.g. texts, images or charts` ).
    add_cell( io_row = row iv_shade = `ShadeA` iv_icon = `sap-icon://message-popup` iv_title = `Messages` iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Message` iv_descr = `User notification` ).
    add_cell( io_row = row iv_shade = `ShadeB` iv_icon = `sap-icon://header`        iv_title = `Bars`     iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Bar`     iv_descr = `Toolbars and headers` ).
    add_cell( io_row = row iv_shade = `ShadeC` iv_icon = `sap-icon://tree`          iv_title = `Trees`    iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Tree`    iv_descr = `Hierarchical data representation` ).

    panel = page->__( n = `Panel`
        p = VALUE #( ( n = `accessibleRole`   v = `Region` )
                     ( n = `backgroundDesign` v = `Transparent` )
                     ( n = `class`            v = `sapUiNoContentPadding` ) ) ).

    panel->__( `headerToolbar` )->__( `Toolbar`
       )->_( n = `Title`
              p = VALUE #( ( n = `level`      v = `H1` )
                           ( n = `text`       v = `Layout & Pages` )
                           ( n = `titleStyle` v = `H1` )
                           ( n = `width`      v = `100%` ) ) ).

    bl  = panel->__( n = `BlockLayout` ns = `l` ).
    row = bl->__( n = `BlockLayoutRow` ns = `l` ).
    add_cell( io_row = row iv_shade = `ShadeA` iv_icon = `sap-icon://write-new`          iv_title = `Object Page`            iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Object%20Page`             iv_descr = `Displaying, creating, or editing objects` ).
    add_cell( io_row = row iv_shade = `ShadeB` iv_icon = `sap-icon://chart-table-view`   iv_title = `Dynamic Page`           iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Dynamic%20Page`            iv_descr = `Page with title, header, and content area` ).
    add_cell( io_row = row iv_shade = `ShadeC` iv_icon = `sap-icon://screen-split-three` iv_title = `Flexible Column Layout` iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Flexible%20Column%20Layout` iv_descr = `Page with up to 3 columns` ).
    add_cell( io_row = row iv_shade = `ShadeA` iv_icon = `sap-icon://screen-split-one`   iv_title = `Split App`              iv_href = `https://ui5.sap.com/sdk/#/controls/filter/Split%20App`               iv_descr = `Two-column layout` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD add_cell.

    DATA(cell) = io_row->__( n = `BlockLayoutCell` ns = `l`
        p = VALUE #( ( n = `backgroundColorSet`   v = `ColorSet10` )
                     ( n = `backgroundColorShade` v = iv_shade ) ) ).
    DATA(vl) = cell->__( n = `VerticalLayout` ns = `l` ).
    vl->_( n = `Icon` ns = `core`
            p = VALUE #( ( n = `class` v = `sapUiTinyMarginBottom` )
                         ( n = `size`  v = `2rem` )
                         ( n = `src`   v = iv_icon ) )
      )->_( n = `Link`
             p = VALUE #( ( n = `href`   v = iv_href )
                          ( n = `target` v = `_blank` )
                          ( n = `text`   v = iv_title ) )
      )->_( n = `Text` a = `text` v = iv_descr ).

  ENDMETHOD.

ENDCLASS.
