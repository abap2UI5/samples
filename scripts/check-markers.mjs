#!/usr/bin/env node
/*
 * check-markers — the capability marker on a title says what the code does.
 *
 * A DESCRIPT may end in `(A)`, `(C)` or `(A,C)` (AGENTS.md section 12), and
 * the marker travels into every view of the catalogue: the overview app,
 * SAMPLES.md and catalogue.json, each with the legend of lib/markers.mjs
 * beside it. Somebody looking for "a sample that drives the frontend" filters
 * on it. Nothing derived it from the code, so it drifted both ways: a sample
 * that only sets an option on an ordinary `_event( )` carried `(A)`, and
 * seven samples that call follow_up_action( ) had none until they were
 * marked by hand.
 *
 * The definitions are section 12's, encoded here - change them in both places:
 *
 *   (A)  the class performs a FRONTEND ACTION:
 *          - client->follow_up_action( ... ) - this covers every cs_event-*
 *            the framework executes in the browser, including the control
 *            events control_by_id / control_global / binding_call, which are
 *            only ever passed to it;
 *          - client->_event_client( ... ), the deprecated spelling of the same;
 *          - a client-side interaction such as drag and drop: a control of
 *            the `dnd` namespace (`ns = \`dnd\``, `<dnd:`) or the
 *            `dragDropConfig` aggregation.
 *        NOT the back button (`client->_event_nav_app_leave( )`), and NOT an
 *        option on an ordinary roundtrip `_event( )` (`s_ctrl`, e.g.
 *        check_prevent_default): that event still goes to the backend and
 *        nothing else.
 *   (C)  the class uses an abap2UI5 CUSTOM CONTROL: an element of the
 *        `z2ui5` namespace (`ns = \`z2ui5\``, `<z2ui5:`) or the declaration
 *        of that namespace (`xmlns:z2ui5`, which maps it to `z2ui5.cc`).
 *
 * Both directions are refused: a marker the code does not back, and code
 * that needs a marker the title lacks. Comments are stripped before the code
 * is read, so a comment that MENTIONS follow_up_action( ) does not count; a
 * method call is looked for outside string literals too (an intro text may
 * name one), a namespace inside them, because a builder call writes it as one.
 *
 * Who is held to it: every tile (scanSamples). Not the overview app - it
 * is an index, not a sample, and carries no marker - and not the ZZZ helpers,
 * which have no title anybody reads.
 *
 *   node scripts/check-markers.mjs      (npm run check:markers)
 */
import fs from 'fs';
import path from 'path';
import { ROOT, scanSamples } from './lib/scan-samples.mjs';
import { MARKERS } from './lib/markers.mjs';

/**
 * ABAP source without comments (`*` in column 1, `"` outside a literal), in
 * two readings: `code` keeps the literals - a builder call writes its
 * namespace as one, `ns = \`dnd\`` - and `calls` blanks them too, so a
 * MessageStrip text that NAMES follow_up_action( ) is not taken for a call.
 */
function readCode(source) {
  const code = [];
  const calls = [];
  for (const line of source.split('\n')) {
    if (line.startsWith('*')) continue;
    let quote = null; // the delimiter of the literal we are in: ` ' |
    let depth = 0; // embedded expressions of a | template |
    let end = line.length;
    let bare = '';
    for (let i = 0; i < line.length; i += 1) {
      const c = line[i];
      if (quote === '|' && depth === 0) {
        if (c === '\\') { i += 1; continue; }
        if (c === '{') { depth = 1; bare += c; } else if (c === '|') { quote = null; bare += c; }
        continue;
      }
      if (quote && quote !== '|') {
        if (c === quote) {
          if (line[i + 1] === quote) { i += 1; continue; } // doubled = escaped
          quote = null;
          bare += c;
        }
        continue;
      }
      // code - or an embedded expression of a template, which is code too
      if (quote === '|') {
        if (c === '{') depth += 1;
        else if (c === '}') depth -= 1;
        bare += c;
        continue;
      }
      if (c === '"') { end = i; break; }
      if (c === '`' || c === "'" || c === '|') quote = c;
      bare += c;
    }
    code.push(line.slice(0, end));
    calls.push(bare);
  }
  return { code: code.join('\n'), calls: calls.join('\n') };
}

/* [ pattern, which reading it is matched in, what it means ] */
const ACTION = [
  [/\bfollow_up_action\s*\(/i, 'calls', 'calls follow_up_action( )'],
  [/\b_event_client\s*\(/i, 'calls', 'calls _event_client( )'],
  [/\bns\s*=\s*[`']dnd[`']|<dnd:/i, 'code', 'builds a drag-and-drop control (dnd namespace)'],
  [/[`']dragDropConfig[`']|<dragDropConfig\b/i, 'code', 'builds a dragDropConfig aggregation'],
];
const CUSTOM = [
  [/\bns\s*=\s*[`']z2ui5[`']|<z2ui5:/i, 'code', 'builds an element of the z2ui5 namespace'],
  [/xmlns:z2ui5\b/i, 'code', 'declares the z2ui5 custom-control namespace'],
];

const evidence = (read, rules) => rules.filter(([re, where]) => re.test(read[where])).map(([, , why]) => why);

/* `(A)`, `(C)`, `(A,C)` - and anything that LOOKS like one (`(C,A)`, `(a)`,
 * `(A, C)`), which is refused rather than read as "no marker". */
const MARKER = /\s\(([AC](?:\s*,\s*[AC])*)\)\s*$/i;

const { tiles } = scanSamples();
const problems = [];
const counts = { '(A)': 0, '(C)': 0, '(A,C)': 0 };

for (const tile of tiles) {
  const rel = `${tile.path}/${tile.app}.clas.abap`;
  const title = tile.sub ? `${tile.header} - ${tile.sub}` : tile.header;
  const m = MARKER.exec(title);
  const marker = m ? `(${m[1]})` : '';
  if (marker && !(marker in MARKERS)) {
    problems.push(`${rel}: DESCRIPT marker ${marker} is not one of ${Object.keys(MARKERS).join(' ')}`);
    continue;
  }
  if (marker) counts[marker] += 1;

  const read = readCode(fs.readFileSync(path.join(ROOT, rel), 'utf8'));
  const action = evidence(read, ACTION);
  const custom = evidence(read, CUSTOM);
  const want = action.length && custom.length ? '(A,C)' : action.length ? '(A)' : custom.length ? '(C)' : '';

  if (marker !== want) {
    const why = [...action, ...custom];
    problems.push(
      `${rel}: "${title}" carries ${marker || 'no marker'}, the code says ${want || 'none'}`
      + (why.length ? ` (${why.join('; ')})` : ' (no frontend action, no custom control)'),
    );
  }
}

console.log(
  `check-markers: ${tiles.length} tile(s) read; `
  + Object.entries(counts).map(([k, n]) => `${n} ${k}`).join(', '),
);

if (problems.length) {
  console.error(`\n${problems.length} problem(s):`);
  for (const p of problems) console.error(`  ${p}`);
  console.error(
    '\nSee AGENTS.md section 12. Fix the DESCRIPT in the .clas.xml (or the code), '
    + 'then regenerate the catalogues: npm run launchpad.',
  );
  process.exit(1);
}
console.log('every capability marker matches the code - OK');
