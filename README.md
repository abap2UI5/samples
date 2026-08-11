[![abap version](https://img.shields.io/badge/abap%20version-standard%20%28%E2%89%A5%207.02%29%20%2B%20cloud-blue)](#installation)
[![namespace](https://img.shields.io/badge/namespace-z2ui5__cl__smp-blue)](abaplint.jsonc)
[![dependency](https://img.shields.io/badge/dependency-abap2UI5-blue)](https://github.com/abap2UI5/abap2UI5)
<br>
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

# abap2UI5-samples

More than 340 ready-to-run apps for [abap2UI5](https://github.com/abap2UI5/abap2UI5) — from a two-line Hello World to 1:1 rebuilds of the UI5 demo kit. Over 200 of them are cloud-ready and downportable, so both branches below carry them. Install them, click through, read the source: the fastest way to learn abap2UI5 development.

#### Installation

1. Install [abap2UI5](https://github.com/abap2UI5/abap2UI5) first — this repository ships apps, not the framework.
2. Pull it with abapGit, using the branch that matches your system:

   | Branch  | System                                                        | Content                 |
   |---------|---------------------------------------------------------------|-------------------------|
   | `main`  | on-premise NW 7.50+ **and** ABAP Cloud, BTP, S/4HANA Cloud    | everything              |
   | `702`   | NW 7.02 – 7.4x                                                | portable set, downported |

3. Run `Z2UI5_CL_SMP_APP_000` — the overview app linking every sample of the portable set.

`main` is the default branch and is checked against both ABAP Standard and ABAP Cloud on every pull request. `702` is generated from `main` on every push; never commit to it directly.

#### What's inside

* **`src/01` "basic"** — cloud-ready, downportable and plain OpenUI5 1.71: framework basics, actions and custom controls, plus the control library rebuilt per UI5 library (`sap.m`, `sap.f`, `sap.uxap`, …). Present on both branches.
* **`src/00` "system"** — no demo category: `00/01` holds the helper classes the samples share (present on both branches), `00/02` the restricted samples (SAPUI5-only controls, features newer than UI5 1.71, Fiori Launchpad or OData), `00/97` the experimental ones, `00/98` the test and scaffolding apps, `00/99` the retired apps. Everything but `00/01` is stripped from `702`.

Every sample runs on ABAP Cloud — that is why `main` needs no cloud-specific branch.

Layout, naming and code conventions are documented in [AGENTS.md](AGENTS.md) — read it before contributing.

#### Contributing & Issues

Pull requests are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md). For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
