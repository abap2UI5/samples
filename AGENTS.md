# AGENTS.md

Single source of truth for agents working on **abap2UI5 Samples** — a collection
of demo apps for the abap2UI5 framework. This file owns everything: the folder
scheme, the compatibility model, the launchpad generation rules, **and** the
ABAP code style / app-structure conventions.

> These instructions OVERRIDE any default behavior and must be followed exactly.

## Language

**This entire project is in English.** All code, comments, commit messages, PR
titles, PR descriptions, and any other text must be written in English.

---

## 1. Repository layout

All samples live under `src/`, split into exactly two top-level packages
(abapGit `FOLDER_LOGIC=PREFIX`, `STARTING_FOLDER=/src/`). There are **no demo
apps directly in `src/` root** — every sample sits in a categorised subpackage.

```
src/
├── 01/  "basic"     cloud-ready & downportable — survives every build
│   ├── 01/  framework
│   ├── 02/  framework with action
│   ├── 03/  framework popups
│   ├── 04/  controls with action
│   ├── 05/  controls with cc
│   └── 08/  controls
└── 00/  "extended"  restricted / special-purpose — STRIPPED from cloud & 702 builds
    ├── 01/  only non-abap-cloud          on-premise-only ABAP (not ABAP Cloud ready)
    ├── 02/  only non-openui5             SAPUI5-only controls (sap.suite.*, sap.ui.comp.*, VizFrame, …)
    ├── 03/  only with launchpad          runs only inside the Fiori Launchpad
    ├── 04/  only higher UI5 1.71         uses a control/property introduced after UI5 1.71
    ├── 05/  only with javascript and css and html   needs native JS / CSS / HTML
    ├── 06/  only testing                 test / scaffolding apps, not demos
    ├── 07/  experimental                 work-in-progress / not finished
    ├── 08/  demos                        complete showcase apps (multi-feature)
    ├── 09/  generic xml view             built on z2ui5_cl_util_xml
    ├── 10/  only non-openui5-with-cc     SAPUI5-only control that also needs a custom control
    ├── 11/  uncategorized                not yet triaged into a category
    └── 99/  obsolete                     superseded, or uses a deprecated control
```

Each subpackage's `package.devc.xml` `<CTEXT>` is the human-readable name shown
above (e.g. `only non-abap-cloud`). **That CTEXT string is also the launchpad
group name — keep the two identical** (see §4).

> Class names never encode the folder (`FOLDER_LOGIC=PREFIX`). Moving a sample
> between packages needs **no rename** and keeps navigation intact — but the
> launchpad catalog must be updated (§4).

---

## 2. Compatibility model — what belongs in `src/01` vs `src/00`

The split is driven directly by the CI builds:

| Build (workflow)   | What it does                                    | Sees `src/01` | Sees `src/00` |
|--------------------|-------------------------------------------------|:---:|:---:|
| `ABAP_STANDARD`    | `abaplint ./abaplint.jsonc` (syntax `v750`)     | ✅ | ✅ |
| `ABAP_CLOUD`       | `rm -r src/00` → `abaplint abap_cloud.jsonc`    | ✅ | ❌ |
| `ABAP_702`         | branch `702` → `rm -rf src/00` → `npm run downport` → `abaplint abap_702.jsonc` | ✅ | ❌ |

**Consequence of the rule:**

- **`src/01` ("basic")** — a sample may only live here if it is **ABAP Cloud
  ready AND downportable to 7.02** and runs on plain OpenUI5 1.71 without any
  restriction. These survive all three builds.
- **`src/00` ("extended")** — anything with *any* restriction. It is deleted
  before the cloud and 702 builds, so it is only ever checked by
  `ABAP_STANDARD`. Pick the subpackage by the **first** restriction that
  applies:

  1. Needs on-premise-only ABAP (not Cloud) → `00/01`
  2. Uses SAPUI5-only controls → `00/02` (and if it *also* needs a custom control → `00/10`)
  3. Runs only inside the Launchpad → `00/03`
  4. Uses a control/property introduced after UI5 1.71 → `00/04`
  5. Needs native JavaScript / CSS / HTML → `00/05`
  6. Test / scaffolding app → `00/06`
  7. Experimental / work-in-progress → `00/07`
  8. Complete multi-feature showcase demo → `00/08`
  9. Built on the generic XML view (`z2ui5_cl_util_xml`) → `00/09`
  10. Deprecated control/property, or superseded → `00/99`
  11. Not yet triaged → `00/11` (temporary parking; triage into 01–99 later)

