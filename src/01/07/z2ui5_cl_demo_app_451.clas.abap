CLASS z2ui5_cl_demo_app_451 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_token.
    DATA t_tokens         TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA t_tokens_added   TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA t_tokens_removed TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_451 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_tokens = VALUE #( ( key = `0001` text = `Token 1` )
                          ( key = `0002` text = `Token 2` ) ).
      view_display( ).
    ELSEIF client->check_on_event( `UPDATE_BACKEND` ).
      " added/removed tokens arrive in the bound tables via the companion's change event
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Custom Control - MultiInput Validator`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The invisible companion control z2ui5.cc.MultiInputExt installs the ` &&
                   `free-text validator: type any text and press Enter to create a token.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the companion references the MultiInput by id and adds the validator
    " (free text + Enter -> new Token), mirroring token changes to the backend
    page->_z2ui5( )->multiinput_ext(
        multiinputid  = `myInput`
        addedtokens   = client->_bind_edit( t_tokens_added )
        removedtokens = client->_bind_edit( t_tokens_removed )
        change        = client->_event( `UPDATE_BACKEND` ) ).

    page->multi_input(
        id            = `myInput`
        width         = `20em`
        showvaluehelp = abap_false
        class         = `sapUiSmallMargin`
        tokens        = client->_bind_edit( t_tokens )
        )->tokens(
            )->token( key  = `{KEY}`
                      text = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
