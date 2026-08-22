" @keywords cell enter row index event grid alv
" @summary Events on cell level in a grid table: which row and which column the user was in, and what arrives in the backend.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_160 DEFINITION PUBLIC.

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
    DATA mt_output TYPE STANDARD TABLE OF ty_s_output WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_160 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD model_init.

    DATA temp1 LIKE mt_output.
      DATA temp2 TYPE z2ui5_cl_smp_app_160=>ty_s_output.
    CLEAR temp1.
    mt_output = temp1.

    DO 10 TIMES.

      
      CLEAR temp2.
      temp2-index = sy-index.
      temp2-set_sk = `Test`.
      temp2-matnr = `1234567`.
      temp2-description = `Test`.
      temp2-pl_01 = 0.
      temp2-pl_02 = 0.
      INSERT temp2 INTO TABLE mt_output.

    ENDDO.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `PL_TOTAL_CHANGE` ) IS NOT INITIAL.
      client->message_box_display(
        `Id of Input via source object: ` && client->get_event_arg( ) && |\n| &&
        `Id of Input via event.oSource.sId: ` && client->get_event_arg( 2 ) && |\n| &&
        `Value of same row, index: ` && client->get_event_arg( 3 ) && |\n| &&
        `Id of parent (row) via event.oSource.oParent.sId: ` && client->get_event_arg( 4 ) && |\n| &&
        `Attribute of parameters.value: ` && client->get_event_arg( 5 ) ).
    ENDIF.


  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Events on Cell Level`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->ele( `headerContent`
                )->tag( `Link`
            )->end( ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Pressing ENTER in a sap.ui.table cell input fires a backend event that carries the cell id, ` &&
                   `its row index and the parent row id as event arguments, shown here in a message box.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Text`
        )->a( n = `text` v = `Make an input and press ENTER` ).

    
    table = page->ele( `FlexBox`
        )->a( n = `height` v = `85vh`
        )->ele( n = `Table` ns = `table`
            )->a( n = `rows`               v = client->_bind( mt_output )
            )->a( n = `alternateRowColors` v = `true`
            )->a( n = `selectionMode`      v = `None` ).

    
    columns = table->ele( n = `columns` ns = `table` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `5.2rem`
        )->a( n = `sortProperty`   v = `SET_SK`
        )->a( n = `filterProperty` v = `SET_SK`
        )->tag( `Text`
            )->a( n = `text` v = `Column 1`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{SET_SK}` ).
    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `5rem`
        )->a( n = `sortProperty`   v = `MATNR`
        )->a( n = `filterProperty` v = `MATNR`
        )->tag( `Text`
            )->a( n = `text` v = `Column 2`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{MATNR}` ).
    
    CLEAR temp3.
    INSERT `${$source>/id}` INTO TABLE temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    INSERT `${INDEX}` INTO TABLE temp3.
    INSERT `$event.oSource.oParent.sId` INTO TABLE temp3.
    INSERT `${$parameters>/value}` INTO TABLE temp3.
    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `5rem`
        )->a( n = `sortProperty`   v = `PL_TOTAL`
        )->a( n = `filterProperty` v = `PL_TOTAL`
        )->tag( `Text`
            )->a( n = `text` v = `Column 5`
        )->ele( n = `template` ns = `table`
            )->tag( `Input`
                )->a( n = `type`     v = `Number`
                )->a( n = `editable` b = abap_true
                )->a( n = `value`    v = `{PL_TOTAL}`
                )->a( n = `submit`   v = client->_event( val = `PL_TOTAL_CHANGE` t_arg = temp3 ) ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `4rem`
        )->a( n = `sortProperty`   v = `per_cent_total`
        )->a( n = `filterProperty` v = `per_cent_total`
        )->tag( `Text`
            )->a( n = `text` v = `Column 6`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{PL_TOTAL} %` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
