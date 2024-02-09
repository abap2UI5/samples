CLASS z2ui5_cl_demo_app_107 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_items,
        filename    TYPE string,
        mediatype   TYPE string,
        uploadstate TYPE string,
        url         TYPE string,
      END OF ty_items .

    DATA:
      mt_items TYPE TABLE OF ty_items WITH DEFAULT KEY .
    DATA mv_file_raw TYPE string .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.
    DATA check_load_cc TYPE abap_bool.

    METHODS z2ui5_view_display.
    METHODS z2ui5_on_event.
    METHODS get_custom_js
      RETURNING
        VALUE(result) TYPE string.


  PRIVATE SECTION.
    DATA mv_page TYPE string.

ENDCLASS.



CLASS z2ui5_cl_demo_app_107 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_load_cc = abap_false.
      check_load_cc = abap_true.
      client->nav_app_call( z2ui5_cl_popup_js_loader=>factory( get_custom_js( ) ) ).
      RETURN.

    ELSEIF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_view_display( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    client->_bind_edit( mv_file_raw ).

    DATA(view) =  z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        title          = 'abap2UI5 - P13N Dialog'
        navbuttonpress = client->_event( 'BACK' )
        shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
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

  METHOD get_custom_js.

    result  = `` && |\n| &&
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

  ENDMETHOD.

ENDCLASS.
