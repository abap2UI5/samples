CLASS z2ui5_cl_demo_app_383 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA image TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS popup_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_383 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      image = `https://raw.githubusercontent.com/abap2UI5/abap2UI5/main/docs/images/logo.png`.
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell(
        )->page(
            title          = `abap2UI5 - Frontend Action - Image Editor Popup Close`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->vbox( `sapUiSmallMargin`
                )->image(
                    src   = client->_bind( image )
                    width = `20rem`
                )->button(
                    text  = `Edit Image...`
                    icon  = `sap-icon://edit`
                    press = client->_event( `EDIT` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup(
        )->dialog(
            title               = `Edit Image`
            icon                = `sap-icon://edit`
            contentheight       = `80%`
            contentwidth        = `80%`
            verticalscrolling   = abap_false
            horizontalscrolling = abap_false ).

    popup->image_editor_container(
        )->image_editor(
            id  = `imageEditor`
            src = image ).

    popup->buttons(
        )->button(
            text  = `Cancel`
            type  = `Reject`
            press = client->_event( `CANCEL` )
        )->button(
            text  = `Save`
            type  = `Emphasized`
            press = client->_event_client( client->cs_event-image_editor_popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `EDIT`.
        popup_display( ).

      WHEN `SAVE`.

        image = client->get_event_arg( 1 ).
        client->popup_destroy( ).
        client->view_model_update( ).
        client->message_toast_display( `Image saved` ).

      WHEN `CANCEL`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
