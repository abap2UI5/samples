CLASS z2ui5_cl_demo_app_355 DEFINITION PUBLIC.

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
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_355 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    wlan      = abap_true.
    flight    = abap_true.
    high_perf = abap_true.
    price     = `799`.
    address   = `Main Rd, Manchester`.
    country   = `GR`.
    volume    = `7`.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->__( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:core`   v = `sap.ui.core` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->__( `Shell`
       )->__( n = `Page`
              p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                           ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                           ( n = `title`          v = `abap2UI5 - InputListItem` ) ) ).

    page->__( `headerContent`
       )->_( n = `Link`
             p = VALUE #( ( n = `href`   v = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InputListItem/sample/sap.m.sample.InputListItem` )
                          ( n = `target` v = `_blank` )
                          ( n = `text`   v = `UI5 Demo Kit` ) ) ).

    DATA(list) = page->__( n = `List` a = `headerText` v = `Input` ).

    list->__( n = `InputListItem` a = `label` v = `WLAN`
       )->_( n = `Switch` a = `state` v = client->_bind_edit( wlan ) ).

    list->__( n = `InputListItem` a = `label` v = `Flight Mode`
       )->_( n = `CheckBox` a = `selected` v = client->_bind_edit( flight ) ).

    list->__( n = `InputListItem` a = `label` v = `High Performance`
       )->_( n = `RadioButton`
             p = VALUE #( ( n = `groupName` v = `GroupPerf` )
                          ( n = `selected`  v = client->_bind_edit( high_perf ) ) ) ).

    list->__( n = `InputListItem` a = `label` v = `Battery Saving`
       )->_( n = `RadioButton`
             p = VALUE #( ( n = `groupName` v = `GroupPerf` )
                          ( n = `selected`  v = client->_bind_edit( battery ) ) ) ).

    list->__( n = `InputListItem` a = `label` v = `Price (EUR)`
       )->_( n = `Input`
             p = VALUE #( ( n = `placeholder` v = `Price` )
                          ( n = `type`        v = `Number` )
                          ( n = `value`       v = client->_bind_edit( price ) ) ) ).

    list->__( n = `InputListItem` a = `label` v = `Address`
       )->_( n = `Input`
             p = VALUE #( ( n = `placeholder` v = `Address` )
                          ( n = `value`       v = client->_bind_edit( address ) ) ) ).

    list->__( n = `InputListItem` a = `label` v = `Country`
       )->__( n = `Select` a = `selectedKey` v = client->_bind_edit( country )
           )->_( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `GR` ) ( n = `text` v = `Greece` ) )
           )->_( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `MX` ) ( n = `text` v = `Mexico` ) )
           )->_( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `NO` ) ( n = `text` v = `Norway` ) )
           )->_( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `NZ` ) ( n = `text` v = `New Zealand` ) )
           )->_( n = `Item` ns = `core` p = VALUE #( ( n = `key` v = `NL` ) ( n = `text` v = `Netherlands` ) ) ).

    list->__( n = `InputListItem` a = `label` v = `Volume`
       )->__( n = `HBox` a = `justifyContent` v = `End`
           )->_( n = `Slider`
                 p = VALUE #( ( n = `max`   v = `10` )
                              ( n = `min`   v = `0` )
                              ( n = `value` v = client->_bind_edit( volume ) )
                              ( n = `width` v = `200px` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
