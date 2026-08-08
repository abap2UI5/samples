CLASS z2ui5_cl_smp_app_475 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls build their UI from OData V2 metadata, so this app carries no
    " ABAP data at all - it switches the default model to a service instead. The
    " SAP Gateway demo service GWSAMPLE_BASIC ships with every on-premise system
    " and only has to be activated once in /IWFND/MAINT_SERVICE. Its entity set is
    " ProductSet, which is why the tutorial's Products entity set is mapped onto it.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/IWBEP/GWSAMPLE_BASIC/`.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_475 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Smart Controls - SmartField`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      " The tutorial binds the view to a single product record in its controller
      " (bindElement( `/Products('4711')` )). There is no controller here, so the
      " element binding is declared on the SmartForm - the SmartField's relative
      " {Price} binding resolves against it. This is an OData ENTITY path into the
      " service, not a path into an ABAP-fed model, so there is no
      " client->_bind( ) variable to derive it from.
      DATA(form) = page->_generic(
          name   = `SmartForm`
          ns     = `smartForm`
          t_prop = VALUE #( ( n = `editable` v = `true` )
                            ( n = `binding`  v = `{/ProductSet('AR-FB-1000')}` ) ) ).

      form->_generic( name = `layout` ns = `smartForm`
          )->_generic(
              name   = `ColumnLayout`
              ns     = `smartForm`
              t_prop = VALUE #( ( n = `emptyCellsLarge` v = `4` )
                                ( n = `labelCellsLarge` v = `4` )
                                ( n = `columnsM`        v = `1` )
                                ( n = `columnsL`        v = `1` )
                                ( n = `columnsXL`       v = `1` ) ) ).

      form->_generic( name = `Group` ns = `smartForm`
          )->_generic( name = `GroupElement` ns = `smartForm`
              )->_generic(
                  name   = `SmartField`
                  ns     = `smartField`
                  t_prop = VALUE #( ( n = `value` v = `{Price}` )
                                    ( n = `id`    v = `idPrice` ) ) ).

      client->view_display( val                       = view->stringify( )
                            switch_default_model_path = c_odata_service ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
