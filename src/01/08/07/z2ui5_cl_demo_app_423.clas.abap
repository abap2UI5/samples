"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBox
"! The combo box control provides a list box with items and a text field allowing the user to either
"! type a value directly into the control or choose from the list of existing items.
CLASS z2ui5_cl_demo_app_423 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_country,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_country.
    DATA t_countries TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_423 IMPLEMENTATION.

  METHOD view_display.

    " Data of the mock model sap/ui/demo/mock/countriesExtendedCollection.json used by the original sample
    t_countries = VALUE #(
      ( key = `DZ` text = `Algeria` )
      ( key = `AR` text = `Argentina` )
      ( key = `AU` text = `Australia` )
      ( key = `AT` text = `Austria` )
      ( key = `BH` text = `Bahrain` )
      ( key = `BE` text = `Belgium` )
      ( key = `BA` text = `Bosnia and Herzegovina` )
      ( key = `BR` text = `Brazil` )
      ( key = `BG` text = `Bulgaria` )
      ( key = `CA` text = `Canada` )
      ( key = `CL` text = `Chile` )
      ( key = `CO` text = `Colombia` )
      ( key = `HR` text = `Croatia` )
      ( key = `CU` text = `Cuba` )
      ( key = `CZ` text = `Czech Republic` )
      ( key = `DK` text = `Denmark` )
      ( key = `EG` text = `Egypt` )
      ( key = `EE` text = `Estonia` )
      ( key = `FI` text = `Finland` )
      ( key = `FR` text = `France` )
      ( key = `GER` text = `Germany` )
      ( key = `GH` text = `Ghana` )
      ( key = `GR` text = `Greece` )
      ( key = `HU` text = `Hungary` )
      ( key = `IN` text = `India` )
      ( key = `ID` text = `Indonesia` )
      ( key = `IE` text = `Ireland` )
      ( key = `IL` text = `Israel` )
      ( key = `IT` text = `Italy` )
      ( key = `JP` text = `Japan` )
      ( key = `JO` text = `Jordan` )
      ( key = `KE` text = `Kenya` )
      ( key = `KW` text = `Kuwait` )
      ( key = `LV` text = `Latvia` )
      ( key = `LT` text = `Lithuania` )
      ( key = `MK` text = `Macedonia` )
      ( key = `MY` text = `Malaysia` )
      ( key = `MX` text = `Mexico` )
      ( key = `ME` text = `Montenegro` )
      ( key = `MA` text = `Morocco` )
      ( key = `NL` text = `Netherlands` )
      ( key = `NZ` text = `New Zealand` )
      ( key = `NG` text = `Nigeria` )
      ( key = `NO` text = `Norway` )
      ( key = `OM` text = `Oman` )
      ( key = `PE` text = `Peru` )
      ( key = `PH` text = `Philippines` )
      ( key = `PL` text = `Poland` )
      ( key = `PT` text = `Portugal` )
      ( key = `QA` text = `Qatar` )
      ( key = `RO` text = `Romania` )
      ( key = `RU` text = `Russia` )
      ( key = `SA` text = `Saudi Arabia` )
      ( key = `SN` text = `Senegal` )
      ( key = `RS` text = `Serbia` )
      ( key = `SG` text = `Singapore` )
      ( key = `SK` text = `Slovakia` )
      ( key = `SI` text = `Slovenia` )
      ( key = `ZA` text = `South Africa` )
      ( key = `KR` text = `South Korea` )
      ( key = `ES` text = `Spain` )
      ( key = `SE` text = `Sweden` )
      ( key = `CH` text = `Switzerland` )
      ( key = `TN` text = `Tunisia` )
      ( key = `TR` text = `Turkey` )
      ( key = `UG` text = `Uganda` )
      ( key = `UA` text = `Ukraine` )
      ( key = `AE` text = `United Arab Emirates` )
      ( key = `GB` text = `United Kingdom` )
      ( key = `YE` text = `Yemen` ) ).

    " the original sorts the items by text via a model sorter - the data is sorted in ABAP instead
    SORT t_countries BY text.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Combo box`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBox` ).

    page->page(
        showheader = abap_false
        class      = `sapUiContentPadding`
        )->combobox( items = client->_bind( t_countries )
            )->item(
                key  = `{KEY}`
                text = `{TEXT}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
