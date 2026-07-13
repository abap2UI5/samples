"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CheckBox/sample/sap.m.sample.CheckBoxTriState
"! In this sample, the CheckBox reflects the selection states of its dependent input fields -
"! selected, not selected, and partially selected.
CLASS z2ui5_cl_demo_app_421 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA child1 TYPE abap_bool.
    DATA child2 TYPE abap_bool.
    DATA child3 TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_421 IMPLEMENTATION.

  METHOD view_display.

    child1 = abap_true.
    child2 = abap_false.
    child3 = abap_true.

    DATA(child1_bind) = client->_bind_edit( child1 ).
    DATA(child2_bind) = client->_bind_edit( child2 ).
    DATA(child3_bind) = client->_bind_edit( child3 ).

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Tri-State Check Box`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.CheckBox/sample/sap.m.sample.CheckBoxTriState` ).

    page->vertical_layout(
        )->text( `Which languages(s) do you speak?`
        )->checkbox(
            text              = `select / deselect all`
            selected          = |\{= ${ child1_bind } \|\| ${ child2_bind } \|\| ${ child3_bind } \}|
            partiallyselected = |\{= !(${ child1_bind } && ${ child2_bind } && ${ child3_bind })\}|
            select            = client->_event( val = `PARENT_CLICKED` t_arg = VALUE #( ( `${$parameters>/selected}` ) ) )
        )->html( `<hr>`
        )->get_parent(
        )->checkbox(
            text     = `English`
            selected = child1_bind
        )->checkbox(
            text     = `German`
            selected = child2_bind
        )->checkbox(
            text     = `French`
            selected = child3_bind ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `PARENT_CLICKED` ).

      DATA(selected) = xsdbool( client->get_event_arg( 1 ) = `true` ).
      child1 = selected.
      child2 = selected.
      child3 = selected.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
