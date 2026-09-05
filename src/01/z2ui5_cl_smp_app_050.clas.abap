" @keywords style stylesheet inline html class own design
" @summary Ships a stylesheet with the view, so an app can carry its own design without a change to the UI5 theme.
" @docs https://abap2ui5.github.io/docs/cookbook/view/definition
CLASS z2ui5_cl_smp_app_050 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_050 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.

    IF client->check_on_init( ) IS NOT INITIAL.

      product  = `tomato`.
      quantity = `500`.
    ENDIF.

    IF client->get_event( ) = `BUTTON_POST`.
      client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDIF.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - CSS - Ship Your Own CSS with the View`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `An inline html style element is sent to the frontend with the view, so the sample can restyle ` &&
                   `standard UI5 controls - here the inputs are enlarged and the post button turns red.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " raw markup travels in the content attribute of a core:HTML leaf - the
    " builder re-escapes it on stringify, so the literal markup is written here
    page->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>` && |\n| &&
                         `.sapMInput \{` && |\n| &&
                         `    height: 80px !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         |\n| &&
                         `input \{` && |\n| &&
                         `    height: 80% !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         |\n| &&
                         `input[role="textbox"] \{` && |\n| &&
                         `    height: 80px !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         |\n| &&
                         `input[role="text"] \{` && |\n| &&
                         `    height: 80px !important;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         |\n| &&
                         `.sapUiSearchField \{` && |\n| &&
                         `    height: 35px;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         |\n| &&
                         `.sapUiTfCombo:hover \{` && |\n| &&
                         `    height: 2rem;` && |\n| &&
                         `    font-size: 2.5rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         |\n| &&
                         `.sapMInputBaseInner::placeholder \{` && |\n| &&
                         `    font-size: 1.4rem !important;` && |\n| &&
                         `\}` && |\n| &&
                         `</style>`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `BUTTON_POST` )
            )->a( n = `text`  v = `post`
            )->a( n = `class` v = `mySuperRedButton`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( quantity )
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `title`    v = `Form Title`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form`
                )->tag( `Title`
                    )->a( n = `text` v = `Input`
                )->tag( `Label`
                    )->a( n = `text` v = `quantity`
                )->tag( `Input`
                    )->a( n = `value` v = client->_bind( quantity )
                )->tag( `Label`
                    )->a( n = `text` v = `product`
                )->tag( `Input`
                    )->a( n = `enabled` b = abap_false
                    )->a( n = `value`   v = product
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_POST` )
                    )->a( n = `text`  v = `post` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
