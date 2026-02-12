CLASS z2ui5_cl_demo_app_081 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_product  TYPE string.
    DATA mv_quantity TYPE string.
    DATA mv_placement TYPE string.

    TYPES:
      BEGIN OF ty_tab,
        selected TYPE abap_bool,
        id       TYPE string,
        name     TYPE string,
      END OF ty_tab.

    DATA mt_tab TYPE STANDARD TABLE OF ty_tab WITH EMPTY KEY.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS display_view.
    METHODS display_popover
      IMPORTING
        id TYPE string.
    METHODS display_popover_list
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_081 IMPLEMENTATION.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->popover(
                  title     = `Popover Title`
                  placement = mv_placement
              )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
                  )->button(
                      text  = `Cancel`
                      press = mo_client->_event( `BUTTON_CANCEL` )
                  )->button(
                      text  = `Confirm`
                      press = mo_client->_event( `BUTTON_CONFIRM` )
                      type  = `Emphasized`
                )->get_parent( )->get_parent(
            )->text( `make an input here:`
            )->input( value = `abcd` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD display_popover_list.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->popover(
                  title     = `Popover Title`
                  placement = mv_placement
              )->list(
                items           = mo_client->_bind_edit( mt_tab )
*                selectionchange = client->_event( 'SEL_CHANGE' t_arg = VALUE #( ( `${$parameters>/listItem}` ) ) )
                selectionchange = mo_client->_event( `SEL_CHANGE` )
                mode            = `SingleSelectMaster`
                 )->standard_list_item(
                  title       = `{ID}`
                  description = `{NAME}`
                  selected    = `{SELECTED}` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->shell(
      )->page(
              title          = `abap2UI5 - Popover with List`
              navbuttonpress = mo_client->_event_nav_app_leave( )
              shownavbutton  = mo_client->check_app_prev_stack( )
          )->simple_form( `Popover`
              )->content( `form`
                  )->title( `Input`
                  )->label( `Link`
                  )->link( text = `Documentation UI5 Popover Control`
                           href = `https://openui5.hana.ondemand.com/entity/sap.m.Popover`
                  )->label( `placement`
                  )->segmented_button( selected_key = mo_client->_bind_edit( mv_placement )
                        )->items(
                        )->segmented_button_item(
                                key  = `Left`
                                icon = `sap-icon://add-favorite`
                                text = `Left`
                        )->segmented_button_item(
                                key  = `Top`
                                icon = `sap-icon://accept`
                                text = `Top`
                        )->segmented_button_item(
                                key  = `Bottom`
                                icon = `sap-icon://accept`
                                text = `Bottom`
                        )->segmented_button_item(
                                key  = `Right`
                                icon = `sap-icon://attachment`
                                text = `Right`
                  )->get_parent( )->get_parent(
                  )->label( `popover`
                  )->button(
                      text  = `show popover with list`
                      press = mo_client->_event( `POPOVER_LIST` )
                      id    = `TEST` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
      display_view( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `SEL_CHANGE`.
        DATA(lt_sel) = mt_tab.
        DELETE lt_sel WHERE selected IS INITIAL.
      WHEN `POPOVER_LIST`.
        display_popover_list( `TEST` ).
      WHEN `POPOVER`.
        display_popover( `TEST` ).
      WHEN `BUTTON_CONFIRM`.
        mo_client->message_toast_display( |confirm| ).
        mo_client->popover_destroy( ).
      WHEN `BUTTON_CANCEL`.
        mo_client->message_toast_display( |cancel| ).
        mo_client->popover_destroy( ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    mv_placement = `Left`.
    mv_product  = `tomato`.
    mv_quantity = `500`.

    mt_tab = VALUE #(
                      ( id = `1` name = `name1` )
                      ( id = `2` name = `name2` )
                      ( id = `3` name = `name3` )
                      ( id = `4` name = `name4` ) ).
  ENDMETHOD.
ENDCLASS.
