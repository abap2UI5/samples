CLASS z2ui5_cl_demo_app_268 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_268 IMPLEMENTATION.

  METHOD display_view.

    DATA(lv_css) = `.size1 {`                    &&
                `  font-size : 1.5rem;`       &&
                `}`                           &&
                `.size2 {`                    &&
                `  font-size : 2.5rem;`       &&
                `}`                           &&
                `.size3 {`                    &&
                `  font-size : 5rem;`         &&
                `}`                           &&
                `.size4 {`                    &&
                `  font-size : 7.5rem;`       &&
                `}`                           &&
                `.size5 {`                    &&
                `  font-size : 10rem;`        &&
                `}`                           &&
      `@media (max-width:599px) {`  &&
                ` .size1 {`                   &&
                `   font-size : 1rem;`        &&
                ` }`                          &&
                ` .size2 {`                   &&
                `   font-size : 2rem;`        &&
                `}`                           &&
                ` .size3 {`                   &&
                `   font-size : 3rem;`        &&
                ` }`                          &&
                ` .size4 {`                   &&
                `   font-size : 4rem;`        &&
                ` }`                          &&
                ` .size5 {`                   &&
                `   font-size : 5rem;`        &&
                ` }`                          &&
                `}`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( lv_css )->get_parent( ).

    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Icon`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.Icon/sample/sap.ui.core.sample.Icon` ).

    lo_page->hbox( class = `sapUiSmallMargin`
           )->icon(
               src   = `sap-icon://syringe`
               class = `size1`
               color = `#031E48` )->get(
               )->layout_data( ns = `core`
                   )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
           )->icon(
               src   = `sap-icon://pharmacy`
               class = `size2`
               color = `#64E4CE` )->get(
               )->layout_data( ns = `core`
                   )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
           )->icon(
               src   = `sap-icon://electrocardiogram`
               class = `size3`
               color = `#E69A17` )->get(
               )->layout_data( ns = `core`
                   )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
           )->icon(
               src   = `sap-icon://doctor`
               class = `size4`
               color = `#1C4C98` )->get(
               )->layout_data( ns = `core`
                   )->flex_item_data( growfactor = `1` )->get_parent( )->get_parent(
           )->icon(
               src   = `sap-icon://stethoscope`
               class = `size5`
               color = `#8875E7`
               press = mo_client->_event( `handleStethoscopePress` ) )->get(
               )->layout_data( ns = `core`
                   )->flex_item_data( growfactor = `1` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `handleStethoscopePress`.
        mo_client->message_toast_display( `Over budget!` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Built with an embedded font, icons scale well, and can be altered with CSS. ` &&
                                                `They can also fire a press event. See the Icon Explorer for more icons.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
