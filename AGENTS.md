# AGENTS.md

Single source of truth for agents working on **abap2UI5 Samples** — a collection
of demo apps for the abap2UI5 framework. This file owns everything: the folder
scheme, the compatibility model, the overview generation rules, **and** the
ABAP code style / app-structure conventions.

> These instructions OVERRIDE any default behavior and must be followed exactly.

## Language

**This entire project is in English.** All code, comments, commit messages, PR
titles, PR descriptions, and any other text must be written in English.

## Pull requests

- **The PR title becomes the squash-merge commit subject — make it describe
  the change.** Before merging, replace any auto-generated title (e.g. a
  branch name like `Claude/...-abc123`) with a short descriptive English
  title that states what actually changed.
- **One topic per PR.** A structural change (moving, adding, or renaming
  subpackages) must not ride along in a PR titled for an unrelated sample —
  split it into its own PR so the history stays searchable.

---

## 1. Repository layout

Everything lives under `src/`, split into two top-level packages
(abapGit `FOLDER_LOGIC=PREFIX`, `STARTING_FOLDER=/src/`). `01` "samples" holds
the portable samples directly; `00` is the system package — shared code plus
every sample that carries a restriction. There
are **no demo apps directly in `src/` root** — every sample sits in a
categorised subpackage. The only class in the root package is
`z2ui5_cl_smp_app_000`, the overview app (§3), which is an index, not a sample.

```
src/
├── 00/  "system"     not a sample category — the samples held back by maturity or purpose — STRIPPED WHOLE from the 702 build
│   ├── 97/  "experimental"   work-in-progress / not finished
│   └── 98/  "testing"        test / scaffolding apps, not demos
└── 01/  "samples"     cloud-ready & downportable — the sample catalog: bindings, events, popups, framework actions, custom controls and use cases — survives every build
```

The former wrapper level (`01` "basic" holding a single subpackage `01/01`
"Basic") was flattened on 2026-08-12: the samples now live directly in
`src/01`, and the overview app moved from `src/01` into the `src/` root
package.

### The restricted and obsolete packages are gone

**`src/00/02` ("restricted - release/version") and `src/00/99` ("obsolet") were
removed on 2026-08-12**, `00/99` together with the samples it still held. Two
categories, not two policies: what made a sample restricted or obsolete is
unchanged, there is simply no package standing empty in the tree waiting for
the next one.

