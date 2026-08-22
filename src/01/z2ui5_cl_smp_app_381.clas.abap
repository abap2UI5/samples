" @keywords toast notification duration position animation
" @summary A MessageToast and what can be said about it: text, duration, position and animation.
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
    DATA offset TYPE string.
    DATA animation_timing TYPE string.
    DATA animation_duration TYPE string.
    DATA autoclose TYPE abap_bool.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `SHOW` ) IS NOT INITIAL.
      show_toast( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    message            = `This is a message toast.`.
    duration           = `3000`.
    width              = `15em`.
    my                 = `center bottom`.
    at                 = `center bottom`.
    offset             = `0 0`.
    animation_timing   = `ease`.
    animation_duration = `1000`.
    autoclose          = abap_true.

  ENDMETHOD.


  METHOD show_toast.

    client->message_toast_display(
        text                    = message
        duration                = duration
        width                   = width
        my                      = my
        at                      = at
        offset                  = offset
        animationtimingfunction = animation_timing
        animationduration       = animation_duration
        autoclose               = autoclose ).

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA select_my TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA select_at TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA position LIKE LINE OF temp1.
    DATA select_animation TYPE REF TO z2ui5_cl_ui5_view_builder.
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Message - MessageToast, Text and Duration`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample demonstrates MessageToast: configure the text, duration, position ` &&
                   `and animation, then show a short, non-blocking toast notification.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `headerContent`
        )->tag( `Link`
            )->a( n = `text`   v = `UI5 Demo Kit`
            )->a( n = `target` v = `_blank`
            )->a( n = `href`   v = `https://sdk.openui5.org/entity/sap.m.MessageToast/sample/sap.m.sample.MessageToast` ).

    
    form = page->ele( `Panel`
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

    
    select_my = form->tag( `Label`
        )->a( n = `text` v = `my`
        )->ele( `Select`
            )->a( n = `selectedKey` v = client->_bind( my ) ).
    
    select_at = form->tag( `Label`
        )->a( n = `text` v = `at`
        )->ele( `Select`
            )->a( n = `selectedKey` v = client->_bind( at ) ).

    
    temp1 = get_positions( ).
    
    LOOP AT temp1 INTO position.
      select_my->tag( n = `Item` ns = `core`
          )->a( n = `key`  v = position
          )->a( n = `text` v = position ).
      select_at->tag( n = `Item` ns = `core`
          )->a( n = `key`  v = position
          )->a( n = `text` v = position ).
    ENDLOOP.

    form->tag( `Label`
        )->a( n = `text` v = `offset` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( offset ) ).

    
    select_animation = form->tag( `Label`
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
            )->a( n = `selected` v = client->_bind( autoclose ) ).

    form->tag( `Button`
        )->a( n = `press` v = client->_event( `SHOW` )
        )->a( n = `text`  v = `Show Message Toast`
        )->a( n = `type`  v = `Emphasized` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_positions.

    DATA temp2 TYPE string_table.
    CLEAR temp2.
    INSERT `begin top` INTO TABLE temp2.
    INSERT `begin center` INTO TABLE temp2.
    INSERT `begin bottom` INTO TABLE temp2.
    INSERT `left top` INTO TABLE temp2.
    INSERT `left center` INTO TABLE temp2.
    INSERT `left bottom` INTO TABLE temp2.
    INSERT `center top` INTO TABLE temp2.
    INSERT `center center` INTO TABLE temp2.
    INSERT `center bottom` INTO TABLE temp2.
    INSERT `right top` INTO TABLE temp2.
    INSERT `right center` INTO TABLE temp2.
    INSERT `right bottom` INTO TABLE temp2.
    INSERT `end top` INTO TABLE temp2.
    INSERT `end center` INTO TABLE temp2.
    INSERT `end bottom` INTO TABLE temp2.
    result = temp2.

  ENDMETHOD.

ENDCLASS.
