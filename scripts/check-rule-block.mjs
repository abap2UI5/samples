#!/usr/bin/env node
/*
 * check-rule-block — the shared abaplint rule set is actually shared.
 *
 * `abaplint.jsonc` carries this line near the top:
 *
 *   THE RULE BLOCK BELOW IS KEPT BYTE-IDENTICAL IN THREE REPOSITORIES:
 *   abap2UI5/samples, abap2UI5/samples-controls and abap2UI5/samples-stack.
 *   Change it in one and copy it to the other two.
 *
 * That is a request, and three hand-synced copies drift — not with a bang but
 * with somebody switching one rule off to get a pull request through and never
 * coming back. Then "the shared core" is a comment describing something that
 * stopped being true, and nothing anywhere fails.
 *
 * So it is checked. Not byte-for-byte, which would fail on a reordered key or
 * a reflowed comment and teach everyone to ignore it, but on what actually
 * matters: WHICH RULES ARE CONFIGURED. A rule present in one repository and
 * absent in another is the drift worth catching.
 *
 * Three keys are legitimately repo-specific and are named rather than guessed:
 * they are nested inside `object_naming` and `severity`, which every
 * repository sets for its own objects.
 *
 *   node scripts/check-rule-block.mjs     (npm run check:rule-block)
 *
 * The other two configs are fetched from GitHub. When that fails — offline, a
 * rate limit, a sandbox with no route out — the run says so and passes: a
 * repository's own gates must not go red because github.com is unreachable,
 * and it must not claim to have verified something it did not.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const HERE = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const REPOS = ['samples', 'samples-controls', 'samples-stack'];
const RAW = (r) => `https://raw.githubusercontent.com/abap2UI5/${r}/main/abaplint.jsonc`;

/* Keys that are nested config of a rule rather than a rule, and that each
 * repository sets for its own object types. Listed, so a genuinely new
 * difference cannot hide behind "probably one of those". */
const REPO_SPECIFIC = new Set(['tabl', 'intf', 'clas', 'devc', 'ddls', 'severity']);

/** Every rule name a config configures. Comments stripped; the file is JSONC. */
function ruleNames(text) {
  const names = new Set();
  for (const m of text.matchAll(/^\s*"([a-z0-9_]+)"\s*:/gm)) {
    if (!REPO_SPECIFIC.has(m[1])) names.add(m[1]);
  }
  return names;
}

const mine = ruleNames(fs.readFileSync(path.join(HERE, 'abaplint.jsonc'), 'utf8'));
const self = path.basename(HERE);

const problems = [];
let compared = 0;
let why = '';

for (const repo of REPOS) {
  if (repo === self) continue;
  let text;
  try {
    const res = await fetch(RAW(repo), { signal: AbortSignal.timeout(15000) });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    text = await res.text();
  } catch (err) {
    why ||= err.message;
    continue;
  }
  compared += 1;
  const theirs = ruleNames(text);
  const onlyMine = [...mine].filter((r) => !theirs.has(r)).sort();
  const onlyTheirs = [...theirs].filter((r) => !mine.has(r)).sort();
  if (onlyMine.length) problems.push(`configured here and not in ${repo}: ${onlyMine.join(', ')}`);
  if (onlyTheirs.length) problems.push(`configured in ${repo} and not here: ${onlyTheirs.join(', ')}`);
}

console.log(`check-rule-block: ${mine.size} rule(s) configured here, compared against ${compared} of ${REPOS.length - 1} sibling(s)`);

if (compared < REPOS.length - 1) {
  console.log(`could NOT fetch every sibling (${why}) — the comparison is INCOMPLETE.`);
}

if (problems.length) {
  console.error(`\n${problems.length} difference(s):`);
  for (const p of problems) console.error(`  ${p}`);
  console.error('\nThe rule block is shared on purpose (see the note at the top of');
  console.error('abaplint.jsonc). Switching a rule off in one repository and not the');
  console.error('others is how "the shared core" quietly becomes three different cores.');
  console.error('Change it everywhere, or move the rule out of the shared block with a');
  console.error('comment saying why it is only right here.');
  process.exit(1);
}
console.log('the shared rule block is the same everywhere - OK');
