CLASS Z2UI5_CL_DEMO_APP_086 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES Z2UI5_if_app .

    TYPES:
      BEGIN OF ty_s_tab_supplier,
        Suppliername TYPE string,
        email        TYPE string,
        phone        TYPE string,
        zipcode      TYPE string,
        city         TYPE string,
        street       TYPE string,
        country      TYPE string,
      END OF ty_s_tab_supplier .

    DATA ls_detail_supplier TYPE ty_s_tab_supplier .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_086 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
               title          = 'abap2UI5 - Flow Logic - APP 85'
               navbuttonpress = client->_event( 'BACK' ) shownavbutton = abap_true
           )->header_content(
               )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1640743794206228480`
               )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
           )->get_parent( ).

    page->grid( 'L6 M12 S12' )->content( 'layout'

          )->simple_form( 'Supplier' )->content( 'form'

           )->label( 'Value set by previous app'
           )->input( value = ls_detail_supplier-suppliername  editable = 'false'  ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
