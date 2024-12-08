CLASS z2ui5_cl_demo_app_231 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF t_drs,
        start TYPE d,
        end   TYPE d,
      END OF t_drs .

    DATA:
      drs1    TYPE t_drs,
      drs2    TYPE t_drs,
      drs3    TYPE t_drs,
      drs4    TYPE t_drs,
      drs5    TYPE t_drs,
      mindate TYPE d VALUE '20160101',
      maxdate TYPE d VALUE '20161231',
      text    TYPE string.

  PRIVATE SECTION.
    DATA
      check_initialized TYPE abap_bool.

    METHODS:
      display_view
        IMPORTING
          client TYPE REF TO z2ui5_if_client,
      initialize,
      on_event
        IMPORTING
          client TYPE REF TO z2ui5_if_client.

ENDCLASS.



CLASS z2ui5_cl_demo_app_231 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic_property( VALUE #( n = `core:require` v = `{Helper:'z2ui5/Util'}` ) ).

    DATA(page) = view->shell(
                    )->page(
                        title          = 'abap2UI5 - Sample: Date Range Selection'
                        navbuttonpress = client->_event( 'BACK' )
                        shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DateRangeSelection/sample/sap.m.sample.DateRangeSelection' ).

    DATA(vbox) = page->vbox( ).

    " DRS1
    vbox->label( text     = `DateRangeSelection displayFormat 'yyyy/MM/dd', set via binding:`
                 labelfor = `DRS1`
       )->date_range_selection(
            id              = 'DRS1'
            displayformat   = 'yyyy/MM/dd'
            change          = client->_event( val = 'handleChange' t_arg = VALUE #( ( `DRS2` ) ) )
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs1-start ) && ') }'
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs1-end ) && ') }' ).

    " DRS2
    vbox->label( text     = `DateRangeSelection with minDate=2016-01-01 and maxDate=2016-12-31:`
                 labelfor = `DRS2`
       )->date_range_selection(
            id              = 'DRS2'
            mindate         = `{= Helper.DateCreateObject($` && client->_bind( mindate ) && ') }'
            maxdate         = `{= Helper.DateCreateObject($` && client->_bind( maxdate ) && ') }'
            change          = client->_event( val = 'handleChange' t_arg = VALUE #( ( `DRS2` ) ) )
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs2-start ) && ') }'
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs2-end ) && ') }' ).

    " DRS3
    vbox->label( text     = `DateRangeSelection with OK button in the footer and with shortcut for today:"`
                 labelfor = `DRS3`
       )->date_range_selection(
            id                    = 'DRS3'
            showcurrentdatebutton = abap_true
            showfooter            = abap_true
            change                = client->_event( val = 'handleChange' t_arg = VALUE #( ( `DRS3` ) ) )
            datevalue             = `{= Helper.DateCreateObject($` && client->_bind( drs3-start ) && ') }'
            seconddatevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs3-end ) && ') }' ).

    " DRS4
    vbox->label( text     = `DateRangeSelection with displayFormat 'MM/yyyy':`
                 labelfor = `DRS3`
       )->date_range_selection(
            id              = 'DRS4'
            change          = client->_event( val = 'handleChange' t_arg = VALUE #( ( `DRS4` ) ) )
            displayformat   = 'MM/yyyy'
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs4-start ) && ') }'
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs4-end ) && ') }' ).

    " DRS5
    vbox->label( text     = `DateRangeSelection with displayFormat 'MM/yyyy':`
                 labelfor = `DRS3`
       )->date_range_selection(
            id              = 'DRS5'
            change          = client->_event( val = 'handleChange' t_arg = VALUE #( ( `DRS5` ) ) )
            displayformat   = 'yyyy'
            datevalue       = `{= Helper.DateCreateObject($` && client->_bind( drs5-start ) && ') }'
            seconddatevalue = `{= Helper.DateCreateObject($` && client->_bind( drs5-end ) && ') }' ).

    vbox->label( text     = 'Change event'
                 labelfor = 'TextEvent' ).
    vbox->text( id   = 'TextEvent'
                text = client->_bind_edit( text ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD initialize.

    drs1-start = '20140202'.
    drs1-end   = '20140217'.

    drs2-start = '20160216'.
    drs2-end   = '20160218'.

    drs3-start = '20140202'.
    drs3-end   = '20140217'.

    drs4-start = '20190401'.
    drs4-end   = '20191001'.

    drs5-start = '20150101'.
    drs5-end   = '20191001'.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'handleChange'.

        DATA(args) = client->get( )-t_event_arg.
        DATA(source) = args[ 1 ].

        ASSIGN me->(source) TO FIELD-SYMBOL(<drs>).

        DATA(drs) = CORRESPONDING t_drs( <drs> ).

        text = |Id: { source }\n|
            && |From: { drs-start }\n|
            && |To: { drs-end }|.

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      initialize( ).
      display_view( client ).
    ELSE.
      client->view_model_update( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
