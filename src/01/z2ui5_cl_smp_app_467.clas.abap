" @keywords messagemanager validation target field state central model
" @summary The UI5 message model: validation messages carry the field they belong to, so the control shows the state and one list holds them all.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_467 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        message        TYPE string,
        description    TYPE string,
        type           TYPE string,
        target         TYPE string,
        additionaltext TYPE string,
      END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.
    DATA name       TYPE string.
    DATA amount     TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_467 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_messages.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      amount = 42.

      " app-authored messages - the controller's MessageManager.addMessages
      " equivalent. The z2ui5.cc.MessageManager companion reconciles this
      " table into the central message manager: each row becomes a
      " sap.ui.core.message.Message with the view's model as processor, so a
      " row with a target sets that field's valueState too.
      
      CLEAR temp1.
      
      temp2-message = `Please enter a valid name`.
      temp2-type = `Error`.
      temp2-additionaltext = `Name`.
      temp2-target = `/NAME`.
      INSERT temp2 INTO TABLE temp1.
      temp2-message = `Draft saved automatically`.
      temp2-type = `Information`.
      temp2-additionaltext = `Autosave`.
      INSERT temp2 INTO TABLE temp1.
      t_messages = temp1.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

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
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Message - Message Model and MessageManager`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Both sources of the central message> model in one page: the Name messages ` &&
                   `are AUTHORED BY THE APP (pushed from an ABAP table by the invisible ` &&
                   `z2ui5.cc.MessageManager companion - the Error targets the Name field and ` &&
                   `colours it), while typing letters into the Amount field collects the failed ` &&
                   `Integer validation AUTOMATICALLY - no app code, no roundtrip. Both render ` &&
                   `in the list below.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " invisible companion control: reconciles /T_MESSAGES into the message
    " manager (adds the app's messages, removes its own when they drop out,
    " leaves auto-collected validation untouched)
    page->ele( n = `MessageManager` ns = `z2ui5`
        )->a( n = `items` v = client->_bind( t_messages ) ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Label`
            )->a( n = `text`  v = `Name (message authored by the app)`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( name )
        )->tag( `Label`
            )->a( n = `text`  v = `Amount (integer only - validation collected automatically)`
        )->tag( `Input`
            )->a( n = `value` v = |\{ path: '{ client->_bind( val = amount path = abap_true ) }', | &&
                              |type: 'sap.ui.model.type.Integer' \}|
            )->a( n = `width` v = `12rem` ).

    page->ele( `List`
        )->a( n = `headerText` v = `Collected messages (message> model)`
        )->a( n = `items`      v = `{message>/}`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `noDataText` v = `no messages`
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{message>message}`
            )->a( n = `description` v = `{message>additionalText}`
            )->a( n = `info`        v = `{message>type}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
