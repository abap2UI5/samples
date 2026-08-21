#!/usr/bin/env node
/*
 * generate-screenshots - a thumbnail per sample for the overview page.
 *
 * The page in web/ describes every sample with a title and a sentence; what a
 * sample looks like was only ever visible after clicking through to the
 * playground. The abap2UI5-linter can answer that without a system: its
 * render gate reconstructs the view from the z2ui5_cl_ui5_view_builder calls,
 * seeds it with a model derived from the class's own TYPES/DATA and renders
 * it in a headless browser - and `screenshotFiles` is that same harness kept
 * standing long enough to photograph it. So a thumbnail here is the render
 * gate's view of the sample, not a staged picture: what it shows is what the
 * gate checks.
 *
 * GENERATED AT DEPLOY, NEVER COMMITTED - the same decision as web/apps.json,
 * for the same reason: the deploy-web workflow writes web/thumbs/ fresh on
 * every deploy, so the pictures are never staler than the classes, and a
 * sample pull request carries no binary diff. The page treats a missing
 * picture as "no picture" (the <img> removes itself), so this script is
 * allowed to skip what it cannot photograph:
 *
 *   - a class whose view does not survive the headless render (a z2ui5.cc
 *     custom control the harness cannot load, for example) is reported and
 *     skipped - its card simply has no thumbnail;
 *   - only when NOTHING could be photographed does the run fail, because that
 *     is not a sample problem but a harness one (no browser, broken runtime),
 *     and a deploy that silently dropped every picture would look like a
 *     design change.
 *
 * Unlike the other scripts here this one needs the devDependencies - the
 * linter and @abap2ui5/render-runtime, the same pair `npm run check:abap2ui5`
 * already uses - plus the playwright chromium the render gate drives.
 *
 *   node scripts/generate-screenshots.mjs               write web/thumbs/
 *   node scripts/generate-screenshots.mjs --limit 5     a quick local smoke
 *   node scripts/generate-screenshots.mjs --out DIR     write elsewhere
 */
import fs from 'fs';
import path from 'path';
import { screenshotFiles } from '@abap2ui5/linter';
import { ROOT, scanSamples } from './lib/scan-samples.mjs';

const argOut = process.argv.indexOf('--out');
const OUT = argOut === -1
  ? path.join(ROOT, 'web', 'thumbs')
  : path.resolve(process.argv[argOut + 1]);
const argLimit = process.argv.indexOf('--limit');
const LIMIT = argLimit === -1 ? Infinity : Number(process.argv[argLimit + 1]);

/* The card thumbnail's viewport. 4:3 at a laptop-ish width, viewport only
 * (not the full page): the first screen is what a reader recognises a sample
 * by, and a full-page shot of a long table would shrink to an unreadable
 * strip. The CSS crops to the same ratio, so nothing is distorted. */
const SIZE = { width: 800, height: 600 };

/* One browser session per chunk. screenshotFiles renders every file it is
 * given in one session, so bigger chunks amortise the browser start - but a
 * whole corpus in one call holds every PNG in memory at once, and one crash
 * would take all pictures with it. */
const CHUNK = 25;

const tiles = scanSamples().areas['01'].slice(0, LIMIT);
fs.mkdirSync(OUT, { recursive: true });

let written = 0;
const skipped = [];
for (let i = 0; i < tiles.length; i += CHUNK) {
  const chunk = tiles.slice(i, i + CHUNK);
  const byFile = new Map(chunk.map((t) => [`${t.path}/${t.app}.clas.abap`, t]));
  const shots = await screenshotFiles([...byFile.keys()].map((f) => path.join(ROOT, f)), {
    ...SIZE,
    fullPage: false,
  });
  for (const shot of shots) {
    /* A class can build several documents - the main view first, then nested
     * views and popup fragments. The thumbnail is the main view; index 0 is
     * what the app opens with. */
    if (shot.index !== 0) continue;
    const tile = byFile.get(path.relative(ROOT, shot.file).split(path.sep).join('/'));
    if (!shot.png || shot.errors.length) {
      skipped.push(`${tile.app}: ${shot.errors[0] || 'no picture'}`);
      continue;
    }
    fs.writeFileSync(path.join(OUT, `${tile.app}.png`), shot.png);
    written++;
  }
}

for (const line of skipped) console.warn(`no thumbnail for ${line}`);
console.log(`${path.relative(ROOT, OUT)}: ${written} of ${tiles.length} samples photographed`
  + (skipped.length ? `, ${skipped.length} skipped (their cards show no picture)` : ''));

if (written === 0) {
  console.error('nothing could be photographed - that is a harness problem (browser, render runtime), not a sample one');
  process.exit(1);
}
