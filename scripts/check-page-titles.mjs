#!/usr/bin/env node
/*
 * check-page-titles — the opened sample names what its tile names.
 *
 * AGENTS.md section 12: the page title of a sample is
 *
 *     `abap2UI5 - <DESCRIPT without its (A) / (C) / (A,C) marker>`
 *
 * A user clicks a tile in the overview (which shows the DESCRIPT) and the
 * sample that opens must say the same thing, so it is recognisably the one
 * they clicked. The rule was prose only, and the two had drifted apart before
 * ("Focus II", "Table Filters Reset after view Update"): renaming a DESCRIPT
 * fails nothing else.
 *
 * What is read: the first `Page` the class builds after the main view's
 * `Shell` - section 12 requires every main view to open `mvc:View` -> `Shell`
 * -> `Page`, and that page is the one the user sees first. It is found in
 * source order, so it may sit in the same chain as the Shell, hang off a
 * variable holding it, or be the first page of a NavContainer directly in the
 * Shell (Z2UI5_CL_SMP_APP_499). Every other title is the sample's own business
 * and is not judged: a `Dialog` (a popup carries its own title), a further
 * NavContainer page, a FlexibleColumnLayout column, a nested view's page. A
 * class that builds two main views (one per branch) is held to it for both.
 *
 * The title must be a plain backtick literal, written with `v =` or `t =`:
 * a title computed at run time cannot be compared, and a sample has no
 * reason to compute it.
 *
 * Who is held to it: every tile (scanSamples). Not the overview app - its
 * title is `abap2UI5 - Samples` (section 3) - and not the ZZZ helpers, which
 * have no tile and therefore no DESCRIPT a user ever reads.
 *
 *   node scripts/check-page-titles.mjs      (npm run check:titles)
 */
import fs from 'fs';
import path from 'path';
import { ROOT, scanSamples } from './lib/scan-samples.mjs';

/* the marker check-markers.mjs reads - here only to strip it */
const MARKER = /\s\([AC](?:\s*,\s*[AC])*\)\s*$/i;

/* Source without comments: `*` in column 1, `"` outside a literal. */
function stripComments(source) {
  return source.split('\n').map((line) => {
    if (line.startsWith('*')) return '';
    let quote = null;
    for (let i = 0; i < line.length; i += 1) {
      const c = line[i];
      if (quote) {
        if (c === quote) quote = null;
        continue;
      }
      if (c === '"') return line.slice(0, i);
      if (c === '`' || c === "'" || c === '|') quote = c;
    }
    return line;
  }).join('\n');
}

/* The `Shell` of a main view, and the first `Page` built after it - in the
 * same chain or from a variable holding the Shell or a container inside it. */
const SHELL = /(?:ele|tag)\(\s*(?:n\s*=\s*)?`Shell`/g;
const PAGE = /(?:ele|tag)\(\s*(?:n\s*=\s*)?`Page`/;
/* One attribute call right after it; the Page's attributes are a run of these. */
const ATTRIBUTE = /^\s*\)?\s*->\s*a\(\s*n\s*=\s*`([^`]*)`\s+([vtb])\s*=\s*/;

/** The title value written after one Shell -> Page, or null when it has none. */
function pageTitle(code, from) {
  let rest = code.slice(from);
  for (;;) {
    const m = ATTRIBUTE.exec(rest);
    if (!m) return null;
    rest = rest.slice(m[0].length);
    const literal = /^`([^`]*)`/.exec(rest);
    if (m[1] === 'title') {
      return literal ? { literal: literal[1] } : { computed: rest.split('\n')[0].trim() };
    }
    // skip this attribute's value up to the start of the next call
    const next = rest.search(/\n\s*\)\s*->/);
    if (next === -1) return null;
    rest = rest.slice(next);
  }
}

const { tiles } = scanSamples();
const problems = [];
let pages = 0;

for (const tile of tiles) {
  const rel = `${tile.path}/${tile.app}.clas.abap`;
  const descript = (tile.sub ? `${tile.header} - ${tile.sub}` : tile.header).replace(MARKER, '');
  const want = `abap2UI5 - ${descript}`;
  const code = stripComments(fs.readFileSync(path.join(ROOT, rel), 'utf8'));

  const shells = [...code.matchAll(SHELL)];
  if (!shells.length) {
    problems.push(`${rel}: no Shell -> Page main view found (section 12), so its title cannot be checked`);
    continue;
  }
  for (const shell of shells) {
    const after = shell.index + shell[0].length;
    const m = PAGE.exec(code.slice(after));
    if (!m) {
      problems.push(`${rel}: a Shell without a Page after it (section 12), so its title cannot be checked`);
      continue;
    }
    pages += 1;
    const at = after + m.index;
    const line = code.slice(0, at).split('\n').length;
    const title = pageTitle(code, at + m[0].length);
    if (!title) {
      problems.push(`${rel}:${line}: the Shell -> Page carries no title - want \`${want}\``);
    } else if (title.computed !== undefined) {
      problems.push(`${rel}:${line}: the page title is computed (${title.computed}) - want the literal \`${want}\``);
    } else if (title.literal !== want) {
      problems.push(`${rel}:${line}: page title \`${title.literal}\` - the DESCRIPT says \`${want}\``);
    }
  }
}

console.log(`check-page-titles: ${tiles.length} tile(s), ${pages} Shell -> Page title(s) read`);

if (problems.length) {
  console.error(`\n${problems.length} problem(s):`);
  for (const p of problems) console.error(`  ${p}`);
  console.error(
    '\nSee AGENTS.md section 12: the page title is `abap2UI5 - ` + the DESCRIPT without its marker. '
    + 'Change the title and the DESCRIPT together (and regenerate with npm run launchpad when the DESCRIPT moves).',
  );
  process.exit(1);
}
console.log('every page title names its DESCRIPT - OK');
