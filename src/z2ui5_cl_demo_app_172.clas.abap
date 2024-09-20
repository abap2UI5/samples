CLASS z2ui5_cl_demo_app_172 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_output,
        index    TYPE i,
        text     TYPE c LENGTH 30,
        link     TYPE c LENGTH 30,
        currency TYPE p LENGTH 13 DECIMALS 2,
        percent1 TYPE p LENGTH 3 DECIMALS 2,
        input1   TYPE i,
        input2   TYPE i,
        input3   TYPE i,
        bool     TYPE abap_bool,
        waers    TYPE waers,
      END OF ty_output .

    DATA check_initialized TYPE abap_bool .
    DATA output TYPE STANDARD TABLE OF ty_output.
    DATA client TYPE REF TO z2ui5_if_client.
  PROTECTED SECTION.

    METHODS load_output_table .
    METHODS on_event .
    METHODS render_main_screen .
    METHODS calculate_sum
      IMPORTING
        !i_column TYPE string .
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_172 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_160->LOAD_OUTPUT_TABLE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD load_output_table.

    DATA ls_output TYPE ty_output.
    CLEAR output.

    DO 11 TIMES.

      ls_output-index = sy-index.
      ls_output-text = 'Text'.
      ls_output-link = 'Link'.
      ls_output-currency = '123.45'.
      ls_output-waers = 'EUR'.

      IF sy-index = 1.
        ls_output-bool = abap_false.
        ls_output-percent1 = '100.00'.
      ELSE.
        ls_output-bool = abap_true.
        ls_output-percent1 = '10.00'.
      ENDIF.

      APPEND ls_output TO output.

    ENDDO.

    "Calculate percentages of the total line from user input

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_160->ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD on_event.

    DATA: lt_event_arguments TYPE string_table,
          lv_tab_index       TYPE string,
          lv_message         TYPE string.

    lt_event_arguments = client->get( )-t_event_arg.

    CASE client->get( )-event.

      WHEN 'LINK_CLICK'.

        lv_tab_index = lt_event_arguments[ 1 ].

        CONCATENATE 'Link in row' lv_tab_index 'clicked' INTO lv_message SEPARATED BY space.
        client->message_toast_display( lv_message ).

*      WHEN 'INPUT_CHANGE'.
*        client->view_model_update( ).
*
*        RETURN.

      WHEN 'INPUT_CHANGE'.


        DATA(lv_id_event) = lt_event_arguments[ 1 ].
        lv_tab_index = lt_event_arguments[ 2 ].
        DATA(ls_row_submit) = output[ lv_tab_index ].
        DATA(lv_id_parent) = lt_event_arguments[ 3 ].
        DATA(lv_column) = lt_event_arguments[ 4 ].

        me->calculate_sum( lv_column ).

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.

    client->follow_up_action( val = `sap.z2ui5.afterBE()` ).
    client->view_model_update( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_160->RENDER_MAIN_SCREEN
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD render_main_screen.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
    )->page(
        id = `page`
        title          = 'abap2UI5 - Demo ui.table'
        navbuttonpress = client->_event( 'BACK' )
          shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        )->header_content(
        )->link(
        )->get_parent( ).

     page->_generic( name = `script` ns = `html` )->_cc_plain_xml( `sap.z2ui5.afterBE = () => {  setTimeout( () => { let input = document.activeElement.childNodes[0].childNodes[0].childNodes[0].childNodes[0]; input.focus( ); input.select(); } , 100 ); }`
).

    DATA(table) = page->ui_table( id = `tab` alternaterowcolors = 'true' visiblerowcountmode = 'Auto'
         fixedrowcount = '1' selectionmode = 'None'  rows = client->_bind_edit( val = output ) ).
    DATA(columns) = table->ui_columns( ).

    columns->ui_column( width = '8rem' sortproperty = 'TEXT' filterproperty = 'TEXT' )->text( text = 'Text Column' )->ui_template( )->text( text = `{TEXT}` ).
    columns->ui_column( width = '8rem' sortproperty = 'LINK' filterproperty = 'LINK' )->text( text = 'Link Column' )->ui_template( )->link( text = `{LINK}`
      press = client->_event( val = 'LINK_CLICK' t_arg = VALUE #( ( `${INDEX}`) ) ) ).
    columns->ui_column( width = '8rem' sortproperty = 'CURRENCY' filterproperty = 'CURRENCY' )->text( text = 'Currency Column' )->ui_template( )->text(
     text = `{ parts: [ 'CURRENCY', 'WAERS'],  type: 'sap.ui.model.type.Currency', formatOptions: { currencyCode: false } }` ).
    "Formatting of currency is language dependant, f.e. add the parameter &sap-language=DE o your URL to move the euro sign behind the number

    columns->ui_column( width = '8rem' sortproperty = 'PERCENT1' filterproperty = 'PERCENT1' )->text( text = 'Percentage' )->ui_template( )->text( text = `{PERCENT1} %` ).

    columns->ui_column( width = '8rem' sortproperty = 'INPUT1' filterproperty = 'INPUT1' )->text( text = 'Input Column' )->ui_template( )->input(
      value = `{INPUT1}` enabled = `{BOOL}` change = client->_event( val = 'INPUT_CHANGE' t_arg = VALUE #(
        ( `${$source>/id}` ) "Access the id of the HTML element
        ( `${INDEX}` ) "Access the value of the index column of the row where the user made a change
        ( `$event.oSource.oParent.sId` ) "Access the id of the parent element
        ( `INPUT1` ) "Pass the column name as simple string to the event
         ) ) editable = abap_true type = 'Number' ).

    columns->ui_column( width = '8rem' sortproperty = 'INPUT2' filterproperty = 'INPUT2' )->text( text = 'Input Column'
     )->ui_template(
      )->input(
      value = `{INPUT2}`
      enabled = `{BOOL}`
      change = client->_event( val = 'INPUT_CHANGE'
        t_arg = VALUE #(
        ( `${$source>/id}` )
        ( `${INDEX}` )
        ( `$event.oSource.oParent.sId` )
        ( `INPUT2` )
         ) )
       submit = client->_event( val = 'INPUT_SUBMIT' )
       editable = abap_true
       type = 'Number' ).

    columns->ui_column( width = '8rem' sortproperty = 'INPUT3' filterproperty = 'INPUT3' )->text( text = 'Input Column' )->ui_template( )->input(
      value = `{INPUT3}` enabled = `{BOOL}` change = client->_event( val = 'INPUT_CHANGE' t_arg = VALUE #(
        ( `${$source>/id}` )
        ( `${INDEX}` )
        ( `$event.oSource.oParent.sId` )
        ( `INPUT3` )
         ) ) editable = abap_true type = 'Number' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_160->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      load_output_table( ).
      render_main_screen(  ).
      RETURN.
    ENDIF.

    on_event(  ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_160->CALCULATE_SUM
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COLUMN                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD calculate_sum.

    DATA: lv_sum TYPE i.

    FIELD-SYMBOLS: <f_output> LIKE LINE OF output,
                   <f_input>  TYPE any.

    LOOP AT output ASSIGNING <f_output> WHERE index > 1.

      ASSIGN COMPONENT i_column OF STRUCTURE <f_output> TO  <f_input>.
      lv_sum = lv_sum + <f_input>.

    ENDLOOP.

    READ TABLE output INDEX 1 ASSIGNING <f_output>.
    ASSIGN COMPONENT i_column OF STRUCTURE <f_output> TO  <f_input>.
    <f_input> = lv_sum.


  ENDMETHOD.
ENDCLASS.
