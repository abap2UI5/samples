CLASS z2ui5_cl_smp_app_477 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_477 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Smart Controls - SmartTable`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      " No model data and no event wiring: the SmartTable binds itself
      " (enableautobinding) and reads the SmartFilterBar's conditions through the
      " smartfilterid association - the whole app is the view plus the service.
      page->smart_filter_bar(
          id        = `smartFilterBar`
          entityset = `ProductSet`
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
          tabletype               = `ResponsiveTable`
          editable                = `false`
          entityset               = `ProductSet`
          initiallyvisiblefields  = `ProductID,Name,Category,SupplierName,Price`
          usevariantmanagement    = `false`
          usetablepersonalisation = `false`
          header                  = `Products`
          showrowcount            = `true`
          enableexport            = `false`
          enableautobinding       = `true` ).

      client->view_display( val                       = view->stringify( )
                            switch_default_model_path = c_odata_service ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
