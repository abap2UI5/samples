CLASS z2ui5_cl_smp_app_476 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " Smart controls build their UI from OData V2 metadata, so this app carries no
    " ABAP data at all - it switches the default model to a service instead. The
    " SAP Gateway demo service GWSAMPLE_BASIC ships with every on-premise system
    " and only has to be activated once in /IWFND/MAINT_SERVICE. Its entity set is
    " ProductSet, which is why the tutorial's Products entity set and two of its
    " field names are mapped onto it ({ProductId} -> {ProductID}, {CategoryName}
    " -> {Category}).
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/IWBEP/GWSAMPLE_BASIC/`.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_476 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Smart Controls - SmartForm`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      " editTogglable renders the display/edit toggle in the form header. The
      " element binding replaces the controller's bindElement( ) - an OData ENTITY
      " path into the service, so there is no client->_bind( ) variable behind it;
      " every SmartField value and the form title {Name} are relative to it.
      DATA(form) = page->_generic(
          name   = `SmartForm`
          ns     = `smartForm`
          t_prop = VALUE #( ( n = `id`            v = `smartForm` )
                            ( n = `editTogglable` v = `true` )
                            ( n = `title`         v = `{Name}` )
                            ( n = `flexEnabled`   v = `false` )
                            ( n = `binding`       v = `{/ProductSet('AR-FB-1000')}` ) ) ).

      DATA(group) = form->_generic(
          name   = `Group`
          ns     = `smartForm`
          t_prop = VALUE #( ( n = `label` v = `Product` ) ) ).

      group->_generic( name = `GroupElement` ns = `smartForm`
          )->_generic(
              name   = `SmartField`
              ns     = `smartField`
              t_prop = VALUE #( ( n = `value` v = `{ProductID}` ) ) ).

      group->_generic( name = `GroupElement` ns = `smartForm`
          )->_generic(
              name   = `SmartField`
              ns     = `smartField`
              t_prop = VALUE #( ( n = `value` v = `{Name}` ) ) ).

      " elementForLabel picks the second field of the group element as the one the
      " group label belongs to (0-based, so Description)
      group->_generic(
          name   = `GroupElement`
          ns     = `smartForm`
          t_prop = VALUE #( ( n = `elementForLabel` v = `1` ) )
          )->_generic(
              name   = `SmartField`
              ns     = `smartField`
              t_prop = VALUE #( ( n = `value` v = `{Category}` ) )
          )->get_parent(
          )->_generic(
              name   = `SmartField`
              ns     = `smartField`
              t_prop = VALUE #( ( n = `value` v = `{Description}` ) ) ).

      group->_generic( name = `GroupElement` ns = `smartForm`
          )->_generic(
              name   = `SmartField`
              ns     = `smartField`
              t_prop = VALUE #( ( n = `value` v = `{Price}` ) ) ).

      form->_generic(
          name   = `Group`
          ns     = `smartForm`
          t_prop = VALUE #( ( n = `label` v = `Supplier` ) )
          )->_generic( name = `GroupElement` ns = `smartForm`
              )->_generic(
                  name   = `SmartField`
                  ns     = `smartField`
                  t_prop = VALUE #( ( n = `value` v = `{SupplierName}` ) ) ).

      client->view_display( val                       = view->stringify( )
                            switch_default_model_path = c_odata_service ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
