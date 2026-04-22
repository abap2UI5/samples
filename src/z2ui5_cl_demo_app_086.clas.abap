CLASS z2ui5_cl_demo_app_086 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_086 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
               title          = `abap2UI5 - Flow Logic - APP 85`
               navbuttonpress = client->_event_nav_app_leave( )
               shownavbutton  = client->check_app_prev_stack( ) ).

    page->grid( `L6 M12 S12` )->content( `layout`
      )->simple_form( `Supplier` )->content( `form`
      )->label( `Value set by previous app`
           )->input( value    = ls_detail_supplier-suppliername
                     editable = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