A sample qualifies for `src/01` **only if none** of the above restrictions
apply: OpenUI5-compatible, ABAP-Cloud-ready, standalone, every control **and**
property available since UI5 1.71 (16 Jan 2020) **and** not deprecated, no native
JS, not a test, finished and clean. "Old" is not enough (deprecated → `00/99`);
"non-deprecated" is not enough (post-1.71 → `00/04`).

---

## 3. The two launchpad apps

There is **one launchpad per top-level package**, and they cross-link:

| App class                | Lives in | Title                            | Mirrors     | Button → other |
|--------------------------|----------|----------------------------------|-------------|----------------|
| `z2ui5_cl_sample_app_000`| `src/01` | `abap2UI5 - Samples`             | `src/01/**` | "Extended Samples" → `sample_app_001` |
| `z2ui5_cl_sample_app_001`| `src/00` | `abap2UI5 - Samples (restricted)`| `src/00/**` | "Basic Samples" → `sample_app_000` |

Both are identical in shape: a `get_catalog( )` method returning a flat table of
tiles, and a `view_display( )` that loops the catalog, emitting an H3 section
title whenever the `group` changes and one link (`header` + optional `sub`) per
tile. Navigation is by class name: the tile press event is the `app` value,
`on_event` does `to_upper( )` → `CREATE OBJECT TYPE (classname)` →
`nav_app_call( )`. A `class_exists( )` guard keeps the view from breaking on a
missing class — but that is a safety net, **not** a substitute for keeping the
catalog correct.

Within a group, `view_display( )` also inserts a **blank line between blocks**:
consecutive tiles whose `header` shares the same base name form one block, and a
new block (first row gets `sapUiSmallMarginTop`) starts when the base changes.
The base is the header with a trailing Roman numeral removed (`header_base( )`),
so `Binding`, `Binding I` … `Binding VIII` render as one block, then a gap, then
the `Event` block, and so on.

`z2ui5_cl_demo_app_000` is the old "classic" launchpad (now under `00/99`,
obsolete); `sample_app_000` links to it via a message strip. Do not extend it.

---

## 4. The launchpad is ALWAYS (re)generated — schema & rules

**Treat the two `get_catalog( )` tables as a generated mirror of the folder
tree, never as free-form data.** Whenever you add, remove, or move a sample —
or move a whole subpackage between `src/00` and `src/01`, or change a class's
description — you **must** regenerate the affected catalog(s) in the same change.

### Regenerate with the generator

Do not hand-edit the catalogs. Run the generator, which scans the folders and
class descriptions and rewrites both `get_catalog( )` blocks:

```
npm run launchpad      # → node scripts/generate-launchpad.js
npx abaplint           # must report 0 issues
```

`scripts/generate-launchpad.js` implements every rule below. Edit the script (not
the generated ABAP) if a rule changes.

### Tile schema

One row per app, all four fields always present:

```abap
( group = `<subpackage CTEXT>` header = `<display title>` sub = `<short description>` app = `<class name, lowercase>` )
```

| Field    | Meaning / rule |
|----------|----------------|
| `group`  | **Exactly** the CTEXT of the subpackage the app physically lives in. Becomes the H3 section title (rendered once, when the group changes). |
| `header` | Link text shown to the user. **Derived from the class short text** (see below). |
| `sub`    | Short description shown next to the link. **Derived from the class short text** (see below). May be empty (`` `` ``) → then only the link is rendered. |
| `app`    | The app's class name in **lowercase** (folder-independent). Drives navigation. |

**`header` and `sub` come from the class, not from hand-written labels.** The
source of truth is the app class's abapGit short text `<DESCRIPT>` in its
`*.clas.xml`, written in the format `header - sub`:
- Split the DESCRIPT on the **first** `` ` - ` `` (space-hyphen-space): the part
  before is `header`, the part after is `sub` (which may itself contain ` - `).
- No ` - ` at all → `header` = the whole DESCRIPT, `sub` = empty.
- Unescape XML entities (`&amp;` → `&`, etc.) when copying into the ABAP literal.

When regenerating, **re-read every class's `<DESCRIPT>`** — the descriptions are
maintained on the classes and change there, so never carry `header`/`sub` over
from the old catalog.

