CLASS zcl_fixture_patterns DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA amount TYPE i.
    DATA rate   TYPE p LENGTH 10 DECIMALS 2.
    DATA gross  TYPE string.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fixture_patterns IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_navigated( ).

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `xmlns` v = `sap.m` ).

      DATA(page) = view->ele( `Shell`
          )->ele( `Page` ).

      page->tag( `Input`
          )->a( n = `value` v = client->_bind( amount )
          )->tag( `Input`
              )->a( n = `value` v = client->_bind( rate ) ).

      page->ele( `HBox`
          )->tag( `Text`
      )->end(
          )->ele( `VBox` ).

      page->tag( `Title`
      )->end( ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `CALC` ).
      gross = |{ amount + amount * rate / 100 }|.

    ELSEIF client->check_on_event( `BACK` ).
      client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ELSEIF client->check_on_event( `BACK_VIA` ).
      DATA(app_back) = CAST z2ui5_if_app( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      client->nav_app_leave( app_back ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
