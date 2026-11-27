#!/usr/bin/env node
/*
 * Generates the overview app's catalog from the folder tree.
 * (This is the smp_app_000 index page. It has nothing to do with the Fiori
 * Launchpad - those demos live in abap2UI5/samples-stack, src/09.)
 *
 * Note: the app lists every sample in the repository - `src/` is flat since
 * 2026-09-22 and holds nothing else. SAMPLES.md renders the same list as
 * markdown (scripts/generate-samples-md.mjs); both read the same scan
 * (scripts/lib/scan-samples.mjs), so the app and the markdown can never
 * disagree about what this repository contains.
 *
 * Job (see AGENTS.md section 4): scan every demo app class under src/, derive
 * a tile from its abapGit <DESCRIPT> and its comment lines (that is
 * scan-samples.mjs), then rewrite the result = VALUE #( ... ) block of
 * get_catalog( ) in the overview app (smp_app_000):
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
import { ROOT, SRC, scanSamples } from './lib/scan-samples.mjs';
import { loadLearningPath } from './lib/learning-path.mjs';
import { unsearchable, unrecognisable, halfDone } from './lib/search-lines.mjs';
import { CHECK, writeOrCheck } from './lib/emit.mjs';
import { rewriteCatalog } from './lib/catalog-block.mjs';

/* `--check` renders exactly the same catalog and compares it instead of
 * writing it, so `npm run check` and the `catalogues` job of check-docs.yaml
 * can hold the catalog to the tree without rewriting the tree while they do
 * so. Same code path, one branch at the end (lib/emit.mjs): a check that
 * regenerated differently from the generator would be worse than none. */

// The one overview app, beside the samples it lists. A missing file is an
// error, not something to skip, because it means the catalog stops being
// generated.
const TARGET = path.join(SRC, 'z2ui5_cl_smp_app_000.clas.abap');

// --- 1. scan --------------------------------------------------------------
const { tiles, hidden } = scanSamples();

/* --- 1b. the learning path decides the groups ------------------------------
 * The scan groups a tile by the CTEXT of the package it lives in, which is
 * one package - the samples - so the app used to render every sample under no
 * heading at all, while SAMPLES.md and the catalogue page had six named
 * stages and 24 categories to read by. The stage is the group here: the
 * title the reader sees, in the teaching order, with the stage's blurb on the
 * first tile so the app can say what the group is for. The category stays
 * where it was, in the header - `Basics I`, `Table III` - which is what the
 * blocks inside a group are made of (block_base in the app). */
const fail = (message) => {
  console.error(`launchpad: ${message}`);
  process.exit(1);
};
{
  const list = tiles;
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
// lib/catalog-block.mjs: the rows, escaped and split under the line limit, and
// the splice into the method, ended by its ENDMETHOD rather than a text search
/* A TILE without `@keywords` is a tile nobody can find.
 *
 * DESCRIPT caps the short text at 60 characters, so it carries the name of the
 * thing and little else; `@keywords` is where the words a newcomer actually
 * types go ("f4 search help suggestion input"). Three readers use them - the
 * overview app's search box, `Ctrl+F` on SAMPLES.md, and an agent asking
 * whether a sample for X exists - and all three degrade the same silent way:
 * the sample is still listed, still correct, and simply never comes up.
 *
 * The ZZZ helpers are already out (scanSamples flags them): a helper is
 * reached BY another sample, never looked up, so search terms for it would be
 * words nobody will type. */
{
  const missing = unsearchable(tiles);
  if (missing.length) {
    console.error(`${missing.length} tile(s) carry no \` @keywords\` line, so nothing can find them:`);
    for (const t of missing) console.error(`  ${t.app}  (${t.header})`);
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
{
  const missing = unrecognisable(tiles);
  if (missing.length) {
    console.error(`${missing.length} tile(s) carry no \` @summary\` line, so nothing says what they show:`);
    for (const t of missing) console.error(`  ${t.app}  (${t.header})`);
    console.error('\nAdd it under the @keywords line (AGENTS.md section 4, tile schema):');
    console.error('  " @summary <one sentence: what this sample SHOWS, not which controls it uses>');
    process.exit(1);
  }
}

/* The two lines travel together. A class with one line and not the other is
 * the state nobody chose: it means an author added a sample the way the last
 * one looked and stopped halfway. (The ZZZ helpers are out of this by
 * construction - `scanSamples` flags them, and a helper is reached BY a
 * sample, never looked up.) */
const half = halfDone(tiles);
if (half.length) {
  console.error(`${half.length} sample(s) carry one search line but not the other:`);
  for (const t of half) {
    console.error(`  ${t.app}  (${t.header}) — has ${t.keywords ? '@keywords, no @summary' : '@summary, no @keywords'}`);
  }
  console.error('\nBoth or neither: they answer the two halves of one question.');
  process.exit(1);
}

const next = rewriteCatalog(fs.readFileSync(TARGET, 'utf8'), tiles, TARGET);
const rel = path.relative(ROOT, TARGET);
console.log(`${rel}: ${tiles.length} tiles`);
const total = tiles.length;
writeOrCheck(TARGET, next, 'the overview catalog', {
  stale: [
    `the overview catalog no longer mirrors the folder tree:\n  ${rel}`,
    '\nRun `npm run launchpad` and commit the result (AGENTS.md section 4).',
  ],
  fresh: `launchpad: up to date — ${total} tile(s), ${hidden.length} ZZZ helper app(s) hidden`,
  wrote: `generated ${total} tiles, ${hidden.length} ZZZ helper app(s) hidden`,
});
if (!CHECK) console.log('now run: npx abaplint  (expect 0 issues)');
