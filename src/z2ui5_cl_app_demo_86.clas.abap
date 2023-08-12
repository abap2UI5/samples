class Z2UI5_CL_APP_DEMO_86 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    begin of ty_s_tab_supplier,
  Suppliername TYPE string,
  email        TYPE string,
  phone        TYPE string,
  zipcode      TYPE string,
  city         TYPE string,
  street       TYPE string,
  country      TYPE string,
  END OF ty_s_tab_supplier .

  data LS_DETAIL_SUPPLIER type TY_S_TAB_SUPPLIER .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_86 IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~MAIN.

    CASE client->get( )-event.
     WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.


        data(view) = Z2UI5_CL_XML_VIEW=>factory( client ).
        DATA(page) = view->shell(
            )->page(
                   title          = 'abap2UI5 - Flow Logic - APP 85'
                   navbuttonpress = client->_event( 'BACK' ) shownavbutton = abap_true
               )->header_content(
                   )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1640743794206228480`
                   )->link( text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url( )
               )->get_parent( ).

        page->grid( 'L6 M12 S12' )->content( 'layout'

              )->simple_form( 'Supplier' )->content( 'form'

               )->label( 'Value set by previous app'
               )->input( value = ls_detail_supplier-suppliername  editable = 'false'  ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
