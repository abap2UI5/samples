" @keywords messagebox details table structure tree object reference escape limit action onclose
" @summary Every shape message_box_display( ) accepts - a text, a number, HTML, messages, a table, a structure, an object - plus the options of the box itself.
CLASS z2ui5_cl_smp_app_502 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA answer TYPE string.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_s_message,
        type    TYPE c LENGTH 1,
        id      TYPE string,
        number  TYPE n LENGTH 3,
        message TYPE string,
      END OF ty_s_message.
    TYPES ty_t_message TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_t100,
        msgty TYPE c LENGTH 1,
        msgid TYPE string,
        msgno TYPE n LENGTH 3,
        msgv1 TYPE string,
        msgv2 TYPE string,
        msgv3 TYPE string,
        msgv4 TYPE string,
      END OF ty_s_t100.
    TYPES:
      BEGIN OF ty_s_address,
        street  TYPE string,
        city    TYPE string,
        country TYPE string,
      END OF ty_s_address.
    TYPES:
      BEGIN OF ty_s_item,
        posnr TYPE n LENGTH 6,
        matnr TYPE string,
        menge TYPE i,
        netwr TYPE p LENGTH 9 DECIMALS 2,
        waers TYPE c LENGTH 3,
      END OF ty_s_item.
    TYPES:
      BEGIN OF ty_s_order,
        vbeln     TYPE string,
        kunnr     TYPE string,
        erdat     TYPE d,
        s_address TYPE ty_s_address,
        t_item    TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY,
      END OF ty_s_order.
    TYPES:
      BEGIN OF ty_s_node,
        name  TYPE string,
        child TYPE REF TO data,
      END OF ty_s_node.
    " The key column is NOT called `id`: the message formatter runs before the
    " data renderer and reads a component of that name as a message id, which
    " would turn this business table into a box of messages that do not exist.
    " The same holds for TYPE, NUMBER, MESSAGE, TEXT and the MSG* spellings.
    TYPES:
      BEGIN OF ty_s_row,
        key   TYPE string,
        descr TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS on_event_basic
      IMPORTING
        event         TYPE clike
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS on_event_message
      IMPORTING
        event         TYPE clike
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS on_event_data
      IMPORTING
        event         TYPE clike
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS on_event_box
      IMPORTING
        event TYPE clike.

    METHODS view_display.
    METHODS render_basic
      IMPORTING form TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS render_message
      IMPORTING form TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS render_data
      IMPORTING form TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS render_limit
      IMPORTING form TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS render_box
      IMPORTING form TYPE REF TO z2ui5_cl_ui5_view_builder.
    METHODS render_section
      IMPORTING
        form  TYPE REF TO z2ui5_cl_ui5_view_builder
        title TYPE string.
    METHODS render_demo
      IMPORTING
        form  TYPE REF TO z2ui5_cl_ui5_view_builder
        label TYPE string
        text  TYPE string
        descr TYPE string
        press TYPE string.

    METHODS get_t_message
      RETURNING
        VALUE(result) TYPE ty_t_message.
    METHODS get_s_order
      RETURNING
        VALUE(result) TYPE ty_s_order.
    METHODS get_t_row
      IMPORTING
        rows          TYPE i
      RETURNING
        VALUE(result) TYPE ty_t_row.
    METHODS get_tree
      RETURNING
        VALUE(result) TYPE REF TO data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_502 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    DATA event TYPE string.
    event = client->get_event( ).
    IF on_event_basic( event ) = abap_true.
      RETURN.
    ENDIF.

    IF on_event_message( event ) = abap_true.
      RETURN.
    ENDIF.

    IF on_event_data( event ) = abap_true.
      RETURN.
    ENDIF.

    on_event_box( event ).

  ENDMETHOD.


  METHOD on_event_basic.
        DATA count TYPE i.

    result = abap_true.

    CASE event.

      WHEN `TEXT`.
        " a character value is its own text - the shape the method always had
        client->message_box_display( `The document was saved.` ).

      WHEN `NUMBER`.
        " a number, a date, a hex value: shown the way the runtime writes it,
        " trimmed - the app formats nothing
        
        count = 42.
        client->message_box_display( count ).

      WHEN `HTML`.
        " markup moves into the details, where UI5 renders it through a
        " FormattedText; the plain text behind it stays as the box text. Only
        " ul/ol/li/strong/em survive there - that is what the control keeps
        client->message_box_display(
            `<strong>Three checks failed:</strong><ul><li>No plant</li><li>No price</li><li>No route</li></ul>` ).

      WHEN `ESCAPE`.
        " every value the renderer writes is escaped, so business data that
        " looks like markup arrives as the text it is
        client->message_box_display( get_t_row( 2 ) ).

      WHEN OTHERS.
        result = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_message.

    DATA t_empty TYPE ty_t_message.
        DATA temp1 TYPE ty_s_message.
        DATA s_message LIKE temp1.
        DATA temp2 TYPE ty_s_t100.
        DATA s_t100 LIKE temp2.
            DATA value TYPE i.
            DATA error TYPE REF TO cx_root.

    result = abap_true.

    CASE event.

      WHEN `MSG_ONE`.
        " one message structure: the box takes its type and its title from the
        " message, so the app passes neither
        
        CLEAR temp1.
        temp1-type = `S`.
        temp1-id = `Z2UI5`.
        temp1-number = `001`.
        temp1-message = `Order 4711 was created`.
        
        s_message = temp1.
        client->message_box_display( s_message ).

      WHEN `MSG_TABLE`.
        " several messages collapse into ONE box: a counting headline, every
        " text as a bullet, type and title from the first
        client->message_box_display( get_t_message( ) ).

      WHEN `MSG_T100`.
        " no text at all, an id and a number: the text is resolved out of the
        " message class of the system, placeholders substituted
        
        CLEAR temp2.
        temp2-msgty = `I`.
        temp2-msgid = `00`.
        temp2-msgno = `001`.
        temp2-msgv1 = `The text`.
        temp2-msgv2 = `comes from`.
        temp2-msgv3 = `message class`.
        temp2-msgv4 = `00`.
        
        s_t100 = temp2.
        client->message_box_display( s_t100 ).

      WHEN `MSG_EXCEPTION`.
        " an exception is a message too - the box shows what get_text( )
        " renders, as an error
        TRY.
            
            value = 1 / 0.
            client->message_box_display( |{ value }| ).

            
          CATCH cx_root INTO error.
            client->message_box_display( error ).
        ENDTRY.

      WHEN `MSG_EMPTY`.
        " the one case that shows NOTHING at all: complex data that is
        " initial. A call over the result table of something that returned
        " nothing stays as silent as it always was
        client->message_box_display( t_empty ).
        client->message_toast_display( `No box - the message table was empty` ).

      WHEN OTHERS.
        result = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_data.

    DATA s_order TYPE ty_s_order.

    FIELD-SYMBOLS <s_tree> TYPE ty_s_node.
        DATA address LIKE REF TO s_order-s_address.
        DATA tree TYPE REF TO data.

    result = abap_true.

    CASE event.

      WHEN `DATA_TABLE`.
        " a business table: a counting headline in the box, the rows as a
        " numbered list below it
        s_order = get_s_order( ).
        client->message_box_display( s_order-t_item ).

      WHEN `DATA_STRUCTURE`.
        " a nested structure: field names in bold, the nested structure and
        " the nested table as lists of their own
        s_order = get_s_order( ).
        client->message_box_display( s_order ).

      WHEN `DATA_OBJECT`.
        " an object shows its PUBLIC instance state - here the running app
        " itself, which is why its client reference is protected: a public one
        " would arrive in this box as part of the app
        client->message_box_display( me ).

      WHEN `DATA_REFERENCE`.
        " a data reference is followed and what it points at is rendered
        s_order = get_s_order( ).
        
        GET REFERENCE OF s_order-s_address INTO address.
        client->message_box_display( address ).

      WHEN `LIMIT_ROWS`.
        " 120 rows against a limit of 100: the box renders the first hundred
        " and SAYS how many it left out instead of truncating silently
        client->message_box_display( get_t_row( 120 ) ).

      WHEN `LIMIT_DEPTH`.
        " a node that points at the next one, six levels deep. The renderer
        " stops at five and writes an ellipsis where it stopped - without the
        " limit a structure that points at itself would never end
        
        tree = get_tree( ).
        ASSIGN tree->* TO <s_tree>.
        IF sy-subrc = 0.
          client->message_box_display( <s_tree> ).
        ENDIF.

      WHEN OTHERS.
        result = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_box.

    DATA s_order TYPE ty_s_order.
        DATA type TYPE string.
        DATA temp3 TYPE string_table.

    CASE event.

      WHEN `BOX_TYPE`.
        " the severity, when the data does not bring one: information (the
        " default, mapped to MessageBox.show), success, warning, error. The
        " wire carries the value as the event argument, so one event and one
        " handler serve all four buttons
        
        type = client->get_event_arg( ).
        client->message_box_display( text = |This box was opened with type = { type }|
                                     type = type ).

      WHEN `BOX_OPTIONS`.
        " everything the box itself can be given, in one call.
        " closeonnavigation = abap_false keeps it open when the browser
        " navigates, the one option whose effect is not visible in the box.
        " The only parameter left out is `dependenton`, which ties the box to
        " the lifecycle of a control and needs UI5 1.124
        client->message_box_display( text              = `The delivery date lies in the past.`
                                     type              = `warning`
                                     title             = `Please check`
                                     icon              = `WARNING`
                                     contentwidth      = `25rem`
                                     styleclass        = `sapUiSizeCompact`
                                     textdirection     = `Inherit`
                                     closeonnavigation = abap_false ).

      WHEN `BOX_ACTIONS`.
        " the buttons of the box, which one is emphasized and which one has
        " the focus - and onclose, the event that carries the pressed action
        " back as the first event argument. An action is a MessageBox.Action
        " name or, like `Later`, any text the app wants on a button
        
        CLEAR temp3.
        INSERT `DELETE` INTO TABLE temp3.
        INSERT `Later` INTO TABLE temp3.
        INSERT `CANCEL` INTO TABLE temp3.
        client->message_box_display( text             = `Delete document 4711?`
                                     type             = `warning`
                                     title            = `Delete`
                                     actions          = temp3
                                     emphasizedaction = `DELETE`
                                     initialfocus     = `CANCEL`
                                     onclose          = `BOX_CLOSED` ).

      WHEN `BOX_CLOSED`.
        " the answer of the box above. Nothing is rendered here: `answer` is
        " bound, and changed bound data reaches the open view on its own
        answer = client->get_event_arg( ).
        client->message_toast_display( |You pressed { answer }| ).

      WHEN `BOX_DETAILS`.
        " details the app writes itself - the second block of the box. UI5
        " puts them behind a "Show details" link; abap2UI5 opens that block,
        " so what is in here is on screen when the box is
        client->message_box_display(
            text    = `The posting was rejected.`
            details = `<ul><li>Company code 1000 is closed</li><li>Period 08 is not open</li></ul>` ).

      WHEN `BOX_DETAILS_TAKEN`.
        " ... and the rule about them: details never overwrite a rendering.
        " The table below fills that slot, so what the app passes here is
        " dropped rather than hiding the data it asked to see
        s_order = get_s_order( ).
        client->message_box_display( text    = s_order-t_item
                                     details = `this text is not shown - the table owns the details` ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Message - MessageBox for Any Data`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `client->message_box_display( ) takes TYPE any: throw in what the app already holds. ` &&
                   `Messages are recognized first and bring their own severity and title; everything else - a table, ` &&
                   `a structure, a tree, an object, a number, an HTML string - is rendered instead of dropped. ` &&
                   `One button per case, and each button is one call: the app pre-formats nothing.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable`        b = abap_true
        )->a( n = `layout`          v = `ResponsiveGridLayout`
        )->a( n = `labelSpanXL`     v = `2`
        )->a( n = `labelSpanL`      v = `2`
        )->a( n = `labelSpanM`      v = `3`
        )->a( n = `labelSpanS`      v = `12`
        )->a( n = `adjustLabelSpan` v = `false`
        )->a( n = `columnsXL`       v = `1`
        )->a( n = `columnsL`        v = `1`
        )->a( n = `columnsM`        v = `1`
        )->ele( n = `content` ns = `form` ).

    render_basic( form ).
    render_message( form ).
    render_data( form ).
    render_limit( form ).
    render_box( form ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD render_basic.

    render_section( form  = form
                    title = `A text, a number, HTML` ).

    render_demo( form  = form
                 label = `Text`
                 text  = `A text`
                 descr = `A character value is its own text - the shape the method always had`
                 press = client->_event( `TEXT` ) ).

    render_demo( form  = form
                 label = `Number`
                 text  = `A number`
                 descr = `A number, a date, a hex value - shown the way the runtime writes it`
                 press = client->_event( `NUMBER` ) ).

    render_demo( form  = form
                 label = `HTML`
                 text  = `An HTML string`
                 descr = `Markup moves into the details, where UI5 renders it - the plain text stays in the box`
                 press = client->_event( `HTML` ) ).

    render_demo( form  = form
                 label = `Escaping`
                 text  = `Data that looks like HTML`
                 descr = `Every rendered value is escaped, so a value containing tags arrives as text`
                 press = client->_event( `ESCAPE` ) ).

  ENDMETHOD.


  METHOD render_message.

    render_section( form  = form
                    title = `Messages - recognized first, and they bring their own severity` ).

    render_demo( form  = form
                 label = `One message`
                 text  = `A message structure`
                 descr = `The BAPIRET2 shape - type and title come from the message, not from the call`
                 press = client->_event( `MSG_ONE` ) ).

    render_demo( form  = form
                 label = `Several messages`
                 text  = `A message table`
                 descr = `One box: a counting headline, every text as a bullet, severity from the first`
                 press = client->_event( `MSG_TABLE` ) ).

    render_demo( form  = form
                 label = `T100`
                 text  = `id, number, placeholders`
                 descr = `No text in the structure - it is resolved from the message class of the system`
                 press = client->_event( `MSG_T100` ) ).

    render_demo( form  = form
                 label = `Exception`
                 text  = `A caught exception`
                 descr = `The box shows what get_text( ) renders, as an error`
                 press = client->_event( `MSG_EXCEPTION` ) ).

    render_demo( form  = form
                 label = `Nothing`
                 text  = `An empty message table`
                 descr = `The one case that shows no box at all - a call that returned nothing stays silent`
                 press = client->_event( `MSG_EMPTY` ) ).

  ENDMETHOD.


  METHOD render_data.

    render_section( form  = form
                    title = `Any other data - rendered instead of dropped` ).

    render_demo( form  = form
                 label = `Table`
                 text  = `A business table`
                 descr = `A counting headline in the box, the rows as a numbered list below it`
                 press = client->_event( `DATA_TABLE` ) ).

    render_demo( form  = form
                 label = `Structure`
                 text  = `A nested structure`
                 descr = `Field names in bold; a nested structure and a nested table become lists of their own`
                 press = client->_event( `DATA_STRUCTURE` ) ).

    render_demo( form  = form
                 label = `Object`
                 text  = `An object reference`
                 descr = `The public instance state of the object - here the running app itself`
                 press = client->_event( `DATA_OBJECT` ) ).

    render_demo( form  = form
                 label = `Data reference`
                 text  = `A REF TO data`
                 descr = `The reference is followed and what it points at is rendered`
                 press = client->_event( `DATA_REFERENCE` ) ).

  ENDMETHOD.


  METHOD render_limit.

    render_section( form  = form
                    title = `Where the renderer stops - announced, never silent` ).

    render_demo( form  = form
                 label = `Row limit`
                 text  = `120 rows, 100 shown`
                 descr = `The box renders the first hundred and says how many it left out`
                 press = client->_event( `LIMIT_ROWS` ) ).

    render_demo( form  = form
                 label = `Depth limit`
                 text  = `A tree, six levels deep`
                 descr = `Five levels are rendered, an ellipsis marks where it stopped`
                 press = client->_event( `LIMIT_DEPTH` ) ).

  ENDMETHOD.


  METHOD render_box.
    DATA row TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE string_table.
    DATA t_type LIKE temp5.
    DATA type LIKE LINE OF t_type.

    render_section( form  = form
                    title = `The box itself` ).

    form->tag( `Label`
        )->a( n = `text` v = `Type` ).

    
    row = form->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->a( n = `wrap`       v = `Wrap` ).

    
    CLEAR temp5.
    INSERT `information` INTO TABLE temp5.
    INSERT `success` INTO TABLE temp5.
    INSERT `warning` INTO TABLE temp5.
    INSERT `error` INTO TABLE temp5.
    
    t_type = temp5.

    
    LOOP AT t_type INTO type.
      row->tag( `Button`
          )->a( n = `text`  v = type
          )->a( n = `press` v = client->_event( val = `BOX_TYPE`
                                                arg = type )
          )->a( n = `class` v = `sapUiTinyMarginEnd` ).
    ENDLOOP.

    row->tag( `Text`
        )->a( n = `text`  v = `The severity, when the data does not bring one - information is the default`
        )->a( n = `class` v = `sapUiSmallMarginBegin` ).

    render_demo( form  = form
                 label = `Options`
                 text  = `title, icon, width, class`
                 descr = `Everything the box itself can be given, in one call`
                 press = client->_event( `BOX_OPTIONS` ) ).

    render_demo( form  = form
                 label = `Actions`
                 text  = `Buttons and onclose`
                 descr = `actions, emphasizedAction, initialFocus - the pressed one comes back through onclose`
                 press = client->_event( `BOX_ACTIONS` ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Your answer`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( answer ) ).

    render_demo( form  = form
                 label = `Details`
                 text  = `Details from the app`
                 descr = `The second block of the box - shown straight away, not behind a link`
                 press = client->_event( `BOX_DETAILS` ) ).

    render_demo( form  = form
                 label = `Details, taken`
                 text  = `A table plus details`
                 descr = `Details never overwrite a rendering - the table owns the slot, the text is dropped`
                 press = client->_event( `BOX_DETAILS_TAKEN` ) ).

  ENDMETHOD.


  METHOD render_section.

    form->ele( `Toolbar`
        )->tag( `Title`
            )->a( n = `text`  v = title
            )->a( n = `level` v = `H3`
            )->a( n = `class` v = `sapUiSmallMarginBegin sapUiSmallMarginTop sapUiTinyMarginBottom`
    )->end( ).

  ENDMETHOD.


  METHOD render_demo.
    DATA row TYPE REF TO z2ui5_cl_ui5_view_builder.

    form->tag( `Label`
        )->a( n = `text` v = label ).

    
    row = form->ele( `HBox`
        )->a( n = `alignItems` v = `Center`
        )->a( n = `wrap`       v = `Wrap` ).

    row->tag( `Button`
        )->a( n = `text`  v = text
        )->a( n = `press` v = press
        )->a( n = `width` v = `15rem`
        )->tag( `Text`
            )->a( n = `text`  v = descr
            )->a( n = `class` v = `sapUiSmallMarginBegin` ).

  ENDMETHOD.


  METHOD get_t_message.

    DATA temp7 TYPE z2ui5_cl_smp_app_502=>ty_t_message.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp7.
    
    temp8-type = `E`.
    temp8-id = `Z2UI5`.
    temp8-number = `010`.
    temp8-message = `Material 4711 is not available in plant 1000`.
    INSERT temp8 INTO TABLE temp7.
    temp8-type = `W`.
    temp8-id = `Z2UI5`.
    temp8-number = `011`.
    temp8-message = `The delivery date was moved to 2026-10-01`.
    INSERT temp8 INTO TABLE temp7.
    temp8-type = `I`.
    temp8-id = `Z2UI5`.
    temp8-number = `012`.
    temp8-message = `Pricing was redetermined`.
    INSERT temp8 INTO TABLE temp7.
    temp8-type = `S`.
    temp8-id = `Z2UI5`.
    temp8-number = `013`.
    temp8-message = `Order 4711 was saved`.
    INSERT temp8 INTO TABLE temp7.
    result = temp7.

  ENDMETHOD.


  METHOD get_s_order.
    DATA temp1 TYPE z2ui5_cl_smp_app_502=>ty_s_order-t_item.
    DATA temp2 LIKE LINE OF temp1.

    CLEAR result.
    result-vbeln = `0000004711`.
    result-kunnr = `0000001000`.
    result-erdat = `20260904`.
    CLEAR result-s_address.
    result-s_address-street = `Dietmar-Hopp-Allee 16`.
    result-s_address-city = `Walldorf`.
    result-s_address-country = `DE`.
    
    CLEAR temp1.
    
    temp2-posnr = `000010`.
    temp2-matnr = `TG-11`.
    temp2-menge = 5.
    temp2-netwr = '249.90'.
    temp2-waers = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-posnr = `000020`.
    temp2-matnr = `TG-12`.
    temp2-menge = 2.
    temp2-netwr = '1199.00'.
    temp2-waers = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-posnr = `000030`.
    temp2-matnr = `TG-13`.
    temp2-menge = 12.
    temp2-netwr = '58.50'.
    temp2-waers = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    result-t_item = temp1.

  ENDMETHOD.


  METHOD get_t_row.
      DATA temp9 TYPE z2ui5_cl_smp_app_502=>ty_s_row.

    DO rows TIMES.
      " values that look like markup on purpose: this table is what the
      " escaping row shows as well
      
      CLEAR temp9.
      temp9-key = |ROW-{ sy-index }|.
      temp9-descr = |<b>Position { sy-index }</b> of a result set nobody reads in a popup & nowhere else|.
      INSERT temp9
             INTO TABLE result.
    ENDDO.

  ENDMETHOD.


  METHOD get_tree.

    DATA child TYPE REF TO data.

    FIELD-SYMBOLS <s_node> TYPE ty_s_node.

    " built from the bottom up, so every node holds the one below it
    DO 6 TIMES.
      CREATE DATA result TYPE ty_s_node.
      ASSIGN result->* TO <s_node>.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      <s_node>-name  = |Level { 7 - sy-index }|.
      <s_node>-child = child.
      child = result.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
