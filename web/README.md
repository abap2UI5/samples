# `web/` — the overview page

The learning path of this repository as a page, for somebody who has not
installed anything yet: **https://abap2ui5.github.io/samples/** (published by
the `deploy-web` workflow, which needs *Settings → Pages → Source =
GitHub Actions*).

It is the third view of the same catalogue, and the three are generated from
one scan (`scripts/lib/scan-samples.mjs`) so they cannot disagree:

| Where | For whom |
|---|---|
| `Z2UI5_CL_SMP_APP_000`, the overview app | somebody who has the repository in a system |
| [`SAMPLES.md`](../SAMPLES.md) | somebody reading the repository on GitHub |
| this page | somebody who has not installed anything and is asking where to start |

## What is in here

| File | |
|---|---|
| `index.html` | the page — one file, no framework |
| `overview.css` | one stylesheet, light and dark |
| `overview.js` | draws the path, narrows it on a search, remembers what you ticked (`localStorage`, this browser only) |
| `apps.json` | **generated, not committed** — `node scripts/generate-overview-index.mjs` |

Only `src/01` is on the page: the portable set that survives every build.
`src/00/97` is unfinished and `src/00/98` is run by a check rather than learned
from, and a page that teaches must not lead anybody into either.

## Working on it

```
node scripts/generate-overview-index.mjs     # writes web/apps.json
python3 -m http.server 8000 --directory web  # any static server will do
```

`file://` does not work — the page `fetch`es `apps.json`.

The **order** the samples are in is the one thing not derived from the tree:
it is a teaching decision and lives in `scripts/lib/learning-path.json`, which
assigns every category to a stage. `npm run check:overview` fails when a
category has no stage or a stage names a category nobody uses, so a new sample
category cannot quietly fall off the page.
