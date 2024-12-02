CLASS z2ui5_cl_demo_app_313 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        count      TYPE i,
        value      TYPE string,
        descr      TYPE string,
        icon       TYPE string,
        info       TYPE string,
        checkbox   TYPE abap_bool,
        percentage TYPE p LENGTH 5 DECIMALS 2,
        valuecolor TYPE string,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.
    DATA check_ui5 TYPE abap_bool.
    DATA mv_key TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_313 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = view->shell(
          )->page(
              title          = 'abap2UI5 - Smart Controls with Variants'
              navbuttonpress = client->_event( 'BACK' )
              shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).


    page->smart_filter_bar(
        id             = 'smartFilterBar'
        persistencykey = 'SmartFilterPKey'
        entityset      = 'BookingSupplement'
    )->_control_configuration(
        )->control_configuration(
        previnitdatafetchinvalhelpdia = abap_false
        visibleinadvancedarea         = abap_true
        key                           = 'TravelID'
    )->get_parent(
    )->smart_table(
        id                      = 'smartTable_ResponsiveTable'
        smartfilterid           = 'smartFilterBar'
        tabletype               = 'ResponsiveTable'
        editable                = abap_false
        initiallyvisiblefields  = 'TravelID,BookingID'
        entityset               = 'BookingSupplement'
        usevariantmanagement    = abap_true
        useexporttoexcel        = abap_true
        usetablepersonalisation = abap_true
        header                  = 'Test'
        showrowcount            = abap_true
        enableexport            = abap_false
        enableautobinding       = abap_true
    ).

*      page->_cc_plain_xml(   `     <smartFilterBar:SmartFilterBar ` && |\n|  &&
*                             `     id="smartFilterBar"` && |\n|  &&
*                             `     entitySet="BookingSupplement" persistencyKey="SmartFilterPKey" >` && |\n|  &&
*                             `     <smartFilterBar:controlConfiguration>` && |\n|  &&
*                             `         <smartFilterBar:ControlConfiguration` && |\n|  &&
*                             `             key="TravelID" visibleInAdvancedArea="true"` && |\n|  &&
*                             `             preventInitialDataFetchInValueHelpDialog="false">` && |\n|  &&
*                             `         </smartFilterBar:ControlConfiguration>` && |\n|  &&
*                            `     </smartFilterBar:controlConfiguration>` && |\n|  &&
*                             ` </smartFilterBar:SmartFilterBar> <smartTable:SmartTable ` && |\n|  &&
*       `       id="smartTable_ResponsiveTable"` && |\n|  &&
*       `       smartFilterId="smartFilterBar" ` && |\n|  &&
*       `       tableType="ResponsiveTable" ` && |\n|  &&
*       `       editable="false"` && |\n|  &&
*       `       initiallyVisibleFields="TravelID,BookingID"` && |\n|  &&
*       `       entitySet="BookingSupplement" ` && |\n|  &&
*       `       useVariantManagement="true"` && |\n|  &&
*       `       useExportToExcel="true"` && |\n|  &&
*       `       useTablePersonalisation="true" ` && |\n|  &&
*       `       header="Test" ` && |\n|  &&
*       `       showRowCount="true"` && |\n|  &&
*       `       enableExport="false" ` && |\n|  &&
*       `       enableAutoBinding="true">` && |\n|  &&
*       `</smartTable:SmartTable>` ).
**       `   <smartForm:SmartForm editable="true">` && |\n|  &&
*       `       <smartForm:layout>` && |\n|  &&
*       `           <smartForm:ColumnLayout ` && |\n|  &&
*       `               emptyCellsLarge="4"` && |\n|  &&
*       `               labelCellsLarge="4"` && |\n|  &&
*       `               columnsM="1"` && |\n|  &&
*       `               columnsL="1"` && |\n|  &&
*       `               columnsXL="1"/>` && |\n|  &&
*       `       </smartForm:layout>` && |\n|  &&
*       `       <smartForm:Group>` && |\n|  &&
*       `           <smartForm:GroupElement>` && |\n|  &&
*       `               <smartField:SmartField value="{City}" id="idPrice"/>` && |\n|  &&
*       `           </smartForm:GroupElement>` && |\n|  &&
*       `       </smartForm:Group>` && |\n|  &&
*       `   </smartForm:SmartForm>` ).

      client->view_display( val = view->stringify( ) switchdefaultmodel = abap_true ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
