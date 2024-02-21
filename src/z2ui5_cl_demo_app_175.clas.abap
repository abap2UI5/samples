class Z2UI5_CL_DEMO_APP_175 definition
  public
  final
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data MV_CHECK_INITIALIZED type ABAP_BOOL .
protected section.

  methods ON_RENDERING
    importing
      !IR_CLIENT type ref to Z2UI5_IF_CLIENT .
  methods ON_INIT
    importing
      !IR_CLIENT type ref to Z2UI5_IF_CLIENT .
private section.

  methods ON_EVENT
    importing
      !IR_CLIENT type ref to Z2UI5_IF_CLIENT .
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_175 IMPLEMENTATION.


  METHOD ON_EVENT.

*    CASE ir_client->get( )-event.
*      WHEN ''.
*
*    ENDCASE.
  ENDMETHOD.


  method ON_INIT.
  endmethod.


  METHOD ON_RENDERING.
* ---------- Set view -----------------------------------------------------------------------------
    DATA(lr_view) = z2ui5_cl_xml_view=>factory( client = ir_client
                                                t_ns = VALUE #( ( n = `xmlns:table` v = `sap.ui.table` ) ) ).

* ---------- Set dynamic page ---------------------------------------------------------------------
    DATA(lr_dyn_page) =  lr_view->dynamic_page(
        showfooter = abap_false
       "  headerExpanded = abap_true
      "   toggleHeaderOnTitleClick = client->_event( 'ON_TITLE' )
     ).

* ---------- Get header title ---------------------------------------------------------------------
    DATA(lr_header_title) = lr_dyn_page->title( ns = 'f' )->get( )->dynamic_page_title( ).

* ---------- Set header title text ----------------------------------------------------------------
    lr_header_title->heading( ns = 'f' )->title( TEXT-t00 ).

* ---------- Get page header area ----------------------------------------------------------------
    DATA(lr_header) = lr_dyn_page->header( ns = 'f' )->dynamic_page_header( pinnable = abap_true )->content( ns = 'f' ).

* ---------- Get page content area ----------------------------------------------------------------
    DATA(lr_content) = lr_dyn_page->content( ns = 'f' ).

* -------------------------------------------------------------------------------------------------
* WIZARD
* -------------------------------------------------------------------------------------------------
data(lr_wizard) = lr_content->wizard( ).

* -------------------------------------------------------------------------------------------------
* WIZARD Step 1
* -------------------------------------------------------------------------------------------------
data(lr_wiz_step1) = lr_wizard->wizard_step( title              = 'Step1'
                                             validated          = abap_true ).

lr_wiz_step1->message_strip( text = 'STEP1' ).

* -------------------------------------------------------------------------------------------------
* WIZARD Step 2
* -------------------------------------------------------------------------------------------------
data(lr_wiz_step2) = lr_wizard->wizard_step( title              = 'Step2'
                                             validated          = abap_true ).

lr_wiz_step2->message_strip( text = 'STEP2' ).

* -------------------------------------------------------------------------------------------------
* WIZARD Step 3
* -------------------------------------------------------------------------------------------------
data(lr_wiz_step3) = lr_wizard->wizard_step( title              = 'Step3'
                                             validated          = abap_true ).

lr_wiz_step3->message_strip( text = 'STEP3' ).

* -------------------------------------------------------------------------------------------------
* WIZARD Step 4
* -------------------------------------------------------------------------------------------------
data(lr_wiz_step4) = lr_wizard->wizard_step( title              = 'Step4'
                                             validated          = abap_true ).

lr_wiz_step4->message_strip( text = 'STEP4' ).


* ---------- Set View -----------------------------------------------------------------------------
    ir_client->view_display( lr_view->stringify( ) ).
  ENDMETHOD.


  method Z2UI5_IF_APP~MAIN.
* -------------------------------------------------------------------------------------------------
* INITIALIZATION
* -------------------------------------------------------------------------------------------------
    IF me->mv_check_initialized = abap_false.
      me->mv_check_initialized = abap_true.
      me->on_init( ir_client = client ).

* -------------------------------------------------------------------------------------------------
* RENDERING
* -------------------------------------------------------------------------------------------------
      me->on_rendering( ir_client = client ).
    ENDIF.

* -------------------------------------------------------------------------------------------------
* EVENTS
* -------------------------------------------------------------------------------------------------
    me->on_event( ir_client = client ).

  endmethod.
ENDCLASS.
