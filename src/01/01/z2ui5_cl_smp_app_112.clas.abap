CLASS z2ui5_cl_smp_app_112 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mo_view_parent TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_class_2 TYPE string.
    DATA mr_data TYPE REF TO data.

    TYPES:
      BEGIN OF ty_s_item,
        product TYPE string,
        info    TYPE string,
      END OF ty_s_item.
    DATA mt_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    METHODS on_event.
    METHODS view_display
      CHANGING
        xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_112 IMPLEMENTATION.

  METHOD view_display.

    " Deliberately styled DIFFERENTLY from sub-app class 1 (a form), so the
    " parent demo 104 shows at a glance WHICH class is embedded right now.
    IF mt_items IS INITIAL.
      mt_items = VALUE #( ( product = `Notebook 17"` info = `in stock` )
                          ( product = `Monitor 27"`  info = `2 weeks` )
                          ( product = `Dock Pro`     info = `sold out` ) ).
    ENDIF.

    mo_view_parent->message_strip(
        text     = `SUB-APP CLASS 2 (z2ui5_cl_smp_app_112): an orange LIST - a different class ` &&
                   `with different controls and its own data, embedded into the same detail ` &&
                   `column of the parent app.`
        type     = `Warning`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    mo_view_parent->list( headertext = `Class 2 - Products`
                          items      = client->_bind( mt_items )
        )->standard_list_item( title = `{PRODUCT}`
                               info  = `{INFO}` ).

    mo_view_parent->vbox( `sapUiSmallMargin`
        )->input( value       = client->_bind( mv_class_2 )
                  placeholder = `type here - the value lives in sub-app 2`
        )->button( text  = `raise event in sub-app 2`
                   press = client->_event( `MESSAGE_SUB` )
                   icon  = `sap-icon://table-view` ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `MESSAGE_SUB` ).
      client->message_box_display( `event raised in SUB-APP CLASS 2 (the list)` ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
