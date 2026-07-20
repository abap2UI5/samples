"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectMarker/sample/sap.m.sample.ObjectMarker
"! The ObjectMarker is a small building block representing an object by an icon or text and icon. Often
"! it is used in a table.
CLASS z2ui5_cl_demo_app_289 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product        TYPE string,
        type           TYPE string,
        additionalinfo TYPE string,
      END OF ty_s_product.
    DATA lt_a_data TYPE TABLE OF ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_289 IMPLEMENTATION.

  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Marker in a table`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectMarker/sample/sap.m.sample.ObjectMarker` ).

    
    CLEAR temp1.
    INSERT `${TYPE}` INTO TABLE temp1.
    page->table( id = `idProductsTable`
           items    = client->_bind( lt_a_data )
           )->columns(
               )->column(
                   )->text( `Products`
               )->get_parent(
               )->column(
                   )->text( `Status`
               )->get_parent(
               )->column(
                   )->text( `Status (active)`
               )->get_parent( )->get_parent(
           )->column_list_item(
               )->object_identifier(
                   text = `{PRODUCT}` )->get_parent(
               )->object_marker(
                   type           = `{TYPE}`
                   additionalinfo = `{ADDITIONALINFO}` )->get_parent(
               )->object_marker(
                   type           = `{TYPE}`
                   additionalinfo = `{ADDITIONALINFO}`
                   press          = client->_event( val = `onPress` t_arg = temp1 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
      WHEN `onPress`.
        client->message_toast_display( |{ client->get_event_arg( ) } marker pressed!| ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The ObjectMarker is a small building block representing an object by an icon or text and icon. Often it is used in a table.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp3 LIKE lt_a_data.
      DATA temp4 LIKE LINE OF temp3.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( client ).

      
      CLEAR temp3.
      
      temp4-product = `Power Projector 4713`.
      temp4-type = `Locked`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Power Projector 4713`.
      temp4-type = `LockedBy`.
      temp4-additionalinfo = `John Doe`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Power Projector 4713`.
      temp4-type = `LockedBy`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Gladiator MX`.
      temp4-type = `Draft`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Hurricane GX`.
      temp4-type = `Unsaved`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Hurricane GX`.
      temp4-type = `UnsavedBy`.
      temp4-additionalinfo = `John Doe`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Hurricane GX`.
      temp4-type = `UnsavedBy`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Hurricane GX`.
      temp4-type = `Unsaved`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Webcam`.
      temp4-type = `Favorite`.
      INSERT temp4 INTO TABLE temp3.
      temp4-product = `Deskjet Super Highspeed`.
      temp4-type = `Flagged`.
      INSERT temp4 INTO TABLE temp3.
      lt_a_data = temp3.

    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
