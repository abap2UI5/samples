#!/usr/bin/env node
/*
 * check-atc — two findings a sample can ship that no gate here could see.
 *
 * Both come from the same place: abaplint models neither, so a sample passes
 * every gate in this repository and the problem surfaces on the system
 * somebody installed it on. That is worse than a missing sample - it is the
 * code they copied because it was published as the way to do the thing.
 *
 * 1. NOWHERE - a `SELECT` with no `WHERE` clause.
 *
 *    The extended program check (SLIN / ATC) runs in those systems and
 *    nowhere here; it wants the pseudo-comment `"#EC CI_NOWHERE` on the
 *    statement. The framework's own z2ui5_cl_ui5_srv_draft=>count_entries_total
 *    is the precedent - it reads the whole draft table on purpose and says so.
 *    Twenty-one statements here read a small demo table with no WHERE, which is
 *    exactly what they demonstrate; none said so until 2026-09-16.
 *
 * 2. SUBRC_AFTER_ASSIGN - `sy-subrc` read after a plain dynamic `ASSIGN`.
 *
 *    On some releases a SUCCESSFUL assign does not reset `sy-subrc`, so the
 *    test reads FALSE for an assignment that worked and TRUE for one that did
 *    not (abap2UI5 #1937). `IS [NOT] ASSIGNED` is the check that holds on all
 *    of them - and inside a LOOP, `UNASSIGN <fs>.` has to come FIRST, because
 *    a failed assign leaves the previous round's binding in place and
 *    `IS ASSIGNED` would then read TRUE for the failure. Fourteen of these
 *    shipped here, among them the sub-app view handover (`MV_VIEW_DISPLAY`,
 *    `VIEW_PARENT`) - and app_502's node builder, which assigns inside a
 *    `DO`, where a stale binding builds onto the wrong node.
 *
 *    `ASSIGN COMPONENT … OF STRUCTURE` is the NEGATIVE and must never be
 *    reported: there `sy-subrc` distinguishes "component not found" and IS
 *    the documented check. Reporting it is how a cleanup turns a
 *    wrong-branch bug into a silently-taken one.
 *
 * The scan reads ABAP STATEMENTS, not lines - a multi-line `ASSIGN COMPONENT`
 * looks like a plain `ASSIGN` to a line-based scan, which would report the one
 * shape that must not be reported.
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

/* The code half of a line: the trailing `"` comment cut off, outside string
 * literals so a `"` in a `'…'` or `|…|` stays text. */
function code(line) {
  let quote = null;
  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (quote) {
      if (ch === quote) quote = null;
      continue;
    }
    if (ch === "'" || ch === '|') quote = ch;
    else if (ch === '"') return line.slice(0, i);
  }
  return line;
}

/* Statements, with the line they start on and their raw text (the raw half
 * keeps the pseudo-comments rule 1 decides on). */
function statements(source) {
  const out = [];
  let raw = [];
  let start = 0;
  source.split(/\r?\n/).forEach((line, i) => {
    if (/^\s*\*/.test(line)) return;
    const c = code(line);
    if (raw.length === 0) {
      if (c.trim() === '') return;
      start = i + 1;
    }
    raw.push(line);
    if (c.trimEnd().endsWith('.') || c.trimEnd().endsWith(':')) {
      out.push({ start, raw: raw.join('\n'), code: raw.map(code).join(' ').replace(/\s+/g, ' ').trim() });
      raw = [];
    }
  });
  if (raw.length > 0) out.push({ start, raw: raw.join('\n'), code: raw.map(code).join(' ').replace(/\s+/g, ' ').trim() });
  return out;
}

/* Statements that write sy-subrc and so end an ASSIGN's claim on it.
 * Deliberately short and deliberately over-broad: one missing from the list
 * makes the scan report MORE, which a reader catches, rather than less. */
const SETS_SUBRC =
  /^(read\s+table|select|loop\s+at|find|replace|call\s+function|call\s+method|delete|insert|modify|append|split|open\s+dataset|authority-check|import|export|describe|search|get\s+parameter|set\s+parameter)\b/i;

const findings = [];

for (const rel of abapFiles('src')) {
  let claim = null;
  for (const st of statements(readFileSync(join(ROOT, rel), 'utf8'))) {
    const { code: c, raw, start } = st;

    if (/^SELECT\b/i.test(c) && !/\bWHERE\b/i.test(c) && !/#EC\s+CI_NOWHERE/i.test(raw)) {
      findings.push({
        rule: 'nowhere',
        at: `${rel}:${start}`,
        message: 'SELECT without a WHERE clause - the extended check wants "#EC CI_NOWHERE on the statement',
      });
    }

    if (/^ASSIGN\b/i.test(c)) {
      claim = /^ASSIGN\s+COMPONENT\b/i.test(c) ? 'component' : 'plain';
      continue;
    }
    if (/\bsy-subrc\b/i.test(c)) {
      if (claim === 'plain') {
        findings.push({
          rule: 'subrc_after_assign',
          at: `${rel}:${start}`,
          message: `${c.slice(0, 70)} - a successful dynamic ASSIGN does not reset sy-subrc on every release (#1937); use IS [NOT] ASSIGNED`,
        });
      }
      claim = null;
      continue;
    }
    if (SETS_SUBRC.test(c) || /\bEXCEPTIONS\b/i.test(c)) claim = null;
    if (/^(METHOD|ENDMETHOD|FORM|ENDFORM)\b/i.test(c)) claim = null;
  }
}

if (findings.length > 0) {
  console.error('check-atc: these fire on the system a sample is installed on.\n');
  for (const f of findings) console.error(`  [${f.rule}] ${f.at}\n      ${f.message}`);
  console.error(
    '\nnowhere            - a full read on purpose says so, on the first line of the\n' +
    '                     statement; see any annotated SELECT under src/.\n' +
    'subrc_after_assign - IS [NOT] ASSIGNED, and `UNASSIGN <fs>.` BEFORE the ASSIGN\n' +
    '                     when it sits in a loop or the symbol was assigned earlier.\n' +
    '                     ASSIGN COMPONENT is not this finding and is never reported.',
  );
  process.exit(1);
}

console.log('check-atc: no SELECT without a WHERE, no sy-subrc after a dynamic ASSIGN - OK');
