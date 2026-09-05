" @keywords menubutton menuitem popover messagetoast require module
" @summary A MenuButton whose items call a UI5 module loaded with core:require, so the click is answered in the frontend.
CLASS z2ui5_cl_smp_app_163 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS view_menu.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_163 IMPLEMENTATION.

  METHOD on_event.

    IF client->check_on_event( `OPEN_MENU` ) IS NOT INITIAL.
      view_menu( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_menu.

    DATA menu_view TYPE REF TO z2ui5_cl_ui5_view_builder.
    menu_view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    menu_view->a( n = `core:require` v = `{ MessageToast: 'sap/m/MessageToast' }` ).

    " Every MenuItem below calls the core:require'd MessageToast in the
    " BROWSER through an expression binding - no roundtrip, which is the point
    " of this sample. binding-for-event is about a MODEL binding landing on an
    " event by accident; this is the deliberate other thing.
    " abap2ui5lint-disable binding-for-event
    menu_view->ele( `Menu`
        )->a( n = `title` v = `Choose Your Action`
        )->tag( `MenuItem`
            )->a( n = `press` v = `MessageToast.show('selected action is ' + ${$source>/text})`
            )->a( n = `text`  v = `Accept`
            )->a( n = `icon`  v = `sap-icon://accept`
        )->tag( `MenuItem`
            )->a( n = `press` v = `MessageToast.show('selected action is ' + ${$source>/text})`
            )->a( n = `text`  v = `Reject`
            )->a( n = `icon`  v = `sap-icon://decline`
        )->tag( `MenuItem`
            )->a( n = `press` v = `MessageToast.show('selected action is ' + ${$source>/text})`
            )->a( n = `text`  v = `Email`
            )->a( n = `icon`  v = `sap-icon://email`
        )->tag( `MenuItem`
            )->a( n = `press` v = `MessageToast.show('selected action is ' + ${$source>/text})`
            )->a( n = `text`  v = `Forward`
            )->a( n = `icon`  v = `sap-icon://forward`
        )->tag( `MenuItem`
            )->a( n = `press` v = `MessageToast.show('selected action is ' + ${$source>/text})`
            )->a( n = `text`  v = `Delete`
            )->a( n = `icon`  v = `sap-icon://delete`
        )->tag( `MenuItem`
            )->a( n = `press` v = `MessageToast.show('selected action is ' + ${$source>/text})`
            )->a( n = `text`  v = `Other` ).
    " abap2ui5lint-enable binding-for-event

    client->popover_display( xml = menu_view->stringify( ) by_id = `menuButton` ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA vbox TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    view           = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Menu - Menu Button with core:require`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    view->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample opens a Menu as a popover anchored to a button; choosing an ` &&
                   `item shows the selected action in a MessageToast.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    vbox = view->ele( `VBox` ).

    vbox->tag( `Button`
        )->a( n = `press` v = client->_event( `OPEN_MENU` )
        )->a( n = `text`  v = `Open Menu`
        )->a( n = `id`    v = `menuButton`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
