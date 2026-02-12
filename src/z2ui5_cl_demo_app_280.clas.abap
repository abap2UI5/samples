CLASS z2ui5_cl_demo_app_280 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_280 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Header Container - Vertical Mode`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.HeaderContainer/sample/sap.m.sample.HeaderContainerVM` ).

    lo_page->header_container( scrollstep  = `124`
                            scrolltime  = `500`
                            orientation = `Vertical`
                            height      = `400px`
         )->numeric_content( scale      = `M`
                             value      = `1.75`
                             valuecolor = `Good`
                             indicator  = `Up`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `0.57`
                             valuecolor = `Error`
                             indicator  = `Down`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `1.04`
                             valuecolor = `Neutral`
                             indicator  = `Up`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `3.65`
                             valuecolor = `Good`
                             indicator  = `Up`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `0.73`
                             valuecolor = `Error`
                             indicator  = `Down`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `1.01`
                             valuecolor = `Critical`
                             indicator  = `Down`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `1.42`
                             valuecolor = `Good`
                             indicator  = `Up`
                             press      = mo_client->_event( `PRESS` ) )->get_parent(
         )->numeric_content( scale      = `M`
                             value      = `0.21`
                             valuecolor = `Error`
                             indicator  = `Down`
                             press      = mo_client->_event( `PRESS` ) )->get_parent( )->get_parent(
       )->header_container( scrollstep  = `200`
                            orientation = `Vertical`
                            height      = `400px`
         )->tile_content( unit   = `EUR`
                          footer = `Current Quarter`
           )->content(
             )->numeric_content( value      = `1.96`
                                 valuecolor = `Error`
                                 indicator  = `Down`
                                 press      = mo_client->_event( `PRESS` ) )->get_parent( )->get_parent( )->get_parent(
         )->tile_content( footer = `Leave Requests`
           )->content(
             )->numeric_content( value = `35`
                                 icon  = `sap-icon://travel-expense` )->get_parent( )->get_parent( )->get_parent(
         )->tile_content( footer = `Hours since last Activity`
           )->content(
             )->numeric_content( value = `9`
                                 icon  = `sap-icon://horizontal-bar-chart` )->get_parent( )->get_parent( )->get_parent(
         )->tile_content( unit   = `EUR`
                          footer = `Current Quarter`
           )->content(
             )->numeric_content( scale     = `M`
                                 value     = `88`
                        valuecolor         = `Good`
                                 indicator = `Up` )->get_parent( )->get_parent( )->get_parent(
         )->tile_content( unit   = `Unit`
                          footer = `Footer Text`
           )->content(
             )->numeric_content( value = `1522`
                                 icon  = `sap-icon://bubble-chart` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `PRESS`.
        mo_client->message_toast_display( `Fire press` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The Header Container with a vertical layout and with divider lines.` ).

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
