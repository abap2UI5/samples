[![ABAP NW 7.02 to ABAP Cloud](https://img.shields.io/badge/ABAP-NW%207.02%20%E2%86%92%20Cloud-blue)](#try-it-in-60-seconds)
[![namespace](https://img.shields.io/badge/namespace-z2ui5__cl__smp-blue)](abaplint.jsonc)
[![abap2UI5](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fabap2UI5%2Fsamples%2Fmain%2F.github%2Fbadges%2Fabap2ui5.json)](#the-learning-path)
<br><br>
[![abap-standard](https://github.com/abap2UI5/samples/actions/workflows/abap-standard.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/abap-standard.yaml)
[![abap-cloud](https://github.com/abap2UI5/samples/actions/workflows/abap-cloud.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/abap-cloud.yaml)
[![abap-702](https://github.com/abap2UI5/samples/actions/workflows/abap-702.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/abap-702.yaml)
<br>
[![check-abap2UI5](https://img.shields.io/endpoint?url=https%3A%2F%2Fraw.githubusercontent.com%2Fabap2UI5%2Fsamples%2Fmain%2F.github%2Fbadges%2Fcheck-abap2ui5.json)](https://github.com/abap2UI5/samples/actions/workflows/check-abap2UI5.yaml)
[![check-app-rules](https://github.com/abap2UI5/samples/actions/workflows/check-app-rules.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-app-rules.yaml)
[![check-rename](https://github.com/abap2UI5/samples/actions/workflows/check-rename.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-rename.yaml)
<br>
[![check-docs](https://github.com/abap2UI5/samples/actions/workflows/check-docs.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-docs.yaml)
[![check-docs-links](https://github.com/abap2UI5/samples/actions/workflows/check-docs-links.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-docs-links.yaml)
[![check-keywords](https://github.com/abap2UI5/samples/actions/workflows/check-keywords.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/check-keywords.yaml)
<br>
[![publish-702](https://github.com/abap2UI5/samples/actions/workflows/publish-702.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-702.yaml)
[![publish-overview](https://github.com/abap2UI5/samples/actions/workflows/publish-overview-apps.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-overview-apps.yaml)

# abap2UI5 — samples

**Learn the abap2UI5 basics — 105 ready-to-run apps, from a two-line Hello
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

Every sample is `Z2UI5_CL_SMP_APP_<no>`, and you start it with
`?app_start=z2ui5_cl_smp_app_<no>`. **The number alone does not name a sample:
each of the three repositories numbers from its own sequence, and the class
prefix is what says which one you mean** — `Z2UI5_CL_SMP_APP_493` is the Hello
World here, while `Z2UI5_CL_SMPS_APP_493` in
[samples-stack](https://github.com/abap2UI5/samples-stack) is a FilterBar with
variant management. So the catalogue always gives you the class, not a number.

No system at hand? **[The sample path](https://abap2ui5.github.io/samples/) is
this catalogue as a page** — the samples in the order they are meant to be read
in, six stages from the smallest app that runs to files, devices and custom
CSS. Every card opens the source, or starts the class in the
[playground](https://abap2ui5.github.io/playground/) with nothing installed at
all. [SAMPLES.md](SAMPLES.md) is the same catalogue to scroll and `Ctrl+F`.
Both are generated from the tree, so both are what is actually here.

#### The learning path

This repository is step 1 of 3. When the basics feel familiar, the other two
sample repositories take you further:

|      | Repository | What you learn | Where to start |
|------|------------|----------------|----------------|
| 1️⃣ | **samples** — 📍 *you are here* | **the abap2UI5 basics** — bindings, events, popups, navigation, complete apps | run `Z2UI5_CL_SMP_APP_000`, or follow [the sample path](https://abap2ui5.github.io/samples/) |
| 2️⃣ | [**samples-controls**](https://github.com/abap2UI5/samples-controls) | **how to use every UI5 control** — the UI5 Demo Kit rebuilt with abap2UI5 | run `z2ui5_cl_smpc_app_000` |
| 3️⃣ | [**samples-stack**](https://github.com/abap2UI5/samples-stack) | **how abap2UI5 plays with your stack** — OData, RAP, WebSockets, the Fiori Launchpad and more | pick your technology in its package table |

#### What's inside

* **`src/01` "samples"** — cloud-ready, downportable and plain OpenUI5 1.71: the
  sample catalog (bindings, events, popups, framework actions, custom controls
  and use cases) plus a small curated set of control demos — the complete
  control reference lives in
  [samples-controls](https://github.com/abap2UI5/samples-controls). Present on both
  branches.
* **`src/00` "system"** — no demo category: `00/97` holds the experimental
  samples and `00/98` the test and scaffolding apps. Both are stripped from
  `702`. There are no shared helper classes — every sample is self-contained.

Every sample runs on ABAP Cloud — that is why `main` needs no cloud-specific
branch. `main` is the default branch and is checked against both ABAP Standard
and ABAP Cloud on every pull request; `702` is generated from `main` on every
push — never commit to it directly.

Layout, naming and code conventions are documented in [AGENTS.md](AGENTS.md) —
read it before contributing.

Every pull request is linted against ABAP Standard (`v750`), ABAP Cloud and
7.02 (after the downport), checked with the
[abap2UI5-linter](https://github.com/abap2UI5/linter), and the overview
catalog, [SAMPLES.md](SAMPLES.md) and the docs are verified against the folder
tree.


#### Contributing & Issues

Pull requests are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md). For bug
reports or feature requests, please open an issue in the
[abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
