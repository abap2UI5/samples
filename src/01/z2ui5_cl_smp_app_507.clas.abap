" @keywords binding omit initial default property absent omit_initial omit_initial_paths ratingindicator maxvalue enabled boolean
" @summary An ABAP field is never absent, only initial - so a bound 0 overrides the UI5 default. omit_initial leaves initial fields out of the model, omit_initial_paths only the ones you name.
"! Three lists over the same rows, bound three ways. Each RatingIndicator
"! reads maxValue and enabled from its row:
"!
"!  - plain _bind( ): every field reaches the client as a value, so a row
"!    with no maxValue sends 0 and the control shows no stars - the UI5
"!    default of 5 never had a chance
"!  - omit_initial = abap_true: initial fields are left out, the default
"!    applies - but abap_false is initial too, so the archived row loses
"!    its enabled = false and becomes editable
"!  - omit_initial_paths = MAXVALUE: only that column is omitted, the
"!    boolean still travels, and both rows render as intended
CLASS z2ui5_cl_smp_app_507 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        name     TYPE string,
        value    TYPE i,
        maxvalue TYPE i,
        enabled  TYPE abap_bool,
        note     TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA t_plain TYPE ty_t_row.
    DATA t_omit  TYPE ty_t_row.
    DATA t_paths TYPE ty_t_row.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS render_list
      IMPORTING
        parent TYPE REF TO z2ui5_cl_ui5_view_builder
        title  TYPE string
        descr  TYPE string
        items  TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_507 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_smp_app_507=>ty_t_row.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      " the same rows three times - one attribute per binding, because the
      " omission is a property of the bind, not of the data
      
      CLEAR temp1.
      
      temp2-name = `Handling`.
      temp2-value = 4.
      temp2-maxvalue = 5.
      temp2-enabled = abap_true.
      temp2-note = `maxValue 5, enabled`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Price`.
      temp2-value = 7.
      temp2-maxvalue = 10.
      temp2-enabled = abap_true.
      temp2-note = `maxValue 10, enabled`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Design`.
      temp2-value = 3.
      temp2-enabled = abap_true.
      temp2-note = `NO maxValue - the UI5 default 5 is meant`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Archived`.
      temp2-value = 2.
      temp2-maxvalue = 5.
      temp2-enabled = abap_false.
      temp2-note = `maxValue 5, NOT enabled`.
      INSERT temp2 INTO TABLE temp1.
      t_plain = temp1.
      t_omit  = t_plain.
      t_paths = t_plain.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA row TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Omit Initial Values`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The same four rows, bound three ways. Design has no maxValue and Archived is not ` &&
                   `enabled - watch what each binding makes of the two: a plain bind sends 0 for the missing ` &&
                   `maxValue, omit_initial drops it but drops the abap_false as well, omit_initial_paths ` &&
                   `drops only the column you name.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    row = page->ele( `HBox`
        )->a( n = `wrap`  v = `Wrap`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    render_list( parent = row
                 title  = `_bind( t_plain )`
                 descr  = `every field travels: Design gets maxValue 0 and shows no stars`
                 items  = client->_bind( t_plain ) ).

    render_list( parent = row
                 title  = `_bind( t_omit omit_initial = abap_true )`
                 descr  = `initial fields stay out: Design shows 5 stars - but Archived is enabled now, its abap_false was initial too`
                 items  = client->_bind( val          = t_omit
                                         omit_initial = abap_true ) ).

    
    CLEAR temp3.
    INSERT `MAXVALUE` INTO TABLE temp3.
    render_list( parent = row
                 title  = `_bind( t_paths omit_initial_paths = MAXVALUE )`
                 descr  = `only MAXVALUE stays out: Design shows 5 stars and Archived stays disabled`
                 items  = client->_bind( val                = t_paths
                                         omit_initial_paths = temp3 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD render_list.

    DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    box = parent->ele( `VBox`
        )->a( n = `width` v = `22rem`
        )->a( n = `class` v = `sapUiSmallMarginEnd sapUiSmallMarginBottom` ).

    box->tag( `Title`
        )->a( n = `text`  t = title
        )->a( n = `level` v = `H4` ).
    box->tag( `Text`
        )->a( n = `text`  t = descr
        )->a( n = `class` v = `sapUiTinyMarginBottom` ).

    box->ele( `List`
        )->a( n = `items` v = items
        )->ele( `CustomListItem`
            )->ele( `VBox`
                )->a( n = `class` v = `sapUiTinyMargin`
                )->tag( `Label`
                    )->a( n = `text` v = `{NAME} - {NOTE}`
                )->tag( `RatingIndicator`
                    )->a( n = `value`    v = `{VALUE}`
                    )->a( n = `maxValue` v = `{MAXVALUE}`
                    )->a( n = `enabled`  v = `{ENABLED}`
                    )->a( n = `iconSize` v = `1.25rem` ).

  ENDMETHOD.

ENDCLASS.
