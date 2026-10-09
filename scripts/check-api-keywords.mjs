#!/usr/bin/env node
/*
 * check-api-keywords — a sample is found by the abap2UI5 API it shows.
 *
 * `@keywords` is where a sample names "the abap2UI5 API it demonstrates"
 * (AGENTS.md section 4): the overview app's search box, Ctrl+F on SAMPLES.md
 * and an agent asking whether a sample for X exists all read that line, and
 * none of them reads the code. A sample that closes its dialog with
 * `cs_event-popup_close` and does not say so is invisible to somebody who
 * types `popup_close` - it stays listed, stays correct, and never comes up.
 * Twenty-seven tiles had that gap when this gate was written (2026-10-09).
 *
 * The rule, decided from the class alone:
 *
 *   1. every `cs_event-<name>` constant of the framework the code passes -
 *      `z2ui5_if_client=>cs_event-<name>` or `client->cs_event-<name>` -
 *      must stand as `<name>` among the keywords. A class's OWN `cs_event`
 *      constants (Z2UI5_CL_SMP_APP_496 has one) are not the framework's
 *      API and are not read;
 *   2. every call of a CURATED client method (API below) must stand as the
 *      method name among the keywords.
 *
 * The curated list holds the methods that are the feature whenever they are
 * called - opening a popup, a popover or a nested view, calling another app,
 * the URL hash and app state. Deliberately NOT on it, each for a measured
 * reason (2026-10-09), so the rule has no false positive on the tree:
 *
 *   - the lifecycle and plumbing every sample calls (`check_on_*`, `_bind`,
 *     `_event`, `get_event*`, `get`, `view_display`, `_event_nav_app_leave`,
 *     `check_app_prev_stack`) - a keyword on 140 classes finds nothing;
 *   - the feedback channels `message_box_display` (22 tiles) and
 *     `message_toast_display` (31): all but four and three of them only
 *     report an error or confirm a press, and requiring the name there would
 *     make a search for it list every sample that happens to say "saved". The
 *     `Message` samples, which are ABOUT them, name them already;
 *   - `follow_up_action` itself - rule 1 holds the constant it carries, which
 *     is the part a reader searches for;
 *   - the companions `popup_destroy`, `popover_destroy`, `nav_app_leave`,
 *     `get_app_prev`: they follow a `popup_display` / `popover_display` /
 *     `nav_app_call` the same class makes, and that one is held.
 *
 * A name is read from CODE only: comments are dropped and literal contents
 * blanked (check-app-patterns' readings), so a MessageStrip that NAMES
 * `cs_event-popup_close` is prose, not a use.
 *
 * Who is held to it: every tile (scanSamples). Not the overview app - an
 * index, whose keywords say what IT is for - and not the ZZZ helpers, which
 * are reached by another sample and never searched for.
 *
 *   node scripts/check-api-keywords.mjs      (npm run check:api-keywords)
 */
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { readings } from './check-app-patterns.mjs';
import { ROOT, scanSamples } from './lib/scan-samples.mjs';

/* The curated client methods - see the header for what is left out and why. */
const API = [
  'popup_display',
  'popover_display',
  'nest_view_display',
  'nest2_view_display',
  'nest_view_destroy',
  'nest2_view_destroy',
  'view_destroy',
  'nav_app_call',
  'hash_set',
  'hash_replace',
  'app_state_set_active',
  'app_state_get_href',
  'set_session_stateful',
  '_bind_path',
];

const lineAt = (source, offset) => source.slice(0, offset).split('\n').length;

/**
 * The API names a class uses and its keywords do not name.
 * @param {string} source   the .clas.abap
 * @param {string} keywords the @keywords line, space separated
 * @returns {{name: string, line: number}[]} one entry per missing name, at its first use
 */
function scan(source, keywords) {
  const named = new Set(keywords.toLowerCase().split(/\s+/).filter(Boolean));
  const { mask } = readings(source);
  const first = new Map();
  const note = (name, offset) => {
    const key = name.toLowerCase();
    if (!named.has(key) && !first.has(key)) first.set(key, lineAt(source, offset));
  };
  for (const m of mask.matchAll(/(?:\bz2ui5_if_client=>|\bclient->)\s*cs_event-(\w+)/gi)) note(m[1], m.index);
  for (const m of mask.matchAll(/->\s*(\w+)\s*\(/g)) {
    if (API.includes(m[1].toLowerCase())) note(m[1], m.index);
  }
  return [...first].map(([name, line]) => ({ name, line })).sort((a, b) => a.line - b.line);
}

export { API, scan };

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}

function main() {
  const { tiles } = scanSamples();
  const problems = [];
  for (const tile of tiles) {
    const rel = `${tile.path}/${tile.app}.clas.abap`;
    for (const f of scan(readFileSync(join(ROOT, rel), 'utf8'), tile.keywords)) {
      problems.push(`${rel}:${f.line}: uses ${f.name}, which no @keywords term names`);
    }
  }
  console.log(`check-api-keywords: ${tiles.length} tile(s) read, ${API.length} curated client methods plus every cs_event constant`);
  if (problems.length) {
    console.error(`\n${problems.length} problem(s):`);
    for (const p of problems) console.error(`  ${p}`);
    console.error(
      '\nAdd the name to the class\'s " @keywords line (AGENTS.md section 4), then regenerate '
      + 'the catalogues: npm run launchpad.',
    );
    process.exit(1);
  }
  console.log('every cs_event constant and curated client method a sample uses is in its @keywords - OK');
}
