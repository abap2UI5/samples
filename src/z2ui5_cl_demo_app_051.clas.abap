CLASS Z2UI5_CL_DEMO_APP_051 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA:
      BEGIN OF screen,
        input1 TYPE string,
        input2 TYPE string,
        input3 TYPE string,
      END OF screen.

    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

    METHODS Z2UI5_on_rendering
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.
    METHODS Z2UI5_on_event
      IMPORTING
        client TYPE REF TO Z2UI5_if_client.
    METHODS Z2UI5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_051 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_002->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      Z2UI5_on_init( ).
      Z2UI5_on_rendering( client ).
    ENDIF.

    Z2UI5_on_event( client ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_002->Z2UI5_ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_SEND'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->message_toast_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_002->Z2UI5_ON_INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_on_init.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_002->Z2UI5_ON_RENDERING
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_on_rendering.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Label Example'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
         )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    DATA(layout) = page->vertical_layout( class  = `sapUiContentPadding` width = `100%` ).
    layout->label( text = 'Input mandantory' labelfor = `input1` ).
    layout->input(
                id              = `input1`
                required        = abap_true
*                value           = client->_bind_edit( screen-input1 )
                ).


    layout->label( text = 'Input bold' labelfor = `input2` design = `Bold` ).
    layout->input(
                id              = `input2`
                value           = client->_bind_edit( screen-input2 ) ).

    layout->label( text = 'Input normal' labelfor = `input3` ).
    layout->input(
                id              = `input3`
                value           = client->_bind_edit( screen-input2 ) ).


    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
