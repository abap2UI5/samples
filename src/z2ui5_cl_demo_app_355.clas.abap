CLASS z2ui5_cl_demo_app_355 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA wlan      TYPE abap_bool.
    DATA flight    TYPE abap_bool.
    DATA high_perf TYPE abap_bool.
    DATA battery   TYPE abap_bool.
    DATA price     TYPE string.
    DATA address   TYPE string.
    DATA country   TYPE string.
    DATA volume    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_355 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      wlan      = abap_true.
      flight    = abap_true.
      high_perf = abap_true.
      price     = `799`.
      address   = `Main Rd, Manchester`.
      country   = `GR`.
      volume    = `7`.
    ENDIF.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->_( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:core`   v = `sap.ui.core` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->_( `Shell` )->_( n = `Page`
        p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                     ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                     ( n = `title`          v = `abap2UI5 - InputListItem` ) ) ).

    page->_( `headerContent`
       )->__( n = `Link`
              p = VALUE #( ( n = `href`   v = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InputListItem/sample/sap.m.sample.InputListItem` )
                           ( n = `target` v = `_blank` )
                           ( n = `text`   v = `UI5 Demo Kit` ) ) ).

    DATA(list) = page->_( n = `List` a = `headerText` v = `Input` ).

    list->_( n = `InputListItem` a = `label` v = `WLAN`
       )->__( n = `Switch` a = `state` v = client->_bind_edit( wlan ) ).

    list->_( n = `InputListItem` a = `label` v = `Flight Mode`
       )->__( n = `CheckBox` a = `selected` v = client->_bind_edit( flight ) ).

    list->_( n = `InputListItem` a = `label` v = `High Performance`
       )->__( n = `RadioButton`
              p = VALUE #( ( n = `groupName` v = `GroupPerf` )
                           ( n = `selected`  v = client->_bind_edit( high_perf ) ) ) ).

    list->_( n = `InputListItem` a = `label` v = `Battery Saving`
       )->__( n = `RadioButton`
              p = VALUE #( ( n = `groupName` v = `GroupPerf` )
                           ( n = `selected`  v = client->_bind_edit( battery ) ) ) ).

    list->_( n = `InputListItem` a = `label` v = `Price (EUR)`
       )->__( n = `Input`
              p = VALUE #( ( n = `placeholder` v = `Price` )
                           ( n = `type`        v = `Number` )
                           ( n = `value`       v = client->_bind_edit( price ) ) ) ).

    list->_( n = `InputListItem` a = `label` v = `Address`
       )->__( n = `Input`
              p = VALUE #( ( n = `placeholder` v = `Address` )
                           ( n = `value`       v = client->_bind_edit( address ) ) ) ).

    list->_( n = `InputListItem` a = `label` v = `Country`
       )->_( n = `Select` a = `selectedKey` v = client->_bind_edit( country )
           )->__( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `GR` ) ( n = `text` v = `Greece` ) )
           )->__( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `MX` ) ( n = `text` v = `Mexico` ) )
           )->__( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `NO` ) ( n = `text` v = `Norway` ) )
           )->__( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `NZ` ) ( n = `text` v = `New Zealand` ) )
           )->__( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `NL` ) ( n = `text` v = `Netherlands` ) ) ).

    list->_( n = `InputListItem` a = `label` v = `Volume`
       )->_( n = `HBox` a = `justifyContent` v = `End`
           )->__( n = `Slider`
                  p = VALUE #( ( n = `max`   v = `10` )
                               ( n = `min`   v = `0` )
                               ( n = `value` v = client->_bind_edit( volume ) )
                               ( n = `width` v = `200px` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
