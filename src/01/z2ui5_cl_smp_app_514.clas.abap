" @keywords carousel aggregation item index clone template setactivepage positional control_by_id
" @summary Jumps a Carousel to a page that was cloned from a bound template - addressed positionally as id/aggregation/index, the only way to reach a clone.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_514 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_page,
        title TYPE string,
        text  TYPE string,
      END OF ty_s_page.

    DATA t_pages TYPE STANDARD TABLE OF ty_s_page WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - the index the backend last jumped to, counted from 1
    DATA current TYPE i.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.
    METHODS page_show
      IMPORTING
        index TYPE i.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_514 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    t_pages = VALUE #( ( title = `Bicycle`  text = `The first page of the carousel.` )
                       ( title = `Car`      text = `The second page - and the one the buttons below jump to.` )
                       ( title = `Train`    text = `The third page.` )
                       ( title = `Aircraft` text = `The fourth and last page.` ) ).
    current = 1.

  ENDMETHOD.


  METHOD page_show.

    current = index.
    " A page of this carousel is a CLONE of the aggregation template, and a
    " clone has no id the backend can spell: UI5 mints it from the template
    " id, the parent id and the position, and the parent id carries the view
    " prefix assigned at runtime. So the item is addressed POSITIONALLY -
    " `<control id>/<aggregation>/<index>`, 0-based - which the frontend
    " resolves against the live aggregation. It is the equivalent of the UI5
    " controller idiom oCarousel.setActivePage( oCarousel.getPages()[ i ] ).
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                              t_arg = VALUE #( ( `demoCarousel` )
                                               ( `setActivePage` )
                                               ( |demoCarousel/pages/{ index - 1 }| ) ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `FIRST`.
        page_show( 1 ).

      WHEN `NEXT`.
        " wrap around at the end - the count is ABAP's, not the carousel's
        page_show( COND #( WHEN current >= lines( t_pages ) THEN 1 ELSE current + 1 ) ).

      WHEN `LAST`.
        page_show( lines( t_pages ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Aggregation Item by Index`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The carousel pages are clones of a bound template, so none of them has an id the backend ` &&
                   `could name. Wherever a control call takes a control id it also takes an aggregation item, written ` &&
                   `id/aggregation/index and counted from 0.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `FIRST` )
            )->a( n = `text`  v = `First`
            )->a( n = `icon`  v = `sap-icon://close-command-field`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `NEXT` )
            )->a( n = `text`  v = `Next`
            )->a( n = `icon`  v = `sap-icon://navigation-right-arrow`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `LAST` )
            )->a( n = `text`  v = `Last`
            )->a( n = `icon`  v = `sap-icon://open-command-field` ).

    page->ele( `Carousel`
        )->a( n = `id`     v = `demoCarousel`
        )->a( n = `height` v = `20rem`
        )->a( n = `pages`  v = client->_bind( t_pages )
        )->a( n = `class`  v = `sapUiSmallMargin`

        )->ele( `pages`
            )->ele( `VBox`
                )->a( n = `justifyContent` v = `Center`
                )->a( n = `alignItems`     v = `Center`
                )->a( n = `height`         v = `100%`

                )->tag( `Title`
                    )->a( n = `text`  v = `{TITLE}`
                    )->a( n = `level` v = `H2`

                )->tag( `Text`
                    )->a( n = `text`  v = `{TEXT}`
                    )->a( n = `class` v = `sapUiSmallMarginTop` ).

    client->view_display( view->stringify( ) ).

    " The active page is live control state that no binding carries: this
    " response destroys the view slot and the frontend rebuilds the control
    " tree, so the carousel comes back on its first page while `current`
    " survives in ABAP. Re-issuing the call from here - after the view that
    " will hold it - is what keeps the two in step across a rebuild.
    page_show( current ).

  ENDMETHOD.

ENDCLASS.
