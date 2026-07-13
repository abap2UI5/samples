"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeader
"! This is a Object Header which displays the basic information about objects similar to the Object
"! List Item. Besides a title and number you can show multiple attributes (on the left) and statuses
"! (on the right).
CLASS z2ui5_cl_demo_app_460 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_460 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Header`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeader` ).

    DATA(header) = page->object_header(
        title      = `Notebook Basic 15`
        number     = `956.00`
        numberunit = `EUR`
        class      = `sapUiResponsivePadding--header` ).

    header->_generic( `statuses`
        )->object_status(
            text  = `Some Damaged`
            state = `Error` )->get_parent(
        )->object_status(
            text  = `In Stock`
            state = `Success` ).

    header->object_attribute( text = `4.2 KG`
        )->object_attribute( text = `30 x 18 x 3 cm`
        )->object_attribute( text = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        )->object_attribute(
            text   = `www.sap.com`
            active = abap_true
            press  = client->_event_client( val   = client->cs_event-open_new_tab
                                            t_arg = VALUE #( ( `http://www.sap.com` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
