CLASS z2ui5_cl_demo_app_346 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        index       TYPE i,
        title       TYPE string,
        value       TYPE string,
        description TYPE string,
        icon        TYPE string,
        info        TYPE string,
        checkbox    TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA focuscolumn TYPE string.
    DATA focusrow TYPE string.
    DATA focusid TYPE string READ-ONLY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_view.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF c_id,
        index       TYPE string VALUE 'Index',
        title       TYPE string VALUE 'Title',
        color       TYPE string VALUE 'Color',
        info        TYPE string VALUE 'Info',
        checkbox    TYPE string VALUE 'Checkbox',
        description TYPE string VALUE 'Description',
      END OF c_id.

    METHODS next_focus.
    METHODS focus.
    METHODS default_focus.

ENDCLASS.


CLASS z2ui5_cl_demo_app_346 IMPLEMENTATION.


  METHOD set_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml( `window.addEventListener('focus', function(e) {`
                                                && `  try {`
                                                && `    const focusCtrlId = sap.ui.getCore().getCurrentFocusedControlId(); `
                                                && `    if (!focusCtrlId) {`
                                                && `      return;`
                                                && `    }`
                                                && `    const customData = sap.ui.core.Element.getElementById(focusCtrlId).getCustomData()[0];`
                                                && `    if (!customData) {`
                                                && `      return;`
                                                && `    }`
                                                && `    const column = customData.getProperty("value");`
                                                && `    if (!column) {`
                                                && `      return;`
                                                && `    }`
                                                && `    const m = focusCtrlId.match(/(\d+$)/);`
                                                && `    const model = z2ui5.oView.getModel() ;`
                                                && `    model.setProperty("/FOCUSID",focusCtrlId);`
                                                && `    model.setProperty("/XX/FOCUSCOLUMN",column);`
                                                && `    model.setProperty("/XX/FOCUSROW",m[1]);`
                                                && `  } catch(e){}`
                                                && `}, true);`
                                                && ``
                                                && `z2ui5.determineFocusId = (column, row) => { `
                                                && `  try {`
                                                && `    const selector = "td:has([data-columnid='" + column + "']) > div";`
                                                && `    const id = document.querySelectorAll(selector)[row].id;`
                                                && `    z2ui5.oView.getModel().setProperty("/FOCUSID",id);`
                                                && `    const element = sap.ui.core.Element.getElementById(id);`
                                                && `    if (!element) {`
                                                && `      return;`
                                                && `    }`
                                                && `    const focus = element.getFocusInfo();`
                                                && `    element.applyFocusInfo(focus);`
                                                && `  } catch(e){}`
                                                && `}` ).

    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - Tables and focus'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true ).

    DATA(tab) = page->table(
            items = client->_bind_edit( t_tab )
        )->header_toolbar(
            )->overflow_toolbar(
                )->label( `Column Id` )->input( submit      = client->_event( 'FOCUS' )
                                                value       = client->_bind_edit( focuscolumn )
                                                placeholder = `Focus Column`
                                                width       = `10%`
                )->label( `Row Index` )->input( submit      = client->_event( 'FOCUS' )
                                                value       = client->_bind_edit( focusrow )
                                                placeholder = `Focus Row`
                                                width       = `10%`
                                                type        = 'Number'
                )->button(
                    text  = 'Set Focus'
                    press = client->_event( 'FOCUS' )
                )->button(
                    text  = 'Next Focus'
                    press = client->_event( 'ENTER' )
                )->button(
                    text  = 'Reset Focus'
                    press = client->_event( 'RESET' )
                )->title( text = client->_bind( focusid )
                )->toolbar_spacer(
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Index' )->get_parent(
        )->column(
            )->text( 'Title' )->get_parent(
        )->column(
            )->text( 'Color' )->get_parent(
        )->column(
            )->text( 'Info' )->get_parent(
        )->column(
            )->text( 'Checkbox' )->get_parent(
        )->column(
            )->text( 'Description' ).

    tab->items( )->column_list_item( selected = '{SELKZ}'
      )->cells(
          )->text( text = '{INDEX}'
          )->input( value  = '{TITLE}'
                    submit = client->_event( 'ENTER' )
          )->get( )->custom_data( )->core_custom_data(
                     key        = 'ColumnId'
                     value      = c_id-title
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->input( value  = '{VALUE}'
                    submit = client->_event( 'ENTER' )
          )->get( )->custom_data( )->core_custom_data(
                     key        = 'ColumnId'
                     value      = c_id-color
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->input( value  = '{INFO}'
                    submit = client->_event( 'ENTER' )
          )->get( )->custom_data( )->core_custom_data(
                     key        = 'ColumnId'
                     value      = c_id-info
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->checkbox( selected = '{CHECKBOX}'
          )->get( )->custom_data( )->core_custom_data(
                     key        = 'ColumnId'
                     value      = c_id-checkbox
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->input( value  = '{DESCRIPTION}'
                    submit = client->_event( 'ENTER' )
          )->get( )->custom_data( )->core_custom_data(
                     key        = 'ColumnId'
                     value      = c_id-description
                     writetodom = abap_true ).

    client->view_display( view->stringify( ) ).
    focus( ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_tab = VALUE #(
          ( index = 0 title = 'entry 01'  value = 'red'    info = 'completed'  description = 'this is a description' checkbox = abap_true )
          ( index = 1 title = 'entry 02'  value = 'blue'   info = 'completed'  description = 'this is a description' checkbox = abap_true )
          ( index = 2 title = 'entry 03'  value = 'green'  info = 'completed'  description = 'this is a description' checkbox = abap_true )
          ( index = 3 title = 'entry 04'  value = 'orange' info = 'completed'  description = '' checkbox = abap_true )
          ( index = 4 title = 'entry 05'  value = 'grey'   info = 'completed'  description = 'this is a description' checkbox = abap_true )
          ( index = 5 ) ).

      default_focus( ).
      set_view( ).
      RETURN.

    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->view_destroy( ).
        client->nav_app_leave( ).
      WHEN 'FOCUS'.
        focus( ).
      WHEN 'RESET'.
        default_focus( ).
        focus( ).
      WHEN 'ENTER'.
        next_focus( ).
        focus( ).
    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD next_focus.

    focuscolumn = SWITCH #(
                    focuscolumn
                      WHEN c_id-title THEN c_id-color
                      WHEN c_id-color THEN c_id-info
                      WHEN c_id-info  THEN c_id-checkbox
                      WHEN c_id-checkbox THEN c_id-description
                      ELSE c_id-title ).

    IF focuscolumn = c_id-title.
      IF line_exists( t_tab[ focusrow + 2 ] ).
        focusrow = condense( CONV i( focusrow + 1 ) ).
      ELSE.
        focusrow = '0'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD focus.
    client->follow_up_action( `z2ui5.determineFocusId("` && focuscolumn && `", "` && focusrow && `")` ).
  ENDMETHOD.


  METHOD default_focus.
    focuscolumn = 'Title'.
    focusrow = '0'.
  ENDMETHOD.

ENDCLASS.
