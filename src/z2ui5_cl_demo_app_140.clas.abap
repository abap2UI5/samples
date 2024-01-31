CLASS z2ui5_cl_demo_app_140 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox .
    TYPES:
      ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY .

    DATA client TYPE REF TO z2ui5_if_client .
    DATA check_initialized TYPE abap_bool .
    DATA: gt_multi TYPE ty_t_combo.
    DATA: gt_sel_multi TYPE ty_t_combo.
    DATA: gt_sel_multi2 TYPE string_table.
    METHODS ui5_on_init .
    METHODS ui5_on_event .
    METHODS ui5_view_main_display .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_140 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEMO_MULTICOMBOBOX_UI5->UI5_ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ui5_on_event.

    TRY.
        DATA(ok_code) = client->get( )-event.
        CASE ok_code.
          WHEN 'FILTERBAR'.
*            gt_sel_multi2[] = gt_sel_multi[].
            client->view_model_update( ).
        ENDCASE.
      CATCH cx_root INTO DATA(x).
        client->message_box_display( text = x->get_text( ) type = `error` ).
    ENDTRY.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEMO_MULTICOMBOBOX_UI5->UI5_ON_INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ui5_on_init.

    gt_multi = VALUE ty_t_combo(
      ( key = 'A01' text = 'T1' )
      ( key = 'A02' text = 'T2' )
      ( key = 'A03' text = 'T3' )
      ( key = 'A04' text = 'T4' )
      ( key = 'A05' text = 'T5' )
      ).

    gt_sel_multi2 = value #( ( `A01` ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEMO_MULTICOMBOBOX_UI5->UI5_VIEW_MAIN_DISPLAY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD ui5_view_main_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell(
            )->page(
                    title          = 'abap2UI5 - Multi Combo Box'
                    navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->header_content(
                    )->link(
                        text = 'Source_Code'
                        href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                        target = '_blank'
                )->get_parent(
               )->simple_form( title = 'Form Title' editable = abap_true
                    )->content( 'form'
                  )->multi_combobox(
*                            name = 'Multi'
                           name = 'MultiComboBox'
                    selectedkeys = client->_bind_edit( gt_sel_multi2 )
*                            selecteditems = client->_bind_edit( gt_sel_multi )
                                   items = client->_bind_edit( val = gt_multi )
                                   )->item(
                                      key = '{KEY}'
                                      text = '{TEXT}'
                                  )->get_parent(
                  )->button(
                            text  = 'post'
                            press = client->_event( val = 'BUTTON_POST' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_DEMO_MULTICOMBOBOX_UI5->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_on_init( ).
    ENDIF.

    ui5_view_main_display( ).
    ui5_on_event( ).
  ENDMETHOD.
ENDCLASS.

