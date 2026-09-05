" @keywords unit test abapunit testclasses assert testable logic method
" @summary The app logic in a method of its own - no client, no attributes - so the local test class beside the class can assert it with ABAP Unit.
CLASS z2ui5_cl_smp_app_503 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount TYPE i.
    DATA rate   TYPE i.
    DATA gross  TYPE string.

    "! The logic under test: a net amount plus a percentage, rounded to whole
    "! units. It takes what it needs and returns what it computes - it reads
    "! no attribute, touches no client and starts no roundtrip, which is the
    "! whole reason a test can call it.
    "!
    "! @parameter net | the net amount
    "! @parameter percent | the tax rate, in percent
    "! @parameter result | the gross amount, rounded to whole units
    METHODS gross_amount
      IMPORTING
        net           TYPE i
        percent       TYPE i
      RETURNING
        VALUE(result) TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_503 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      amount = 100.
      rate   = 19.

      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `CALC` ) IS NOT INITIAL.
      gross = |{ gross_amount( net = amount percent = rate ) }|.
    ENDIF.

  ENDMETHOD.


  METHOD gross_amount.

    " the rounding is the part worth a test: + 50 before the integer division
    " rounds the half up instead of cutting it off
    result = net + ( net * percent + 50 ) DIV 100.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Basics VI - Unit Tests for the App Logic`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The sum below is computed by gross_amount( ), a method that takes what it needs and ` &&
                   `returns what it computes - it reads no attribute and never sees the client. That is what makes ` &&
                   `it testable: the local test class in z2ui5_cl_smp_app_503.clas.testclasses.abap calls it with ` &&
                   `three inputs and asserts the three answers, without a browser, a view or a roundtrip. abapGit ` &&
                   `keeps that file beside the class, and CLSCCINCL in the .clas.xml is what says the class has one.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Gross from net`
        )->a( n = `editable` b = abap_true
        )->a( n = `layout`   v = `ResponsiveGridLayout`
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `Net amount`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( amount )
            )->tag( `Label`
                )->a( n = `text` v = `Tax rate in percent`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( rate )
            )->tag( `Label`
                )->a( n = `text` v = `Gross amount`
            )->tag( `Text`
                )->a( n = `text` v = client->_bind( gross )
            )->tag( `Label`
                )->a( n = `text` v = `Run the logic`
            )->tag( `Button`
                )->a( n = `text`  v = `gross_amount( )`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `CALC` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
