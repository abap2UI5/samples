#!/usr/bin/env node
/*
 * check-keywords — every sample says what it is about, and says it first.
 *
 * Two plain `"` comments above the CLASS statement (AGENTS.md section 4):
 * `@keywords`, the words somebody would type who does not know the sample
 * exists, and `@summary`, the one sentence that tells them whether it is the
 * one they want. 104 classes here carry them.
 *
 * WHY A SEPARATE GATE, when generate-launchpad.mjs already refuses a tile
 * without the two lines. Three reasons, and they are the difference between a
 * rule and an enforced rule:
 *
 *  1. `npm run launchpad` REWRITES the tree, so it is not something `npm run
 *     check` can call and not something a pull request runs. The one workflow
 *     that does run it - publish-overview-apps - regenerates and PUSHES; a
 *     missing line surfaces there as a job that failed after the catalogue was
 *     already half rebuilt, which is a strange place to learn it.
 *  2. The generator only sees what becomes a TILE, which is src/01. The six
 *     experimental samples in src/00/97 have no tile and carry both lines
 *     anyway, because the cookbook links to them - and nothing checked that.
 *  3. It cannot check what it does not read: that the line is the FIRST line
 *     of the file, that the terms are lowercase, that there are enough of them
 *     to separate one sample from the next.
 *
 * WHO NEEDS A LINE is decided from the tree, not from a list somebody has to
 * maintain:
 *
 *   - every sample in `src/01` and `src/00/97`, plus the overview app itself;
 *   - NOT the `ZZZ` helper apps - a helper is reached BY a sample, never
 *     looked up, so search terms for it would be words nobody will type;
 *   - NOT `src/00/98`, the testing and scaffolding package. Those apps exist
 *     to be run by a check, not to be learned from (AGENTS.md section 1), and
 *     none of the three readers below is looking for them.
 *
 * WHY IT MATTERS: nothing about a missing line is broken. The sample compiles,
 * runs, and is listed. The only symptom is that nobody looking for it arrives,
 * and it is the same silent symptom in all three readers - the overview app's
 * search box, `Ctrl+F` over SAMPLES.md, and an agent asking through
 * abap2UI5/mcp-server whether a sample for X already exists.
 *
 * The convention is shared with abap2UI5/samples-stack, deliberately
 * unchanged, so one reader can read both repositories.
 *
 *   node scripts/check-keywords.mjs      (npm run check:keywords)
 */
import fs from 'fs';
import path from 'path';
import { ROOT, scanSamples } from './lib/scan-samples.mjs';

/* The overview app is not a tile and therefore not in the scan - but it is a
 * sample somebody starts, and the first thing anyone runs, so it is held to
 * the same two lines. */
const OVERVIEW = { path: 'src', app: 'z2ui5_cl_smp_app_000' };

/* The package whose apps are not demos: they are run by a check. */
const EXEMPT_SUBNUM = new Set(['98']);

/* Loose enough to survive reformatting, strict enough to mean it: the line has
 * to be FIRST. A keyword line further down is one a reader scrolls past and
 * one a scanner reading the head of a file would miss. */
const KEYWORDS = /^" @keywords (.+?)\r?$/;
const SUMMARY = /^" @summary (\S.*?)\r?$/;

/* Below three terms the line is not doing its job: two words are the class
 * header again, and the header is already searched. Four to eight is the
 * point. */
const MIN_TERMS = 3;

const { areas, hidden } = scanSamples();

const exemptHelpers = new Set(hidden.map((h) => h.app));
const required = [
  ...areas['01'],
  ...areas['00'].filter((t) => !EXEMPT_SUBNUM.has(t.subnum)),
]
  .filter((t) => !exemptHelpers.has(t.app));

const problems = [];
const terms = new Set();

for (const tile of [OVERVIEW, ...required]) {
  const rel = `${tile.path}/${tile.app}.clas.abap`;
  const lines = fs.readFileSync(path.join(ROOT, rel), 'utf8').split('\n');

  const m = KEYWORDS.exec(lines[0]);
  if (!m) {
    const later = lines.findIndex((l) => KEYWORDS.test(l));
    problems.push(
      later > 0
        ? `${rel}: the \`" @keywords\` line is on line ${later + 1}, not the first line`
        : `${rel}: no \`" @keywords\` line\n`
          + '    add one as the FIRST line: synonyms, the controls it builds, the API it shows',
    );
  } else {
    const words = m[1].trim().split(/\s+/);
    if (words.length < MIN_TERMS) {
      problems.push(`${rel}: only ${words.length} keyword(s) — ${MIN_TERMS} is the floor, four to eight is the point`);
    }
    for (const w of words) {
      if (w !== w.toLowerCase()) problems.push(`${rel}: \`${w}\` is not lowercase`);
      terms.add(w);
    }
  }

  /* @summary sits directly under it. It exists because DESCRIPT is capped at
   * 60 characters and stops after naming the thing ("Popup - change a popup
   * control from the backend"); without it a catalogue row is a title and
   * nothing else. */
  if (!lines.some((l) => SUMMARY.test(l))) {
    problems.push(`${rel}: no \`" @summary\` line — one sentence saying what the sample shows`);
  }
}

/* The two lines travel together, everywhere - including where there is no
 * tile. A class with one and not the other is the state nobody chose: an
 * author added a sample the way the last one looked and stopped halfway. */
for (const tile of [...Object.values(areas).flat(), ...hidden]) {
  if (Boolean(tile.keywords) === Boolean(tile.summary)) continue;
  problems.push(
    `${tile.path}/${tile.app}.clas.abap: has ${tile.keywords ? '@keywords and no @summary' : '@summary and no @keywords'}`
    + '\n    both or neither — they answer the two halves of one question',
  );
}

console.log(
  `check-keywords: ${required.length + 1} sample(s) hold to it, `
  + `${exemptHelpers.size} ZZZ helper(s) and `
  + `${areas['00'].filter((t) => EXEMPT_SUBNUM.has(t.subnum)).length} testing app(s) exempt; `
  + `${terms.size} distinct search terms`,
);

if (problems.length) {
  console.error(`\n${problems.length} problem(s):`);
  for (const p of problems) console.error(`  ${p}`);
  console.error('\nSee AGENTS.md section 4 — a sample nobody can find is a sample nobody has.');
  process.exit(1);
}
console.log('every sample says what it is about - OK');
