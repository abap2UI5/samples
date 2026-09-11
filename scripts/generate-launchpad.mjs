#!/usr/bin/env node
/*
 * Generates the overview app's catalog from the folder tree.
 * (This is the smp_app_000 index page. It has nothing to do with the Fiori
 * Launchpad - those demos live in abap2UI5/samples-stack, src/09.)
 *
 * Note: only src/01 has an overview app. Everything under src/00 - the
 * experimental (src/00/97) and testing (src/00/98) samples - is reported but
 * not listed in any app. SAMPLES.md lists it, which is what
 * scripts/generate-samples-md.mjs is for; both read the same scan
 * (scripts/lib/scan-samples.mjs), so the app and the markdown can never
 * disagree about what this repository contains.
 *
 * Job (see AGENTS.md section 4): scan every demo app class under src/, derive
 * a tile from its abapGit <DESCRIPT> and its comment lines (that is
 * scan-samples.mjs), then rewrite the result = VALUE #( ... ) block of
 * get_catalog( ) in the overview app of the area (src/01 -> smp_app_000):
 *   - one group per stage of the learning path (lib/learning-path.json), in
 *     the order somebody learns them - the same stages catalogue.json
 *     publishes and the sample catalogue page draws, so the app in the system
 *     reads like the page and not like a flat list of 100 rows,
 *   - the first tile of a group carries the stage's blurb (`intro`), which
 *     the app renders once under the group title,
 *   - tiles within a group sorted by header, then sub, then app.
 * Apps whose header is "ZZZ" are helper apps (called only by other apps) and
 * are skipped. The `@summary` line of the overview app is written here too,
 * with the live count, so it cannot say "149" while the tree holds 104.
 *
 * No dependencies. Run:  node scripts/generate-launchpad.mjs   (or: npm run launchpad)
 * Afterwards run abaplint (must be 0 issues).
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { SRC, scanSamples } from './lib/scan-samples.mjs';
import { loadLearningPath } from './lib/learning-path.mjs';
import { markersLine } from './lib/markers.mjs';

const HERE = path.dirname(fileURLToPath(import.meta.url));

/* `--check` renders exactly the same catalog and compares it instead of
 * writing it, so `npm run check` can hold what the publish-overview-apps
 * workflow holds without rewriting the tree while it does so. Same code path,
 * one branch at the end: a check that regenerated differently from the
 * generator would be worse than none. */
const CHECK = process.argv.includes('--check');
const stale = [];

// area (top-level package under src) -> overview app file. Every area listed
// here must have its overview app in the tree - a missing file is an error,
// not something to skip, because it means the catalog stops being generated.
// src/00 is deliberately absent: the experimental (src/00/97) and testing
// (src/00/98) samples have no overview app since the extended samples were
// reorganised, so their tiles are counted but listed nowhere. Add an entry back
// here the day an extended overview returns.
const TARGETS = {
  '01': path.join(SRC, 'z2ui5_cl_smp_app_000.clas.abap'),
};

// --- 1. scan --------------------------------------------------------------
const { areas: tiles, hidden } = scanSamples();

/* --- 1b. the learning path decides the groups ------------------------------
 * The scan groups a tile by the CTEXT of the package it lives in, which for
 * src/01 is one package - "samples" - so the app used to render every sample
 * under no heading at all, while SAMPLES.md and the catalogue page had six
 * named stages and 24 categories to read by. The stage is the group here: the
 * title the reader sees, in the teaching order, with the stage's blurb on the
 * first tile so the app can say what the group is for. The category stays
 * where it was, in the header - `Basics I`, `Table III` - which is what the
 * blocks inside a group are made of (block_base in the app). */
const fail = (message) => {
  console.error(`launchpad: ${message}`);
  process.exit(1);
};
{
  const list = tiles['01'] ?? [];
  const { stages, stageOf } = loadLearningPath(list, fail);
  const rank = new Map(stages.map((stage, i) => [stage.id, i]));
  for (const tile of list) tile.stage = stageOf(tile.base);
  // a stable sort by stage keeps the scan's header/sub/app order inside a stage
  list.sort((a, b) => rank.get(a.stage.id) - rank.get(b.stage.id));
  let previous = null;
  for (const tile of list) {
    tile.group = tile.stage.title;
    tile.intro = tile.stage !== previous ? tile.stage.blurb : '';
    previous = tile.stage;
  }
}

