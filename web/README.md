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

## The bar at the top is shared, and so is the strip at the bottom

Three repositories publish three pages that answer three different questions,
and until now only one of them said so. A reader who arrived on
[samples-controls](https://abap2ui5.github.io/samples-controls/) — the biggest
of the three, and the likeliest thing a search engine hands somebody — was
told nothing about the other two.

Two blocks fix that, and both are **identical in all three repositories**:

| | |
|---|---|
| `<nav class="family">` | above the masthead: *Learn · Controls · Stack*, the current one marked with `aria-current`, and the playground and the documentation set apart on the right as the tools they are |
| `<section class="three">` | before the footer: one card per page with the question it answers, because the end of a page is where a reader who is done with it arrives |

They carry verbs rather than repository names — `samples-controls` tells a
newcomer nothing, *Controls / every UI5 control, searchable* tells them
everything — and the repository name lives in the `title` attribute and the
footer instead. There is no numbering: *step 3 of 3* used to be on the
samples-stack page and claimed an order that does not hold, since Controls is
a reference you come back to rather than a step you finish.

Three repositories cannot share a file at run time without one page fetching
something from another host, which is exactly what these pages avoid, so the
blocks are **copied**. That is already the practice here — the design tokens
in `samples-stack` are a declared copy of the ones in `samples-controls` — and
`npm run check:family-nav` is what keeps the copies honest: it fails when a
subtitle is reworded on one page only, when the *you are here* marker is left
on whichever page was copied from, when a sibling drops out of the footer, or
when anything links `…/samples-controls/search/` again, which has been a 404
since that catalogue moved to the root of its site.

The styles sit at the end of `overview.css` between the same markers and read
three tokens this page sets in `:root` — `--family-width`, `--family-gutter`
and `--family-bleed`. Those three are the *only* thing the copies are allowed
to differ in, because the three pages are built around containers of different
widths.

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