### Generation rules

1. **One catalog per area.** Apps in `src/01/**` belong in `sample_app_000`; apps in
   `src/00/**` belong in `sample_app_001`. Never list an app in the wrong launchpad.
2. **Each app appears exactly once**, and every demo app physically present in an
   area is listed (no missing tiles) — **except hidden helper apps**: a class
   whose `<DESCRIPT>` header is `ZZZ` (e.g. `ZZZ - called by SubApp I`) is only
   ever called by another app and must **not** get a tile. It stays in the
   folder (and is checked by abaplint), just not shown in the launchpad.
3. **`group` == subpackage CTEXT.** If you rename a subpackage's CTEXT, update
   every tile's `group` to match. A tile's group must equal the CTEXT of the
   folder the class physically lives in — never a neighbouring category.
4. **Group blocks follow folder order.** Emit groups in ascending folder number
   (`00/01` → `00/11` → `00/99`; `01/01` → `01/08`) so the on-screen order
   mirrors the tree. When inserting a new group, place it at its numeric slot
   (e.g. `uncategorized` = `00/11` goes **after** `only non-openui5-with-cc`
   (`00/10`) and **before** `obsolete` (`00/99`)).
5. **Within a group, sort tiles alphabetically (case-insensitive) by `header`,
   then by `sub`.** Sorting by `header` first keeps numbered series together and
   in order (`Binding I`, `Binding II`, `Binding III`, … underneath each other;
   likewise `Popover I…IV`, `Popup I…III`). The group order from rule 4 is
   untouched; only the tiles inside each group are ordered.
6. **Moving a subpackage = moving its whole tile group** between the two
   catalogs, inserted at the correct numeric slot (e.g. the uncategorized move
   `src/01/07` → `src/00/11` lifted the entire `uncategorized` group out of
   `sample_app_000` and into `sample_app_001`).
7. After every change, verify: `get_catalog( )` and the folder tree agree —
   same apps, same group names (== CTEXT), same grouping, no app in the wrong
   launchpad, none missing. The safest way to regenerate is to rebuild each
   catalog straight from the physical tree (one tile per class, group = its
   folder CTEXT) and carry over the existing `header`/`sub` metadata.

### Formatting

Keep the `VALUE #( ... )` literal one tile per line, aligned as in the existing
catalog. Follow all ABAP rules in §7 (backticks, 2-space indent, LF, final
newline). **Run `abaplint` — 0 issues — before committing.**

---

## 5. Checklists

**Adding a sample**
1. Create the class; place it in the correct folder per §2.
2. Add one tile to the matching launchpad catalog (§4), in the right group and
   numeric position, sorted by `sub`.
3. `abaplint` → 0 issues → commit (English message).

**Moving a sample / subpackage**
1. `git mv` the files (no rename needed — `FOLDER_LOGIC=PREFIX`).
2. Update the catalog(s): change the tile's `group`, and if it crossed between
   `src/00` and `src/01`, move the tile to the other launchpad.
3. `abaplint` → 0 issues → commit.

**Before every commit**
- `abaplint` reports 0 issues (config `abaplint.jsonc`).
- abapGit file format for all file types: UTF-8, LF only, final newline,
  2-space indent (§6).
- Launchpad catalogs still mirror the folder tree (§4).

---

## 6. Rules

### abaplint

- **Run `abaplint` before every commit. It must report 0 issues.**
- Configuration: `abaplint.jsonc`
- Install: `npm install -g @abaplint/cli`
- Run: `abaplint`

### abapGit file consistency

All serialized files (`.abap`, `.xml`, and any other abapGit-managed file types)
must conform to the abapGit file format:
- **Encoding**: UTF-8 (with optional BOM: `xEF BB BF`)
- **Line endings**: LF (`x0A`) only — never CRLF
- **Final newline**: every file must end with a single newline character after the last line
- **Indentation**: 2 spaces — never tabs

**Always verify consistency for all file types before committing**, not just
`.abap` files. abaplint covers `.abap` files; for `.xml` and other files, check
manually or via editor tooling that the above rules are met.

---

## 7. Code Conventions

