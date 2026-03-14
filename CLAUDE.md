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
- Class names are always written in **lowercase** in both `DEFINITION` and `IMPLEMENTATION` — never uppercase.
- Classes are **not** `FINAL` — do not add the `FINAL` keyword to class definitions.
- Always include `PROTECTED SECTION.` and `PRIVATE SECTION.` in the class definition, even if empty.
- **Blank lines — class definition** (`EMPTY_LINES_IN_CLASS_DEFINITION`):
  - Add one blank line above each section keyword (`PUBLIC SECTION.`, `PROTECTED SECTION.`, `PRIVATE SECTION.`) — unless the preceding section is empty.
  - No blank line directly below a section keyword.
  - No blank line above `ENDCLASS.`.
  - Max 1 consecutive blank line inside the definition block.
  - Add one blank line between groups of different declaration types (e.g. between `INTERFACES` and `DATA`, or `DATA` and `METHODS`).
- **Blank lines — outside methods** (`EMPTY_LINES_OUTSIDE_METHODS`):
  - Exactly 1 blank line between `ENDCLASS.` and the next `CLASS … IMPLEMENTATION.` (i.e. between the definition and the implementation block).
  - Exactly 1 blank line between two `METHOD … ENDMETHOD.` blocks.
  - Exactly 2 blank lines between two top-level class blocks.
- **Blank lines — inside methods** (`EMPTY_LINES_WITHIN_METHODS`):
  - Max 1 consecutive blank line inside a method body.
  - At most 1 blank line at the very start of a method body (after `METHOD`).
  - At most 1 blank line at the very end of a method body (before `ENDMETHOD`).
  - One blank line above the first executable statement is allowed.
- Always run `abaplint` after every change. It must report 0 issues before committing.
- Before starting app development, read all active rules in `abaplint.jsonc` and follow them throughout.

## Framework Reference

For deeper information about how the abap2UI5 framework works internally — architecture, roundtrip processing, data binding engine, session persistence, and core classes — refer to the [abap2UI5 repository](https://github.com/abap2UI5/abap2UI5) and its `CLAUDE.md`.

## How Apps Work

Every abap2UI5 app implements `z2ui5_if_app` with a single `main()` method. The framework calls `main()` on every roundtrip (HTTP POST). Use the lifecycle checks to react to different situations:

- `client->check_on_init( )` — true on the very first call
- `client->check_on_navigated( )` — true when returning from a sub-app or popup
- `client->check_on_event( )` — true when a user triggered an event

Always use `ELSEIF` to chain these checks — never separate `IF` blocks:
```abap
IF client->check_on_init( ).
  ...
ELSEIF client->check_on_navigated( ).
  ...
ELSEIF client->check_on_event( ).
  ...
ENDIF.
```

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

## Navigation

### Back Navigation

Always use `client->_event_nav_app_leave()` to bind the back button event directly in the view. This triggers navigation without a roundtrip to the ABAP backend:

```abap
METHOD view_display.
  DATA(view) = z2ui5_cl_xml_view=>factory( ).
  DATA(page) = view->page( title = `My App`
                            shownavbutton = client->check_app_prev_stack( )
                            navbuttonpress = client->_event_nav_app_leave( ) ).
  " ...
  client->view_display( view->stringify( ) ).
ENDMETHOD.
```

Only use the manual pattern (handling `BACK` in `on_event`) when you need to do something with the app or client instance **before** navigating back — for example, writing data back to the previous app:

```abap
METHOD on_event.
  CASE client->get( )-event.
    WHEN `BACK`.
      " interact with previous app instance first
      CAST z2ui5_cl_app_parent( client->get_app_prev( ) )->set_result( ms_result ).
      client->nav_app_leave( ).
  ENDCASE.
ENDMETHOD.
```

## Building Views

Views are XML strings passed to `client->view_display()`. There are two ways to build them:

### 1. `z2ui5_cl_xml_view` — typed fluent API
Pre-built methods for common UI5 controls (`shell`, `page`, `simple_form`, `input`, `button`, etc.). Use this for standard layouts.

### 2. `z2ui5_cl_util_xml` — generic XML builder
Builds any XML structure directly from element names, namespaces and attributes. **Look up the control in the [UI5 API Reference](https://ui5.sap.com/#/api) and translate 1:1 to ABAP** — no wrapper, no abstraction layer.

**UI5 XML:**
```xml
<form:SimpleForm title="T" editable="true">
  <form:content>
    <Label text="qty"/>
    <Input value="{...}"/>
  </form:content>
</form:SimpleForm>
```

**ABAP:**
```abap
->_( n = `SimpleForm` ns = `form` p = VALUE #(
        ( n = `title`    v = `T` )
        ( n = `editable` v = abap_true ) )
)->_( n = `content` ns = `form`
)->__( n = `Label` a = `text` v = `qty`
)->__( n = `Input` a = `value` v = client->_bind_edit( qty ) )
```

Key rules for `z2ui5_cl_util_xml`:
- `_( n, ns, p )` — add child element, navigate **into** it
- `__( n, ns, a, v, p )` — add child element, **stay** at current level
- `p( n, v )` — add a single attribute to current element
- Single attribute: use `a = ... v = ...` parameters directly
- Multiple attributes: use `p = VALUE #( ( n = ... v = ... ) ... )`
- Namespace declarations go on the root `mvc:View` element as regular attributes (`xmlns:form`, etc.)
- Only declare namespaces that are actually used in the view
- `stringify()` on the factory root produces the complete XML string

## App Structure

### Simple apps (< 50 lines in `main`)

Write everything directly in `main` — no method encapsulation needed. Count only the lines inside the `main` method, not the total class length.

### Larger apps — canonical template

The following is the **maximum structure**. Only add methods that are actually needed.

### Event handler sub-methods

When the body of a single `WHEN` branch in `on_event` grows too long, extract it into a dedicated method named `on_event_<event>` (e.g. `on_event_save`, `on_event_delete`). The `on_event` method then stays a thin dispatcher — one call per branch — and all the logic lives in the sub-method.

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
        on_event_save( ).
      WHEN `BACK`.
        client->nav_app_leave( ).
    ENDCASE.
  ENDMETHOD.
  METHOD on_event_save.
    data_update( ).
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
