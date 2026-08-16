CLASS z2ui5_cl_smp_app_118 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_row,
             id    TYPE i,
             descr TYPE string,
             adate TYPE d,
             atime TYPE t,
           END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA problematic_rows TYPE ty_t_row.
    DATA these_are_fine_rows TYPE ty_t_row.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_118 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      problematic_rows = VALUE #(
        ( id = 1 descr = `filled with the actual date and time in correct format` adate = sy-datum atime = sy-uzeit )
        ( id = 2 descr = `correct init values` adate = `00000000` atime = `000000` )
        ( id = 3 descr = `correct init values by ignoring` )
        ( id = 4 descr = `filling with a zero leads to a correct init value` adate = 0 atime = 0 )
        ( id = 5 descr = `this raises an exception now` adate = ``  atime = `` )
        ( id = 6 descr = `Fifth row` adate = sy-datum atime = sy-uzeit ) ).

      these_are_fine_rows = VALUE #(
        ( id = 1 descr = `First row` adate = sy-datum atime = sy-uzeit )
        ( id = 2 descr = `Second row` adate = 0 atime = 0 )
        ( id = 3 descr = `Third row` adate = 0 atime = 0 )
        ( id = 4 descr = `Fourth row` adate = 0 atime = 0 )
        ( id = 5 descr = `Fifth row` adate = sy-datum atime = sy-uzeit ) ).

    ENDIF.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Weird Behavior Showcase`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `showHeader`     b = abap_true ).

    DATA(tab_ko) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( problematic_rows )
        )->a( n = `mode`  v = `MultiSelect` ).

    tab_ko->ele( `headerToolbar`
        )->ele( `Toolbar`
            )->tag( `Title`
                )->a( n = `text` v = |This table has the weird behavior|
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                " abap2ui5lint-disable-next-line event-without-handler -- internal test app
                )->a( n = `press` v = client->_event( `ON_BTN_GO` )
                )->a( n = `text`  v = |Go|
                )->a( n = `icon`  v = `sap-icon://blur` ).

    tab_ko->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `ID`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Description`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Date `
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Time` ).

    tab_ko->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->ele( `ObjectIdentifier`
                    )->a( n = `title` v = `{ID}`
                )->end(
                )->tag( `Text`
                    )->a( n = `text` v = `{DESCR}`
                )->tag( `Text`
                    )->a( n = `text` v = `{ADATE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{ATIME}` ).

    DATA(tab_ok) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( these_are_fine_rows )
        )->a( n = `mode`  v = `MultiSelect` ).

    tab_ok->ele( `headerToolbar`
        )->ele( `Toolbar`
            )->tag( `Title`
                )->a( n = `text` v = |This table is fine| ).

    tab_ok->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `ID`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Description`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Date `
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Time` ).

    tab_ok->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->ele( `ObjectIdentifier`
                    )->a( n = `title` v = `{ID}`
                )->end(
                )->tag( `Text`
                    )->a( n = `text` v = `{DESCR}`
                )->tag( `Text`
                    )->a( n = `text` v = `{ADATE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{ATIME}` ).

    client->view_display( view->stringify( ) ).

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-set_title
        t_arg = VALUE #( ( `abap2UI5 - Weird Behavior Showcase` ) ) ).

  ENDMETHOD.

ENDCLASS.
