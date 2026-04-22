CLASS z2ui5_cl_demo_app_096 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA mo_view_parent TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_descr       TYPE string.

    DATA mr_data TYPE REF TO data.

    METHODS on_init.
    METHODS on_event.

    METHODS view_display
      CHANGING xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_096 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    mv_descr = `data sub app`.
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `MESSAGE_SUB` ).
      client->message_box_display( `event sub app` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    IF mo_view_parent IS NOT BOUND.

      DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( `Main View` ).

      mo_view_parent = page->grid( `L6 M12 S12`
          )->content( `layout` ).

      page->footer( )->overflow_toolbar(
                 )->toolbar_spacer(
                 )->button( text  = `event sub app`
                            press = client->_event( `BUTTON_SAVE` )
                            type  = `Success` ).

    ENDIF.

    mo_view_parent->input( client->_bind_edit( mv_descr ) ).
    mo_view_parent->button( text  = `event sub app`
                            press = client->_event( `MESSAGE_SUB` ) ).

  ENDMETHOD.

ENDCLASS.
