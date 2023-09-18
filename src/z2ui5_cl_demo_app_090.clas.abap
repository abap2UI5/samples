CLASS z2ui5_cl_demo_app_090 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

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

    "P13N
    TYPES: BEGIN OF t_items22,
             visible TYPE abap_bool,
             name    TYPE string,
             label   TYPE string,
           END OF t_items22.
    TYPES: tt_items22 TYPE STANDARD TABLE OF t_items22 WITH DEFAULT KEY.

    TYPES: BEGIN OF t_items32,
             sorted     TYPE abap_bool,
             name       TYPE string,
             label      TYPE string,
             descending TYPE abap_bool,
           END OF t_items32.
    TYPES: tt_items32 TYPE STANDARD TABLE OF t_items32 WITH DEFAULT KEY.

    TYPES: BEGIN OF t_items33,
             grouped TYPE abap_bool,
             name    TYPE string,
             label   TYPE string,
           END OF t_items33.
    TYPES: tt_items33 TYPE STANDARD TABLE OF t_items33 WITH DEFAULT KEY.

    DATA: mt_columns_p13n TYPE tt_items22.
    DATA: mt_sort_p13n TYPE tt_items32.
    DATA: mt_groups_p13n TYPE tt_items33.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_view_display.
    METHODS z2ui5_view_p13n.
    METHODS z2ui5_view_p13n_popup.
    METHODS z2ui5_on_event.


  PRIVATE SECTION.
    DATA mv_page TYPE string.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_090 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

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


      mt_columns_p13n = VALUE #(
                                  ( visible = `true` name = `key1` label = `City` )
                                  ( visible = `false` name = `key2` label = `Country` )
                                  ( visible = `false` name = `key2` label = `Region` )
                                ).

      mt_sort_p13n = VALUE #(
                            ( sorted = `true` name = `key1` label = `City` descending = `true` )
                            ( sorted = `false` name = `key2` label = `Country` descending = `false` )
                            ( sorted = `false` name = `key2` label = `Region` descending = `false` )
                          ).

      mt_groups_p13n = VALUE #(
                            ( grouped = `true` name = `key1` label = `City` )
                            ( grouped = `false` name = `key2` label = `Country` )
                            ( grouped = `false` name = `key2` label = `Region` )
                          ).

    DATA(lv_custom_js) = `sap.z2ui5.setInitialData = () => {` && |\n| &&
                         `    debugger;` && |\n| &&
                         `    var oView = sap.z2ui5.oView` && |\n| &&
                         `    var oSelectionPanel = oView.byId("columnsPanel");` && |\n| &&
                         `    var oSortPanel = oView.byId("sortPanel");` && |\n| &&
                         `    var oGroupPanel = oView.byId("groupPanel");` && |\n| &&
                         `    oSelectionPanel.setP13nData(oView.getModel().oData.EDIT.MT_COLUMNS_P13N);` && |\n| &&
                         `    oSortPanel.setP13nData(oView.getModel().oData.EDIT.MT_SORT_P13N);` && |\n| &&
                         `    oGroupPanel.setP13nData(oView.getModel().oData.EDIT.MT_GROUPS_P13N);` && |\n| &&
                         `    var oPopup = oView.byId("p13nPopup");` && |\n| &&
                         `    oPopup.open();` && |\n| &&
                         `};`.

    client->view_display( Z2UI5_cl_xml_view=>factory( client
      )->zcc_plain_xml( `<html:script>` && lv_custom_js && `</html:script>`
      )->stringify( ) ).

    client->timer_set(
      interval_ms    = '0'
      event_finished = client->_event( 'DISPLAY_VIEW' )
    ).

      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'DISPLAY_VIEW'.
        z2ui5_view_display( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'P13N_OPEN'.
        z2ui5_view_p13n( ).

      WHEN 'P13N_POPUP'.
        z2ui5_view_p13n_popup( ).

      WHEN 'OK' OR 'CANCEL'.
        client->popup_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    client->_bind_edit( val = mt_columns_p13n pretty_name = 'L' ).
    client->_bind_edit( val = mt_sort_p13n pretty_name = 'L'  ).
    client->_bind_edit( val = mt_groups_p13n pretty_name = 'L' ).

    DATA(page) =  z2ui5_cl_xml_view=>factory( client ).

    page = page->shell( )->page(
        title          = 'abap2UI5 - P13N Dialog'
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton  = abap_true
        class = 'sapUiContentPadding' ).

    page = page->vbox( ).

    page->_generic( name = `Popup` ns = `p13n`
                          t_prop = VALUE #( ( n = `title` v = `My Custom View Settings` )
*                                            ( n = `close` v = client->_event( 'P13N_CLOSE' ) )
*                                            ( n = `warningText`  v = `Are you sure?` )
                                            ( n = `id`  v = `p13nPopup` )
*                                            ( n = `reset`  v = client->_event( `P13N_RESET` ) )
                                          )
                         )->_generic( name = `panels` ns = `p13n`
                           )->_generic( name = `SelectionPanel` ns = `p13n`
                                        t_prop = VALUE #( ( n = `id`    v = `columnsPanel` )
                                                          ( n = `title`  v = `Columns` )
*                                                          ( n = `enableCount`  v = 'X' )
*                                                          ( n = `showHeader` v = 'X' )
                                                         ) )->get_parent(
                          )->_generic( name = `SortPanel` ns = `p13n`
                                       t_prop = VALUE #( ( n = `id`  v = `sortPanel` )
                                                         ( n = `title` v = `Sort` )
                                                        )
                                                    )->get_parent(
                         )->_generic( name = `GroupPanel` ns = `p13n`
                                      t_prop = VALUE #( ( n = `id`  v = `groupPanel` )
                                                        ( n = `title`  v = `Group` )
                                                       )
                                      )->get_parent(  )->get_parent( )->get_parent(

                                    )->get_parent( )->get_parent( ).

    page->button( text = `Open P13N Dialog` press = client->_event( 'P13N_OPEN' ) class = `sapUiTinyMarginBeginEnd`
    )->button( text = `Open P13N.POPUP` press = `sap.z2ui5.setInitialData()` )->get_parent( )->get_parent( ).




    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_view_p13n.



    DATA(p13n_dialog) = z2ui5_cl_xml_view=>factory_popup( client ).

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
           t_prop = VALUE #( ( n = `columnKey` v = `{columnkey}` )
                             ( n = `text`      v = `{text}` ) ) )->get_parent( )->get_parent(

         )->_generic( name = `columnsItems`
           )->_generic( name = `P13nColumnsItem`
               t_prop = VALUE #( ( n = `columnKey` v = `{columnkey}` )
                                  ( n = `visible`   v = `{visible}` )
                                   ( n = `index`    v = `{index}` ) ) )->get_parent( )->get_parent( )->get_parent(

     )->_generic( name = `P13nGroupPanel`
           t_prop = VALUE #( ( n = `groupItems` v = `{path:'` && client->_bind_edit( val = mt_groups path = abap_true ) && `'}` ) )
     )->items(
      )->_generic( name = `P13nItem`
           t_prop = VALUE #( ( n = `columnKey` v = `{columnkey}` )
                             ( n = `text`      v = `{text}` ) ) )->get_parent( )->get_parent(

      )->_generic( name = `groupItems`
        )->_generic( name = `P13nGroupItem`
            t_prop = VALUE #( ( n = `columnKey` v = `{columnkey}` )
                              ( n = `operation` v = `{operation}` )
                              ( n = `showIfGrouped` v = `{showifgrouped}` ) ) ).

    client->popup_display( p13n->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_view_p13n_popup.



    DATA(p13n_popup) = z2ui5_cl_xml_view=>factory( client ).

    p13n_popup->_generic( name = `Popup` ns = `p13n`
                              t_prop = VALUE #( ( n = `title` v = `My Custom View Settings` )
*                                                ( n = `close` v = client->_event( 'P13N_CLOSE' ) )
*                                                ( n = `warningText`  v = `Are you sure?` )
                                                ( n = `id`  v = `p13nPopup` )
*                                                ( n = `reset`  v = client->_event( `P13N_RESET` ) )
                                              )
                             )->_generic( name = `panels` ns = `p13n`
                               )->_generic( name = `SelectionPanel` ns = `p13n`
                                            t_prop = VALUE #( ( n = `id`    v = `columnsPanel` )
                                                              ( n = `title`  v = `Columns` )
*                                                              ( n = `enableCount`  v = 'X' )
*                                                              ( n = `showHeader` v = 'X' )
                                                             ) )->get_parent(
                              )->_generic( name = `SortPanel` ns = `p13n`
                                           t_prop = VALUE #( ( n = `id`  v = `sortPanel` )
                                                             ( n = `title` v = `Sort` )
                                                            )
                                                        )->get_parent(
                             )->_generic( name = `GroupPanel` ns = `p13n`
                                          t_prop = VALUE #( ( n = `id`  v = `groupPanel` )
                                                            ( n = `title`  v = `Group` )
                                                           )
                                          )->get_parent(  )->get_parent( )->get_parent(
                                        ).

    client->view_display( p13n_popup->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
