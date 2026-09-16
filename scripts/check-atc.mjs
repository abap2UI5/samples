#!/usr/bin/env node
/*
 * check-atc — the extended program check (SLIN / ATC) runs in the systems the
 * samples are INSTALLED on, and nowhere here.
 *
 * abaplint does not model it, so a sample can pass every gate in this
 * repository and still light up a customer's ATC run - and a sample that does
 * is worse than a missing sample: it is the code somebody copied because it
 * was published as the way to do the thing.
 *
 * ONE finding, the one this repository actually carried: a `SELECT` with no
 * `WHERE` clause. The check wants the pseudo-comment `"#EC CI_NOWHERE` on the
 * statement, and the framework's own
 * z2ui5_cl_ui5_srv_draft=>count_entries_total is the precedent - it reads the
 * whole draft table on purpose and says so. Twenty-one statements here read a
 * small demo table without a WHERE, which is exactly what they are
 * demonstrating; none of them said so, and they were annotated in one pass
 * (2026-09-16) by the same scan this gate runs.
 *
 * The scan is line-based on purpose. A SELECT runs from the keyword to the
 * first line that ENDS in a period, and a SELECT carries no string literal
 * that could hide one - so the two things a real statement splitter buys
 * (literals, embedded templates) buy nothing here, and a reader can see in
 * twenty lines what this decides.
 *
 * Run:  npm run check:atc
 */
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

const ROOT = new URL('..', import.meta.url).pathname;

function abapFiles(dir, out = []) {
  for (const entry of readdirSync(join(ROOT, dir), { withFileTypes: true })) {
    const rel = `${dir}/${entry.name}`;
    if (entry.isDirectory()) abapFiles(rel, out);
    else if (rel.endsWith('.abap')) out.push(rel);
  }
  return out;
}

/** The code half of a line: the trailing `"` comment cut off. */
const code = (line) => {
  const at = line.indexOf('"');
  return at === -1 ? line : line.slice(0, at);
};

const findings = [];

for (const rel of abapFiles('src')) {
  const lines = readFileSync(join(ROOT, rel), 'utf8').split(/\r?\n/);
  for (let i = 0; i < lines.length; i++) {
    if (/^\s*\*/.test(lines[i])) continue;
    if (!/^\s*SELECT\b/i.test(code(lines[i]))) continue;
    // collect the statement: to the first line whose CODE ends in a period
    const text = [];
    let j = i;
    for (; j < lines.length; j++) {
      text.push(lines[j]);
      if (code(lines[j]).trimEnd().endsWith('.')) break;
    }
    const whole = text.join('\n');
    i = j;
    if (/\bWHERE\b/i.test(whole.replace(/"[^\n]*/g, ''))) continue;
    if (/#EC\s+CI_NOWHERE/i.test(whole)) continue;
    findings.push(`${rel}:${i + 1 - (text.length - 1)}  SELECT without WHERE and without "#EC CI_NOWHERE`);
  }
}

if (findings.length > 0) {
  console.error('check-atc: the extended program check would report these.\n');
  for (const f of findings) console.error(`  ${f}`);
  console.error(
    '\nA sample that reads a whole table on purpose says so with the pseudo-comment,\n' +
    'on the first line of the statement - see any annotated SELECT under src/00/98.',
  );
  process.exit(1);
}

console.log(`check-atc: ${findings.length} finding(s) - every SELECT without a WHERE says so`);
