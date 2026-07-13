"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ProgressIndicator/sample/sap.m.sample.ProgressIndicator
"! Shows the progress of a process in a graphical way. To indicate the progress, the inside of the
"! ProgressIndicator is filled with a color.
CLASS z2ui5_cl_demo_app_022 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA percent_animation    TYPE string.
    DATA display_animation    TYPE string.
    DATA percent_no_animation TYPE string.
    DATA display_no_animation TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_022 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    percent_animation    = `0`.
    display_animation    = `0%`.
    percent_no_animation = `0`.
    display_no_animation = `0%`.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ANIMATION_0`.

        percent_animation = `0`.
        display_animation = `0%`.

      WHEN `ANIMATION_100`.

        percent_animation = `100`.
        display_animation = `100%`.

      WHEN `NO_ANIMATION_0`.

        percent_no_animation = `0`.
        display_no_animation = `0%`.

      WHEN `NO_ANIMATION_100`.

        percent_no_animation = `100`.
        display_no_animation = `100%`.

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Progress Indicator Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ProgressIndicator/sample/sap.m.sample.ProgressIndicator` ).

    DATA(layout) = page->vertical_layout(
                       class = `sapUiContentPadding`
                       width = `100%` ).

    layout->text(
        text  = `Regular Mode`
        class = `sapUiSmallMarginBottom`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `30`
        displayvalue = `30%`
        showvalue    = abap_true
        state        = `None`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `50`
        showvalue    = abap_false
        state        = `Error`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `99`
        displayvalue = `0.99GB of 1GB`
        showvalue    = abap_true
        state        = `Success`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `25`
        displayvalue = `25%`
        showvalue    = abap_true
        state        = `Warning`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `40`
        displayvalue = `40%`
        showvalue    = abap_true
        state        = `Information`
    )->text(
        text  = `Information Popover Scenario`
        class = `sapUiSmallMarginBottom`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `40`
        displayvalue = `Reduce container width until this text is truncated, then press the ProgressIndicator`
        showvalue    = abap_true
        state        = `Success`
    )->text(
        text  = `Invalid percent values`
        class = `sapUiSmallMarginBottom`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `-20`
        displayvalue = `-20`
        showvalue    = abap_true
        state        = `None`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `120`
        displayvalue = `120`
        showvalue    = abap_true
        state        = `None`
    )->text(
        text  = `Display Only Mode`
        class = `sapUiSmallMarginBottom`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `30`
        displayvalue = `30%`
        showvalue    = abap_true
        state        = `None`
        displayonly  = abap_true
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `50`
        showvalue    = abap_false
        state        = `Error`
        displayonly  = abap_true
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `99`
        displayvalue = `0.99GB of 1GB`
        showvalue    = abap_true
        state        = `Success`
        displayonly  = abap_true
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `25`
        displayvalue = `25%`
        showvalue    = abap_true
        state        = `Warning`
        displayonly  = abap_true
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = `40`
        displayvalue = `40%`
        showvalue    = abap_true
        state        = `Information`
        displayonly  = abap_true
    )->text(
        text  = `Set the ProgressIndicator to 100% with animation`
        class = `sapUiSmallMarginBottom`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = client->_bind( percent_animation )
        displayvalue = client->_bind( display_animation )
        state        = `Success`
        displayonly  = abap_true
    )->flex_box(
        )->button(
            text  = `Set to 0%`
            class = `sapUiSmallMarginEnd`
            press = client->_event( `ANIMATION_0` )
        )->button(
            text  = `Set to 100%`
            press = client->_event( `ANIMATION_100` ) ).

    " displayAnimation of the original sample is omitted here (available only since UI5 1.73)
    layout->text(
        text  = `Set the ProgressIndicator to 100% without animation`
        class = `sapUiSmallMarginBottom`
    )->progress_indicator(
        class        = `sapUiSmallMarginBottom`
        percentvalue = client->_bind( percent_no_animation )
        displayvalue = client->_bind( display_no_animation )
        state        = `Success`
        displayonly  = abap_true
    )->flex_box(
        )->button(
            text  = `Set to 0%`
            class = `sapUiSmallMarginEnd`
            press = client->_event( `NO_ANIMATION_0` )
        )->button(
            text  = `Set to 100%`
            press = client->_event( `NO_ANIMATION_100` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
