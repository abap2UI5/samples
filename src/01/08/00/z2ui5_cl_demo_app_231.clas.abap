"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelection
"! The Date Range Selection is an extension of the Date Picker Control and enables the user to select
"! range of dates.
CLASS z2ui5_cl_demo_app_231 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_drs,
        start      TYPE d,
        end        TYPE d,
        valuestate TYPE string,
      END OF ty_s_drs.

    DATA drs1    TYPE ty_s_drs.
    DATA drs2    TYPE ty_s_drs.
    DATA drs3    TYPE ty_s_drs.
    DATA drs4    TYPE ty_s_drs.
    DATA drs5    TYPE ty_s_drs.
    DATA mindate TYPE d VALUE `20160101`.
    DATA maxdate TYPE d VALUE `20161231`.
    DATA text    TYPE string.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS initialize.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_231 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic_property( VALUE #( n = `core:require` v = `{Helper:'z2ui5/Util'}` ) ).

    DATA(page) = view->shell(
                    )->page(
                        title          = `abap2UI5 - Sample: Date Range Selection`
                        navbuttonpress = client->_event_nav_app_leave( )
                        shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelection` ).

    DATA(vbox) = page->vbox( `sapUiSmallMargin` ).

    " DRS1
    vbox->label( text     = `DateRangeSelection displayFormat 'yyyy/MM/dd', set via binding:`
                 labelfor = `DRS1`
       )->date_range_selection(
            id              = `DRS1`
            displayformat   = `yyyy/MM/dd`
            valuestate      = client->_bind( drs1-valuestate )
            change          = client->_event( val = `handleChange` t_arg = VALUE #( ( `DRS1` ) ( `${$parameters>/valid}` ) ) )
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs1-start ) && `) }`
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs1-end ) && `) }` ).

    " DRS2
    vbox->label( text     = `DateRangeSelection with minDate=2016-01-01 and maxDate=2016-12-31:`
                 labelfor = `DRS2`
       )->date_range_selection(
            id              = `DRS2`
            mindate         = `{= Helper.DateCreateObject($` && client->_bind( mindate ) && `) }`
            maxdate         = `{= Helper.DateCreateObject($` && client->_bind( maxdate ) && `) }`
            valuestate      = client->_bind( drs2-valuestate )
            change          = client->_event( val = `handleChange` t_arg = VALUE #( ( `DRS2` ) ( `${$parameters>/valid}` ) ) )
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs2-start ) && `) }`
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs2-end ) && `) }` ).

    " DRS3
    " showCurrentDateButton of the original sample is omitted here (available only since UI5 1.95)
    vbox->label( text     = `DateRangeSelection with OK button in the footer and with shortcut for today:`
                 labelfor = `DRS3`
       )->date_range_selection(
            id              = `DRS3`
            showfooter      = abap_true
            valuestate      = client->_bind( drs3-valuestate )
            change          = client->_event( val = `handleChange` t_arg = VALUE #( ( `DRS3` ) ( `${$parameters>/valid}` ) ) )
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs3-start ) && `) }`
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs3-end ) && `) }` ).

    " DRS4
    vbox->label( text     = `DateRangeSelection with displayFormat 'MM/yyyy':`
                 labelfor = `DRS4`
       )->date_range_selection(
            id              = `DRS4`
            valuestate      = client->_bind( drs4-valuestate )
            change          = client->_event( val = `handleChange` t_arg = VALUE #( ( `DRS4` ) ( `${$parameters>/valid}` ) ) )
            displayformat   = `MM/yyyy`
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs4-start ) && `) }`
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs4-end ) && `) }` ).

    " DRS5
    vbox->label( text     = `DateRangeSelection with displayFormat 'yyyy':`
                 labelfor = `DRS5`
       )->date_range_selection(
            id              = `DRS5`
            valuestate      = client->_bind( drs5-valuestate )
            change          = client->_event( val = `handleChange` t_arg = VALUE #( ( `DRS5` ) ( `${$parameters>/valid}` ) ) )
            displayformat   = `yyyy`
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs5-start ) && `) }`
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs5-end ) && `) }` ).

    vbox->label( text     = `Change event`
                 labelfor = `TextEvent` ).
    vbox->text( id   = `TextEvent`
                text = client->_bind_edit( text ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD initialize.

    drs1 = VALUE #( start = `20140202` end = `20140217` valuestate = `None` ).
    drs2 = VALUE #( start = `20160216` end = `20160218` valuestate = `None` ).
    drs3 = VALUE #( start = `20140202` end = `20140217` valuestate = `None` ).
    drs4 = VALUE #( start = `20190402` end = `20191017` valuestate = `None` ).
    drs5 = VALUE #( start = `20090202` end = `20250217` valuestate = `None` ).

  ENDMETHOD.


  METHOD on_event.

    FIELD-SYMBOLS <drs> TYPE ty_s_drs.

    IF client->check_on_event( `handleChange` ).

      DATA(args) = client->get( )-t_event_arg.
      DATA(source) = args[ 1 ].

      ASSIGN me->(source) TO <drs>.

      <drs>-valuestate = COND #( WHEN args[ 2 ] = `true` THEN `None` ELSE `Error` ).

      text = |Id: { source }\n|
          && |From: { <drs>-start }\n|
          && |To: { <drs>-end }|.

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      initialize( ).
      view_display( client ).

    ELSE.
      client->view_model_update( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
