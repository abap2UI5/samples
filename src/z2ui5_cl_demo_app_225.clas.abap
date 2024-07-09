class Z2UI5_CL_DEMO_APP_225 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_225 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Icon Tab Bar - Separator'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->label( wrapping = `true`
                                text = `No icon(='') used as separator, the separator will be a vertical line.`
                                class = `sapUiSmallMargin` ).

    layout->icon_tab_bar( id = `idIconTabBarSeparatorNoIcon`
                          expanded = `false`
                          class = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( key = `info`
                                                  icon = `sap-icon://hint`
                                                  iconcolor = `Neutral`
                                                  )->text( text = `Info content goes here ...` )->get_parent(
                              )->icon_tab_separator( icon = `` )->get_parent(
                              )->icon_tab_filter( key = `attachments`
                                                  icon = `sap-icon://attachment`
                                                  iconcolor = `Neutral`
                                                  count = `3`
                                                  )->text( text = `Attachments go here ...` )->get_parent(
                              )->icon_tab_filter( key = `notes`
                                                  icon = `sap-icon://notes`
                                                  count = `12`
                                                  )->text( text = `Notes go here ...` )->get_parent(
                              )->icon_tab_separator( icon = `` )->get_parent(
                              )->icon_tab_filter( key = `people`
                                                  icon = `sap-icon://group`
                                                  iconcolor = `Negative`
                                                  )->text( text = `People content goes here ...`
                   ).

    layout->label( wrapping = `true`
                                text = `Icon used as separator, you are free to choose an icon you want.`
                                class = `sapUiSmallMargin` ).

    layout->icon_tab_bar( id = `idIconTabBarSeparatorIcon`
                          expanded = `false`
                          class = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( key = `info`
                                                  icon = `sap-icon://hint`
                                                  iconcolor = `Neutral`
                                                  )->text( text = `Info content goes here ...` )->get_parent(
                              )->icon_tab_filter( key = `attachments`
                                                  icon = `sap-icon://attachment`
                                                  iconcolor = `Neutral`
                                                  count = `3`
                                                  )->text( text = `Attachments go here ...` )->get_parent(
                              )->icon_tab_separator( icon = `sap-icon://process` )->get_parent(
                              )->icon_tab_filter( key = `notes`
                                                  icon = `sap-icon://notes`
                                                  iconcolor = `Positive`
                                                  count = `12`
                                                  )->text( text = `Notes go here ...` )->get_parent(
                              )->icon_tab_separator( icon = `sap-icon://process` )->get_parent(
                              )->icon_tab_filter( key = `people`
                                                  icon = `sap-icon://group`
                                                  iconcolor = `Negative`
                                                  )->text( text = `People content goes here ...`
                   ).

    layout->label( wrapping = `true`
                                text = `Different separators used.`
                                class = `sapUiSmallMargin` ).

    layout->icon_tab_bar( id = `idIconTabBarSeparatorMixed`
                          expanded = `false`
                          class = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( key = `info`
                                                  icon = `sap-icon://hint`
                                                  iconcolor = `Critical`
                                                  )->text( text = `Info content goes here ...` )->get_parent(
                              )->icon_tab_separator( icon = `` )->get_parent(
                              )->icon_tab_filter( key = `info`
                                                  icon = `sap-icon://attachment`
                                                  iconcolor = `Neutral`
                                                  count = `3`
                                                  )->text( text = `Attachments go here ...` )->get_parent(
                              )->icon_tab_separator( icon = `sap-icon://vertical-grip` )->get_parent(
                              )->icon_tab_filter( key = `notes`
                                                  icon = `sap-icon://notes`
                                                  iconcolor = `Positive`
                                                  count = `12`
                                                  )->text( text = `Notes go here ...` )->get_parent(

                              )->icon_tab_separator( icon = `sap-icon://process` )->get_parent(
                              )->icon_tab_filter( key = `people`
                                                  icon = `sap-icon://group`
                                                  iconcolor = `Negative`
                                                  )->text( text = `People content goes here ...`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
