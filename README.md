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
[![publish-cloud](https://github.com/abap2UI5/samples/actions/workflows/publish-cloud.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-cloud.yaml)
[![publish-702](https://github.com/abap2UI5/samples/actions/workflows/publish-702.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-702.yaml)
[![publish-overview](https://github.com/abap2UI5/samples/actions/workflows/publish-overview-apps.yaml/badge.svg)](https://github.com/abap2UI5/samples/actions/workflows/publish-overview-apps.yaml)

# abap2UI5-samples

More than 340 ready-to-run apps for [abap2UI5](https://github.com/abap2UI5/abap2UI5) — from a two-line Hello World to 1:1 rebuilds of the UI5 demo kit. Over 200 of them are cloud-ready and downportable, so every branch below carries them. Install them, click through, read the source: the fastest way to learn abap2UI5 development.

#### Installation

1. Install [abap2UI5](https://github.com/abap2UI5/abap2UI5) first — this repository ships apps, not the framework.
2. Pull it with abapGit, using the branch that matches your system:

   | Branch     | System                                        | Content                              |
   |------------|-----------------------------------------------|--------------------------------------|
   | `standard` | on-premise, NW 7.50+                          | everything                           |
   | `cloud`    | ABAP Cloud, BTP, S/4HANA Cloud                | cloud-ready subset                   |
   | `702`      | NW 7.02 – 7.4x                                | same subset, downported              |

3. Run `Z2UI5_CL_SMP_APP_000` — the overview app linking every sample of the portable set.

`cloud` and `702` are generated from `standard` on every push; never commit to them directly.

#### What's inside

* **`src/01` "basic"** — cloud-ready, downportable and plain OpenUI5 1.71: framework basics, actions and custom controls, plus the control library rebuilt per UI5 library (`sap.m`, `sap.f`, `sap.uxap`, …). Present on every branch.
* **`src/02` "restricted"** — everything with a catch: SAPUI5-only controls, features newer than UI5 1.71, on-premise-only ABAP, Fiori Launchpad or OData, plus experimental apps. Stripped from `cloud` and `702`.
* **`src/00` "system"** — no demo category: `00/01` holds the helper classes the samples share (present on every branch), `00/98` the test and scaffolding apps, `00/99` the retired apps. Test and obsolete apps are stripped from `cloud` and `702` just like `src/02`.

Layout, naming and code conventions are documented in [AGENTS.md](AGENTS.md) — read it before contributing.

#### Contributing & Issues

Pull requests are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md). For bug reports or feature requests, please open an issue in the [abap2UI5 repository.](https://github.com/abap2UI5/abap2UI5/issues)
