" @keywords color background conditional formatting style data attribute
" @summary Colours single table cells from the backend: the row carries its colour as custom data and a stylesheet turns it into a background.
CLASS z2ui5_cl_smp_app_305 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title TYPE string,
        value TYPE string,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_view.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_305 IMPLEMENTATION.

  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - CSS - Color Table Cells from the Backend`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Table cells are coloured from the backend: each cell carries a data-color attribute bound to the ` &&
                   `row, and an inline html style element maps those values to a background colour.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " raw markup travels in the content attribute of a core:HTML leaf - the
    " builder re-escapes it on stringify, so the literal markup is written here
    page->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>`
&& `td:has([data-color="red"])\{ `
&& `    background-color: red;`
&& `\}`
&& ``
&& `td:has([data-color="green"])\{`
&& `    background-color: green;`
&& `\}`
&& ``
&& `td:has([data-color="blue"])\{`
&& `    background-color: blue;`
&& `\}`
&& ``
&& `td:has([data-color="orange"])\{`
&& `    background-color: orange;`
&& `\}`
&& ``
&& `td:has([data-color="grey"])\{`
&& `    background-color: grey;`
&& `\}`
&& ``
&& `td:has([data-color="yellow"])\{`
&& `    background-color: yellow;`
&& `\}`
&& `</style>` ).

    
    tab = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_tab )
        )->a( n = `mode`  v = `MultiSelect`
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `change cell color`
            )->end(
        )->end( ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Title`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Color`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->ele( `Text`
                    )->a( n = `text` v = `{TITLE}`
                    )->ele( `customData`
                        )->tag( n = `CustomData` ns = `core`
                            )->a( n = `value`      v = `{VALUE}`
                            )->a( n = `key`        v = `color`
                            )->a( n = `writeToDom` b = abap_true
                    )->end(
                )->end(
                )->tag( `Input`
                    )->a( n = `enabled` b = abap_true
                    )->a( n = `value`   v = `{VALUE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_tab.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-title = `entry 01`.
      temp2-value = `red`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 02`.
      temp2-value = `blue`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 03`.
      temp2-value = `green`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 04`.
      temp2-value = `yellow`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 05`.
      temp2-value = `orange`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 06`.
      temp2-value = `grey`.
      INSERT temp2 INTO TABLE temp1.
      t_tab = temp1.

      set_view( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      set_view( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