- Follow the [SAP ABAP Style Guide](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md).
- Never use an init flag attribute (`check_initialized`, `mv_init`, `is_initialized`, etc.). Always use `client->check_on_init( )` instead.
- Use backticks for all string literals, not single quotes.
- Use string templates (`|...|` with `{ }` for embedded expressions) instead of `&&` for string concatenation (e.g. `|item { name }|` not `` `item ` && name ``).
- Prefer functional to procedural language constructs — use `var = VALUE #( ).` to reset a variable, never `CLEAR var.`.
- Use type prefixes only for tables and structures: prefix table variables/attributes with `t_` (e.g. `t_items`) and structure variables/attributes with `s_` (e.g. `s_screen`). Do not add prefixes to scalar variables or object references.
- Name local types with a `ty_s_` prefix for structure types (e.g. `ty_s_row`) and `ty_t_` for table types (e.g. `ty_t_rows`). Only define a `ty_t_` table type when it is used more than once — for a single-use table, declare it inline with `STANDARD TABLE OF ty_s_xxx`.
- No blank line between a `TYPES` definition and the `DATA` declaration that directly uses it.
- Class names are always written in **lowercase** in both `DEFINITION` and `IMPLEMENTATION` — never uppercase.
- Classes are **not** `FINAL` — do not add the `FINAL` keyword to class definitions.
- Use `DEFINITION PUBLIC.` — never `DEFINITION PUBLIC CREATE PUBLIC.` (`CREATE PUBLIC` is the default and adds unnecessary overhead).
- Always include `PROTECTED SECTION.` and `PRIVATE SECTION.` in the class definition, even if empty.
- Keep `PRIVATE SECTION.` always empty — declare everything at `PROTECTED SECTION.` level at most.
- In every section (`PUBLIC SECTION.`, `PROTECTED SECTION.`), always follow this declaration order: `TYPES` first, then `DATA`, then `METHODS`.
- **Blank lines — class definition** (`EMPTY_LINES_IN_CLASS_DEFINITION`):
  - Add one blank line above each section keyword (`PUBLIC SECTION.`, `PROTECTED SECTION.`, `PRIVATE SECTION.`) — unless the preceding section is empty.
  - No blank line directly below a section keyword.
  - No blank line above `ENDCLASS.`.
  - Max 1 consecutive blank line inside the definition block.
  - Add one blank line between groups of different declaration types (e.g. between `INTERFACES` and `DATA`, or `DATA` and `METHODS`).
- **Blank lines — outside methods** (`EMPTY_LINES_OUTSIDE_METHODS`):
  - Exactly 2 blank lines between `ENDCLASS.` and the next `CLASS … IMPLEMENTATION.` (i.e. between the definition and the implementation block).
  - Exactly 2 blank lines between two `METHOD … ENDMETHOD.` blocks.
  - Exactly 2 blank lines between two top-level class blocks.
- **Blank lines — inside methods** (`EMPTY_LINES_WITHIN_METHODS`):
  - Always add exactly 1 blank line at the very start of a method body (after `METHOD`).
  - Always add exactly 1 blank line at the very end of a method body (before `ENDMETHOD`).
  - Max 1 consecutive blank line inside a method body.
  - Always add 1 blank line **before** an `IF` block — **except** when the method is a pure dispatcher (its only purpose is to jump to other methods, with no own logic before the `IF`). In that case, omit the blank line between the opening assignment and the `IF`.
  - Always add 1 blank line **before** `ELSEIF` and `ELSE`.
  - In setup methods (`on_init` and similar), add 1 blank line between the last data assignment and the first non-assignment statement (e.g. before `view_display( )`):
    ```abap
    METHOD on_init.

      price    = `1234`.
      currency = `EUR`.

      view_display( ).

    ENDMETHOD.
    ```
  - If a branch (`IF`, `ELSEIF`, `ELSE`) contains **more than one statement**, add 1 blank line directly after the condition line as well:
    ```abap
    me->client = client.

    IF client->check_on_init( ).

      product  = `products`.
      quantity = `500`.
      view_display( ).

    ELSEIF client->check_on_event( `SAVE` ).
      data_update( ).
    ENDIF.
    ```
- Always run `abaplint` after every change. It must report 0 issues before committing.
- Before starting app development, read all active rules in `abaplint.jsonc` and follow them throughout.

---

## 8. Framework Reference

