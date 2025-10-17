CLASS z2ui5_cl_demo_app_352_ws DEFINITION PUBLIC
  INHERITING FROM cl_apc_wsp_ext_stateless_base.

  PUBLIC SECTION.

    CLASS-METHODS: get_active_connections
      RETURNING
        VALUE(result) TYPE i.

    METHODS:
      if_apc_wsp_extension~on_message REDEFINITION,
      if_apc_wsp_extension~on_start REDEFINITION,
      if_apc_wsp_extension~on_close REDEFINITION.

    CONSTANTS:
      c_amc_application_id TYPE amc_application_id VALUE 'Z2UI5_SAMPLE' ##NO_TEXT,
      c_channel_id         TYPE amc_channel_id VALUE '/news_feed' ##NO_TEXT,
      BEGIN OF c_msg,
        __new_connection__ TYPE string VALUE `__NEW_CONNECTION__` ##NO_TEXT,
        __closed__         TYPE string VALUE `__CLOSED__` ##NO_TEXT,
      END OF c_msg.

  PRIVATE SECTION.

    CLASS-METHODS:
      get_producer
        RETURNING
          VALUE(producer) TYPE REF TO if_amc_message_producer_text
        RAISING
          cx_amc_error,
      send
        IMPORTING
          i_message TYPE string
        RAISING
          cx_amc_error.

ENDCLASS.


CLASS z2ui5_cl_demo_app_352_ws IMPLEMENTATION.


  METHOD get_producer.

    producer ?= cl_amc_channel_manager=>create_message_producer( i_application_id = c_amc_application_id
                                                                 i_channel_id     = c_channel_id ).

  ENDMETHOD.


  METHOD if_apc_wsp_extension~on_message.

    TRY.
        send( i_message->get_text( ) ).
      CATCH cx_root INTO DATA(error).
        RAISE SHORTDUMP error.
    ENDTRY.

  ENDMETHOD.


  METHOD if_apc_wsp_extension~on_start.

    TRY.

        i_context->get_binding_manager(
                )->bind_amc_message_consumer( i_application_id = c_amc_application_id
                                              i_channel_id     = c_channel_id ).

        get_producer( )->send( c_msg-__new_connection__ ).

      CATCH cx_root INTO DATA(error).
        RAISE SHORTDUMP error.
    ENDTRY.

  ENDMETHOD.


  METHOD if_apc_wsp_extension~on_close.

    TRY.
        get_producer( )->send( c_msg-__closed__ ).

      CATCH cx_root INTO DATA(error).
        RAISE SHORTDUMP error.
    ENDTRY.

  ENDMETHOD.


  METHOD get_active_connections.

    SELECT
      FROM amc_receiver2
      FIELDS COUNT( * )
      WHERE channel_id = @( to_lower( |{ c_amc_application_id }{ c_channel_id }| ) )
      INTO @result.

  ENDMETHOD.


  METHOD send.

    get_producer( )->send( i_message ).

  ENDMETHOD.

ENDCLASS.

