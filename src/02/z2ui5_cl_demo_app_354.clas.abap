CLASS z2ui5_cl_demo_app_354 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_354 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      product  = `products`.
      quantity = `500`.

      DATA(lv_nav)   = client->_event_nav_app_leave( ).
      DATA(lv_shown) = client->check_app_prev_stack( ).
      DATA(lv_qty)   = client->_bind_edit( quantity ).
      DATA(lv_post)  = client->_event( `BUTTON_POST` ).

      client->view_display(
        |<mvc:View displayBlock="true" height="100%" | &&
        |xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc" xmlns:form="sap.ui.layout.form">| &&
        |<Shell>| &&
        |<Page title="abap2UI5 - First Example" | &&
        |navButtonPress="{ lv_nav }" showNavButton="{ lv_shown }">| &&
        |<form:SimpleForm title="Form Title" editable="true">| &&
        |<form:content>| &&
        |<Title text="Input"/>| &&
        |<Label text="quantity"/>| &&
        |<Input value="{ lv_qty }"/>| &&
        |<Label text="product"/>| &&
        |<Input value="{ product }" enabled="false"/>| &&
        |<Button text="post" press="{ lv_post }"/>| &&
        |</form:content>| &&
        |</form:SimpleForm>| &&
        |</Page>| &&
        |</Shell>| &&
        |</mvc:View>| ).

    ELSEIF client->check_on_event( `BUTTON_POST` ).
      client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
