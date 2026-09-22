" @keywords translation i18n text element text symbol textpool language message class multi language
" @summary Puts the screen texts in the class's own text elements instead of an i18n file, so SE63 translates them and the app shows them in the logon language.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/translation_i18n
CLASS z2ui5_cl_smp_app_519 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA name TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_519 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `GREET`.
      " The text element is translated, the value is not - so the two are
      " concatenated here rather than written as one literal. A text element
      " with a placeholder would be a message class instead.
      client->message_box_display( |{ 'Hello'(004) } { name }| ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the three text symbols this app is about - see the block below
    DATA name_label  TYPE string.
    DATA placeholder TYPE string.
    DATA greet       TYPE string.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Basics VII - Translatable Texts (Text Elements)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A UI5 app keeps its translations in i18n files. An abap2UI5 app has no frontend ` &&
                   `artefacts to put them in - and does not need any: the view is built in ABAP, so ABAP's own ` &&
                   `translation carries it. Text elements here, a message class where a text takes placeholders.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " Every text below comes out of the class's text pool (Goto > Text
    " Elements in SE24/ADT). The literal in the source is the fallback and the
    " maintenance text; what renders is the entry for the logon language.
    "
    " Read into a VARIABLE first, and that is part of the lesson: a text
    " symbol is a CHARACTER literal, while the builder's v is TYPE string.
    " Handing one straight to v answers `'...'(001) is not type-compatible
    " with formal parameter V` on a system - a SYNTAX_ERROR of the class,
    " although abaplint, the transpiler and the unit suite are all green on
    " it. The assignment below is a plain conversion and is allowed on every
    " release. Inside a string template ( see on_event( ) ) the symbol needs
    " no variable: an embedded expression is a general expression position.
    "
    " And handed to t, not v: a translation is text somebody else types, and
    " t escapes it, so a `{` or `\` in one language's entry is shown rather
    " than read by UI5 as a binding.
    name_label  = 'Your name'(001).
    placeholder = 'Type a name here'(002).
    greet       = 'Greet'(003).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Label`
            )->a( n = `text`     t = name_label
            )->a( n = `labelFor` v = `nameInput`

        )->tag( `Input`
            )->a( n = `id`          v = `nameInput`
            )->a( n = `value`       v = client->_bind( name )
            )->a( n = `placeholder` t = placeholder
            )->a( n = `width`       v = `20rem`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `GREET` )
            )->a( n = `text`  t = greet
            )->a( n = `type`  v = `Emphasized`
            )->a( n = `class` v = `sapUiSmallMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
