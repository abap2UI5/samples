CLASS z2ui5_cl_demo_app_181 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_initialized TYPE abap_bool .

    TYPES:
      BEGIN OF ty_cities,
        text TYPE string,
        key  TYPE string,
      END OF ty_cities.

    TYPES t_cities TYPE STANDARD TABLE OF ty_cities WITH DEFAULT KEY.
    DATA mt_cities TYPE t_cities.

    TYPES:
      BEGIN OF ty_product_items,
        title         TYPE string,
        subtitle      TYPE string,
        revenue       TYPE string,
        status        TYPE string,
        status_schema TYPE string,
      END OF ty_product_items.

    TYPES t_product_items TYPE STANDARD TABLE OF ty_product_items WITH DEFAULT KEY.
    DATA mt_products TYPE t_product_items.

    METHODS on_event .
    METHODS view_display .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_181 IMPLEMENTATION.

  METHOD on_event.

    IF mo_client->check_on_event( `BOOK` ).
      mo_client->message_toast_display( `BOOKED !!! ENJOY` ).
    ENDIF.
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page(
        title          = `Cards Demo`
        class          = `sapUiContentPadding`
        navbuttonpress = mo_client->_event_nav_app_leave( )
        shownavbutton  = mo_client->check_app_prev_stack( ) ).

    mt_cities = VALUE #( ( text = `Berlin` key = `BR` )
                                                                                                       ( text = `London` key = `LN` )
                                                                                                       ( text = `Madrid` key = `MD` )
                                                                                                       ( text = `Prague` key = `PR` )
                                                                                                       ( text = `Paris`  key = `PS` )
                                                                                                       ( text = `Sofia`  key = `SF` )
                                                                                                       ( text = `Vienna` key = `VN` ) ).

    mt_products = VALUE #( ( title = `Notebook HT` subtitle = `ID23452256-D44` revenue = `27.25K EUR` status = `success` status_schema = `Success` )
                                                                                                 ( title = `Notebook XT` subtitle = `ID27852256-D47` revenue = `7.35K EUR` status = `exceeded` status_schema = `Error` )
                                                                                                 ( title = `Notebook ST` subtitle = `ID123555587-I05` revenue = `22.89K EUR` status = `warning` status_schema = `Warning` ) ).

    DATA(lo_card_1) = lo_page->card( width = `300px`
                               class = `sapUiMediumMargin`
      )->header( ns = `f`
        )->card_header( title    = `Buy bus ticket on-line`
                        subtitle = `Buy a single-ride ticket for a date`
                        iconsrc  = `sap-icon://bus-public-transport`
                      )->get_parent( )->get_parent(
                    )->content( ns = `f`
                      )->vbox( height         = `110px`
                               class          = `sapUiSmallMargin`
                               justifycontent = `SpaceBetween`
                        )->hbox( justifycontent = `SpaceBetween`
                          )->combobox( width       = `120px`
                                       placeholder = `From City`
                                       items       = `{path:'` && mo_client->_bind( val = mt_cities path = abap_true ) && `', sorter: { path: 'TEXT' } }`
                                       )->get( )->item( key  = `{KEY}`
                                                        text = `{TEXT}` )->get_parent(
                          )->combobox( width       = `120px`
                                       placeholder = `To City`
                                       items       = `{path:'` && mo_client->_bind( val = mt_cities path = abap_true ) && `', sorter: { path: 'TEXT' } }`
                                       )->get( )->item( key  = `{KEY}`
                                                        text = `{TEXT}` )->get_parent(
                      )->get_parent(
                   )->hbox( rendertype     = `Bare`
                            justifycontent = `SpaceBetween`
                    )->date_picker( width       = `200px`
                                    placeholder = `Choose Date ...`
                    )->button( text  = `Book`
                               type  = `Emphasized`
                               press = mo_client->_event( `BOOK` )
                               class = `sapUiTinyMarginBegin` ).

    DATA(lo_card_2) = lo_page->card( width = `300px`
                               class = `sapUiMediumMargin`
                     )->header( ns = `f`
                       )->card_header( title    = `Project Cloud Transformation`
                                       subtitle = `Revenue per Product | EUR`
                                     )->get_parent( )->get_parent(
                                   )->content( ns = `f`
                                    )->list( class          = `sapUiSmallMarginBottom`
                                             showseparators = `None`
                                             items          = mo_client->_bind( mt_products )
                                       )->custom_list_item(
                                        )->hbox( alignitems     = `Center`
                                                 justifycontent = `SpaceBetween`
                                          )->vbox( class = `sapUiSmallMarginBegin sapUiSmallMarginTopBottom`
                                            )->title( text       = `{TITLE}`
                                                      titlestyle = `H3`
                                            )->text( text = `{SUBTITLE}`
                                          )->get_parent(
                                          )->object_status( class = `sapUiTinyMargin sapUiSmallMarginEnd`
                                                            text  = `{REVENUE}`
                                                            state = `{STATUS_SCHEMA}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.

      view_display( ).

    ENDIF.

    on_event( ).
  ENDMETHOD.
ENDCLASS.
