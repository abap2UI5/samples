CLASS z2ui5_cl_demo_app_205 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_205 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flex Box - Basic Alignment`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vbox(
                   )->panel( headertext = `Upper left`
                   )->flex_box( height         = `100px`
                                alignitems     = `Start`
                                justifycontent = `Start`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Upper center`
                   )->flex_box( height         = `100px`
                                alignitems     = `Start`
                                justifycontent = `Center`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Upper right`
                   )->flex_box( height         = `100px`
                                alignitems     = `Start`
                                justifycontent = `End`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Middle left`
                   )->flex_box( height         = `100px`
                                alignitems     = `Center`
                                justifycontent = `Start`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Middle center`
                   )->flex_box( height         = `100px`
                                alignitems     = `Center`
                                justifycontent = `Center`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Middle right`
                   )->flex_box( height         = `100px`
                                alignitems     = `Center`
                                justifycontent = `End`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Lower left`
                   )->flex_box( height         = `100px`
                                alignitems     = `End`
                                justifycontent = `Start`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Lower center`
                   )->flex_box( height         = `100px`
                                alignitems     = `End`
                                justifycontent = `Center`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` )->get_parent( )->get_parent(
                   )->panel( headertext = `Lower right`
                   )->flex_box( height         = `100px`
                                alignitems     = `End`
                                justifycontent = `End`
                              )->button( text  = `1`
                                         type  = `Emphasized`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text  = `2`
                                         type  = `Reject`
                                         class = `sapUiSmallMarginEnd`
                              )->button( text = `3`
                                         type = `Accept` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
