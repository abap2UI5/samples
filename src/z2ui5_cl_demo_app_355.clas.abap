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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - InputListItem`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(list) = page->_generic( name   = `List`
                                 t_prop = VALUE #( ( n = `headerText` v = `Input` ) ) ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `WLAN` ) )
        )->_generic( name   = `Switch`
                     t_prop = VALUE #( ( n = `state` v = client->_bind_edit( wlan ) ) )
        )->get_parent( )->get_parent( ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `Flight Mode` ) )
        )->_generic( name   = `CheckBox`
                     t_prop = VALUE #( ( n = `selected` v = client->_bind_edit( flight ) ) )
        )->get_parent( )->get_parent( ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `High Performance` ) )
        )->_generic( name   = `RadioButton`
                     t_prop = VALUE #( ( n = `groupName` v = `GroupPerf` )
                                       ( n = `selected`  v = client->_bind_edit( high_perf ) ) )
        )->get_parent( )->get_parent( ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `Battery Saving` ) )
        )->_generic( name   = `RadioButton`
                     t_prop = VALUE #( ( n = `groupName` v = `GroupPerf` )
                                       ( n = `selected`  v = client->_bind_edit( battery ) ) )
        )->get_parent( )->get_parent( ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `Price (EUR)` ) )
        )->_generic( name   = `Input`
                     t_prop = VALUE #( ( n = `placeholder` v = `Price` )
                                       ( n = `value`       v = client->_bind_edit( price ) )
                                       ( n = `type`        v = `Number` ) )
        )->get_parent( )->get_parent( ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `Address` ) )
        )->_generic( name   = `Input`
                     t_prop = VALUE #( ( n = `placeholder` v = `Address` )
                                       ( n = `value`       v = client->_bind_edit( address ) ) )
        )->get_parent( )->get_parent( ).

    DATA(select) = list->_generic( name   = `InputListItem`
                                   t_prop = VALUE #( ( n = `label` v = `Country` ) )
                       )->_generic( name   = `Select`
                                    t_prop = VALUE #( ( n = `selectedKey` v = client->_bind_edit( country ) ) ) ).
    select->_generic( name = `Item` ns = `core`
                      t_prop = VALUE #( ( n = `key` v = `GR` ) ( n = `text` v = `Greece` ) )
           )->get_parent( )->_generic( name = `Item` ns = `core`
                      t_prop = VALUE #( ( n = `key` v = `MX` ) ( n = `text` v = `Mexico` ) )
           )->get_parent( )->_generic( name = `Item` ns = `core`
                      t_prop = VALUE #( ( n = `key` v = `NO` ) ( n = `text` v = `Norway` ) )
           )->get_parent( )->_generic( name = `Item` ns = `core`
                      t_prop = VALUE #( ( n = `key` v = `NZ` ) ( n = `text` v = `New Zealand` ) )
           )->get_parent( )->_generic( name = `Item` ns = `core`
                      t_prop = VALUE #( ( n = `key` v = `NL` ) ( n = `text` v = `Netherlands` ) )
           )->get_parent( )->get_parent( )->get_parent( ).

    list->_generic( name   = `InputListItem`
                    t_prop = VALUE #( ( n = `label` v = `Volume` ) )
        )->_generic( name   = `HBox`
                     t_prop = VALUE #( ( n = `justifyContent` v = `End` ) )
            )->_generic( name   = `Slider`
                         t_prop = VALUE #( ( n = `min`   v = `0` )
                                           ( n = `max`   v = `10` )
                                           ( n = `value` v = client->_bind_edit( volume ) )
                                           ( n = `width` v = `200px` ) )
            )->get_parent( )->get_parent( )->get_parent( ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