For deeper information about how the abap2UI5 framework works internally —
architecture, roundtrip processing, data binding engine, session persistence,
and core classes — refer to the
[abap2UI5 repository](https://github.com/abap2UI5/abap2UI5) and its `CLAUDE.md`.

---

## 9. How Apps Work

Every abap2UI5 app implements `z2ui5_if_app` with a single `main()` method. The framework calls `main()` on every roundtrip (HTTP POST). Use the lifecycle checks to react to different situations:

- `client->check_on_init( )` — true on the very first call
- `client->check_on_navigated( )` — true when returning from a sub-app or popup — re-display the view here (see below)
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

### Returning from a sub-app — always re-display the view

When a called sub-app takes over the screen with its own `view_display( )` and later returns via `nav_app_leave( )`, the browser still shows the sub-app's view — the framework does not restore the previous view automatically. All class attributes survive the roundtrip serialization, so there is nothing to re-read: simply call `view_display( )` again in the `check_on_navigated( )` branch. Do **not** call `data_read( )` or similar there.

```abap
IF client->check_on_init( ).
  data_read( ).
  view_display( ).
ELSEIF client->check_on_navigated( ).
  view_display( ).
ELSEIF client->check_on_event( `SAVE` ).
  data_update( ).
ENDIF.
```

Calling `view_display( )` in the `check_on_navigated( )` branch is **always safe** — even after a popup, where the main view stayed on screen, it simply re-renders the same view. Use it as the general rule. Only as an optional optimization, when the app returns exclusively from a popup (`z2ui5_cl_pop_*` / `popup_display`), a `client->view_model_update( )` is sufficient — never rely on it when a full-screen sub-app can be called.

### Event checking — inline vs. CASE

`check_on_event( )` accepts an optional event name argument. Use it to check for a specific event directly in the `ELSEIF` chain when there are **2–3 events** and no complex dispatch logic is needed:

```abap
IF client->check_on_init( ).
  ...
ELSEIF client->check_on_event( `SAVE` ).
  data_update( ).
ELSEIF client->check_on_event( `DELETE` ).
  data_delete( ).
ENDIF.
```

Use a `CASE` statement (inside an `ELSEIF client->check_on_event( )` block) only when there are **4 or more events**, or when a dedicated `on_event` method is extracted for a larger app.

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

### Navigation

**Back Navigation** — always use `client->_event_nav_app_leave()` to bind the back button event directly in the view. This triggers navigation without a roundtrip to the ABAP backend:

```abap
METHOD view_display.

  DATA(view) = z2ui5_cl_xml_view=>factory( ).
  DATA(page) = view->shell(
      )->page(
          title          = `My App`
          shownavbutton  = client->check_app_prev_stack( )
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
      CAST z2ui5_cl_app_parent( client->get_app_prev( ) )->set_result( s_result ).
      client->nav_app_leave( ).
  ENDCASE.

ENDMETHOD.
```

---

## 10. Building Views

Views are XML strings passed to `client->view_display()`. There are two ways to build them:

### 1. `z2ui5_cl_xml_view` — typed fluent API
Pre-built methods for common UI5 controls (`shell`, `page`, `simple_form`, `input`, `button`, etc.). Use this for standard layouts.

#### View structure and indentation

Always add 1 blank line before `DATA(view) = z2ui5_cl_xml_view=>factory( ).` to visually separate view construction from preceding logic.

Always build the view in `view_display` and call `client->view_display( view->stringify( ) )` as a **standalone statement at the end** — never nested inside the chain.

Indent the fluent chain to reflect the XML hierarchy:
- Each method that **navigates into a child element** (returns a child node) is indented **4 spaces deeper** than its parent call.
- Methods that **add a sibling** within the same container (and return the container) stay at the **same indentation level**.

#### Parameter formatting

- **Single parameter**: write inline — `)->label( `Quantity` )` or `)->input( client->_bind_edit( qty ) )`.
- **More than one parameter**: always split across multiple lines — one parameter per line, aligned below the opening `(`, closing `)` on its own line:

```abap
)->input(
    value   = product
    enabled = abap_false
)->button(
    text  = `Post`
    press = client->_event( `POST` ) ).
```

Never put two or more named parameters on the same line.

```abap
METHOD view_display.

  DATA(view) = z2ui5_cl_xml_view=>factory( ).
  view->shell(
      )->page(
          title          = `My App`
          navbuttonpress = client->_event_nav_app_leave( )
          shownavbutton  = client->check_app_prev_stack( )
          )->simple_form(
              title    = `Form Title`
              editable = abap_true
              )->content( `form`
              )->label( `Quantity`
              )->input( client->_bind_edit( quantity )
              )->label( `Product`
              )->input(
                  value   = product
                  enabled = abap_false
              )->button(
                  text  = `Post`
                  press = client->_event( `POST` ) ).
  client->view_display( view->stringify( ) ).

ENDMETHOD.
```

The hierarchy above is: `shell` → `page` → `simple_form` → `content` → (leaf elements).
`label`, `input`, `button` are siblings inside `content`, so they stay at the same indent level as `)->content(`.

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

#### Method chaining

Each call in a chain must start on its own line — never place two `->_()` / `->__()` calls on the same line:

```abap
" Wrong
DATA(page) = root->__( `Shell` )->__( n = `Page`

" Correct
DATA(page) = root->__( `Shell`
   )->__( n = `Page`
```

Chain continuations (`)->`) are indented 3 spaces relative to the statement's base indentation.

#### Parameter alignment

When `p` appears on a continuation line, align it directly under `n` — one space after the opening `(`:

```abap
" Wrong — p is one space too far right
)->_( n = `Input`
              p = VALUE #( ... ) ).

" Correct — p directly under n
)->_( n = `Input`
             p = VALUE #( ... ) ).
```

Continuation lines inside `VALUE #( )` align with the first tuple `(`:

```abap
)->_( n = `Input`
      p = VALUE #( ( n = `type`  v = `Number` )
                   ( n = `value` v = client->_bind_edit( qty ) ) ) ).
```

#### VALUE #( ) formatting

In `VALUE #( )` constructor expressions with named fields, use **either** entirely inline (all fields on one line) **or** each field on its own line — never mix both styles in the same expression:

```abap
" Wrong — mixed
t_products = VALUE #(
  ( name = `Notebook Basic 15`  product_id = `HT-1000` supplier_name = `Very Best Screens`
    dimensions = `30 x 18 x 3 cm` weight_measure = `4.2` weight_unit = `KG` ) ).

" Correct — one field per line, = signs aligned
t_products = VALUE #(
  ( name           = `Notebook Basic 15`
    product_id     = `HT-1000`
    supplier_name  = `Very Best Screens`
    dimensions     = `30 x 18 x 3 cm`
    weight_measure = `4.2`
    weight_unit    = `KG` ) ).
```

---

## 11. App Structure

### Simple apps (< 50 lines in `main`)

Write everything directly in `main` — no method encapsulation needed. Count only the lines inside the `main` method, not the total class length.

**Do not extract `view_display` or any other helper method just because the app has a view.** A separate `view_display` method is only justified when the app is large enough to warrant the full canonical structure (≥ 50 lines in `main`). Extracting it in a simple app adds unnecessary indirection.

### Larger apps — canonical template

When the logic no longer fits inside `main`, always extract exactly `on_init` and `on_event` as the first step — never use other method names for this purpose. `main` then becomes a pure dispatcher that calls these two methods. Only add further methods (`view_display`, `data_read`, etc.) when they are actually needed.

In the `check_on_navigated( )` branch the dispatcher calls `view_display( )` directly — the app state survived the serialization, only the view must be re-displayed. Extract a dedicated `on_navigation` method only when the app additionally needs to process results from the called sub-app (via `get_app_prev( )`) before re-displaying.

**Never create a pass-through method with only one statement.** If an extracted method (e.g. `on_init`) would contain only a single call, replace the method call in the dispatcher with that single call directly — and omit the pass-through method entirely. For example, if `on_init` would only call `view_display( )`, write `view_display( )` directly in the `IF client->check_on_init( ).` branch instead.

### Event handler sub-methods

When the body of a single `WHEN` branch in `on_event` grows too long, extract it into a dedicated method named `on_event_<event>` (e.g. `on_event_save`, `on_event_delete`). The `on_event` method then stays a thin dispatcher — one call per branch — and all the logic lives in the sub-method.

The following is the **maximum structure**. Only add methods that are actually needed.

```abap
CLASS z2ui5_cl_app_xxx DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    " bound data (DATA attributes for _bind/_bind_edit)...
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.        " first call: load data, display view
    METHODS on_event.       " user triggered an event
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
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    data_read( ).
    view_display( ).

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
