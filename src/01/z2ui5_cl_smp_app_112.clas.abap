CLASS z2ui5_cl_smp_app_112 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        product TYPE string,
        info    TYPE string,
      END OF ty_s_item.

    DATA view_parent TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA mv_class_2 TYPE string.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_112 IMPLEMENTATION.

  METHOD view_display.

    " Deliberately styled DIFFERENTLY from sub-app class 1 (a form), so the
    " parent demo 104 shows at a glance WHICH class is embedded right now.
    t_items = VALUE #( ( product = `Notebook 17"` info = `in stock` )
                       ( product = `Monitor 27"`  info = `2 weeks` )
                       ( product = `Dock Pro`     info = `sold out` ) ).

    view_parent->tag( `MessageStrip`
        )->a( n = `text`     v = `SUB-APP CLASS 2 (z2ui5_cl_smp_app_112): an orange LIST - a different class ` &&
                   `with different controls and its own data, embedded into the same detail ` &&
                   `column of the parent app.`
        )->a( n = `type`     v = `Warning`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    view_parent->ele( `List`
        )->a( n = `headerText` v = `Class 2 - Products`
        )->a( n = `items`      v = client->_bind( t_items )
        )->tag( `StandardListItem`
            )->a( n = `title` v = `{PRODUCT}`
            )->a( n = `info`  v = `{INFO}` ).

    view_parent->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Input`
            )->a( n = `placeholder` v = `type here - the value lives in sub-app 2`
            )->a( n = `value`       v = client->_bind( mv_class_2 )
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `MESSAGE_SUB` )
            )->a( n = `text`  v = `raise event in sub-app 2`
            )->a( n = `icon`  v = `sap-icon://table-view` ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `MESSAGE_SUB` ).
      client->message_box_display( `event raised in SUB-APP CLASS 2 (the list)` ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    " No check_on_navigated( ) branch: this is a SUB-APP. It never calls
    " client->view_display( ) - it renders into the parent's view reference
    " (view_parent), and the parent app owns the screen and re-displays it.
    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
