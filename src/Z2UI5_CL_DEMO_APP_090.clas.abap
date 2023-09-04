CLASS Z2UI5_CL_DEMO_APP_090 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

    TYPES: BEGIN OF t_items2,
             columnkey TYPE string,
             text      TYPE string,
             visible   TYPE abap_bool,
             index     TYPE i,
           END OF t_items2.
    TYPES: tt_items2 TYPE STANDARD TABLE OF t_items2 WITH DEFAULT KEY.

    TYPES: BEGIN OF t_items3,
             columnkey     TYPE string,
             operation     TYPE string,
             showifgrouped TYPE abap_bool,
             key           TYPE string,
             text          TYPE string,
           END OF t_items3.
    TYPES: tt_items3 TYPE STANDARD TABLE OF t_items3 WITH DEFAULT KEY.

    DATA: mt_columns TYPE tt_items2.
    DATA: mt_columns1 TYPE tt_items2.
    DATA: mt_groups TYPE tt_items3.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_view_display.
    METHODS Z2UI5_view_p13n.
    METHODS Z2UI5_on_event.


  PRIVATE SECTION.
    DATA mv_page TYPE string.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_090 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      mt_columns =  VALUE #( ( columnkey = `productId` text = `Product ID` )
                                         ( columnkey = `name`      text = `Name` )
                                         ( columnkey = `category`  text = `Category` )
                                         ( columnkey = `supplierName` text = `Supplier Name` )
                                       ).
      mt_columns1 = VALUE #(
                                           ( columnkey = `name`      visible = abap_true index = 0 )
                                           ( columnkey = `category`  visible = abap_true index = 1 )
                                           ( columnkey = `productId` visible = abap_false )
                                           ( columnkey = `supplierName` visible = abap_false )
                                         ).

      mt_groups = VALUE #( ( columnkey = `name` text = `Name` showifgrouped = abap_true )
                           ( columnkey = `category` text = `Category` showifgrouped = abap_true )
                           ( columnkey = `productId` showifgrouped = abap_false )
                           ( columnkey = `supplierName` showifgrouped = abap_false )
                         ).

      Z2UI5_view_display( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'P13N_OPEN'.
        Z2UI5_view_p13n( ).

      WHEN 'OK' OR 'CANCEL'.
        client->popup_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_view_display.

    DATA(page) =  Z2UI5_cl_xml_view=>factory( client )->shell( )->page(
        title          = 'abap2UI5 - P13N Dialog'
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton  = abap_true
        class = 'sapUiContentPadding' ).

    page->button( text = `Open P13N Dialog` press = client->_event( 'P13N_OPEN' ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_view_p13n.

    DATA(p13n_dialog) = Z2UI5_cl_xml_view=>factory_popup( client ).

    DATA(p13n) = p13n_dialog->_generic( name = `P13nDialog`
    t_prop = VALUE #(
    ( n = `ok`                      v = client->_event( `OK` ) )
    ( n = `cancel`                  v = client->_event( `CANCEL` ) )
    ( n = `reset`                   v = client->_event( `RESET` ) )
    ( n = `showReset`               v = `true` )
    ( n = `initialVisiblePanelType` v = `sort` )
    )
    )->_generic( name = `panels`
     )->_generic( name = `P13nColumnsPanel`
     t_prop = VALUE #(
*     ( n = `title`   v = `Columns` )
*     ( n = `visible` v = `true` )
*     ( n = `type`    v = `Columns` )
     ( n = `items`   v = `{path:'` && client->_bind_edit( val = mt_columns path = abap_true ) && `'}` )
     ( n = `columnsItems`   v = `{path:'` && client->_bind_edit( val = mt_columns1 path = abap_true ) && `'}` ) )
     )->items(
         )->_generic( name = `P13nItem`
           t_prop = VALUE #( ( n = `columnKey` v = `{COLUMNKEY}` )
                             ( n = `text`      v = `{TEXT}` ) ) )->get_parent( )->get_parent(

         )->_generic( name = `columnsItems`
           )->_generic( name = `P13nColumnsItem`
               t_prop = VALUE #( ( n = `columnKey` v = `{COLUMNKEY}` )
                                  ( n = `visible`   v = `{VISIBLE}` )
                                   ( n = `index`    v = `{INDEX}` ) ) )->get_parent( )->get_parent( )->get_parent(

     )->_generic( name = `P13nGroupPanel`
           t_prop = VALUE #( ( n = `groupItems` v = `{path:'` && client->_bind_edit( val = mt_groups path = abap_true ) && `'}` ) )
     )->items(
      )->_generic( name = `P13nItem`
           t_prop = VALUE #( ( n = `columnKey` v = `{COLUMNKEY}` )
                             ( n = `text`      v = `{TEXT}` ) ) )->get_parent( )->get_parent(

      )->_generic( name = `groupItems`
        )->_generic( name = `P13nGroupItem`
            t_prop = VALUE #( ( n = `columnKey` v = `{COLUMNKEY}` )
                              ( n = `operation` v = `{OPERATION}` )
                              ( n = `showIfGrouped` v = `{SHOWIFGROUPED}` ) ) ).

    client->popup_display( p13n->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
