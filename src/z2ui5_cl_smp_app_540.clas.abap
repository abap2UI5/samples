" @keywords ai llm chat assistant chatbot prompt conversation feedinput feedlistitem busy start_timer
" @summary A chat assistant screen - conversation history, suggested prompts, a busy feed while the answer is on its way, a clear button - answered by a built-in rule-based provider that one method turns into a real LLM call.
CLASS z2ui5_cl_smp_app_540 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        role   TYPE string,
        sender TYPE string,
        text   TYPE string,
        icon   TYPE string,
        info   TYPE string,
      END OF ty_s_message.
    TYPES ty_t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

    DATA t_messages TYPE ty_t_messages.
    DATA busy       TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS chat_reset.
    METHODS prompt_send
      IMPORTING
        prompt TYPE string.
    METHODS message_add
      IMPORTING
        role TYPE string
        text TYPE string.

    "! The provider seam: the whole conversation in, the next answer out.
    "! @parameter t_history | the conversation so far, newest message first
    "! @parameter result    | the assistant's answer
    METHODS get_answer
      IMPORTING
        t_history     TYPE ty_t_messages
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_540 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      chat_reset( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `POST` OR `SUGGEST`.
        prompt_send( client->get_event_arg( ) ).

      WHEN `ANSWER`.
        message_add( role = `assistant`
                     text = get_answer( t_messages ) ).
        busy = abap_false.

      WHEN `CLEAR`.
        chat_reset( ).

    ENDCASE.

  ENDMETHOD.


  METHOD chat_reset.

    t_messages = VALUE #( ).
    busy       = abap_false.

    message_add( role = `assistant`
                 text = `Hi, I am the assistant of this sample. Type a question or pick one of the suggestions above.` ).

  ENDMETHOD.


  METHOD prompt_send.

    IF prompt IS INITIAL OR busy = abap_true.
      RETURN.
    ENDIF.

    message_add( role = `user`
                 text = prompt ).
    busy = abap_true.

    " The answer comes in a SECOND roundtrip: this response shows the
    " question at once and puts the feed into its busy state, the timer then
    " asks for the answer. With a real LLM that second roundtrip is where the
    " seconds are spent. The 800 ms only stand in for that time here - drop
    " the delay to 0 once a real provider answers.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-start_timer
                              t_arg = VALUE #( ( `ANSWER` ) ( `800` ) ) ).

  ENDMETHOD.


  METHOD message_add.

    " newest first - the order of a sap.m feed, with the FeedInput on top
    INSERT VALUE #( role   = role
                    text   = text
                    sender = COND #( WHEN role = `user` THEN `You` ELSE `Assistant` )
                    icon   = COND #( WHEN role = `user` THEN `sap-icon://customer` ELSE `sap-icon://hint` )
                    info   = COND #( WHEN role = `assistant` THEN `built-in rule-based provider` ) )
           INTO t_messages INDEX 1.

  ENDMETHOD.


  METHOD get_answer.

    " ---------------------------------------------------------------------
    " Plug a real LLM in HERE, and nowhere else. The method receives the
    " whole conversation, which is what a chat completion API wants: map
    " t_history to its message list (role user / assistant - reverse it,
    " the feed keeps it newest first), send it, return the reply text.
    " The view, the busy state and the history handling stay as they are.
    "
    " Calling an endpoint needs an HTTP destination or a communication
    " arrangement on the system, which a sample in this repository cannot
    " bring along - the samples that call a real model live in
    " abap2UI5/samples-stack: https://github.com/abap2UI5/samples-stack
    "
    " Until then this deterministic provider answers: a few keyword rules
    " over the last question, so the sample runs on every system and in CI.
    " ---------------------------------------------------------------------
    DATA question TYPE string.
    DATA first_question TYPE string.
    DATA user_count TYPE i.

    LOOP AT t_history INTO DATA(message).

      IF message-role <> `user`.
        CONTINUE.
      ENDIF.

      user_count = user_count + 1.
      IF user_count = 1.
        question = message-text.
      ENDIF.
      first_question = message-text.
    ENDLOOP.

    " blanks around the words, punctuation removed: ` hi ` must match the
    " greeting and not the start of `history`
    DATA(words) = | { to_lower( translate( val = question from = `?!.,;:` to = `` ) ) } |.

    IF contains( val = words sub = ` hello ` ) OR contains( val = words sub = ` hi ` ) OR contains( val = words sub = ` hey ` ).
      result = `Hello! Ask me what I can do, what abap2UI5 is, or how to plug in a real language model.`.

    ELSEIF contains( val = words sub = ` help ` ) OR contains( val = words sub = ` can you do ` ).
      result = `I am a rule-based stand-in for a language model. I know a few topics: abap2UI5 itself, how to ` &&
               `plug in a real LLM, how many messages this chat has, and what you asked first.`.

    ELSEIF contains( val = words sub = ` llm ` ) OR contains( val = words sub = ` real ` ) OR contains( val = words sub = ` plug ` ).
      result = `Replace the body of the method get_answer( ) with a call to your model. It already receives the ` &&
               `whole conversation, so the model sees the context - the screen does not change at all.`.

    ELSEIF contains( val = words sub = ` abap2ui5 ` ).
      result = `abap2UI5 builds UI5 apps in pure ABAP: one class renders the view, binds its attributes and ` &&
               `handles the events - this chat is one such class.`.

    ELSEIF contains( val = words sub = ` how many ` ).
      result = |This chat holds { lines( t_history ) } messages so far, { user_count } of them from you.|.

    ELSEIF contains( val = words sub = ` first ` ).
      result = |The first thing you asked was: "{ first_question }"|.

    ELSE.
      result = |You said: "{ question }". I only follow a few rules - ask me what I can do to see them.|.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA t_prompts TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    t_prompts = VALUE #( ( `What can you do?` )
                         ( `What is abap2UI5?` )
                         ( `How do I plug in a real LLM?` )
                         ( `How many messages so far?` )
                         ( `What did I ask first?` ) ).

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - AI - Chat Assistant with FeedInput and FeedListItem`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->ele( `headerContent`
        )->tag( `Button`
            )->a( n = `text`    v = `Clear Chat`
            )->a( n = `icon`    v = `sap-icon://delete`
            )->a( n = `enabled` v = |\{= !${ client->_bind( busy ) } \}|
            )->a( n = `press`   v = client->_event( `CLEAR` ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A chat assistant screen: the question shows at once, the feed stays busy until the answer ` &&
                   `arrives in a second roundtrip. The answer comes from one method that receives the whole conversation - ` &&
                   `here a rule-based stand-in, in a real app the call to your language model.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(content) = page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMarginBeginEnd` ).

    " the typed text leaves the browser as the event argument - the
    " FeedInput clears itself after post, so its value is not bound
    content->tag( `FeedInput`
        )->a( n = `placeholder` v = `Ask the assistant something...`
        )->a( n = `icon`        v = `sap-icon://customer`
        )->a( n = `enabled`     v = |\{= !${ client->_bind( busy ) } \}|
        )->a( n = `post`        v = client->_event( val = `POST`
                                                    arg = `${$parameters>/value}` ) ).

    DATA(suggestions) = content->ele( `HBox`
        )->a( n = `wrap`  v = `Wrap`
        )->a( n = `class` v = `sapUiSmallMarginTop` ).
    LOOP AT t_prompts INTO DATA(prompt).
      suggestions->tag( `Button`
          )->a( n = `text`    t = prompt
          )->a( n = `class`   v = `sapUiTinyMarginEnd sapUiTinyMarginBottom`
          )->a( n = `enabled` v = |\{= !${ client->_bind( busy ) } \}|
          )->a( n = `press`   v = client->_event( val = `SUGGEST`
                                                  arg = prompt ) ).
    ENDLOOP.

    content->ele( `List`
        )->a( n = `items`              v = client->_bind( t_messages )
        )->a( n = `busy`               v = client->_bind( busy )
        )->a( n = `busyIndicatorDelay` v = `0`
        )->a( n = `showSeparators`     v = `Inner`
        )->a( n = `noDataText`         v = `No messages yet.`
        )->ele( `items`
            )->tag( `FeedListItem`
                )->a( n = `sender`       v = `{SENDER}`
                )->a( n = `text`         v = `{TEXT}`
                )->a( n = `icon`         v = `{ICON}`
                )->a( n = `info`         v = `{INFO}`
                )->a( n = `senderActive` b = abap_false
                )->a( n = `iconActive`   b = abap_false ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