// --- 2. rewrite get_catalog( ) -------------------------------------------
function rewrite(file, list) {
  let text = fs.readFileSync(file, 'utf8');

  const open = text.indexOf('result = VALUE #(');
  const close = text.indexOf(') ).', open);
  if (open === -1 || close === -1) throw new Error(`no VALUE block in ${file}`);

  // indentation of the tiles = indent of "result" line + 2 spaces
  const indent = ' '.repeat((text.slice(0, open).match(/\n( *)$/) || [, ''])[1].length + 2);

  // ABAP sources are limited to 255 characters per line — longer lines break
  // the abapGit import ("Literals across more than one line are not allowed")
  const MAX_LINE = 255;
  // one field on its own line(s), the literal split into && chunks so no line
  // exceeds the limit; continuation lines align under the opening backtick
  const chunked = (name, value, fieldIndent) => {
    const first = `${fieldIndent}${name} = `;
    const contIndent = ' '.repeat(first.length);
    const chunkSize = MAX_LINE - contIndent.length - 6;
    const chunks = [];
    for (let s = value; s.length; s = s.slice(chunkSize)) chunks.push(s.slice(0, chunkSize));
    if (chunks.length === 0) chunks.push('');
    return chunks.map((c, i) =>
      `${i === 0 ? first : contIndent}\`${c}\`${i < chunks.length - 1 ? ' &&' : ''}`);
  };
  const rows = list.map((t) => {
    const kw = t.keywords ? ` keywords = \`${t.keywords}\`` : '';
    const one = `${indent}( group = \`${t.group}\` header = \`${t.header}\` sub = \`${t.sub}\`${kw} path = \`${t.path}\` app = \`${t.app}\` )`;
    // the blurb is a paragraph, never on the one-line shape
    if (one.length <= MAX_LINE && !t.intro) return one;
    const fieldIndent = `${indent}  `;
    return [
      `${indent}( group = \`${t.group}\` header = \`${t.header}\``,
      ...chunked('sub', t.sub, fieldIndent),
      ...(t.keywords ? chunked('keywords', t.keywords, fieldIndent) : []),
      ...(t.intro ? chunked('intro', t.intro, fieldIndent) : []),
      `${fieldIndent}path = \`${t.path}\` app = \`${t.app}\` )`,
    ].join('\n');
  });
  // the last row additionally closes the constructor + statement
  rows[rows.length - 1] += ' ).';

  const block = `result = VALUE #(\n${rows.join('\n')}`;
  let next = text.slice(0, open) + block + text.slice(close + ') ).'.length);

  /* The app's own @summary line - the sentence SAMPLES.md, catalogue.json and
   * the sample catalogue page put under its title - carries the count of what
   * it lists. Written here, from the list, because a hand-written number on
   * the one class that is generated anyway is the number that goes stale. */
  const summary = `" @summary Every sample in this repository as a searchable list, grouped along the learning path - the app the other ${list.length} are reached from.`;
  if (!/^" @summary .*$/m.test(next)) throw new Error(`no @summary line in ${file}`);
  next = next.replace(/^" @summary .*$/m, summary);

  /* And the legend of the capability markers some titles end in, rendered by
   * the app under its list - one source (lib/markers.mjs) for every view of
   * the catalogue. */
  const legend = `    CONSTANTS c_legend TYPE string VALUE \`Markers on a title: ${markersLine()}\`.`;
  if (legend.length > MAX_LINE) throw new Error('the marker legend no longer fits one ABAP line - shorten lib/markers.mjs');
  if (!/^ {4}CONSTANTS c_legend TYPE string VALUE `.*`\.$/m.test(next)) {
    throw new Error(`no c_legend constant to write the marker legend into in ${file}`);
  }
  next = next.replace(/^ {4}CONSTANTS c_legend TYPE string VALUE `.*`\.$/m, legend);

  if (!CHECK) { fs.writeFileSync(file, next); return; }
  if (next !== text) stale.push(path.relative(path.join(HERE, '..'), file));
}

/* A TILE without `@keywords` is a tile nobody can find.
 *
 * DESCRIPT caps the short text at 60 characters, so it carries the name of the
 * thing and little else; `@keywords` is where the words a newcomer actually
 * types go ("f4 search help suggestion input"). Three readers use them - the
 * overview app's search box, `Ctrl+F` on SAMPLES.md, and an agent asking
 * whether a sample for X exists - and all three degrade the same silent way:
 * the sample is still listed, still correct, and simply never comes up.
 *
 * Scoped to the areas that HAVE an overview app, because that is what a tile
 * is. The ZZZ helpers are already out (scanSamples flags them): a helper is
 * reached BY another sample, never looked up, so search terms for it would be
 * words nobody will type. */
for (const [area, list] of Object.entries(tiles)) {
  if (!TARGETS[area]) continue;
  const unsearchable = list.filter((t) => !t.keywords);
  if (unsearchable.length) {
    console.error(`${unsearchable.length} tile(s) in src/${area} carry no \` @keywords\` line, so nothing can find them:`);
    for (const t of unsearchable) console.error(`  ${t.app}  (${t.header})`);
    console.error('\nAdd it as the FIRST line of the class (AGENTS.md section 4, tile schema):');
    console.error('  " @keywords <words a newcomer would type, lowercase, space separated>');
    process.exit(1);
  }
}

/* And a tile without `" @summary` is one nobody can CHOOSE.
 *
 * Being findable and being recognisable are two different failures. The
 * keywords put a sample in front of somebody; the summary is what tells them
 * whether it is the one they want, and until it existed the answer was a
 * 60-character short text ("Popup - change a popup control from the backend")
 * that names the thing and stops. The same three readers are affected - the
 * overview app, SAMPLES.md, an agent through abap2UI5/mcp-server - and here the
 * degradation is not silence but a wrong guess, which costs more.
 *
 * Written, not generated. abap2UI5/samples-controls fetches the sentence from
 * the demo kit and samples-stack derives half of its metadata; here there is
 * no upstream to quote, so the line is the author's. That is exactly why it
 * needs a gate: nothing else fails when it is missing. */
for (const [area, list] of Object.entries(tiles)) {
  if (!TARGETS[area]) continue;
  const unrecognisable = list.filter((t) => !t.summary);
  if (unrecognisable.length) {
    console.error(`${unrecognisable.length} tile(s) in src/${area} carry no \` @summary\` line, so nothing says what they show:`);
    for (const t of unrecognisable) console.error(`  ${t.app}  (${t.header})`);
    console.error('\nAdd it under the @keywords line (AGENTS.md section 4, tile schema):');
    console.error('  " @summary <one sentence: what this sample SHOWS, not which controls it uses>');
    process.exit(1);
  }
}

/* The two lines travel together, everywhere - including where there is no
 * tile. src/00/97 has no overview app, and its six experimental samples still
 * carry both lines because they are documented samples that people are sent
 * to from the cookbook. A class with one line and not the other is the state
 * nobody chose: it means an author added a sample the way the last one looked
 * and stopped halfway. (The ZZZ helpers are out of this by construction -
 * `scanSamples` flags them, and a helper is reached BY a sample, never looked
 * up.) */
const halfDone = Object.values(tiles).flat()
  .filter((t) => Boolean(t.keywords) !== Boolean(t.summary));
if (halfDone.length) {
  console.error(`${halfDone.length} sample(s) carry one search line but not the other:`);
  for (const t of halfDone) {
    console.error(`  ${t.app}  (${t.header}) — has ${t.keywords ? '@keywords, no @summary' : '@summary, no @keywords'}`);
  }
  console.error('\nBoth or neither: they answer the two halves of one question.');
  process.exit(1);
}

let total = 0;
for (const [area, list] of Object.entries(tiles)) {
  const file = TARGETS[area];
  // an area with no overview app has no catalog to mirror - report what it
  // holds so the tiles are not silently lost sight of
  if (!file) {
    console.log(`src/${area}: no overview app, ${list.length} tiles not listed`);
    continue;
  }
  rewrite(file, list);
  console.log(`${path.relative(path.join(HERE, '..'), file)}: ${list.length} tiles`);
  total += list.length;
}
if (CHECK) {
  if (stale.length) {
    console.error(`the overview catalog no longer mirrors the folder tree:\n  ${stale.join('\n  ')}`);
    console.error('\nRun `npm run launchpad` and commit the result (AGENTS.md section 4).');
    process.exit(1);
  }
  console.log(`launchpad: up to date — ${total} tile(s), ${hidden.length} ZZZ helper app(s) hidden`);
} else {
  console.log(`generated ${total} tiles, ${hidden.length} ZZZ helper app(s) hidden`);
  console.log('now run: npx abaplint  (expect 0 issues)');
}
