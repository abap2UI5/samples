class Z2UI5_CL_DEMO_APP_173 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types: begin of ty_s_data,
         name type string,
         END OF ty_s_data,
         ty_t_data type STANDARD TABLE OF ty_s_data with EMPTY KEY.

DATA mt_data type ty_t_data.

  data CLIENT type ref to Z2UI5_IF_CLIENT .



  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS render_main.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_173 IMPLEMENTATION.



  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.

      mt_data = VALUE #( ( name = 'Theo')
                         ( name = 'Lore' ) ).

      client->_bind( mt_data  ).

      render_main( ).

    ENDIF.

  ENDMETHOD.

  METHOD render_main.

    DATA(xml) =
    '<mvc:View xmlns="sap.m" xmlns:mvc="sap.ui.core.mvc" xmlns:template="http://schemas.sap.com/sapui5/extension/sap.ui.core.template/1">' &&
    '   <App>                                                                                                                            ' &&
    '     <Page title="XML Templating">                                                                                                  ' &&
    '       <OverflowToolbar>                                                                                                            ' &&
    '         <ToolbarSpacer />                                                                                                          ' &&
    '         <template:repeat list="{meta>/MT_DATA}" var="MT_DATA">                                                                     ' &&
    '           <ToggleButton text="{MT_DATA>NAME}" />                                                                                   ' &&
    '         </template:repeat>                                                                                                         ' &&
    '         <ToolbarSpacer />                                                                                                          ' &&
    '         <OverflowToolbarButton icon="sap-icon://action-settings" />                                                                ' &&
    '      </OverflowToolbar>                                                                                                            ' &&
    '     </Page>                                                                                                                        ' &&
    '   </App>                                                                                                                           ' &&
    '</mvc:View>'.

    client->view_display( xml ).


  ENDMETHOD.

ENDCLASS.
