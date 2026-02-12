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

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mv_focuscolumn TYPE string.
    DATA mv_focusrow TYPE string.
    DATA mv_focusid TYPE string READ-ONLY.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_view.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF c_id,
        index       TYPE string VALUE `Index`,
        title       TYPE string VALUE `Title`,
        color       TYPE string VALUE `Color`,
        info        TYPE string VALUE `Info`,
        checkbox    TYPE string VALUE `Checkbox`,
        description TYPE string VALUE `Description`,
      END OF c_id.

    METHODS next_focus.
    METHODS focus.
    METHODS default_focus.

ENDCLASS.

CLASS z2ui5_cl_demo_app_346 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view->_generic( name = `script`
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

    DATA(lo_page) = lo_view->shell(
        )->page(
            title          = `abap2UI5 - Tables and focus`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = abap_true ).

    DATA(lo_tab) = lo_page->table(
            items = mo_client->_bind_edit( mt_tab )
        )->header_toolbar(
            )->overflow_toolbar(
                )->label( `Column Id` )->input( submit      = mo_client->_event( `FOCUS` )
                                                value       = mo_client->_bind_edit( mv_focuscolumn )
                                                placeholder = `Focus Column`
                                                width       = `10%`
                )->label( `Row Index` )->input( submit      = mo_client->_event( `FOCUS` )
                                                value       = mo_client->_bind_edit( mv_focusrow )
                                                placeholder = `Focus Row`
                                                width       = `10%`
                                                type        = `Number`
                )->button(
                    text  = `Set Focus`
                    press = mo_client->_event( `FOCUS` )
                )->button(
                    text  = `Next Focus`
                    press = mo_client->_event( `ENTER` )
                )->button(
                    text  = `Reset Focus`
                    press = mo_client->_event( `RESET` )
                )->title( text = mo_client->_bind( mv_focusid )
                )->toolbar_spacer(
        )->get_parent( )->get_parent( ).

    lo_tab->columns(
        )->column(
            )->text( `Index` )->get_parent(
        )->column(
            )->text( `Title` )->get_parent(
        )->column(
            )->text( `Color` )->get_parent(
        )->column(
            )->text( `Info` )->get_parent(
        )->column(
            )->text( `Checkbox` )->get_parent(
        )->column(
            )->text( `Description` ).

    lo_tab->items( )->column_list_item( selected = `{SELKZ}`
      )->cells(
          )->text( text = `{INDEX}`
          )->input( value  = `{TITLE}`
                    submit = mo_client->_event( `ENTER` )
          )->get( )->custom_data( )->core_custom_data(
                     key        = `ColumnId`
                     value      = c_id-title
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->input( value  = `{VALUE}`
                    submit = mo_client->_event( `ENTER` )
          )->get( )->custom_data( )->core_custom_data(
                     key        = `ColumnId`
                     value      = c_id-color
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->input( value  = `{INFO}`
                    submit = mo_client->_event( `ENTER` )
          )->get( )->custom_data( )->core_custom_data(
                     key        = `ColumnId`
                     value      = c_id-info
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->checkbox( selected = `{CHECKBOX}`
          )->get( )->custom_data( )->core_custom_data(
                     key        = `ColumnId`
                     value      = c_id-checkbox
                     writetodom = abap_true
          )->get_parent( )->get_parent(
          )->input( value  = `{DESCRIPTION}`
                    submit = mo_client->_event( `ENTER` )
          )->get( )->custom_data( )->core_custom_data(
                     key        = `ColumnId`
                     value      = c_id-description
                     writetodom = abap_true ).

    mo_client->view_display( lo_view->stringify( ) ).
    focus( ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      mt_tab = VALUE #(
          ( index = 0 title = `entry 01`  value = `red`    info = `completed`  description = `this is a description` checkbox = abap_true )
          ( index = 1 title = `entry 02`  value = `blue`   info = `completed`  description = `this is a description` checkbox = abap_true )
          ( index = 2 title = `entry 03`  value = `green`  info = `completed`  description = `this is a description` checkbox = abap_true )
          ( index = 3 title = `entry 04`  value = `orange` info = `completed`  description = `` checkbox = abap_true )
          ( index = 4 title = `entry 05`  value = `grey`   info = `completed`  description = `this is a description` checkbox = abap_true )
          ( index = 5 ) ).

      default_focus( ).
      set_view( ).
      RETURN.

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `BACK`.
        mo_client->view_destroy( ).
        mo_client->nav_app_leave( ).
      WHEN `FOCUS`.
        focus( ).
      WHEN `RESET`.
        default_focus( ).
        focus( ).
      WHEN `ENTER`.
        next_focus( ).
        focus( ).
    ENDCASE.

    mo_client->view_model_update( ).
  ENDMETHOD.

  METHOD next_focus.

    mv_focuscolumn = SWITCH #(
                    mv_focuscolumn
                      WHEN c_id-title THEN c_id-color
                      WHEN c_id-color THEN c_id-info
                      WHEN c_id-info  THEN c_id-checkbox
                      WHEN c_id-checkbox THEN c_id-description
                      ELSE c_id-title ).

    IF mv_focuscolumn = c_id-title.
      IF line_exists( mt_tab[ mv_focusrow + 2 ] ).
        mv_focusrow = condense( CONV i( mv_focusrow + 1 ) ).
      ELSE.
        mv_focusrow = `0`.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD focus.

    mo_client->follow_up_action( `z2ui5.determineFocusId("` && mv_focuscolumn && `", "` && mv_focusrow && `")` ).
  ENDMETHOD.

  METHOD default_focus.

    mv_focuscolumn = `Title`.
    mv_focusrow = `0`.
  ENDMETHOD.
ENDCLASS.
