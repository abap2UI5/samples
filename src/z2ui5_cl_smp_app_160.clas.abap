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
        pl_total       TYPE i,
        per_cent_total TYPE p LENGTH 2 DECIMALS 1,
      END OF ty_s_output.
    DATA mt_output TYPE STANDARD TABLE OF ty_s_output WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    mt_output = VALUE #( ).

    DO 10 TIMES.
      INSERT VALUE #( index = sy-index
                      set_sk = `Test`
                      matnr  = `1234567`
                      pl_total = sy-index * 10
                      per_cent_total = sy-index ) INTO TABLE mt_output.
    ENDDO.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `PL_TOTAL_CHANGE` ).
      client->message_box_display(
        `Id of Input via source object: ` && client->get_event_arg( ) && |\n| &&
        `Id of Input via event.oSource.sId: ` && client->get_event_arg( 2 ) && |\n| &&
        `Value of same row, index: ` && client->get_event_arg( 3 ) && |\n| &&
        `Id of parent (row) via event.oSource.oParent.sId: ` && client->get_event_arg( 4 ) && |\n| &&
        `Attribute of parameters.value: ` && client->get_event_arg( 5 ) ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Events on Cell Level`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Pressing ENTER in a sap.ui.table cell input fires a backend event that carries the cell id, ` &&
                   `its row index and the parent row id as event arguments, shown here in a message box.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Text`
        )->a( n = `text` v = `Make an input and press ENTER` ).

    DATA(table) = page->ele( `FlexBox`
        )->a( n = `height` v = `85vh`
        )->ele( n = `Table` ns = `table`
            )->a( n = `rows`               v = client->_bind( mt_output )
            )->a( n = `alternateRowColors` v = `true`
            )->a( n = `selectionMode`      v = `None` ).

    DATA(columns) = table->ele( n = `columns` ns = `table` ).

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
                )->a( n = `submit`   v = client->_event( val = `PL_TOTAL_CHANGE`
                                                          t_arg = VALUE #( ( `${$source>/id}` )
                                                                           ( `$event.oSource.sId` )
                                                                           ( `${INDEX}` )
                                                                           ( `$event.oSource.oParent.sId` )
                                                                           ( `${$parameters>/value}` ) ) ) ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `4rem`
        )->a( n = `sortProperty`   v = `per_cent_total`
        )->a( n = `filterProperty` v = `per_cent_total`
        )->tag( `Text`
            )->a( n = `text` v = `Column 6`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{PER_CENT_TOTAL} %` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
