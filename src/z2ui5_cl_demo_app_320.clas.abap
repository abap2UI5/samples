CLASS z2ui5_cl_demo_app_320 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA viewportpercentwidth TYPE i VALUE 100.

    TYPES: BEGIN OF ty_item,
             id           TYPE string,
             initials     TYPE string,
             fallbackicon TYPE string,
             src          TYPE string,
             name         TYPE string,
             tooltip      TYPE string,
             jobposition  TYPE string,
             mobile       TYPE string,
             phone        TYPE string,
             email        TYPE string,
           END OF ty_item.
    TYPES ty_items TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY.

    DATA item           TYPE ty_item.
    DATA items          TYPE ty_items.
    DATA group_items    TYPE ty_items.
    DATA content_height TYPE string.
    DATA content_width  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_avatar_group_view.

    METHODS display_individual_popover
      IMPORTING !id TYPE string.

    METHODS display_group_popover
      IMPORTING !id TYPE string.

    METHODS on_event.

  PRIVATE SECTION.
    METHODS calculate_content_height
      IMPORTING !lines        TYPE i
      RETURNING VALUE(result) TYPE string.

ENDCLASS.


CLASS z2ui5_cl_demo_app_320 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    me->client = client.

    IF client->check_on_init( ).

      items = VALUE #(
          mobile = `+89181818181`
          phone  = `+2828282828`
          email  = `blabla@blabla`
          ( id = `1` initials = `JD` name = `John Doe` tooltip = `1` jobposition = `Marketing Manager` )
          ( id = `2` initials = `SP` name = `Sarah Parker` tooltip = `2` jobposition = `Visual Designer` )
          ( id = `3` initials = `JG` name = `Jason Goldwell` tooltip = `3` jobposition = `Software Developer` )
          ( id = `4` name = `Christian Bow` jobposition = `Marketing Manager` tooltip = `4` )
          ( id          = `5`
            src         = `https://sapui5.hana.ondemand.com/test-resources/sap/f/images/Woman_avatar_01.png`
            tooltip     = `5`
            name        = `Jessica Parker`
            jobposition = `Visual Designer` )
          ( id = `6` initials = `JB` name = `Jonathan Bale` jobposition = `Software Developer` tooltip = `6` )
          ( id = `7` initials = `GS` name = `Gordon Smith` jobposition = `Marketing Manager` tooltip = `7` )
          ( id = `8` fallbackicon = `sap-icon =//person-placeholder` name = `Simon Jason` tooltip = `8` jobposition = `Visual Designer` )
          ( id = `9` initials = `JS` name = `Jason Swan` jobposition = `Software Developer` tooltip = `9` )
          ( id = `10` initials = `JC` name = `John Carter` jobposition = `Marketing Manager` tooltip = `10` )
          ( id          = `11`
            src         = `https://sapui5.hana.ondemand.com/test-resources/sap/f/images/Woman_avatar_02.png`
            name        = `Whitney Parker`
            tooltip     = `11`
            jobposition = `Visual Designer` )
          ( id = `12` fallbackicon = `sap-icon =//person-placeholder` name = `Jason Goldwell` tooltip = `12` jobposition = `Software Developer` )
          ( id = `13` initials = `CD` name = `Chris Doe` jobposition = `Marketing Manager` tooltip = `13` )
          ( id = `14` initials = `SS` name = `Sarah Smith` jobposition = `Visual Designer` tooltip = `14` )
          ( id = `15` initials = `DC` name = `David Copper` jobposition = `Software Developer` tooltip = `15` ) ).
      display_avatar_group_view( ).
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD display_avatar_group_view.
    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_z2ui5( )->title( `Avatar Group Sample` ).
    view->page( title          = 'abap2UI5 - Sample: Avatar Group'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        )->slider( value = client->_bind_edit( viewportpercentwidth )
            )->vertical_layout( id    = `vl1`
                                width = |{ client->_bind_edit( viewportpercentwidth ) }%|
                                class = `sapUiContentPadding`
                )->label( text  = `AvatarGroup control in Individual mode`
                          class = `sapUiSmallMarginBottom sapUiMediumMarginTop`
                )->avatar_group(
                    id                = `avatarGroup1`
                    grouptype         = `Individual`
                    avatardisplaysize = `S`
                    press             = client->_event(
                                            val   = `onIndividualPress`
                                            t_arg = VALUE #(
                                                ( `${$source>/id}` )
                                                ( `${$parameters>/groupType}` )
                                                ( `${$parameters>/overflowButtonPressed}` )
                                                ( `${$parameters>/avatarsDisplayed}` )
                                                ( `$event.getParameter("eventSource").getId()` )
                                                ( `$event.oSource.indexOfItem($event.getParameter("eventSource"))` ) ) )

                    items             = client->_bind( items )
                    )->avatar_group_item( initials     = `{INITIALS}`
                                          fallbackicon = `{FALLBACKICON}`
                                          src          = `{SRC}`
                                          tooltip      = `{NAME}`

                )->get_parent(

                )->label( text  = `AvatarGroup control in Group mode`
                          class = `sapUiSmallMarginBottom sapUiMediumMarginTop`
                )->avatar_group( id                = `avatarGroup2`
                                 grouptype         = `Group`
                                 tooltip           = `Avatar Group`
                                 avatardisplaysize = `M`
                                 press             = client->_event( val   = `onGroupPress`
                                                                     t_arg = VALUE #(
                                                                         ( `${$source>/id}` )
                                                                         ( `${$parameters>/groupType}` )
                                                                         ( `${$parameters>/overflowButtonPressed}` )
                                                                         ( `${$parameters>/avatarsDisplayed}` ) ) )
                                 items             = client->_bind( items )
                    )->avatar_group_item( initials     = `{INITIALS}`
                                          fallbackicon = `{FALLBACKICON}`
                                          src          = `{SRC}` ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  METHOD display_individual_popover.
    DATA(individual_popover) = z2ui5_cl_xml_view=>factory_popup( ).
    individual_popover->popover( id             = `individualPopover`
                                 class          = `sapFAvatarGroupPopover`
                                 title          = `Business card`
                                 titlealignment = `Center`
                                 placement      = `Bottom`
                                 contentwidth   = `250px`
                                 contentheight  = `332px`
        )->card(
            )->content( ns = `f`
                )->vertical_layout( class = `sapUiContentPadding`
                    )->hbox( alignitems = `Center`
                        )->avatar( src          = client->_bind( item-src )
                                   initials     = client->_bind( item-initials )
                                   badgetooltip = client->_bind( item-tooltip )
                                   fallbackicon = client->_bind( item-fallbackicon )
                        )->vbox( class = `sapUiTinyMarginBegin`
                            )->title( text = client->_bind_local( item-name )
                            )->text( text = client->_bind_local( item-jobposition )
                        )->get_parent(
                    )->get_parent(
                    )->title( text = `Contact Details`
                    )->label( text = `Mobile`
                    )->text( text = client->_bind( item-mobile )
                    )->label( text = `Phone`
                    )->text( text = client->_bind( item-phone )
                    )->label( text = `Email`
                    )->text( text = client->_bind( item-email ) ).

    client->popover_display( xml   = individual_popover->stringify( )
                             by_id = id ).
  ENDMETHOD.

  METHOD display_group_popover.
    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(nav_container) = view->popover( id            = `groupPopover`
                                         class         = `sapFAvatarGroupPopover`
                                         showheader    = abap_false
                                         contentwidth  = client->_bind( content_width )
                                         contentheight = client->_bind( content_height )
                                         placement     = `Bottom`
        )->nav_container( id = `navContainer` ).

    nav_container->page( id             = `main`
                         titlealignment = `Center`
                         title          = |Team Members ({ lines( group_items ) })|
                )->vertical_layout( class = `sapUiTinyMarginTop`
                                    width = `100%`
                    )->grid( default_span = `XL6 L6 M6 S12`
                             content      = client->_bind( group_items )

                        )->hbox( alignitems = `Center`
                            )->vbox(
                                )->avatar( class           = `sapUiTinyMarginEnd`
                                           initials        = `{INITIALS}`
                                           fallbackicon    = `{FALLBACKICON}`
                                           src             = `{SRC}`
                                           badgetooltip    = `{NAME}`
                                           backgroundcolor = `{BACKGROUNDCOLOR}`
                                           press           = client->_event( val   = `onAvatarPress`
                                                                             t_arg = VALUE #( ( `${ID}` ) ) )
                            )->get_parent(
                            )->vbox(
                                )->text( text = `{NAME}`
                                )->text( text = `{JOBPOSITION}` ).

    nav_container->page( id             = `detail`
                         shownavbutton  = abap_true
                         navbuttonpress = client->_event( val = `onNavBack` )
                         titlealignment = `Center`
                         title          = |Team Members ({ lines( group_items ) })|
        )->card(
            )->content( ns = `f`
                )->vertical_layout( class = `sapUiContentPadding`
                    )->hbox( alignitems = `Center`
                        )->avatar( src          = client->_bind( item-src )
                                   initials     = client->_bind( item-initials )
                                   badgetooltip = client->_bind( item-tooltip )
                                   fallbackicon = client->_bind( item-fallbackicon )
                        )->vbox( class = `sapUiTinyMarginBegin`
                            )->title( text = client->_bind( item-name )
                            )->text( text = client->_bind( item-jobposition )
                        )->get_parent(
                    )->get_parent(
                    )->title( text = `Contact Details`
                    )->label( text = `Mobile`
                    )->text( text = client->_bind( item-mobile )
                    )->label( text = `Phone`
                    )->text( text = client->_bind( item-phone )
                    )->label( text = `Email`
                    )->text( text = client->_bind( item-email ) ).

    client->popover_display( xml   = view->stringify( )
                             by_id = id ).
  ENDMETHOD.

  METHOD on_event.
    DATA(lt_arg) = client->get( )-t_event_arg.
    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).

      WHEN `onGroupPress`.
        DATA(group_id) = lt_arg[ 1 ].
        group_items = items.
        content_height = calculate_content_height( lines( group_items ) ).
        content_width = '450px'.

        display_group_popover( id = group_id ).
        client->popover_destroy( ).

      WHEN `onIndividualPress`.
        DATA(overflow_button_pressed) = lt_arg[ 3 ].
        DATA(items_displayed) = lt_arg[ 4 ].
        DATA(item_id) = lt_arg[ 5 ].
        DATA(item_table_index) = lt_arg[ 6 ].

        group_items = VALUE ty_items( FOR itm IN items FROM items_displayed + 1
                                      ( itm ) ).
        content_height = calculate_content_height( lines( group_items ) ).
        content_width = '450px'.

        IF overflow_button_pressed = abap_true.
          display_group_popover( id = item_id ).
        ELSE.
          item = VALUE #( items[ item_table_index + 1 ] OPTIONAL ).
          display_individual_popover( id = item_id ).
        ENDIF.
        client->popover_destroy( ).

      WHEN `onAvatarPress`.
        DATA(id) = lt_arg[ 1 ].
        item = VALUE #( items[ id = id ] OPTIONAL ).
        content_height = `370px`.
        content_width = `250px`.

        client->popover_model_update( ).
        client->follow_up_action( client->_event_client( val   = `POPOVER_NAV_CONTAINER_TO`
                                                         t_arg = VALUE #( ( `navContainer` ) ( `detail` ) ) ) ).
      WHEN `onNavBack`.
        content_height = calculate_content_height( lines( group_items ) ).
        content_width = `450px`.

        client->popover_model_update( ).
        client->follow_up_action( client->_event_client( val   = `POPOVER_NAV_CONTAINER_TO`
                                                         t_arg = VALUE #( ( `navContainer` ) ( `main` ) ) ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD calculate_content_height.
    DATA(lv_floor) = floor( ( lines / 2 ) ) * 68 + 48.
    DATA(lv_string) = CONV string( lv_floor ).
    result = |{ condense( lv_string ) }px|.
  ENDMETHOD.
ENDCLASS.
