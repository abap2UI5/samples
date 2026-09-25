#!/usr/bin/env node
/*
 * check-orphan-samples — a sample that is in the tree but in no catalogue.
 *
 * Every other gate here counts TILES: check-keywords holds each one to a
 * `@keywords` and a `@summary` line, generate-launchpad refuses a category no
 * learning-path stage names, generate-samples-md and generate-catalogue fail
 * when their output is stale. All of them read scanSamples( ), and scanSamples
 * only ever returns what it could place — so a sample the scan cannot place is
 * invisible to the lot of them, and a green `npm run check` says nothing about
 * it.
 *
 * That is not hypothetical. `Z2UI5_CL_SMP_APP_004` and thirteen others were
 * moved out of the experimental package and landed one level too high (#843,
 * and the two hand-made commits before it), in a folder no catalogue read. For
 * two commits the repository shipped fourteen samples that appeared in neither
 * the overview app nor SAMPLES.md — among them the only demonstrations of
 * app_state_set_active, hash_back, _bind_path, omit_initial, check_arg_literal
 * and t_model_skipped, and Basics IV, which left the learning path reading
 * I, II, III, V, VI. Thirteen gates stayed green the whole time.
 *
 * This is the gate for the other direction: not "is every tile complete" but
 * "is every sample a tile". `src/` is flat since 2026-09-22, so the rule is as
 * short as the tree: a class whose name says sample (`z2ui5_cl_smp_app_*`) has
 * to sit directly in `src/`, with its `.clas.xml` sidecar beside it - the
 * DESCRIPT in there is where every catalogue takes the title from, so a class
 * without one has no tile either - or it is refused here.
 *
 * WHAT IS DELIBERATELY NOT AN ORPHAN:
 *
 *   - the overview app (`z2ui5_cl_smp_app_000`). It sits in `src/` with the
 *     samples and is an index, not a sample; scanSamples drops it by name
 *     before the placement check, so it never reaches the orphan list.
 *   - a ZZZ helper app. It is in `src/`, gets no tile by its own rule, and
 *     scanSamples returns it under `hidden` — accounted for, not lost.
 *
 * The distinction this gate draws is therefore not "has a tile" but "was
 * SEEN". Being skipped by a rule is fine; being skipped by an accident of
 * where the file sits is not.
 *
 * Run: node scripts/check-orphan-samples.mjs  (npm run check:orphans)
 */
import { scanSamples } from './lib/scan-samples.mjs';

const { tiles, hidden, orphans } = scanSamples();

if (orphans.length > 0) {
  const n = orphans.length;
  console.error(
    `${n} sample class${n === 1 ? '' : 'es'} in the tree that no catalogue can reach:\n`,
  );
  for (const o of orphans) console.error(`  ${o.path}\n    ${o.why}`);
  console.error(
    '\nA class named z2ui5_cl_smp_app_* has to live directly in src/, the one '
    + 'flat\nsample package (AGENTS.md section 1), with its .clas.xml sidecar '
    + 'beside it.\nAs it is now it is in no overview app and in no SAMPLES.md '
    + 'row, and every\nother gate here passes it without looking: they all count '
    + 'tiles, and it is not one.'
    + '\n\nMove it into src/ (or add the sidecar), then run `npm run launchpad` '
    + 'and commit the result.',
  );
  process.exit(1);
}

console.log(
  `check-orphans: ${tiles.length + hidden.length} sample class(es) scanned in src/, `
  + `every one of them reachable by a catalogue (${hidden.length} ZZZ helper(s) `
  + 'accounted for) - OK',
);
