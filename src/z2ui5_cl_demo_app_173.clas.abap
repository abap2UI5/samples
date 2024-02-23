CLASS z2ui5_cl_demo_app_173 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        name TYPE string,
        DATE type string,
        AGE  type string,
      END OF ty_s_data,
      ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        FNAME      type string,
        merge      TYPE string,
        visible    TYPE string,
      END OF ty_s_layout,
      ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mt_data   TYPE ty_t_data.

PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_173 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    client->_bind( mt_data ).
    client->_bind( mt_layout ).

    mt_data = VALUE #( ( name = 'Theo' date = '01.01.2000' age = '5' )
                       ( name = 'Lore' date = '01.01.2000' age = '1' ) ).

    mt_layout = VALUE #( ( fname = 'NAME' merge = 'false' visible = 'true' )
                         ( fname = 'DATE' merge = 'false' visible = 'true' )
                         ( fname = 'AGE'  merge = 'false' visible = 'false' ) ).

    DATA(xml) =
`<mvc:View xmlns="sap.m " xmlns:core="sap.ui.core " xmlns:mvc="sap.ui.core.mvc " displayBlock="true " height="100% ">` &&
`  <Shell>` &&
`    <Page>` &&
`      <Table items="{/MT_DATA}">` &&
`        <columns>` &&
`          <template:repeat list="{meta>/MT_LAYOUT} " var="MT_LAYOUT">` &&
`            <Column` &&
`           mergeDuplicates="{MT_LAYOUT>MERGE}"` &&
`           visible="{MT_LAYOUT>VISIBLE}"/>` &&
`          </template:repeat>` &&
`        </columns>` &&
`        <items>` &&
`          <ColumnListItem>` &&
`            <cells>` &&
`              <template:repeat list="{meta>/MT_LAYOUT}" var="MT_LAYOUT">` &&
`                <ObjectIdentifier text="{MT_LAYOUT>FNAME}"/>` &&
`              </template:repeat>` &&
`            </cells>` &&
`          </ColumnListItem>` &&
`        </items>` &&
`      </Table>` &&
`    </Page>` &&
`  </Shell>` &&
`</mvc:View> `.

    client->view_display( xml ).

  ENDMETHOD.

ENDCLASS.
