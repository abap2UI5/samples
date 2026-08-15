" @keywords element binding relative path aggregation dialog row
"! Aggregation binding on a popup via an element bind. The main table is bound
"! to the product aggregation ({/T_PRODUCT}); pressing a row's "components"
"! button opens a popup that uses RELATIVE bindings only ({NAME}, {CATEGORY}, and
"! the nested aggregation {T_ITEM}). Instead of copying the row's data into event
"! args, the app element-binds the whole popup slot to /T_PRODUCT/[index] with
"! client->follow_up_action( cs_event-bind_element, view = cs_view-popup ), so the
"! popup's relative bindings - including its component list's aggregation binding -
"! resolve against the selected product. The row index arrives as the event arg
"! (the pressed control's binding-context path).
CLASS z2ui5_cl_smp_app_470 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        name TYPE string,
        qty  TYPE i,
        unit TYPE string,
      END OF ty_s_item,
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
        price    TYPE string,
        t_item   TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY,
      END OF ty_s_product.
    DATA t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS popup_components
      IMPORTING
        index TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_470 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      t_product = VALUE #(
        ( name = `Notebook 15"` category = `Hardware`    price = `1299`
          t_item = VALUE #( ( name = `SSD 1 TB` qty = 1 unit = `pc` )
                            ( name = `RAM 16 GB` qty = 2 unit = `pc` )
                            ( name = `Charger 90W` qty = 1 unit = `pc` ) ) )
        ( name = `Wireless Mouse` category = `Accessories` price = `39`
          t_item = VALUE #( ( name = `AA Battery` qty = 2 unit = `pc` ) ) )
        ( name = `USB-C Dock` category = `Accessories` price = `189`
          t_item = VALUE #( ( name = `Power Supply` qty = 1 unit = `pc` )
                            ( name = `Cable 1 m` qty = 1 unit = `pc` )
                            ( name = `Quick Guide` qty = 1 unit = `pc` ) ) ) ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `SHOW`.
        popup_components( client->get_event_arg( ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popup - Element Binding to the Selected Row`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The table is bound to the product aggregation. Press a row's "components" button - the ` &&
                   `popup is element-bound to that product, so its relative bindings (incl. the component ` &&
                   `list's aggregation binding) resolve without copying any data into event args.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_product ) ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Product`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Category`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Price`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Components` ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CATEGORY}`
                )->tag( `Text`
                    )->a( n = `text` v = `{PRICE} EUR`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event(
                        val   = `SHOW`
                        t_arg = VALUE #( ( `$event.oSource.getBindingContext().getPath().split('/').pop()` ) ) )
                    )->a( n = `text`  v = `components`
                    )->a( n = `icon`  v = `sap-icon://product` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_components.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).
    DATA(dialog) = popup->ele( `Dialog`
        )->a( n = `title`        v = `{NAME}`
        )->a( n = `contentWidth` v = `24rem` ).

    " relative bindings - resolved by the element bind below
    DATA(box) = dialog->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTop` ).
    box->ele( `ObjectStatus`
        )->a( n = `text`  v = `{CATEGORY}`
        )->a( n = `title` v = `Category` ).
    box->ele( `ObjectStatus`
        )->a( n = `text`  v = `{PRICE} EUR`
        )->a( n = `title` v = `Price` ).

    " the popup's own aggregation binding: the product's component list ({T_ITEM})
    dialog->ele( `List`
        )->a( n = `headerText` v = `Components`
        )->a( n = `items`      v = `{T_ITEM}`
        )->tag( `StandardListItem`
            )->a( n = `title` v = `{NAME}`
            )->a( n = `info`  v = `{QTY} {UNIT}` ).

    dialog->ele( `buttons`
        )->tag( `Button`
            )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )
            )->a( n = `text`  v = `Close`
            )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

    " element-bind the whole popup slot to the selected product, so every relative
    " binding in the popup (and its component list aggregation) resolves against it
    client->follow_up_action(
        val   = client->cs_event-bind_element
        view  = client->cs_view-popup
        t_arg = VALUE #( ( index ) ( client->_bind( t_product ) ) ) ).

  ENDMETHOD.
ENDCLASS.
