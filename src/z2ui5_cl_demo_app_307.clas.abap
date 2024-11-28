CLASS z2ui5_cl_demo_app_307 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_item,
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
           END OF ty_item.
    TYPES ty_items TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY.

    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.
    DATA items             TYPE ty_items.

    METHODS initialization.

    METHODS display_view
      IMPORTING !client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING !client TYPE REF TO z2ui5_if_client.

ENDCLASS.


CLASS z2ui5_cl_demo_app_307 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      initialization( ).
      display_view( client ).
    ENDIF.

    on_event( client ).
  ENDMETHOD.

  METHOD initialization.
    items = VALUE #(
        ( title     = `Box title 1`
          subtitle  = `Subtitle 1`
          counter   = 5
          highlight = `Error`
          unread    = abap_true
          type      = `Active` )
        ( title     = `Box title 2`
          subtitle  = `Subtitle 2`
          counter   = 15
          highlight = `Warning`
          type      = `Active` )
        ( title     = `Box title 3`
          subtitle  = `Subtitle 3`
          counter   = 15734
          highlight = `None`
          type      = `Inactive`
          busy      = abap_true )
        ( title     = `Box title 4`
          subtitle  = `Subtitle 4`
          counter   = 2
          highlight = `None`
          type      = `Inactive` )
        ( title     = `Box title 5`
          subtitle  = `Subtitle 5`
          counter   = 1
          highlight = `Warning`
          type      = `Inactive` )
        ( title     = `Box title 6 Box title Box title Box title Box title Box title`
          subtitle  = `Subtitle 6`
          counter   = 5
          highlight = `None`
          type      = `Active` )
        ( title     = `Very long Box title that should wrap 7`
          subtitle  = `This is a long subtitle 7`
          counter   = 5
          highlight = `Error`
          type      = `DetailAndActive` )
        ( title     = `Box title B 8`
          subtitle  = `Subtitle 8`
          counter   = 0
          highlight = `None`
          type      = `Navigation` )
        ( title     = `Box title B 9 Box title B  Box title B 9 Box title B 9Box title B 9title B 9 Box title B 9Box title B`
          subtitle  = `Subtitle 9`
          highlight = `Success`
          type      = `Inactive` )
        ( title     = `Box title B 10`
          subtitle  = `Subtitle 10`
          highlight = `None`
          type      = `Active` )
        ( title     = `Box title B 11`
          subtitle  = `Subtitle 11`
          highlight = `None`
          type      = `Active` )
        ( title     = `Box title B 12`
          subtitle  = `Subtitle 12`
          highlight = `Information`
          type      = `Inactive` )
        ( title     = `Box title 13`
          subtitle  = `Subtitle 13`
          counter   = 5
          highlight = `None`
          type      = `Navigation` )
        ( title     = `Box title 14`
          subtitle  = `Subtitle 14`
          highlight = `Success`
          type      = `DetailAndActive` )
        ( title     = `Box title 15`
          subtitle  = `Subtitle 15`
          highlight = `None`
          type      = `Inactive` )
        ( title     = `Box title 16`
          subtitle  = `Subtitle 16`
          counter   = 37412578
          highlight = `None`
          type      = `Navigation` )
        ( title     = `Box title 17`
          subtitle  = `Subtitle 17`
          highlight = `Information`
          type      = `Inactive` )
        ( title     = `Box title 18`
          subtitle  = `Subtitle 18`
          highlight = `None`
          type      = `Inactive` )
        ( title     = `Very long Box title that should wrap 19`
          subtitle  = `This is a long subtitle 19`
          highlight = `None`
          type      = `Inactive` )
        ( title     = `Box title B 20`
          subtitle  = `Subtitle 20`
          counter   = 1
          busy      = abap_true
          highlight = `Success`
          type      = `Inactive` )
        ( title     = `Box title B 21`
          subtitle  = `Subtitle 21`
          highlight = `None`
          type      = `Navigation` )
        ( title     = `Box title B 22`
          subtitle  = `Subtitle 22`
          counter   = 5
          highlight = `None`
          unread    = abap_true
          type      = `Inactive` )
        ( title     = `Box title B 23`
          subtitle  = `Subtitle 23`
          counter   = 3
          highlight = `None`
          unread    = abap_true
          type      = `Inactive` )
        ( title     = `Box title B 24`
          subtitle  = `Subtitle 24`
          counter   = 5
          highlight = `Error`
          type      = `Inactive` )
        ( title     = `Box title B 21`
          subtitle  = `Subtitle 21`
          highlight = `None`
          type      = `Inactive` )
        ( title     = `Box title B 22`
          subtitle  = `Subtitle 22`
          highlight = `None`
          unread    = abap_true
          type      = `Navigation` )
        ( title     = `Box title B 23`
          subtitle  = `Subtitle 23`
          highlight = `None`
          type      = `Navigation` ) ).
  ENDMETHOD.

  METHOD display_view.
    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_z2ui5( )->title( `Grid List with Drag and Drop` ).

    view->panel( id               = `panelForGridList`
                 backgrounddesign = `Transparent`
        )->header_toolbar(
            )->toolbar( height = `3rem`
                )->title( text = `Grid List with Drag and Drop`
            )->get_parent(
        )->get_parent(
        )->grid_list( id         = `gridList`
                      headertext = `GridList header`
                      items      = client->_bind_edit( items )
            )->drag_drop_config(
                )->drag_info( sourceaggregation = `items`
                )->grid_drop_info(
                    targetaggregation = `items`
                    dropposition      = `Between`
                    droplayout        = `Horizontal`
                    drop              = client->_event(
                        val   = 'onDrop'
                        t_arg = VALUE #(
                            ( `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` )
                            ( `${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl})` )
                            ( `${$parameters>/dropPosition}` ) ) )
            )->get_parent(
            )->custom_layout( ns = 'f'
                )->grid_box_layout( boxminwidth = `17rem`
            )->get_parent(
            )->grid_list_item( counter   = '{COUNTER}'
                               highlight = '{HIGHLIGHT}'
                               type      = '{TYPE}'
                               unread    = '{UNREAD}'
                )->vbox( height = `100%`
                    )->vbox( class = `sapUiSmallMargin`
                        )->layout_data(
                            )->flex_item_data( growfactor   = `1`
                                               shrinkfactor = `0`
                        )->get_parent(
                        )->title( text     = '{TITLE}'
                                  wrapping = abap_true
                        )->label( text     = '{SUBTITLE}'
                                  wrapping = abap_true ).

    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.
      WHEN 'onDrop'.
        DATA(ondropparameters) = client->get( )-t_event_arg.
        TRY.
            DATA(drag_position) = CONV i( ondropparameters[ 1 ] ) + 1.
            DATA(drop_position) = CONV i( ondropparameters[ 2 ] ) + 1.
            DATA(insert_position) = ondropparameters[ 3 ].
            DATA(item) = items[ drag_position ].
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

    ENDCASE.
    client->view_model_update( ).
  ENDMETHOD.
ENDCLASS.
