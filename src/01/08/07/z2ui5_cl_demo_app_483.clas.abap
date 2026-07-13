"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableContextualWidthStatic
"! This example shows the container-based pop-in behavior. The container has static width.
CLASS z2ui5_cl_demo_app_483 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_person,
        first_name TYPE string,
        last_name  TYPE string,
        birth_date TYPE string,
        gender     TYPE string,
      END OF ty_s_person.
    DATA t_persons TYPE STANDARD TABLE OF ty_s_person WITH EMPTY KEY.
    DATA contextual_width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_483 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( `CHANGE_WIDTH` ).

      contextual_width = `100px`.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    contextual_width = `500px`.
    t_persons = VALUE #(
        ( first_name = `John`     last_name = `Doe`        birth_date = `1986-05-11` gender = `Male` )
        ( first_name = `Harry`    last_name = `Potter`     birth_date = `1976-05-19` gender = `Male` )
        ( first_name = `Heinz`    last_name = `Piper`      birth_date = `1989-08-08` gender = `Male` )
        ( first_name = `Indiana`  last_name = `Jones`      birth_date = `1991-12-03` gender = `Male` )
        ( first_name = `Darth`    last_name = `Vader`      birth_date = `1977-02-24` gender = `Male` )
        ( first_name = `Barbara`  last_name = `Dreher`     birth_date = `1999-08-31` gender = `Female` )
        ( first_name = `Dante`    last_name = `Alighieri`  birth_date = `1982-04-22` gender = `Male` )
        ( first_name = `Mark`     last_name = `Anson`      birth_date = `1984-05-24` gender = `Male` )
        ( first_name = `Jane`     last_name = `Doe`        birth_date = `1976-07-17` gender = `Female` )
        ( first_name = `Sean`     last_name = `Penn`       birth_date = `1977-09-15` gender = `Male` )
        ( first_name = `Terry`    last_name = `Jones`      birth_date = `1988-06-07` gender = `Male` )
        ( first_name = `Leia`     last_name = `Vader`      birth_date = `1991-11-09` gender = `Female` )
        ( first_name = `Karla`    last_name = `Damon`      birth_date = `1981-12-08` gender = `Female` )
        ( first_name = `Andante`  last_name = `Allegro`    birth_date = `1985-07-02` gender = `Male` )
        ( first_name = `John`     last_name = `Dufke`      birth_date = `1979-08-17` gender = `Male` )
        ( first_name = `Hermione` last_name = `Potter`     birth_date = `1971-06-15` gender = `Female` )
        ( first_name = `Dante`    last_name = `Alioli`     birth_date = `1987-05-11` gender = `Male` )
        ( first_name = `Heinz`    last_name = `Pepper`     birth_date = `1995-10-21` gender = `Male` )
        ( first_name = `John`     last_name = `Johnson`    birth_date = `1981-10-26` gender = `Male` )
        ( first_name = `Luke`     last_name = `Vader`      birth_date = `1972-06-06` gender = `Male` )
        ( first_name = `Petra`    last_name = `Delorean`   birth_date = `1988-04-24` gender = `Female` )
        ( first_name = `Venus`    last_name = `Botticelli` birth_date = `1976-09-08` gender = `Female` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Table - ContextualWidth (Static)`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.TableContextualWidthStatic` ).

    page->message_strip(
        text     = `Table is initially setting contextualWidth to 500px. Press button to change the contextualWidth.`
        type     = `Success`
        class    = `sapUiSmallMargin`
        showicon = abap_true ).

    page->overflow_toolbar(
        )->button(
            text  = `change contextualWidth to 100px`
            press = client->_event( `CHANGE_WIDTH` ) ).

    page->table(
           id              = `table`
           contextualwidth = client->_bind( contextual_width )
           popinlayout     = `GridSmall`
           headertext      = `Products`
           items           = client->_bind( t_persons )
           )->columns(
               )->column(
                   )->header( ``
                       )->label( `First Name`
                   )->get_parent(
               )->get_parent(
               )->column(
                   demandpopin    = abap_true
                   minscreenwidth = `Phone`
                   )->header( ``
                       )->label( `Last Name`
                   )->get_parent(
               )->get_parent(
               )->column(
                   minscreenwidth = `Phone`
                   demandpopin    = abap_true
                   popindisplay   = `Inline`
                   halign         = `Right`
                   )->header( ``
                       )->label( `Birth Date`
                   )->get_parent(
               )->get_parent(
               )->column(
                   width          = `4rem`
                   demandpopin    = abap_true
                   halign         = `Right`
                   minscreenwidth = `Tablet`
                   popindisplay   = `Inline`
                   )->header( ``
                       )->label( `Gender`
                   )->get_parent(
               )->get_parent(
           )->get_parent(
           )->items(
               )->column_list_item(
                   )->cells(
                       )->label( `{FIRST_NAME}`
                       )->label( `{LAST_NAME}`
                       )->label( `{BIRTH_DATE}`
                       )->label( `{GENDER}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
