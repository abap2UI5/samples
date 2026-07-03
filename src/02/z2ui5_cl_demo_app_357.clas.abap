CLASS z2ui5_cl_demo_app_357 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS add_cell
      IMPORTING
        row   TYPE REF TO z2ui5_cl_util_xml
        icon  TYPE string
        title TYPE string
        href  TYPE string
        descr TYPE string
        shade TYPE string.

  PRIVATE SECTION.
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

    DATA(page) = root->__( `Shell`
       )->__( n = `Page`
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

    panel->__( `headerToolbar`
       )->__( `Toolbar`
       )->_( n = `Title`
             p = VALUE #( ( n = `level`      v = `H1` )
                          ( n = `text`       v = `Featured Controls` )
                          ( n = `titleStyle` v = `H1` )
                          ( n = `width`      v = `100%` ) ) ).

    DATA(bl)  = panel->__( n = `BlockLayout` ns = `l` ).
    DATA(row) = bl->__( n = `BlockLayoutRow` ns = `l` ).
    add_cell( row = row shade = `ShadeA` icon = `sap-icon://edit`         title = `Input`   href = `https://ui5.sap.com/sdk/#/controls/filter/Input`   descr = `User interaction` ).
    add_cell( row = row shade = `ShadeB` icon = `sap-icon://list`         title = `Lists`   href = `https://ui5.sap.com/sdk/#/controls/filter/List`    descr = `Various list structures` ).
    add_cell( row = row shade = `ShadeC` icon = `sap-icon://table-view`   title = `Tables`  href = `https://ui5.sap.com/sdk/#/controls/filter/Table`   descr = `Simple or more powerful tables` ).
    add_cell( row = row shade = `ShadeA` icon = `sap-icon://popup-window` title = `Pop-Ups` href = `https://ui5.sap.com/sdk/#/controls/filter/Popup`   descr = `Dialogs and popovers` ).

    row = bl->__( n = `BlockLayoutRow` ns = `l` ).
    add_cell( row = row shade = `ShadeB` icon = `sap-icon://grid`          title = `Tiles`    href = `https://ui5.sap.com/sdk/#/controls/filter/Tile`    descr = `Tiles for e.g. texts, images or charts` ).
    add_cell( row = row shade = `ShadeA` icon = `sap-icon://message-popup` title = `Messages` href = `https://ui5.sap.com/sdk/#/controls/filter/Message` descr = `User notification` ).
    add_cell( row = row shade = `ShadeB` icon = `sap-icon://header`        title = `Bars`     href = `https://ui5.sap.com/sdk/#/controls/filter/Bar`     descr = `Toolbars and headers` ).
    add_cell( row = row shade = `ShadeC` icon = `sap-icon://tree`          title = `Trees`    href = `https://ui5.sap.com/sdk/#/controls/filter/Tree`    descr = `Hierarchical data representation` ).

    panel = page->__( n = `Panel`
        p = VALUE #( ( n = `accessibleRole`   v = `Region` )
                     ( n = `backgroundDesign` v = `Transparent` )
                     ( n = `class`            v = `sapUiNoContentPadding` ) ) ).

    panel->__( `headerToolbar`
       )->__( `Toolbar`
       )->_( n = `Title`
             p = VALUE #( ( n = `level`      v = `H1` )
                          ( n = `text`       v = `Layout & Pages` )
                          ( n = `titleStyle` v = `H1` )
                          ( n = `width`      v = `100%` ) ) ).

    bl  = panel->__( n = `BlockLayout` ns = `l` ).
    row = bl->__( n = `BlockLayoutRow` ns = `l` ).
    add_cell( row = row shade = `ShadeA` icon = `sap-icon://write-new`          title = `Object Page`            href = `https://ui5.sap.com/sdk/#/controls/filter/Object%20Page`             descr = `Displaying, creating, or editing objects` ).
    add_cell( row = row shade = `ShadeB` icon = `sap-icon://chart-table-view`   title = `Dynamic Page`           href = `https://ui5.sap.com/sdk/#/controls/filter/Dynamic%20Page`            descr = `Page with title, header, and content area` ).
    add_cell( row = row shade = `ShadeC` icon = `sap-icon://screen-split-three` title = `Flexible Column Layout` href = `https://ui5.sap.com/sdk/#/controls/filter/Flexible%20Column%20Layout` descr = `Page with up to 3 columns` ).
    add_cell( row = row shade = `ShadeA` icon = `sap-icon://screen-split-one`   title = `Split App`              href = `https://ui5.sap.com/sdk/#/controls/filter/Split%20App`               descr = `Two-column layout` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD add_cell.

    DATA(cell) = row->__( n = `BlockLayoutCell` ns = `l`
        p = VALUE #( ( n = `backgroundColorSet`   v = `ColorSet10` )
                     ( n = `backgroundColorShade` v = shade ) ) ).
    DATA(vl) = cell->__( n = `VerticalLayout` ns = `l` ).
    vl->_( n = `Icon` ns = `core`
           p = VALUE #( ( n = `class` v = `sapUiTinyMarginBottom` )
                        ( n = `size`  v = `2rem` )
                        ( n = `src`   v = icon ) )
      )->_( n = `Link`
            p = VALUE #( ( n = `href`   v = href )
                         ( n = `target` v = `_blank` )
                         ( n = `text`   v = title ) )
      )->_( n = `Text` a = `text` v = descr ).

  ENDMETHOD.

ENDCLASS.
