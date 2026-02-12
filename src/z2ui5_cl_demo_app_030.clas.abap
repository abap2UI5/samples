CLASS z2ui5_cl_demo_app_030 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_030 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mt_tab = VALUE #(
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `incompleted` descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
            ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN `BUTTON_ROUNDTRIP`.
        DATA(lv_dummy) = `user pressed a button, your custom implementation can be called here`.
      WHEN `BUTTON_MSG_BOX`.
        client->message_box_display(
          text = `this is a message box with a custom text`
          type = `success` ).
    ENDCASE.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->dynamic_page(
        showfooter = abap_true
       "  headerExpanded = abap_true
      "   toggleHeaderOnTitleClick = client->_event( 'ON_TITLE' )
      ).

    DATA(lo_header_title) = lo_page->title( ns = `f` )->get( )->dynamic_page_title( ).

    lo_header_title->heading( ns = `f` )->title( `Header Title` ).

    lo_header_title->expanded_content( `f`
             )->label( text = `this is a subheading` ).

    lo_header_title->snapped_content( ns = `f`
             )->label( text = `this is a subheading` ).

    lo_header_title->actions( ns = `f` )->overflow_toolbar(
         )->overflow_toolbar_button(
             icon    = `sap-icon://edit`
             text    = `edit header`
             type    = `Emphasized`
             tooltip = `edit`
         )->overflow_toolbar_button(
             icon    = `sap-icon://pull-down`
             text    = `show section`
             type    = `Emphasized`
             tooltip = `pull-down`
         )->overflow_toolbar_button(
             icon    = `sap-icon://show`
             text    = `show state`
             tooltip = `show`
         )->button(
            " icon = `sap-icon://edit`
             text  = `Go Back`
             press = client->_event_nav_app_leave( ) ).

    lo_header_title->navigation_actions(
            )->button( icon = `sap-icon://full-screen`
                       type = `Transparent`
            )->button( icon = `sap-icon://exit-full-screen`
                       type = `Transparent`
            )->button( icon = `sap-icon://decline`
                       type = `Transparent` ).

    lo_page->header( )->dynamic_page_header( pinnable = abap_true
        )->horizontal_layout(
            )->vertical_layout(
                   )->object_attribute( title = `Location`
                                        text  = `Warehouse A`
                   )->object_attribute( title = `Halway`
                                        text  = `23L`
                   )->object_attribute( title = `Rack`
                                        text  = `34`
             )->get_parent(
               )->vertical_layout(
                    )->object_attribute( title = `Location`
                                         text  = `Warehouse A`
                    )->object_attribute( title = `Halway`
                                         text  = `23L`
                    )->object_attribute( title = `Rack`
                                         text  = `34`
             )->get_parent(
              )->vertical_layout(
                   )->object_attribute( title = `Location`
                                        text  = `Warehouse A`
                   )->object_attribute( title = `Halway`
                                        text  = `23L`
                   )->object_attribute( title = `Rack`
                                        text  = `34` ).

    DATA(lo_cont) = lo_page->content( ns = `f` ).

    lo_cont->list(
         headertext = `List Ouput`
         items      = client->_bind( mt_tab )
         )->standard_list_item(
             title       = `{TITLE}`
             description = `{DESCR}`
             icon        = `{ICON}`
             info        = `{INFO}` ).

    lo_page->footer( ns = `f` )->overflow_toolbar(
             )->overflow_toolbar_button(
                 icon    = `sap-icon://edit`
                 text    = `edit header`
                 type    = `Emphasized`
                 tooltip = `edit`
             )->overflow_toolbar_button(
                 icon    = `sap-icon://pull-down`
                 text    = `show section`
                 type    = `Emphasized`
                 tooltip = `pull-down` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
