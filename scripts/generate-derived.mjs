#!/usr/bin/env node
/*
 * generate-derived — catalogue-derived.json, what the LINTER knows about each
 * sample, beside what catalogue.json says the tree holds.
 *
 * One question the tree cannot answer, and so catalogue.json cannot either:
 *
 *   "which sample shows sap.m.Table at all?"
 *
 * A sample's category is what it is FILED under and its `@keywords` are what
 * somebody thought to write down; neither is the list of controls the view
 * actually builds. The other half is the same question the other way round:
 *
 *   "my system runs UI5 1.84 — will this sample render on it?"
 *
 * These samples are held to the same 1.71 floor the framework is, so the
 * answer is 1.71 for almost all of them — but "almost" is the reason to
 * derive it rather than assume it.
 *
 * Both come out of @abap2ui5/linter, which reconstructs the view a builder
 * chain produces and resolves every control against the UI5 metadata
 * snapshot. It is asked for two things it computes anyway:
 *
 *   stats.types            every control the sample BUILDS, with occurrences
 *   `*-too-new` findings   everything above the floor, each carrying `since`
 *
 * The highest of those `since` values IS the sample's minimum UI5 release,
 * and the floor itself when there are none.
 *
 * WHY IT IS A SECOND FILE. Everything committed-fact about a sample — class,
 * file, category, stage, title, description, summary, keywords, docs — is in
 * catalogue.json already, and that file is generated offline and
 * dependency-free on purpose. This one carries ONLY the derived facts, keyed
 * by `class`: a consumer joins the two on that key. Both are generated from
 * one scan of one tree, so they cannot disagree about which samples exist.
 *
 * Which UI5 LIBRARY each control ships in is deliberately not answered here.
 * That is one taxonomy question, and answering it in three sample
 * repositories would be three copies of a prefix table that drift; the
 * consumer that needs it — the playground's catalogue, which has to decide
 * "does this render on the build I carry" — owns the mapping. Identical
 * reasoning, and an identical file shape, in abap2UI5/samples-controls and
 * abap2UI5/samples-stack.
 *
 * COMMITTED, and read from raw.githubusercontent.com by the playground's
 * deploy, which serves committed files only.
 *
 *   node scripts/generate-derived.mjs          write catalogue-derived.json
 *   node scripts/generate-derived.mjs --check  fail if it is stale (CI)
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { checkAbapSource } from '@abap2ui5/linter';
import { scanSamples } from './lib/scan-samples.mjs';

const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.join(HERE, '..');
const OUT = path.join(ROOT, 'catalogue-derived.json');
const CHECK = process.argv.includes('--check');

/** The floor this repository holds every sample to — and the answer for a
 *  sample that needs nothing newer. */
const MIN_UI5 = '1.71';

/** The repository a consumer joins this against. */
const REPO = 'abap2UI5/samples';
const REF = 'main';

/** Compare two dotted UI5 versions numerically ("1.9" < "1.71" < "1.120"). */
function cmpVersion(a, b) {
  const pa = String(a).split('.').map(Number);
  const pb = String(b).split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const d = (pa[i] || 0) - (pb[i] || 0);
    if (d) return d;
  }
  return 0;
}

/** "1.77.0" / "1.77" -> "1.77" — the minor is what a system is called by. */
const shortVersion = (v) => String(v).split('.').slice(0, 2).join('.');

/* ---------------------------------------------------------------- collect */

/* src/01 only, the same set catalogue.json and the learning path carry: src/00
 * is the generated downport of it, so linting both would mean every sample
 * twice under two class names. */
const { areas } = scanSamples();
const tiles = areas['01'];

const controlIds = new Map();          // control name -> index in `controls`
const idOf = (name) => {
  if (!controlIds.has(name)) controlIds.set(name, controlIds.size);
  return controlIds.get(name);
};

const samples = [];
let failed = 0;