So a sample that plain OpenUI5 1.71 cannot run — a SAPUI5-only control
(`sap.suite.*`, `sap.ui.comp.*`, `sap.viz.*`, …), a control or property
introduced after UI5 1.71, or native JavaScript / CSS the sample would have to
ship — has **no home in this repository today**, and neither has a superseded
one. Do not park it in `src/01`: every sample there must survive the 702
downport (§2). Either it belongs in
[samples-stack](https://github.com/abap2UI5/samples-stack) or
[samples-controls](https://github.com/abap2UI5/samples-controls) (§2), or the
category has to come back. Re-creating one is a deliberate, self-contained
change: add the package, put it back into the tree above, into the §2 build
table, and into the `downport` strip list in `package.json` — all three in the
same commit, or the two checks below fail.

There is **no on-premise-only package**: `main` is installed on ABAP Cloud
systems as it is, so every sample in the repository must be ABAP Cloud ready.
A sample that needs on-premise-only ABAP does not belong in this repository.

This tree is machine-checked: `node scripts/check-agents-structure.mjs` compares
it against the actual `package.devc.xml` `<CTEXT>` values and fails on any
drift (runs in CI). **Whenever a subpackage is added, removed, or renamed,
update this tree in the same change.**

Each subpackage's `package.devc.xml` `<CTEXT>` is the quoted name shown above
(e.g. `experimental`). **That CTEXT string is also the overview group name —
keep the two identical** (see §4).

> Class names never encode the folder (`FOLDER_LOGIC=PREFIX`). Moving a sample
> between packages needs **no rename** and keeps navigation intact — but the
> overview catalog must be updated (§4).

### Sample numbers are per repository — the prefix is what qualifies them

`Z2UI5_CL_SMP_APP_<no>` is the name; `<no>` alone is not. **Numbers are handed
out inside this repository only**, and the three sample repositories reuse each
other's freely — `493` is `Z2UI5_CL_SMP_APP_493`, Hello World, here, and
`Z2UI5_CL_SMPS_APP_493`, a classic FilterBar with variant management, in
[samples-stack](https://github.com/abap2UI5/samples-stack). So are `489` and
`490`. There is no global number space and there was never going to be one:
each repository numbers from its own sequence, and coordinating three of them
would buy nothing a prefix does not already give.

What follows, in prose anywhere — this file, the README, a commit message, a
comment: **name a sample by its class, never by its number alone.**
`Z2UI5_CL_SMP_APP_143` and "sample 143" read the same to somebody who already
knows which repository they are in, and only the first one still reads
correctly to everybody else. The tables in a generated catalogue are exempt:
there the number is a link to the class file, which is the qualification.

### There is no Control Library package any more

**`01/03` "Control Library" is gone (2026-08-12), with all 32 of its samples.**
1:1 rebuilds of UI5 demo kit samples are collected in
[abap2UI5/samples-controls](https://github.com/abap2UI5/samples-controls) —
which rebuilds every official sample against its original view and gates each
port on that comparison — and keeping the same original rebuilt in both was
pure redundancy: 14 of the 32 were already ported there under the same demo kit
sample id, and 12 of the rest carried no sample id at all, only an entity URL,
so there was no original to be faithful to. The whole set was imported into
samples-controls' `todo/` for triage before the packages were removed here and
every imported class got its verdict the same day; that staging folder was
deleted with the closed triage, so the per-sample verdicts are in
samples-controls' **git history** (`todo/README.md` at commit `37e77b6`), not in
its tree.

**Do not re-create a Control Library package, and do not add a demo kit rebuild
to `src/01`.** A sample that rebuilds one specific demo kit original belongs in
samples-controls, full stop. What legitimately stays here is what cannot live
there, and it goes into the basic package (`src/01`) as an ordinary sample:

- a **1.71-safe** variant of a sample whose samples-controls port keeps
  post-1.71 members for 1:1 fidelity (declared `POST_171` there) — this
  repository is downported to 702, so the restriction matters here and does
  not there;
- a sample in samples-controls' **hold-out set** (`ui5/holdout.json`), which is
  deliberately never ported there because it measures its generator;
- a **free-style control demo** with no single demo kit original.

**These exceptions are the `Control Behaviour` category** (§4), and they are the
whole of it: today `Z2UI5_CL_SMP_APP_448` (expand a Panel by ID), `_078`
(MultiInput with tokens), `_449` (open the PDF viewer by ID), `_088` (switch a
NavContainer page by ID) and `_202` (a Wizard with steps) — four of them driving
a control from the backend rather than showing what the control is.

**The category was called `Control` until 2026-08-18**, which was the wrong
name for exactly this reason: it is the noun samples-controls owns, and a
reader who found a five-entry "Control" section in this repository's catalogue
had no way to tell it apart from the 300-entry control reference next door
except by reading all five. The entries were always legitimate; the heading
claimed a scope they never had. `Control Behaviour` says what they are and
keeps `control` as the search term. A new entry belongs here only if it passes
one of the three tests above — otherwise it is a demo kit rebuild and belongs
in samples-controls, full stop.

A sample with a restriction still goes to the matching `src/00` category
(`src/00/97` experimental, `src/00/98` when it is a test app) — that model is
unchanged.

---

## 2. Compatibility model — what belongs in `src/01` vs `src/00/97` vs `src/00/98`

`main` is the default branch and the only branch anyone commits to. It is
installed **both** on standard on-premise systems and on ABAP Cloud, so it is
checked against both releases on every pull request. `702` is the one derived
branch, generated from `main` by `publish-702`.

The split is driven directly by the CI builds:

| Build (workflow)   | What it does                                    | Sees `src/00/97` | Sees `src/00/98` | Sees `src/01` |
|--------------------|-------------------------------------------------|:---:|:---:|:---:|
| `abap-standard`    | `abaplint ./abaplint.jsonc` (syntax `v750`)     | ✅ | ✅ | ✅ |
| `abap-cloud`       | `abaplint abap_cloud.jsonc` (syntax `Cloud`)    | ✅ | ✅ | ✅ |
| `abap-702`         | `npm run downport` (does `rm -rf src/00`) → `abaplint abap_702.jsonc` | ❌ | ❌ | ✅ |

**Only the 702 build strips anything.** `main` is published as it is and runs on
both standard and ABAP Cloud systems, so `abap-standard` and `abap-cloud` lint
the *whole* tree — experimental and testing samples included — and all of it
passes. The ABAP restriction that used to justify a strip for cloud is gone with
the on-premise package (§1): what is left is restricted by maturity or by
purpose, never by ABAP release.

**Test and experimental samples never reach the 702 branch.** The downport
removes **`src/00` whole**, so the `702` branch carries only the portable set.
It used to remove the two subpackages one by one and leave
the parent behind as a package with no objects in it; once `00/01` was gone
there was nothing left for that hull to hold, and a package that ships empty
says the branch has a system area when it has none. Keep the path together in
the two places that name it — `package.json` `downport` and the build table
above. That is machine-checked: `node scripts/check-strip-lists.mjs` compares
both and fails if one names a different set, or a package that no longer
exists (runs in CI). `src/00` holds nothing but those two subpackages today:
**`src/00/01` "context" was removed on 2026-08-20** with
the two classes it held, `z2ui5_cl_smp_context` and `z2ui5_cx_smp_error`. What
they offered was generic RTTI, message and conversion helpers, and a sample
that reaches for one stops being a single readable snippet — the thing a
sample is for. Every caller now carries the few lines it actually used, so
`src/00` is samples only, and the whole tree outside `src/01` is stripped from
the 702 build.

**Stripped is not unchecked, and nothing is suppressed.** `abaplint.jsonc` has
no `noIssues` list: every package under `src/` is really linted, by
`abap-standard` and by `abap-cloud` alike. Do not introduce one to make a
sample pass — a path listed there stops being checked at all, silently.

The `abap-702` transformation also produces the derived branch `702`
(`publish-702`, on every push to `main`). There is no `cloud` branch: ABAP Cloud
systems install `main` itself, and `abap-cloud` is a check on the pull request,
not a publish step. The `702` branch carries the root `abaplint.jsonc` of `main`
unchanged — the release-specific configs stay under `.github/abaplint/` and are
passed to abaplint explicitly.
Copying `abap_702.jsonc` over the root config would make the abaplint **GitHub
App** lint the derived branch at syntax `v702`: the app resolves a dependency
from the installed repository's default branch and ignores the `branch` field,
so it would check the downported samples against the *un*-downported framework
in `abap2UI5/abap2UI5@main` and report every type declared there with
`WITH EMPTY KEY` as unknown. The 7.02 check itself is not lost — it runs in
`abap-702` on every pull request, and again in `publish-702` before the push.

**Consequence of the rule:**

- **`src/01` ("samples")** — a sample may only live here if it is **ABAP Cloud
  ready AND downportable to 7.02** and runs on plain OpenUI5 1.71 without any
  restriction. These survive all three builds.
- **`src/00/97` ("experimental")** and **`src/00/98` ("testing")** — a sample
  held back by its maturity or its purpose. Both are deleted before the 702
  build, so they are only ever checked by `abap-standard` and `abap-cloud`.
  Pick the subpackage by the **first** restriction that applies:

  1. Test / scaffolding app → `00/98`
  2. Experimental / work-in-progress → `00/97`

  **What is in `src/00` stays in `src/00` — `00/97` included.** Neither
  subpackage is a waiting room that samples graduate from: do not move a
  sample out of `00/97` (or `00/98`) into `src/01`, and do not propose it
  because the sample happens to lint clean against all three releases.
  Passing the builds is a precondition for living in this repository at
  all (§1), never on its own a reason to promote a sample. Only the
  maintainer decides that a sample changes package, and only by saying so
  (human decision 2026-08-12, on the routing and app-state samples in
  `00/97`).

  A sample restricted by **UI5** — a SAPUI5-only control (`sap.suite.*`,
  `sap.ui.comp.*`, `sap.viz.*`, `sap.ui.vk`/`vbm`, `sap.ndc`,
  `sap.ui.richtexteditor`, …), a control or property introduced after UI5 1.71,
  or a runtime it cannot ship (native JavaScript / CSS / HTML) — and one that is
  **superseded or deprecated** have no package here any more (§1). Neither may
  be filed under `00/97` or `00/98` to get it in: those two say *not finished
  yet* and *not a demo*, not *does not run*.

**A sample that needs something the system provides does not belong here at
all.** Those live in
[abap2UI5/samples-stack](https://github.com/abap2UI5/samples-stack), one package per
technology: an OData service, smart controls, a RAP business object, a stateful
session, an APC channel, the MIME repository, and the **Fiori Launchpad**
(`src/09` there — the demos that read startup parameters, set the shell title and
navigate cross-app, moved out of the restricted package on 2026-08-12).

A sample qualifies for `src/01` **only if none** of the above restrictions
apply: OpenUI5-compatible, ABAP-Cloud-ready, standalone, every control **and**
property available since UI5 1.71 (16 Jan 2020) **and** not deprecated, no native
JS, not a test, finished and clean. "Old" is not enough and "non-deprecated" is
not enough either — a deprecated control and a post-1.71 one both disqualify a
sample from `src/01`, and neither has a package to fall back on any more (§1).
ABAP Cloud readiness is not a sorting criterion at all — it is a precondition
for every sample in the repository (§1).

---

## 3. The overview app

`z2ui5_cl_smp_app_000` is the **overview app** — a generated index page that
lists every sample of the basic area. It is *not* a Fiori Launchpad app, despite
the name of the generator that writes it (`npm run launchpad`, §4). The demos
that run inside a real Fiori Launchpad are not in this repository at all — they
live in [abap2UI5/samples-stack](https://github.com/abap2UI5/samples-stack) under
`src/09` (§2).

| App class              | Lives in     | Title                | Mirrors     |
|------------------------|--------------|----------------------|-------------|
| `z2ui5_cl_smp_app_000` | `src/` root  | `abap2UI5 - Samples` | `src/01/**` |

**It is the only one.** `src/00` (the system package) has no overview app: its
samples are reachable by class name only, and the generator merely reports how
many tiles they would hold (§4). An extended overview app existed once
(`z2ui5_cl_sample_app_g01`, mirroring the restricted area, cross-linked with
this one); it was removed when the extended samples were reorganised. Should it
ever return, it comes back as a second `TARGETS` entry in
`scripts/generate-launchpad.mjs` and a second row above.

Its shape: a `get_catalog( )` method returning a flat table of tiles, and a
`view_display( )` that loops the catalog, emitting one link (`header` + optional
`sub`) per tile, followed by a `sap-icon://source-code` **`core:Icon`** that
opens **that sample's ABAP class on GitHub** (`source_url( )` over the tile's
`path`, wired client-side through `open_url( )` like the header buttons — a
`Button` carries no `href`). It is deliberately an icon and not a transparent
`Button`: a `Button` brings its own height (2rem even in compact density) and
would set the line height of every row, while the icon is as tall as the text
beside it — which is what keeps the list tight. Around that list it renders a
fixed frame: **two header rows** (below) and an empty `vbox( height = 4rem )`
after the last tile so the list does not end glued to the page bottom.

### The two header rows

The page carries no content header of its own — both rows are built by hand:

1. **`render_header( )`** puts a `Bar` into the page's `customHeader`, so the
   row can be split into a left and a right half:
   - `contentLeft` — the back button and the app title, i.e. what the stock
     header would render on its own. A `Page` renders either its own
     header or a custom one, so `title` / `navbuttonpress` / `shownavbutton`
     are gone from the `page( )` call and the back `Button`
     (`sap-icon://nav-back`, `visible = check_app_prev_stack( )`,
     `press = _event_nav_app_leave( )`) is built here.
   - `contentRight` — the three sample repositories of the abap2UI5 family,
     then a `ToolbarSeparator` (`header_separator( )`,
     `sapUiSmallMarginBegin sapUiSmallMarginEnd`), then the two entries that
     leave the system: documentation and GitHub. The separator is the point:
     the three open an app, the two open a site.
2. **`render_sub_header( )`** puts an `OverflowToolbar` into `subHeader` and
   holds the `SearchField` (`24rem`).

**There is no intro text on the page.** It used to be a `MessageStrip` above
the list — tile count, the source-code icon, the **Ctrl+F12** developer tools,
the `(A)` / `(C)` markers — which pushed the first samples off the screen; it
then moved behind an info icon in the header, and on 2026-08-13 it was dropped
altogether with that icon. The page explains itself through its tooltips.

### The shared overview header

Every abap2UI5 overview app renders the same **entries** — here
(`render_header( )` / `header_button( )`), in
[samples-controls](https://github.com/abap2UI5/samples-controls) and in
[samples-stack](https://github.com/abap2UI5/samples-stack). Six icons, always
in this order. `header_button( )` takes each entry's `name` and `descr`
separately: the tooltip is `<name> - <descr>`, and the name alone titles the
popover of an uninstalled repository. The names are the *italic* ones below.
There used to be a sixth entry in front, `sap-icon://home` for the framework's
start page (`z2ui5_cl_app_startup`) — dropped from all three overviews on
2026-08-13: they list samples, and the start page is not one.

| Icon | Target | Repository |
|------|--------|------------|
| `sap-icon://lightbulb` | `z2ui5_cl_smp_app_000` | abap2UI5/samples — *Samples* |
| `sap-icon://palette` | `z2ui5_cl_smpc_app_000` | abap2UI5/samples-controls — *Control Samples* |
| `sap-icon://database` | `z2ui5_cl_smps_app_000` | abap2UI5/samples-stack — *Stack Samples* |
| `sap-icon://learning-assistant` | — | <https://abap2UI5.org> |
| `sap-icon://globe` | — | the repository the app itself lives in |

The repository entries lead to an app **inside** the system, the last two lead
out of it, and every overview shows that split — this one by a
`ToolbarSeparator` between the groups in its header Bar's `contentRight`
(above), samples-controls and samples-stack by a `ToolbarSpacer`
(`width = 1rem`) between the groups in their single-row `headerContent`. The
GitHub entry is **not** `sap-icon://source-code`: in the shared header that
icon is reserved for the per-sample source links an overview renders in its
list.

**Here the entries are `core:Icon`s, not `Button`s** (`header_button( )`), and
the reason is the colour: an icon carries one (`color`), a `Button` on 1.71
does not — the coloured `sap.m.ButtonType` values (`Critical`, `Neutral`, …)
are 1.73+. There are **two states, active and inactive**, and nothing in
between:

| Entry | Colour | Press |
|-------|--------|-------|
| the overview app is on this system | default (active) | `cs_event-nav` into it |
| it is **not** on this system | default (active) | `cs_event-install` → `install_display( )` |
| documentation / GitHub (no `class`) | default (active) | opens the site |
| the app you are in (`here`) | `Neutral` (inactive) | none |

Grey therefore marks exactly one entry — the overview you are already in,
which is the only one with nowhere to go. A repository that is not installed
looks like any other: it *is* a destination, the press just explains what has
to happen first. The tooltip says so before the click does.

**A missing repository stays clickable.** Instead of dropping the user on
GitHub without a word, the press fires `cs_event-install` carrying the class,
the GitHub URL and the repository name; `install_display( )`
opens a `Popover` on the pressed icon — hence every repository icon carries
its class name as `id` — that says what is missing, that abapGit installs it,
and links to the repository. Only entries **without** a `class` (documentation,
GitHub) still open their site directly through `open_url( )`.

**All three overviews carry this header, layout included** (2026-08-13): the
`Bar` in the page's `customHeader`, back button and title on the left, the
five icons with their separator on the right, the two colour states and the
install popover. samples-controls builds it in
`scripts/generate-overview.mjs` (its overview class is generated — never edit
the class), samples-stack in `z2ui5_cl_smps_app_000`. All three build it with
`z2ui5_cl_ui5_view_builder`, which renders an empty attribute rather than
skipping it (`color=""` is no valid `IconColor`), so the optional ones are
added under an `IF`. What stays local to a repository is
what sits *around* the family entries — this one's `SearchField` sub-header,
samples-controls' filter toolbar, samples-stack's Regenerate Demo Data button
(first in its `contentRight`, before a separator). **A change to an icon, the
order, the colours or the press behaviour belongs in all three repositories in
the same change.**

Each repository is installed on its own, so every button decides for itself:
`class_installed( )` instantiates the target class, and

- **on this system** → the press is `cs_event-nav` with the class name as its
  event argument; `on_event` hands it to `app_call( )`, which navigates with
  `nav_app_call( )` — the back button returns to the overview.
- **not on this system** → the press opens that repository on GitHub, and the
  tooltip says why (`… - not installed, opens GitHub`). A `Button` carries no
  `href` and `cs_event-open_new_tab` is same-origin only, so the new tab comes
  from the `URLHELPER` `REDIRECT` frontend action (`open_url( )`) — client-side,
  inside the click handler, which is what keeps the popup blocker quiet.
- **the app you are in** (`here = abap_true`, the lightbulb here) → the button
  stays, disabled, tooltip `… - you are here`, so the row reads the same in
  every overview.

A repository that **renames** its overview app is installed under both names in
the wild for a while, so `header_button( )` takes an optional `class_old` and
falls back to it when the current name is not on the system —
`z2ui5_cl_smpc_app_overview` for samples-controls (renamed again 2026-08),
`z2ui5_cl_demo_app_g00` for this repository. Add the old name there when an
overview app is renamed; drop it again once the rename is old enough.

**Keep the three headers in sync.** A change to the order, the icons or the
behaviour belongs in all three repositories in the same change.

The search field filters the tile list: its `search` event (Enter, or the
clear button) fires `SEARCH`, which re-renders the view with `catalog_filter( )`
applied — a case-insensitive contains-match against each tile's `header`, `sub`,
`keywords` (never rendered, §4) and `app` class name — and then replays the
focus into the search field.

That focus wire is `focus_search( )`, a `set_focus` follow-up action with the
cursor at the end of what is already typed, and it runs on **every** display of
the page: the overview opens with the cursor in the filter, so the first key
you press searches, and after a filter roundtrip typing simply continues. On
the way back from a sample it is queued **before** `scroll_restore( )` —
focusing a control can scroll it into view, and the restored scroll position is
the one that must survive.
The info popover keeps naming the **total** tile count (the unfiltered
catalog), an empty filter result renders a `No sample matches the filter.` text
instead of tiles, and the filter value survives navigation into a sample and
back (it is a serialized public attribute).

An H3 section title is emitted whenever the `group` changes — but only when
there is more than one group to tell apart. `group_titles_needed( )` decides
that by comparing every tile's group against the first one; with the whole
catalog in a single package the heading would only repeat the page title, so it
is left out — and because nothing then separates the first block from the
header rows above it, that first block opens with the same `sapUiSmallMarginTop`
the other blocks carry. Keep that check free of table expressions (`t_catalog[ 1 ]`): the
702 downport hoists them out of their guarding condition, so an `IS NOT INITIAL`
guard around one does not survive the transformation.

Navigation is by class name: the tile press event is the `app` value, `on_event`
(after handling `SEARCH`, see above)
does `to_upper( )` → `CREATE OBJECT TYPE (classname)` → `nav_app_call( )`,
wrapped in a `TRY`/`CATCH cx_root` so a catalog entry whose class is missing
from the system does not dump — a safety net, **not** a substitute for keeping
the catalog correct. `on_event` also records the scroll position, which
`scroll_restore( )` replays via `follow_up_action( cs_event-scroll_to )` on
`check_on_navigated( )`, so returning from a sample lands where the user left.

Within a group, `view_display( )` also inserts a **blank line between blocks**:
consecutive tiles whose `header` shares the same base name form one block, and a
new block (first row gets `sapUiSmallMarginTop`) starts when the base changes.
The base comes from `block_base( )`: in the **controls section** (groups whose
CTEXT starts with `controls -`) it is the header's **first letter**, so a blank
line separates letter groups only (`Button`, `ButtonGroup` render together, then
a gap before `Carousel`); everywhere else it is the header with a trailing Roman
numeral removed (`header_base( )`), so `Binding`, `Binding I` … `Binding VIII`
render as one block, then a gap, then the `Event` block, and so on. All links of
a block share the same width — the estimated render width of the widest header in
the block plus roughly one space, precomputed by `block_widths( )` /
`header_width( )` — so the `sub` descriptions of a block line up exactly
underneath each other in one column, directly next to the links.

`z2ui5_cl_smp_app_000_0`, the old "classic" overview app, is gone with the
`00/99` package it was retired to (§1). Do not bring it back — `smp_app_000` is
the only overview app, and it is generated.

### `SAMPLES.md` — the same catalogue, readable on GitHub

Reaching the overview app costs an installed framework, an abapGit pull and an
HTTP handler. Before that, the repository is a flat folder of classes whose
names encode nothing, and the question a visitor arrives with — *is there a
sample for X?* — has no answer here. `src/00` is worse off: it has no overview
app at all, so its apps are reachable by class name only and nothing lists
the names.

[`SAMPLES.md`](SAMPLES.md) answers it. Every app, its description, its
`@keywords` (the app keeps them for its search box; on a page the reader *is*
the search box, so they are rendered), the `@docs` chapter that explains what
it demonstrates, and a link to the source. Written by
`scripts/generate-samples-md.mjs` from the **same scan** as the overview app —
`scripts/lib/scan-samples.mjs`, which is the single place that knows what counts
as a sample, where its title comes from and which classes are hidden helpers.
Two copies of that would drift silently: the app and the page would simply
disagree about what this repository contains, and nothing would fail.

Four things it shows that the app does not, on purpose:

| | Why |
|---|---|
| the `src/00` packages | they have no overview app (§3); listing them nowhere is how its 45 apps became invisible |
| the `ZZZ` helper apps | they must not get a tile — but a catalogue claiming to account for the tree has to say they exist |
| the `@keywords` | never rendered in the app (§4); here they are what `Ctrl+F` finds |
| the `@docs` link | the chapter that explains the pattern the sample demonstrates (§4) — the app has no room for it, and a page does |

The `702` branch carries its own: `npm run downport` strips `src/00` and
regenerates the file afterwards, so the copy on that branch
lists what that branch actually ships.

**Do not hand-edit it** — it is regenerated by `npm run launchpad` along with
the overview app and `catalogue.json` (below), and `publish-overview-apps`
checks and pushes the three together (§4).

**It has readers outside this repository, and they parse the ROWS.** Two of
them today:

| | |
|---|---|
| [mcp-server](https://github.com/abap2UI5/mcp-server) `lib/examples.mjs` | the `examples` MCP tool — an agent asking "has somebody already built X" |
| [docs](https://github.com/abap2UI5/docs) `scripts/link-samples.mjs` | the *Working Samples* block under a cookbook page |

Both read this file live rather than a generated index, so what they see is
always what it says — and both match a row with a regex. **Changing the shape
of a row breaks them silently.** Adding the `@docs` line as a second
`<br><sub>` block did exactly that: a parser expecting one small-type block
matched no rows at all, and the `examples` tool would have answered "no sample
for that" to every query — no error, no log, just an agent taking it at face
value and writing the app from scratch.

So a change to `row( )` in `generate-samples-md.mjs` is a change to their input.
Grep both repositories for the row regex before merging one, and give them a
fixture with the new shape.

### `catalogue.json` — the same catalogue, as data

The fourth view of the one catalogue, and the first one addressed to a
machine. The two readers above parse SAMPLES.md rows with a regex because
nothing better existed; an AI agent that has just cloned this repository was
in the same position. [`catalogue.json`](catalogue.json) at the repository
root is the structured answer: one entry per `src/01` sample — class, folder,
category, learning-path stage, keywords, `@summary`, `@docs` links — plus a
header naming the repository, its place in the three-repository family, and
the number-collision caveat (§1, "Sample numbers are per repository") encoded
as data rather than prose. Written by `scripts/generate-catalogue.mjs` from
the **same scan** as the other three views (`scripts/lib/scan-samples.mjs`)
and the same learning-path file as the overview page
(`scripts/lib/learning-path.json`), so it cannot disagree with any of them.

**It is committed, and `web/apps.json` is not — that is one decision, not
two.** Both are derived, and what differs is who reads them: `apps.json` is
the overview page's build output, and its reader always arrives through a
deploy that has just regenerated it, so a committed copy would only add a
derived diff to every sample pull request. `catalogue.json`'s reader is a
clone or a raw fetch, which no deploy ever runs for — a file that only exists
after a build step does not exist for them at all. What keeps the committed
copy honest is the freshness gate: `npm run check:catalogue` (in
`npm run check`) runs the generator with `--check` and fails when the file is
stale, and the `publish-overview-apps` workflow regenerates and pushes it
together with the overview app and SAMPLES.md.

**Do not hand-edit it** — `npm run launchpad` rewrites it (or
`npm run catalogue` for this file alone); change the facts on the classes, as
always (§4).

---

## 4. The overview is ALWAYS (re)generated — schema & rules

**Treat the `get_catalog( )` table as a generated mirror of the folder
tree, never as free-form data.** Whenever you add, remove, or move a sample —
or move a whole subpackage between `src/00` and `src/01`, or change a class's
description — regenerate the catalog in the same change.

The `publish-overview-apps` workflow regenerates the catalog on every pull
request. On a **same-repository** pull request it commits the result onto the
branch itself, so a stale catalog no longer blocks anyone — but read that
commit, it is a real change to what the overview offers (a class that stops
matching the sample naming scheme shows up there as a deleted tile). It can
only push where `GITHUB_TOKEN` reaches: on a pull request **from a fork**, and
on **`main`** (protected — `github-actions[bot]` can never be added to a
bypass list), the job instead fails with the command to run. So regenerating
yourself and committing the result with the change that made it stale is always
the safe route, and on those two paths it is the only one.

### Regenerate with the generator

Do not hand-edit the catalog. Run the generator, which scans the folders and
class descriptions, rewrites the `get_catalog( )` block and writes `SAMPLES.md`
(§3) from the same scan:

```
npm run launchpad      # → generate-launchpad.mjs && generate-samples-md.mjs
npx abaplint           # must report 0 issues
```

Both outputs come from `scripts/lib/scan-samples.mjs`, which implements every
rule below — that is the file to edit when a rule changes, never the generated
ABAP or markdown. The two generators only *render*: how a tile is written as an
ABAP literal (`generate-launchpad.mjs`, including the controls-section
truncation, which is about the overview not wrapping on a phone) and how it is
written as a table row (`generate-samples-md.mjs`).

### Tile schema

One row per app; `group`, `header`, `sub` and `app` are always present,
`keywords` only when the class carries the comment line:

```abap
( group = `<subpackage CTEXT>` header = `<display title>` sub = `<short description>` keywords = `<extra search terms>` path = `<folder>` app = `<class name, lowercase>` )
```

| Field    | Meaning / rule |
|----------|----------------|
| `group`  | **Exactly** the CTEXT of the subpackage the app physically lives in. Becomes the H3 section title (rendered once, when the group changes). |
| `header` | Link text shown to the user. **Derived from the class short text** (see below). |
| `sub`    | Short description shown next to the link. **Derived from the class short text** (see below). May be empty (`` `` ``) → then only the link is rendered. |
| `keywords` | **Never rendered — search only.** Extra terms so a sample is found by words that do not fit into the 60 characters of its DESCRIPT (see below). **Required on every tile** — `npm run launchpad` refuses an area's overview app if one of its tiles has no `@keywords` line. Three readers depend on them and all three fail the same silent way (the sample stays listed, stays correct, and never comes up): the overview app's search box, `Ctrl+F` on SAMPLES.md, and an agent asking whether a sample for X exists. ZZZ helpers are exempt — a helper is reached BY another sample, never looked up. |
| `path`   | The class's folder relative to the repository root (`src/01`). Generated, because the class name does **not** encode the folder — `source_url( )` builds the GitHub link of the sample from it. |
| `app`    | The app's class name in **lowercase** (folder-independent). Drives navigation. |

**`keywords` comes from a plain comment line on the class**, the first line of
the `*.clas.abap` (above an ABAP Doc block, if the class has one), lowercase and
space-separated:

```abap
" @keywords f4 search help suggestion input dialog select
CLASS z2ui5_cl_smp_app_009 DEFINITION PUBLIC.
```

It is a plain `"` comment on purpose — an unknown `"! @tag` is reported by the
extended check (SLIN/ATC). Put there what a newcomer would type but the visible
text cannot hold: **synonyms** (`f4` for value help, `alv` for the grid table),
**control names** the sample uses (`combobox`, `facetfilter`, `progressindicator`),
and the **abap2UI5 API** it demonstrates (`nav_app_call`, `binding_call`,
`control_by_id`). Four to eight terms, no backticks. The line is optional — a
sample without one is simply found by its header, sub and class name.

**`@summary` is the sentence under the title**, a second comment line directly
under `@keywords` — one sentence saying what the sample SHOWS:

```abap
" @keywords f4 search help suggestion input dialog select
" @summary The value help, both halves: suggestions while typing and the F4 dialog behind the field, over the same data.
CLASS z2ui5_cl_smp_app_009 DEFINITION PUBLIC.
```

The two lines answer the two halves of one question. `@keywords` decides
whether somebody *finds* the sample; `@summary` decides whether they can tell
it is the one they want — which a 60-character DESCRIPT cannot ("Popup -
change a popup control from the backend" names the thing and stops). It is
rendered in `SAMPLES.md` directly under the row title, in normal type:
everything else in the row is metadata, this is its content.

**Required on every tile, and required together**: `npm run launchpad`
refuses an overview app whose tile has no `@summary`, and refuses any sample
carrying one of the two lines without the other — including in `src/00/97`,
which has no tile but whose six samples are linked from the cookbook. ZZZ
helpers are exempt, as with `@keywords`.

**The gate is `npm run check:keywords`** (`scripts/check-keywords.mjs`, and the
`check-keywords` workflow on every pull request). The generator's refusal above
is not one: `npm run launchpad` *rewrites* the tree, so it is not something a
pull request or `npm run check` can call, and the one workflow that does run it
regenerates and pushes — a missing line surfaces there as a job that failed
after the catalogue was half rebuilt. The gate also holds three things the
generator never sees, because it only ever looked at what becomes a tile: that
the `@keywords` line is the **first** line of the file (one further down is one
a reader scrolls past and a scanner reading the head of a file misses), that
the terms are lowercase and at least three of them, and `src/00/97`, which has
no tile at all. **104 classes carried the two lines with nothing checking
them**; both sibling repositories gated theirs.

Who is held to it is decided from the tree, never from a list: every sample in
`src/01` and `src/00/97` plus the overview app itself; not the ZZZ helpers (a
helper is reached BY a sample, never looked up); not `src/00/98`, whose apps
are run by a check rather than learned from (§1). A list would need maintaining
and would rot; this cannot.

Write it, do not derive it. The sibling repositories can: `samples-controls`
**fetches** the demo kit's own sentence (`ui5/descriptions.json`) and
`samples-stack` derives half of its metadata from the package scheme. Here
there is no upstream to quote — these apps were written for this repository —
so the line is the author's, which is exactly why it needs a gate: nothing
else fails when it is missing. Say what the sample demonstrates and what it is
good for, not which controls it happens to contain.

**`@docs` is the way back to the documentation**, a third optional comment
line under `@summary`, holding one or more full URLs into
`https://abap2ui5.github.io/docs/`:

```abap
" @keywords f4 search help suggestion input dialog select
" @summary The value help, both halves: suggestions while typing and the F4 dialog behind the field, over the same data.
" @docs https://abap2ui5.github.io/docs/cookbook/expert_more/value_help
CLASS z2ui5_cl_smp_app_009 DEFINITION PUBLIC.
```

It is rendered in `SAMPLES.md` (never in the app — the tile has no room, and a
reader who is already inside the overview is not looking for a link out).
Full URLs rather than paths, because the line has to be useful where somebody
actually meets it: a search engine drops people into a class, and the code was
all they got.

**Do not add one by hand.** The pairing is declared on the documentation side —
a cookbook page lists its samples in frontmatter, and `scripts/link-samples.mjs`
in [abap2UI5/docs](https://github.com/abap2UI5/docs) generates the block of
sample links on the page *and* fails when a class it links to does not point
back. Adding a line here that no page declares makes that check red. Add the
page's `samples:` entry first; this line follows from it.

**The gate is `npm run check:docs-links`** (`scripts/check-docs-links.mjs`, and
the `check-docs-links` workflow on every pull request). It verifies both halves
of a line: that the **page exists** — `docs/<path>.md` in abap2UI5/docs, and
the `#anchor` when there is one — and that the **page names the class back** in
its `samples:` frontmatter.

That second half is the check quoted above, run from this side. It existed only
over there, which meant a pull request HERE could add a stale or invented link
and stay green until somebody regenerated the documentation; and the first half
existed nowhere at all. The scan refuses a URL that is not on the documentation
site, which catches a typo in the **host** and nothing whatsoever about the
path — and 97 classes carry one of these lines. Nothing fails when a page is
renamed: the class compiles, `SAMPLES.md` renders the link, and it 404s for
every reader who follows it.

It reads the documentation the way `check-app-rules` reads the shared rule set,
and degrades the same way: an **abap2UI5/docs checkout next to this one** first
(`$DOCS_HOME`, `.docs`, `../docs`) so a developer with the ecosystem cloned is
checked offline and in a second; otherwise `raw.githubusercontent.com`, one
request per page; otherwise it says so and passes. A gate must not go red
because github.com is unreachable, and must not claim to have verified what it
did not.

**`header` and `sub` come from the class, not from hand-written labels.** The
source of truth is the app class's abapGit short text `<DESCRIPT>` in its
`*.clas.xml`, written in the format `header - sub` — except for demo kit
rebuilds (§1), where the generator overrides `sub` with the full description
from the ABAP Doc lines below the `"! Rebuild of the UI5 demo kit sample:`
line:
- Split the DESCRIPT on the **first** `` ` - ` `` (space-hyphen-space): the part
  before is `header`, the part after is `sub` (which may itself contain ` - `).
- No ` - ` at all → `header` = the whole DESCRIPT, `sub` = empty.
- Unescape XML entities (`&amp;` → `&`, etc.) when copying into the ABAP literal.
- **Controls section only** (groups whose CTEXT starts with `controls -`): the
  generator drops the namespace prefix from `header` (`sap.m.Switch` → `Switch`
  — the group heading already names the namespace) and truncates `sub` to one
  line (`CONTROLS_SUB_MAX` characters, backed off to a word boundary, `+ " ..."`)
  so the overview never wraps.

When regenerating, **re-read every class's `<DESCRIPT>`** — the descriptions are
maintained on the classes and change there, so never carry `header`/`sub` over
from the old catalog.

### The `header` is the category — pick one from this list

With the whole catalog in a single package there is no group heading (§3), so
the `header` **is** the category a reader sees, repeated down the page as the
link text. It is also the cheapest search term: typing `popup` filters the
list to the popup samples. Keep the set small, and keep every entry a word a
newcomer would actually type:

| Header | What belongs in it |
|--------|--------------------|
| `Basics I` … `IV` | the entry point — first app, lifecycle, the minimum loop. The only numbered series: the Roman numeral orders them as a learning path (rule 5 sorts by `header`), and `header_base( )` still renders them as one block |
| `Binding` | `_bind( )`, binding syntax, UI5 model types, the model itself |
| `Browser` | the browser page and tab: URL, title, favicon, reload, clipboard, storage, logout |
| `Control Behaviour` | one UI5 control is the topic — how it *behaves* and how the backend drives it, typically by calling its methods by ID. **Not** a control reference: that is [samples-controls](https://github.com/abap2UI5/samples-controls), and the header says so (§1) |
| `CSS` | own styles shipped with the view |
| `Device` | camera, geolocation, device model, frontend info |
| `Event` | `_event( )`, `t_arg`, keyboard shortcuts, event defaults |
| `File` | upload and download |
| `Focus` / `Scroll` | cursor and scroll position |
| `Formatter` | the curated JS formatters abap2UI5 ships |
| `Grid Table` | `sap.ui.table.Table` — never `ui.Table` |
| `List` / `Table` / `Tree` | `sap.m.List` / `sap.m.Table` / `sap.m.Tree` |
| `Menu` / `Popover` / `Popup` | menus, popovers, dialogs |
| `Message` | MessageBox, MessageToast, MessageView, message model |
| `Navigation` | `nav_app_call( )` / `nav_app_leave( )` between apps |
| `Nested View` | `nest_view_display( )`, FlexibleColumnLayout |
| `Templating` | views generated at runtime (`template:repeat`) |
| `Timer` | client timers driving the backend |

**Do not invent a catch-all** (`More`, `Function`, `Misc`, `Other`) — those
existed and were dissolved on 2026-08-13 because nobody searches for them. A
new header is justified when at least two samples share a topic none of the
above covers; add it to the table in the same change.

Rules for the `sub`:

- **Title Case, a short noun phrase**, max 60 characters for the whole
  DESCRIPT — that is the hard limit of the ABAP class short text.
- **Name the control or the API the sample is about** (`FlexibleColumnLayout`,
  `SearchField`, `CustomTreeItem`, `setSizeLimit`, `nav_app_call`,
  `template:repeat`). This is what makes the sample findable — the search
  matches `header`, `sub` and the class name, nothing else.
- **Do not echo the header** (`Control Behaviour - Wizard Control`,
  `Popup - Value Help with Popups`).
- Describe **what the sample shows**, not the mechanism it happens to use, when
  the two differ — a Menu demo is `Menu - …`, even if its point is `core:require`.

### Generation rules

1. **One catalog per area — and only `src/01` has one.** Apps in `src/01/**`
   belong in `smp_app_000`. `src/00/**` has no overview app (§3): an app moved
   to `src/00/97` ("experimental") or `src/00/98` ("testing") gets **no** tile —
   the generator only reports how many those packages hold.
2. **Each app appears exactly once**, and every demo app physically present in an
   area is listed (no missing tiles) — **except hidden helper apps**: a class
   whose `<DESCRIPT>` header is `ZZZ` (e.g. `ZZZ - called by SubApp I`) is only
   ever called by another app and must **not** get a tile. It stays in the
   folder (and is checked by abaplint), just not shown in the overview.
3. **`group` == subpackage CTEXT.** If you rename a subpackage's CTEXT, update
   every tile's `group` to match. A tile's group must equal the CTEXT of the
   folder the class physically lives in — never a neighbouring category.
4. **Group blocks follow folder order.** Emit groups in ascending folder number
   so the on-screen order mirrors the tree; a nested subpackage forms its own
   group directly after its parent slot. The samples live directly in `src/01`
   today, so there is a single group ("samples") — and with only one group the
   overview leaves the heading out entirely (§3). When a nested subpackage is
   added, place its group at its numeric position rather than appending it.
5. **Within a group, sort tiles alphabetically (case-insensitive) by `header`,
   then by `sub`.** Sorting by `header` first keeps numbered series together and
   in order (`Binding I`, `Binding II`, `Binding III`, … underneath each other;
   likewise `Popover I…IV`, `Popup I…III`). The group order from rule 4 is
   untouched; only the tiles inside each group are ordered.
6. **Moving a subpackage out of `src/01` drops its whole tile group** — there
   is no catalog on the other side, in `src/00/97` no more than in `src/00/98`.
   Moving one *into* `src/01` adds its group at the matching numeric slot
   (rule 4).
7. After every change, verify: `get_catalog( )` and the folder tree agree —
   same apps, same group names (== CTEXT), same grouping, no app in the wrong
   overview, none missing. The safest way to regenerate is to rebuild the
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
2. Regenerate the overview catalog and `SAMPLES.md`: `npm run launchpad` (§4).
3. `abaplint` → 0 issues → commit (English message).

**Moving a sample / subpackage**
1. `git mv` the files (no rename needed — `FOLDER_LOGIC=PREFIX`).
2. Regenerate the overview catalog and `SAMPLES.md`: `npm run launchpad` (§4).
3. If a subpackage was added/removed/renamed: update the §1 tree and run
   `node scripts/check-agents-structure.mjs`.
4. `abaplint` → 0 issues → commit.

**Before every commit**

```sh
npm run check
```

**`npm run check` is the whole of CI**, minus the one step that cannot be run
on a tree you want to keep (below). Every workflow that can make a pull request
red has a step here, and every step here has a workflow — so a green run
locally means a green run there, which is the only reason to run it at all.
It used to be six of eleven, and the three it was missing were the three
nobody thought to run by hand.

In the order they fail fastest:

| step | workflow | what it holds |
|---|---|---|
| `npm run lint` | `abap-standard` | `abaplint` reports 0 issues (`abaplint.jsonc`, `v750`) |
| `npm run check:cloud` | `abap-cloud` | the same tree against the ABAP Cloud API — `main` is installed there as it is (§2) |
| `npm run check:abap2ui5` | `check-abap2UI5` | the abap2UI5-linter: the app class and the view it builds, plus a headless render of every view. New findings fail; `abap2ui5lint-baseline.json` holds the debt frozen at adoption, and an entry whose finding is gone fails too |
| `npm run check:agents` | `check-docs` | no drift between the §1 tree and the actual `package.devc.xml` CTEXTs |
| `npm run check:strip` | `check-docs` | no drift in the strip list (§2) |
| `npm run check:keywords` | `check-keywords` | every sample carries `@keywords` and `@summary`, first line, lowercase (§4) |
| `npm run check:launchpad` | `publish-overview-apps` | the overview catalog and `SAMPLES.md` still mirror the folder tree (§3, §4) |
| `npm run check:catalogue` | `publish-overview-apps` | the committed `catalogue.json` still mirrors the folder tree (§3) |
| `npm run check:prose` | `check-docs` | every class name written in prose exists, here and in the sibling repositories |
| `npm run check:docs-links` | `check-docs-links` | every `" @docs` URL resolves, and its page names the class back (§4) |
| `npm run check:app-rules` | `check-app-rules` | the abaplint rule block still matches its source in abap2UI5 (§6) |
| `npm run rename` | `check-rename` | the samples still rename out of the `z2ui5` namespace; writes to the gitignored `output/`, never to `src/` |

`check:launchpad` runs the two generators with `--check`: same render, compared
instead of written. The generators are the source of truth either way, because
a check that regenerated differently from the generator would be worse than
none.

The last three talk to the network — `check:app-rules` and `check:docs-links`
prefer a sibling checkout and otherwise fetch, and both **say so and pass** when
they can reach neither: a gate must not go red because github.com is (§6). That
degradation is why `check:app-rules` is in the aggregate now; it was left out
back when an unreachable source was a failure.

**The one CI step that is not here: `npm run downport`** (`abap-702`,
`publish-702`). It is not a check, it is the 702 build: it deletes the stripped
packages and runs `abaplint --fix` over what is left, so running it leaves you
with a downported working copy rather than an answer. Run it deliberately, on a
clean tree, and `git checkout .` afterwards.

By hand, because no script covers it:
- abapGit file format for all file types: UTF-8, LF only, final newline,
  2-space indent (§6).

---

## 6. Rules

### abaplint

- **Run `abaplint` before every commit. It must report 0 issues.**
- Configuration: `abaplint.jsonc`
- Install: `npm install -g @abaplint/cli`
- Run: `abaplint`
- **The rule block below the marker is a CHECKED COPY of the shared app rule
  set, and its source is
  [abap2UI5/abap2UI5](https://github.com/abap2UI5/abap2UI5)
  `.github/abaplint/app-rules.json`** — the repository where the rest of "how
  to write an abap2UI5 app" already lives (the `build-an-app` and
  `view-chain-layout` skills, `docs/agents/building-apps.md`, `abap-check`,
  `ui5-check`), because a shared thing needs one owner. **Change it THERE
  first, then copy it here**; this repository, samples-controls and
  samples-stack are consumers of that file, not peers of each other.
  - This replaced a three-way peer comparison, deliberately: three peers have
    no answer to which of them is right, a repository without its own copy of
    the checker turned the *other* repositories' CI red when it drifted, and
    the peer checker compared rule NAMES only — so switching a rule to
    `false` to get a pull request through, precisely the drift it existed to
    catch, read to it as no change at all.
  - **The gate is `scripts/check-app-rules.mjs`** (`npm run check:app-rules`,
    and the `check-app-rules` workflow on every pull request and push to
    `main`). It compares PARSED SETTINGS against the source, preferring an
    `abap2UI5` checkout next to this one and falling back to
    `raw.githubusercontent.com`. It is the one gate here that needs the
    network: when the source is unreachable it says so and **passes**, rather
    than going red because github.com is. abap2UI5 checks the same thing from
    its side (`shared-file-gate.mjs`) — that is the source noticing, this is
    the consumer noticing.
  - abaplint has no `extends`, so there is no shared file to include — the
    checked copy is the mechanism, and the block carries a header saying so.
  - Only `global`, `dependencies` and `syntax` are per repository (release
    floor, dependency set, suppressions) — plus exactly **one** rule:
    `object_naming`, which encodes the repository's token (SMP / SMPC /
    SMPS) and is the only rule `check-app-rules` excludes from the
    comparison. It sits last in the file behind a marker that says so.
    Everything above that marker must match the source.
- **Every rule abaplint ships is listed in the config — all 188 of them**
  (2026-08-16; it was 17 here, 44 in samples-controls and 41 in
  samples-stack, the rest defaulting to off unnoticed). 171 are on. **A rule
  is never left out of the file.** When an abaplint upgrade adds one, add the
  key to `app-rules.json` in abap2UI5 and copy the block into all three
  consumers: on if all three corpora pass, off with the reason in a comment
  above it if they do not. An unlisted rule reads as "nobody decided" rather
  than "decided against".
- The 17 that are off carry their reason in the file. In short: four rules
  want Hungarian notation and `no_public_attributes` wants the model hidden,
  both against §7 and §9; `abapdoc` treats demos as a published API; seven
  rules read a view builder chain or a `VALUE #( )` data table as a
  malformed parameter list, and that layout has its own gate
  (`chain-house-layout` in `npm run check:abap2ui5`, §10); `prefer_inline` /
  `no_inline_in_optional_branches` move declarations the samples place
  deliberately; `prefer_corresponding` proposes a rewrite that does not
  activate on a generic field symbol; and `smim_consistency` cannot resolve
  a MIME folder that lives on the system.
- Several rules run with flags off or an `exclude` rather than wholesale.
  The ones worth knowing here: `check_subrc` (`selectSingle`, `selectTable`
  — "no rows" is a legitimate state, and the SELECT either feeds a binding
  or is read back with `OPTIONAL`), `dangerous_statement` (`dynamicSQL` — it
  is the subject of the generic table browser samples in `src/00/98`),
  `double_space` (`keywords` and `endParen` — both would strip deliberate
  column alignment), `no_yoda_conditions` (`onlyConstants` — unrestricted it
  demands `lines( t ) < i` instead of `i > lines( t )`) and
  `empty_structure` (`when` — an event that only needs the round-trip is a
  legitimate empty branch, with a comment where the code would be).
  - An `exclude` that names another repository's files is **not** noise here:
    it is what lets one block serve three corpora. `z2ui5_cl_smps_bp_*`
    matches nothing under this `src/`, and removing it would break
    samples-stack on the next copy.
- **Write the flag set out in full when configuring a rule.** abaplint
  replaces the whole options object, so a partial one silently turns every
  flag it omits *off* — `"check_subrc": { "selectTable": false }` disables
  the rule entirely instead of narrowing it.

### abap2UI5-linter

- **It is not a view checker.** It validates a **whole app class** — the ABAP
  and the view it produces, together. Assuming it only inspects XML is the
  common mistake, and it misses the point: the group that catches what no
  other tool can is precisely the one that spans both sides.

  | Rule group | What it catches |
  |------------|-----------------|
  | `metadata` | controls and members resolved against the UI5 metadata snapshot |
  | `structure`| defects in the shape of the document itself |
  | `version`  | controls, members and enum values newer than the target UI5 release |
  | `data`     | the view renders, but not with the data — or not for the user — the author meant |
  | `abap2ui5` | defects living in the relationship between the ABAP class and the view it builds; silent at runtime, invisible to any UI5 tooling |

- Configuration: `abap2ui5lint.jsonc` (UI5 floor `1.71`, distribution
  `openui5`, `failOn: warning`, baseline, badges)
- Run: `npm run check:abap2ui5`
- CI: `abap2UI5` — as opposed to `abap-standard` / `abap-cloud` /
  `abap-702`, which lint ABAP itself against three target releases
- **The gate is effective**: 148 app classes, 172 reconstructed views, and
  an `abap2ui5lint-baseline.json` that froze the adoption-time debt (#753)
  until every entry was fixed — empty since 0.6.1, kept so the next adoption
  has its shape. It was
  not always: while the linter still looked for the view builder's former name
  it found no checkable file at all, and a green `check-abap2UI5` badge then
  meant "nothing was checkable", not "the apps are clean".
- **That is why a run reports what it LOOKED at**, not only what it found.
  The gates log every file into a collapsed group while they run, and the run
  closes with a summary — classes, views reconstructed (**and how many
  classes produced none**), controls, bindings and icons judged, the control
  histogram, what the baseline swallowed and per rule, the phase times:

  ```
  sources    148 app classes
  views      172 documents reconstructed, nested 11 deep, 7 classes produced none
  judged     2,178 controls of 106 types, 551 bindings, 68 icons, 4,178 attributes
  gates      properties 148 files, render 172 documents
  ```

  (No `baselined` line any more: `abap2ui5lint-baseline.json` has been empty
  since 0.6.1 — the one frozen finding was fixed rather than carried.)

  A `judged` line of zeroes, or `148 classes produced none`, is the earlier
  failure repeating itself — and now it says so instead of printing
  "Success! No findings detected."
- **The two README badges** (`.github/badges/abap2ui5.json` and
  `.github/badges/check-abap2ui5.json`, shields.io endpoint files) carry the
  same statement, split along what they mean: *abap2UI5 | 148 apps · 172 views
  · 2,178 controls* is what is here, blue, a fact; *check-abap2UI5 | 86 rules
  passed* is what the gate made of it, green (or *3 problems*, *7 errors*,
  red). A run that finds nothing checkable turns both grey and says so. Every
  run rewrites them, `check-abap2UI5` commits them onto the pull request
  branch, and main picks them up when that pull request merges — so the counts
  are what the last run actually checked. **A sample added or removed changes
  these files**; commit them with the change (the workflow pushes them if you
  forget, and reports it when it cannot).

### The scripts under `scripts/`

**Every script is an ES module and is named `.mjs`.** No CommonJS, no
`require( )`, no `__dirname` — resolve the repository root from
`fileURLToPath(import.meta.url)`, the way every script here already does.

The repository ran two module systems side by side until 2026-08-18: five
CommonJS `.js` files and three ESM `.mjs` ones, with no rule saying which a new
script should be. That is not a style preference. A `.js` file cannot `import`
the `.mjs` scan, so a check written the ESM way could not reuse
`lib/scan-samples`, and one written the CommonJS way could not `await` a
`fetch( )` at the top level — which is exactly what the two network-aware gates
do. The split decided what a new check was allowed to reuse, silently, by the
extension somebody picked. Both sibling repositories are ESM throughout;
so is this one now.

Everything else about a script follows from that:

- **No dependencies.** Plain node, so a gate is a few seconds and needs no
  `npm ci` — `check-docs`, `check-keywords`, `check-docs-links`,
  `check-app-rules` and `check-prose-names` all run `node <script>` directly
  in CI.
- **One scan, two renderers.** Anything that reads the sample tree goes through
  `scripts/lib/scan-samples.mjs` (§4). A second scan drifts silently.
- **A gate that needs the network says so and passes** when it cannot reach it
  (`check-app-rules`, `check-docs-links`) — see §6 below and the header of
  `scripts/check-app-rules.mjs`. Prefer a sibling checkout over a fetch, so a
  developer with the whole ecosystem cloned is checked offline.

### abapGit file consistency

All serialized files (`.abap`, `.xml`, and any other abapGit-managed file types)
must conform to the abapGit file format:
- **Encoding**: UTF-8 (with optional BOM: `xEF BB BF`)
- **Line endings**: LF (`x0A`) only — never CRLF
- **abapGit `*.clas.xml` sidecars start with the UTF-8 BOM** (`EF BB BF` before
  `<?xml`) — abapGit writes them that way, and a BOM-less sidecar produces a
  spurious diff on the next push from a system (human fixes 2026-07-18).
  Copy an existing sidecar as template.
- **Final newline**: every file must end with a single newline character after the last line
- **Indentation**: 2 spaces — never tabs
- **Line length**: max **255 characters** per `.abap` source line (hard ABAP
  limit — longer lines break the abapGit import with "Literals across more
  than one line are not allowed"; enforced via the abaplint `line_length`
  rule). Split long string literals into `&&` chunks.

**Always verify consistency for all file types before committing**, not just
`.abap` files. abaplint covers `.abap` files; for `.xml` and other files, check
manually or via editor tooling that the above rules are met.

---

## 7. Code Conventions

- Follow the [SAP ABAP Style Guide](https://github.com/SAP/styleguides/blob/main/clean-abap/CleanABAP.md).
- Never use an init flag attribute (`check_initialized`, `mv_init`, `is_initialized`, etc.). Always use `client->check_on_init( )` instead.
- An `abap_bool` is compared to `abap_true` / `abap_false` — never asked with `IS INITIAL` / `IS NOT INITIAL`, which is the question for a string that might be empty (`IF mv_flag = abap_false.`, `DELETE lt_x WHERE flag = abap_false.`). The three `check_on_*( )` methods return `abap_bool` as well, and there the corpus writes the predicative call itself: `IF client->check_on_init( ).`, `` ELSEIF client->check_on_event( `LOCK` ). ``. Never `IF client->check_on_init( ) OR client->check_on_navigated( ).` — that `OR` is redundant, see the lifecycle section below. Only a NEGATIVE branch is spelled out, as `= abap_false` — there is no negated predicative form here. The rule and its reasons live in abap2UI5's `build-an-app` skill.
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
- **ABAP Doc (`"!`) position** — not caught by `abaplint`, but the extended check (SLIN/ATC) reports "ABAP Doc comment is in the wrong position": a `"!` block must sit directly before the one declaration it documents. Inside a chained statement (`TYPES: BEGIN OF …`) that means directly before the component, *within* the chain. It is never allowed inside a `METHODS` parameter list — document parameters in the method's own doc block above the `METHODS` keyword via `"! @parameter <name> | <text>`. A plain `"` comment (no `!`) is fine anywhere.
- ABAP Doc is parsed as HTML: escape a literal `<`, `>` or `&` as `&lt;`, `&gt;`, `&amp;`.
- **A mock table is a table.** In a `VALUE #( )` of three or more rows with the same field list, pad every cell to the width of its column and leave the LAST cell of a row unpadded, so no spaces pile up before the closing `)`. Rows whose field lists differ have no column to align and stay as they are; a row that would break 255 characters once padded is wrapped at the same field boundaries in every row instead.
- **A call that fits on one line goes on one line** (budget 120 characters) — stacking parameters is for calls that do not fit, not for calls that happen to have two. The view chain is the exception: it keeps one call per line (`view-chain-layout`), and a `t_arg` list wrapped over several lines stays wrapped, hanging under its first element.
- Always run `abaplint` after every change. It must report 0 issues before committing.
- Before starting app development, read all active rules in `abaplint.jsonc` and follow them throughout.
- **The rules that most often bite when writing a new sample** (all of them
  enforced since 2026-08-16, see §6):
  - A table type is `WITH EMPTY KEY`, never `WITH DEFAULT KEY`.
  - A local type name starts with `ty_` (`ty_s_` / `ty_t_`, §7 above).
  - `CASE` needs two `WHEN` branches. One event is an `IF` — which is what §9
    asks for anyway; `CASE` starts at four.
  - Every `SELECT` carries an `ORDER BY` (`ORDER BY PRIMARY KEY` if the order
    itself does not matter), and `SELECT SINGLE` needs the full key — without
    it, use `ORDER BY PRIMARY KEY ... UP TO 1 ROWS` and read row 1.
  - `ASSIGN` and `READ TABLE` are followed by an `sy-subrc` check. Reading an
    unassigned field symbol dumps; a missed `READ TABLE` leaves the previous
    work area in place, which is worse than a dump because it looks like data.
  - An explicit `DATA` belongs at the top of its method (`definitions_top`).
    An inline `DATA( )` at the point of use is fine and is not affected.
  - No commented-out code, no unused variable, type or method, no empty
    `WHEN`, no end-of-line comment, no `!` before a parameter name.
  - Two blank lines between methods — three is a finding.

---

## 8. Framework Reference

For deeper information about how the abap2UI5 framework works internally —
architecture, roundtrip processing, data binding engine, session persistence,
and core classes — refer to the
[abap2UI5 repository](https://github.com/abap2UI5/abap2UI5) and its `AGENTS.md`.

---

## 9. How Apps Work

Every abap2UI5 app implements `z2ui5_if_app` with a single `main()` method. The framework calls `main()` on every roundtrip (HTTP POST). Use the lifecycle checks to react to different situations:

- `client->check_on_init( )` — true on the very first call, and there **only to seed**
- `client->check_on_navigated( )` — the DISPLAY branch: true on that first call as well, and whenever the app regains the screen (returning from a sub-app or popup, a restored bookmark)
- `client->check_on_event( )` — true when a user triggered an event

Always use `ELSEIF` to chain these checks — never separate `IF` blocks:
```abap
IF client->check_on_init( ).
  " only what must happen ONCE - seed the model, seed a control-state flag
ELSEIF client->check_on_navigated( ).
  view_display( ).
ELSEIF client->check_on_event( ).
  on_event( ).
ENDIF.
```

**`check_on_init( )` true implies `check_on_navigated( )` true** — every path to an
instance's first `main( )` sets that flag (`factory_first_start` for a fresh start
and for a draft restore, `factory_system_startup`, `prepare_app_stack` for
`nav_app_call` and `nav_app_leave`). So an init branch whose only statement is
`view_display( )` has an `ELSEIF` twin doing exactly the same thing, and
`IF check_on_init( ) OR check_on_navigated( ).` says the same redundancy in one
line. An app with nothing to seed drops the init branch entirely:

```abap
me->client = client.
IF client->check_on_navigated( ).
  view_display( ).
ELSEIF client->check_on_event( ).
  on_event( ).
ENDIF.
```

The exception is a **sub-app that never owns the screen** (apps 105 and 112): it
renders into the parent's view reference and has no `check_on_navigated( )` branch
at all, so there `check_on_init( )` is the only place the view is built.

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

Calling `view_display( )` in the `check_on_navigated( )` branch is **always safe** — even after a popup, where the main view stayed on screen, it simply re-renders the same view. Use it as the general rule. When the app returns exclusively from a popup (`z2ui5_cl_pop_*` / `popup_display`), doing nothing is sufficient — the framework pushes the model automatically whenever `main( )` changed it — but never rely on that when a full-screen sub-app can be called.

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
| Views | `view_display`, `view_destroy` | Main view lifecycle (the model itself is pushed automatically — there is no model-update call) |
| Nested views | `nest_view_display/destroy`, `nest2_view_*` | Embedded sub-views |
| Popups | `popup_display`, `popup_destroy` | Modal dialogs |
| Popovers | `popover_display`, `popover_destroy` | Context popovers |
| Binding | `_bind(val)` | Data binding — the value is written back before the event handler runs (`_bind_edit` is an obsolete alias) |
| Events | `_event(val)`, `follow_up_action(val)`, `check_on_event(val)` | Event registration and checking (`_event_client` is an obsolete alias — `follow_up_action` covers both roles: returned into a view attribute it binds the frontend action to a control, called on `client` it queues the action after the current response renders) |
| Navigation | `nav_app_call(app)`, `nav_app_leave()`, `get_app_prev()` | App stack navigation |
| Lifecycle | `check_on_init()`, `check_on_navigated()`, `check_app_prev_stack()` | State checks |
| Messages | `message_box_display(text)`, `message_toast_display(text)` | User notifications |
| Session | `set_session_stateful(val)`, `set_app_state_active(val)` | Session management |
| Browser | `set_push_state(val)`, `follow_up_action(val)` | Browser interaction (`cs_event-history_back` was removed in 1.143.0 — go back by passing the raw JS `history.back()` to `follow_up_action( )`, or `nav_app_leave( )` inside the app; routing via `follow_up_action( cs_event-set_nav_routing )`) |
| Info | `get()`, `get_event()`, `get_event_arg()`, `get_app(id)` | Request/context data |
| Constants | `cs_event`, `cs_view` | Predefined event IDs and view names |

### Navigation

**Back Navigation** — always use `client->_event_nav_app_leave()` to bind the back button event directly in the view. This triggers navigation without a roundtrip to the ABAP backend:

```abap
METHOD view_display.

  DATA(view) = z2ui5_cl_ui5_view_builder=>factory( )->ele( n = `View` ns = `mvc`
      )->a( n = `displayBlock` v = `true`
      )->a( n = `height`       v = `100%`
      )->a( n = `xmlns`        v = `sap.m`
      )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
      )->a( n = `xmlns:core`   v = `sap.ui.core` ).

  DATA(page) = view->ele( `Shell` )->ele( `Page`
      )->a( n = `title`          v = `My App`
      )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
      )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).
  " ...
  client->view_display( view->stringify( ) ).

ENDMETHOD.
```

Only use the manual pattern (handling `BACK` in `on_event`) when you need to do something with the app or client instance **before** navigating back — for example, writing data back to the previous app:

```abap
METHOD on_event.

  CASE client->get_event( ).
    WHEN `BACK`.
      " interact with previous app instance first
      CAST z2ui5_cl_app_parent( client->get_app_prev( ) )->set_result( s_result ).
      client->nav_app_leave( ).
  ENDCASE.

ENDMETHOD.
```

---

## 10. Building Views

Views are XML strings passed to `client->view_display()`, built with
`z2ui5_cl_ui5_view_builder` — the released builder in the framework's `src/02`.
It is generic: six methods build any UI5 view 1:1, so there is no list of
supported controls and nothing to wait for when UI5 adds one. Element and
property names come straight from the
[UI5 API Reference](https://ui5.sap.com/#/api) and are written exactly as
documented there.

### 1. The builder — `factory`, `ele`, `tag`, `a`, `end`, `stringify`

- `factory( )` returns an **empty root**. Unlike the retired builder it opens
  no `mvc:View` for you: you open it and declare the namespaces yourself, which
  is why they are visible in every sample.
- `ele( n = ns = )` adds a child element and **descends into it** — the chain
  now points at the new element.
- `tag( n = ns = )` adds a child element and **stays** on the current one, so
  the next `tag( )`/`ele( )` becomes its sibling and no `end( )` is needed.
  This is the form for a leaf, whatever its attributes are.
- `a( n = v = )` sets an attribute on the element the chain points at — the
  child just added by `ele( )`/`tag( )`, or the node itself while it has no
  children. So `a( )` always follows the control it belongs to.
- `a( n = b = )` takes an **ABAP boolean** and renders `true`/`false` itself:
  write `a( n = `editable` b = mv_edit_mode )`, never a conversion of your own.
  Pass either `v` or `b`, never both.
- `end( )` ascends to the parent element.
- `stringify( )` renders the whole view, always from the root, no matter which
  element the reference currently points at.

#### Empty attributes are rendered

The builder writes every attribute you add, including an empty one — and
`type=""` or `color=""` is not a valid UI5 enum value. An attribute whose value
may be empty at runtime therefore goes under an `IF`, it is not simply passed:

```abap
DATA(button) = toolbar->tag( `Button` )->a( n = `text` v = name ).
IF icon IS NOT INITIAL.
  button->a( n = `icon` v = icon ).
ENDIF.
```

#### View structure and indentation

Always add 1 blank line before `DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).`
to visually separate view construction from preceding logic.

Always build the view in `view_display` and call
`client->view_display( view->stringify( ) )` as a **standalone statement at the
end** — never nested inside the chain.

The chain is the only picture of the view's tree there is, so its layout is
load-bearing rather than cosmetic. **Six rules, and they are identical in
`abap2UI5/samples-controls`** — the two corpora were unified in one pass after
a survey found them following opposite conventions:

1. **One call per line.** Every `ele( )`, `tag( )`, `a( )` and `end( )` opens
   its own line with `)->`. A control never shares its line with the container
   it opens, nor with its own attributes.
2. **Four spaces per level, everywhere.** A child sits one level in from its
   container, a control's attributes one level in from the control. The same
   step throughout every file — a chain that steps by 2 and then by 4 and then
   stops moving is no longer describing the tree, it is decorating it.
3. **The closing paren rides with the arrow.** Never a `)` alone at a line end;
   carry it to the next segment so it always reads `)->`.
4. **`end( )` stands alone in the column of the `ele( )` it closes.** That is
   what makes an ascent over several levels visible instead of hidden. What is
   forbidden is the *run on one line* —
   `` )->end( )->end( )->ele( `footer` )->ele( `OverflowToolbar` `` changes four
   levels where nobody can see them.
5. **Align the `v =` / `b =` column** within one control's attribute block.
6. **`stringify( )` is a standalone final statement** — never nested in the
   chain.

```abap
METHOD view_display.

  DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
      )->ele( n = `View` ns = `mvc`
          )->a( n = `displayBlock` v = `true`
          )->a( n = `height`       v = `100%`
          )->a( n = `xmlns`        v = `sap.m`
          )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
          )->a( n = `xmlns:core`   v = `sap.ui.core`
          )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

  view->ele( `Shell`
      )->ele( `Page`
          )->a( n = `title`          v = `My App`
          )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
          )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
          )->ele( n = `SimpleForm` ns = `form`
              )->a( n = `title`    v = `Form Title`
              )->a( n = `editable` b = abap_true
              )->ele( n = `content` ns = `form`
                  )->tag( `Label`
                      )->a( n = `text` v = `Quantity`
                  )->tag( `Input`
                      )->a( n = `value` v = client->_bind( quantity )
                  )->tag( `Button`
                      )->a( n = `text`  v = `Post`
                      )->a( n = `press` v = client->_event( `POST` ) ).

  client->view_display( view->stringify( ) ).

ENDMETHOD.
```

The hierarchy is `mvc:View` → `Shell` → `Page` → `form:SimpleForm` →
`form:content` → leaves, and every one of those levels is four spaces. `Label`,
`Input` and `Button` are siblings inside `content`, so they are added with
`tag( )` and stay at the same indent while their attributes step in.

#### One chain, or one statement per subtree

Both shapes are correct, and the choice is about the view, not about style:

- **One chain** — the whole view in a single statement, ascending with
  `end( )`. The shape `samples-controls` uses throughout, because a 1:1 port
  mirrors one original XML file.
- **One statement per subtree** — hold a container in a variable
  (`DATA(page)`, `DATA(cont)`, `DATA(lo_columns)`) and start a new statement
  from it. The shape most of this corpus uses, and the better one when a
  subtree is filled from a loop, when the same node is filled twice, or when a
  teaching sample reads better with the parts named. `z2ui5_cl_smp_app_052`
  is the worked example.

The split shape reconstructs and renders fine — the linter reads all 172
documents in this corpus from it. What is *not* allowed is mixing them inside
one subtree, and blank lines inside a chain: they belong to the long
single-chain shape, where they separate an `ele( )` block from its first child.

#### What checks this

The rules above are also the **`view-chain-layout` skill**
(`.claude/skills/view-chain-layout/`), kept byte-identical in `abap2UI5` and
`abap2UI5/samples-controls` — read it before writing or reformatting a chain.

The linter's `chain-house-layout` rule (part of `npm run check:abap2ui5`,
in `check-abap2UI5.yaml`) checks all six rules and `npm run fmt:chains`
applies them. The fixer rewrites whitespace *between* chain segments only,
and the layout survives because every fix is verified against the rule — a
formatting change can never alter what the view builds.

#### Namespaces

Every namespace prefix a view uses must be declared on the view element —
the builder does not collect them for you. Declare only the ones the view
actually uses, and use the prefixes the UI5 documentation uses
(`form` for `sap.ui.layout.form`, `layout` for `sap.ui.layout`, `f` for
`sap.f`, `table` for `sap.ui.table`).

#### Popups

A popup is a `core:FragmentDefinition` root you build the same way, and hand
to `client->popup_display( )`:

```abap
DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
    )->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core` ).
```

### 2. Bindings

**Binding paths always come from a bind call — never hardcode them.** Every
model value a view references must be registered through
`client->_bind( )`: a
hand-written path (`{/START_DATE}`, or `{ path: '/START_DATE', ... }` in a
raw binding-info string) is NOT part of the serialized model — the frontend
receives no data for it and typed/object properties crash on the missing
value (human find 2026-07-18 in `Z2UI5_CL_SMP_APP_456`/`_457`). Compose raw
binding-info strings with the bare path from
`client->_bind( val = x path = abap_true )`.

**Always `_bind( )`, never `_bind_edit( )`.** Both bind into the same root
model — the split between them disappeared with the `XX/` view-model node — so
`_bind_edit` is only an obsolete alias and is slated for removal.
The single exception is a mapping that differs per direction, because `_bind`
has no `custom_mapper_back` / `custom_filter_back` parameters; no sample in
this repository currently needs that — one that does must say so in a comment
at the call.

**Call it "binding", never "one-way"/"two-way" binding** — in sample titles,
message strips, comments and `@keywords` alike. With only `_bind( )` left, and
the value always written back before the event handler runs, the qualifier
distinguishes nothing and makes readers look for a second mode that does not
exist. Say "bound attribute", "the value is written back before the event
handler runs".
"One-way" is correct only for a real UI5 one-way model that is not `_bind( )`
— the `device>` JSONModel in `z2ui5_cl_smp_app_445`, for example.

### 3. Two things the builder does not do

- **There is no raw-text node.** An element cannot carry text content, so an
  inline `<style>` body or any other raw markup goes into the `content`
  attribute of a `core:HTML` leaf. Write the **decoded** markup — the builder
  escapes it on stringify:

  ```abap
  page->tag( n = `HTML` ns = `core` )->a( n = `content` v = `<style>` && css && `</style>` ).
  ```

- **There is no way back up to a named ancestor.** `end( )` climbs exactly one
  level, so a view is built the way it nests. When a helper method needs a
  container the caller owns, the caller passes that reference — see the
  nested-view samples in `src/00/98`, which take the Page they render into
  (`mo_parent_page`) rather than searching for it.

> The former standalone XML builder `z2ui5_cl_util_xml` is retired in the
> framework (obsolete package, no new consumers) and is no longer used by any
> sample — do not use it in new samples.

> **The `z2ui5_cl_pop_*` helper popups are obsolete.** They live in the
> framework's obsolete package (`src/99`) and must not be used any more: never
> reference one from a sample, and never create a sample demonstrating one
> (human decision 2026-08-12; the last two usages — `z2ui5_cl_pop_to_confirm`
> in `Z2UI5_CL_SMP_APP_279`, `z2ui5_cl_pop_image_editor` in
> `Z2UI5_CL_SMP_APP_306` — were removed the same day). A sample that needs a dialog builds it itself with
> `z2ui5_cl_ui5_view_builder=>factory( )` with a `core:FragmentDefinition`
> root + `client->popup_display( )`.

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
    " bound data (DATA attributes for _bind)...
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

    CASE client->get_event( ).
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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).
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

---

## 12. Sample content conventions

Learned while curating the `src/01` (Basic) package — follow these so
new/edited samples stay consistent:

- **Every sample opens with an intro `MessageStrip`.** As the **first control in
  the page content** (right after the page is created, before the form/table),
  add a short, specific English explanation of what the sample demonstrates:
  ```abap
  page->message_strip(
      text     = `<one or two sentences: what this sample shows / does>`
      type     = `Information`
      showicon = abap_true
      class    = `sapUiSmallMargin` ).
  ```
  Split a long `text` into `` `chunk ` && `` continuation lines (≤255 chars/line,
  aligned under the first backtick). If the view is one uncaptured fluent chain,
  capture the page first (`DATA(page) = <view>->shell( )->page( ... ).`).

- **DESCRIPTs of framework-action / custom-control samples carry a
  capability marker** appended to the `<DESCRIPT>`
  (leading space), surfaced in the overview:
  - `(C)` — uses an abap2UI5 **custom control** (the `z2ui5` cc namespace:
    `ele( n = … ns = `z2ui5` )`, `z2ui5.cc`, `xmlns:z2ui5`).
  - `(A)` — performs a **frontend action**: `client->follow_up_action( )`
    (including the `cs_event-control_by_id` / `cs_event-control_global` /
    `cs_event-binding_call` events), or a
    client-side interaction like drag-and-drop. The ubiquitous back-button
    `client->_event_nav_app_leave( )` does **not** count.
  - `(A,C)` — both. Regenerate the overviews after changing any DESCRIPT (§4).

- **A read-only info form disables its inputs** (`enabled = abap_false`) — do not
  leave display-only values in editable inputs (see `z2ui5_cl_smp_app_122`).

- **No redundant footer Back button.** The `shell( )->page( )` already renders a
  nav-back button (`navbuttonpress` / `shownavbutton`); do not add a second
  `Back` button in the page footer (removed from the MessageBox / MessageToast
  samples).

- **Must run on OpenUI5 1.71 — watch for "phantom control" 404s.** A generic
  aggregation-escape method that names an aggregation the parent does **not**
  have makes UI5 resolve it as a *control class* and 404 with `failed to load
  sap/<lib>/<name>.js` on 1.71, crashing the sample. Two real cases:
  - `object_page_section( )->heading( `uxap` )` — `sap.uxap.ObjectPageSection`
    has no `heading` aggregation. Put the section title in `title = `…`` and go
    straight to `sub_sections( )`. (`heading( `f` )` **is** valid on a
    `dynamic_page_title( )` — sap.f `DynamicPageTitle` has that aggregation.)
  - `<footer>` on a popup `Dialog` — `sap.m.Dialog` only got a public `footer`
    aggregation ~1.110; a `page( )->footer( )` is fine (sap.m.Page always had
    one). Every control/property in `src/01` must exist since 1.71 (§2); when in
    doubt check "available since" in the demo kit.

- **`sap.m.SimpleForm` needs `editable = abap_true`** for its label/input pairs
  to line up on one row — without it the form renders in display mode and the
  first field is mislaid (fixed in `Z2UI5_CL_SMP_APP_189`; compare
  `Z2UI5_CL_SMP_APP_133`).

- **`StandardListItem`: `info` right-aligns to the far edge** (a status/amount
  slot). For a secondary attribute that belongs *with* the title (e.g. a
  product's category) use `description` — a left-aligned subtitle — instead; the
  far-right float looks disconnected on wide screens (fixed in
  `Z2UI5_CL_SMP_APP_454`/`_455`).

- **The page title carries the `<DESCRIPT>` text**, in the form
  `` `abap2UI5 - <DESCRIPT without the (A)/(C) marker>` `` — every sample in
  `src/01` follows it since 2026-08-13. A user clicks a tile in the overview
  (which shows the DESCRIPT) and the opened sample must name the same thing, so
  it is recognisably the right sample. Change the two together: renaming a
  DESCRIPT without the page title puts them out of sync again (they had drifted
  to "Focus II" and "Table Filters Reset after view Update").

- **Start every view from `view->shell( )->page( … )`** (not `view->page( … )`)
  so all samples share the same outer frame (fixed in `Z2UI5_CL_SMP_APP_143`).

- **Give a `search_field` an explicit `placeholder`.** Without one UI5 shows its
  locale default (German "Suchen" on a DE system), which clashes with the
  otherwise-English samples.

---

## The overview page — `web/`, on GitHub Pages

**https://abap2ui5.github.io/samples/** — the learning path as a page, for
somebody who has not installed anything yet. Published by the `deploy-web`
workflow on every push to `main` that touches `src/`, `web/` or the generator
(*Settings → Pages → Source = GitHub Actions*).

It is the **third view of one catalogue**, and the reason the three cannot
disagree is that all three are rendered from the same scan
(`scripts/lib/scan-samples.mjs`, §4): the overview app for a reader who has the
repository in a system, `SAMPLES.md` for a reader on GitHub, this page for a
reader who is still deciding whether to install it. **Do not give the page its
own facts about a sample.** Its title, its one sentence, its search terms and
its documentation chapters are the `DESCRIPT`, the `@summary`, the `@keywords`
and the `@docs` of the class — change them on the class, as always, and all
three follow.

**Only `src/01` is on it.** `src/00/97` is unfinished and `src/00/98` exists to
be run by a check rather than learned from (§2), and both are stripped from
`702` — a page that teaches must not lead anybody into either. The ZZZ helpers
are out for the reason they carry no tile (§4); they come back only as the
extra files a playground link needs to actually run.

### The one thing that is not derived: the order

The categories are the header of a `DESCRIPT` and therefore sort
alphabetically, which puts `Browser` between `Binding` and `CSS` — an order
nobody learns in. So the page groups the 23 categories into **stages**, and
that grouping is a teaching decision written in
**`scripts/lib/learning-path.json`** and nowhere else:

```json
{ "id": "rows", "title": "Show many rows", "blurb": "…", "categories": ["Table", "Grid Table", "List", "Tree"] }
```

**Every category belongs to exactly one stage.** `npm run check:overview`
(`scripts/generate-overview-index.mjs --check`, part of `npm run check`) fails
when a category has no stage, when two stages claim one, or when a stage names
a category no sample carries. A new category is therefore a decision somebody
has to make — where in the path does this belong — rather than a section that
silently is not on the page. Adding a sample to an existing category needs
nothing: the page picks it up on the next deploy.

### The files

`web/index.html`, `web/overview.css`, `web/overview.js` — no framework, no
build step — plus `web/apps.json`, which is **generated and not committed**
(`node scripts/generate-overview-index.mjs`, or `npm run overview`). It is a
build output like any bundle: the workflow writes it on every deploy, so it is
never staler than the tree, and a sample pull request carries no diff of
derived data. See `web/README.md` for how to run the page locally.

That non-commit decision is about the page's artefact, not about derived
files as such: `catalogue.json` at the repository root is derived from the
same scan and **is** committed, because its reader is a clone rather than a
deploy (§3).

`web/thumbs/` follows `apps.json`, not `catalogue.json`: **one thumbnail per
sample, generated at deploy and never committed.**
`scripts/generate-screenshots.mjs` (`npm run screenshots`) photographs every
`src/01` view with the abap2UI5-linter's render harness — the same headless
reconstruction `npm run check:abap2ui5`'s render gate clears, kept standing
long enough for a picture — so what a card shows is what the gate checks, of
the class as it is on `main`. It is the one script under `scripts/` that
needs the devDependencies (the linter, `@abap2ui5/render-runtime`, a
playwright chromium): it is a deploy step, not a gate, and it is in no check
aggregate. A view the harness cannot render — the `z2ui5.cc` custom-control
samples, mostly — is reported and skipped, and the page treats the missing
file as "no picture" (the `<img>` removes itself), so a sample without a
thumbnail is normal, not broken. Only a run that photographs *nothing* fails,
because that is a harness problem; even then the deploy publishes
(`continue-on-error`), since a page without pictures beats no page.

<!-- The section below is SHARED. Its source is
     abap2UI5/abap2UI5 .github/shared/agents-metadata.md - change it THERE
     first, or the change is drift. abap2UI5's `npm run check:shared`
     compares this section against the source, from the heading down to the
     next `##`; anything above this comment is this repository's own. -->
## Metadata: what goes on the class, and what goes beside it

Shared across `abap2UI5/samples`, `abap2UI5/samples-controls` and
`abap2UI5/samples-stack`. Decided once, so nobody has to decide it again per
repository.

**A class says what it IS. A sidecar records what HAPPENED to it.**

| | where | why |
|---|---|---|
| `DESCRIPT` — `Titel - Kurzbeschreibung` | `.clas.xml` | 60 characters, hard. What ADT's object list shows |
| `" @summary` — one sentence | first lines of `.clas.abap` | no limit. The line a catalogue puts under the title |
| `" @keywords` — search terms | first lines of `.clas.abap` | what somebody would type who does not know the sample exists |
| upstream sample, port batch, audit findings, verification date, deviations | a sidecar (`meta/<class>.json`) | not properties of the class; written by machinery; long-form; changes on a different schedule |

### Why the first three are not in a sidecar

**A sidecar does not travel.** abapGit pulls `src/`; a `meta/` folder never
reaches the SAP system. Three places that costs:

1. **In the system it is simply absent** — which is why an overview app that
   needs the data has to have it *baked in* by a generator.
2. **A search engine drops somebody into the `.clas.abap` on GitHub** and the
   code is all they get. This is the same argument `@docs` is a full URL for.
3. **An AI reading the class file gets no metadata** unless its tooling happens
   to know about `meta/`.

A `"` comment costs the ABAP nothing — it is not `"!`, so SLIN/ATC does not
report an unknown tag — and it cannot desync from the class, because it is in
the class.

### Why the rest is not on the class

A deviation note with three paragraphs and a verification date is not a
property of the class; it is a log entry about a process, usually written by a
test run rather than by an author. Putting it in a `"` comment would bloat the
source and would still be worse structured than JSON. That belongs beside the
class, and the sidecar is right for it.

### The test, when a new field turns up

Ask: *would this still be true if nobody ever ran a check again?* If yes it
describes the sample and belongs on the class. If it only became true because
somebody did something, it belongs in the sidecar.
