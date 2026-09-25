" @keywords live search table filter keystroke roundtrip busy indicator overlay check_queue_last check_no_busy typing
" @summary A SearchField that filters a 6000-row table on every keystroke, wired with check_queue_last and check_no_busy so no keystroke is lost and the busy overlay never flashes over the field.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
"! Needs abap2UI5 newer than 1.144.0 - check_queue_last and check_no_busy are
"! appended to ty_s_event_control after that release; on an older framework
"! the class does not activate (unknown component of s_ctrl).
CLASS z2ui5_cl_smp_app_059 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA t_table TYPE ty_t_table.
    DATA field   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS set_search.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_059 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      set_data( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `BUTTON_SEARCH` ).

      set_data( ).
      set_search( ).

    ENDIF.

  ENDMETHOD.


  METHOD set_search.

    " a typed contains-search over the columns the table shows - the search
    " string is compared uppercase against uppercase, so it matches whatever
    " the user typed
    DATA(search) = to_upper( field ).
    IF search IS INITIAL.
      RETURN.
    ENDIF.

    DATA(t_all) = t_table.
    t_table = VALUE #( ).

    LOOP AT t_all INTO DATA(s_row).
      IF to_upper( s_row-product )          CS search
      OR to_upper( s_row-create_date )      CS search
      OR to_upper( s_row-create_by )        CS search
      OR to_upper( s_row-storage_location ) CS search OR |{ s_row-quantity }| CS search.
        INSERT s_row INTO TABLE t_table.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_data.

    t_table = VALUE #( ).
    DO 1000 TIMES.
      INSERT LINES OF VALUE ty_t_table(
          ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
          ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
          ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
          ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
          ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
          ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
          ) INTO TABLE t_table.

    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    " The SearchField below round-trips on every keystroke on purpose: the
    " filter runs in ABAP over the full table, which is the point of the
    " sample. check_queue_last and check_no_busy are what make that wire
    " behave - the first so no keystroke is lost, the second so the overlay
    " stays out of the way while they are typed.
    " abap2ui5lint-disable live-event-roundtrip

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page1) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Live Search over a Large Table`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    page1->tag( `MessageStrip`
        )->a( n = `text`     v = `abap2UI5 runs one backend request at a time: while one is in flight the app is busy and a ` &&
                   `further event is dropped. A live search fires per keystroke and would lose every one typed during ` &&
                   `the flight, the last one included - the table would keep filtering on an earlier prefix until you ` &&
                   `paused. The wire below is registered with s_ctrl-check_queue_last, which keeps the last keystroke ` &&
                   `of the flight and sends it once the response has landed. It also carries s_ctrl-check_no_busy: a ` &&
                   `keystroke that meets a round-trip in flight raises the global busy overlay with no delay at all - ` &&
                   `right for a dropped click, wrong over the field you are typing into - and that flag keeps it down. ` &&
                   `The round-trip is unchanged, only the overlay is. Type quickly: the filter lands on what you typed ` &&
                   `and nothing blinks. Z2UI5_CL_SMP_APP_511 shows the same wire with and without the flags side by side.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page1->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMarginBegin`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `value`       v = client->_bind( field )
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->_event(
                val    = `BUTTON_SEARCH`
                s_ctrl = VALUE #( check_queue_last = abap_true
                                  check_no_busy    = abap_true ) ) ).

    DATA(tab) = page1->ele( `Table`
        )->a( n = `items` v = client->_bind( t_table ) ).
    DATA(columns) = tab->ele( `columns` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Product` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Date` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Name` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Location` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Quantity` ).

    DATA(cells) = tab->ele( `items`
        )->ele( `ColumnListItem` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{PRODUCT}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CREATE_DATE}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CREATE_BY}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{STORAGE_LOCATION}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

    " abap2ui5lint-enable live-event-roundtrip

  ENDMETHOD.
ENDCLASS.
