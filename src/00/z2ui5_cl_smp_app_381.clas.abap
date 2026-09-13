" @keywords toast notification duration position animation anchor collision onclose class css closeonbrowsernavigation
" @summary A MessageToast and everything that can be said about it: text, duration, width, where it docks and to what, collision, animation, a CSS class, and the event its closing fires.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_381 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA message TYPE string.
    DATA duration TYPE string.
    DATA width TYPE string.
    DATA my TYPE string.
    DATA at TYPE string.
    DATA dock_to_anchor TYPE abap_bool.
    DATA offset TYPE string.
    DATA collision TYPE string.
    DATA animation_timing TYPE string.
    DATA animation_duration TYPE string.
    DATA autoclose TYPE abap_bool.
    DATA close_on_navigation TYPE abap_bool.
    DATA notify_close TYPE abap_bool.
    DATA css_class TYPE string.
    DATA closed_count TYPE i.
    DATA closed_text TYPE string.

  PROTECTED SECTION.


    METHODS on_init.
    METHODS show_toast.
    METHODS view_display.
    METHODS get_positions
      RETURNING
        VALUE(result) TYPE string_table.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_381 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `SHOW` ).
      show_toast( ).
    ELSEIF client->check_on_event( `TOAST_CLOSED` ).

      " the onclose event: fired by the client when the toast is gone, with
      " or without the user - a plain backend event like any button press
      closed_count = closed_count + 1.
      closed_text  = |toast closed { closed_count } time(s) - the onclose event reached the backend|.

    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    message             = `This is a message toast.`.
    duration            = `3000`.
    width               = `15em`.
    my                  = `center bottom`.
    at                  = `center bottom`.
    offset              = `0 0`.
    collision           = `fit fit`.
    animation_timing    = `ease`.
    animation_duration  = `1000`.
    autoclose           = abap_true.
    close_on_navigation = abap_true.
    notify_close        = abap_true.
    css_class           = `myToast`.
    closed_text         = `no toast closed yet`.

  ENDMETHOD.


  METHOD show_toast.

    " `of` is the element the toast docks to - my/at are read relative to it
    " instead of to the window. It travels as a jQuery selector, so the
    " anchor is a DOM node with an id the backend can spell: the core:HTML
    " box in the view below, not a control whose id UI5 prefixes at runtime
    DATA(anchor) = COND string( WHEN dock_to_anchor = abap_true
                                THEN `#toastAnchor` ).
    " an empty event name means no callback; only a toast that should
    " report its closing carries one
    DATA(onclose) = COND string( WHEN notify_close = abap_true
                                 THEN `TOAST_CLOSED` ).

    client->message_toast_display(
        text                     = message
        duration                 = duration
        width                    = width
        my                       = my
        at                       = at
        of                       = anchor
        offset                   = offset
        collision                = collision
        onclose                  = onclose
        animationtimingfunction  = animation_timing
        animationduration        = animation_duration
        autoclose                = autoclose
        closeonbrowsernavigation = close_on_navigation
        class                    = css_class ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Message - MessageToast, Position, onClose and Class`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample demonstrates MessageToast: configure the text, duration, position - ` &&
                   `to the window or docked to the anchor box - collision, animation, a CSS class and the ` &&
                   `onclose event, then show a short, non-blocking toast notification.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the style behind the CSS class, and the anchor `of` docks to: a DOM
    " node whose id the backend knows, which no UI5 control can promise.
    " The braces of the CSS rule are escaped: the XML view parser would read
    " them as a binding otherwise
    page->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>.myToast \{ background-color: #0a6ed1; color: #fff; \}</style>` &&
                   `<div id="toastAnchor" class="sapUiSmallMargin" style="border: 2px dashed #0a6ed1; padding: 0.5rem; width: 14rem;">` &&
                   `the anchor box (id toastAnchor)</div>` ).

    page->ele( `headerContent`
        )->tag( `Link`
            )->a( n = `text`   v = `UI5 Demo Kit`
            )->a( n = `target` v = `_blank`
            )->a( n = `href`   v = `https://sdk.openui5.org/entity/sap.m.MessageToast/sample/sap.m.sample.MessageToast` ).

    DATA(form) = page->ele( `Panel`
        )->a( n = `headerText` v = `Message Toast Configuration`
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `title`    v = `Settings`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `Message`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( message )
        )->tag( `Label`
            )->a( n = `text` v = `Duration (ms)`
        )->tag( `Input`
            )->a( n = `type`  v = `Number`
            )->a( n = `value` v = client->_bind( duration )
        )->tag( `Label`
            )->a( n = `text` v = `Width`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( width ) ).

    DATA(select_my) = form->tag( `Label`
        )->a( n = `text` v = `my`
        )->ele( `Select`
            )->a( n = `selectedKey` v = client->_bind( my ) ).
    DATA(select_at) = form->tag( `Label`
        )->a( n = `text` v = `at`
        )->ele( `Select`
            )->a( n = `selectedKey` v = client->_bind( at ) ).

    LOOP AT get_positions( ) INTO DATA(position).
      select_my->tag( n = `Item` ns = `core`
          )->a( n = `key`  t = position
          )->a( n = `text` t = position ).
      select_at->tag( n = `Item` ns = `core`
          )->a( n = `key`  t = position
          )->a( n = `text` t = position ).
    ENDLOOP.

    form->tag( `Label`
        )->a( n = `text` v = `of - dock to the anchor box instead of the window`
        )->tag( `CheckBox`
            )->a( n = `selected` v = client->_bind( dock_to_anchor )
        )->tag( `Label`
            )->a( n = `text` v = `offset`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( offset ) ).

    form->tag( `Label`
        )->a( n = `text` v = `collision`
        )->ele( `Select`
            )->a( n = `selectedKey` v = client->_bind( collision )
            )->tag( n = `Item` ns = `core`
                )->a( n = `key`  v = `fit fit`
                )->a( n = `text` v = `fit fit - shift into the viewport`
            )->tag( n = `Item` ns = `core`
                )->a( n = `key`  v = `flip flip`
                )->a( n = `text` v = `flip flip - flip to the opposite side`
            )->tag( n = `Item` ns = `core`
                )->a( n = `key`  v = `flipfit flipfit`
                )->a( n = `text` v = `flipfit flipfit - flip first, then shift`
            )->tag( n = `Item` ns = `core`
                )->a( n = `key`  v = `none none`
                )->a( n = `text` v = `none none - stay where told` ).

    DATA(select_animation) = form->tag( `Label`
        )->a( n = `text` v = `animationTimingFunction`
        )->ele( `Select`
            )->a( n = `selectedKey` v = client->_bind( animation_timing ) ).
    select_animation->tag( n = `Item` ns = `core`
        )->a( n = `key`  v = `ease`
        )->a( n = `text` v = `ease`
        )->tag( n = `Item` ns = `core`
            )->a( n = `key`  v = `linear`
            )->a( n = `text` v = `linear`
        )->tag( n = `Item` ns = `core`
            )->a( n = `key`  v = `ease-in`
            )->a( n = `text` v = `ease-in`
        )->tag( n = `Item` ns = `core`
            )->a( n = `key`  v = `ease-out`
            )->a( n = `text` v = `ease-out`
        )->tag( n = `Item` ns = `core`
            )->a( n = `key`  v = `ease-in-out`
            )->a( n = `text` v = `ease-in-out` ).

    form->tag( `Label`
        )->a( n = `text` v = `animationDuration (ms)`
        )->tag( `Input`
            )->a( n = `type`  v = `Number`
            )->a( n = `value` v = client->_bind( animation_duration )
        )->tag( `Label`
            )->a( n = `text` v = `autoClose`
        )->tag( `CheckBox`
            )->a( n = `selected` v = client->_bind( autoclose )
        )->tag( `Label`
            )->a( n = `text` v = `closeOnBrowserNavigation`
        )->tag( `CheckBox`
            )->a( n = `selected` v = client->_bind( close_on_navigation )
        )->tag( `Label`
            )->a( n = `text` v = `onclose - report the closing as a backend event`
        )->tag( `CheckBox`
            )->a( n = `selected` v = client->_bind( notify_close )
        )->tag( `Label`
            )->a( n = `text` v = `class - a CSS class for the toast (myToast is styled above)`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( css_class ) ).

    form->tag( `Button`
        )->a( n = `press` v = client->_event( `SHOW` )
        )->a( n = `text`  v = `Show Message Toast`
        )->a( n = `type`  v = `Emphasized` ).

    form->tag( `Label`
        )->a( n = `text` v = `the onclose event`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( closed_text ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_positions.

    result = VALUE #(
      ( `begin top` )
      ( `begin center` )
      ( `begin bottom` )
      ( `left top` )
      ( `left center` )
      ( `left bottom` )
      ( `center top` )
      ( `center center` )
      ( `center bottom` )
      ( `right top` )
      ( `right center` )
      ( `right bottom` )
      ( `end top` )
      ( `end center` )
      ( `end bottom` ) ).

  ENDMETHOD.

ENDCLASS.
