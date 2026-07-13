"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridInfo
"! You can use the Grid control to make responsive table-free layouts; here we are using a default
"! indent and span, and specifying the Small settings such that the image and text will stack on a
"! small display.
CLASS z2ui5_cl_demo_app_517 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_person,
        pic_url     TYPE string,
        name        TYPE string,
        description TYPE string,
      END OF ty_s_person.
    DATA s_person1 TYPE ty_s_person.
    DATA s_person2 TYPE ty_s_person.
    DATA s_person3 TYPE ty_s_person.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_517 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Grid - Info Layout`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.Grid/sample/sap.ui.layout.sample.GridInfo` ).

    DATA(content) = page->grid(
        class        = `sapUiSmallMarginTop`
        hspacing     = `2`
        default_span = `L6 M6 S10`
        )->content( `layout` ).

    " the wrapper grid_data method does not support the linebreak properties - generic element used
    content->image(
        src   = client->_bind( s_person1-pic_url )
        width = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `span` v = `L3 M3 S8` )
                                  ( n = `linebreakL` v = `true` )
                                  ( n = `linebreakM` v = `true` )
                                  ( n = `linebreakS` v = `true` ) ) ).

    content->vbox(
        )->text(
            text  = client->_bind( s_person1-name )
            class = `nameTitle`
        )->text( client->_bind( s_person1-description ) ).

    content->image(
        src   = client->_bind( s_person2-pic_url )
        width = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `span` v = `L3 M3 S8` )
                                  ( n = `linebreakL` v = `true` )
                                  ( n = `linebreakM` v = `true` )
                                  ( n = `linebreakS` v = `true` ) ) ).

    content->vbox(
        )->text(
            text  = client->_bind( s_person2-name )
            class = `nameTitle`
        )->text( client->_bind( s_person2-description ) ).

    content->image(
        src   = client->_bind( s_person3-pic_url )
        width = `100%` )->get(
        )->layout_data(
            )->_generic(
                name   = `GridData`
                ns     = `layout`
                t_prop = VALUE #( ( n = `span` v = `L3 M3 S8` )
                                  ( n = `linebreakL` v = `true` )
                                  ( n = `linebreakM` v = `true` )
                                  ( n = `linebreakS` v = `true` ) ) ).

    content->vbox(
        )->text(
            text  = client->_bind( s_person3-name )
            class = `nameTitle`
        )->text( client->_bind( s_person3-description ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      s_person1 = VALUE #(
        pic_url     = `https://upload.wikimedia.org/wikipedia/commons/2/25/George_Washington_as_CIC_of_the_Continental_Army_bust.jpg`
        name        = `George Washington`
        description = `George Washington was the first President of the United States, the commander-in-chief of the Continental Army ` &&
                      `during the American Revolutionary War, and one of the Founding Fathers of the United States.` ).
      s_person2 = VALUE #(
        pic_url     = `https://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
        name        = `Alexandrina Victoria`
        description = `Queen Victoria was the monarch of the United Kingdom of Great Britain and Ireland from 20 June 1837 until her death. ` &&
                      `From 1 May 1876, she used the additional title of Empress of India.` ).
      s_person3 = VALUE #(
        pic_url     = `https://upload.wikimedia.org/wikipedia/commons/f/fc/Frederic_II_de_prusse.jpg`
        name        = `Friedrich Der Große`
        description = `Frederick II was King in Prussia of the Hohenzollern dynasty. He is best known for his brilliance in military campaigning ` &&
                      `and organization of Prussian armies. He became known as Frederick the Great and was nicknamed Der Alte Fritz.` ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
