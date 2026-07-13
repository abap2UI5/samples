"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageOnJSONWithLazyLoading
"! Object Page with LazyLoading
CLASS z2ui5_cl_demo_app_535 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS render_section
      IMPORTING
        sections TYPE REF TO z2ui5_cl_xml_view
        index    TYPE i.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_535 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Page with LazyLoading`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageOnJSONWithLazyLoading` ).

    " the property headerContentPinned is only available since UI5 1.93 and left out
    DATA(object_page_layout) = page->object_page_layout( enablelazyloading  = abap_true
                                                         uppercaseanchorbar = abap_false ).

    DATA(header_title) = object_page_layout->header_title(
        )->object_page_dyn_header_title( ).

    header_title->heading( `uxap`
        )->title( `ObjectPage with LazyLoading` ).

    header_title->snapped_title_on_mobile(
        )->title( `ObjectPage with LazyLoading` ).

    header_title->actions( `uxap`
        )->button( text = `Edit`
                   type = `Emphasized`
        )->button( type = `Transparent`
                   text = `Delete`
        )->button( type = `Transparent`
                   text = `Copy`
        )->overflow_toolbar_button( icon    = `sap-icon://action`
                                    type    = `Transparent`
                                    text    = `Share`
                                    tooltip = `action` ).

    DATA(sections) = object_page_layout->sections( ).

    DO 11 TIMES.
      render_section( sections = sections
                      index    = sy-index ).
    ENDDO.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD render_section.

    " shared block EmploymentBlockJob rebuilt as static content, the model mapping data is hardcoded
    TYPES:
      BEGIN OF ty_s_employee,
        name TYPE string,
        job  TYPE string,
      END OF ty_s_employee.
    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.
    t_employees = VALUE #( ( name = `Michael Adams`   job = `Scrum Master` )
                           ( name = `John Miller`     job = `Product Owner` )
                           ( name = `Richard Wilson`  job = `Ux Designer` )
                           ( name = `Julie Armstrong` job = `Quality Engineer` )
                           ( name = `Denise Smith`    job = `Team Member` )
                           ( name = `Richard Adams`   job = `Team Member` ) ).

    DATA(job_grid) = sections->object_page_section( titleuppercase = abap_false
                                                    title          = `my section`
        )->sub_sections(
            )->object_page_sub_section( title          = |Section { index }|
                                        mode           = `Expanded`
                                        titleuppercase = abap_false
                )->blocks(
                    )->grid( default_span = `L4 M6 S12`
                             hspacing     = `0`
                             width        = `100%` ).

    LOOP AT t_employees INTO DATA(s_employee).
      job_grid->vertical_layout(
          )->label( s_employee-name
          )->label( s_employee-job ).
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
