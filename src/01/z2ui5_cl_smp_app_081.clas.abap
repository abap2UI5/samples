" @keywords list selection placement anchor
CLASS z2ui5_cl_smp_app_081 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selected TYPE abap_bool,
        id       TYPE string,
        name     TYPE string,
      END OF ty_s_tab.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA mv_placement TYPE string.

    DATA mt_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS popover_display
      IMPORTING
        id TYPE string.
    METHODS popover_list_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_081 IMPLEMENTATION.

  METHOD popover_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).
    view->ele( `Popover`
        )->a( n = `title`     v = `Popover Title`
        )->a( n = `placement` v = mv_placement
        )->ele( `footer`
            )->ele( `OverflowToolbar`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_CANCEL` )
                    )->a( n = `text`  v = `Cancel`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_CONFIRM` )
                    )->a( n = `text`  v = `Confirm`
                    )->a( n = `type`  v = `Emphasized`
            )->end(
        )->end(
        )->tag( `Text`
            )->a( n = `text` v = `make an input here:`
        )->tag( `Input`
            )->a( n = `value` v = `abcd` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD popover_list_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).
    view->ele( `Popover`
        )->a( n = `title`     v = `Popover Title`
        )->a( n = `placement` v = mv_placement
        )->ele( `List`
            )->a( n = `items`           v = client->_bind( mt_tab )
            )->a( n = `mode`            v = `SingleSelectMaster`
            )->a( n = `selectionChange` v = client->_event( val = `SEL_CHANGE` )
            )->tag( `StandardListItem`
                )->a( n = `title`       v = `{ID}`
                )->a( n = `description` v = `{NAME}`
                )->a( n = `selected`    v = `{SELECTED}` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popover - Select from a List`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Opens a Popover anchored to a button, showing a selectable list inside it; the ` &&
                   `segmented button chooses on which side the popover appears.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Popover`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `Input`
            )->tag( `Label`
                )->a( n = `text` v = `Link`
            )->tag( `Link`
                )->a( n = `text` v = `Documentation UI5 Popover Control`
                )->a( n = `href` v = `https://openui5.hana.ondemand.com/entity/sap.m.Popover`
            )->tag( `Label`
                )->a( n = `text` v = `placement`
            )->ele( `SegmentedButton`
                )->a( n = `selectedKey` v = client->_bind( mv_placement )
                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://add-favorite`
                        )->a( n = `key`  v = `Left`
                        )->a( n = `text` v = `Left`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://accept`
                        )->a( n = `key`  v = `Top`
                        )->a( n = `text` v = `Top`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://accept`
                        )->a( n = `key`  v = `Bottom`
                        )->a( n = `text` v = `Bottom`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://attachment`
                        )->a( n = `key`  v = `Right`
                        )->a( n = `text` v = `Right`
                )->end(
            )->end(
            )->tag( `Label`
                )->a( n = `text` v = `popover`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPOVER_LIST` )
                )->a( n = `text`  v = `show popover with list`
                )->a( n = `id`    v = `TEST` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SEL_CHANGE`.
        DATA(lt_sel) = mt_tab.
        DELETE lt_sel WHERE selected IS INITIAL.

      WHEN `POPOVER_LIST`.
        popover_list_display( `TEST` ).

      WHEN `POPOVER`.
        popover_display( `TEST` ).

      WHEN `BUTTON_CONFIRM`.
        client->message_toast_display( |confirm| ).
        client->popover_destroy( ).

      WHEN `BUTTON_CANCEL`.
        client->message_toast_display( |cancel| ).
        client->popover_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD on_init.

    mv_placement = `Left`.
    product      = `tomato`.
    quantity     = `500`.

    mt_tab = VALUE #(
                      ( id = `1` name = `name1` )
                      ( id = `2` name = `name2` )
                      ( id = `3` name = `name3` )
                      ( id = `4` name = `name4` ) ).

  ENDMETHOD.

ENDCLASS.
