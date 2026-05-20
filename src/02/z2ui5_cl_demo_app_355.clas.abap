CLASS z2ui5_cl_demo_app_355 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA wlan      TYPE abap_bool.
    DATA flight    TYPE abap_bool.
    DATA high_perf TYPE abap_bool.
    DATA battery   TYPE abap_bool.
    DATA price     TYPE string.
    DATA address   TYPE string.
    DATA country   TYPE string.
    DATA volume    TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_355 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    wlan      = abap_true.
    flight    = abap_true.
    high_perf = abap_true.
    price     = `799`.
    address   = `Main Rd, Manchester`.
    country   = `GR`.
    volume    = `7`.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(nl) = cl_abap_char_utilities=>newline.
    DATA(xml) =
      |<mvc:View displayBlock="true" height="100%"| &&
      | xmlns="sap.m" xmlns:core="sap.ui.core" xmlns:mvc="sap.ui.core.mvc">{ nl }| &&
      |  <Shell>{ nl }| &&
      |    <Page{ nl }| &&
      |        title="abap2UI5 - InputListItem"{ nl }| &&
      |        showNavButton="{ client->check_app_prev_stack( ) }"{ nl }| &&
      |        navButtonPress="{ client->_event_nav_app_leave( ) }">{ nl }| &&
      |      <headerContent>{ nl }| &&
      |        <Link{ nl }| &&
      |            href="https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InputListItem/sample/sap.m.sample.InputListItem"{ nl }| &&
      |            target="_blank"{ nl }| &&
      |            text="UI5 Demo Kit"/>{ nl }| &&
      |      </headerContent>{ nl }| &&
      |      <List headerText="Input">{ nl }| &&
      |        <InputListItem label="WLAN">{ nl }| &&
      |          <Switch state="{ client->_bind_edit( wlan ) }"/>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="Flight Mode">{ nl }| &&
      |          <CheckBox selected="{ client->_bind_edit( flight ) }"/>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="High Performance">{ nl }| &&
      |          <RadioButton groupName="GroupPerf" selected="{ client->_bind_edit( high_perf ) }"/>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="Battery Saving">{ nl }| &&
      |          <RadioButton groupName="GroupPerf" selected="{ client->_bind_edit( battery ) }"/>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="Price (EUR)">{ nl }| &&
      |          <Input placeholder="Price" type="Number" value="{ client->_bind_edit( price ) }"/>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="Address">{ nl }| &&
      |          <Input placeholder="Address" value="{ client->_bind_edit( address ) }"/>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="Country">{ nl }| &&
      |          <Select selectedKey="{ client->_bind_edit( country ) }">{ nl }| &&
      |            <core:Item key="GR" text="Greece"/>{ nl }| &&
      |            <core:Item key="MX" text="Mexico"/>{ nl }| &&
      |            <core:Item key="NO" text="Norway"/>{ nl }| &&
      |            <core:Item key="NZ" text="New Zealand"/>{ nl }| &&
      |            <core:Item key="NL" text="Netherlands"/>{ nl }| &&
      |          </Select>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |        <InputListItem label="Volume">{ nl }| &&
      |          <HBox justifyContent="End">{ nl }| &&
      |            <Slider max="10" min="0" value="{ client->_bind_edit( volume ) }" width="200px"/>{ nl }| &&
      |          </HBox>{ nl }| &&
      |        </InputListItem>{ nl }| &&
      |      </List>{ nl }| &&
      |    </Page>{ nl }| &&
      |  </Shell>{ nl }| &&
      |</mvc:View>|.

    client->view_display( xml ).

  ENDMETHOD.

ENDCLASS.
