"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxDefaultFiltering
"! The default filtering is 'starts with per term', which filters by the beginning of every word in
"! every column. Autocomplete (type-ahead) works only for the first column, the leading value.
CLASS z2ui5_cl_demo_app_425 DEFINITION PUBLIC.

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

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_425 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " subset of the demo kit mock data sap/ui/demo/mock/countriesExtendedCollection.json
    t_countries = VALUE #(
        ( key = `DZ`  text = `Algeria` )
        ( key = `AR`  text = `Argentina` )
        ( key = `AU`  text = `Australia` )
        ( key = `AT`  text = `Austria` )
        ( key = `BH`  text = `Bahrain` )
        ( key = `BE`  text = `Belgium` )
        ( key = `BA`  text = `Bosnia and Herzegovina` )
        ( key = `BR`  text = `Brazil` )
        ( key = `BG`  text = `Bulgaria` )
        ( key = `CA`  text = `Canada` )
        ( key = `CL`  text = `Chile` )
        ( key = `CO`  text = `Colombia` )
        ( key = `HR`  text = `Croatia` )
        ( key = `CU`  text = `Cuba` )
        ( key = `CZ`  text = `Czech Republic` )
        ( key = `DK`  text = `Denmark` )
        ( key = `EG`  text = `Egypt` )
        ( key = `EE`  text = `Estonia` )
        ( key = `FI`  text = `Finland` )
        ( key = `FR`  text = `France` )
        ( key = `GER` text = `Germany` )
        ( key = `GH`  text = `Ghana` )
        ( key = `GR`  text = `Greece` )
        ( key = `HU`  text = `Hungary` )
        ( key = `IN`  text = `India` )
        ( key = `ID`  text = `Indonesia` )
        ( key = `IE`  text = `Ireland` )
        ( key = `IL`  text = `Israel` )
        ( key = `IT`  text = `Italy` )
        ( key = `JP`  text = `Japan` ) ).
    " the original sorts the countries by text via a model sorter - the data is sorted in ABAP instead
    SORT t_countries BY text.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Combo box - Default Filtering`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            class          = `sapUiContentPadding` ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxDefaultFiltering` ).

    page->vbox(
        )->label(
            text     = `Enter a search term, e.g. "A", and see filtered list.`
            labelfor = `idComboBox`
        )->combobox(
            id                  = `idComboBox`
            showsecondaryvalues = abap_true
            items               = client->_bind( t_countries )
            )->list_item(
                key            = `{KEY}`
                text           = `{TEXT}`
                additionaltext = `{KEY}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
