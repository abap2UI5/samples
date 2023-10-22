class Z2UI5_CL_DEMO_APP_107 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ty_items,
        filename    TYPE string,
        mediatype   TYPE string,
        uploadstate TYPE string,
        url         TYPE string,
      END OF ty_items .

  data:
    mt_items TYPE TABLE OF ty_items WITH DEFAULT KEY .
  data MV_FILE_RAW type STRING .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_view_display.
    METHODS z2ui5_on_event.


  PRIVATE SECTION.
    DATA mv_page TYPE string.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_107 IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(lv_script) = `` && |\n| &&
                        `sap.z2ui5.fileGet = (oEvent,oController) => {` && |\n| &&
                        ` var oFileUploadComponent = oEvent.getParameters("items").item.getFileObject();` && |\n| &&
                        ` if (oFileUploadComponent) {` && |\n| &&
                        `   _handleRawFile(oFileUploadComponent,oController);` && |\n| &&
                        ` }` && |\n| &&
                        ` console.log(sap.z2ui5.oResponse.OVIEWMODEL.EDIT.MV_FILE_RAW.data);` && |\n| &&
                        `};` && |\n| &&
                        `_handleRawFile = (oFile, oController) => {` && |\n| &&
                        ` var oFileRaw = {` && |\n| &&
                        `   name: oFile.name,mimetype: oFile.type,size: oFile.size,data: []` && |\n| &&
                        ` }` && |\n| &&
                        ` var reader = new FileReader();` && |\n| &&
                        ` reader.onload = function (e) {` && |\n| &&
                        `   oFileRaw.data = e.target.result;` && |\n| &&
                        `   sap.z2ui5.oResponse.OVIEWMODEL.EDIT.MV_FILE_RAW = oFileRaw;` && |\n| &&
                        ` }` && |\n| &&
                        `  reader.readAsDataURL(oFile);` && |\n| &&
                        `};`.

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_cc_plain_xml( `<html:script>` && lv_script && `</html:script>`
        )->stringify( ) ).

      client->timer_set(
        interval_ms    = '0'
        event_finished = client->_event( 'DISPLAY_VIEW' )
      ).


      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_ON_EVENT.

    CASE client->get( )-event.
      WHEN 'DISPLAY_VIEW'.
        z2ui5_view_display( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_VIEW_DISPLAY.

    client->_bind_edit( mv_file_raw ).

    DATA(view) =  z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = view->shell( )->page(
        title          = 'abap2UI5 - P13N Dialog'
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton  = abap_true
        class = 'sapUiContentPadding' ).

    page = page->upload_set( instantupload = abap_true
                             showicons = abap_true
                             uploadenabled = abap_true
                             terminationenabled = abap_true
*                             filetypes = `txt,doc,png`
                             maxfilenamelength = `30`
                             maxfilesize = `200`
*                             mediatypes = 'text/plain,application/msword,image/png'
                             mode = `MultiSelect`
                             items = client->_bind_edit( mt_items )
*                             afteritemadded = client->_event( val = 'AFTER' t_arg = VALUE #( ( `${$parameters>/}` ) ) )
                             afteritemadded = `sap.z2ui5.fileGet($event,$controller)` "sap.z2ui5.updateData(${$parameters>/reason})
                             uploadcompleted = `sap.z2ui5.fileGet($event,$controller)` "sap.z2ui5.updateData(${$parameters>/reason})
                              )->_generic( name = `toolbar` ns = `upload`
                                )->overflow_toolbar(
                                  )->toolbar_spacer(
                                  )->upload_set_toolbar_placeholder(
                              )->get_parent( )->get_parent( )->get_parent(
                              )->items( ns = `upload`
                                )->upload_set_item( filename = `{FILENAME}`
                                                    url = `{URL}`
                                                    mediatype = `{MEDIATYPE}`
*                                                    uploadState = `{UPLOADSTATE}`
                                                    ).
    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
