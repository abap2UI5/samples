CLASS z2ui5_cl_demo_app_060 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_currency,
        language          TYPE string,
        currency          TYPE string,
        currencyname      TYPE string,
        currencyshortname TYPE string,
      END OF ty_s_currency.


    DATA mt_suggestion_out TYPE STANDARD TABLE OF ty_s_currency.
    DATA mt_suggestion TYPE STANDARD TABLE OF ty_s_currency.
    DATA input TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_060 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      set_data( ).
      z2ui5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'ON_SUGGEST'.

        DATA lt_range TYPE RANGE OF string.
        lt_range = VALUE #( (  sign = 'I' option = 'CP' low = `*` && input && `*` ) ).

        CLEAR mt_suggestion_out.
        LOOP AT mt_suggestion INTO DATA(ls_sugg)
            WHERE currencyname IN lt_range.
          INSERT ls_sugg INTO TABLE mt_suggestion_out.
        ENDLOOP.

*        SELECT FROM i_currencytext
*          FIELDS *
*          WHERE currencyname IN @lt_range
*          AND  language = 'E'
*          INTO CORRESPONDING FIELDS OF TABLE @mt_suggestion.

        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page(
       title          = 'abap2UI5 - Live Suggestion Event'
       navbuttonpress = client->_event( 'BACK' )
       shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1675074394710765568`
             )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA(input) = grid->simple_form( 'Input'
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( input )
                    suggest         = client->_event( 'ON_SUGGEST' )
                    showtablesuggestionvaluehelp = abap_false
                    suggestionrows  = client->_bind( mt_suggestion_out )
                    showsuggestion  = abap_true
                    valueliveupdate = abap_true
                    autocomplete    = abap_false
                 )->get( ).

    input->suggestion_columns(
        )->column( )->label( text = 'Name' )->get_parent(
        )->column( )->label( text = 'Currency' ).

    input->suggestion_rows(
        )->column_list_item(
            )->label( text = '{CURRENCYNAME}'
            )->label( text = '{CURRENCY}' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD set_data.

    TYPES:
      BEGIN OF ty_s_currency,
        language          TYPE string,
        currency          TYPE string,
        currencyname      TYPE string,
        currencyshortname TYPE string,
      END OF ty_s_currency.

    mt_suggestion = VALUE #(
( language = 'E' currency = 'ADP' currencyname = 'Andorran Peseta --> (Old --> EUR)' currencyshortname = 'Peseta'  )
( language = 'E' currency = 'AED' currencyname = 'United Arab Emirates Dirham' currencyshortname = 'Dirham'  )
( language = 'E' currency = 'AFA' currencyname = 'Afghani (Old)' currencyshortname = 'Afghani'  )
( language = 'E' currency = 'AFN' currencyname = 'Afghani' currencyshortname = 'Afghani'  )
( language = 'E' currency = 'ALL' currencyname = 'Albanian Lek' currencyshortname = 'Lek'  )
( language = 'E' currency = 'AMD' currencyname = 'Armenian Dram' currencyshortname = 'Dram'  )
( language = 'E' currency = 'ANG' currencyname = 'West Indian Guilder' currencyshortname = 'W.Ind.Guilder'  )
( language = 'E' currency = 'AOA' currencyname = 'Angolanische Kwanza' currencyshortname = 'Kwansa'  )
( language = 'E' currency = 'AON' currencyname = 'Angolan New Kwanza (Old)' currencyshortname = 'New Kwanza'  )
( language = 'E' currency = 'AOR' currencyname = 'Angolan Kwanza Reajustado (Old)' currencyshortname = 'Kwanza Reajust.'  )
( language = 'E' currency = 'ARS' currencyname = 'Argentine Peso' currencyshortname = 'Arg. Peso'  )
( language = 'E' currency = 'ATS' currencyname = 'Austrian Schilling (Old --> EUR)' currencyshortname = 'Shilling'  )
( language = 'E' currency = 'AUD' currencyname = 'Australian Dollar' currencyshortname = 'Austr. Dollar'  )
( language = 'E' currency = 'AWG' currencyname = 'Aruban Florin' currencyshortname = 'Aruban Florin'  )
( language = 'E' currency = 'AZM' currencyname = 'Azerbaijani Manat (Old)' currencyshortname = 'Manat'  )
( language = 'E' currency = 'AZN' currencyname = 'Azerbaijani Manat' currencyshortname = 'Manat'  )
( language = 'E' currency = 'BAM' currencyname = 'Bosnia and Herzegovina Convertible Mark' currencyshortname = 'Convert. Mark'  )
( language = 'E' currency = 'BBD' currencyname = 'Barbados Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'BDT' currencyname = 'Bangladesh Taka' currencyshortname = 'Taka'  )
( language = 'E' currency = 'BEF' currencyname = 'Belgian Franc (Old --> EUR)' currencyshortname = 'Belgian Franc'  )
( language = 'E' currency = 'BGN' currencyname = 'Bulgarian Lev' currencyshortname = 'Lev'  )
( language = 'E' currency = 'BHD' currencyname = 'Bahraini Dinar' currencyshortname = 'Dinar'  )
( language = 'E' currency = 'BIF' currencyname = 'Burundi Franc' currencyshortname = 'Burundi Franc'  )
( language = 'E' currency = 'BMD' currencyname = 'Bermudan Dollar' currencyshortname = 'Bermudan Dollar'  )
( language = 'E' currency = 'BND' currencyname = 'Brunei Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'BOB' currencyname = 'Boliviano' currencyshortname = 'Boliviano'  )
( language = 'E' currency = 'BRL' currencyname = 'Brazilian Real' currencyshortname = 'Real'  )
( language = 'E' currency = 'BSD' currencyname = 'Bahaman Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'BTN' currencyname = 'Bhutan Ngultrum' currencyshortname = 'Ngultrum'  )
( language = 'E' currency = 'BWP' currencyname = 'Botswana Pula' currencyshortname = 'Pula'  )
( language = 'E' currency = 'BYB' currencyname = 'Belarusian Ruble (Old)' currencyshortname = 'Belarus. Ruble'  )
( language = 'E' currency = 'BYN' currencyname = 'Belarusian Ruble (New)' currencyshortname = 'Bela. Ruble N.'  )
( language = 'E' currency = 'BYR' currencyname = 'Belarusian Ruble' currencyshortname = 'Ruble'  )
( language = 'E' currency = 'BZD' currencyname = 'Belize Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'CAD' currencyname = 'Canadian Dollar' currencyshortname = 'Canadian Dollar'  )
( language = 'E' currency = 'CDF' currencyname = 'Congolese Franc' currencyshortname = 'test data'  )
( language = 'E' currency = 'CFP' currencyname = 'French Franc (Pacific Islands)' currencyshortname = 'Fr. Franc (Pac)'  )
( language = 'E' currency = 'CHF' currencyname = 'Swiss Franc' currencyshortname = 'Swiss Franc'  )
( language = 'E' currency = 'CLP' currencyname = 'Chilean Peso' currencyshortname = 'Peso'  )
( language = 'E' currency = 'CNY' currencyname = 'Chinese Renminbi' currencyshortname = 'Renminbi'  )
( language = 'E' currency = 'COP' currencyname = 'Colombian Peso' currencyshortname = 'Peso'  )
( language = 'E' currency = 'CRC' currencyname = 'Costa Rica Colon' currencyshortname = 'Cost.Rica Colon'  )
( language = 'E' currency = 'CSD' currencyname = 'Serbian Dinar (Old)' currencyshortname = 'Serbian Dinar'  )
( language = 'E' currency = 'CUC' currencyname = 'Peso Convertible' currencyshortname = 'Peso Convertib.'  )
( language = 'E' currency = 'CUP' currencyname = 'Cuban Peso' currencyshortname = 'Cuban Peso'  )
( language = 'E' currency = 'CVE' currencyname = 'Cape Verde Escudo' currencyshortname = 'Escudo'  )
( language = 'E' currency = 'CYP' currencyname = 'Cyprus Pound  (Old --> EUR)' currencyshortname = 'Cyprus Pound'  )
( language = 'E' currency = 'CZK' currencyname = 'Czech Krona' currencyshortname = 'Krona'  )
( language = 'E' currency = 'DEM' currencyname = 'German Mark    (Old --> EUR)' currencyshortname = 'German Mark'  )
( language = 'E' currency = 'DEM3' currencyname = '(Internal) German Mark (3 dec.places)' currencyshortname = '(Int.) DEM 3 DP'  )
( language = 'E' currency = 'DJF' currencyname = 'Djibouti Franc' currencyshortname = 'Djibouti Franc'  )
( language = 'E' currency = 'DKK' currencyname = 'Danish Krone' currencyshortname = 'Danish Krone'  )
( language = 'E' currency = 'DOP' currencyname = 'Dominican Peso' currencyshortname = 'Dominican Peso'  )
( language = 'E' currency = 'DZD' currencyname = 'Algerian Dinar' currencyshortname = 'Dinar'  )
( language = 'E' currency = 'ECS' currencyname = 'Ecuadorian Sucre (Old --> USD)' currencyshortname = 'Sucre'  )
( language = 'E' currency = 'EEK' currencyname = 'Estonian Krone (Old --> EUR)' currencyshortname = 'Krona'  )
( language = 'E' currency = 'EGP' currencyname = 'Egyptian Pound' currencyshortname = 'Pound'  )
( language = 'E' currency = 'ERN' currencyname = 'Eritrean Nafka' currencyshortname = 'Nakfa'  )
( language = 'E' currency = 'ESP' currencyname = 'Spanish Peseta (Old --> EUR)' currencyshortname = 'Peseta'  )
( language = 'E' currency = 'ETB' currencyname = 'Ethiopian Birr' currencyshortname = 'Birr'  )
( language = 'E' currency = 'EUR' currencyname = 'European Euro' currencyshortname = 'Euro'  )
( language = 'E' currency = 'FIM' currencyname = 'Finnish Markka (Old --> EUR)' currencyshortname = 'Finnish markka'  )
( language = 'E' currency = 'FJD' currencyname = 'Fiji Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'FKP' currencyname = 'Falkland Pound' currencyshortname = 'Falkland Pound'  )
( language = 'E' currency = 'FRF' currencyname = 'French Franc (Old --> EUR)' currencyshortname = 'French Franc'  )
( language = 'E' currency = 'GBP' currencyname = 'British Pound' currencyshortname = 'Pound sterling'  )
( language = 'E' currency = 'GEL' currencyname = 'Georgian Lari' currencyshortname = 'Lari'  )
( language = 'E' currency = 'GHC' currencyname = 'Ghanaian Cedi (Old)' currencyshortname = 'Cedi'  )
( language = 'E' currency = 'GHS' currencyname = 'Ghanian Cedi' currencyshortname = 'Cedi'  )
( language = 'E' currency = 'GIP' currencyname = 'Gibraltar Pound' currencyshortname = 'Gibraltar Pound'  )
( language = 'E' currency = 'GMD' currencyname = 'Gambian Dalasi' currencyshortname = 'Dalasi'  )
( language = 'E' currency = 'GNF' currencyname = 'Guinean Franc' currencyshortname = 'Franc'  )
( language = 'E' currency = 'GRD' currencyname = 'Greek Drachma (Old --> EUR)' currencyshortname = 'Drachma'  )
( language = 'E' currency = 'GTQ' currencyname = 'Guatemalan Quetzal' currencyshortname = 'Quetzal'  )
( language = 'E' currency = 'GWP' currencyname = 'Guinea Peso (Old --> SHP)' currencyshortname = 'Guinea Peso'  )
( language = 'E' currency = 'GYD' currencyname = 'Guyana Dollar' currencyshortname = 'Guyana Dollar'  )
( language = 'E' currency = 'HKD' currencyname = 'Hong Kong Dollar' currencyshortname = 'H.K.Dollar'  )
( language = 'E' currency = 'HNL' currencyname = 'Honduran Lempira' currencyshortname = 'Lempira'  )
( language = 'E' currency = 'HRK' currencyname = 'Croatian Kuna' currencyshortname = 'Kuna'  )
( language = 'E' currency = 'HTG' currencyname = 'Haitian Gourde' currencyshortname = 'Gourde'  )
( language = 'E' currency = 'HUF' currencyname = 'Hungarian Forint' currencyshortname = 'Forint'  )
( language = 'E' currency = 'IDR' currencyname = 'Indonesian Rupiah' currencyshortname = 'Rupiah'  )
( language = 'E' currency = 'IEP' currencyname = 'Irish Punt (Old --> EUR)' currencyshortname = 'Irish Punt'  )
( language = 'E' currency = 'ILS' currencyname = 'Israeli Scheckel' currencyshortname = 'Scheckel'  )
( language = 'E' currency = 'INR' currencyname = 'Indian Rupee' currencyshortname = 'Rupee'  )
( language = 'E' currency = 'IQD' currencyname = 'Iraqui Dinar' currencyshortname = 'Dinar'  )
( language = 'E' currency = 'IRR' currencyname = 'Iranian Rial' currencyshortname = 'Rial'  )
( language = 'E' currency = 'ISK' currencyname = 'Iceland Krona' currencyshortname = 'Krona'  )
( language = 'E' currency = 'ITL' currencyname = 'Italian Lira (Old --> EUR)' currencyshortname = 'Lire'  )
( language = 'E' currency = 'JMD' currencyname = 'Jamaican Dollar' currencyshortname = 'Jamaican Dollar'  )
( language = 'E' currency = 'JOD' currencyname = 'Jordanian Dinar' currencyshortname = 'Jordanian Dinar'  )
( language = 'E' currency = 'JPY' currencyname = 'Japanese Yen' currencyshortname = 'Yen'  )
( language = 'E' currency = 'KES' currencyname = 'Kenyan Shilling' currencyshortname = 'Shilling'  )
( language = 'E' currency = 'KGS' currencyname = 'Kyrgyzstan Som' currencyshortname = 'Som'  )
( language = 'E' currency = 'KHR' currencyname = 'Cambodian Riel' currencyshortname = 'Riel'  )
( language = 'E' currency = 'KMF' currencyname = 'Comoros Franc' currencyshortname = 'Comoros Franc'  )
( language = 'E' currency = 'KPW' currencyname = 'North Korean Won' currencyshortname = 'N. Korean Won'  )
( language = 'E' currency = 'KRW' currencyname = 'South Korean Won' currencyshortname = 'S.Korean Won'  )
( language = 'E' currency = 'KWD' currencyname = 'Kuwaiti Dinar' currencyshortname = 'Dinar'  )
( language = 'E' currency = 'KYD' currencyname = 'Cayman Dollar' currencyshortname = 'Cayman Dollar'  )
( language = 'E' currency = 'KZT' currencyname = 'Kazakstanian Tenge' currencyshortname = 'Tenge'  )
( language = 'E' currency = 'LAK' currencyname = 'Laotian Kip' currencyshortname = 'Kip'  )
( language = 'E' currency = 'LBP' currencyname = 'Lebanese Pound' currencyshortname = 'Lebanese Pound'  )
( language = 'E' currency = 'LKR' currencyname = 'Sri Lankan Rupee' currencyshortname = 'Sri Lanka Rupee'  )
( language = 'E' currency = 'LRD' currencyname = 'Liberian Dollar' currencyshortname = 'Liberian Dollar'  )
( language = 'E' currency = 'LSL' currencyname = 'Lesotho Loti' currencyshortname = 'Loti'  )
( language = 'E' currency = 'LTL' currencyname = 'Lithuanian Lita' currencyshortname = 'Lita'  )
( language = 'E' currency = 'LUF' currencyname = 'Luxembourg Franc (Old --> EUR)' currencyshortname = 'Lux. Franc'  )
( language = 'E' currency = 'LVL' currencyname = 'Latvian Lat' currencyshortname = 'Lat'  )
( language = 'E' currency = 'LYD' currencyname = 'Libyan Dinar' currencyshortname = 'Libyan Dinar'  )
( language = 'E' currency = 'MAD' currencyname = 'Moroccan Dirham' currencyshortname = 'Dirham'  )
( language = 'E' currency = 'MDL' currencyname = 'Moldavian Leu' currencyshortname = 'Leu'  )
( language = 'E' currency = 'MGA' currencyname = 'Madagascan Ariary' currencyshortname = 'Madagasc.Ariary'  )
( language = 'E' currency = 'MGF' currencyname = 'Madagascan Franc (Old' currencyshortname = 'Madagascan Fr.'  )
( language = 'E' currency = 'MKD' currencyname = 'Macedonian Denar' currencyshortname = 'Maced. Denar'  )
( language = 'E' currency = 'MMK' currencyname = 'Myanmar Kyat' currencyshortname = 'Kyat'  )
( language = 'E' currency = 'MNT' currencyname = 'Mongolian Tugrik' currencyshortname = 'Tugrik'  )
( language = 'E' currency = 'MOP' currencyname = 'Macao Pataca' currencyshortname = 'Pataca'  )
( language = 'E' currency = 'MRO' currencyname = 'Mauritanian Ouguiya' currencyshortname = 'Ouguiya'  )
( language = 'E' currency = 'MTL' currencyname = 'Maltese Lira (Old --> EUR)' currencyshortname = 'Lira'  )
( language = 'E' currency = 'MUR' currencyname = 'Mauritian Rupee' currencyshortname = 'Rupee'  )
( language = 'E' currency = 'MVR' currencyname = 'Maldive Rufiyaa' currencyshortname = 'Rufiyaa'  )
( language = 'E' currency = 'MWK' currencyname = 'Malawi Kwacha' currencyshortname = 'Malawi Kwacha'  )
( language = 'E' currency = 'MXN' currencyname = 'Mexican Pesos' currencyshortname = 'Peso'  )
( language = 'E' currency = 'MYR' currencyname = 'Malaysian Ringgit' currencyshortname = 'Ringgit'  )
( language = 'E' currency = 'MZM' currencyname = 'Mozambique Metical (Old)' currencyshortname = 'Metical'  )
( language = 'E' currency = 'MZN' currencyname = 'Mozambique Metical' currencyshortname = 'Metical'  )
( language = 'E' currency = 'NAD' currencyname = 'Namibian Dollar' currencyshortname = 'Namibian Dollar'  )
( language = 'E' currency = 'NGN' currencyname = 'Nigerian Naira' currencyshortname = 'Naira'  )
( language = 'E' currency = 'NIO' currencyname = 'Nicaraguan Cordoba Oro' currencyshortname = 'Cordoba Oro'  )
( language = 'E' currency = 'NLG' currencyname = 'Dutch Guilder (Old --> EUR)' currencyshortname = 'Guilder'  )
( language = 'E' currency = 'NOK' currencyname = 'Norwegian Krone' currencyshortname = 'Norwegian Krone'  )
( language = 'E' currency = 'NPR' currencyname = 'Nepalese Rupee' currencyshortname = 'Rupee'  )
( language = 'E' currency = 'NZD' currencyname = 'New Zealand Dollars' currencyshortname = 'N.Zeal.Dollars'  )
( language = 'E' currency = 'OMR' currencyname = 'Omani Rial' currencyshortname = 'Omani Rial'  )
( language = 'E' currency = 'PAB' currencyname = 'Panamanian Balboa' currencyshortname = 'Balboa'  )
( language = 'E' currency = 'PEN' currencyname = 'Peruvian New Sol' currencyshortname = 'New Sol'  )
( language = 'E' currency = 'PGK' currencyname = 'Papua New Guinea Kina' currencyshortname = 'Kina'  )
( language = 'E' currency = 'PHP' currencyname = 'Philippine Peso' currencyshortname = 'Peso'  )
( language = 'E' currency = 'PKR' currencyname = 'Pakistani Rupee' currencyshortname = 'Rupee'  )
( language = 'E' currency = 'PLN' currencyname = 'Polish Zloty (new)' currencyshortname = 'Zloty'  )
( language = 'E' currency = 'PTE' currencyname = 'Portuguese Escudo (Old --> EUR)' currencyshortname = 'Escudo'  )
( language = 'E' currency = 'PYG' currencyname = 'Paraguayan Guarani' currencyshortname = 'Guarani'  )
( language = 'E' currency = 'QAR' currencyname = 'Qatar Rial' currencyshortname = 'Rial'  )
( language = 'E' currency = 'RMB' currencyname = 'Chinese Yuan Renminbi' currencyshortname = 'Yuan Renminbi'  )
( language = 'E' currency = 'ROL' currencyname = 'Romanian Leu (Old)' currencyshortname = 'Leu (Old)'  )
( language = 'E' currency = 'RON' currencyname = 'Romanian Leu' currencyshortname = 'Leu'  )
( language = 'E' currency = 'RSD' currencyname = 'Serbian Dinar' currencyshortname = 'Serbian Dinar'  )
( language = 'E' currency = 'RUB' currencyname = 'Russian Ruble' currencyshortname = 'Ruble'  )
( language = 'E' currency = 'RWF' currencyname = 'Rwandan Franc' currencyshortname = 'Franc'  )
( language = 'E' currency = 'SAR' currencyname = 'Saudi Riyal' currencyshortname = 'Rial'  )
( language = 'E' currency = 'SBD' currencyname = 'Solomon Islands Dollar' currencyshortname = 'Sol.Isl.Dollar'  )
( language = 'E' currency = 'SCR' currencyname = 'Seychelles Rupee' currencyshortname = 'Rupee'  )
( language = 'E' currency = 'SDD' currencyname = 'Sudanese Dinar (Old)' currencyshortname = 'Dinar'  )
( language = 'E' currency = 'SDG' currencyname = 'Sudanese Pound' currencyshortname = 'Pound'  )
( language = 'E' currency = 'SDP' currencyname = 'Sudanese Pound (until 1992)' currencyshortname = 'Pound'  )
( language = 'E' currency = 'SEK' currencyname = 'Swedish Krona' currencyshortname = 'Swedish Krona'  )
( language = 'E' currency = 'SGD' currencyname = 'Singapore Dollar' currencyshortname = 'Sing.Dollar'  )
( language = 'E' currency = 'SHP' currencyname = 'St.Helena Pound' currencyshortname = 'St.Helena Pound'  )
( language = 'E' currency = 'SIT' currencyname = 'Slovenian Tolar (Old --> EUR)' currencyshortname = 'Tolar'  )
( language = 'E' currency = 'SKK' currencyname = 'Slovakian Krona (Old --> EUR)' currencyshortname = 'Krona'  )
( language = 'E' currency = 'SLL' currencyname = 'Sierra Leone Leone' currencyshortname = 'Leone'  )
( language = 'E' currency = 'SOS' currencyname = 'Somalian Shilling' currencyshortname = 'Shilling'  )
( language = 'E' currency = 'SRD' currencyname = 'Surinam Dollar' currencyshortname = 'Surinam Doillar'  )
( language = 'E' currency = 'SRG' currencyname = 'Surinam Guilder (Old)' currencyshortname = 'Surinam Guilder'  )
( language = 'E' currency = 'SSP' currencyname = 'South Sudanese Pound' currencyshortname = 'Pound'  )
( language = 'E' currency = 'STD' currencyname = 'Sao Tome / Principe Dobra' currencyshortname = 'Dobra'  )
( language = 'E' currency = 'SVC' currencyname = 'El Salvador Colon' currencyshortname = 'Colon'  )
( language = 'E' currency = 'SYP' currencyname = 'Syrian Pound' currencyshortname = 'Syrian Pound'  )
( language = 'E' currency = 'SZL' currencyname = 'Swaziland Lilangeni' currencyshortname = 'Lilangeni'  )
( language = 'E' currency = 'THB' currencyname = 'Thailand Baht' currencyshortname = 'Baht'  )
( language = 'E' currency = 'TJR' currencyname = 'Tajikistani Ruble (Old)' currencyshortname = 'Ruble'  )
( language = 'E' currency = 'TJS' currencyname = 'Tajikistani Somoni' currencyshortname = 'Somoni'  )
( language = 'E' currency = 'TMM' currencyname = 'Turkmenistani Manat (Old)' currencyshortname = 'Manat (Old)'  )
( language = 'E' currency = 'TMT' currencyname = 'Turkmenistani Manat' currencyshortname = 'Manat'  )
( language = 'E' currency = 'TND' currencyname = 'Tunisian Dinar' currencyshortname = 'Dinar'  )
( language = 'E' currency = 'TOP' currencyname = 'Tongan Pa''anga' currencyshortname = 'Pa''anga'  )
( language = 'E' currency = 'TPE' currencyname = 'Timor Escudo --> USD' currencyshortname = 'Timor Escudo'  )
( language = 'E' currency = 'TRL' currencyname = 'Turkish Lira (Old)' currencyshortname = 'Lira (Old)'  )
( language = 'E' currency = 'TRY' currencyname = 'Turkish Lira' currencyshortname = 'Lira'  )
( language = 'E' currency = 'TTD' currencyname = 'Trinidad and Tobago Dollar' currencyshortname = 'T.+ T. Dollar'  )
( language = 'E' currency = 'TWD' currencyname = 'New Taiwan Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'TZS' currencyname = 'Tanzanian Shilling' currencyshortname = 'Shilling'  )
( language = 'E' currency = 'UAH' currencyname = 'Ukraine Hryvnia' currencyshortname = 'Hryvnia'  )
( language = 'E' currency = 'UGX' currencyname = 'Ugandan Shilling' currencyshortname = 'Shilling'  )
( language = 'E' currency = 'USD' currencyname = 'United States Dollar' currencyshortname = 'US Dollar'  )
( language = 'E' currency = 'USDN' currencyname = '(Internal) United States Dollar (5 Dec.)' currencyshortname = 'US Dollar'  )
( language = 'E' currency = 'UYU' currencyname = 'Uruguayan Peso' currencyshortname = 'Peso'  )
( language = 'E' currency = 'UZS' currencyname = 'Uzbekistan Som' currencyshortname = 'Total'  )
( language = 'E' currency = 'VEB' currencyname = 'Venezuelan Bolivar (Old)' currencyshortname = 'Bolivar (Old)'  )
( language = 'E' currency = 'VEF' currencyname = 'Venezuelan Bolivar' currencyshortname = 'Bolivar'  )
( language = 'E' currency = 'VND' currencyname = 'Vietnamese Dong' currencyshortname = 'Dong'  )
( language = 'E' currency = 'VUV' currencyname = 'Vanuatu Vatu' currencyshortname = 'Vatu'  )
( language = 'E' currency = 'WST' currencyname = 'Samoan Tala' currencyshortname = 'Tala'  )
( language = 'E' currency = 'XAF' currencyname = 'Gabon CFA Franc BEAC' currencyshortname = 'CFA Franc BEAC'  )
( language = 'E' currency = 'XCD' currencyname = 'East Carribean Dollar' currencyshortname = 'Dollar'  )
( language = 'E' currency = 'XEU' currencyname = 'European Currency Unit (E.C.U.)' currencyshortname = 'E.C.U.'  )
( language = 'E' currency = 'XOF' currencyname = 'Benin CFA Franc BCEAO' currencyshortname = 'CFA Franc BCEAO'  )
( language = 'E' currency = 'XPF' currencyname = 'CFP Franc' currencyshortname = 'Franc'  )
( language = 'E' currency = 'YER' currencyname = 'Yemeni Ryal' currencyshortname = 'Yemeni Ryal'  )
( language = 'E' currency = 'YUM' currencyname = 'New Yugoslavian Dinar (Old)' currencyshortname = 'New Dinar'  )
( language = 'E' currency = 'ZAR' currencyname = 'South African Rand' currencyshortname = 'Rand'  )
( language = 'E' currency = 'ZMK' currencyname = 'Zambian Kwacha (Old)' currencyshortname = 'Kwacha'  )
( language = 'E' currency = 'ZMW' currencyname = 'Zambian Kwacha (New)' currencyshortname = 'Kwacha'  )
( language = 'E' currency = 'ZRN' currencyname = 'Zaire (Old)' currencyshortname = 'Zaire'  )
( language = 'E' currency = 'ZWD' currencyname = 'Zimbabwean Dollar (Old)' currencyshortname = 'Zimbabwe Dollar'  )
( language = 'E' currency = 'ZWL' currencyname = 'Zimbabwean Dollar (New)' currencyshortname = 'Zimbabwe Dollar'  )
( language = 'E' currency = 'ZWN' currencyname = 'Zimbabwean Dollar (Old)' currencyshortname = 'Zimbabwe Dollar'  )
( language = 'E' currency = 'ZWR' currencyname = 'Zimbabwean Dollar (Old)' currencyshortname = 'Zimbabwe Dollar'  )
 ).

  ENDMETHOD.

ENDCLASS.
