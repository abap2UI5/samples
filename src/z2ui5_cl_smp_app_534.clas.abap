"! A popup-as-app, called by the page z2ui5_cl_smp_app_532: nav_app_call( )
"! opens an app that shows a dialog and no view of its own, so its caller's
"! page stays on screen. Closing hands back with nav_app_leave( ), the caller
"! re-displays - and the page does NOT move: the display carries the app
"! instance, and the frontend sees that the page on screen belongs to it.
"! This app is a hidden helper (never listed on its own in the overview).
CLASS z2ui5_cl_smp_app_534 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_534 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.

    IF client->check_on_navigated( ) IS NOT INITIAL.

      
      popup = z2ui5_cl_ui5_view_builder=>factory( ).
      
      dialog = popup->ele( n = `FragmentDefinition` ns = `core`
          )->a( n = `xmlns`      v = `sap.m`
          )->a( n = `xmlns:core` v = `sap.ui.core`
          )->ele( `Dialog`
              )->a( n = `title` v = `A popup-as-app` ).
      dialog->tag( `Text`
          )->a( n = `text`  v = `This app shows a dialog and nothing else. Close it: the page behind it comes back ` &&
                              `without a transition - it never left.`
          )->a( n = `class` v = `sapUiSmallMargin` ).
      dialog->ele( `buttons`
          )->tag( `Button`
              )->a( n = `id`    v = `close`
              )->a( n = `text`  v = `Close`
              )->a( n = `press` v = client->_event( `CLOSE` ) ).
      client->popup_display( popup->stringify( ) ).

    ELSEIF client->check_on_event( `CLOSE` ) IS NOT INITIAL.

      client->popup_destroy( ).
      client->nav_app_leave( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
