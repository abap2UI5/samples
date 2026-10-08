" mentions in comments are not code: client->nav_app_leave( client->get_app( id_prev_app_stack ) )
CLASS zcl_fixture_patterns_clean DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA amount   TYPE i.
    DATA quantity TYPE i.
    DATA gross    TYPE string.
    METHODS gross_amount
      IMPORTING
        net           TYPE i
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fixture_patterns_clean IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-t_model_skipped IS NOT INITIAL.
      client->message_toast_display( `Not a number - the old value stands.` ).
    ENDIF.

    IF client->check_on_navigated( ).

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `xmlns` v = `sap.m` ).

      DATA(page) = view->ele( `Shell`
          )->ele( `Page` ).

      page->tag( `MessageStrip`
          )->a( n = `text` v = `Text naming client->nav_app_leave( client->get_app( id_prev_app_stack ) ) is not code.` ).

      page->tag( `Input`
          )->a( n = `value` v = client->_bind( amount ) ).

      page->ele( `HBox`
          )->tag( `Text`
              )->a( n = `text` v = |{ quantity }|
          )->ele( `VBox`
              )->tag( `Text`
          )->end(
      )->end( ).

      page->end(
          )->ele( `footer` ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `CALC` ).
      gross = |{ gross_amount( net = amount ) }|.

    ELSEIF client->check_on_event( `BACK` ).
      client->nav_app_leave( event = `RETURNED` ).
    ENDIF.

  ENDMETHOD.


  METHOD gross_amount.

    result = net * 2.

  ENDMETHOD.

ENDCLASS.
