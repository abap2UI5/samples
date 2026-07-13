"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutCustomBackground
"! Block Layout in which all cells use the same background color set and different color shade.
CLASS z2ui5_cl_demo_app_511 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA color_set TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_511 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      color_set = `ColorSet5`.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(morbi_text) = `Morbi id ullamcorper lorem, vestibulum facilisis velit. Ut elementum aliquam nisl a pretium. ` &&
      `Donec auctor mattis convallis. Aenean sodales tortor nec facilisis fringilla. Nam feugiat nulla at diam sollicitudin pretium. ` &&
      `Sed at lacus volutpat, finibus arcu ultricies, convallis elit. Aliquam sollicitudin tortor sit amet mi consequat fringilla. ` &&
      `Fusce nisl leo, tempor et nulla id, pellentesque suscipit augue. Morbi cursus molestie tellus. ` &&
      `Ut volutpat orci interdum, condimentum risus sed, iaculis tellus. Proin nisi eros, tristique nec tortor quis, suscipit sodales dui.`.

    DATA(form_text) = `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin, ` &&
      `in gravida lectus aliquam. Vivamus tortor lorem, semper et diam ac, faucibus suscipit metus. ` &&
      `Curabitur eget aliquet purus, id vestibulum sapien. Cras vitae imperdiet felis. ` &&
      `Fusce placerat velit orci, at tempor nisl aliquam laoreet. Aliquam in sapien sit amet tortor laoreet feugiat id in ligula.`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Block Layout with custom background color set for the cells`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutCustomBackground` ).

    DATA(vbox) = page->vbox( ).

    " the showColon property of sap.m.Label was introduced after UI5 1.71 and is omitted
    DATA(select) = vbox->hbox(
        alignitems = `Center`
        class      = `sapUiContentPadding`
        )->label(
            text  = `Color set for all cells`
            class = `sapUiTinyMarginEnd`
        )->select( selectedkey = client->_bind_edit( color_set ) ).

    DO 11 TIMES.

      DATA(color_set_key) = |ColorSet{ sy-index }|.
      select->item(
          key  = color_set_key
          text = COND string( WHEN sy-index = 11
                              THEN |{ color_set_key } (transparent in SAP Horizon theme)|
                              ELSE color_set_key ) ).

    ENDDO.

    DATA(block_layout) = vbox->block_layout( ).

    block_layout->block_layout_row(
        )->block_layout_cell(
            title                = `Cells with Custom Color (Shade A)`
            backgroundcolorset   = client->_bind_edit( color_set )
            backgroundcolorshade = `ShadeA` ).

    " the custom CSS image background of the first cell needs custom CSS and is omitted
    block_layout->block_layout_row(
        )->block_layout_cell(
            title          = `The Title`
            titlealignment = `Center`
            )->text( `Donec bibendum diam nibh, sit amet ornare ante fermentum sed. Ut vulputate justo at orci sollicitudin.` )->get_parent(
        )->block_layout_cell(
            title                = `An Icon (Shade B)`
            backgroundcolorset   = client->_bind_edit( color_set )
            backgroundcolorshade = `ShadeB`
            )->icon( src = `sap-icon://add-activity` ).

    block_layout->block_layout_row(
        )->block_layout_cell(
            title                = `Simple Form (Shade C)`
            backgroundcolorset   = client->_bind_edit( color_set )
            backgroundcolorshade = `ShadeC`
            )->simple_form(
                editable         = abap_true
                backgrounddesign = `Transparent`
                layout           = `ResponsiveGridLayout`
                )->content( `form`
                )->label( `sap.m.Input`
                )->input(
                    type        = `Text`
                    placeholder = `Enter Name ...`
                )->label( `sap.m.TextArea`
                )->text_area(
                    placeholder = `Please add your comment...`
                    rows        = `6`
                    maxlength   = `255`
                    width       = `100%`
                )->label( `sap.m.Text`
                )->text( form_text ).

    block_layout->block_layout_row(
        )->block_layout_cell(
            title                = `Right Aligned Title (Shade D)`
            titlealignment       = `Right`
            backgroundcolorset   = client->_bind_edit( color_set )
            backgroundcolorshade = `ShadeD`
            )->text( morbi_text ).

    block_layout->block_layout_row(
        )->block_layout_cell(
            title                = `Left Aligned Title (Shade E - Only Available for SAP Quartz and Horizon Themes)`
            titlealignment       = `Left`
            backgroundcolorset   = client->_bind_edit( color_set )
            backgroundcolorshade = `ShadeE`
            )->text( morbi_text ).

    block_layout->block_layout_row(
        )->block_layout_cell(
            title                = `Default Aligned Title (Shade F - Only Available for SAP Quartz and Horizon Themes)`
            backgroundcolorset   = client->_bind_edit( color_set )
            backgroundcolorshade = `ShadeF`
            )->text( morbi_text ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
