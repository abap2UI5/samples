" @keywords icon font registerfont iconpool tnt collection glyph missing control_global
" @summary Registers the sap.tnt icon collection with IconPool so a sap-icon://SAP-icons-TNT/... URI resolves - without it the icon renders no glyph and logs nothing.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_518 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS font_register.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_518 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      font_register( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD font_register.

    " A normal UI5 app does this in its Component's init. An abap2UI5 app has
    " no Component of its own, and IconPool is a module SINGLETON rather than
    " a control, so no other wire reaches it. t_arg is positional: the font
    " family and the font URI - a module path in every real use, resolved
    " through sap.ui.require.toUrl, so the registration survives a different
    " mount point.
    "
    " Issue it from the init branch: the collection is registered once per
    " session, so a repeat call costs nothing but says the wrong thing.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                              t_arg = VALUE #( ( `ICON_POOL` )
                                               ( `registerFont` )
                                               ( `SAP-icons-TNT` )
                                               ( `sap/tnt/themes/base/fonts/` ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Register an Icon Font`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Only the default SAP-icons font is registered out of the box. A URI naming another ` &&
                   `collection renders NO GLYPH and logs nothing at all - an empty space where an icon should be is the ` &&
                   `whole symptom, which is what makes this one worth knowing.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Title`
            )->a( n = `text`  v = `From the default collection`
            )->a( n = `level` v = `H3`

        )->tag( n = `Icon` ns = `core`
            )->a( n = `src`   v = `sap-icon://sap-ui5`
            )->a( n = `size`  v = `2.5rem`
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->tag( `Title`
            )->a( n = `text`  v = `From SAP-icons-TNT, registered above`
            )->a( n = `level` v = `H3`

        )->tag( n = `Icon` ns = `core`
            )->a( n = `src`  v = `sap-icon://SAP-icons-TNT/application-service`
            )->a( n = `size` v = `2.5rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
