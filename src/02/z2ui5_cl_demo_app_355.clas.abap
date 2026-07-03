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

    DATA(xml) =
      |<mvc:View displayBlock="true" height="100%" xmlns="sap.m" xmlns:core="sap.ui.core" xmlns:mvc="sap.ui.core.mvc">| &&
      |  <Shell>| &&
      |    <Page| &&
      |        title="abap2UI5 - InputListItem"| &&
      |        showNavButton="{ client->check_app_prev_stack( ) }"| &&
      |        navButtonPress="{ client->_event_nav_app_leave( ) }">| &&
      |      <headerContent>| &&
      |        <Link| &&
      |            href="https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.InputListItem/sample/sap.m.sample.InputListItem"| &&
      |            target="_blank"| &&
      |            text="UI5 Demo Kit"/>| &&
      |      </headerContent>| &&
      |      <List headerText="Input">| &&
      |        <InputListItem label="WLAN">| &&
      |          <Switch state="{ client->_bind_edit( wlan ) }"/>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="Flight Mode">| &&
      |          <CheckBox selected="{ client->_bind_edit( flight ) }"/>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="High Performance">| &&
      |          <RadioButton groupName="GroupPerf" selected="{ client->_bind_edit( high_perf ) }"/>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="Battery Saving">| &&
      |          <RadioButton groupName="GroupPerf" selected="{ client->_bind_edit( battery ) }"/>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="Price (EUR)">| &&
      |          <Input placeholder="Price" type="Number" value="{ client->_bind_edit( price ) }"/>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="Address">| &&
      |          <Input placeholder="Address" value="{ client->_bind_edit( address ) }"/>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="Country">| &&
      |          <Select selectedKey="{ client->_bind_edit( country ) }">| &&
      |            <core:Item key="GR" text="Greece"/>| &&
      |            <core:Item key="MX" text="Mexico"/>| &&
      |            <core:Item key="NO" text="Norway"/>| &&
      |            <core:Item key="NZ" text="New Zealand"/>| &&
      |            <core:Item key="NL" text="Netherlands"/>| &&
      |          </Select>| &&
      |        </InputListItem>| &&
      |        <InputListItem label="Volume">| &&
      |          <HBox justifyContent="End">| &&
      |            <Slider max="10" min="0" value="{ client->_bind_edit( volume ) }" width="200px"/>| &&
      |          </HBox>| &&
      |        </InputListItem>| &&
      |      </List>| &&
      |    </Page>| &&
      |  </Shell>| &&
      |</mvc:View>|.

    client->view_display( xml ).

  ENDMETHOD.

ENDCLASS.
