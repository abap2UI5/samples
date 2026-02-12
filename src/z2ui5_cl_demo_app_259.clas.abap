CLASS z2ui5_cl_demo_app_259 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_259 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Button`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page_01->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Button/sample/sap.m.sample.Button` ).

    DATA(lo_page_02) = lo_page_01->page(
                              title = `Page`
                              class = `sapUiContentPadding`
                              )->custom_header(
                                  )->toolbar(
                                      )->button( type  = `Back`
                                                 press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                      )->toolbar_spacer(
                                      )->title( text  = `Title`
                                                level = `H2`
                                      )->toolbar_spacer(
                                      )->button( icon           = `sap-icon://edit`
                                                 type           = `Transparent`
                                                 press          = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                                 arialabelledby = `editButtonLabel`
                                  )->get_parent(
      )->get_parent(
                              )->sub_header(
                                  )->toolbar(
                                      )->toolbar_spacer(
                                      )->button( text  = `Default`
                                                 press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                      )->button( type  = `Reject`
                                                 text  = `Reject`
                                                 press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                      )->button( icon           = `sap-icon://action`
                                                 type           = `Transparent`
                                                 press          = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                                 arialabelledby = `actionButtonLabel`
                                      )->toolbar_spacer(
                                  )->get_parent(
      )->get_parent(
                              )->content(
                                  )->hbox(
                                      )->button( text            = `Default`
                                                 press           = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                                 ariadescribedby = `defaultButtonDescription genericButtonDescription`)->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
                                      )->button( type            = `Accept`
                                                 text            = `Accept`
                                                 press           = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                                 ariadescribedby = `acceptButtonDescription genericButtonDescription` )->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
                                      )->button( type            = `Reject`
                                                 text            = `Reject`
                                                 press           = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                                 ariadescribedby = `rejectButtonDescription genericButtonDescription` )->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
                                      )->button( text            = `Coming Soon`
                                                 press           = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                                 ariadescribedby = `comingSoonButtonDescription genericButtonDescription`
                                                 enabled         = abap_false )->get(
                                          )->layout_data(
                                              )->flex_item_data( growfactor = `1`
                                          )->get_parent(
                                      )->get_parent(
      )->get_parent(
" Collection of labels (some of which are invisible) used to provide ARIA descriptions for the buttons
                                  )->label( id   = `genericButtonDescription`
                                            text = `Note: The buttons in this sample display MessageToast when pressed.`
      )->invisible_text( ns   = `core`
                         id   = `defaultButtonDescription`
                         text = `Description of default button goes here.` )->get_parent(
                                  )->invisible_text( ns   = `core`
                                                     id   = `acceptButtonDescription`
                                                     text = `Description of accept button goes here.` )->get_parent(
                                  )->invisible_text( ns   = `core`
                                                     id   = `rejectButtonDescription`
                                                     text = `Description of reject button goes here.` )->get_parent(
                                  )->invisible_text( ns   = `core`
                                                     id   = `comingSoonButtonDescription`
                                                     text = `This feature is not active just now.` )->get_parent(
                                  " These labels exist only to provide targets for the ARIA label on the Edit and Action buttons
                                  )->invisible_text( ns   = `core`
                                                     id   = `editButtonLabel`
                                                     text = `Edit Button Label` )->get_parent(
                                  )->invisible_text( ns   = `core`
                                                     id   = `actionButtonLabel`
                                                     text = `Action Button Label` )->get_parent(
                              )->get_parent(
                              )->footer(
                                  )->toolbar(
                                      )->toolbar_spacer(
                                      )->button( type  = `Emphasized`
                                                 text  = `Emphasized`
                                                 press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                      )->button( text  = `Default`
                                                 press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) )
                                      )->button( icon  = `sap-icon://action`
                                                 type  = `Transparent`
                                                 press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/id}` ) ) ) )->get_parent(
                                  )->get_parent(
                              )->get_parent( ).

    mo_client->view_display( lo_page_02->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `ON_PRESS`.
        mo_client->message_toast_display( mo_client->get_event_arg( 1 ) && ` Pressed` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Buttons trigger user actions and come in a variety of shapes and colors. Placing a button on a page header or footer changes its appearance.` ).

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
