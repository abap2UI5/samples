CLASS z2ui5_cl_smp_app_478 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_478 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Smart Controls - Page Variant`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      " Page variant: one SmartVariantManagement in front of the page owns the
      " persistency (PageVariantPKey) and both smart controls register with it
      " through their smartvariant association, each contributing its own
      " persistencykey. Everything below is metadata-driven - no model data.
      page->hbox(
          )->smart_variant_management(
              id             = `pageVariantId`
              persistencykey = `PageVariantPKey` ).

      " The tutorial's onFiltersChanged handler is not published, so there is no
      " original body to rebuild - but the original IS a controller function, i.e.
      " client-side. The wire therefore stays roundtrip-free (control_global
      " MESSAGE_TOAST): a backend round-trip fired in the middle of the variant /
      " filter handshake is exactly what a smart control does not expect.
      page->smart_filter_bar(
          id                     = `smartFilterBar`
          entityset              = `ProductSet`
          smartvariant           = `pageVariantId`
          persistencykey         = `SmartFilterPKey`
          assignedfilterschanged = client->_event_client(
              val   = client->cs_event-control_global
              t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Assigned filters changed` ) ) )
          )->_control_configuration(
              )->control_configuration(
                  key                           = `Category`
                  visibleinadvancedarea         = `true`
                  previnitdatafetchinvalhelpdia = `false` ).

      " GWSAMPLE_BASIC carries no UI.LineItem annotation, and without one a
      " SmartTable starts with NO columns at all - it renders the "add columns to
      " see the content" placeholder instead of falling back to all metadata
      " fields. The initially visible fields therefore have to be named; the
      " tutorial's own service annotates the four columns it shows.
      page->smart_table(
          id                      = `smartTable_ResponsiveTable`
          smartfilterid           = `smartFilterBar`
          smartvariant            = `pageVariantId`
          tabletype               = `ResponsiveTable`
          editable                = `false`
          entityset               = `ProductSet`
          initiallyvisiblefields  = `ProductID,Name,Category,SupplierName,Price`
          usevariantmanagement    = `true`
          usetablepersonalisation = `true`
          header                  = `Products`
          showrowcount            = `true`
          enableexport            = `false`
          enableautobinding       = `true`
          persistencykey          = `SmartTablePKey` ).

      client->view_display( val                       = view->stringify( )
                            switch_default_model_path = c_odata_service ).

      " The handshake a controller would do: without initialise( ) the page variant
      " never gets a personalizable control, so saving a view dies in sap.ui.fl and
      " stored views are never loaded. The action waits for the smart controls to
      " register, which they do once their metadata has arrived.
      client->follow_up_action( val   = client->cs_event-smart_variant_init
                                t_arg = VALUE #( ( `pageVariantId` ) ( `smartFilterBar` ) ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
