" @keywords toast notification global object control_global follow_up_action options duration position animation anchor collision class css template
" @summary The MessageToast steered as the UI5 control it is: every sap.m.MessageToast option 1:1 through the global object, plus a toast composed on the client without a round-trip.
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
    TYPES:
      BEGIN OF ty_s_opt,
        name TYPE string,
        val  TYPE string,
      END OF ty_s_opt.
    TYPES ty_t_opt TYPE STANDARD TABLE OF ty_s_opt WITH DEFAULT KEY.

    METHODS toast_options
      RETURNING
        VALUE(result) TYPE string.
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
    ELSEIF client->check_on_event( `TOAST_CLOSED` ) IS NOT INITIAL.

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

    " Where a toast docks, how it animates, how wide it is - that is the
    " CONTROL, not the ABAP app, so it is set the way every other UI5 control
    " is steered from here: the whitelisted global call, whose last argument
    " is the option object of sap.m.MessageToast.show( ) 1:1.
    "
    " client->message_toast_display( ) carries none of these. It carries what
    " an ABAP app decides - the text, how long the toast stands, and the
    " backend event its closing raises - and the class
    " Z2UI5_CL_SMP_APP_502 shows that side for the message box
    DATA temp1 TYPE string_table.
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT message INTO TABLE temp1.
    INSERT toast_options( ) INTO TABLE temp1.
    client->follow_up_action( val   = client->cs_event-control_global
                              t_arg = temp1 ).

  ENDMETHOD.


  METHOD toast_options.

    DATA t_opt TYPE string_table.
      DATA temp3 LIKE LINE OF t_opt.
      DATA temp4 LIKE LINE OF t_opt.
    DATA temp1 TYPE ty_t_opt.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp5 LIKE temp1.
    DATA s_opt LIKE LINE OF temp5.
        DATA temp6 LIKE LINE OF t_opt.
    DATA temp7 TYPE string.
    DATA temp12 LIKE LINE OF t_opt.
    DATA temp8 TYPE string.
    DATA temp13 LIKE LINE OF t_opt.
      DATA temp9 LIKE LINE OF t_opt.
      DATA temp10 LIKE LINE OF t_opt.
      DATA temp11 LIKE LINE OF t_opt.
    DATA option LIKE LINE OF t_opt.

    " The option object as JSON. A t_arg that starts with a brace is embedded
    " as REAL JSON by the framework, so this arrives on the client as an
    " object - not as a string that happens to look like one. Numbers stay
    " unquoted and flags are true/false, because sap.m.MessageToast checks
    " the type of every option it reads.
    "
    " An option the form left EMPTY is left out rather than sent empty: a
    " `"duration":` is no JSON, the backend would fail to parse the whole
    " object and embed it as a plain string, and the toast would then show
    " with no options at all - quietly, which is the one failure mode of this
    " path worth knowing
    IF duration IS NOT INITIAL.
      
      temp3 = |"duration":{ duration }|.
      APPEND temp3 TO t_opt.
    ENDIF.
    IF animation_duration IS NOT INITIAL.
      
      temp4 = |"animationDuration":{ animation_duration }|.
      APPEND temp4 TO t_opt.
    ENDIF.
    
    CLEAR temp1.
    
    temp2-name = `width`.
    temp2-val = width.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `my`.
    temp2-val = my.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `at`.
    temp2-val = at.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `offset`.
    temp2-val = offset.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `collision`.
    temp2-val = collision.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `animationTimingFunction`.
    temp2-val = animation_timing.
    INSERT temp2 INTO TABLE temp1.
    
    temp5 = temp1.
    
    LOOP AT temp5 INTO s_opt.
      IF s_opt-val IS NOT INITIAL.
        
        temp6 = |"{ s_opt-name }":"{ s_opt-val }"|.
        APPEND temp6 TO t_opt.
      ENDIF.
    ENDLOOP.
    
    IF autoclose = abap_true.
      temp7 = `true`.
    ELSE.
      temp7 = `false`.
    ENDIF.
    
    temp12 = |"autoClose":{ temp7 }|.
    APPEND temp12 TO t_opt.
    
    IF close_on_navigation = abap_true.
      temp8 = `true`.
    ELSE.
      temp8 = `false`.
    ENDIF.
    
    temp13 = |"closeOnBrowserNavigation":{ temp8 }|.
    APPEND temp13 TO t_opt.

    " `of` is the element the toast docks to - my/at are read relative to it
    " instead of to the window. It travels as a jQuery selector, so the
    " anchor is a DOM node with an id the backend can spell: the core:HTML
    " box in the view below, not a control whose id UI5 prefixes at runtime
    IF dock_to_anchor = abap_true.
      
      temp9 = |"of":"#toastAnchor"|.
      APPEND temp9 TO t_opt.
    ENDIF.

    " `class` is the one entry here that is NO MessageToast option: the
    " frontend puts the classes on the DOM node of the toast, which carries
    " no id to address it by. It rides in the same object
    IF css_class IS NOT INITIAL.
      
      temp10 = |"class":"{ css_class }"|.
      APPEND temp10 TO t_opt.
    ENDIF.

    " onClose is a BACKEND event name here, not a JS callback: the frontend
    " turns it into the round-trip that reaches on_event below
    IF notify_close = abap_true.
      
      temp11 = |"onClose":"TOAST_CLOSED"|.
      APPEND temp11 TO t_opt.
    ENDIF.

    
    LOOP AT t_opt INTO option.
      IF result IS INITIAL.
        result = option.
      ELSE.
        result = |{ result },{ option }|.
      ENDIF.
    ENDLOOP.

    result = |\{{ result }\}|.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA select_my TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA select_at TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp12 TYPE string_table.
    DATA position LIKE LINE OF temp12.
    DATA select_animation TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp13 TYPE string_table.
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
                    )->a( n = `title`          v = `abap2UI5 - Message - MessageToast via the Global Object`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Two ways to a toast, and this is the UI5 one: follow_up_action( cs_event-control_global ) ` &&
                   `calls sap.m.MessageToast.show( ) itself, and its last argument is the option object of that API 1:1 - ` &&
                   `position, collision, animation, autoClose. Configure them below and watch the object travel. ` &&
                   `The other way is client->message_toast_display( ), which carries no UI5 option at all: it carries ` &&
                   `what an ABAP app decides, and Z2UI5_CL_SMP_APP_502 shows that side for the message box.`
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

    
    temp12 = get_positions( ).
    
    LOOP AT temp12 INTO position.
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

    " ... and the second reason the global object exists: the same call WIRED
    " into the view. The toast is composed on the client - the extra argument
    " fills the {0} placeholder of the text - so a button that only wants to
    " say what was pressed needs no round-trip to the backend at all
    
    CLEAR temp13.
    INSERT `MESSAGE_TOAST` INTO TABLE temp13.
    INSERT `show` INTO TABLE temp13.
    INSERT `{0} - composed on the client, the backend never saw this press` INTO TABLE temp13.
    INSERT `${$source>/text}` INTO TABLE temp13.
    form->tag( `Label`
        )->a( n = `text` v = `wired, no round-trip - the text is composed on the client`
        )->tag( `Button`
            )->a( n = `text`  v = `Compose on the client`
            )->a( n = `press` v = client->follow_up_action(
                                       val   = client->cs_event-control_global
                                       t_arg = temp13 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_positions.

    DATA temp15 TYPE string_table.
    CLEAR temp15.
    INSERT `begin top` INTO TABLE temp15.
    INSERT `begin center` INTO TABLE temp15.
    INSERT `begin bottom` INTO TABLE temp15.
    INSERT `left top` INTO TABLE temp15.
    INSERT `left center` INTO TABLE temp15.
    INSERT `left bottom` INTO TABLE temp15.
    INSERT `center top` INTO TABLE temp15.
    INSERT `center center` INTO TABLE temp15.
    INSERT `center bottom` INTO TABLE temp15.
    INSERT `right top` INTO TABLE temp15.
    INSERT `right center` INTO TABLE temp15.
    INSERT `right bottom` INTO TABLE temp15.
    INSERT `end top` INTO TABLE temp15.
    INSERT `end center` INTO TABLE temp15.
    INSERT `end bottom` INTO TABLE temp15.
    result = temp15.

  ENDMETHOD.

ENDCLASS.
