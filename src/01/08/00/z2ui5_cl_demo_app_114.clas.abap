CLASS z2ui5_cl_demo_app_114 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_feed,
        author    TYPE string,
        authorpic TYPE string,
        type      TYPE string,
        date      TYPE string,
        text      TYPE string,
      END OF ty_s_feed.
    DATA mt_feed TYPE TABLE OF ty_s_feed.
    DATA ms_feed TYPE ty_s_feed.
    DATA mv_value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_114 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      set_data( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE z2ui5_cl_demo_app_114=>ty_s_feed.

    IF client->check_on_event( `POST` ) IS NOT INITIAL.

      IF mv_value IS NOT INITIAL.
        
        CLEAR temp1.
        ms_feed = temp1.
        ms_feed-author = sy-uname.
        ms_feed-type = `Respond`.
        ms_feed-text = mv_value.
        mv_value = ``.
        INSERT ms_feed INTO mt_feed INDEX 1.
        client->view_model_update( ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD set_data.

    DATA temp2 LIKE mt_feed.
    DATA temp3 LIKE LINE OF temp2.
    CLEAR temp2.
    
    temp3-author = `choper725`.
    temp3-authorpic = `employee`.
    temp3-type = `Request`.
    temp3-date = `August 26 2023`.
    temp3-text = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
`Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna` &&
`aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.`.
    INSERT temp3 INTO TABLE temp2.
    temp3-author = `choper725`.
    temp3-authorpic = `sap-icon://employee`.
    temp3-type = `Reply`.
    temp3-date = `August 26 2023`.
    temp3-text = `this is feed input`.
    INSERT temp3 INTO TABLE temp2.
    mt_feed = temp2.

  ENDMETHOD.


  METHOD view_display.

    DATA lo_view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    lo_view = z2ui5_cl_xml_view=>factory( ).

    
    page = lo_view->shell( )->page(
             title          = `Feed Input`
             navbuttonpress = client->_event_nav_app_leave( )
             shownavbutton  = client->check_app_prev_stack( ) ).

    page->flex_box(
            justifycontent = `Start`
            class          = `sapUiSmallMarginEnd`
            alignitems     = `Center`
            )->icon(
                    src   = `sap-icon://person-placeholder`
                    class = `sapUiSmallMarginEnd`
            )->text_area(
                    value       = client->_bind( mv_value )
                    rows        = `4`
                    cols        = `120`
                    class       = `sapUiSmallMarginEnd`
                    placeholder = `Post something here...`
                    editable    = abap_true
                    enabled     = abap_true
            )->button(
                    icon      = `sap-icon://paper-plane`
                    press     = client->_event( `POST` )
                    iconfirst = abap_true ).

    page->list(
      items          = client->_bind( mt_feed )
      showseparators = `Inner`
        )->feed_list_item(
          sender                   = `{AUTHOR}`
          senderpress              = client->_event( `SENDER_PRESS` )
          iconpress                = client->_event( `ICON_PRESS` )
          icondensityaware         = abap_false
          showicon                 = abap_false
          info                     = `Reply`
          text                     = `{TEXT}`
          convertlinkstoanchortags = `All` ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
