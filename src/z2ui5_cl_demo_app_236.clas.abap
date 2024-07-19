class Z2UI5_CL_DEMO_APP_236 definition
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



CLASS Z2UI5_CL_DEMO_APP_236 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: TextArea - Growing'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout(
                          class  = `sapUiContentPadding`
                          width = `100%`
                          )->content( ns = `layout`
                              )->message_strip(
                                  showicon = abap_true
                                  text = `This TextArea shows up to 7 lines, then a scrollbar is presented.`
                                  )->text_area( placeholder = `Enter Text` growing = abap_true growingmaxlines = `7` width = `100%`

                              )->message_strip(
                                  showicon = abap_true
                                  text = `This TextArea shows up to 7 lines, then a scrollbar is presented.`
                                  class = `sapUiMediumMarginTop`
                              )->text_area( value = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy ` &&
                                                    `eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                    `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, ` &&
                                                    `no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, ` &&
                                                    `consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore ` &&
                                                    `magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                    `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. ` &&
                                                    `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor ` &&
                                                    `invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et ` &&
                                                    `accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata ` &&
                                                    `sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                    `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                                    `sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam ` &&
                                                    `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`  growing = abap_true growingmaxlines = `7` width = `100%`

                              )->message_strip(
                                  showicon = abap_true
                                  text = `This TextArea adjusts its height according to its content.`
                                  class = `sapUiMediumMarginTop`
                              )->text_area( value = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy ` &&
                                                    `eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                    `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, ` &&
                                                    `no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, ` &&
                                                    `consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore ` &&
                                                    `magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                    `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. ` &&
                                                    `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor ` &&
                                                    `invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et ` &&
                                                    `accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata ` &&
                                                    `sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                    `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                                    `sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam ` &&
                                                    `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`  growing = abap_true width = `100%`

                              )->message_strip(
                                  showicon = abap_true
                                  text = `Growing TextArea in a SimpleForm`
                                  class = `sapUiMediumMarginTop`
                                  )->simple_form( "ns = `form`
                                      editable = `true`
                                      layout = `ResponsiveGridLayout`
                                      )->label( text = `Comment`
                              )->text_area( value = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy ` &&
                                                    `eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                                    `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, ` &&
                                                    `no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, ` &&
                                                    `consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore ` &&
                                                    `magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                    `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat. ` &&
                                                    `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor ` &&
                                                    `invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et ` &&
                                                    `accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata ` &&
                                                    `sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing ` &&
                                                    `elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                                    `sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam ` &&
                                                    `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`  growing = abap_true width = `100%`
                   ).

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
