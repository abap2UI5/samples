CLASS z2ui5_cl_demo_app_308 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_308 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page( title          = 'Harvey Chart'
                   navbuttonpress = client->_event( 'BACK' )
                   shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

      page->harvey_ball_micro_chart(
*                                   colorpalette  =
*                                   press         =
                                     size          = 'L'
*                                   height        =
*                                   width         =
                                     total         = '10'
                                     totallabel    = '11'
*                                   aligncontent  =
*                                   hideonnodata  =
*                                   formattedlabel =
                                     showfractions = abap_true
                                     showtotal     = abap_true
                                     totalscale    = abap_true
*  RECEIVING
*                                   result        =
        )->harveyballmicrochartitem(
*                                 id            =
                                   color         = 'Good'
                                   fraction      = '8'
                                   fractionscale = 'Mrd'
*                                 class         =
*  RECEIVING
*                                 result        =
        ).

      client->view_display( view->stringify( ) ).

    ENDIF.


    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
