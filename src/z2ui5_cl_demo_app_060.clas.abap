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
    DATA mt_suggestion     TYPE STANDARD TABLE OF ty_s_currency.
    DATA input             TYPE string.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_060 IMPLEMENTATION.

  METHOD set_data.

    TYPES:
      BEGIN OF ty_s_currency,
        language          TYPE string,
        currency          TYPE string,
        currencyname      TYPE string,
        currencyshortname TYPE string,
      END OF ty_s_currency.

    mt_suggestion = VALUE #(
        Language = 'E'
        ( Currency = 'ADP' CurrencyName = 'Andorran Peseta --> (Old --> EUR)' CurrencyShortName = 'Peseta'  )
        ( Currency = 'AED' CurrencyName = 'United Arab Emirates Dirham' CurrencyShortName = 'Dirham'  )
        ( Currency = 'AFA' CurrencyName = 'Afghani (Old)' CurrencyShortName = 'Afghani'  )
        ( Currency = 'AFN' CurrencyName = 'Afghani' CurrencyShortName = 'Afghani'  )
        ( Currency = 'ALL' CurrencyName = 'Albanian Lek' CurrencyShortName = 'Lek'  )
        ( Currency = 'AMD' CurrencyName = 'Armenian Dram' CurrencyShortName = 'Dram'  )
        ( Currency = 'ANG' CurrencyName = 'West Indian Guilder' CurrencyShortName = 'W.Ind.Guilder'  )
        ( Currency = 'AOA' CurrencyName = 'Angolanische Kwanza' CurrencyShortName = 'Kwansa'  )
        ( Currency = 'AON' CurrencyName = 'Angolan New Kwanza (Old)' CurrencyShortName = 'New Kwanza'  )
        ( Currency = 'AOR' CurrencyName = 'Angolan Kwanza Reajustado (Old)' CurrencyShortName = 'Kwanza Reajust.'  )
        ( Currency = 'ARS' CurrencyName = 'Argentine Peso' CurrencyShortName = 'Arg. Peso'  )
        ( Currency = 'ATS' CurrencyName = 'Austrian Schilling (Old --> EUR)' CurrencyShortName = 'Shilling'  )
        ( Currency = 'AUD' CurrencyName = 'Australian Dollar' CurrencyShortName = 'Austr. Dollar'  )
        ( Currency = 'AWG' CurrencyName = 'Aruban Florin' CurrencyShortName = 'Aruban Florin'  )
        ( Currency = 'AZM' CurrencyName = 'Azerbaijani Manat (Old)' CurrencyShortName = 'Manat'  )
        ( Currency = 'AZN' CurrencyName = 'Azerbaijani Manat' CurrencyShortName = 'Manat'  )
        ( Currency = 'BAM' CurrencyName = 'Bosnia and Herzegovina Convertible Mark' CurrencyShortName = 'Convert. Mark'  )
        ( Currency = 'BBD' CurrencyName = 'Barbados Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'BDT' CurrencyName = 'Bangladesh Taka' CurrencyShortName = 'Taka'  )
        ( Currency = 'BEF' CurrencyName = 'Belgian Franc (Old --> EUR)' CurrencyShortName = 'Belgian Franc'  )
        ( Currency = 'BGN' CurrencyName = 'Bulgarian Lev' CurrencyShortName = 'Lev'  )
        ( Currency = 'BHD' CurrencyName = 'Bahraini Dinar' CurrencyShortName = 'Dinar'  )
        ( Currency = 'BIF' CurrencyName = 'Burundi Franc' CurrencyShortName = 'Burundi Franc'  )
        ( Currency = 'BMD' CurrencyName = 'Bermudan Dollar' CurrencyShortName = 'Bermudan Dollar'  )
        ( Currency = 'BND' CurrencyName = 'Brunei Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'BOB' CurrencyName = 'Boliviano' CurrencyShortName = 'Boliviano'  )
        ( Currency = 'BRL' CurrencyName = 'Brazilian Real' CurrencyShortName = 'Real'  )
        ( Currency = 'BSD' CurrencyName = 'Bahaman Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'BTN' CurrencyName = 'Bhutan Ngultrum' CurrencyShortName = 'Ngultrum'  )
        ( Currency = 'BWP' CurrencyName = 'Botswana Pula' CurrencyShortName = 'Pula'  )
        ( Currency = 'BYB' CurrencyName = 'Belarusian Ruble (Old)' CurrencyShortName = 'Belarus. Ruble'  )
        ( Currency = 'BYN' CurrencyName = 'Belarusian Ruble (New)' CurrencyShortName = 'Bela. Ruble N.'  )
        ( Currency = 'BYR' CurrencyName = 'Belarusian Ruble' CurrencyShortName = 'Ruble'  )
        ( Currency = 'BZD' CurrencyName = 'Belize Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'CAD' CurrencyName = 'Canadian Dollar' CurrencyShortName = 'Canadian Dollar'  )
        ( Currency = 'CDF' CurrencyName = 'Congolese Franc' CurrencyShortName = 'test data'  )
        ( Currency = 'CFP' CurrencyName = 'French Franc (Pacific Islands)' CurrencyShortName = 'Fr. Franc (Pac)'  )
        ( Currency = 'CHF' CurrencyName = 'Swiss Franc' CurrencyShortName = 'Swiss Franc'  )
        ( Currency = 'CLP' CurrencyName = 'Chilean Peso' CurrencyShortName = 'Peso'  )
        ( Currency = 'CNY' CurrencyName = 'Chinese Renminbi' CurrencyShortName = 'Renminbi'  )
        ( Currency = 'COP' CurrencyName = 'Colombian Peso' CurrencyShortName = 'Peso'  )
        ( Currency = 'CRC' CurrencyName = 'Costa Rica Colon' CurrencyShortName = 'Cost.Rica Colon'  )
        ( Currency = 'CSD' CurrencyName = 'Serbian Dinar (Old)' CurrencyShortName = 'Serbian Dinar'  )
        ( Currency = 'CUC' CurrencyName = 'Peso Convertible' CurrencyShortName = 'Peso Convertib.'  )
        ( Currency = 'CUP' CurrencyName = 'Cuban Peso' CurrencyShortName = 'Cuban Peso'  )
        ( Currency = 'CVE' CurrencyName = 'Cape Verde Escudo' CurrencyShortName = 'Escudo'  )
        ( Currency = 'CYP' CurrencyName = 'Cyprus Pound  (Old --> EUR)' CurrencyShortName = 'Cyprus Pound'  )
        ( Currency = 'CZK' CurrencyName = 'Czech Krona' CurrencyShortName = 'Krona'  )
        ( Currency = 'DEM' CurrencyName = 'German Mark    (Old --> EUR)' CurrencyShortName = 'German Mark'  )
        ( Currency = 'DEM3' CurrencyName = '(Internal) German Mark (3 dec.places)' CurrencyShortName = '(Int.) DEM 3 DP'  )
        ( Currency = 'DJF' CurrencyName = 'Djibouti Franc' CurrencyShortName = 'Djibouti Franc'  )
        ( Currency = 'DKK' CurrencyName = 'Danish Krone' CurrencyShortName = 'Danish Krone'  )
        ( Currency = 'DOP' CurrencyName = 'Dominican Peso' CurrencyShortName = 'Dominican Peso'  )
        ( Currency = 'DZD' CurrencyName = 'Algerian Dinar' CurrencyShortName = 'Dinar'  )
        ( Currency = 'ECS' CurrencyName = 'Ecuadorian Sucre (Old --> USD)' CurrencyShortName = 'Sucre'  )
        ( Currency = 'EEK' CurrencyName = 'Estonian Krone (Old --> EUR)' CurrencyShortName = 'Krona'  )
        ( Currency = 'EGP' CurrencyName = 'Egyptian Pound' CurrencyShortName = 'Pound'  )
        ( Currency = 'ERN' CurrencyName = 'Eritrean Nafka' CurrencyShortName = 'Nakfa'  )
        ( Currency = 'ESP' CurrencyName = 'Spanish Peseta (Old --> EUR)' CurrencyShortName = 'Peseta'  )
        ( Currency = 'ETB' CurrencyName = 'Ethiopian Birr' CurrencyShortName = 'Birr'  )
        ( Currency = 'EUR' CurrencyName = 'European Euro' CurrencyShortName = 'Euro'  )
        ( Currency = 'FIM' CurrencyName = 'Finnish Markka (Old --> EUR)' CurrencyShortName = 'Finnish markka'  )
        ( Currency = 'FJD' CurrencyName = 'Fiji Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'FKP' CurrencyName = 'Falkland Pound' CurrencyShortName = 'Falkland Pound'  )
        ( Currency = 'FRF' CurrencyName = 'French Franc (Old --> EUR)' CurrencyShortName = 'French Franc'  )
        ( Currency = 'GBP' CurrencyName = 'British Pound' CurrencyShortName = 'Pound sterling'  )
        ( Currency = 'GEL' CurrencyName = 'Georgian Lari' CurrencyShortName = 'Lari'  )
        ( Currency = 'GHC' CurrencyName = 'Ghanaian Cedi (Old)' CurrencyShortName = 'Cedi'  )
        ( Currency = 'GHS' CurrencyName = 'Ghanian Cedi' CurrencyShortName = 'Cedi'  )
        ( Currency = 'GIP' CurrencyName = 'Gibraltar Pound' CurrencyShortName = 'Gibraltar Pound'  )
        ( Currency = 'GMD' CurrencyName = 'Gambian Dalasi' CurrencyShortName = 'Dalasi'  )
        ( Currency = 'GNF' CurrencyName = 'Guinean Franc' CurrencyShortName = 'Franc'  )
        ( Currency = 'GRD' CurrencyName = 'Greek Drachma (Old --> EUR)' CurrencyShortName = 'Drachma'  )
        ( Currency = 'GTQ' CurrencyName = 'Guatemalan Quetzal' CurrencyShortName = 'Quetzal'  )
        ( Currency = 'GWP' CurrencyName = 'Guinea Peso (Old --> SHP)' CurrencyShortName = 'Guinea Peso'  )
        ( Currency = 'GYD' CurrencyName = 'Guyana Dollar' CurrencyShortName = 'Guyana Dollar'  )
        ( Currency = 'HKD' CurrencyName = 'Hong Kong Dollar' CurrencyShortName = 'H.K.Dollar'  )
        ( Currency = 'HNL' CurrencyName = 'Honduran Lempira' CurrencyShortName = 'Lempira'  )
        ( Currency = 'HRK' CurrencyName = 'Croatian Kuna' CurrencyShortName = 'Kuna'  )
        ( Currency = 'HTG' CurrencyName = 'Haitian Gourde' CurrencyShortName = 'Gourde'  )
        ( Currency = 'HUF' CurrencyName = 'Hungarian Forint' CurrencyShortName = 'Forint'  )
        ( Currency = 'IDR' CurrencyName = 'Indonesian Rupiah' CurrencyShortName = 'Rupiah'  )
        ( Currency = 'IEP' CurrencyName = 'Irish Punt (Old --> EUR)' CurrencyShortName = 'Irish Punt'  )
        ( Currency = 'ILS' CurrencyName = 'Israeli Scheckel' CurrencyShortName = 'Scheckel'  )
        ( Currency = 'INR' CurrencyName = 'Indian Rupee' CurrencyShortName = 'Rupee'  )
        ( Currency = 'IQD' CurrencyName = 'Iraqui Dinar' CurrencyShortName = 'Dinar'  )
        ( Currency = 'IRR' CurrencyName = 'Iranian Rial' CurrencyShortName = 'Rial'  )
        ( Currency = 'ISK' CurrencyName = 'Iceland Krona' CurrencyShortName = 'Krona'  )
        ( Currency = 'ITL' CurrencyName = 'Italian Lira (Old --> EUR)' CurrencyShortName = 'Lire'  )
        ( Currency = 'JMD' CurrencyName = 'Jamaican Dollar' CurrencyShortName = 'Jamaican Dollar'  )
        ( Currency = 'JOD' CurrencyName = 'Jordanian Dinar' CurrencyShortName = 'Jordanian Dinar'  )
        ( Currency = 'JPY' CurrencyName = 'Japanese Yen' CurrencyShortName = 'Yen'  )
        ( Currency = 'KES' CurrencyName = 'Kenyan Shilling' CurrencyShortName = 'Shilling'  )
        ( Currency = 'KGS' CurrencyName = 'Kyrgyzstan Som' CurrencyShortName = 'Som'  )
        ( Currency = 'KHR' CurrencyName = 'Cambodian Riel' CurrencyShortName = 'Riel'  )
        ( Currency = 'KMF' CurrencyName = 'Comoros Franc' CurrencyShortName = 'Comoros Franc'  )
        ( Currency = 'KPW' CurrencyName = 'North Korean Won' CurrencyShortName = 'N. Korean Won'  )
        ( Currency = 'KRW' CurrencyName = 'South Korean Won' CurrencyShortName = 'S.Korean Won'  )
        ( Currency = 'KWD' CurrencyName = 'Kuwaiti Dinar' CurrencyShortName = 'Dinar'  )
        ( Currency = 'KYD' CurrencyName = 'Cayman Dollar' CurrencyShortName = 'Cayman Dollar'  )
        ( Currency = 'KZT' CurrencyName = 'Kazakstanian Tenge' CurrencyShortName = 'Tenge'  )
        ( Currency = 'LAK' CurrencyName = 'Laotian Kip' CurrencyShortName = 'Kip'  )
        ( Currency = 'LBP' CurrencyName = 'Lebanese Pound' CurrencyShortName = 'Lebanese Pound'  )
        ( Currency = 'LKR' CurrencyName = 'Sri Lankan Rupee' CurrencyShortName = 'Sri Lanka Rupee'  )
        ( Currency = 'LRD' CurrencyName = 'Liberian Dollar' CurrencyShortName = 'Liberian Dollar'  )
        ( Currency = 'LSL' CurrencyName = 'Lesotho Loti' CurrencyShortName = 'Loti'  )
        ( Currency = 'LTL' CurrencyName = 'Lithuanian Lita' CurrencyShortName = 'Lita'  )
        ( Currency = 'LUF' CurrencyName = 'Luxembourg Franc (Old --> EUR)' CurrencyShortName = 'Lux. Franc'  )
        ( Currency = 'LVL' CurrencyName = 'Latvian Lat' CurrencyShortName = 'Lat'  )
        ( Currency = 'LYD' CurrencyName = 'Libyan Dinar' CurrencyShortName = 'Libyan Dinar'  )
        ( Currency = 'MAD' CurrencyName = 'Moroccan Dirham' CurrencyShortName = 'Dirham'  )
        ( Currency = 'MDL' CurrencyName = 'Moldavian Leu' CurrencyShortName = 'Leu'  )
        ( Currency = 'MGA' CurrencyName = 'Madagascan Ariary' CurrencyShortName = 'Madagasc.Ariary'  )
        ( Currency = 'MGF' CurrencyName = 'Madagascan Franc (Old' CurrencyShortName = 'Madagascan Fr.'  )
        ( Currency = 'MKD' CurrencyName = 'Macedonian Denar' CurrencyShortName = 'Maced. Denar'  )
        ( Currency = 'MMK' CurrencyName = 'Myanmar Kyat' CurrencyShortName = 'Kyat'  )
        ( Currency = 'MNT' CurrencyName = 'Mongolian Tugrik' CurrencyShortName = 'Tugrik'  )
        ( Currency = 'MOP' CurrencyName = 'Macao Pataca' CurrencyShortName = 'Pataca'  )
        ( Currency = 'MRO' CurrencyName = 'Mauritanian Ouguiya' CurrencyShortName = 'Ouguiya'  )
        ( Currency = 'MTL' CurrencyName = 'Maltese Lira (Old --> EUR)' CurrencyShortName = 'Lira'  )
        ( Currency = 'MUR' CurrencyName = 'Mauritian Rupee' CurrencyShortName = 'Rupee'  )
        ( Currency = 'MVR' CurrencyName = 'Maldive Rufiyaa' CurrencyShortName = 'Rufiyaa'  )
        ( Currency = 'MWK' CurrencyName = 'Malawi Kwacha' CurrencyShortName = 'Malawi Kwacha'  )
        ( Currency = 'MXN' CurrencyName = 'Mexican Pesos' CurrencyShortName = 'Peso'  )
        ( Currency = 'MYR' CurrencyName = 'Malaysian Ringgit' CurrencyShortName = 'Ringgit'  )
        ( Currency = 'MZM' CurrencyName = 'Mozambique Metical (Old)' CurrencyShortName = 'Metical'  )
        ( Currency = 'MZN' CurrencyName = 'Mozambique Metical' CurrencyShortName = 'Metical'  )
        ( Currency = 'NAD' CurrencyName = 'Namibian Dollar' CurrencyShortName = 'Namibian Dollar'  )
        ( Currency = 'NGN' CurrencyName = 'Nigerian Naira' CurrencyShortName = 'Naira'  )
        ( Currency = 'NIO' CurrencyName = 'Nicaraguan Cordoba Oro' CurrencyShortName = 'Cordoba Oro'  )
        ( Currency = 'NLG' CurrencyName = 'Dutch Guilder (Old --> EUR)' CurrencyShortName = 'Guilder'  )
        ( Currency = 'NOK' CurrencyName = 'Norwegian Krone' CurrencyShortName = 'Norwegian Krone'  )
        ( Currency = 'NPR' CurrencyName = 'Nepalese Rupee' CurrencyShortName = 'Rupee'  )
        ( Currency = 'NZD' CurrencyName = 'New Zealand Dollars' CurrencyShortName = 'N.Zeal.Dollars'  )
        ( Currency = 'OMR' CurrencyName = 'Omani Rial' CurrencyShortName = 'Omani Rial'  )
        ( Currency = 'PAB' CurrencyName = 'Panamanian Balboa' CurrencyShortName = 'Balboa'  )
        ( Currency = 'PEN' CurrencyName = 'Peruvian New Sol' CurrencyShortName = 'New Sol'  )
        ( Currency = 'PGK' CurrencyName = 'Papua New Guinea Kina' CurrencyShortName = 'Kina'  )
        ( Currency = 'PHP' CurrencyName = 'Philippine Peso' CurrencyShortName = 'Peso'  )
        ( Currency = 'PKR' CurrencyName = 'Pakistani Rupee' CurrencyShortName = 'Rupee'  )
        ( Currency = 'PLN' CurrencyName = 'Polish Zloty (new)' CurrencyShortName = 'Zloty'  )
        ( Currency = 'PTE' CurrencyName = 'Portuguese Escudo (Old --> EUR)' CurrencyShortName = 'Escudo'  )
        ( Currency = 'PYG' CurrencyName = 'Paraguayan Guarani' CurrencyShortName = 'Guarani'  )
        ( Currency = 'QAR' CurrencyName = 'Qatar Rial' CurrencyShortName = 'Rial'  )
        ( Currency = 'RMB' CurrencyName = 'Chinese Yuan Renminbi' CurrencyShortName = 'Yuan Renminbi'  )
        ( Currency = 'ROL' CurrencyName = 'Romanian Leu (Old)' CurrencyShortName = 'Leu (Old)'  )
        ( Currency = 'RON' CurrencyName = 'Romanian Leu' CurrencyShortName = 'Leu'  )
        ( Currency = 'RSD' CurrencyName = 'Serbian Dinar' CurrencyShortName = 'Serbian Dinar'  )
        ( Currency = 'RUB' CurrencyName = 'Russian Ruble' CurrencyShortName = 'Ruble'  )
        ( Currency = 'RWF' CurrencyName = 'Rwandan Franc' CurrencyShortName = 'Franc'  )
        ( Currency = 'SAR' CurrencyName = 'Saudi Riyal' CurrencyShortName = 'Rial'  )
        ( Currency = 'SBD' CurrencyName = 'Solomon Islands Dollar' CurrencyShortName = 'Sol.Isl.Dollar'  )
        ( Currency = 'SCR' CurrencyName = 'Seychelles Rupee' CurrencyShortName = 'Rupee'  )
        ( Currency = 'SDD' CurrencyName = 'Sudanese Dinar (Old)' CurrencyShortName = 'Dinar'  )
        ( Currency = 'SDG' CurrencyName = 'Sudanese Pound' CurrencyShortName = 'Pound'  )
        ( Currency = 'SDP' CurrencyName = 'Sudanese Pound (until 1992)' CurrencyShortName = 'Pound'  )
        ( Currency = 'SEK' CurrencyName = 'Swedish Krona' CurrencyShortName = 'Swedish Krona'  )
        ( Currency = 'SGD' CurrencyName = 'Singapore Dollar' CurrencyShortName = 'Sing.Dollar'  )
        ( Currency = 'SHP' CurrencyName = 'St.Helena Pound' CurrencyShortName = 'St.Helena Pound'  )
        ( Currency = 'SIT' CurrencyName = 'Slovenian Tolar (Old --> EUR)' CurrencyShortName = 'Tolar'  )
        ( Currency = 'SKK' CurrencyName = 'Slovakian Krona (Old --> EUR)' CurrencyShortName = 'Krona'  )
        ( Currency = 'SLL' CurrencyName = 'Sierra Leone Leone' CurrencyShortName = 'Leone'  )
        ( Currency = 'SOS' CurrencyName = 'Somalian Shilling' CurrencyShortName = 'Shilling'  )
        ( Currency = 'SRD' CurrencyName = 'Surinam Dollar' CurrencyShortName = 'Surinam Doillar'  )
        ( Currency = 'SRG' CurrencyName = 'Surinam Guilder (Old)' CurrencyShortName = 'Surinam Guilder'  )
        ( Currency = 'SSP' CurrencyName = 'South Sudanese Pound' CurrencyShortName = 'Pound'  )
        ( Currency = 'STD' CurrencyName = 'Sao Tome / Principe Dobra' CurrencyShortName = 'Dobra'  )
        ( Currency = 'SVC' CurrencyName = 'El Salvador Colon' CurrencyShortName = 'Colon'  )
        ( Currency = 'SYP' CurrencyName = 'Syrian Pound' CurrencyShortName = 'Syrian Pound'  )
        ( Currency = 'SZL' CurrencyName = 'Swaziland Lilangeni' CurrencyShortName = 'Lilangeni'  )
        ( Currency = 'THB' CurrencyName = 'Thailand Baht' CurrencyShortName = 'Baht'  )
        ( Currency = 'TJR' CurrencyName = 'Tajikistani Ruble (Old)' CurrencyShortName = 'Ruble'  )
        ( Currency = 'TJS' CurrencyName = 'Tajikistani Somoni' CurrencyShortName = 'Somoni'  )
        ( Currency = 'TMM' CurrencyName = 'Turkmenistani Manat (Old)' CurrencyShortName = 'Manat (Old)'  )
        ( Currency = 'TMT' CurrencyName = 'Turkmenistani Manat' CurrencyShortName = 'Manat'  )
        ( Currency = 'TND' CurrencyName = 'Tunisian Dinar' CurrencyShortName = 'Dinar'  )
        ( Currency = 'TOP' CurrencyName = 'Tongan Pa''anga' CurrencyShortName = 'Pa''anga'  )
        ( Currency = 'TPE' CurrencyName = 'Timor Escudo --> USD' CurrencyShortName = 'Timor Escudo'  )
        ( Currency = 'TRL' CurrencyName = 'Turkish Lira (Old)' CurrencyShortName = 'Lira (Old)'  )
        ( Currency = 'TRY' CurrencyName = 'Turkish Lira' CurrencyShortName = 'Lira'  )
        ( Currency = 'TTD' CurrencyName = 'Trinidad and Tobago Dollar' CurrencyShortName = 'T.+ T. Dollar'  )
        ( Currency = 'TWD' CurrencyName = 'New Taiwan Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'TZS' CurrencyName = 'Tanzanian Shilling' CurrencyShortName = 'Shilling'  )
        ( Currency = 'UAH' CurrencyName = 'Ukraine Hryvnia' CurrencyShortName = 'Hryvnia'  )
        ( Currency = 'UGX' CurrencyName = 'Ugandan Shilling' CurrencyShortName = 'Shilling'  )
        ( Currency = 'USD' CurrencyName = 'United States Dollar' CurrencyShortName = 'US Dollar'  )
        ( Currency = 'USDN' CurrencyName = '(Internal) United States Dollar (5 Dec.)' CurrencyShortName = 'US Dollar'  )
        ( Currency = 'UYU' CurrencyName = 'Uruguayan Peso' CurrencyShortName = 'Peso'  )
        ( Currency = 'UZS' CurrencyName = 'Uzbekistan Som' CurrencyShortName = 'Total'  )
        ( Currency = 'VEB' CurrencyName = 'Venezuelan Bolivar (Old)' CurrencyShortName = 'Bolivar (Old)'  )
        ( Currency = 'VEF' CurrencyName = 'Venezuelan Bolivar' CurrencyShortName = 'Bolivar'  )
        ( Currency = 'VND' CurrencyName = 'Vietnamese Dong' CurrencyShortName = 'Dong'  )
        ( Currency = 'VUV' CurrencyName = 'Vanuatu Vatu' CurrencyShortName = 'Vatu'  )
        ( Currency = 'WST' CurrencyName = 'Samoan Tala' CurrencyShortName = 'Tala'  )
        ( Currency = 'XAF' CurrencyName = 'Gabon CFA Franc BEAC' CurrencyShortName = 'CFA Franc BEAC'  )
        ( Currency = 'XCD' CurrencyName = 'East Carribean Dollar' CurrencyShortName = 'Dollar'  )
        ( Currency = 'XEU' CurrencyName = 'European Currency Unit (E.C.U.)' CurrencyShortName = 'E.C.U.'  )
        ( Currency = 'XOF' CurrencyName = 'Benin CFA Franc BCEAO' CurrencyShortName = 'CFA Franc BCEAO'  )
        ( Currency = 'XPF' CurrencyName = 'CFP Franc' CurrencyShortName = 'Franc'  )
        ( Currency = 'YER' CurrencyName = 'Yemeni Ryal' CurrencyShortName = 'Yemeni Ryal'  )
        ( Currency = 'YUM' CurrencyName = 'New Yugoslavian Dinar (Old)' CurrencyShortName = 'New Dinar'  )
        ( Currency = 'ZAR' CurrencyName = 'South African Rand' CurrencyShortName = 'Rand'  )
        ( Currency = 'ZMK' CurrencyName = 'Zambian Kwacha (Old)' CurrencyShortName = 'Kwacha'  )
        ( Currency = 'ZMW' CurrencyName = 'Zambian Kwacha (New)' CurrencyShortName = 'Kwacha'  )
        ( Currency = 'ZRN' CurrencyName = 'Zaire (Old)' CurrencyShortName = 'Zaire'  )
        ( Currency = 'ZWD' CurrencyName = 'Zimbabwean Dollar (Old)' CurrencyShortName = 'Zimbabwe Dollar'  )
        ( Currency = 'ZWL' CurrencyName = 'Zimbabwean Dollar (New)' CurrencyShortName = 'Zimbabwe Dollar'  )
        ( Currency = 'ZWN' CurrencyName = 'Zimbabwean Dollar (Old)' CurrencyShortName = 'Zimbabwe Dollar'  )
        ( Currency = 'ZWR' CurrencyName = 'Zimbabwean Dollar (Old)' CurrencyShortName = 'Zimbabwe Dollar'  ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.

      DATA(lv_script) = |   debugger;| && |\n| &&
                  |function setInputFIlter()\{| && |\n| &&
                  | var inp = sap.z2ui5.oView.byId('suggInput');| && |\n| &&
                  | inp.setFilterFunction(function(sValue, oItem)\{| && |\n| &&

                  |   var aSplit = sValue.split(" ");| && |\n| &&
                  |   if (aSplit.length > 0) \{| && |\n| &&
                  |     var sTermNew = aSplit.slice(-1)[0];| && |\n| &&
                  |     sTermNew.trim();| && |\n| &&
                  |     if (sTermNew) \{| && |\n| &&
                  |       if (oItem.mAggregations.cells[0].mProperties.text.match(new RegExp(sTermNew, "i"))| && |\n| &&
                  |           \|\| oItem.mAggregations.cells[1].mProperties.text.match(new RegExp(sTermNew, "i")) ) \{| && |\n| &&
                  |         return true;| && |\n| &&
                  |       \} else return false;| && |\n| &&
                  |     \}| && |\n| &&
                  |   \}| && |\n| &&
                  | \});| && |\n| &&
                  |\}|.

      check_initialized = abap_true.
      set_data( ).

      client->view_display( z2ui5_cl_xml_view=>factory(
       )->_z2ui5( )->timer( client->_event( `START` )
         )->_generic( ns   = `html`
                      name = `script` )->_cc_plain_xml( lv_script
         )->stringify( ) ).

    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_view_display( ).
      WHEN 'ON_SUGGEST'.

        DATA lt_range TYPE RANGE OF string.
        lt_range = VALUE #( (  sign = 'I' option = 'CP' low = |*{ input }*| ) ).

        CLEAR mt_suggestion_out.
        LOOP AT mt_suggestion INTO DATA(ls_sugg)
             WHERE CurrencyName IN lt_range.
          INSERT ls_sugg INTO TABLE mt_suggestion_out.
        ENDLOOP.

*        SELECT FROM i_currencytext
*          FIELDS *
*          WHERE currencyname IN @lt_range
*          AND  language = 'E'
*          INTO CORRESPONDING FIELDS OF TABLE @mt_suggestion.

        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page(
                     title          = 'abap2UI5 - Live Suggestion Event'
                     navbuttonpress = client->_event( 'BACK' )
                     shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA(input) = grid->simple_form( 'Input'
        )->content( 'form'
            )->label( 'Input with value help'
            )->input( id                           = `suggInput`
                      value                        = client->_bind_edit( input )
                      suggest                      = client->_event( 'ON_SUGGEST' )
                      showtablesuggestionvaluehelp = abap_false
                      suggestionrows               = client->_bind( mt_suggestion_out )
                      showsuggestion               = abap_true
                      valueliveupdate              = abap_true
                      autocomplete                 = abap_false
                 )->get( ).

    input->suggestion_columns(
        )->column( )->label( text = 'Name' )->get_parent(
        )->column( )->label( text = 'Currency' ).

    input->suggestion_rows(
        )->column_list_item(
            )->label( text = '{CURRENCYNAME}'
            )->label( text = '{CURRENCY}' ).

    page->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( `setInputFIlter()` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
