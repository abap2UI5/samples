CLASS z2ui5_cl_smp_app_105 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA view_parent TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA mv_class_1 TYPE string.

    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_105 IMPLEMENTATION.

  METHOD view_display.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.

    " Deliberately styled DIFFERENTLY from sub-app class 2 (a table), so the
    " parent demo 104 shows at a glance WHICH class is embedded right now.
    view_parent->tag( `MessageStrip`
        )->a( n = `text`     v = `SUB-APP CLASS 1 (z2ui5_cl_smp_app_105): a green FORM - it has no page of ` &&
                   `its own, its controls are injected into the detail column of the calling ` &&
                   `parent app through a shared view reference.`
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = view_parent->ele( `Panel`
        )->a( n = `headerText` v = `Class 1 - Form`
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `Embedded class`
        )->ele( `ObjectStatus`
            )->a( n = `state` v = `Success`
            )->a( n = `text`  v = `z2ui5_cl_smp_app_105` ).

    form->tag( `Label`
        )->a( n = `text` v = `Input from class 1`
        )->tag( `Input`
            )->a( n = `placeholder` v = `type here - the value lives in sub-app 1`
            )->a( n = `value`       v = client->_bind( mv_class_1 ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Event`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `MESSAGE_SUB` )
            )->a( n = `text`  v = `raise event in sub-app 1`
            )->a( n = `icon`  v = `sap-icon://form` ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `MESSAGE_SUB` ) IS NOT INITIAL.
      client->message_box_display( `event raised in SUB-APP CLASS 1 (the form)` ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    " No check_on_navigated( ) branch: this is a SUB-APP. It never calls
    " client->view_display( ) - it renders into the parent's view reference
    " (view_parent), and the parent app owns the screen and re-displays it.
    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
