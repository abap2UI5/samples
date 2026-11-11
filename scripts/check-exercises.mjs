#!/usr/bin/env node
/*
 * check-exercises — scripts/lib/exercises.json, the playground's lesson
 * exercises, against the tree:
 *
 *   - exactly one exercise per sample of the learning path's first stage
 *     (catalogue.json, stage "start"), and none for any other class,
 *   - a task and a hint, both prose, and a check with at least one condition,
 *   - every pattern compiles,
 *   - the sample as committed does NOT already pass its source checks: an
 *     exercise solved before it starts teaches nothing. (The view checks need
 *     the abap2UI5 linter's rebuilt XML, which the playground has and this
 *     plain-node script does not, so they are compiled but not run here.)
 *
 *   node scripts/check-exercises.mjs        (from the repository root)
 */
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const { exercises } = JSON.parse(fs.readFileSync(path.join(root, 'scripts/lib/exercises.json'), 'utf8'));
const catalogue = JSON.parse(fs.readFileSync(path.join(root, 'catalogue.json'), 'utf8'));
const start = catalogue.samples.filter((s) => s.stage === 'start');
const problems = [];

for (const sample of start) {
  if (!exercises[sample.class]) problems.push(`${sample.class} (${sample.title}) is a Start-here lesson without an exercise`);
}
for (const [cls, exercise] of Object.entries(exercises)) {
  const sample = start.find((s) => s.class === cls);
  if (!sample) {
    problems.push(`${cls} has an exercise but is not a Start-here lesson in catalogue.json`);
    continue;
  }
  for (const field of ['task', 'hint']) {
    if (typeof exercise[field] !== 'string' || exercise[field].trim().length < 10) problems.push(`${cls}: ${field} is missing or too short`);
  }
  const check = exercise.check ?? {};
  const known = new Set(['view', 'source', 'sourceNot', 'tests']);
  for (const key of Object.keys(check)) if (!known.has(key)) problems.push(`${cls}: check.${key} is not a condition the playground knows`);
  const lists = ['view', 'source', 'sourceNot'].map((k) => [k, check[k] ?? []]);
  if (lists.every(([, l]) => l.length === 0) && !check.tests) problems.push(`${cls}: the check has no condition`);
  if (check.tests !== undefined && !(Number.isInteger(check.tests) && check.tests > 0)) problems.push(`${cls}: check.tests is a positive whole number`);
  const compiled = {};
  for (const [key, list] of lists) {
    if (!Array.isArray(list) || list.some((p) => typeof p !== 'string')) {
      problems.push(`${cls}: check.${key} is a list of patterns`);
      continue;
    }
    compiled[key] = [];
    for (const p of list) {
      try {
        compiled[key].push(new RegExp(p, 'i'));
      } catch (e) {
        problems.push(`${cls}: check.${key} pattern ${p} does not compile - ${e.message}`);
      }
    }
  }
  const dir = path.dirname(path.join(root, sample.file));
  const source = fs.readdirSync(dir)
    .filter((f) => f.startsWith(`${cls}.clas.`) && f.endsWith('.abap'))
    .map((f) => fs.readFileSync(path.join(dir, f), 'utf8'))
    .join('\n');
  const sourceDone = (compiled.source ?? []).every((r) => r.test(source)) && !(compiled.sourceNot ?? []).some((r) => r.test(source));
  const onlySource = (compiled.view ?? []).length === 0 && !check.tests;
  if (onlySource && sourceDone) problems.push(`${cls}: the sample as committed already passes its own exercise`);
}

if (problems.length) {
  console.error(`check-exercises: ${problems.length} problem(s)\n  ${problems.join('\n  ')}`);
  process.exit(1);
}
console.log(`check-exercises: ${Object.keys(exercises).length} exercises, one per Start-here lesson`);
