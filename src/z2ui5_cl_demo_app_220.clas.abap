class z2ui5_cl_demo_app_220 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_220 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Rating Indicator'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout( class  = `sapUiContentPadding` ).
    layout->label( text = `Rating Indicator default size` labelfor = `RI_default` ).
    layout->rating_indicator( id = `RI_default` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` tooltip = `Rating Tooltip` ).

    layout->label( text = `Rating Indicator with size L` labelfor = `RI_L` ).
    layout->rating_indicator( id = `RI_L` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` iconSize = `32px` tooltip = `Rating Tooltip` ).

    layout->label( text = `Rating Indicator with size M` labelfor = `RI_M` ).
    layout->rating_indicator( id = `RI_M` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` iconSize = `22px` tooltip = `Rating Tooltip` ).

    layout->label( text = `Rating Indicator with size S` labelfor = `RI_S` ).
    layout->rating_indicator( id = `RI_S` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` iconSize = `16px` tooltip = `Rating Tooltip` ).

    layout->label( text = `Rating Indicator with size XS` labelfor = `RI_XS` ).
    layout->rating_indicator( id = `RI_XS` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` iconSize = `12px` tooltip = `Rating Tooltip` ).

    layout->label( text = `Rating Indicator with non active state` labelfor = `RI_EnabledFalse` ).
    layout->rating_indicator( id = `RI_EnabledFalse` maxValue = `5` enabled = `false` class = `sapUiSmallMarginBottom` value = `4` iconSize = `12px` tooltip = `Rating Tooltip` ).

    layout->label( text = `Rating Indicator display only` labelfor = `RI_display_only` ).
    layout->rating_indicator( id = `RI_display_only` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` tooltip = `Rating Tooltip`  displayonly = abap_true ).

    layout->label( text = `Rating Indicator readonly mode` labelfor = `RI_read_only` ).
    layout->rating_indicator( id = `RI_read_only` maxValue = `5` class = `sapUiSmallMarginBottom` value = `4` tooltip = `Rating Tooltip`  editable = `false` ).

    layout->label( text = `Rating Indicator with different maxValue` labelfor = `RI_maxValue` ).
    layout->rating_indicator( id = `RI_maxValue` maxValue = `8` class = `sapUiSmallMarginBottom` value = `4` tooltip = `Rating Tooltip` ).
    layout->rating_indicator( maxValue = `7` class = `sapUiSmallMarginBottom` value = `4` tooltip = `Rating Tooltip` ).
    layout->rating_indicator( maxValue = `6` class = `sapUiSmallMarginBottom` value = `3` tooltip = `Rating Tooltip` ).
    layout->rating_indicator( maxValue = `5` class = `sapUiSmallMarginBottom` value = `2` ).
    layout->rating_indicator( maxValue = `4` class = `sapUiSmallMarginBottom` value = `2` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
