"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListDragAndDrop
"! This sample represents GridList with enabled Drag and Drop functionality.
CLASS z2ui5_cl_demo_app_307 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             busy               TYPE abap_bool,
             busyindicatordelay TYPE i,
             busyindicatorsize  TYPE string,
             counter            TYPE i,
             fieldgroupids      TYPE string,
             highlight          TYPE string,
             highlighttext      TYPE string,
             navigated          TYPE abap_bool,
             selected           TYPE abap_bool,
             type               TYPE string,
             unread             TYPE abap_bool,
             visiple            TYPE abap_bool,
             title              TYPE string,
             subtitle           TYPE string,
           END OF ty_s_item.
    TYPES ty_items TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.

    DATA items             TYPE ty_items.

    METHODS initialization.

    METHODS view_display
      IMPORTING client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_307 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      initialization( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD initialization.

    DATA temp1 TYPE z2ui5_cl_demo_app_307=>ty_items.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-title = `Box title 1`.
    temp2-subtitle = `Subtitle 1`.
    temp2-counter = 5.
    temp2-highlight = `Error`.
    temp2-unread = abap_true.
    temp2-type = `Active`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 2`.
    temp2-subtitle = `Subtitle 2`.
    temp2-counter = 15.
    temp2-highlight = `Warning`.
    temp2-type = `Active`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 3`.
    temp2-subtitle = `Subtitle 3`.
    temp2-counter = 15734.
    temp2-highlight = `None`.
    temp2-type = `Inactive`.
    temp2-busy = abap_true.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 4`.
    temp2-subtitle = `Subtitle 4`.
    temp2-counter = 2.
    temp2-highlight = `None`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 5`.
    temp2-subtitle = `Subtitle 5`.
    temp2-counter = 1.
    temp2-highlight = `Warning`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 6 Box title Box title Box title Box title Box title`.
    temp2-subtitle = `Subtitle 6`.
    temp2-counter = 5.
    temp2-highlight = `None`.
    temp2-type = `Active`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Very long Box title that should wrap 7`.
    temp2-subtitle = `This is a long subtitle 7`.
    temp2-counter = 5.
    temp2-highlight = `Error`.
    temp2-type = `DetailAndActive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 8`.
    temp2-subtitle = `Subtitle 8`.
    temp2-counter = 0.
    temp2-highlight = `None`.
    temp2-type = `Navigation`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 9 Box title B  Box title B 9 Box title B 9Box title B 9title B 9 Box title B 9Box title B`.
    temp2-subtitle = `Subtitle 9`.
    temp2-highlight = `Success`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 10`.
    temp2-subtitle = `Subtitle 10`.
    temp2-highlight = `None`.
    temp2-type = `Active`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 11`.
    temp2-subtitle = `Subtitle 11`.
    temp2-highlight = `None`.
    temp2-type = `Active`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 12`.
    temp2-subtitle = `Subtitle 12`.
    temp2-highlight = `Information`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 13`.
    temp2-subtitle = `Subtitle 13`.
    temp2-counter = 5.
    temp2-highlight = `None`.
    temp2-type = `Navigation`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 14`.
    temp2-subtitle = `Subtitle 14`.
    temp2-highlight = `Success`.
    temp2-type = `DetailAndActive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 15`.
    temp2-subtitle = `Subtitle 15`.
    temp2-highlight = `None`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 16`.
    temp2-subtitle = `Subtitle 16`.
    temp2-counter = 37412578.
    temp2-highlight = `None`.
    temp2-type = `Navigation`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 17`.
    temp2-subtitle = `Subtitle 17`.
    temp2-highlight = `Information`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title 18`.
    temp2-subtitle = `Subtitle 18`.
    temp2-highlight = `None`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Very long Box title that should wrap 19`.
    temp2-subtitle = `This is a long subtitle 19`.
    temp2-highlight = `None`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 20`.
    temp2-subtitle = `Subtitle 20`.
    temp2-counter = 1.
    temp2-busy = abap_true.
    temp2-highlight = `Success`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 21`.
    temp2-subtitle = `Subtitle 21`.
    temp2-highlight = `None`.
    temp2-type = `Navigation`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 22`.
    temp2-subtitle = `Subtitle 22`.
    temp2-counter = 5.
    temp2-highlight = `None`.
    temp2-unread = abap_true.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 23`.
    temp2-subtitle = `Subtitle 23`.
    temp2-counter = 3.
    temp2-highlight = `None`.
    temp2-unread = abap_true.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 24`.
    temp2-subtitle = `Subtitle 24`.
    temp2-counter = 5.
    temp2-highlight = `Error`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 21`.
    temp2-subtitle = `Subtitle 21`.
    temp2-highlight = `None`.
    temp2-type = `Inactive`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 22`.
    temp2-subtitle = `Subtitle 22`.
    temp2-highlight = `None`.
    temp2-unread = abap_true.
    temp2-type = `Navigation`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Box title B 23`.
    temp2-subtitle = `Subtitle 23`.
    temp2-highlight = `None`.
    temp2-type = `Navigation`.
    INSERT temp2 INTO TABLE temp1.
    items = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page( title          = `Grid List with Drag and Drop`
                 navbuttonpress = client->_event_nav_app_leave( )
                 shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.GridList/sample/sap.f.sample.GridListDragAndDrop` ).

    
    CLEAR temp3.
    INSERT `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` INTO TABLE temp3.
    INSERT `${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl})` INTO TABLE temp3.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp3.
    page->panel( id               = `panelForGridList`
                 backgrounddesign = `Transparent`
        )->header_toolbar(
            )->toolbar( height = `3rem`
                )->title( `Grid List with Drag and Drop`
            )->get_parent(
        )->get_parent(
        )->grid_list( id         = `gridList`
                      headertext = `GridList header`
                      items      = client->_bind( items )
            )->drag_drop_config(
                )->drag_info( `items`
                )->grid_drop_info(
                    targetaggregation = `items`
                    dropposition      = `Between`
                    droplayout        = `Horizontal`
                    drop              = client->_event(
                    val               = `onDrop`
                    t_arg             = temp3 )
            )->get_parent(
            )->custom_layout( `f`
                )->grid_box_layout( boxminwidth = `17rem`
            )->get_parent(
            )->grid_list_item( counter   = `{COUNTER}`
                               highlight = `{HIGHLIGHT}`
                               type      = `{TYPE}`
                               unread    = `{UNREAD}`
                )->vbox( height = `100%`
                    )->vbox( `sapUiSmallMargin`
                        )->layout_data(
                            )->flex_item_data( growfactor   = `1`
                                               shrinkfactor = `0`
                        )->get_parent(
                        )->title( text     = `{TITLE}`
                                  wrapping = abap_true
                        )->label( text     = `{SUBTITLE}`
                                  wrapping = abap_true ).

    client->view_display( view->stringify( ) ).

    
    CLEAR temp5.
    INSERT `Grid List with Drag and Drop` INTO TABLE temp5.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_title
        t_arg = temp5 ).

  ENDMETHOD.


  METHOD on_event.
      DATA ondropparameters TYPE string_table.
          DATA temp7 TYPE i.
          DATA temp1 LIKE LINE OF ondropparameters.
          DATA temp2 LIKE sy-tabix.
          DATA drag_position TYPE i.
          DATA temp8 TYPE i.
          DATA temp3 LIKE LINE OF ondropparameters.
          DATA temp4 LIKE sy-tabix.
          DATA drop_position TYPE i.
          DATA insert_position LIKE LINE OF ondropparameters.
          DATA temp5 LIKE LINE OF ondropparameters.
          DATA temp6 LIKE sy-tabix.
          DATA item LIKE LINE OF items.
          DATA temp9 LIKE LINE OF items.
          DATA temp10 LIKE sy-tabix.

    IF client->check_on_event( `onDrop` ) IS NOT INITIAL.
      
      ondropparameters = client->get( )-t_event_arg.
      TRY.
          
          
          
          temp2 = sy-tabix.
          READ TABLE ondropparameters INDEX 1 INTO temp1.
          sy-tabix = temp2.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          temp7 = temp1.
          
          drag_position = temp7 + 1.
          
          
          
          temp4 = sy-tabix.
          READ TABLE ondropparameters INDEX 2 INTO temp3.
          sy-tabix = temp4.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          temp8 = temp3.
          
          drop_position = temp8 + 1.
          
          
          
          temp6 = sy-tabix.
          READ TABLE ondropparameters INDEX 3 INTO temp5.
          sy-tabix = temp6.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          insert_position = temp5.
          
          
          
          temp10 = sy-tabix.
          READ TABLE items INDEX drag_position INTO temp9.
          sy-tabix = temp10.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          item = temp9.
        CATCH cx_root.
          RETURN.
      ENDTRY.

      DELETE items INDEX drag_position.

      IF drag_position < drop_position.
        drop_position = drop_position - 1.
      ENDIF.

      IF insert_position = `Before`.
        INSERT item INTO items INDEX drop_position.

      ELSE.
        INSERT item INTO items INDEX drop_position + 1.
      ENDIF.
    ENDIF.
    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
