CLASS z2ui5_cl_demo_app_257 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_257 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Generic Tag with Different Configurations`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `hint_icon`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `POPOVER` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTag/sample/sap.m.sample.GenericTag` ).

    DATA(lo_layout) = lo_page->vertical_layout(
                          class = `sapUiContentPadding`
                          width = `100%`
                          )->grid( class        = `sapUiSmallMarginBottom`
                                   hspacing     = `0`
                                   vspacing     = `0`
                                   default_span = `L4 M6 S12`
                                   width        = `100%`
                              )->flex_box( class          = `sapUiTinyMarginBottom`
                                           direction      = `Column`
                                           fitcontainer   = abap_true
                                           alignitems     = `Start`
                                           justifycontent = `Start`
                                  )->text( text  = `Generic Tag - KPI`
                                           class = `sapUiSmallMarginBottom`
                                  )->generic_tag( text   = `Project Cost`
                                                  design = `StatusIconHidden`
                                                  status = `Error`
                                                  class  = `sapUiSmallMarginBottom`
                                      )->object_number( state      = `Error`
                                                        emphasized = abap_false
                                                        number     = `3.5M`
                                                        unit       = `EUR` )->get_parent(
      )->generic_tag( text   = `Project Cost`
                      design = `StatusIconHidden`
                      status = `Warning`
                      class  = `sapUiSmallMarginBottom`
                                      )->object_number( state      = `Warning`
                                                        emphasized = abap_false
                                                        number     = `2.4M`
                                                        unit       = `EUR` )->get_parent(
      )->generic_tag( text   = `Project Cost`
                      design = `StatusIconHidden`
                      status = `Success`
                      class  = `sapUiSmallMarginBottom`
                                      )->object_number( state      = `Success`
                                                        emphasized = abap_false
                                                        number     = `1.6M`
                                                        unit       = `EUR` )->get_parent(
      )->generic_tag( text   = `PC`
                      design = `StatusIconHidden`
                      status = `Error`
                      class  = `sapUiSmallMarginBottom`
                                      )->object_number( state      = `Error`
                                                        emphasized = `false`
                                                        number     = `35`
                                                        unit       = `%` )->get_parent(
      )->generic_tag( text   = `PC`
                      design = `StatusIconHidden`
                      status = `Warning`
                      class  = `sapUiSmallMarginBottom`
                                       )->object_number( state      = `Warning`
                                                         emphasized = abap_false
                                                         number     = `71`
                                                         unit       = `%` )->get_parent(
      )->generic_tag( text   = `PC`
                      design = `StatusIconHidden`
                      status = `Success`
                      class  = `sapUiSmallMarginBottom`
                                      )->object_number( state      = `Success`
                                                        emphasized = abap_false
                                                        number     = `96`
                                                        unit       = `%` )->get_parent( )->get_parent(
                              )->flex_box( direction      = `Column`
                                           fitcontainer   = `true`
                                           alignitems     = `Start`
                                           justifycontent = `Start`
                                  )->text( text  = `Generic Tag - KPI (error handling)`
                                           class = `sapUiSmallMarginBottom`
                                  )->generic_tag( text       = `Project Cost`
                                                  design     = `StatusIconHidden`
                                                  status     = `Error`
                                                  valuestate = `Error`
                                                  class      = `sapUiSmallMarginBottom` )->get_parent( )->get_parent(
                              )->flex_box( direction      = `Column`
                                           fitcontainer   = abap_true
                                           alignitems     = `Start`
                                           justifycontent = `Start`
                                  )->text( text  = `Generic Tag - Situation`
                                           class = `sapUiSmallMarginBottom`
                                  )->generic_tag( text   = `Shortage Expected`
                                                  status = `Warning`
                                                  class  = `sapUiSmallMarginBottom` )->get_parent(
                                  )->generic_tag( text   = `Material Shortage`
                                                  status = `Warning`
                                                  class  = `sapUiSmallMarginBottom` )->get_parent( )->get_parent(
                              )->flex_box( direction      = `Column`
                                           fitcontainer   = abap_true
                                           alignitems     = `Start`
                                           justifycontent = `Start`
                                  )->text( text  = `Generic Tag with label`
                                           id    = `genericTagLabel`
                                           class = `sapUiSmallMarginBottom`
                                  )->generic_tag( arialabelledby = `genericTagLabel`
                                                  text           = `Project Cost`
                                                  design         = `StatusIconHidden`
                                                  status         = `Error`
                                                  class          = `sapUiSmallMarginBottom`
                                  )->object_number( state      = `Error`
                                                    emphasized = `false`
                                                    number     = `3.5M`
                                                    unit       = `EUR` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `POPOVER` ).
      display_popover( `hint_icon` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Previews of the GenericTag control based on combinations of different sets of properties.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
