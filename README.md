[![abap version](https://img.shields.io/badge/abap%20version-standard%20%28%E2%89%A5%207.02%29%20%2B%20cloud-blue)](#try-it-in-60-seconds)
[![namespace](https://img.shields.io/badge/namespace-z2ui5__cl__smp-blue)](abaplint.jsonc)
[![dependency](https://img.shields.io/badge/dependency-abap2UI5-blue)](https://github.com/abap2UI5/abap2UI5)

# abap2UI5 — samples

**Learn the abap2UI5 basics — 150+ ready-to-run apps, from a two-line Hello
World to complete applications.**

Install them, click through, read the source: every sample adds one idea — a
binding, an event, a table, a popup — so the collection reads like a course.
It is the fastest way to learn abap2UI5 development.

#### Your first app

```abap
CLASS zcl_my_app DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
ENDCLASS.

CLASS zcl_my_app IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    client->message_box_display( `Hello World` ).
  ENDMETHOD.
ENDCLASS.
```

That is a complete UI5 app — one interface, one method, and abap2UI5 renders
the rest. Everything in this repository grows from this pattern.

#### Try it in 60 seconds

1. Install [abap2UI5](https://github.com/abap2UI5/abap2UI5) — this repository
   ships apps, not the framework.
2. Pull this repository with [abapGit](https://abapgit.org), using the branch
   that matches your system:

   | Branch  | System                                                     | Content                  |
   |---------|------------------------------------------------------------|--------------------------|
   | `main`  | on-premise NW 7.50+ **and** ABAP Cloud, BTP, S/4HANA Cloud | everything               |
   | `702`   | NW 7.02 – 7.4x                                             | portable set, downported |

3. Run `Z2UI5_CL_SMP_APP_000` — the overview app linking every sample of the
   portable set.

#### The learning path

This repository is step 1 of 3. When the basics feel familiar, the other two
sample repositories take you further:

|      | Repository | What you learn | Where to start |
|------|------------|----------------|----------------|
| 1️⃣ | **samples** — 📍 *you are here* | **the abap2UI5 basics** — bindings, events, popups, navigation, complete apps | run `Z2UI5_CL_SMP_APP_000` |
| 2️⃣ | [**samples-controls**](https://github.com/abap2UI5/samples-controls) | **how to use every UI5 control** — the UI5 Demo Kit rebuilt with abap2UI5 | run `z2ui5_cl_dmo_app_overview` |
| 3️⃣ | [**samples-stack**](https://github.com/abap2UI5/samples-stack) | **how abap2UI5 plays with your stack** — OData, RAP, WebSockets, the Fiori Launchpad and more | pick your technology in its package table |

#### What's inside

* **`src/01` "basic"** — cloud-ready, downportable and plain OpenUI5 1.71: the
  sample catalog (bindings, events, popups, framework actions, custom controls
  and use cases) plus a small curated set of control demos — the complete
  control reference lives in
  [samples-controls](https://github.com/abap2UI5/samples-controls). Present on both
  branches.
* **`src/00` "system"** — no demo category: `00/01` holds the helper classes
  the samples share (present on both branches), `00/02` the restricted samples
  (SAPUI5-only controls, features newer than UI5 1.71), `00/97` the
  experimental ones, `00/98` the test and scaffolding apps, `00/99` the retired
  apps. Everything but `00/01` is stripped from `702`.

Every sample runs on ABAP Cloud — that is why `main` needs no cloud-specific
branch. `main` is the default branch and is checked against both ABAP Standard
and ABAP Cloud on every pull request; `702` is generated from `main` on every
push — never commit to it directly.

Layout, naming and code conventions are documented in [AGENTS.md](AGENTS.md) —
read it before contributing.

<details>
<summary><b>CI & checks</b></summary>
<br>

[![abap-standard](https://github.com/abap2UI5/samples/actions/workflows/abap-standard.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/abap-standard.yaml)
[![abap-cloud](https://github.com/abap2UI5/samples/actions/workflows/abap-cloud.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/abap-cloud.yaml)
[![abap-702](https://github.com/abap2UI5/samples/actions/workflows/abap-702.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/abap-702.yaml)
<br>
[![check-abap2UI5](https://github.com/abap2UI5/samples/actions/workflows/check-abap2UI5.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-abap2UI5.yaml)
[![check-rename](https://github.com/abap2UI5/samples/actions/workflows/check-rename.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-rename.yaml)
[![check-docs](https://github.com/abap2UI5/samples/actions/workflows/check-docs.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-docs.yaml)
<br>
[![publish-702](https://github.com/abap2UI5/samples/actions/workflows/publish-702.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-702.yaml)
[![publish-overview](https://github.com/abap2UI5/samples/actions/workflows/publish-overview-apps.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-overview-apps.yaml)

Every pull request is linted against ABAP Standard (`v750`), ABAP Cloud and
7.02 (after the downport), checked with the
[abap2UI5-linter](https://github.com/abap2UI5/linter), and the overview
catalog and docs are verified against the folder tree.

</details>

#### Contributing & Issues

Pull requests are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md). For bug
reports or feature requests, please open an issue in the
[abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
