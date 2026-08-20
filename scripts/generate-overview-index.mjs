#!/usr/bin/env node
/*
 * generate-overview-index - the data behind the overview page in web/.
 *
 * SAMPLES.md answers "what is in this repository" for somebody who scrolls a
 * 97-row table, and the overview app answers it inside a running system. The
 * page in web/ answers the question a newcomer actually arrives with, which is
 * neither: "I have never written an abap2UI5 app - where do I start, and what
 * comes after that". So it is not a search box over a corpus (that is what the
 * sibling repository samples-controls has, and its corpus is a control
 * reference where search IS the question). It is the learning path this
 * repository already is, laid out in the order somebody walks it.
 *
 * Only `src/01` is on it. src/00/97 is unfinished and src/00/98 is run by a
 * check rather than learned from (AGENTS.md section 2), and both are stripped
 * from the 702 branch - a page that teaches must not lead anybody into them.
 * The ZZZ helpers are out for the same reason they carry no tile: a helper is
 * reached BY a sample, never started on its own. They do come back as the
 * extra `?src=` files a playground link needs (see `deps` below).
 *
 * Everything the page shows about a sample comes from the same scan the
 * overview app and SAMPLES.md are generated from (scripts/lib/scan-samples.mjs)
 * - title, summary, keywords, documentation chapters - so the three cannot
 * disagree about what this repository contains. The one thing the scan cannot
 * know is the teaching order, which is in scripts/lib/learning-path.json.
 *
 *   node scripts/generate-overview-index.mjs           write web/apps.json
 *   node scripts/generate-overview-index.mjs --check   validate, write nothing
 *   node scripts/generate-overview-index.mjs --out X   write it elsewhere
 *
 * NOT committed - web/apps.json is a build output like any bundle: the deploy
 * workflow regenerates it on every push, so it is never staler than the tree it
 * describes, and a sample PR does not carry a diff of derived data. `--check`
 * is what CI runs: it holds the two rules that CAN go wrong in a pull request
 * (a category with no stage, a stage naming a category nobody uses) without
 * needing the output.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { ROOT, SRC, scanSamples } from './lib/scan-samples.mjs';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const CHECK = process.argv.includes('--check');
const argOut = process.argv.indexOf('--out');
const OUT = argOut === -1
  ? path.join(ROOT, 'web', 'apps.json')
  : path.resolve(process.argv[argOut + 1]);

/* The repository the source links point into. The page is built from main, so
 * that is the ref both the blob links and the raw links the playground fetches
 * have to follow. */
const REPO = 'abap2UI5/samples';
const REF = 'main';
const SOURCE = `https://github.com/${REPO}/blob/${REF}/`;
const RAW = `https://raw.githubusercontent.com/${REPO}/${REF}/`;

/* Where a class can be opened and run without a system at all. `?src=` takes
 * raw GitHub URLs and starts the class in the FIRST one (playground
 * src/shell/deep-link.mjs), which is why `deps` below is ordered app-first. */
const PLAYGROUND = 'https://abap2ui5.github.io/playground/';

const DOCS_SITE = 'https://abap2ui5.github.io/docs/';

/* --------------------------------------------------------- the class index */

/** Every ABAP class in the tree, lowercase name -> repository-relative file.
 *  Not the scan: this has to see the ZZZ helpers too, because those are what
 *  a sample REFERENCES. */
function classIndex() {
  const index = {};
  const walk = (dir) => {
    for (const name of fs.readdirSync(dir)) {
      const full = path.join(dir, name);
      if (fs.statSync(full).isDirectory()) walk(full);
      else if (name.endsWith('.clas.abap')) {
        index[path.basename(name, '.clas.abap').toLowerCase()] = path
          .relative(ROOT, full).split(path.sep).join('/');
      }
    }
  };
  walk(SRC);
  return index;
}

/** The other classes a sample needs to actually run, app first.
 *
 *  A sample is one class - except when it is not: `nav_app_call` starts a
 *  second app, a value help reads a shared context class, and half of a
 *  navigation demo is the app it navigates to. Passing only the first file to
 *  the playground opens something that dies on the first click, so every
 *  `z2ui5_cl_smp*` class the source names is collected, transitively, and
 *  becomes another `?src=`. Framework classes (z2ui5_cl_ajson, z2ui5_cl_util,
 *  the view builder) are not collected - the playground bundles abap2UI5
 *  itself, and linking them would be linking the framework twice.
 */
function dependencies(cls, index) {
  const seen = new Set([cls]);
  const queue = [cls];
  const files = [];
  while (queue.length) {
    const current = queue.shift();
    files.push(index[current]);
    const source = fs.readFileSync(path.join(ROOT, index[current]), 'utf8');
    const named = new Set((source.match(/z2ui5_cl_smp[a-z0-9_]*/gi) || []).map((n) => n.toLowerCase()));
    for (const name of [...named].sort()) {
      if (seen.has(name) || !index[name]) continue;
      seen.add(name);
      queue.push(name);
    }
  }
  return files;
}

/* ------------------------------------------------------------ the ordering */

