CLASS z2ui5_cl_demo_app_107 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_items,
        filename    TYPE string,
        mediatype   TYPE string,
        uploadstate TYPE string,
        url         TYPE string,
      END OF ty_items .

    DATA
      mt_items TYPE TABLE OF ty_items WITH DEFAULT KEY .
    DATA mv_file_raw TYPE string .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    DATA mv_check_load_cc TYPE abap_bool.

    METHODS view_display.
    METHODS get_custom_js
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_107 IMPLEMENTATION.

  METHOD get_custom_js.

    result  = `` && |\n| &&
                 `z2ui5.fileGet = (oEvent,oController) => {` && |\n| &&
                 ` var oFileUploadComponent = oEvent.getParameters("items").item.getFileObject();` && |\n| &&
                 ` if (oFileUploadComponent) {` && |\n| &&
                 `   _handleRawFile(oFileUploadComponent,oController);` && |\n| &&
                 ` }` && |\n| &&
                 ` console.log(z2ui5.oResponse.OVIEWMODEL.XX.MV_FILE_RAW.data);` && |\n| &&
                 `};` && |\n| &&
                 `_handleRawFile = (oFile, oController) => {` && |\n| &&
                 ` var oFileRaw = {` && |\n| &&
                 `   name: oFile.name,mimetype: oFile.type,size: oFile.size,data: []` && |\n| &&
                 ` }` && |\n| &&
                 ` var reader = new FileReader();` && |\n| &&
                 ` reader.onload = function (e) {` && |\n| &&
                 `   oFileRaw.data = e.target.result;` && |\n| &&
                 `   z2ui5.oResponse.OVIEWMODEL.XX.MV_FILE_RAW = oFileRaw;` && |\n| &&
                 ` }` && |\n| &&
                 `  reader.readAsDataURL(oFile);` && |\n| &&
                 `};`.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_check_load_cc = abap_false.
      mv_check_load_cc = abap_true.
      mo_client->nav_app_call( z2ui5_cl_pop_js_loader=>factory( get_custom_js( ) ) ).
      RETURN.

    ELSEIF mo_client->check_on_init( ).
      view_display( ).
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD view_display.

    mo_client->_bind_edit( mv_file_raw ).

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page(
        title          = `abap2UI5 - UploadSet Dialog`
        navbuttonpress = mo_client->_event_nav_app_leave( )
        shownavbutton  = mo_client->check_app_prev_stack( )
        class          = `sapUiContentPadding` ).

    lo_page = lo_page->upload_set( instantupload      = abap_true
                             showicons          = abap_true
                             uploadenabled      = abap_true
                             terminationenabled = abap_true
*                             filetypes = `txt,doc,png`
                             maxfilenamelength  = `30`
                             maxfilesize        = `200`
*                             mediatypes = 'text/plain,application/msword,image/png'
                             mode               = `MultiSelect`
                             items              = mo_client->_bind_edit( mt_items )
*                             afteritemadded = client->_event( val = 'AFTER' t_arg = VALUE #( ( `${$parameters>/}` ) ) )
                             afteritemadded     = `z2ui5.fileGet($event,$controller)` "sap.z2ui5.updateData(${$parameters>/reason})
                             uploadcompleted    = `z2ui5.fileGet($event,$controller)` "sap.z2ui5.updateData(${$parameters>/reason})
                              )->_generic( name = `toolbar`
                                           ns   = `upload`
                                )->overflow_toolbar(
                                  )->toolbar_spacer(
                                  )->upload_set_toolbar_placeholder(
                              )->get_parent( )->get_parent( )->get_parent(
                              )->items( ns = `upload`
                                )->upload_set_item( filename  = `{FILENAME}`
                                                    url       = `{URL}`
                                                    mediatype = `{MEDIATYPE}`
*                                                    uploadState = `{UPLOADSTATE}`
                                                    ).
    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
