class Z2UI5_CL_DEMO_APP_256 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_256 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(css) = `.fixFlexFixedSize > .sapUiFixFlexFixed {`      &&
                `    background: #D7E9FF;`                      &&
                `}`                                             &&

                `.fixFlexFixedSize > .sapUiFixFlexFlexible {`   &&
                `    background: #A9CFFF;`                      &&
                `}`                                             &&

                `.fixFlexFixedSize .sapMText {`                 &&
                `    margin-bottom: 1rem;`                      &&
                `}`.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( name = `style` ns = `html` )->_cc_plain_xml( css )->get_parent( ).

    DATA(page) = view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Fix Flex - Fix container size`
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'POPOVER' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexFixedSize' ).

    DATA(layout) = page->fix_flex( ns = `layout` class = `fixFlexFixedSize` fixContentSize = `150px`
                         )->fix_content( ns = `layout`
                                )->scroll_container( height = `100%` vertical = abap_true
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
                                    )->text( class = `column1` text = `This container is flexible and it will adapt its size to fill the remaining size in the FixFlex control`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `Shows a FixFlex control where fixContentSize is set to a specific value(150px) and sap.m.scrollContainer is enabling vertical scrolling.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
