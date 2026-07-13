CLASS z2ui5_cl_demo_app_236 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_236 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: TextArea - Growing`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->vertical_layout(
                          class = `sapUiContentPadding`
                          width = `100%`
                          )->content( `layout`
                              )->message_strip(
                                  showicon = abap_true
                                  text     = `This TextArea shows up to 7 lines, then a scrollbar is presented.`
                                  )->text_area( placeholder     = `Enter Text`
                                                growing         = abap_true
                                                growingmaxlines = `7`
                                                width           = `100%`
      )->message_strip(
                                  showicon = abap_true
                                  text     = `This TextArea shows up to 7 lines, then a scrollbar is presented.`
                                  class    = `sapUiMediumMarginTop`
                              )->text_area( value                                                                                     = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy ` &&
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
                                                    `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`  growing = abap_true
                                            growingmaxlines                                                                           = `7`
                                            width                                                                                     = `100%`
      )->message_strip(
                                  showicon = abap_true
                                  text     = `This TextArea adjusts its height according to its content.`
                                  class    = `sapUiMediumMarginTop`
                              )->text_area( value                                                                                     = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy ` &&
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
                                                    `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`  growing = abap_true
                                            width                                                                                     = `100%`
      )->message_strip(
                                  showicon = abap_true
                                  text     = `Growing TextArea in a SimpleForm`
                                  class    = `sapUiMediumMarginTop`
                                  )->simple_form( "ns = `form`
                                      editable = `true`
                                      layout   = `ResponsiveGridLayout`
                                      )->label( `Comment`
                              )->text_area( value                                                                                     = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy ` &&
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
                                                    `nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`  growing = abap_true
                                            width                                                                                     = `100%` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
