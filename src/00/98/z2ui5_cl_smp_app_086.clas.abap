CLASS z2ui5_cl_smp_app_086 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab_supplier,
        suppliername TYPE string,
        email        TYPE string,
        phone        TYPE string,
        zipcode      TYPE string,
        city         TYPE string,
        street       TYPE string,
        country      TYPE string,
      END OF ty_s_tab_supplier.
    DATA ls_detail_supplier TYPE ty_s_tab_supplier.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_086 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Flow Logic - APP 85`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title` v = `Supplier`
                )->ele( n = `content` ns = `form`
                    )->tag( `Label`
                        )->a( n = `text` v = `Value set by previous app`
                    )->tag( `Input`
                        )->a( n = `editable` v = `false`
                        )->a( n = `value`    v = ls_detail_supplier-suppliername ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
