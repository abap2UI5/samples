CLASS z2ui5_cl_demo_app_237 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_237 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Slider`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
                                     )->header_content(
                             )->button( id      = `hint_icon`
                                        icon    = `sap-icon://hint`
                                        tooltip = `Sample information`
                                        press   = client->_event( `POPOVER` )
                             )->get_parent( ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%`
                          )->text( text  = `Slider without text field`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( value = `30`
                                         width = `90%`
                                         class = `sapUiSmallMarginBottom`
                              )->slider( value = `27`
                                         width = `10em`
                                         class = `sapUiSmallMarginBottom`
                              )->slider( value = `40`
                                         width = `15em`
                                         class = `sapUiSmallMarginBottom`
                              )->slider( value = `9`
                                         width = `77%`
                                         min   = `0`
                                         max   = `10`
                                         class = `sapUiSmallMarginBottom`
                          )->text( text  = `Slider whose value cannot be changed`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( value   = `5`
                                         width   = `66%`
                                         min     = `0`
                                         max     = `50`
                                         enabled = abap_false
                                         class   = `sapUiSmallMarginBottom`
                          )->text( text  = `Slider with text field`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( value               = `50`
                                         width               = `100%`
                                         min                 = `0`
                                         max                 = `100`
                                         showadvancedtooltip = abap_true
                                         inputsastooltips    = abap_false
                                         class               = `sapUiMediumMarginBottom`
                          )->text( text  = `Slider with input field`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( value               = `30`
                                         width               = `100%`
                                         min                 = `0`
                                         max                 = `200`
                                         showadvancedtooltip = abap_true
                                         showhandletooltip   = abap_false
                                         inputsastooltips    = abap_true
                                         class               = `sapUiMediumMarginBottom`
                          )->text( text  = `Slider with tickmarks`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( enabletickmarks = abap_true
                                         min             = `0`
                                         max             = `10`
                                         class           = `sapUiMediumMarginBottom`
                                         width           = `100%`
                              )->slider( enabletickmarks = abap_true
                                         class           = `sapUiMediumMarginBottom`
                                         width           = `100%`
                          )->text( text  = `Slider with tickmarks and step '5'`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( enabletickmarks = abap_true
                                         min             = `-100`
                                         max             = `100`
                                         step            = `5`
                                         class           = `sapUiMediumMarginBottom`
                                         width           = `100%`
                          )->text( text  = `Slider with tickmarks and labels`
                                   class = `sapUiSmallMarginBottom`
                              )->slider( min             = `0`
                                         max             = `30`
                                         enabletickmarks = abap_true
                                         class           = `sapUiMediumMarginBottom`
                                         width           = `100%` )->get(
                                  )->responsive_scale( tickmarksbetweenlabels = `3` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `POPOVER` ).
      popover_display( `hint_icon` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `With the Slider a user can choose a value from a numerical range.`
                                  )->get_parent( ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
