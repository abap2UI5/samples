# CLAUDE.md

## Project

abap2UI5 Samples - Collection of demo apps for the abap2UI5 framework.

## Language

- **This entire project is in English.** All code, comments, commit messages, PR titles, PR descriptions, and any other text must be written in English.

## Rules

### abaplint

- **Run `abaplint` before every commit. It must report 0 issues.**
- Configuration: `abaplint.jsonc`
- Install: `npm install -g @abaplint/cli`
- Run: `abaplint`

### Code Conventions

- Follow the [SAP ABAP Style Guide](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md).
- Never use an init flag attribute (`check_initialized`, `mv_init`, `is_initialized`, etc.). Always use `client->check_on_init( )` instead.
- Use backticks for all string literals, not single quotes.

## How Apps Work

Every abap2UI5 app implements `z2ui5_if_app` with a single `main()` method. The framework calls `main()` on every roundtrip (HTTP POST). Use the lifecycle checks to react to different situations:

- `client->check_on_init( )` — true on the very first call
- `client->check_on_navigated( )` — true when returning from a sub-app or popup
- `client->check_on_event( )` — true when a user triggered an event

### Client API (`z2ui5_if_client`)

| Category | Methods | Purpose |
|---|---|---|
| Views | `view_display`, `view_destroy`, `view_model_update` | Main view lifecycle |
| Nested views | `nest_view_display/destroy/model_update`, `nest2_view_*` | Embedded sub-views |
| Popups | `popup_display`, `popup_destroy`, `popup_model_update` | Modal dialogs |
| Popovers | `popover_display`, `popover_destroy`, `popover_model_update` | Context popovers |
| Binding | `_bind(val)`, `_bind_edit(val)` | Read-only / two-way binding |
| Events | `_event(val)`, `_event_client(val)`, `check_on_event(val)` | Event registration and checking |
| Navigation | `nav_app_call(app)`, `nav_app_leave()`, `get_app_prev()` | App stack navigation |
| Lifecycle | `check_on_init()`, `check_on_navigated()`, `check_app_prev_stack()` | State checks |
| Messages | `message_box_display(text)`, `message_toast_display(text)` | User notifications |
| Session | `set_session_stateful(val)`, `set_app_state_active(val)` | Session management |
| Browser | `set_push_state(val)`, `set_nav_back(val)`, `follow_up_action(val)` | Browser interaction |
| Info | `get()`, `get_event_arg()`, `get_app(id)` | Request/context data |
| Constants | `cs_event`, `cs_view` | Predefined event IDs and view names |

## App Structure

### Simple apps (< 50 lines total)

Write everything directly in `main` — no method encapsulation needed.

### Larger apps — canonical template

The following is the **maximum structure**. Only add methods that are actually needed.

```abap
CLASS z2ui5_cl_app_xxx DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    " bound data (DATA attributes for _bind/_bind_edit)...

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.        " first call: load data, display view
    METHODS on_event.       " user triggered an event
    METHODS on_navigation.  " returned from sub-app or popup
    METHODS view_display.   " build and render the view
    METHODS data_read.      " SELECT from database
    METHODS data_update.    " INSERT / UPDATE / DELETE

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_app_xxx IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      on_navigation( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_init.
    data_read( ).
    view_display( ).
  ENDMETHOD.

  METHOD on_navigation.
    data_read( ).
    client->view_model_update( ).
  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.
      WHEN `SAVE`.
        data_update( ).
      WHEN `BACK`.
        client->nav_app_leave( ).
    ENDCASE.
  ENDMETHOD.

  METHOD view_display.
    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    " ...
    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  METHOD data_read.
    " SELECT ...
  ENDMETHOD.

  METHOD data_update.
    " INSERT / UPDATE / DELETE ...
  ENDMETHOD.

ENDCLASS.
```
