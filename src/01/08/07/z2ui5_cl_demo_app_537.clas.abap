"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageTabNavigationMode
"! Object Page sample showing a layout where the navigation is Tab based (one Tab per section) rather
"! than having all of the sections visible at the same time.
CLASS z2ui5_cl_demo_app_537 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    TYPES: BEGIN OF ty_s_employee,
             name    TYPE string,
             picture TYPE string,
             job     TYPE string,
           END OF ty_s_employee.
    DATA t_employees TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS employees_display
      IMPORTING
        grid_content TYPE REF TO z2ui5_cl_xml_view
        index_from   TYPE i
        index_to     TYPE i
        linebreak    TYPE abap_bool DEFAULT abap_false.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_537 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      t_employees = VALUE #(
        ( name = `Michael Adams`   picture = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/person.png` job = `Scrum Master` )
        ( name = `John Miller`     picture = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/person.png` job = `Product Owner` )
        ( name = `Richard Wilson`  picture = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/person.png` job = `Ux Designer` )
        ( name = `Julie Armstrong` picture = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/person.png` job = `Quality Engineer` )
        ( name = `Denise Smith`    picture = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/person.png` job = `Team Member` )
        ( name = `Richard Adams`   picture = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/person.png` job = `Team Member` ) ).

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Page using the Tab navigation mode`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.uxap.ObjectPageLayout/sample/sap.uxap.sample.ObjectPageTabNavigationMode` ).

    DATA(objectpage) = page->object_page_layout(
        enablelazyloading        = abap_true
        useicontabbar            = abap_true
        showtitleinheadercontent = abap_true
        uppercaseanchorbar       = abap_false ).

    DATA(header_title) = objectpage->header_title( )->object_page_dyn_header_title( ).

    header_title->expanded_heading(
        )->title(
            text     = `Denise Smith`
            wrapping = abap_true ).

    " sap.m.Avatar in the snapped heading omitted (control introduced after UI5 1.71)
    header_title->snapped_heading(
        )->flex_box(
            fitcontainer = abap_true
            alignitems   = `Center`
            )->title(
                text     = `Denise Smith`
                wrapping = abap_true ).

    header_title->expanded_content( `uxap` )->text( `Senior UI Developer` ).
    header_title->snapped_content( `uxap` )->text( `Senior UI Developer` ).
    header_title->snapped_title_on_mobile( )->title( `Senior UI Developer` ).

    header_title->actions( `uxap`
        )->button(
            text = `Edit`
            type = `Emphasized`
        )->button(
            type = `Transparent`
            text = `Delete`
        )->button(
            type = `Transparent`
            text = `Copy`
        )->overflow_toolbar_button(
            icon    = `sap-icon://action`
            type    = `Transparent`
            text    = `Share`
            tooltip = `action` ).

    " sap.m.Avatar in the header content omitted (control introduced after UI5 1.71)
    objectpage->header_content( `uxap`
        )->flex_box(
            wrap         = `Wrap`
            fitcontainer = abap_true
            )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
                )->link( text = `+33 6 4512 5158`
                )->link( text = `DeniseSmith@sap.com`
            )->get_parent(
            )->horizontal_layout( class = `sapUiSmallMarginBeginEnd`
                )->image( src = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/linkedin.png`
                )->image(
                    src   = `https://sapui5.hana.ondemand.com/test-resources/sap/uxap/images/Twitter.png`
                    class = `sapUiSmallMarginBegin`
            )->get_parent(
            )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
                )->label( `Hello! I am Denise and I use UxAP`
                )->vbox(
                    )->label( `Achieved goals`
                    )->progress_indicator(
                        percentvalue = `30`
                        displayvalue = `30%`
            )->get_parent( )->get_parent(
            )->vertical_layout( class = `sapUiSmallMarginBeginEnd`
                )->label( `San Jose, USA` ).

    DATA(sections) = objectpage->sections( ).

    sections->object_page_section(
        titleuppercase = abap_false
        id             = `goals`
        title          = `2014 Goals Plan`
        )->sub_sections(
            )->object_page_sub_section(
                id             = `goalsSS1`
                titleuppercase = abap_false
                )->blocks(
                    )->simple_form(
                        editable = abap_false
                        layout   = `ColumnLayout`
                        )->content( `form`
                        )->label( `Evangelize the UI framework across the company`
                        )->text( `4 days overdue Cascaded`
                        )->label( `Get trained in development management direction`
                        )->text( `Due Nov 21`
                        )->label( `Mentor junior developers`
                        )->text( `Due Dec 31 Cascaded` ).

    DATA(personal) = sections->object_page_section(
        titleuppercase = abap_false
        id             = `personal`
        title          = `Personal`
        )->sub_sections( ).

    DATA(connect) = personal->object_page_sub_section(
        id             = `personalSS1`
        title          = `Connect`
        titleuppercase = abap_false
        )->blocks( ).

    connect->simple_form(
        layout = `ColumnLayout`
        width  = `100%`
        )->content( `form`
        )->title(
            ns   = `core`
            text = `Phone Numbers`
        )->label( `Home`
        )->text( `+ 1 415-321-1234`
        )->label( `Office phone`
        )->text( `+ 1 415-321-5555` ).

    " maxContainerCols omitted here and below (deprecated SimpleForm property)
    connect->simple_form(
        editable   = abap_false
        labelspanl = `4`
        labelspanm = `4`
        labelspans = `4`
        emptyspanl = `0`
        emptyspanm = `0`
        emptyspans = `0`
        width      = `100%`
        )->content( `form`
        )->title(
            ns   = `core`
            text = `Social Accounts`
        )->label( `LinkedIn`
        )->text( `/DeniseSmith`
        )->label( `Twitter`
        )->text( `@DeniseSmith` ).

    connect->simple_form(
        layout   = `ColumnLayout`
        editable = abap_false
        width    = `100%`
        )->content( `form`
        )->title(
            ns   = `core`
            text = `Addresses`
        )->label( `Home Address`
        )->text( `2096 Mission Street`
        )->label( `Mailing Address`
        )->text( `PO Box 32114` ).

    connect->simple_form(
        layout = `ColumnLayout`
        width  = `100%`
        )->content( `form`
        )->title(
            ns   = `core`
            text = `Mailing Address`
        )->label( `Work`
        )->text( `DeniseSmith@sap.com` ).

    DATA(payment) = personal->object_page_sub_section(
        id             = `personalSS2`
        title          = `Payment information`
        titleuppercase = abap_false ).

    payment->blocks(
        )->simple_form(
            editable = abap_false
            layout   = `ColumnLayout`
            )->content( `form`
            )->title(
                ns   = `core`
                text = `Main Payment Method`
            )->label( `Bank Transfer`
            )->text( `Sparkasse Heimfeld, Germany` ).

    payment->more_blocks(
        )->simple_form(
            editable = abap_false
            layout   = `ColumnLayout`
            )->content( `form`
            )->title(
                ns   = `core`
                text = `Payment method for Expenses`
            )->label( `Extra Travel Expenses`
            )->text( `Cash 100 USD` ).

    DATA(employment) = sections->object_page_section(
        titleuppercase = abap_false
        id             = `employment`
        title          = `Employment`
        )->sub_sections( ).

    DATA(job_info) = employment->object_page_sub_section(
        id             = `employmentSS1`
        title          = `Job information`
        titleuppercase = abap_false
        )->blocks( ).

    job_info->simple_form(
        labelspanl = `4`
        labelspanm = `4`
        editable   = abap_false
        labelspans = `4`
        emptyspanl = `0`
        emptyspanm = `0`
        emptyspans = `0`
        layout     = `ResponsiveGridLayout`
        width      = `100%`
        )->content( `form`
        )->label( `Job classification`
        )->text( `Senior Ui Developer (UIDEV-SR)`
        )->text( ` `
        )->label( `Pay Grade`
        )->text( `Salary Grade 18 (GR-14)`
        )->text( ` `
        )->label( `Job title`
        )->text( `Developer`
        )->text( ` `
        )->label( `Local Job Title`
        )->label( `Ui Developer` ).

    job_info->simple_form(
        labelspanl = `4`
        labelspanm = `4`
        editable   = abap_false
        labelspans = `4`
        emptyspanl = `0`
        emptyspanm = `0`
        emptyspans = `0`
        layout     = `ResponsiveGridLayout`
        width      = `100%`
        )->content( `form`
        )->label( `Employee Class`
        )->text( `Employee`
        )->text( ` `
        )->label( `FTE`
        )->text( `1`
        )->text( ` `
        )->label( `Standard Weekly Hours`
        )->label( `40` ).

    job_info->horizontal_layout( class = `sapUiSmallMarginTop`
        )->vertical_layout(
            )->label( `Manager`
            )->horizontal_layout(
                )->content( `layout`
                    )->vertical_layout(
                        )->text( `James Smith`
                        )->text( `Development Manager` ).

    DATA(emp_detail) = employment->object_page_sub_section(
        id             = `employmentSS2`
        title          = `Employee Details`
        titleuppercase = abap_false ).

    emp_detail->blocks(
        )->simple_form(
            labelspanl = `4`
            labelspanm = `4`
            editable   = abap_false
            labelspans = `4`
            emptyspanl = `0`
            emptyspanm = `0`
            emptyspans = `0`
            layout     = `ResponsiveGridLayout`
            width      = `100%`
            )->content( `form`
            )->title(
                ns   = `core`
                text = `Termination information`
            )->label( `Ok to return`
            )->text( `No`
            )->label( `Regret Termination`
            )->text( `Yes` ).

    DATA(emp_detail_more) = emp_detail->more_blocks( ).

    emp_detail_more->simple_form(
        labelspanl = `4`
        labelspanm = `4`
        labelspans = `4`
        emptyspanl = `0`
        emptyspanm = `0`
        emptyspans = `0`
        editable   = abap_false
        layout     = `ResponsiveGridLayout`
        width      = `100%`
        )->content( `form`
        )->label( `Start Date`
        )->text( `Jan 01, 2001`
        )->label( `End Date`
        )->text( `Jun 30, 2014`
        )->label( `Last Date Worked`
        )->text( `Jun 01, 2014`
        )->label( `Payroll End Date`
        )->text( `Jun 01, 2014` ).

    emp_detail_more->simple_form(
        labelspanl = `4`
        labelspanm = `4`
        editable   = abap_false
        labelspans = `4`
        emptyspanl = `0`
        emptyspanm = `0`
        emptyspans = `0`
        layout     = `ResponsiveGridLayout`
        width      = `100%`
        )->content( `form`
        )->label( `Payroll End Date`
        )->text( `Jan 01, 2014`
        )->label( `Benefits End Date`
        )->text( `Jun 30, 2014`
        )->label( `Stock End Date`
        )->text( `Jun 01, 2014`
        )->label( `Eligible for Salary Contribution`
        )->text( `No` ).

    DATA(job_relationship) = employment->object_page_sub_section(
        id             = `employmentSS3`
        title          = `Job Relationship`
        titleuppercase = abap_false ).

    " BlockBase collapsed/expanded views of EmploymentBlockJob mapped to the blocks/moreBlocks aggregations
    DATA(collapsed_content) = job_relationship->blocks(
        )->grid(
            default_span = `L4 M6 S12`
            hspacing     = `0`
            width        = `100%`
        )->content( `layout` ).

    employees_display(
        grid_content = collapsed_content
        index_from   = 1
        index_to     = 2
        linebreak    = abap_true ).

    DATA(expanded_content) = job_relationship->more_blocks(
        )->grid(
            default_span = `L4 M6 S12`
            hspacing     = `0`
            width        = `100%`
        )->content( `layout` ).

    employees_display(
        grid_content = expanded_content
        index_from   = 3
        index_to     = 4 ).

    employees_display(
        grid_content = expanded_content
        index_from   = 5
        index_to     = 6 ).

    DATA(connections) = sections->object_page_section(
        titleuppercase = abap_false
        id             = `connections`
        title          = `Connections`
        )->sub_sections(
            )->object_page_sub_section(
                id             = `connectionsSS1`
                titleuppercase = abap_false
            )->blocks( ).

    LOOP AT t_employees INTO DATA(s_employee).
      connections->panel(
          )->vbox(
              )->image( src = s_employee-picture
              )->label( s_employee-name
              )->label( s_employee-job ).
    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD employees_display.

    DATA(layout) = grid_content->vertical_layout( ).

    IF linebreak = abap_true.
      layout->layout_data( `layout` )->grid_data( linebreak = abap_true ).
    ENDIF.

    LOOP AT t_employees INTO DATA(s_employee) FROM index_from TO index_to.
      layout->horizontal_layout(
          )->grid(
              default_span = `L4 M4 S4`
              hspacing     = `0`
              width        = `100%`
          )->content( `layout`
              )->vertical_layout(
                  )->label( s_employee-name
                  )->label( s_employee-job
                  )->layout_data( `layout`
                      )->grid_data( `L12 M12 S12` ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
