CLASS z2ui5_cl_app_demo_78 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_78 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.

    client->view_display( z2ui5_cl_xml_view=>factory( client )->page(
        )->_generic(
          name   = 'iframe'
          ns     = 'html'
          t_prop = VALUE #(
            ( n = `src` v = `https://view.officeapps.live.com/op/view.aspx?src=https://abap2xlsx.github.io/abap2xlsx-web/foo.xls` ) )
     )->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
