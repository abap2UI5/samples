CLASS z2ui5_cl_demo_app_160 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_output,
        index          TYPE i,
        set_sk         TYPE c LENGTH 10,
        matnr          TYPE matnr,
        description    TYPE c LENGTH 50,
        is_total       TYPE i,
        pl_total       TYPE i,
        per_cent_total TYPE p LENGTH 2 DECIMALS 1,
        is_01_prev     TYPE i,
        pl_01          TYPE i,
        per_cent_01    TYPE p LENGTH 2 DECIMALS 1,
        is_02_prev     TYPE i,
        pl_02          TYPE p LENGTH 2 DECIMALS 1,
        per_cent_02    TYPE p LENGTH 2 DECIMALS 1,
        is_03_prev     TYPE i,
        pl_03          TYPE i,
        per_cent_03    TYPE p LENGTH 2 DECIMALS 1,
        is_q01_prev    TYPE i,
        pl_q01         TYPE i,
        per_cent_q01   TYPE p LENGTH 2 DECIMALS 1,
        is_q02_prev    TYPE i,
        pl_q02         TYPE i,
        per_cent_q02   TYPE p LENGTH 2 DECIMALS 1,
        is_q03_prev    TYPE i,
        pl_q03         TYPE i,
        per_cent_q03   TYPE p LENGTH 2 DECIMALS 1,
        is_q04_prev    TYPE i,
        pl_q04         TYPE i,
        per_cent_q04   TYPE p LENGTH 2 DECIMALS 1,
      END OF ty_s_output.
    DATA mt_output TYPE STANDARD TABLE OF ty_s_output.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_160 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD model_init.

    mt_output = VALUE #( ).

    DO 10 TIMES.

      INSERT VALUE #(
        index = sy-index
        set_sk = `Test`
        matnr  = `1234567`
        description = `Test`
        pl_01 = 0
        pl_02 = 0
      ) INTO TABLE mt_output.

    ENDDO.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `PL_TOTAL_CHANGE` ).
      client->message_box_display(
        `Id of Input via source object: ` &&  client->get_event_arg( ) && z2ui5_cl_sample_context=>cv_char_util_newline  &&
        `Id of Input via event.oSource.sId: ` &&  client->get_event_arg( 2 ) && z2ui5_cl_sample_context=>cv_char_util_newline &&
        `Value of same row, index: ` &&  client->get_event_arg( 3 ) && z2ui5_cl_sample_context=>cv_char_util_newline  &&
        `Id of parent (row) via event.oSource.oParent.sId: ` &&  client->get_event_arg( 4 ) && z2ui5_cl_sample_context=>cv_char_util_newline  &&
        `Attribute of parameters.value: ` &&  client->get_event_arg( 5 )
        ).
    ENDIF.


  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
      )->page(
        title          = `abap2UI5 - Event on cell level`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( )
        )->header_content(
            )->link(
      )->get_parent( ).

    page->message_strip(
        text     = `Pressing ENTER in a sap.ui.table cell input fires a backend event that carries the cell id, ` &&
                   `its row index and the parent row id as event arguments, shown here in a message box.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->text( `Make an input and press ENTER` ).

    DATA(table) = page->flex_box( height = `85vh`
        )->ui_table( alternaterowcolors  = `true`
                     selectionmode       = `None`
                     visiblerowcountmode = `Auto`
                     fixedrowcount       = `1`
                     rows                = client->_bind( mt_output )
    ).

    DATA(columns) = table->ui_columns( ).

    columns->ui_column( width          = `5.2rem`
                        sortproperty   = `SET_SK`
                        filterproperty = `SET_SK` )->text( `Column 1` )->ui_template( )->text( `{SET_SK}` ).
    columns->ui_column( width          = `5rem`
                        sortproperty   = `MATNR`
                        filterproperty = `MATNR` )->text( `Column 2` )->ui_template( )->text( `{MATNR}` ).
    columns->ui_column( width          = `5rem`
                        sortproperty   = `PL_TOTAL`
                        filterproperty = `PL_TOTAL` )->text( `Column 5` )->ui_template( )->input(
                        value          = `{PL_TOTAL}`
                        submit         = client->_event( val = `PL_TOTAL_CHANGE` t_arg = VALUE #(
        ( `${$source>/id}` )
        ( `$event.oSource.sId` )
        ( `${INDEX}` )
        ( `$event.oSource.oParent.sId` )
        ( `${$parameters>/value}` )
         ) ) editable = abap_true type = `Number` ).

    columns->ui_column( width          = `4rem`
                        sortproperty   = `per_cent_total`
                        filterproperty = `per_cent_total` )->text( `Column 6` )->ui_template( )->text( `{PL_TOTAL} %` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