for (const tile of tiles) {
  const rel = `src/01/${tile.app}.clas.abap`;
  const file = path.join(ROOT, rel);
  if (!fs.existsSync(file)) {
    console.error(`generate-derived: ${rel} is not on disk — the scan and the tree disagree`);
    process.exit(1);
  }
  const source = fs.readFileSync(file, 'utf8');

  /* A class the linter cannot reconstruct still gets an entry — it loses only
   * the derived facts, which is better than dropping a sample out of the
   * index over a parse, and `note` says what happened. */
  let types = {};
  let tooNew = [];
  let usesBuilder = false;
  let note = null;
  try {
    const r = checkAbapSource(source, { minUi5: MIN_UI5, render: false, file: rel });
    usesBuilder = !!r.usesBuilder;
    types = r.stats?.types || {};
    tooNew = r.findings
      .filter((f) => /-too-new$/.test(f.type) && f.since)
      .map((f) => ({
        type: f.type,
        name: [f.control, f.member, f.value].filter(Boolean).join('.') || f.type,
        since: shortVersion(f.since),
      }));
  } catch (err) {
    failed++;
    note = `linter: ${err.message}`;
  }

  const minUi5 = tooNew.reduce(
    (acc, f) => (cmpVersion(f.since, acc) > 0 ? f.since : acc),
    MIN_UI5,
  );
  const controls = Object.keys(types).sort();

  samples.push({
    /* The key a consumer joins catalogue.json on. */
    class: tile.app,
    minUi5,
    /* What made it that release — so a filter result can be argued with
     * rather than only believed. */
    needs: tooNew.sort((a, b) => cmpVersion(b.since, a.since) || a.name.localeCompare(b.name)),
    controls: controls.map(idOf),
    controlCount: Object.values(types).reduce((a, b) => a + b, 0),
    /* A sample the linter found no builder chain in built nothing as far as
     * this file knows, and a consumer must not read that as "builds no
     * controls". Several samples here are deliberately not view code at all. */
    ...(usesBuilder ? {} : { noChain: true }),
    ...(note ? { note } : {}),
  });
}

/* ------------------------------------------------------------------ write */

const controls = [...controlIds.keys()];
const releases = [...new Set(samples.map((s) => s.minUi5))].sort(cmpVersion);

const top = {
  note: 'Generated by scripts/generate-derived.mjs. What the linter knows about each sample; '
    + 'the committed facts are in catalogue.json, joined on `class`. Do not hand-edit.',
  repo: REPO,
  ref: REF,
  catalogue: `https://raw.githubusercontent.com/${REPO}/${REF}/catalogue.json`,
  minUi5: MIN_UI5,
  releases,
  /* One dictionary, referenced by index from every sample: the same control
   * names would otherwise be repeated a hundred times. */
  controls,
  counts: { samples: samples.length, controls: controls.length },
};

/* One line per sample, so a sample PR diffs as one changed line — the same
 * reason catalogue.json and SAMPLES.md are one row per sample. */
const head = JSON.stringify(top, null, 2);
const body = samples
  .sort((a, b) => a.class.localeCompare(b.class))
  .map((s) => `    ${JSON.stringify(s)}`)
  .join(',\n');
const page = `${head.slice(0, -2)},\n  "samples": [\n${body}\n  ]\n}\n`;

if (CHECK) {
  const current = fs.existsSync(OUT) ? fs.readFileSync(OUT, 'utf8') : '';
  if (current !== page) {
    console.error('catalogue-derived.json is stale — run `npm run derived` and commit the result.');
    process.exit(1);
  }
  console.log(`catalogue-derived.json: current (${samples.length} samples)`);
} else {
  fs.writeFileSync(OUT, page);
  const size = (fs.statSync(OUT).size / 1024).toFixed(0);
  console.log(
    `catalogue-derived.json: ${samples.length} samples, ${controls.length} controls, `
    + `releases ${releases[0]}–${releases[releases.length - 1]} (${size} KB)`,
  );
}
if (failed) console.error(`generate-derived: ${failed} sample(s) the linter could not reconstruct — see \`note\``);
