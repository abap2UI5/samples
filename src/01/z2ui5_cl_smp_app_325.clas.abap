" @keywords clipboard paste copy text area
CLASS z2ui5_cl_smp_app_325 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input TYPE string.
    DATA text TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_325 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`
              )->a( n = `xmlns:uxap`   v = `sap.uxap` ).
      DATA(page) = view->ele( `Shell`
          )->ele( `Page`
              )->a( n = `title`          v = `abap2UI5 - Browser - Copy to Clipboard`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `Copy the input field or text-area content to the system clipboard via the clipboard_copy follow-up action.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiSmallMargin` ).

      DATA(obj_page) = page->ele( n = `ObjectPageLayout` ns = `uxap`
          )->a( n = `showTitleInHeaderContent` b = abap_true
          )->a( n = `showEditHeaderButton`     b = abap_true
          )->a( n = `upperCaseAnchorBar`       b = abap_false ).

      DATA(header_title) = obj_page->ele( n = `headerTitle` ns = `uxap`
          )->ele( n = `ObjectPageDynamicHeaderTitle` ns = `uxap` ).

      header_title->ele( n = `expandedHeading` ns = `uxap`
          )->ele( `HBox`
              )->tag( `Title`
                  )->a( n = `text`     v = `Test`
                  )->a( n = `wrapping` b = abap_true ).
      header_title->ele( n = `snappedHeading` ns = `uxap`
          )->ele( `FlexBox`
              )->a( n = `alignItems` v = `Center`
              )->tag( `Title`
                  )->a( n = `text`     v = `Test`
                  )->a( n = `wrapping` b = abap_true ).

      DATA(sections) = obj_page->ele( n = `sections` ns = `uxap` ).

      sections->ele( n = `ObjectPageSection` ns = `uxap`
          )->a( n = `titleUppercase` b = abap_false
          )->a( n = `title`          v = `...`
          )->a( n = `id`             v = `id_sec1`
          )->ele( n = `subSections` ns = `uxap`
              )->ele( n = `ObjectPageSubSection` ns = `uxap`
                  )->a( n = `id`    v = `id_input`
                  )->a( n = `title` v = `Input field`
                  )->ele( n = `blocks` ns = `uxap`
                      )->ele( `VBox`
                          )->tag( `Input`
                              )->a( n = `value` v = client->_bind( input )
                              )->a( n = `width` v = `50%`
                          )->tag( `Button`
                              )->a( n = `press` v = client->_event( `COPY_INPUT` )
                              )->a( n = `text`  v = `Copy input`
                              )->a( n = `type`  v = `Emphasized` ).

      sections->ele( n = `ObjectPageSection` ns = `uxap`
          )->a( n = `titleUppercase` b = abap_false
          )->a( n = `title`          v = `...`
          )->a( n = `id`             v = `id_sec2`
          )->ele( n = `subSections` ns = `uxap`
              )->ele( n = `ObjectPageSubSection` ns = `uxap`
                  )->a( n = `id`    v = `id_text_area`
                  )->a( n = `title` v = `Text area`
                  )->ele( n = `blocks` ns = `uxap`
                      )->ele( `VBox`
                          )->tag( `Button`
                              )->a( n = `press` v = client->_event( `COPY_TEXT_AREA` )
                              )->a( n = `text`  v = `Copy text area`
                              )->a( n = `type`  v = `Emphasized`
                          )->tag( `TextArea`
                              )->a( n = `value`           v = client->_bind( text )
                              )->a( n = `rows`            v = `15`
                              )->a( n = `width`           v = `100%`
                              )->a( n = `valueLiveUpdate` b = abap_true
                              )->a( n = `editable`        b = abap_true
                              )->a( n = `id`              v = `text_id`
                              )->a( n = `growing`         b = abap_true
                              )->a( n = `growingMaxLines` v = `50` ).

      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get_event( ).
      WHEN `COPY_INPUT`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-clipboard_copy
            t_arg = VALUE #( ( input ) ) ).
        client->message_toast_display( |input field copied: { input }| ).

      WHEN `COPY_TEXT_AREA`.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-clipboard_copy
            t_arg = VALUE #( ( text ) ) ).
        client->message_toast_display( |text area copied: { text }| ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
