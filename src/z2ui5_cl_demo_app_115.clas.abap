CLASS z2ui5_cl_demo_app_115 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_115 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.


    DATA(lv_style) = `<html:style type="text/css">body {` && |\n| &&
                                      `     font-family: Arial;` && |\n| &&
                                      `     font-size: 90%;` && |\n| &&
                                      `}` && |\n| &&
                                      `table {` && |\n| &&
                                      `     font-family: Arial;` && |\n| &&
                                      `     font-size: 90%;` && |\n| &&
                                      `}` && |\n| &&
                                      `caption {` && |\n| &&
                                      `     font-family: Arial;` && |\n| &&
                                      `     font-size: 90%;` && |\n| &&
                                      `     font-weight:bold;` && |\n| &&
                                      `     text-align:left;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.heading1 {` && |\n| &&
                                      `    font-size: 150%;` && |\n| &&
                                      `     color:#000080;` && |\n| &&
                                      `     font-weight:bold;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.heading2 {` && |\n| &&
                                      `    font-size: 135%;` && |\n| &&
                                      `     color:#000080;` && |\n| &&
                                      `     font-weight:bold;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.heading3 {` && |\n| &&
                                      `    font-size: 120%;` && |\n| &&
                                      `     color:#000080;` && |\n| &&
                                      `     font-weight:bold;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.heading4 {` && |\n| &&
                                      `    font-size: 105%;` && |\n| &&
                                      `     color:#000080;` && |\n| &&
                                      `     font-weight:bold;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.normal {` && |\n| &&
                                      `    font-size: 100%;` && |\n| &&
                                      `     color:#000000;` && |\n| &&
                                      `     font-weight:normal;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.nonprop {` && |\n| &&
                                      `    font-family: Courier New;` && |\n| &&
                                      `     font-size: 100%;` && |\n| &&
                                      `     color:#000000;` && |\n| &&
                                      `     font-weight:400;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.nowrap {` && |\n| &&
                                      `    white-space:nowrap;` && |\n| &&
                                      `}` && |\n| &&
                                      `span.nprpnwrp {` && |\n| &&
                                      `    font-family: Courier New;` && |\n| &&
                                      `     font-size: 100%;` && |\n| &&
                                      `     color:#000000;` && |\n| &&
                                      `     font-weight:400;` && |\n| &&
                                      `     white-space:nowrap;` && |\n| &&
                                      `}` && |\n| &&
                                      `tr.header {` && |\n| &&
                                      `    background-color:#D3D3D3;` && |\n| &&
                                      `}` && |\n| &&
                                      `tr.body {` && |\n| &&
                                      `    background-color:#EFEFEF;` && |\n| &&
                                      `}` && |\n| &&
                                      `</html:style>`.



    DATA(lv_html) = `` && |\n| &&
                    |\n| &&
                    `<h2 title="I'm a header">The title Attribute</h2>` && |\n| &&
                    |\n| &&
                    `<p title="I'm a tooltip">Mouse over this paragraph, to display the title attribute as a tooltip.</p>` && |\n| &&
                    |\n| &&
                    ``.

*    SELECT *from scarr
*           INTO TABLE @DATA(carriers).
*
*    DATA(lv_html) = cl_demo_output=>get( carriers ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
           )->page(
           )->button( text = `test`
          )->_cc_plain_xml( lv_style
          )->html( lv_html ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
