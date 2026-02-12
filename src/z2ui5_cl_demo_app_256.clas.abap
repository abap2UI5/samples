CLASS z2ui5_cl_demo_app_256 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_256 IMPLEMENTATION.

  METHOD display_view.

    DATA(lv_css) = `.fixFlexFixedSize > .sapUiFixFlexFixed {`      &&
                `    background: #D7E9FF;`                      &&
                `}`                                             &&
      `.fixFlexFixedSize > .sapUiFixFlexFlexible {`   &&
                `    background: #A9CFFF;`                      &&
                `}`                                             &&
      `.fixFlexFixedSize .sapMText {`                 &&
                `    margin-bottom: 1rem;`                      &&
                `}`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( lv_css )->get_parent( ).

    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Fix Flex - Fix container size`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `hint_icon`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `POPOVER` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexFixedSize` ).

    DATA(lo_layout) = lo_page->fix_flex( ns             = `layout`
                                   class          = `fixFlexFixedSize`
                                   fixcontentsize = `150px`
                         )->fix_content( ns = `layout`
                                )->scroll_container( height   = `100%`
                                                     vertical = abap_true
                                    )->text( text = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. `                                 &&
                                                    `Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley `      &&
                                                    `of type and scrambled it to make a type specimen book. `                                                                   &&
                                                    `It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ` &&
                                                    `It was popularised in the 1960s with the release of Letraset sheets containing.`
                                    )->text( text = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. `                                 &&
                                                    `Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley `      &&
                                                    `of type and scrambled it to make a type specimen book. `                                                                   &&
                                                    `It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ` &&
                                                    `It was popularised in the 1960s with the release of Letraset sheets containing.`
                                    )->text( text = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. `                                 &&
                                                    `Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley `      &&
                                                    `of type and scrambled it to make a type specimen book. `                                                                   &&
                                                    `It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ` &&
                                                    `It was popularised in the 1960s with the release of Letraset sheets containing.`
                                    )->text( text = `Fix content - Lorem Ipsum is simply dummy text of the printing and typesetting industry. `                                 &&
                                                    `Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley `      &&
                                                    `of type and scrambled it to make a type specimen book. `                                                                   &&
                                                    `It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ` &&
                                                    `It was popularised in the 1960s with the release of Letraset sheets containing.` )->get_parent( )->get_parent(
                         )->flex_content( ns = `layout`
                                    )->text( class = `column1`
                                             text  = `This container is flexible and it will adapt its size to fill the remaining size in the FixFlex control` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `POPOVER` ).
      display_popover( `hint_icon` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Shows a FixFlex control where fixContentSize is set to a specific value(150px) and sap.m.scrollContainer is enabling vertical scrolling.` ).

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