const ROMAN = { I: 1, V: 5, X: 10, L: 50, C: 100, D: 500, M: 1000 };

/** The value of a trailing Roman numeral, or null - `Basics IV` -> 4.
 *  Where a series exists the numeral IS the reading order, and sorting
 *  `Basics IX` after `Basics VIII` alphabetically only works by accident. */
function step(header) {
  const last = header.split(' ').pop();
  if (!/^[IVXLCDM]+$/.test(last) || header.split(' ').length < 2) return null;
  let total = 0;
  for (let i = 0; i < last.length; i++) {
    const value = ROMAN[last[i]];
    total += value < ROMAN[last[i + 1]] ? -value : value;
  }
  return total;
}

/** A gate says what is wrong and stops. A stack trace over a missing entry in
 *  an editorial JSON file only buries the sentence that says what to do. */
function fail(message) {
  console.error(message);
  process.exit(1);
}

/* ------------------------------------------------------------------- build */

const { areas } = scanSamples();
const tiles = areas['01'];
const index = classIndex();

const byCategory = new Map();
for (const tile of tiles) {
  if (!byCategory.has(tile.base)) byCategory.set(tile.base, []);
  byCategory.get(tile.base).push(tile);
}
for (const list of byCategory.values()) {
  list.sort((a, b) => (step(a.header) ?? 0) - (step(b.header) ?? 0)
    || a.header.localeCompare(b.header)
    || a.sub.localeCompare(b.sub));
}

const pathFile = path.join(HERE, 'lib', 'learning-path.json');
const { stages } = JSON.parse(fs.readFileSync(pathFile, 'utf8'));

/* The two rules that keep the page from drifting away from the tree, and the
 * reason this generator has a `--check` mode at all. Both failures are silent
 * otherwise: a new category would simply not be on the page, and a renamed one
 * would leave a heading with nothing under it. */
const placed = new Map();
for (const stage of stages) {
  for (const name of stage.categories) {
    if (placed.has(name)) {
      fail(`category "${name}" is in two stages (${placed.get(name)} and ${stage.id}) — scripts/lib/learning-path.json`);
    }
    placed.set(name, stage.id);
    if (!byCategory.has(name)) {
      fail(`stage "${stage.id}" names category "${name}", which no sample in src/01 carries.\n`
        + 'Drop it from scripts/lib/learning-path.json, or put the category back on a sample\'s DESCRIPT.');
    }
  }
}
const unplaced = [...byCategory.keys()].filter((name) => !placed.has(name));
if (unplaced.length) {
  fail(
    `${unplaced.length} categor${unplaced.length === 1 ? 'y belongs' : 'ies belong'} to no stage of the learning path: ${unplaced.join(', ')}\n`
    + `Add ${unplaced.length === 1 ? 'it' : 'them'} to scripts/lib/learning-path.json — a category with no stage is a sample nobody on the page can reach.`,
  );
}

const sample = (tile) => {
  const deps = dependencies(tile.app, index);
  return {
    class: tile.app,
    title: tile.header,
    step: step(tile.header),
    what: tile.sub,
    summary: tile.summary,
    keywords: tile.keywords ? tile.keywords.split(/\s+/) : [],
    docs: tile.docs.map((url) => ({ chapter: url.replace(DOCS_SITE, ''), url })),
    file: deps[0],
    /* the extra files the playground needs, app first and without it */
    deps: deps.slice(1),
  };
};

const data = {
  repo: REPO,
  source: SOURCE,
  raw: RAW,
  playground: PLAYGROUND,
  docsSite: DOCS_SITE,
  overviewApp: 'z2ui5_cl_smp_app_000',
  counts: {
    samples: tiles.length,
    categories: byCategory.size,
    stages: stages.length,
  },
  stages: stages.map((stage) => ({
    id: stage.id,
    title: stage.title,
    blurb: stage.blurb,
    categories: stage.categories.map((name) => ({
      name,
      samples: byCategory.get(name).map(sample),
    })),
  })),
};

/* A link that 404s is reproduced by a regeneration as faithfully as a working
 * one, so the files are checked to exist rather than trusted. */
for (const stage of data.stages) {
  for (const category of stage.categories) {
    for (const entry of category.samples) {
      for (const file of [entry.file, ...entry.deps]) {
        if (!fs.existsSync(path.join(ROOT, file))) fail(`link would 404: ${file}`);
      }
    }
  }
}

const listed = data.stages.flatMap((s) => s.categories.flatMap((c) => c.samples)).length;
if (listed !== tiles.length) fail(`${tiles.length} samples scanned, ${listed} on the page`);

const summary = `${listed} samples · ${byCategory.size} categories · ${stages.length} stages`;
if (CHECK) {
  console.log(`overview-index: the learning path covers src/01 — ${summary}`);
} else {
  fs.mkdirSync(path.dirname(OUT), { recursive: true });
  fs.writeFileSync(OUT, `${JSON.stringify(data, null, 1)}\n`);
  console.log(`${path.relative(ROOT, OUT)}: ${summary}`);
}
