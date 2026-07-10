# AGENTS.md

Operational guide for agents working on **abap2UI5 Samples**. It complements
`CLAUDE.md` (which owns the ABAP code style and app-structure rules) and focuses
on the two things that are easy to get wrong: **which folder a sample belongs
to**, and **keeping the launchpad apps in sync with the folder tree**.

Everything in this repo is **English only** (code, comments, commits, PRs).

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

> Class names never encode the folder. Moving a sample between packages needs
> **no rename** and keeps navigation intact — but the launchpad catalog must be
> updated (§4).

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
| `z2ui5_cl_sample_000`    | `src/01` | `abap2UI5 - Samples`             | `src/01/**` | "Extended Samples" → `sample_001` |
| `z2ui5_cl_sample_001`    | `src/00` | `abap2UI5 - Samples (restricted)`| `src/00/**` | "Basic Samples" → `sample_000` |

Both are identical in shape: a `get_catalog( )` method returning a flat table of
tiles, and a `view_display( )` that loops the catalog, emitting an H3 section
title whenever the `group` changes and one link (`header` + optional `sub`) per
tile. Navigation is by class name: the tile press event is the `app` value,
`on_event` does `to_upper( )` → `CREATE OBJECT TYPE (classname)` →
`nav_app_call( )`. A `class_exists( )` guard keeps the view from breaking on a
missing class — but that is a safety net, **not** a substitute for keeping the
catalog correct.

`z2ui5_cl_demo_app_000` is the old "classic" launchpad (now under `00/99`,
obsolete); `sample_000` links to it via a message strip. Do not extend it.

---

## 4. The launchpad is ALWAYS (re)generated — schema & rules

**Treat the two `get_catalog( )` tables as a generated mirror of the folder
tree, never as free-form data.** Whenever you add, remove, or move a sample —
or move a whole subpackage between `src/00` and `src/01` — you **must**
regenerate the affected catalog(s) in the same change.

### Tile schema

One row per app, all four fields always present:

```abap
( group = `<subpackage CTEXT>` header = `<display title>` sub = `<short description>` app = `<class name, lowercase>` )
```

| Field    | Meaning / rule |
|----------|----------------|
| `group`  | **Exactly** the CTEXT of the subpackage the app physically lives in. Becomes the H3 section title (rendered once, when the group changes). |
| `header` | Link text shown to the user (a friendly name, or the class name itself for un-triaged apps). |
| `sub`    | Short description shown next to the link. May be empty (`` `` ``) → then only the link is rendered. |
| `app`    | The app's class name in **lowercase** (folder-independent). Drives navigation. |

### Generation rules

1. **One catalog per area.** Apps in `src/01/**` belong in `sample_000`; apps in
   `src/00/**` belong in `sample_001`. Never list an app in the wrong launchpad.
2. **Each app appears exactly once.**
3. **`group` == subpackage CTEXT.** If you rename a subpackage's CTEXT, update
   every tile's `group` to match.
4. **Group blocks follow folder order.** Emit groups in ascending folder number
   (`00/01` → `00/11` → `00/99`; `01/01` → `01/08`) so the on-screen order
   mirrors the tree. When inserting a new group, place it at its numeric slot
   (e.g. `uncategorized` = `00/11` goes **after** `only non-openui5-with-cc`
   (`00/10`) and **before** `obsolete` (`00/99`)).
4b. **Within a group, sort tiles alphabetically by the description text
   (`sub`)**, case-insensitively. The `sub` field is the sort key — not
   `header` and not `app`. (Empty `sub` values therefore sort first.) The group
   order from rule 4 is untouched; only the tiles inside each group are ordered.
5. **Moving a subpackage = moving its whole tile group** between the two
   catalogs, inserted at the correct numeric slot (see the uncategorized move:
   `src/01/07` → `src/00/11` meant lifting the entire `uncategorized` group out
   of `sample_000` and into `sample_001`).
6. After every change: `get_catalog( )` and the folder tree must agree — same
   apps, same group names, same grouping.

### Formatting

Keep the `VALUE #( ... )` literal one tile per line, aligned as in the existing
catalog. Follow all `CLAUDE.md` ABAP rules (backticks, 2-space indent, LF, final
newline). **Run `abaplint` — 0 issues — before committing.**

---

## 5. Checklists

**Adding a sample**
1. Create the class; place it in the correct folder per §2.
2. Add one tile to the matching launchpad catalog (§4), in the right group and
   numeric position.
3. `abaplint` → 0 issues → commit (English message).

**Moving a sample / subpackage**
1. `git mv` the files (no rename needed — `FOLDER_LOGIC=PREFIX`).
2. Update the catalog(s): change the tile's `group`, and if it crossed between
   `src/00` and `src/01`, move the tile to the other launchpad.
3. `abaplint` → 0 issues → commit.

**Before every commit**
- `abaplint` reports 0 issues (config `abaplint.jsonc`).
- abapGit file format for all file types: UTF-8, LF only, final newline,
  2-space indent.
- Launchpad catalogs still mirror the folder tree.
