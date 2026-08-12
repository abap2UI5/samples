CLASS z2ui5_cl_smp_app_105 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA view_parent TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_class_1 TYPE string.
    DATA mr_data TYPE REF TO data.

    METHODS on_event.
    METHODS view_display
      CHANGING
        xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_105 IMPLEMENTATION.

  METHOD view_display.

    " Deliberately styled DIFFERENTLY from sub-app class 2 (a table), so the
    " parent demo 104 shows at a glance WHICH class is embedded right now.
    view_parent->message_strip(
        text     = `SUB-APP CLASS 1 (z2ui5_cl_smp_app_105): a green FORM - it has no page of ` &&
                   `its own, its controls are injected into the detail column of the calling ` &&
                   `parent app through a shared view reference.`
        type     = `Success`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(form) = view_parent->panel( headertext = `Class 1 - Form`
        )->simple_form( editable = abap_true
        )->content( `form` ).

    form->label( `Embedded class`
        )->object_status( text  = `z2ui5_cl_smp_app_105`
                          state = `Success` ).

    form->label( `Input from class 1`
        )->input( value       = client->_bind( mv_class_1 )
                  placeholder = `type here - the value lives in sub-app 1` ).

    form->label( `Event`
        )->button( text  = `raise event in sub-app 1`
                   press = client->_event( `MESSAGE_SUB` )
                   icon  = `sap-icon://form` ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `MESSAGE_SUB` ).
      client->message_box_display( `event raised in SUB-APP CLASS 1 (the form)` ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
