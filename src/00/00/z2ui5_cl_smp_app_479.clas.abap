CLASS z2ui5_cl_smp_app_479 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    " THIS PATH IS A PLACEHOLDER AND MUST BE REPLACED - the app shows an empty
    " chart until it points at a real service.
    " Unlike the other smart control demos, a SmartChart cannot fall back to the
    " Gateway demo service GWSAMPLE_BASIC: it needs an ANALYTICAL OData V2
    " service - properties marked sap:aggregation-role dimension/measure plus the
    " UI.Chart annotation the chart layout comes from. No such service is part of
    " any standard system, so there is no honest default to ship here; enter the
    " analytical service of your system, with an entity set carrying the
    " dimensions and measures the view expects.
    CONSTANTS c_odata_service TYPE string VALUE `/sap/opu/odata/sap/<YOUR_ANALYTICAL_SERVICE>/`.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_479 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Smart Controls - SmartChart`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      " The chart, its dimensions/measures and the personalization dialog are all
      " metadata-driven; the SemanticObjectController turns the annotated Category
      " dimension into a navigation popover and reports its two events back here.
      page->_generic(
          name   = `SmartChart`
          ns     = `smartChart`
          t_prop = VALUE #( ( n = `enableAutoBinding`       v = `true` )
                            ( n = `entitySet`               v = `Products` )
                            ( n = `useVariantManagement`    v = `true` )
                            ( n = `persistencyKey`          v = `SmartChart_Explored` )
                            ( n = `useChartPersonalisation` v = `true` )
                            ( n = `header`                  v = `Products` ) )
          )->_generic( name = `semanticObjectController` ns = `smartChart`
              )->_generic(
                  name   = `SemanticObjectController`
                  ns     = `navpopover`
                  t_prop = VALUE #( ( n = `navigationTargetsObtained` v = client->_event( `NAV_TARGETS_OBTAINED` ) )
                                    ( n = `navigate`                  v = client->_event( val   = `NAVIGATE`
                                                                                          t_arg = VALUE #( ( `${$parameters>/text}` ) ) ) ) ) ).

      client->view_display( val                       = view->stringify( )
                            switch_default_model_path = c_odata_service ).

    ELSEIF client->check_on_event( `NAV_TARGETS_OBTAINED` ).
      " The tutorial answers this event by composing the navigation popover
      " imperatively (oParameters.show( ) with LinkData entries and a SimpleForm of
      " Title/Image/Text). That is frontend construction of controls, which a thin
      " frontend does not express - the wire stays, and the popover keeps the
      " content the SemanticObjectController derives from the annotations itself.
      client->message_toast_display( `Navigation targets obtained` ).

    ELSEIF client->check_on_event( `NAVIGATE` ).

      DATA(text) = client->get_event_arg( ).

      IF text <> `Homepage`.
        client->message_box_display( text  = |{ text } has been pressed|
                                     type  = `information`
                                     title = `SmartChart demo` ).
      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
